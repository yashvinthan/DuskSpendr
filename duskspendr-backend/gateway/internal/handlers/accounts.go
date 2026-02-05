package handlers

import (
  "encoding/json"
  "net/http"
  "time"

  "github.com/google/uuid"
  "github.com/jackc/pgx/v5/pgxpool"

  "duskspendr-gateway/internal/models"
)

type AccountHandler struct {
  Pool *pgxpool.Pool
}

func (h *AccountHandler) List(w http.ResponseWriter, r *http.Request) {
  userID, ok := UserIDFromContext(r.Context())
  if !ok {
    writeError(w, http.StatusBadRequest, "missing user context")
    return
  }

  rows, err := h.Pool.Query(r.Context(), `
    SELECT id, user_id, provider, account_number, account_name, upi_id,
           balance_paisa, status, last_synced_at, linked_at
      FROM linked_accounts
     WHERE user_id = $1
     ORDER BY linked_at DESC
  `, userID)
  if err != nil {
    writeError(w, http.StatusInternalServerError, "query failed")
    return
  }
  defer rows.Close()

  items := []models.LinkedAccount{}
  for rows.Next() {
    var a models.LinkedAccount
    if err := rows.Scan(
      &a.ID,
      &a.UserID,
      &a.Provider,
      &a.AccountNumber,
      &a.AccountName,
      &a.UpiID,
      &a.BalancePaisa,
      &a.Status,
      &a.LastSyncedAt,
      &a.LinkedAt,
    ); err != nil {
      writeError(w, http.StatusInternalServerError, "scan failed")
      return
    }
    items = append(items, a)
  }

  writeJSON(w, http.StatusOK, map[string]any{"items": items})
}

func (h *AccountHandler) Create(w http.ResponseWriter, r *http.Request) {
  userID, ok := UserIDFromContext(r.Context())
  if !ok {
    writeError(w, http.StatusBadRequest, "missing user context")
    return
  }

  var input models.LinkedAccountInput
  if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
    writeError(w, http.StatusBadRequest, "invalid json")
    return
  }
  if input.Provider == "" {
    writeError(w, http.StatusBadRequest, "provider is required")
    return
  }
  if input.Status == "" {
    writeError(w, http.StatusBadRequest, "status is required")
    return
  }

  now := time.Now().UTC()
  id := uuid.New().String()

  _, err := h.Pool.Exec(r.Context(), `
    INSERT INTO linked_accounts (
      id, user_id, provider, account_number, account_name, upi_id,
      balance_paisa, status, last_synced_at, linked_at
    ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
  `,
    id,
    userID,
    input.Provider,
    input.AccountNumber,
    input.AccountName,
    input.UpiID,
    input.BalancePaisa,
    input.Status,
    now,
    now,
  )
  if err != nil {
    writeError(w, http.StatusInternalServerError, "insert failed")
    return
  }

  writeJSON(w, http.StatusCreated, map[string]string{"id": id})
}
