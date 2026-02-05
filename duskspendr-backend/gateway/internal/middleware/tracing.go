// Package middleware provides HTTP middleware for the gateway
package middleware

import (
	"context"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// TraceKey context keys for tracing
type TraceKey string

const (
	// TraceIDKey is the context key for trace ID
	TraceIDKey TraceKey = "trace_id"
	// SpanIDKey is the context key for span ID
	SpanIDKey TraceKey = "span_id"
	// ParentSpanIDKey is the context key for parent span ID
	ParentSpanIDKey TraceKey = "parent_span_id"
)

// Trace header names (compatible with W3C Trace Context)
const (
	TraceIDHeader     = "X-Trace-ID"
	SpanIDHeader      = "X-Span-ID"
	ParentSpanHeader  = "X-Parent-Span-ID"
	W3CTraceParent    = "traceparent"
)

// TraceContext holds distributed tracing information
type TraceContext struct {
	TraceID      string
	SpanID       string
	ParentSpanID string
	StartTime    time.Time
	Service      string
	Operation    string
}

// Tracing returns middleware that adds distributed tracing
func Tracing(serviceName string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		// Extract or generate trace ID
		traceID := c.Get(TraceIDHeader)
		if traceID == "" {
			traceID = c.Get(W3CTraceParent)
		}
		if traceID == "" {
			traceID = generateTraceID()
		}

		// Extract parent span ID (current span becomes child)
		parentSpanID := c.Get(SpanIDHeader)

		// Generate new span ID for this request
		spanID := generateSpanID()

		// Create trace context
		traceCtx := &TraceContext{
			TraceID:      traceID,
			SpanID:       spanID,
			ParentSpanID: parentSpanID,
			StartTime:    time.Now(),
			Service:      serviceName,
			Operation:    c.Method() + " " + c.Path(),
		}

		// Store in context
		ctx := context.WithValue(c.Context(), TraceIDKey, traceID)
		ctx = context.WithValue(ctx, SpanIDKey, spanID)
		if parentSpanID != "" {
			ctx = context.WithValue(ctx, ParentSpanIDKey, parentSpanID)
		}
		c.SetUserContext(ctx)

		// Store trace context in locals for easy access
		c.Locals("trace", traceCtx)

		// Set response headers for trace propagation
		c.Set(TraceIDHeader, traceID)
		c.Set(SpanIDHeader, spanID)
		if parentSpanID != "" {
			c.Set(ParentSpanHeader, parentSpanID)
		}

		// Process request
		err := c.Next()

		// Calculate duration
		duration := time.Since(traceCtx.StartTime)

		// Add duration header
		c.Set("X-Response-Time", duration.String())

		return err
	}
}

// GetTraceContext retrieves trace context from Fiber context
func GetTraceContext(c *fiber.Ctx) *TraceContext {
	if trace, ok := c.Locals("trace").(*TraceContext); ok {
		return trace
	}
	return nil
}

// GetTraceID retrieves trace ID from context
func GetTraceID(ctx context.Context) string {
	if id, ok := ctx.Value(TraceIDKey).(string); ok {
		return id
	}
	return ""
}

// GetSpanID retrieves span ID from context
func GetSpanID(ctx context.Context) string {
	if id, ok := ctx.Value(SpanIDKey).(string); ok {
		return id
	}
	return ""
}

// generateTraceID generates a new trace ID (32 hex chars)
func generateTraceID() string {
	id := uuid.New()
	return id.String()
}

// generateSpanID generates a new span ID (16 hex chars)
func generateSpanID() string {
	id := uuid.New()
	// Use first 16 chars for span ID
	return id.String()[:18]
}

// PropagateTrace creates HTTP headers for trace propagation
func PropagateTrace(traceCtx *TraceContext) map[string]string {
	headers := make(map[string]string)
	
	if traceCtx == nil {
		return headers
	}

	headers[TraceIDHeader] = traceCtx.TraceID
	headers[SpanIDHeader] = traceCtx.SpanID
	if traceCtx.ParentSpanID != "" {
		headers[ParentSpanHeader] = traceCtx.ParentSpanID
	}

	return headers
}
