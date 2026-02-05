package handlers

import (
  "encoding/json"
  "net/http"
  "time"

  "github.com/google/uuid"
  "github.com/jackc/pgx/v5/pgxpool"

  "duskspendr-gateway/internal/models"
)

type UserHandler struct {
  Pool *pgxpool.Pool
}

func (h *UserHandler) Create(w http.ResponseWriter, r *http.Request) {
  var input models.UserInput
  if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
    writeError(w, http.StatusBadRequest, "invalid json")
    return
  }
  if input.Phone == "" {
    writeError(w, http.StatusBadRequest, "phone is required")
    return
  }

  id := uuid.New().String()
  now := time.Now().UTC()
  var createdAt time.Time
  var userID string

  err := h.Pool.QueryRow(r.Context(), `
    INSERT INTO users (id, phone, created_at)
    VALUES ($1, $2, $3)
    ON CONFLICT (phone)
    DO UPDATE SET phone = EXCLUDED.phone
    RETURNING id, created_at
  `, id, input.Phone, now).Scan(&userID, &createdAt)
  if err != nil {
    writeError(w, http.StatusInternalServerError, "insert failed")
    return
  }

  writeJSON(w, http.StatusCreated, models.User{
    ID:        userID,
    Phone:     input.Phone,
    CreatedAt: createdAt,
  })
}
