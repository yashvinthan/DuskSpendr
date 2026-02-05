# DuskSpendr Serverpod

This is a minimal Serverpod service scaffold with a `health` endpoint.

Planned responsibilities:
- user auth/session verification
- data sync endpoints for transactions/accounts/budgets
- background jobs for sync + insights

Notes:
- For now, the Go gateway is the active API surface.
- Run `dart pub get` in this folder before starting the server.
- Set `SERVERPOD_DB_URL` to enable sync persistence.
