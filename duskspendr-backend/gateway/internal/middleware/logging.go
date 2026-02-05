// Package middleware provides HTTP middleware for the gateway
package middleware

import (
	"time"

	"github.com/gofiber/fiber/v2"
)

// RequestLogger returns middleware for structured request logging
func RequestLogger() fiber.Handler {
	return func(c *fiber.Ctx) error {
		start := time.Now()

		// Get trace context if available
		traceCtx := GetTraceContext(c)
		traceID := ""
		spanID := ""
		if traceCtx != nil {
			traceID = traceCtx.TraceID
			spanID = traceCtx.SpanID
		}

		// Process request
		err := c.Next()

		// Calculate duration
		duration := time.Since(start)

		// Log request (structured logging format)
		// In production, use structured logger like zerolog/zap
		logEntry := map[string]interface{}{
			"method":     c.Method(),
			"path":       c.Path(),
			"status":     c.Response().StatusCode(),
			"duration":   duration.String(),
			"duration_ms": duration.Milliseconds(),
			"ip":         c.IP(),
			"user_agent": c.Get("User-Agent"),
			"trace_id":   traceID,
			"span_id":    spanID,
		}

		// Get user ID if authenticated
		if userID := GetUserID(c); userID != "" {
			logEntry["user_id"] = userID
		}

		// Store for access by other handlers if needed
		c.Locals("log_entry", logEntry)

		return err
	}
}

// Recovery returns middleware for panic recovery
func Recovery() fiber.Handler {
	return func(c *fiber.Ctx) error {
		defer func() {
			if r := recover(); r != nil {
				traceCtx := GetTraceContext(c)
				traceID := ""
				if traceCtx != nil {
					traceID = traceCtx.TraceID
				}

				// Log panic
				_ = map[string]interface{}{
					"level":    "error",
					"error":    r,
					"trace_id": traceID,
					"path":     c.Path(),
					"method":   c.Method(),
				}

				// Return 500 error
				c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"error":    "Internal Server Error",
					"trace_id": traceID,
				})
			}
		}()

		return c.Next()
	}
}

// SecurityHeaders adds security headers to responses
func SecurityHeaders() fiber.Handler {
	return func(c *fiber.Ctx) error {
		// Security headers
		c.Set("X-Content-Type-Options", "nosniff")
		c.Set("X-Frame-Options", "DENY")
		c.Set("X-XSS-Protection", "1; mode=block")
		c.Set("Referrer-Policy", "strict-origin-when-cross-origin")
		c.Set("Content-Security-Policy", "default-src 'self'")

		// Remove server header
		c.Set("Server", "")

		return c.Next()
	}
}

// RequestID ensures every request has a unique ID
func RequestID() fiber.Handler {
	return func(c *fiber.Ctx) error {
		requestID := c.Get("X-Request-ID")
		if requestID == "" {
			requestID = generateSpanID()
		}
		c.Set("X-Request-ID", requestID)
		c.Locals("request_id", requestID)
		return c.Next()
	}
}
