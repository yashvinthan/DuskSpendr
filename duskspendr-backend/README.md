# DuskSpendr Backend

This folder contains the backend services for DuskSpendr.

Current layout:
- `gateway/`: Go API gateway (REST). Provides core data APIs for transactions, accounts, and budgets.

Quick start (local):
1. Start Postgres:
   ```
   docker compose up -d
   ```
2. Run migrations:
   - Apply SQL from `gateway/migrations/001_init.sql` to your local database.
3. Run the gateway:
   ```
   cd gateway
   go run ./cmd/api
   ```

Environment variables are documented in `.env.example`.
In production, you must set `AUTH_PEPPER` and `SYNC_SHARED_SECRET` to long random secrets.

Auth flow (local/dev):
- `POST /v1/auth/start` with `{ "phone": "+91..." }` returns `dev_code`.
- `POST /v1/auth/verify` with `{ "phone": "+91...", "code": "123456" }`
  returns `token` and `user_id`.
- Use `Authorization: Bearer <token>` for all `/v1/*` requests.

Sync:
- `POST /v1/sync/transactions` forwards transactions to Serverpod.

Serverpod:
- Configure `SERVERPOD_URL` and check `GET /v1/serverpod/health` to verify connectivity.
- Placeholder service can be started with:
  ```
  cd serverpod
  dart run bin/server.dart
  ```
- For sync persistence, set `SERVERPOD_DB_URL` (e.g. `postgres://dusk:dusk@localhost:5432/duskspendr`).
