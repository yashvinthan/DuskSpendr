package handlers

import (
  "crypto/rand"
  "crypto/sha256"
  "crypto/subtle"
  "encoding/base64"
  "encoding/hex"
  "encoding/json"
  "fmt"
  "math/big"
  "net"
  "net/http"
  "regexp"
  "strings"
  "time"

  "github.com/google/uuid"
  "github.com/jackc/pgx/v5/pgxpool"

  "duskspendr/gateway/internal/config"
  "duskspendr/gateway/internal/models"
)

type HTTPAuthHandler struct {
  Pool *pgxpool.Pool
  Config config.Config
}

func (h *HTTPAuthHandler) Start(w http.ResponseWriter, r *http.Request) {
  var input models.AuthStartInput
  decoder := json.NewDecoder(r.Body)
  decoder.DisallowUnknownFields()
  if err := decoder.Decode(&input); err != nil {
    writeError_HTTP(w, http.StatusBadRequest, "invalid json")
    return
  }
  input.Phone = strings.TrimSpace(input.Phone)
  if !validatePhoneE164_HTTP(input.Phone) {
    writeError_HTTP(w, http.StatusBadRequest, "invalid phone")
    return
  }
  if h.Config.AuthPepper == "" {
    writeError_HTTP(w, http.StatusInternalServerError, "auth not configured")
    return
  }

  if err := h.enforceOTPSendLimits(r, input.Phone); err != nil {
    writeError_HTTP(w, http.StatusTooManyRequests, err.Error())
    return
  }

  userID, err := h.ensureUser(r, input.Phone)
  if err != nil {
    writeError_HTTP(w, http.StatusInternalServerError, "user lookup failed")
    return
  }

  code, err := generateOTP_HTTP(6)
  if err != nil {
    writeError_HTTP(w, http.StatusInternalServerError, "otp generation failed")
    return
  }
  otpID := uuid.New().String()
  expiresAt := time.Now().UTC().Add(5 * time.Minute)
  now := time.Now().UTC()
  sendIP := clientIP_HTTP(r)

  _, _ = h.Pool.Exec(r.Context(), `
    UPDATE auth_otps
       SET consumed_at = $1
     WHERE phone = $2 AND consumed_at IS NULL
  `, now, input.Phone)

  codeHash := hashOTP_HTTP(h.Config.AuthPepper, otpID, code)

  _, err = h.Pool.Exec(r.Context(), `
    INSERT INTO auth_otps (id, user_id, phone, code, code_hash, expires_at, created_at, attempts_remaining, send_ip)
    VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
  `, otpID, userID, input.Phone, nil, codeHash, expiresAt, now, h.Config.OTPMaxAttempts, sendIP)
  if err != nil {
    writeError_HTTP(w, http.StatusInternalServerError, "otp insert failed")
    return
  }

  var devCode string
  if h.Config.Env == "local" {
    devCode = code
  }
  writeJSON_HTTP(w, http.StatusOK, models.AuthStartResponse{
    OTPID:     otpID,
    ExpiresAt: expiresAt,
  })
}

func (h *HTTPAuthHandler) Verify(w http.ResponseWriter, r *http.Request) {
  var input models.AuthVerifyInput
  decoder := json.NewDecoder(r.Body)
  decoder.DisallowUnknownFields()
  if err := decoder.Decode(&input); err != nil {
    writeError_HTTP(w, http.StatusBadRequest, "invalid json")
    return
  }
  input.Phone = strings.TrimSpace(input.Phone)
  input.Code = strings.TrimSpace(input.Code)
  if !validatePhoneE164_HTTP(input.Phone) || input.Code == "" {
    writeError_HTTP(w, http.StatusBadRequest, "phone and code are required")
    return
  }
  if h.Config.AuthPepper == "" {
    writeError_HTTP(w, http.StatusInternalServerError, "auth not configured")
    return
  }

  var userID uuid.UUID
  var otpID string
  var expiresAt time.Time
  var codeHash string
  var attemptsRemaining int
  err := h.Pool.QueryRow(r.Context(), `
    SELECT id, user_id, expires_at, code_hash, attempts_remaining
      FROM auth_otps
     WHERE phone = $1 AND consumed_at IS NULL
      ORDER BY created_at DESC
      LIMIT 1
  `, input.Phone).Scan(&otpID, &userID, &expiresAt, &codeHash, &attemptsRemaining)
  if err != nil {
    writeError_HTTP(w, http.StatusUnauthorized, "invalid code")
    return
  }
  if time.Now().UTC().After(expiresAt) {
    writeError_HTTP(w, http.StatusUnauthorized, "code expired")
    return
  }
  if attemptsRemaining <= 0 {
    writeError_HTTP(w, http.StatusUnauthorized, "too many attempts")
    return
  }

  expectedHash := hashOTP_HTTP(h.Config.AuthPepper, otpID, input.Code)
  if !safeCompare_HTTP(codeHash, expectedHash) {
    _, _ = h.Pool.Exec(r.Context(), `
      UPDATE auth_otps
         SET attempts_remaining = GREATEST(attempts_remaining - 1, 0)
       WHERE id = $1
    `, otpID)
    writeError_HTTP(w, http.StatusUnauthorized, "invalid code")
    return
  }

  token, tokenHash, err := generateToken_HTTP()
  if err != nil {
    writeError_HTTP(w, http.StatusInternalServerError, "token generation failed")
    return
  }

  sessionID := uuid.New().String()
  sessionExpires := time.Now().UTC().Add(30 * 24 * time.Hour)

  _, err = h.Pool.Exec(r.Context(), `
    INSERT INTO sessions (id, user_id, token_hash, expires_at, created_at)
    VALUES ($1,$2,$3,$4,$5)
  `, sessionID, userID, tokenHash, sessionExpires, time.Now().UTC())
  if err != nil {
    writeError_HTTP(w, http.StatusInternalServerError, "session insert failed")
    return
  }

  _, _ = h.Pool.Exec(r.Context(), `
    UPDATE auth_otps
       SET consumed_at = $1, verify_ip = $2
     WHERE id = $3
  `, time.Now().UTC(), clientIP_HTTP(r), otpID)

  writeJSON_HTTP(w, http.StatusOK, models.AuthVerifyResponse{
    Token:     token,
    UserID:    userID.String(),
    ExpiresAt: sessionExpires,
  })
}

func (h *HTTPAuthHandler) ensureUser(r *http.Request, phone string) (uuid.UUID, error) {
  id := uuid.New()
  var userID uuid.UUID
  err := h.Pool.QueryRow(r.Context(), `
    INSERT INTO users (id, phone, created_at)
    VALUES ($1,$2,$3)
    ON CONFLICT (phone)
    DO UPDATE SET phone = EXCLUDED.phone
    RETURNING id
  `, id, phone, time.Now().UTC()).Scan(&userID)
  return userID, err
}

func (h *HTTPAuthHandler) enforceOTPSendLimits(r *http.Request, phone string) error {
  var recentCount int
  err := h.Pool.QueryRow(r.Context(), `
    SELECT COUNT(*)
      FROM auth_otps
     WHERE phone = $1 AND created_at > (now() - interval '1 hour')
  `, phone).Scan(&recentCount)
  if err != nil {
    return fmt.Errorf("otp limit check failed")
  }
  if recentCount >= h.Config.OTPMaxPerHour {
    return fmt.Errorf("too many otp requests")
  }

  ip := clientIP_HTTP(r)
  if ip != "" {
    var ipCount int
    err = h.Pool.QueryRow(r.Context(), `
      SELECT COUNT(*)
        FROM auth_otps
       WHERE send_ip = $1 AND created_at > (now() - interval '1 hour')
    `, ip).Scan(&ipCount)
    if err == nil && ipCount >= h.Config.OTPMaxPerIPPerHour {
      return fmt.Errorf("too many otp requests")
    }
  }

  var lastCreated time.Time
  err = h.Pool.QueryRow(r.Context(), `
    SELECT created_at
      FROM auth_otps
     WHERE phone = $1
     ORDER BY created_at DESC
     LIMIT 1
  `, phone).Scan(&lastCreated)
  if err == nil {
    if time.Since(lastCreated) < time.Duration(h.Config.OTPMinSecondsBetween)*time.Second {
      return fmt.Errorf("please wait before requesting another otp")
    }
  }
  return nil
}

func generateOTP_HTTP(length int) (string, error) {
  if length <= 0 {
    return "", fmt.Errorf("invalid otp length")
  }
  max := big.NewInt(10)
  buf := make([]byte, length)
  for i := 0; i < length; i++ {
    n, err := rand.Int(rand.Reader, max)
    if err != nil {
      return "", err
    }
    buf[i] = byte('0' + n.Int64())
  }
  return string(buf), nil
}

func generateToken_HTTP() (string, string, error) {
  raw := make([]byte, 32)
  if _, err := rand.Read(raw); err != nil {
    return "", "", err
  }
  token := base64.RawURLEncoding.EncodeToString(raw)
  return token, hashToken_HTTP(token), nil
}

func validatePhoneE164_HTTP(phone string) bool {
  re := regexp.MustCompile(`^\+[1-9]\d{7,14}$`)
  return re.MatchString(phone)
}

func hashOTP_HTTP(pepper, otpID, code string) string {
  sum := sha256.Sum256([]byte(pepper + ":" + otpID + ":" + code))
  return hex.EncodeToString(sum[:])
}

func safeCompare_HTTP(a, b string) bool {
  if len(a) != len(b) {
    return false
  }
  return subtle.ConstantTimeCompare([]byte(a), []byte(b)) == 1
}

func clientIP_HTTP(r *http.Request) string {
  if r.RemoteAddr == "" {
    return ""
  }
  host, _, err := net.SplitHostPort(r.RemoteAddr)
  if err == nil {
    return host
  }
  return r.RemoteAddr
}

func writeError_HTTP(w http.ResponseWriter, status int, message string) {
  w.WriteHeader(status)
  json.NewEncoder(w).Encode(map[string]string{"error": message})
}

func writeJSON_HTTP(w http.ResponseWriter, status int, data interface{}) {
  w.WriteHeader(status)
  json.NewEncoder(w).Encode(data)
}

func hashToken_HTTP(token string) string {
  sum := sha256.Sum256([]byte(token))
  return hex.EncodeToString(sum[:])
}
