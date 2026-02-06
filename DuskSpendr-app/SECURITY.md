# DuskSpendr Security & Production Deployment

This document is mandatory reading before deploying to production. Failure to follow it can result in data breaches and compliance violations.

---

## 1. Pre-Deployment Checklist

### 1.1 Secrets & Configuration

- [ ] **No secrets in code or repo.** All API keys, peppers, DB URLs, and JWT secrets must come from environment variables or a secrets manager (e.g. AWS Secrets Manager, Vault).
- [ ] **API base URL:** Production app must be built with HTTPS only:
  ```bash
  flutter build apk --dart-define=API_BASE_URL=https://api.yourdomain.com
  ```
- [ ] **Backend:** Gateway and services use env vars (e.g. `AUTH_PEPPER`, `JWT_SECRET`, `DATABASE_URL`). Never commit `.env` with real values; use `.env.example` as a template only.

### 1.2 Transport Security

- [ ] **HTTPS only** for all production APIs. TLS 1.2 minimum; prefer 1.3.
- [ ] **Certificate validity:** Use a valid certificate from a trusted CA. Avoid self-signed in production.
- [ ] **Certificate pinning (optional but recommended for high-risk):** Consider pinning the API certificate in the Flutter app for production builds to mitigate MITM.

### 1.3 Authentication & Sessions

- [ ] **OTP:** Backend must hash OTPs (e.g. with pepper) and never store plain OTPs. Expiry ≤ 5–10 minutes; limit attempts (e.g. 5).
- [ ] **JWT:** Use short-lived access tokens (e.g. 15–60 min). Store refresh tokens securely; rotate on use if possible. Sign with a strong secret (≥256 bits).
- [ ] **Session storage (app):** Auth token and user id are stored only in `FlutterSecureStorage` with `encryptedSharedPreferences: true` (Android) and Keychain (iOS). No tokens in logs or analytics.
- [ ] **Session timeout:** Rely on JWT expiry for API; optionally implement app-side session timeout (e.g. require re-auth after N minutes of inactivity) and clear `SessionStore` on logout.

### 1.4 Data at Rest

- [ ] **Local DB:** Drift + SQLCipher is used; encryption key is in secure storage. Key must never be logged or backed up in plaintext.
- [ ] **Backup/export:** Backup and export flows use the same encryption service; keys stay on device.

### 1.5 Backend Security

- [ ] **Parameterized queries only.** No string concatenation for SQL. Use prepared statements / parameterized APIs (e.g. pgx `$1,$2`).
- [ ] **Input validation:** Validate and sanitize all inputs (phone format, amounts, IDs). Reject unknown fields where applicable (e.g. `DisallowUnknownFields`).
- [ ] **Rate limiting:** Gateway and auth endpoints must be rate-limited (per IP and per user) to prevent abuse and brute force.
- [ ] **Auth on every sensitive endpoint:** Verify JWT/session for all endpoints that read or write user data.

### 1.6 Privacy & Audit

- [ ] **Audit logging:** Sensitive operations (token storage, data export, account unlink) are logged via PrivacyEngine. Ensure audit logs are retained and protected.
- [ ] **SMS:** Processed on-device only; raw SMS must not be sent to your backend.

### 1.7 Dependency & Build

- [ ] **Dependencies:** Run `flutter pub audit` and fix known vulnerabilities. Keep packages updated.
- [ ] **ProGuard/R8 (Android):** Ensure release builds are obfuscated and that no secrets appear in stack traces or logs.

---

## 2. App-Side Security Summary

| Component        | Implementation |
|-----------------|----------------|
| API base URL    | `AppConfig.apiBaseUrl` from `--dart-define`; release build must use HTTPS. |
| Session store   | `FlutterSecureStorage` with Android encrypted prefs and iOS Keychain. |
| OAuth tokens    | Encrypted at rest via `EncryptionService`; stored in secure storage; audit logged. |
| DB (Drift)      | SQLCipher; key from secure storage. |
| Biometric/PIN   | `local_auth`; PIN hash in secure storage. |

---

## 3. Incident Response

- Rotate all secrets (JWT, peppers, DB credentials) if a compromise is suspected.
- Invalidate affected user sessions and force re-auth.
- Review audit logs for anomalous access.
- Notify affected users and authorities as required by applicable law.

---

## 4. Reporting Vulnerabilities

If you discover a security vulnerability, please report it privately (e.g. to the maintainers or via a private security contact). Do not open public issues for security-sensitive findings.
