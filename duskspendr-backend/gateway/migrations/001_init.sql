CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS auth_otps (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  phone TEXT NOT NULL,
  code TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_auth_otps_phone
  ON auth_otps (phone, created_at DESC);

CREATE TABLE IF NOT EXISTS sessions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL UNIQUE,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_sessions_user
  ON sessions (user_id, expires_at DESC);

CREATE TABLE IF NOT EXISTS linked_accounts (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  provider TEXT NOT NULL,
  account_number TEXT,
  account_name TEXT,
  upi_id TEXT,
  balance_paisa BIGINT,
  status TEXT NOT NULL,
  last_synced_at TIMESTAMPTZ NOT NULL,
  linked_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount_paisa BIGINT NOT NULL,
  type TEXT NOT NULL,
  category TEXT NOT NULL,
  merchant_name TEXT,
  description TEXT,
  timestamp TIMESTAMPTZ NOT NULL,
  source TEXT NOT NULL,
  payment_method TEXT,
  linked_account_id UUID REFERENCES linked_accounts(id) ON DELETE SET NULL,
  reference_id TEXT,
  category_confidence DOUBLE PRECISION,
  is_recurring BOOLEAN NOT NULL DEFAULT false,
  is_shared BOOLEAN NOT NULL DEFAULT false,
  tags JSONB NOT NULL DEFAULT '[]',
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_transactions_user_time
  ON transactions (user_id, timestamp DESC);

CREATE TABLE IF NOT EXISTS budgets (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  limit_paisa BIGINT NOT NULL,
  spent_paisa BIGINT NOT NULL DEFAULT 0,
  period TEXT NOT NULL,
  category TEXT,
  alert_threshold DOUBLE PRECISION NOT NULL DEFAULT 0.8,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);
