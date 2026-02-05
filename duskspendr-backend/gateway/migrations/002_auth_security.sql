ALTER TABLE auth_otps ALTER COLUMN code DROP NOT NULL;

ALTER TABLE auth_otps ADD COLUMN IF NOT EXISTS code_hash TEXT;
ALTER TABLE auth_otps ADD COLUMN IF NOT EXISTS attempts_remaining INT NOT NULL DEFAULT 5;
ALTER TABLE auth_otps ADD COLUMN IF NOT EXISTS consumed_at TIMESTAMPTZ;
ALTER TABLE auth_otps ADD COLUMN IF NOT EXISTS send_ip TEXT;
ALTER TABLE auth_otps ADD COLUMN IF NOT EXISTS verify_ip TEXT;

UPDATE auth_otps
   SET code_hash = encode(digest(code, 'sha256'), 'hex')
 WHERE code_hash IS NULL AND code IS NOT NULL;

ALTER TABLE auth_otps ALTER COLUMN code_hash SET NOT NULL;

CREATE INDEX IF NOT EXISTS idx_auth_otps_phone_created
  ON auth_otps (phone, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_auth_otps_send_ip_created
  ON auth_otps (send_ip, created_at DESC);
