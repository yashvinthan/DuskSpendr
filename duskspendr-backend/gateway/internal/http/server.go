package httpapi

import (
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/jackc/pgx/v5/pgxpool"

	"duskspendr-gateway/internal/config"
	"duskspendr-gateway/internal/handlers"
	mw "duskspendr-gateway/internal/middleware"
	"duskspendr-gateway/internal/serverpod"
)

func NewServer(pool *pgxpool.Pool, serverpodClient *serverpod.Client, cfg config.Config) http.Handler {
	r := chi.NewRouter()
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Recoverer)
	r.Use(middleware.Timeout(30 * time.Second))
	r.Use(middleware.RequestSize(1 << 20))
	r.Use(securityHeaders)
	r.Use(mw.APIVersioning(mw.DefaultVersionConfig()))

	r.Get("/health", handlers.Health)

	userHandler := &handlers.UserHandler{Pool: pool}
	authHandler := &handlers.AuthHandler{Pool: pool, Config: cfg}
	txHandler := &handlers.TransactionHandler{Pool: pool}
	accountHandler := &handlers.AccountHandler{Pool: pool}
	budgetHandler := &handlers.BudgetHandler{Pool: pool}
	serverpodHandler := &handlers.ServerpodHandler{Client: serverpodClient}
	syncHandler := &handlers.SyncHandler{Client: serverpodClient, Pool: pool}

  r.Route("/v1", func(v1 chi.Router) {
    v1.Post("/users", userHandler.Create)
    v1.Post("/auth/start", authHandler.Start)
    v1.Post("/auth/verify", authHandler.Verify)
    v1.Get("/serverpod/health", serverpodHandler.Health)

    v1.Group(func(auth chi.Router) {
      auth.Use(handlers.RequireUserID(pool))

      auth.Get("/transactions", txHandler.List)
      auth.Post("/transactions", txHandler.Create)
      auth.Get("/transactions/{id}", txHandler.Get)
      auth.Put("/transactions/{id}", txHandler.Update)
      auth.Delete("/transactions/{id}", txHandler.Delete)

      auth.Post("/sync/transactions", syncHandler.SyncTransactions)
      auth.With(handlers.SyncIngestRateLimit(cfg)).Post(
        "/sync/transactions/ingest",
        syncHandler.IngestTransactions,
      )

      auth.Get("/accounts", accountHandler.List)
      auth.Post("/accounts", accountHandler.Create)

      auth.Get("/budgets", budgetHandler.List)
      auth.Post("/budgets", budgetHandler.Create)
      auth.Put("/budgets/{id}", budgetHandler.Update)
    })
  })

  return r
}

func securityHeaders(next http.Handler) http.Handler {
  return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("X-Content-Type-Options", "nosniff")
    w.Header().Set("X-Frame-Options", "DENY")
    w.Header().Set("Referrer-Policy", "no-referrer")
    w.Header().Set("X-XSS-Protection", "0")
    next.ServeHTTP(w, r)
  })
}
