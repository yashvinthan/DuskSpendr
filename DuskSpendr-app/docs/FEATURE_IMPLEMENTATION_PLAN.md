# DuskSpendr – Feature Implementation Plan (87 Features)

Security rule: every feature that touches PII, money, or auth must use encrypted storage, validated input, and audit where specified. See [SECURITY.md](../SECURITY.md) before any production deploy.

---

## Spec 1: Core Infrastructure & Data Layer (P0)

| ID     | Feature                      | Priority | Status      | Security Notes |
|--------|------------------------------|----------|------------|----------------|
| SS-001 | Flutter Clean Architecture   | P0       | Done       | MVVM, Riverpod, layers in place. |
| SS-002 | Encrypted Drift Database     | P0       | Done       | SQLCipher, migrations, DAOs. Key in secure storage. |
| SS-003 | Core Data Models             | P0       | Done       | Transaction, LinkedAccount, Budget, Money, etc. |
| SS-004 | Privacy Engine               | P0       | Done       | Validation, encryption utils, audit trails, reports. |
| SS-005 | Biometric/PIN Auth           | P0       | Done       | local_auth, PIN fallback, secure hash storage. |
| SS-006 | Secure Backup/Restore        | P1       | Done       | Checksum in file header; restore verifies before decrypt. Key in secure storage. |

---

## Spec 2: Account Linking System (P0)

| ID     | Feature                | Priority | Status | Security Notes |
|--------|------------------------|----------|--------|----------------|
| SS-010 | Account Linker Arch    | P0       | Done  | Interface, providers, error handling. |
| SS-011 | OAuth 2.0 Auth         | P0       | Done  | PKCE, token refresh; tokens encrypted in SecureTokenManager. |
| SS-012 | SBI Bank Linking       | P0       | Stub  | AA/Open Banking; use official SDK/APIs only. |
| SS-013 | HDFC Bank Linking      | P0       | Stub  | Same as above. |
| SS-014 | ICICI Bank Linking     | P1       | Stub  | Same. |
| SS-015 | Axis Bank Linking      | P1       | Stub  | Same. |
| SS-016 | Google Pay Integration | P0       | Stub  | OAuth, UPI history; validate webhook/signatures. |
| SS-017 | PhonePe Integration    | P0       | Stub  | SDK/API; secure token storage. |
| SS-018 | Paytm UPI              | P1       | Stub  | Same. |
| SS-019 | Amazon Pay Wallet       | P1       | Stub  | Same. |
| SS-020 | Paytm Wallet           | P1       | Done  | OAuth token exchange/refresh; wallet passbook/balance. |
| SS-021 | LazyPay BNPL            | P2       | Stub  | Same. |
| SS-022 | Simpl BNPL              | P2       | Done  | API fetch transactions/balance; deep-link auth. |
| SS-023 | Amazon Pay Later        | P2       | Done  | Pay Later API transactions/limit; Amazon OAuth. |
| SS-024 | Account Unlinking       | P0       | Done  | Revoke tokens, full data cleanup, atomic. |
| SS-025 | Account Management UI   | P0       | Done  | List, status, add/remove. |
| SS-026–031 | Investment platforms (Zerodha, Groww, etc.) | P2 | Stub | Use official APIs; no plaintext secrets. |

---

## Spec 3: Data Synchronization & SMS Parsing (P0)

| ID     | Feature                    | Priority | Status | Security Notes |
|--------|----------------------------|----------|--------|----------------|
| SS-030 | Data Synchronizer Design   | P0       | Done  | Interface, scheduling, error handling. |
| SS-031 | Real-time Transaction Sync| P0       | Done  | Background sync, circuit breaker, rate limit. |
| SS-032 | UPI Notification Handler  | P0       | Done  | EventChannel from Android; parse on-device; wired to ingest. |
| SS-033 | SMS Parser Design          | P0       | Done  | On-device only. |
| SS-034 | Financial Institution Verify | P0     | Done  | Sender whitelist. |
| SS-035 | Spam/Fake SMS Detection    | P0       | Done  | Phishing URLs, bank-impersonation domains, scam patterns. |
| SS-036 | Transaction from SMS       | P0       | Done  | Debit/credit/UPI parsing. |
| SS-037 | Balance from SMS           | P0       | Done  | Balance parsing. |
| SS-038 | Duplicate Transaction     | P0       | Partial| Cross-source, ref matching. |
| SS-039 | Subscription/Recurring   | P1       | Partial| Pattern detection. |
| SS-040 | Sync Status Dashboard     | P1       | Done  | SyncStatusScreen; last sync, per-provider status, manual refresh. |
| SS-041 | Batch Transaction Sync    | P1       | Done  | fetchHistoricalTransactions 90 days, pagination, rate limit. |

---

## Spec 4: Transaction Management & Categorization (P0)

| ID     | Feature                  | Priority | Status | Security Notes |
|--------|--------------------------|----------|--------|----------------|
| SS-050 | Categorizer Design       | P0       | Done  | Interface, ML contract. |
| SS-051 | ML Merchant Recognition  | P0       | Partial| TFLite; run on-device or in secured backend only. |
| SS-052 | Standard Category System | P0       | Done  | 13 categories, i18n. |
| SS-053 | User Feedback Learning   | P1       | Partial| Corrections, mapping updates. |
| SS-054 | Custom Categories        | P1       | Done  | User-defined, rules, secure storage. |
| SS-055 | Transaction List + Filters | P0     | Done  | Date/category/account/amount, search. |
| SS-056 | Transaction Detail       | P0       | Done  | Metadata, category change, notes. |
| SS-057 | Manual Cash Entry        | P0       | Done  | Quick add, category, receipt. |
| SS-058 | Category Management UI   | P1       | Done  | Full UI: list/create/edit, icon/color picker. |
| SS-059 | Confidence Scoring       | P1       | Done  | 0–1 score in categorizer; needsReview flag. |

---

## Spec 5: Budget & Financial Tracking (P0)

| ID     | Feature                      | Priority | Status | Security Notes |
|--------|------------------------------|----------|--------|----------------|
| SS-060 | Daily/Weekly/Monthly Budgets | P0       | Done  | Model, rollover, category budgets. |
| SS-061 | Budget Create/Edit UI        | P0       | Done  | Wizard, alerts. |
| SS-062 | Overspending Alerts         | P0       | Done  | Thresholds, notifications. |
| SS-063 | Pocket Money Prediction      | P1       | Done  | 3-month analysis UI, trend detection, insights. |
| SS-064 | Account Balance Tracking     | P0       | Done  | Per-account, SMS/API. |
| SS-065 | Consolidated Balance         | P0       | Done  | Total, charts, privacy toggle. |
| SS-066 | Low Balance Alerts           | P1       | Done  | Per-account thresholds UI, notifications. |
| SS-067 | Bill Payment Reminders       | P1       | Partial| Recurring, calendar. |
| SS-068 | Loan/Credit Card Tracking    | P2       | Partial| EMI, utilization. |
| SS-069 | Investment Tracking          | P2       | Partial| FDs, gold, stocks, MF, SIP. |
| SS-070 | Financial Calculators        | P2       | Done  | EMI, SIP, etc. |

---

## Spec 6: Student Dashboard UI (P0)

| ID     | Feature                  | Priority | Status | Security Notes |
|--------|--------------------------|----------|--------|----------------|
| SS-080 | Student-Friendly Theme   | P0       | Done  | Colors, typography, components. |
| SS-081 | Main Dashboard           | P0       | Done  | Balance, spending, budget, recent tx. |
| SS-082 | Expense Charts           | P0       | Done  | Pie/bar/line, tooltips. |
| SS-083 | Student Finance Score    | P1       | Done  | Full UI: score gauge, breakdown, tips, share. |
| SS-084 | Weekly/Monthly Summary   | P0       | Done  | Totals, breakdown, export. |
| SS-085 | Spending Trend UI        | P1       | Done  | 3–6 month trends, charts, insights. |
| SS-086 | Quick Action Shortcuts   | P1       | Done  | FAB speed dial implemented. |
| SS-087 | Onboarding Tutorial      | P0       | Done  | Permissions, linking, budget tour. |
| SS-088 | Settings & Preferences   | P0       | Done  | Profile, notifications, privacy, security. |
| SS-089 | Dark Mode                | P2       | Done  | System/manual, OLED. |

---

## Spec 7: Financial Education & Insights (P1)

| ID     | Feature                    | Priority | Status | Security Notes |
|--------|----------------------------|----------|--------|----------------|
| SS-090 | Financial Educator Design  | P1       | Done  | Interface, tips. |
| SS-091 | Personalized Spending Tips | P1       | Partial| Pattern analysis, 1–2/day. |
| SS-092 | Financial Health Score     | P1       | Done  | Full UI: overall score, sub-scores, trends. |
| SS-093 | Improvement Suggestions    | P1       | Done  | Actionable steps in health score screen. |
| SS-094 | Age-Appropriate Content    | P1       | Partial| Topics, lessons, quizzes. |
| SS-095 | Achievement Celebrations   | P2       | Partial| Badges, share. |
| SS-096 | Financial Literacy UI      | P2       | Partial| Hub, progress. |
| SS-097 | Credit Score Tracking      | P2       | Done  | Manual entry UI, improvement tips, CIBIL/Experian stubs. |

---

## Spec 8: Shared Expenses & Social (P1)

| ID     | Feature              | Priority | Status | Security Notes |
|--------|----------------------|----------|--------|----------------|
| SS-100 | Shared Expense Model | P1       | Done  | Entities. |
| SS-101 | Splitting Calculator | P1       | Done  | Equal/percent/exact. |
| SS-102 | Friend/Group Mgmt    | P1       | Partial| Add, groups. |
| SS-103 | Who-Owes-Whom        | P1       | Partial| Net balance, simplification. |
| SS-104 | Settlement Tracking  | P1       | Partial| Full/partial, history. |
| SS-105 | Settlement Reminders | P2       | Done  | Service with notifications, WhatsApp share, configurable frequency. |
| SS-106 | Shared Expense UI    | P1       | Done  | Add expense, split, summary. |
| SS-107 | Privacy Protection   | P1       | Partial| Data isolation, no personal spend exposure. |

---

## Implementation Order (Recommended)

1. **Security baseline:** SECURITY.md, API URL from config, secure session storage (done). Enforce HTTPS in release.
2. **Spec 1:** Confirm backup/restore key handling and integrity (SS-006).
3. **Spec 2:** Implement one bank and one UPI flow end-to-end with real APIs; then replicate pattern.
4. **Spec 3:** Complete sync circuit breaker, push path, and UPI notification handler; harden SMS spam rules.
5. **Spec 4–6:** Fill remaining UI and categorization gaps; ensure all API calls use auth and rate limiting.
6. **Spec 7–8:** Complete insights and shared-expense flows; ensure no PII leakage in social features.

---

## Status Legend

- **Done:** Implemented and wired; security checklist applied.
- **Partial:** Partially implemented; needs completion or hardening.
- **Stub:** Placeholder or interface only; needs full implementation.

Before each release: run `flutter pub audit`, fix lints, and confirm SECURITY.md checklist.
