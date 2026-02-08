// Package main is the entry point for the DuskSpendr API Gateway
// Built with Go Fiber for high-performance request routing
package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/limiter"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"github.com/gofiber/fiber/v2/middleware/requestid"

	"duskspendr-gateway/internal/config"
	"duskspendr-gateway/internal/db"
	"duskspendr-gateway/internal/handlers"
	"duskspendr-gateway/internal/middleware"
	"duskspendr-gateway/internal/queue"
	"duskspendr-gateway/internal/services"
)

func main() {
	cfg := config.Load()
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Database connection pool
	pool, err := db.NewPool(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("Database connection failed: %v", err)
	}
	defer pool.Close()

	// Redis connection (for rate limiting and caching)
	redisClient, err := db.NewRedisClient(ctx, cfg.RedisURL)
	if err != nil {
		log.Printf("Redis connection failed (rate limiting disabled): %v", err)
	}

	// RabbitMQ connection (for async messaging)
	mqConn, err := queue.NewConnection(cfg.RabbitMQURL)
	if err != nil {
		log.Printf("RabbitMQ connection failed (async messaging disabled): %v", err)
	}
	defer func() {
		if mqConn != nil {
			mqConn.Close()
		}
	}()

	// Initialize services
	jwtService := services.NewJWTService(cfg.JWTSecret, cfg.JWTRefreshSecret)
	notificationService := services.NewNotificationService(mqConn)

	var smsSender services.SMSSender
	if cfg.TwilioAccountSID != "" && cfg.TwilioAuthToken != "" && cfg.TwilioFromNumber != "" {
		smsSender = services.NewTwilioSender(cfg.TwilioAccountSID, cfg.TwilioAuthToken, cfg.TwilioFromNumber)
	} else {
		smsSender = services.NewLogSender()
	}

	// Fiber app configuration
	app := fiber.New(fiber.Config{
		Prefork:               cfg.Env == "production",
		ServerHeader:          "DuskSpendr",
		StrictRouting:         true,
		CaseSensitive:         true,
		DisableStartupMessage: cfg.Env == "production",
		ErrorHandler:          handlers.GlobalErrorHandler,
		ReadTimeout:           10 * time.Second,
		WriteTimeout:          10 * time.Second,
		IdleTimeout:           120 * time.Second,
	})

	// Global middleware
	app.Use(recover.New())
	app.Use(requestid.New())
	app.Use(logger.New(logger.Config{
		Format:     "${time} | ${status} | ${latency} | ${ip} | ${method} | ${path} | ${error}\n",
		TimeFormat: "2006-01-02 15:04:05",
		TimeZone:   "UTC",
	}))
	app.Use(cors.New(cors.Config{
		AllowOrigins:     cfg.AllowedOrigins,
		AllowMethods:     "GET,POST,PUT,PATCH,DELETE,OPTIONS",
		AllowHeaders:     "Origin, Content-Type, Accept, Authorization, X-Request-ID",
		AllowCredentials: true,
		MaxAge:           86400,
	}))

	// Rate limiting (if Redis available)
	if redisClient != nil {
		app.Use(limiter.New(limiter.Config{
			Max:               100,
			Expiration:        1 * time.Minute,
			LimiterMiddleware: limiter.SlidingWindow{},
			KeyGenerator: func(c *fiber.Ctx) string {
				return c.IP()
			},
			LimitReached: func(c *fiber.Ctx) error {
				return c.Status(429).JSON(fiber.Map{
					"success": false,
					"error": fiber.Map{
						"code":    "RATE_LIMIT_EXCEEDED",
						"message": "Too many requests. Please try again later.",
					},
				})
			},
		}))
	}

	// Health check (unauthenticated)
	app.Get("/health", handlers.NewHealthHandler(pool, redisClient).Check)
	app.Get("/ready", handlers.NewHealthHandler(pool, redisClient).Ready)

	// API v1 routes
	v1 := app.Group("/api/v1")

	// Auth routes (mostly unauthenticated)
	authHandler := handlers.NewAuthHandler(pool, cfg, jwtService, smsSender)
	auth := v1.Group("/auth")
	auth.Post("/start", authHandler.Start)
	auth.Post("/verify", authHandler.Verify)
	auth.Post("/refresh", authHandler.Refresh)
	auth.Post("/logout", middleware.Auth(jwtService), authHandler.Logout)

	// Integration routes
	integrationsHandler := handlers.NewIntegrationsHandler(cfg)
	integrations := v1.Group("/integrations")
	integrations.Post("/upstox/token", integrationsHandler.UpstoxTokenExchange)

	// Protected routes - require JWT
	protected := v1.Group("", middleware.Auth(jwtService))

	// User routes
	userHandler := handlers.NewUserHandler(pool)
	users := protected.Group("/users")
	users.Get("/me", userHandler.GetProfile)
	users.Put("/me", userHandler.UpdateProfile)
	users.Get("/me/preferences", userHandler.GetPreferences)
	users.Put("/me/preferences", userHandler.UpdatePreferences)

	// Transaction routes
	txHandler := handlers.NewTransactionHandler(pool, mqConn)
	transactions := protected.Group("/transactions")
	transactions.Get("/", txHandler.List)
	transactions.Post("/", txHandler.Create)
	transactions.Get("/:id", txHandler.Get)
	transactions.Put("/:id", txHandler.Update)
	transactions.Delete("/:id", txHandler.Delete)
	transactions.Post("/sync", txHandler.Sync)

	// Budget routes
	budgetHandler := handlers.NewBudgetHandler(pool)
	budgets := protected.Group("/budgets")
	budgets.Get("/", budgetHandler.List)
	budgets.Post("/", budgetHandler.Create)
	budgets.Get("/:id", budgetHandler.Get)
	budgets.Put("/:id", budgetHandler.Update)
	budgets.Delete("/:id", budgetHandler.Delete)

	// Account linking routes
	accountHandler := handlers.NewAccountHandler(pool)
	accounts := protected.Group("/accounts")
	accounts.Get("/", accountHandler.List)
	accounts.Post("/link", accountHandler.Link)
	accounts.Delete("/:id", accountHandler.Unlink)
	accounts.Post("/:id/sync", accountHandler.Sync)

	// Analytics routes (proxy to Python service)
	analytics := protected.Group("/analytics")
	analytics.Get("/spending-summary", handlers.ProxyTo(cfg.AnalyticsServiceURL))
	analytics.Get("/trends", handlers.ProxyTo(cfg.AnalyticsServiceURL))
	analytics.Get("/insights", handlers.ProxyTo(cfg.AnalyticsServiceURL))

	// AI routes (proxy to Python service)
	ai := protected.Group("/ai")
	ai.Post("/categorize", handlers.ProxyTo(cfg.AIServiceURL))
	ai.Post("/insights", handlers.ProxyTo(cfg.AIServiceURL))
	ai.Post("/predict", handlers.ProxyTo(cfg.AIServiceURL))

	// Notification routes
	notifHandler := handlers.NewNotificationHandler(pool, notificationService)
	notifications := protected.Group("/notifications")
	notifications.Get("/", notifHandler.List)
	notifications.Put("/:id/read", notifHandler.MarkRead)
	notifications.Post("/subscribe", notifHandler.Subscribe)

	// Shared expenses routes
	splitHandler := handlers.NewSplitHandler(pool)
	splits := protected.Group("/splits")
	splits.Get("/", splitHandler.ListGroups)
	splits.Post("/", splitHandler.CreateGroup)
	splits.Get("/:groupId", splitHandler.GetGroup)
	splits.Post("/:groupId/expenses", splitHandler.AddExpense)
	splits.Get("/:groupId/balances", splitHandler.GetBalances)
	splits.Post("/:groupId/settle", splitHandler.SettleUp)

	// Data export routes
	exportHandler := handlers.NewExportHandler(pool)
	exports := protected.Group("/export")
	exports.Post("/request", exportHandler.Request)
	exports.Get("/status/:id", exportHandler.Status)
	exports.Get("/download/:id", exportHandler.Download)

	// Graceful shutdown
	go func() {
		if err := app.Listen(cfg.HTTPAddr); err != nil {
			log.Printf("Server error: %v", err)
		}
	}()

	log.Printf("🚀 DuskSpendr Gateway listening on %s", cfg.HTTPAddr)

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
	<-quit

	log.Println("Shutting down server...")
	if err := app.ShutdownWithTimeout(10 * time.Second); err != nil {
		log.Printf("Server shutdown error: %v", err)
	}
	log.Println("Server stopped")
}
