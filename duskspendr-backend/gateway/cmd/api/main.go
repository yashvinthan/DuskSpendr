package main

import (
  "context"
  "log"
  "net/http"
  "os"
  "os/signal"
  "syscall"
  "time"

  "duskspendr/gateway/internal/config"
  "duskspendr/gateway/internal/db"
  httpapi "duskspendr/gateway/internal/http"
  "duskspendr/gateway/internal/serverpod"
)

func main() {
  cfg := config.Load()
  ctx, cancel := context.WithCancel(context.Background())
  defer cancel()

  pool, err := db.NewPool(ctx, cfg.DatabaseURL)
  if err != nil {
    log.Fatalf("db init failed: %v", err)
  }
  defer pool.Close()

  serverpodClient := serverpod.New(cfg.ServerpodURL, cfg.SyncSharedSecret)
  srv := &http.Server{
    Addr:              cfg.HTTPAddr,
    Handler:           httpapi.NewServer(pool, serverpodClient, cfg),
    ReadHeaderTimeout: 5 * time.Second,
  }

  go func() {
    log.Printf("gateway listening on %s", cfg.HTTPAddr)
    if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
      log.Fatalf("server error: %v", err)
    }
  }()

  shutdown := make(chan os.Signal, 1)
  signal.Notify(shutdown, os.Interrupt, syscall.SIGTERM)
  <-shutdown

  ctxShutdown, cancelShutdown := context.WithTimeout(context.Background(), 10*time.Second)
  defer cancelShutdown()
  _ = srv.Shutdown(ctxShutdown)
  log.Println("gateway stopped")
}
