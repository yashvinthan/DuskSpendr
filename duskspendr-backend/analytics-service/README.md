# Analytics Service
Python FastAPI service for usage analytics and dashboard metrics.

## Features
- User activity tracking
- Feature usage analytics
- Custom event tracking
- Dashboard metrics aggregation

## Configuration
The following environment variables are required:

- `DATABASE_URL`: PostgreSQL connection URL (e.g., `postgresql+asyncpg://user:pass@host:5432/db`)
- `REDIS_URL`: Redis connection URL (e.g., `redis://host:6379/1`)

You can set these in a `.env` file in the root directory.

## Running Locally
1. Create a `.env` file:
```bash
echo "DATABASE_URL=postgresql+asyncpg://duskspendr:password@localhost:5432/duskspendr" > .env
echo "REDIS_URL=redis://localhost:6379/1" >> .env
```

2. Run the service:
```bash
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8002
```
