# SS-200: Go API Gateway Setup

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-200 |
| **Epic** | Backend Infrastructure |
| **Type** | Infrastructure |
| **Priority** | P0 - Critical |
| **Story Points** | 8 |
| **Sprint** | Sprint 2 |
| **Assignee** | TBD |
| **Labels** | `backend`, `go`, `fiber`, `api-gateway`, `infrastructure` |

---

## User Story

**As a** DuskSpendr backend developer  
**I want** a high-performance API Gateway  
**So that** all client requests are authenticated, routed, and rate-limited efficiently

---

## Description

Build a production-ready API Gateway using Go and the Fiber framework that serves as the single entry point for all client-facing APIs. The gateway handles authentication, request routing to microservices, rate limiting, request/response logging, and health monitoring.

---

## Acceptance Criteria

### AC1: Service Routing
```gherkin
Given the API Gateway is running
When a request arrives at the gateway
Then route based on path prefix:
  | Path Prefix | Target Service | Port |
  | /api/v1/auth/* | Auth Service (Go) | 8001 |
  | /api/v1/users/* | User Service (Dart) | 8002 |
  | /api/v1/transactions/* | Transaction Service (Dart) | 8003 |
  | /api/v1/ai/* | AI/ML Service (Python) | 8004 |
  | /api/v1/analytics/* | Analytics Service (Python) | 8005 |
And return 503 if target service is unavailable
And include X-Request-ID header in all responses
```

### AC2: JWT Authentication
```gherkin
Given a protected endpoint is called
When the request has Authorization header
Then validate JWT:
  - Check signature with RS256 public key
  - Verify exp claim (not expired)
  - Verify iss claim (our auth service)
  - Extract user_id and inject into X-User-ID header
And allow request to proceed
And return 401 if token is invalid/expired
And return 403 if token lacks required scope
```

### AC3: Rate Limiting
```gherkin
Given rate limits are configured
Then enforce limits per user:
  | Endpoint Pattern | Limit | Window |
  | /api/v1/auth/login | 5 requests | 1 minute |
  | /api/v1/transactions | 100 requests | 1 minute |
  | /api/v1/ai/* | 20 requests | 1 minute |
  | Default | 60 requests | 1 minute |
And return 429 with Retry-After header when exceeded
And store rate limit counters in Redis
```

### AC4: Health Checks
```gherkin
Given the gateway has /health endpoint
When called
Then return:
  | Status | Response |
  | All services up | 200 {"status": "healthy", "services": {...}} |
  | Some services down | 200 {"status": "degraded", "services": {...}} |
  | Critical failure | 503 {"status": "unhealthy"} |
And check all downstream services
And respond within 2 seconds
```

### AC5: Request Logging
```gherkin
Given a request passes through the gateway
Then log in structured JSON:
  - request_id
  - method
  - path
  - status_code
  - latency_ms
  - user_id (if authenticated)
  - ip_address (hashed for privacy)
And do NOT log:
  - Authorization header values
  - Request/response bodies
  - PII fields
```

### AC6: CORS Configuration
```gherkin
Given the gateway handles CORS
Then configure:
  | Setting | Value |
  | Allowed Origins | https://app.DuskSpendr.io, localhost:* |
  | Allowed Methods | GET, POST, PUT, DELETE, OPTIONS |
  | Allowed Headers | Authorization, Content-Type, X-Request-ID |
  | Max Age | 86400 (24 hours) |
And handle preflight OPTIONS requests
```

---

## Technical Implementation

### Go/Fiber Gateway

```go
// cmd/gateway/main.go
package main

import (
    "log"
    "os"
    "time"

    "github.com/gofiber/fiber/v2"
    "github.com/gofiber/fiber/v2/middleware/cors"
    "github.com/gofiber/fiber/v2/middleware/logger"
    "github.com/gofiber/fiber/v2/middleware/recover"
    "github.com/gofiber/fiber/v2/middleware/requestid"
    
    "github.com/DuskSpendr/gateway/internal/config"
    "github.com/DuskSpendr/gateway/internal/middleware"
    "github.com/DuskSpendr/gateway/internal/proxy"
)

func main() {
    cfg := config.Load()
    
    app := fiber.New(fiber.Config{
        AppName:           "DuskSpendr API Gateway",
        EnablePrintRoutes: cfg.Debug,
        ReadTimeout:       10 * time.Second,
        WriteTimeout:      10 * time.Second,
        IdleTimeout:       120 * time.Second,
        ErrorHandler:      middleware.ErrorHandler,
    })
    
    // Global middleware
    app.Use(recover.New())
    app.Use(requestid.New())
    app.Use(logger.New(logger.Config{
        Format:     `{"time":"${time}","id":"${locals:requestid}","status":${status},"latency":"${latency}","method":"${method}","path":"${path}"}` + "\n",
        TimeFormat: time.RFC3339,
    }))
    app.Use(cors.New(cors.Config{
        AllowOrigins:     cfg.CORSOrigins,
        AllowMethods:     "GET,POST,PUT,DELETE,OPTIONS",
        AllowHeaders:     "Authorization,Content-Type,X-Request-ID",
        MaxAge:           86400,
        AllowCredentials: true,
    }))
    
    // Health check (unauthenticated)
    app.Get("/health", middleware.HealthCheck(cfg.Services))
    app.Get("/ready", func(c *fiber.Ctx) error {
        return c.JSON(fiber.Map{"status": "ready"})
    })
    
    // API v1 routes
    api := app.Group("/api/v1")
    
    // Auth routes (some public, some protected)
    auth := api.Group("/auth")
    auth.Post("/register", proxy.Forward(cfg.Services.Auth))
    auth.Post("/login", middleware.RateLimit(5, time.Minute), proxy.Forward(cfg.Services.Auth))
    auth.Post("/refresh", proxy.Forward(cfg.Services.Auth))
    auth.Post("/logout", middleware.JWTAuth(cfg.JWT), proxy.Forward(cfg.Services.Auth))
    
    // Protected routes
    protected := api.Group("", middleware.JWTAuth(cfg.JWT))
    
    // User service
    protected.All("/users/*", proxy.Forward(cfg.Services.User))
    
    // Transaction service
    protected.All("/transactions/*", 
        middleware.RateLimit(100, time.Minute),
        proxy.Forward(cfg.Services.Transaction))
    
    // AI service
    protected.All("/ai/*",
        middleware.RateLimit(20, time.Minute),
        proxy.Forward(cfg.Services.AI))
    
    // Analytics service
    protected.All("/analytics/*", proxy.Forward(cfg.Services.Analytics))
    
    // Start server
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }
    log.Fatal(app.Listen(":" + port))
}
```

### JWT Middleware

```go
// internal/middleware/jwt.go
package middleware

import (
    "strings"
    "time"

    "github.com/gofiber/fiber/v2"
    "github.com/golang-jwt/jwt/v5"
)

type JWTConfig struct {
    PublicKey  string
    Issuer     string
    Audience   string
}

func JWTAuth(cfg JWTConfig) fiber.Handler {
    publicKey, err := jwt.ParseRSAPublicKeyFromPEM([]byte(cfg.PublicKey))
    if err != nil {
        panic("invalid JWT public key: " + err.Error())
    }
    
    return func(c *fiber.Ctx) error {
        // Get token from header
        authHeader := c.Get("Authorization")
        if authHeader == "" {
            return c.Status(401).JSON(fiber.Map{
                "error": "missing_token",
                "message": "Authorization header is required",
            })
        }
        
        // Extract Bearer token
        parts := strings.Split(authHeader, " ")
        if len(parts) != 2 || parts[0] != "Bearer" {
            return c.Status(401).JSON(fiber.Map{
                "error": "invalid_format",
                "message": "Authorization header must be 'Bearer <token>'",
            })
        }
        tokenString := parts[1]
        
        // Parse and validate token
        token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
            if _, ok := token.Method.(*jwt.SigningMethodRSA); !ok {
                return nil, fiber.NewError(401, "invalid signing method")
            }
            return publicKey, nil
        })
        
        if err != nil {
            return c.Status(401).JSON(fiber.Map{
                "error": "invalid_token",
                "message": err.Error(),
            })
        }
        
        claims, ok := token.Claims.(jwt.MapClaims)
        if !ok || !token.Valid {
            return c.Status(401).JSON(fiber.Map{
                "error": "invalid_claims",
                "message": "Token claims are invalid",
            })
        }
        
        // Verify issuer
        if claims["iss"] != cfg.Issuer {
            return c.Status(401).JSON(fiber.Map{
                "error": "invalid_issuer",
            })
        }
        
        // Inject user ID for downstream services
        if userID, ok := claims["sub"].(string); ok {
            c.Set("X-User-ID", userID)
            c.Locals("user_id", userID)
        }
        
        // Inject scopes if present
        if scopes, ok := claims["scope"].(string); ok {
            c.Set("X-User-Scopes", scopes)
        }
        
        return c.Next()
    }
}
```

### Rate Limiter

```go
// internal/middleware/ratelimit.go
package middleware

import (
    "fmt"
    "time"

    "github.com/gofiber/fiber/v2"
    "github.com/redis/go-redis/v9"
)

var redisClient *redis.Client

func RateLimit(limit int, window time.Duration) fiber.Handler {
    return func(c *fiber.Ctx) error {
        // Get identifier (user ID or IP)
        identifier := c.Locals("user_id")
        if identifier == nil {
            identifier = c.IP()
        }
        
        key := fmt.Sprintf("ratelimit:%s:%s", c.Path(), identifier)
        
        // Increment counter
        count, err := redisClient.Incr(c.Context(), key).Result()
        if err != nil {
            // If Redis fails, allow request (fail-open)
            return c.Next()
        }
        
        // Set expiry on first request
        if count == 1 {
            redisClient.Expire(c.Context(), key, window)
        }
        
        // Check limit
        if count > int64(limit) {
            ttl, _ := redisClient.TTL(c.Context(), key).Result()
            c.Set("X-RateLimit-Limit", fmt.Sprintf("%d", limit))
            c.Set("X-RateLimit-Remaining", "0")
            c.Set("Retry-After", fmt.Sprintf("%d", int(ttl.Seconds())))
            
            return c.Status(429).JSON(fiber.Map{
                "error": "rate_limit_exceeded",
                "message": "Too many requests. Please try again later.",
                "retry_after": int(ttl.Seconds()),
            })
        }
        
        // Set rate limit headers
        c.Set("X-RateLimit-Limit", fmt.Sprintf("%d", limit))
        c.Set("X-RateLimit-Remaining", fmt.Sprintf("%d", limit-int(count)))
        
        return c.Next()
    }
}
```

### Health Check

```go
// internal/middleware/health.go
package middleware

import (
    "context"
    "net/http"
    "sync"
    "time"

    "github.com/gofiber/fiber/v2"
    "github.com/DuskSpendr/gateway/internal/config"
)

func HealthCheck(services config.Services) fiber.Handler {
    return func(c *fiber.Ctx) error {
        ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
        defer cancel()
        
        status := "healthy"
        serviceStatuses := make(map[string]string)
        var wg sync.WaitGroup
        var mu sync.Mutex
        
        checkService := func(name, url string) {
            defer wg.Done()
            
            req, _ := http.NewRequestWithContext(ctx, "GET", url+"/health", nil)
            client := &http.Client{Timeout: 1 * time.Second}
            resp, err := client.Do(req)
            
            mu.Lock()
            defer mu.Unlock()
            
            if err != nil || resp.StatusCode != 200 {
                serviceStatuses[name] = "unhealthy"
                status = "degraded"
            } else {
                serviceStatuses[name] = "healthy"
            }
        }
        
        wg.Add(5)
        go checkService("auth", services.Auth.URL)
        go checkService("user", services.User.URL)
        go checkService("transaction", services.Transaction.URL)
        go checkService("ai", services.AI.URL)
        go checkService("analytics", services.Analytics.URL)
        wg.Wait()
        
        statusCode := 200
        if status == "unhealthy" {
            statusCode = 503
        }
        
        return c.Status(statusCode).JSON(fiber.Map{
            "status":   status,
            "services": serviceStatuses,
            "time":     time.Now().UTC().Format(time.RFC3339),
        })
    }
}
```

### Dockerfile

```dockerfile
# Dockerfile
FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o gateway ./cmd/gateway

FROM alpine:3.19
RUN apk --no-cache add ca-certificates

WORKDIR /app
COPY --from=builder /app/gateway .

EXPOSE 8080
CMD ["./gateway"]
```

---

## Definition of Done

- [ ] Fiber gateway with all routes configured
- [ ] JWT RS256 validation working
- [ ] Rate limiting with Redis
- [ ] Health check endpoint
- [ ] Structured logging
- [ ] CORS configured
- [ ] Docker containerized
- [ ] Unit tests for middleware
- [ ] Integration tests with mock services
- [ ] Load tested: 5000 req/s
- [ ] Documentation (OpenAPI)
- [ ] Code reviewed

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| None | - | First infrastructure component |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-201 | Auth service |
| SS-202 | User service |
| SS-205 | Transaction service |
| SS-040 | AI service |

---

## Security Considerations

1. **No Secrets in Logs**: Never log tokens or credentials
2. **Input Validation**: Validate Content-Length, reject oversized requests
3. **TLS Termination**: All traffic encrypted (via Cloudflare/LB)
4. **IP Hashing**: Hash IPs in logs for privacy
5. **Fail-Open Rate Limiting**: If Redis fails, allow requests (availability > strictness)
6. **Request ID Tracing**: Propagate X-Request-ID to all services

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Fiber setup + routing | 3 |
| JWT middleware | 4 |
| Rate limiting | 3 |
| Health checks | 2 |
| CORS + logging | 2 |
| Proxy forwarding | 3 |
| Docker + CI | 2 |
| Unit tests | 3 |
| Integration tests | 2 |
| Load testing | 2 |
| **Total** | **26 hours** |

---

## Related Links

- [Fiber Documentation](https://docs.gofiber.io/)
- [JWT RS256 Security](https://auth0.com/blog/rs256-vs-hs256-whats-the-difference/)

---

*Created: 2026-02-04 | Last Updated: 2026-02-05*
