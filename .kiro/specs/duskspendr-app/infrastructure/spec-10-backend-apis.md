# Spec 10: Backend APIs - Multi-Language Microservices Architecture

## Overview

**Spec ID:** DuskSpendr-INFRA-010  
**Domain:** Backend Engineering  
**Priority:** P0 (Critical)  
**Estimated Effort:** 6 sprints  

---

## Objectives

1. **Polyglot Architecture** - Right language for each service
2. **High Performance** - <100ms API response times
3. **Scalability** - Handle 100K+ concurrent users
4. **Privacy-First** - Minimal data collection, secure processing

---

## Technology Stack

| Service | Language | Framework | Purpose |
|---------|----------|-----------|---------|
| **API Gateway** | Go | Fiber | High-performance routing, rate limiting |
| **Auth Service** | Go | Fiber | JWT, OAuth 2.0, session management |
| **User Service** | Dart | Serverpod | User profiles, preferences (Flutter alignment) |
| **Transaction Service** | Dart | Serverpod | CRUD operations, sync (Flutter alignment) |
| **AI/ML Service** | Python | FastAPI | Categorization, insights, predictions |
| **Notification Service** | Go | Fiber | Push notifications, email, SMS |
| **Analytics Service** | Python | FastAPI | Aggregations, reporting, dashboards |

---

## Microservices Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        CloudFlare CDN                            │
└─────────────────────────────┬───────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   API Gateway (Go/Fiber)                         │
│  - Rate limiting, Auth validation, Request routing               │
└─────────────────────────────┬───────────────────────────────────┘
                              ▼
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│ Auth Service  │    │ User Service  │    │ Transaction   │
│    (Go)       │    │   (Dart)      │    │   Service     │
│               │    │               │    │    (Dart)     │
└───────┬───────┘    └───────┬───────┘    └───────┬───────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             ▼
        ┌─────────────────────────────────────────┐
        │              Message Queue               │
        │           (RabbitMQ / Redis)             │
        └─────────────────────┬───────────────────┘
                              ▼
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│  AI/ML Svc    │    │ Notification  │    │  Analytics    │
│  (Python)     │    │    (Go)       │    │   (Python)    │
└───────────────┘    └───────────────┘    └───────────────┘
```

---

## Service Implementations

### 1. API Gateway (Go/Fiber)

```go
// cmd/gateway/main.go
package main

import (
    "github.com/gofiber/fiber/v2"
    "github.com/gofiber/fiber/v2/middleware/limiter"
    "github.com/gofiber/fiber/v2/middleware/logger"
    "github.com/gofiber/fiber/v2/middleware/cors"
)

func main() {
    app := fiber.New(fiber.Config{
        Prefork:       true,
        ServerHeader:  "DuskSpendr",
        StrictRouting: true,
    })

    // Middleware
    app.Use(logger.New())
    app.Use(cors.New())
    app.Use(limiter.New(limiter.Config{
        Max:        100,
        Expiration: 1 * time.Minute,
    }))

    // Auth middleware
    app.Use("/api/v1/*", AuthMiddleware())

    // Service routing
    app.All("/api/v1/auth/*", proxyTo("auth-service:8001"))
    app.All("/api/v1/users/*", proxyTo("user-service:8002"))
    app.All("/api/v1/transactions/*", proxyTo("transaction-service:8003"))
    app.All("/api/v1/ai/*", proxyTo("ai-service:8004"))
    app.All("/api/v1/analytics/*", proxyTo("analytics-service:8005"))

    app.Listen(":8000")
}
```

### 2. Auth Service (Go/Fiber)

```go
// internal/auth/handler.go
func (h *AuthHandler) Login(c *fiber.Ctx) error {
    var req LoginRequest
    if err := c.BodyParser(&req); err != nil {
        return c.Status(400).JSON(ErrorResponse{Error: "Invalid request"})
    }

    user, err := h.userRepo.FindByEmail(req.Email)
    if err != nil || !h.passwordService.Verify(req.Password, user.PasswordHash) {
        return c.Status(401).JSON(ErrorResponse{Error: "Invalid credentials"})
    }

    accessToken, _ := h.jwtService.GenerateAccessToken(user.ID)
    refreshToken, _ := h.jwtService.GenerateRefreshToken(user.ID)

    return c.JSON(AuthResponse{
        AccessToken:  accessToken,
        RefreshToken: refreshToken,
        ExpiresIn:    3600,
    })
}
```

### 3. User Service (Dart/Serverpod)

```dart
// lib/src/endpoints/user_endpoint.dart
import 'package:serverpod/serverpod.dart';

class UserEndpoint extends Endpoint {
  Future<User> getProfile(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) throw AuthenticationException();
    
    return await User.db.findById(session, userId) 
        ?? (throw NotFoundException('User not found'));
  }
  
  Future<User> updateProfile(Session session, UserUpdate update) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) throw AuthenticationException();
    
    final user = await User.db.findById(session, userId);
    if (user == null) throw NotFoundException('User not found');
    
    user
      ..displayName = update.displayName ?? user.displayName
      ..avatarUrl = update.avatarUrl ?? user.avatarUrl
      ..preferences = update.preferences ?? user.preferences;
    
    await User.db.updateRow(session, user);
    return user;
  }
}
```

### 4. Transaction Service (Dart/Serverpod)

```dart
// lib/src/endpoints/transaction_endpoint.dart
class TransactionEndpoint extends Endpoint {
  Future<List<Transaction>> getTransactions(
    Session session, {
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) throw AuthenticationException();
    
    return await Transaction.db.find(
      session,
      where: (t) => t.userId.equals(userId) &
          (startDate != null ? t.date.greaterThanOrEquals(startDate) : Constant(true)) &
          (endDate != null ? t.date.lessThanOrEquals(endDate) : Constant(true)),
      orderBy: (t) => t.date,
      orderDescending: true,
      limit: limit ?? 50,
      offset: offset ?? 0,
    );
  }
  
  Future<Transaction> createTransaction(
    Session session,
    TransactionCreate data,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) throw AuthenticationException();
    
    final transaction = Transaction(
      userId: userId,
      amount: data.amount,
      merchantName: data.merchantName,
      categoryId: data.categoryId,
      date: data.date,
      source: data.source,
    );
    
    await Transaction.db.insertRow(session, transaction);
    
    // Trigger AI categorization if needed
    if (data.categoryId == null) {
      await session.messages.postMessage(
        'ai-categorization',
        TransactionCategorizationRequest(transactionId: transaction.id!),
      );
    }
    
    return transaction;
  }
}
```

### 5. AI/ML Service (Python/FastAPI)

```python
# app/main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import tensorflow as tf
from transformers import pipeline

app = FastAPI(title="DuskSpendr AI Service")

# Load models on startup
categorizer = pipeline("text-classification", model="./models/transaction_categorizer")
sentiment_analyzer = pipeline("sentiment-analysis")

class TransactionInput(BaseModel):
    merchant_name: str
    description: str | None = None
    amount: float

class CategoryPrediction(BaseModel):
    category: str
    confidence: float
    subcategory: str | None = None

@app.post("/api/v1/ai/categorize", response_model=CategoryPrediction)
async def categorize_transaction(transaction: TransactionInput):
    """AI-powered transaction categorization"""
    text = f"{transaction.merchant_name} {transaction.description or ''}"
    result = categorizer(text)[0]
    
    return CategoryPrediction(
        category=result["label"],
        confidence=result["score"],
        subcategory=get_subcategory(result["label"], transaction.merchant_name),
    )

@app.post("/api/v1/ai/insights")
async def generate_insights(user_id: str, period: str = "month"):
    """Generate personalized financial insights"""
    # Fetch user transaction data
    transactions = await get_user_transactions(user_id, period)
    
    insights = []
    
    # Spending pattern analysis
    spending_by_category = analyze_spending_patterns(transactions)
    insights.append(generate_spending_insight(spending_by_category))
    
    # Anomaly detection
    anomalies = detect_anomalies(transactions)
    if anomalies:
        insights.append(generate_anomaly_alert(anomalies))
    
    # Savings opportunities
    savings = find_savings_opportunities(transactions)
    insights.extend(savings)
    
    return {"insights": insights}
```

### 6. Analytics Service (Python/FastAPI)

```python
# app/analytics.py
from fastapi import FastAPI
import pandas as pd
from datetime import datetime, timedelta

app = FastAPI(title="DuskSpendr Analytics")

@app.get("/api/v1/analytics/spending-summary")
async def get_spending_summary(user_id: str, period: str = "month"):
    """Get spending summary with category breakdown"""
    transactions = await fetch_transactions(user_id, period)
    df = pd.DataFrame(transactions)
    
    summary = {
        "total_spent": float(df[df["amount"] < 0]["amount"].sum().abs()),
        "total_income": float(df[df["amount"] > 0]["amount"].sum()),
        "transaction_count": len(df),
        "by_category": df.groupby("category")["amount"].sum().to_dict(),
        "daily_average": float(df[df["amount"] < 0]["amount"].sum().abs() / 30),
    }
    
    return summary

@app.get("/api/v1/analytics/trends")
async def get_spending_trends(user_id: str, months: int = 6):
    """Get monthly spending trends"""
    end_date = datetime.now()
    start_date = end_date - timedelta(days=months * 30)
    
    transactions = await fetch_transactions(user_id, start_date, end_date)
    df = pd.DataFrame(transactions)
    df["month"] = pd.to_datetime(df["date"]).dt.to_period("M")
    
    trends = df.groupby("month")["amount"].agg(["sum", "count"]).to_dict("index")
    
    return {"trends": trends}
```

---

## API Standards

### OpenAPI 3.0 Specification

All services expose OpenAPI documentation at `/docs` (FastAPI) or `/swagger` (Go/Dart).

### Response Format

```json
{
  "success": true,
  "data": { /* response payload */ },
  "meta": {
    "requestId": "uuid",
    "timestamp": "ISO8601",
    "version": "v1"
  }
}
```

### Error Format

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human readable message",
    "details": [{ "field": "email", "issue": "Invalid format" }]
  }
}
```

---

## Requirements & Feature Tickets

| Ticket ID | Title | Requirement | Priority | Points |
|-----------|-------|-------------|----------|--------|
| SS-200 | Set up Go API Gateway with Fiber | Architecture | P0 | 8 |
| SS-201 | Implement Auth Service (Go) | REQ-01: Account Linking | P0 | 13 |
| SS-202 | Create JWT token management | REQ-01: Secure Auth | P0 | 8 |
| SS-203 | Set up Serverpod project structure | Architecture | P0 | 5 |
| SS-204 | Implement User Service (Dart) | REQ-08: User Profiles | P0 | 8 |
| SS-205 | Build Transaction Service (Dart) | REQ-04: Transaction CRUD | P0 | 13 |
| SS-206 | Set up FastAPI AI service | REQ-04: AI Categorization | P0 | 8 |
| SS-207 | Implement ML categorization endpoint | REQ-04: Auto-categorize | P0 | 13 |
| SS-208 | Build Analytics Service (Python) | REQ-11: Reports | P1 | 13 |
| SS-209 | Create Notification Service (Go) | REQ-05: Budget Alerts | P0 | 8 |
| SS-210 | Implement rate limiting | Security | P0 | 5 |
| SS-211 | Set up RabbitMQ message queue | Architecture | P0 | 5 |
| SS-212 | Create service health checks | Operations | P0 | 3 |
| SS-213 | Implement request tracing | Debugging | P1 | 5 |
| SS-214 | Build budget sync endpoints | REQ-05: Budget Tracking | P0 | 8 |
| SS-215 | Create shared expenses API | REQ-09: Split Bills | P1 | 8 |
| SS-216 | Implement data export API | REQ-16: Data Ownership | P1 | 5 |
| SS-217 | Set up API versioning | Maintainability | P1 | 3 |

---

## Inter-Service Communication

| Pattern | Technology | Use Case |
|---------|------------|----------|
| Sync (REST) | HTTP/JSON | User-facing APIs |
| Async (Events) | RabbitMQ | AI processing, notifications |
| Cache | Redis | Session, rate limits, hot data |

---

## Verification Plan

- Load testing with k6 (10K concurrent users)
- Contract testing between services
- Integration tests for critical flows
- API security scanning (OWASP ZAP)

---

*Last Updated: 2026-02-04*
