# Spec 17: Containers - Docker & Orchestration

## Overview

**Spec ID:** DuskSpendr-INFRA-017  
**Domain:** Container Engineering  
**Priority:** P1  
**Estimated Effort:** 2 sprints  

---

## Objectives

1. **Consistent Environments** - Dev/Staging/Prod parity
2. **Fast Deployments** - Container-based rolling updates
3. **Resource Efficiency** - Optimal container sizing
4. **Security** - Minimal attack surface images

---

## Docker Configuration

### Backend Dockerfile

```dockerfile
# Multi-stage build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
USER nodejs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -q --spider http://localhost:3000/health
CMD ["node", "dist/server.js"]
```

### Docker Compose (Development)

```yaml
version: '3.8'
services:
  api:
    build: ./backend
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://dev:dev@db:5432/DuskSpendr
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: DuskSpendr
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

---

## Requirements & Feature Tickets

| Ticket ID | Title | Requirement | Priority | Points |
|-----------|-------|-------------|----------|--------|
| SS-340 | Create optimized backend Dockerfile | DevOps Efficiency | P0 | 5 |
| SS-341 | Set up Docker Compose for local dev | Developer Experience | P0 | 5 |
| SS-342 | Configure ECR repositories | Cloud Deployment | P0 | 3 |
| SS-343 | Implement container health checks | REQ-02: Data Sync reliability | P0 | 3 |
| SS-344 | Set up container security scanning | Security | P1 | 5 |
| SS-345 | Create ECS task definitions | Cloud Deployment | P0 | 8 |
| SS-346 | Configure container logging | Monitoring | P1 | 3 |
| SS-347 | Implement graceful shutdown | REQ-02: Data Sync | P1 | 3 |

---

*Last Updated: 2026-02-04*
