package handlers

import (
  "net"
  "net/http"
  "sync"
  "time"

  "duskspendr/gateway/internal/config"
)

type tokenBucket struct {
  tokens float64
  last   time.Time
}

type rateLimiter struct {
  mu     sync.Mutex
  rate   float64
  burst  float64
  ttl    time.Duration
  buckets map[string]*tokenBucket
}

func newRateLimiter(ratePerMin int, burst int) *rateLimiter {
  ratePerSec := float64(ratePerMin) / 60.0
  return &rateLimiter{
    rate:   ratePerSec,
    burst:  float64(burst),
    ttl:    10 * time.Minute,
    buckets: make(map[string]*tokenBucket),
  }
}

func (l *rateLimiter) allow(key string) bool {
  if l.rate <= 0 || l.burst <= 0 {
    return true
  }

  now := time.Now()
  l.mu.Lock()
  defer l.mu.Unlock()

  b := l.buckets[key]
  if b == nil {
    b = &tokenBucket{tokens: l.burst, last: now}
    l.buckets[key] = b
  }

  elapsed := now.Sub(b.last).Seconds()
  b.tokens = minFloat(l.burst, b.tokens+(elapsed*l.rate))
  b.last = now

  if b.tokens < 1 {
    return false
  }

  b.tokens -= 1
  l.cleanupLocked(now)
  return true
}

func (l *rateLimiter) cleanupLocked(now time.Time) {
  for key, bucket := range l.buckets {
    if now.Sub(bucket.last) > l.ttl {
      delete(l.buckets, key)
    }
  }
}

func minFloat(a, b float64) float64 {
  if a < b {
    return a
  }
  return b
}

func SyncIngestRateLimit(cfg config.Config) func(http.Handler) http.Handler {
  userLimiter := newRateLimiter(cfg.SyncIngestRPM, cfg.SyncIngestBurst)
  ipLimiter := newRateLimiter(cfg.SyncIngestIPRPM, cfg.SyncIngestBurst)

  return func(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
      if userID, ok := UserIDFromContext(r.Context()); ok {
        if !userLimiter.allow(userID.String()) {
          writeError(w, http.StatusTooManyRequests, "sync rate limit exceeded")
          return
        }
      }

      if ip := clientIPFromRequest(r); ip != "" {
        if !ipLimiter.allow(ip) {
          writeError(w, http.StatusTooManyRequests, "sync rate limit exceeded")
          return
        }
      }

      next.ServeHTTP(w, r)
    })
  }
}

func clientIPFromRequest(r *http.Request) string {
  if r.RemoteAddr == "" {
    return ""
  }
  host, _, err := net.SplitHostPort(r.RemoteAddr)
  if err == nil {
    return host
  }
  return r.RemoteAddr
}
