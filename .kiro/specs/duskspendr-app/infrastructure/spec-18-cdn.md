# Spec 18: CDN - Caching & Global Delivery

## Overview

**Spec ID:** DuskSpendr-INFRA-018  
**Domain:** Content Delivery  
**Priority:** P1  
**Estimated Effort:** 1 sprint  

---

## Objectives

1. **Fast Loading** - <1s asset loading across India
2. **Cost Reduction** - Reduce origin bandwidth
3. **DDoS Protection** - Edge-level filtering
4. **Global Reach** - Low latency for all users

---

## CDN Architecture (CloudFlare)

```
┌─────────────────────────────────────────────────────┐
│                    CloudFlare CDN                    │
├─────────────────────────────────────────────────────┤
│  Edge Locations (India):                             │
│  - Mumbai, Delhi, Chennai, Bangalore, Kolkata        │
│                                                      │
│  Cached Content:                                     │
│  - Static assets (JS, CSS, images)                   │
│  - API responses (where applicable)                  │
│  - ML models for on-device inference                 │
└─────────────────────────────────────────────────────┘
```

---

## Caching Strategy

| Content Type | Cache TTL | Location |
|--------------|-----------|----------|
| Static JS/CSS | 1 year | Edge + Browser |
| Images | 30 days | Edge + Browser |
| ML Models | 7 days | Edge + App |
| API (public) | 5 min | Edge only |
| API (private) | No cache | Origin only |

---

## CloudFlare Configuration

```yaml
cloudflare:
  zone: DuskSpendr.app
  
  page_rules:
    - url: "cdn.DuskSpendr.app/static/*"
      cache_level: cache_everything
      edge_cache_ttl: 31536000  # 1 year
      browser_cache_ttl: 31536000
      
    - url: "cdn.DuskSpendr.app/models/*"
      cache_level: cache_everything
      edge_cache_ttl: 604800  # 7 days
      
    - url: "api.DuskSpendr.app/*"
      cache_level: bypass
      security_level: high
```

---

## Requirements & Feature Tickets

| Ticket ID | Title | Requirement | Priority | Points |
|-----------|-------|-------------|----------|--------|
| SS-350 | Configure CloudFlare CDN | REQ-08: Fast UI | P0 | 5 |
| SS-351 | Set up caching rules for static assets | REQ-08: UI Performance | P0 | 3 |
| SS-352 | Configure ML model distribution | REQ-04: AI Categorization | P1 | 5 |
| SS-353 | Implement cache invalidation strategy | DevOps | P1 | 3 |
| SS-354 | Set up CDN analytics | Monitoring | P2 | 3 |
| SS-355 | Configure DDoS protection rules | Security | P0 | 3 |
| SS-356 | Optimize image delivery (WebP) | REQ-08: UI Performance | P1 | 5 |

---

*Last Updated: 2026-02-04*
