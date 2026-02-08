// Package handlers provides HTTP handlers for the gateway
package handlers

import (
	"context"
	"sync"
	"time"

	"github.com/gofiber/fiber/v2"

	"duskspendr-gateway/internal/db"
	"duskspendr-gateway/internal/queue"
)

// HealthHandler handles health check endpoints
type HealthHandler struct {
	redis     *db.RedisClient
	rabbitmq  *queue.Connection
	startTime time.Time
}

// HealthResponse represents the health check response
type HealthResponse struct {
	Status    string                 `json:"status"`
	Timestamp string                 `json:"timestamp"`
	Uptime    string                 `json:"uptime"`
	Services  map[string]HealthCheck `json:"services"`
}

// HealthCheck represents individual service health
type HealthCheck struct {
	Status  string `json:"status"`
	Latency string `json:"latency,omitempty"`
	Message string `json:"message,omitempty"`
}

// NewHealthHandler creates a new health handler
func NewHealthHandler(redis *db.RedisClient, rabbitmq *queue.Connection) *HealthHandler {
	return &HealthHandler{
		redis:     redis,
		rabbitmq:  rabbitmq,
		startTime: time.Now(),
	}
}

// Check performs a basic health check
func (h *HealthHandler) Check(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"status":    "ok",
		"timestamp": time.Now().UTC().Format(time.RFC3339),
	})
}

// Ready performs readiness check including dependencies
func (h *HealthHandler) Ready(c *fiber.Ctx) error {
	ctx, cancel := context.WithTimeout(c.Context(), 5*time.Second)
	defer cancel()

	services := make(map[string]HealthCheck)
	var wg sync.WaitGroup
	var mu sync.Mutex
	allHealthy := true

	// Check Redis
	wg.Add(1)
	go func() {
		defer wg.Done()
		check := h.checkRedis(ctx)
		mu.Lock()
		services["redis"] = check
		if check.Status != "healthy" {
			allHealthy = false
		}
		mu.Unlock()
	}()

	// Check RabbitMQ
	wg.Add(1)
	go func() {
		defer wg.Done()
		check := h.checkRabbitMQ()
		mu.Lock()
		services["rabbitmq"] = check
		if check.Status != "healthy" {
			allHealthy = false
		}
		mu.Unlock()
	}()

	wg.Wait()

	status := "ok"
	statusCode := fiber.StatusOK
	if !allHealthy {
		status = "degraded"
		statusCode = fiber.StatusServiceUnavailable
	}

	response := HealthResponse{
		Status:    status,
		Timestamp: time.Now().UTC().Format(time.RFC3339),
		Uptime:    time.Since(h.startTime).String(),
		Services:  services,
	}

	return c.Status(statusCode).JSON(response)
}

// Live performs liveness check (is the service running)
func (h *HealthHandler) Live(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"status":    "alive",
		"timestamp": time.Now().UTC().Format(time.RFC3339),
		"uptime":    time.Since(h.startTime).String(),
	})
}

// checkRedis checks Redis connectivity
func (h *HealthHandler) checkRedis(ctx context.Context) HealthCheck {
	if h.redis == nil {
		return HealthCheck{
			Status:  "unhealthy",
			Message: "redis client not configured",
		}
	}

	start := time.Now()
	err := h.redis.Ping(ctx)
	latency := time.Since(start)

	if err != nil {
		return HealthCheck{
			Status:  "unhealthy",
			Latency: latency.String(),
			Message: err.Error(),
		}
	}

	return HealthCheck{
		Status:  "healthy",
		Latency: latency.String(),
	}
}

// checkRabbitMQ checks RabbitMQ connectivity
func (h *HealthHandler) checkRabbitMQ() HealthCheck {
	if h.rabbitmq == nil {
		return HealthCheck{
			Status:  "unhealthy",
			Message: "rabbitmq connection not configured",
		}
	}

	// Check if channel is open
	ch := h.rabbitmq.Channel()
	if ch == nil || ch.IsClosed() {
		return HealthCheck{
			Status:  "unhealthy",
			Message: "rabbitmq channel is closed",
		}
	}

	return HealthCheck{
		Status: "healthy",
	}
}

// Metrics returns basic metrics
func (h *HealthHandler) Metrics(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"uptime_seconds": time.Since(h.startTime).Seconds(),
		"timestamp":      time.Now().UTC().Format(time.RFC3339),
	})
}
