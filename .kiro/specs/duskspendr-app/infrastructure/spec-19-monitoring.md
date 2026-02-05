# Spec 19: Monitoring & Logging - Metrics, Alerts & Crash Tracking

## Overview

**Spec ID:** DuskSpendr-INFRA-019  
**Domain:** Observability  
**Priority:** P0  
**Estimated Effort:** 3 sprints  

---

## Objectives

1. **Full Visibility** - Monitor all components
2. **Proactive Alerts** - Catch issues before users
3. **Crash Tracking** - Instant crash notifications
4. **Performance Insights** - Identify bottlenecks

---

## Monitoring Architecture

```
┌─────────────────────────────────────────────────────────┐
│                 Observability Stack                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │  Metrics    │  │   Logs      │  │   Traces    │      │
│  │ (Prometheus)│  │  (Loki)     │  │  (Jaeger)   │      │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘      │
│         └────────────────┼────────────────┘              │
│                          ▼                               │
│                 ┌─────────────────┐                      │
│                 │    Grafana      │                      │
│                 │   Dashboards    │                      │
│                 └────────┬────────┘                      │
│                          ▼                               │
│                 ┌─────────────────┐                      │
│                 │   PagerDuty     │                      │
│                 │   Alerts        │                      │
│                 └─────────────────┘                      │
│                                                          │
│  Mobile:                                                 │
│  ┌─────────────┐  ┌─────────────┐                       │
│  │  Firebase   │  │  Sentry     │                       │
│  │  Analytics  │  │  Crashes    │                       │
│  └─────────────┘  └─────────────┘                       │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Key Metrics

### Backend Metrics

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| `http_request_duration_seconds` | API latency | P95 > 500ms |
| `http_requests_total` | Request count | Rate drop > 50% |
| `http_request_errors_total` | Error count | Rate > 1% |
| `db_query_duration_seconds` | DB query time | P95 > 100ms |
| `active_connections` | Open connections | > 80% capacity |

### Mobile Metrics (Firebase)

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Crash-free users | % without crashes | < 99.5% |
| App start time | Cold start duration | > 3s |
| Screen render time | Frame timing | > 16ms |
| API success rate | Successful calls | < 99% |

---

## Crash Tracking (Sentry)

```kotlin
// Android Sentry Setup
class DuskSpendrApp : Application() {
    override fun onCreate() {
        super.onCreate()
        
        SentryAndroid.init(this) { options ->
            options.dsn = BuildConfig.SENTRY_DSN
            options.environment = BuildConfig.BUILD_TYPE
            options.release = "${BuildConfig.VERSION_NAME}+${BuildConfig.VERSION_CODE}"
            options.tracesSampleRate = 0.2
            options.isEnableAutoSessionTracking = true
            
            // Privacy: Don't send PII
            options.beforeSend = SentryOptions.BeforeSendCallback { event, hint ->
                event.user?.email = null
                event.user?.ipAddress = null
                event
            }
        }
    }
}
```

---

## Alert Configuration

```yaml
# Prometheus Alert Rules
groups:
  - name: DuskSpendr-alerts
    rules:
      - alert: HighErrorRate
        expr: rate(http_request_errors_total[5m]) > 0.01
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          
      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "API latency is high"
          
      - alert: DatabaseConnectionPoolExhausted
        expr: db_active_connections / db_max_connections > 0.8
        for: 2m
        labels:
          severity: critical
```

---

## Requirements & Feature Tickets

| Ticket ID | Title | Requirement | Priority | Points |
|-----------|-------|-------------|----------|--------|
| SS-360 | Set up Prometheus metrics collection | Operational Excellence | P0 | 8 |
| SS-361 | Configure Grafana dashboards | Operational Excellence | P0 | 8 |
| SS-362 | Implement Firebase Analytics | REQ-08: App Performance | P0 | 5 |
| SS-363 | Set up Sentry crash tracking | REQ-08: App Stability | P0 | 5 |
| SS-364 | Configure PagerDuty alerts | Operational Excellence | P0 | 5 |
| SS-365 | Create API latency monitoring | REQ-02: <5min Sync | P0 | 5 |
| SS-366 | Set up log aggregation (Loki) | Debugging | P1 | 8 |
| SS-367 | Implement distributed tracing | Performance | P1 | 8 |
| SS-368 | Create uptime monitoring | SLA | P0 | 3 |
| SS-369 | Build operational runbooks | Operations | P1 | 5 |
| SS-370 | Set up SMS categorization accuracy tracking | REQ-03: 100% on-device | P0 | 5 |
| SS-371 | Create budget alert delivery monitoring | REQ-05: Budget Alerts | P1 | 3 |

---

## Verification Plan

- Verify all metrics flowing to Prometheus
- Test alert routing to PagerDuty
- Validate crash reports in Sentry
- Load test with observability

---

*Last Updated: 2026-02-04*
