// Package middleware provides HTTP middleware for the gateway
package middleware

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/gofiber/fiber/v2"

	"duskspendr/gateway/internal/db"
)

// RateLimiter provides rate limiting functionality
type RateLimiter struct {
	redis   *db.RedisClient
	max     int
	window  time.Duration
	keyFunc func(*fiber.Ctx) string
}

// RateLimiterConfig holds rate limiter configuration
type RateLimiterConfig struct {
	Max     int           // Maximum requests per window
	Window  time.Duration // Time window
	KeyFunc func(*fiber.Ctx) string // Function to generate rate limit key
}

// DefaultKeyFunc returns the client IP as the rate limit key
func DefaultKeyFunc(c *fiber.Ctx) string {
	return c.IP()
}

// UserKeyFunc returns user ID or IP as the rate limit key
func UserKeyFunc(c *fiber.Ctx) string {
	if userID := GetUserID(c); userID != "" {
		return "user:" + userID
	}
	return "ip:" + c.IP()
}

// NewRateLimiter creates a new rate limiter
func NewRateLimiter(redisClient *db.RedisClient, config RateLimiterConfig) *RateLimiter {
	if config.KeyFunc == nil {
		config.KeyFunc = DefaultKeyFunc
	}
	if config.Max <= 0 {
		config.Max = 100
	}
	if config.Window <= 0 {
		config.Window = time.Minute
	}

	return &RateLimiter{
		redis:   redisClient,
		max:     config.Max,
		window:  config.Window,
		keyFunc: config.KeyFunc,
	}
}

// Handler returns the rate limiting middleware
func (rl *RateLimiter) Handler() fiber.Handler {
	return func(c *fiber.Ctx) error {
		if rl.redis == nil {
			// Skip rate limiting if Redis is not available
			return c.Next()
		}

		ctx, cancel := context.WithTimeout(c.Context(), 2*time.Second)
		defer cancel()

		key := fmt.Sprintf("ratelimit:%s", rl.keyFunc(c))

		// Get current count
		count, err := rl.increment(ctx, key)
		if err != nil {
			// On error, allow the request but log
			return c.Next()
		}

		// Get remaining TTL
		ttl, _ := rl.redis.TTL(ctx, key)
		if ttl < 0 {
			ttl = rl.window
		}

		// Set rate limit headers
		c.Set("X-RateLimit-Limit", strconv.Itoa(rl.max))
		c.Set("X-RateLimit-Remaining", strconv.Itoa(max(0, rl.max-int(count))))
		c.Set("X-RateLimit-Reset", strconv.FormatInt(time.Now().Add(ttl).Unix(), 10))

		// Check if over limit
		if int(count) > rl.max {
			retryAfter := int(ttl.Seconds())
			c.Set("Retry-After", strconv.Itoa(retryAfter))
			
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
				"error":       "Rate limit exceeded",
				"retry_after": retryAfter,
				"limit":       rl.max,
				"window":      rl.window.String(),
			})
		}

		return c.Next()
	}
}

// increment increments the counter for the given key
func (rl *RateLimiter) increment(ctx context.Context, key string) (int64, error) {
	count, err := rl.redis.Incr(ctx, key)
	if err != nil {
		return 0, err
	}

	// Set expiry on first request
	if count == 1 {
		rl.redis.Expire(ctx, key, rl.window)
	}

	return count, nil
}

// RateLimit returns a simple rate limiting middleware using in-memory storage
// Use this when Redis is not available
func RateLimit(limit int, window time.Duration) fiber.Handler {
	// Simple in-memory rate limiter (not suitable for distributed systems)
	store := make(map[string]*rateLimitEntry)

	return func(c *fiber.Ctx) error {
		key := c.IP()
		now := time.Now()

		entry, exists := store[key]
		if !exists || now.After(entry.expiry) {
			store[key] = &rateLimitEntry{
				count:  1,
				expiry: now.Add(window),
			}
		} else {
			entry.count++
		}

		entry = store[key]
		remaining := max(0, limit-entry.count)

		// Set headers
		c.Set("X-RateLimit-Limit", strconv.Itoa(limit))
		c.Set("X-RateLimit-Remaining", strconv.Itoa(remaining))
		c.Set("X-RateLimit-Reset", strconv.FormatInt(entry.expiry.Unix(), 10))

		if entry.count > limit {
			retryAfter := int(time.Until(entry.expiry).Seconds())
			c.Set("Retry-After", strconv.Itoa(retryAfter))

			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
				"error":       "Rate limit exceeded",
				"retry_after": retryAfter,
			})
		}

		return c.Next()
	}
}

type rateLimitEntry struct {
	count  int
	expiry time.Time
}

// max returns the larger of two integers
func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

// RateLimitByEndpoint returns rate limiting with per-endpoint limits
func RateLimitByEndpoint(redisClient *db.RedisClient, limits map[string]RateLimiterConfig) fiber.Handler {
	limiters := make(map[string]*RateLimiter)
	
	for endpoint, config := range limits {
		limiters[endpoint] = NewRateLimiter(redisClient, config)
	}

	defaultLimiter := NewRateLimiter(redisClient, RateLimiterConfig{
		Max:    100,
		Window: time.Minute,
	})

	return func(c *fiber.Ctx) error {
		path := c.Path()
		
		// Check for exact match first
		if limiter, ok := limiters[path]; ok {
			return limiter.Handler()(c)
		}

		// Check for prefix match
		for endpoint, limiter := range limiters {
			if len(path) >= len(endpoint) && path[:len(endpoint)] == endpoint {
				return limiter.Handler()(c)
			}
		}

		// Use default limiter
		return defaultLimiter.Handler()(c)
	}
}
