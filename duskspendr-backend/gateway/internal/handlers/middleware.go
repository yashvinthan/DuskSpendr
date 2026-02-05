package handlers

import (
  "context"
  "crypto/sha256"
  "encoding/hex"
  "encoding/json"
  "net/http"
  "strings"

  "github.com/google/uuid"
  "github.com/jackc/pgx/v5/pgxpool"
)

type ctxKey string

const userIDKey ctxKey = "user_id"

func UserIDFromContext(ctx context.Context) (uuid.UUID, bool) {
  v := ctx.Value(userIDKey)
  if v == nil {
    return uuid.UUID{}, false
  }
  id, ok := v.(uuid.UUID)
  return id, ok
}

func RequireUserID(pool *pgxpool.Pool) func(http.Handler) http.Handler {
  return func(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
      authHeader := r.Header.Get("Authorization")
      if authHeader == "" {
        writeError(w, http.StatusUnauthorized, "missing Authorization header")
        return
      }
      token := strings.TrimSpace(strings.TrimPrefix(authHeader, "Bearer"))
      if token == "" {
        writeError(w, http.StatusUnauthorized, "invalid Authorization header")
        return
      }

      tokenHash := hashToken(token)
      var userID uuid.UUID
      err := pool.QueryRow(r.Context(), `
        SELECT user_id
          FROM sessions
         WHERE token_hash = $1 AND expires_at > now()
      `, tokenHash).Scan(&userID)
      if err != nil {
        writeError(w, http.StatusUnauthorized, "invalid session")
        return
      }

      ctx := context.WithValue(r.Context(), userIDKey, userID)
      next.ServeHTTP(w, r.WithContext(ctx))
    })
  }
}

func hashToken(token string) string {
  sum := sha256.Sum256([]byte(token))
  return hex.EncodeToString(sum[:])
}

func writeJSON(w http.ResponseWriter, status int, v any) {
  w.Header().Set("Content-Type", "application/json")
  w.WriteHeader(status)
  _ = json.NewEncoder(w).Encode(v)
}

func writeError(w http.ResponseWriter, status int, msg string) {
  writeJSON(w, status, map[string]string{"error": msg})
}
