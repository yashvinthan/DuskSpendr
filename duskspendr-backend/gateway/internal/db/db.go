package db

import (
  "context"
  "errors"

  "github.com/jackc/pgx/v5/pgxpool"
)

func NewPool(ctx context.Context, url string) (*pgxpool.Pool, error) {
  if url == "" {
    return nil, errors.New("DATABASE_URL is required")
  }
  pool, err := pgxpool.New(ctx, url)
  if err != nil {
    return nil, err
  }
  if err := pool.Ping(ctx); err != nil {
    pool.Close()
    return nil, err
  }
  return pool, nil
}
