# Spec 15: CI/CD - GitHub Actions, Testing & Deployments

## Overview

**Spec ID:** DuskSpendr-INFRA-015  
**Domain:** DevOps & Automation  
**Priority:** P0  
**Estimated Effort:** 3 sprints  

---

## Objectives

1. Automated Testing - Every PR tested automatically
2. Fast Feedback - Build results in <10 minutes
3. Zero-Downtime Deploys - Rolling deployments
4. Quality Gates - Enforce code quality standards

---

## GitHub Actions Workflows

### Android CI

```yaml
name: Android CI
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - run: ./gradlew testDebugUnitTest
      - run: ./gradlew lintDebug

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./gradlew assembleDebug
```

### Backend CI

```yaml
name: Backend CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: test
        ports:
          - 5432:5432
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm test
```

---

## Quality Gates

| Check | Threshold | Blocking |
|-------|-----------|----------|
| Unit Tests | 100% pass | ✅ |
| Coverage | >80% | ✅ |
| Lint Errors | 0 | ✅ |
| Security | 0 High | ✅ |

---

## Implementation Tickets

| Ticket ID | Title | Priority | Points |
|-----------|-------|----------|--------|
| SS-300 | Android CI workflow | P0 | 8 |
| SS-301 | Backend CI workflow | P0 | 8 |
| SS-302 | Code coverage | P0 | 5 |
| SS-303 | Security scanning | P0 | 5 |
| SS-304 | Branch protection | P0 | 3 |
| SS-305 | ECS deployment | P0 | 8 |
| SS-306 | Play Store deploy | P0 | 8 |
| SS-307 | Slack notifications | P1 | 3 |
| SS-308 | Release automation | P1 | 5 |

---

*Last Updated: 2026-02-04*
