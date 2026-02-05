package handlers

import (
  "encoding/json"
  "net/http"
  "time"

  "github.com/go-chi/chi/v5"
  "github.com/google/uuid"
  "github.com/jackc/pgx/v5/pgxpool"

  "duskspendr-gateway/internal/models"
)

type BudgetHandler struct {
  Pool *pgxpool.Pool
}

func (h *BudgetHandler) List(w http.ResponseWriter, r *http.Request) {
  userID, ok := UserIDFromContext(r.Context())
  if !ok {
    writeError(w, http.StatusBadRequest, "missing user context")
    return
  }

  rows, err := h.Pool.Query(r.Context(), `
    SELECT id, user_id, name, limit_paisa, spent_paisa, period, category,
           alert_threshold, is_active, created_at, updated_at
      FROM budgets
     WHERE user_id = $1
     ORDER BY created_at DESC
  `, userID)
  if err != nil {
    writeError(w, http.StatusInternalServerError, "query failed")
    return
  }
  defer rows.Close()

  items := []models.Budget{}
  for rows.Next() {
    var b models.Budget
    if err := rows.Scan(
      &b.ID,
      &b.UserID,
      &b.Name,
      &b.LimitPaisa,
      &b.SpentPaisa,
      &b.Period,
      &b.Category,
      &b.AlertThreshold,
      &b.IsActive,
      &b.CreatedAt,
      &b.UpdatedAt,
    ); err != nil {
      writeError(w, http.StatusInternalServerError, "scan failed")
      return
    }
    items = append(items, b)
  }

  writeJSON(w, http.StatusOK, map[string]any{"items": items})
}

func (h *BudgetHandler) Create(w http.ResponseWriter, r *http.Request) {
  userID, ok := UserIDFromContext(r.Context())
  if !ok {
    writeError(w, http.StatusBadRequest, "missing user context")
    return
  }

  var input models.BudgetInput
  if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
    writeError(w, http.StatusBadRequest, "invalid json")
    return
  }
  if input.Name == "" {
    writeError(w, http.StatusBadRequest, "name is required")
    return
  }
  if input.LimitPaisa <= 0 {
    writeError(w, http.StatusBadRequest, "limit_paisa must be > 0")
    return
  }
  if input.Period == "" {
    writeError(w, http.StatusBadRequest, "period is required")
    return
  }

  alertThreshold := 0.8
  if input.AlertThreshold != nil {
    alertThreshold = *input.AlertThreshold
  }
  isActive := true
  if input.IsActive != nil {
    isActive = *input.IsActive
  }

  now := time.Now().UTC()
  id := uuid.New().String()

  _, err := h.Pool.Exec(r.Context(), `
    INSERT INTO budgets (
      id, user_id, name, limit_paisa, spent_paisa, period, category,
      alert_threshold, is_active, created_at, updated_at
    ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
  `,
    id,
    userID,
    input.Name,
    input.LimitPaisa,
    0,
    input.Period,
    input.Category,
    alertThreshold,
    isActive,
    now,
    now,
  )
  if err != nil {
    writeError(w, http.StatusInternalServerError, "insert failed")
    return
  }

  writeJSON(w, http.StatusCreated, map[string]string{"id": id})
}

func (h *BudgetHandler) Update(w http.ResponseWriter, r *http.Request) {
  userID, ok := UserIDFromContext(r.Context())
  if !ok {
    writeError(w, http.StatusBadRequest, "missing user context")
    return
  }
  id := chi.URLParam(r, "id")
  if id == "" {
    writeError(w, http.StatusBadRequest, "missing id")
    return
  }

  var input models.BudgetInput
  if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
    writeError(w, http.StatusBadRequest, "invalid json")
    return
  }
  if input.Name == "" {
    writeError(w, http.StatusBadRequest, "name is required")
    return
  }
  if input.LimitPaisa <= 0 {
    writeError(w, http.StatusBadRequest, "limit_paisa must be > 0")
    return
  }
  if input.Period == "" {
    writeError(w, http.StatusBadRequest, "period is required")
    return
  }

  alertThreshold := 0.8
  if input.AlertThreshold != nil {
    alertThreshold = *input.AlertThreshold
  }
  isActive := true
  if input.IsActive != nil {
    isActive = *input.IsActive
  }

  now := time.Now().UTC()

  cmd, err := h.Pool.Exec(r.Context(), `
    UPDATE budgets
       SET name = $1,
           limit_paisa = $2,
           period = $3,
           category = $4,
           alert_threshold = $5,
           is_active = $6,
           updated_at = $7
     WHERE user_id = $8 AND id = $9
  `,
    input.Name,
    input.LimitPaisa,
    input.Period,
    input.Category,
    alertThreshold,
    isActive,
    now,
    userID,
    id,
  )
  if err != nil {
    writeError(w, http.StatusInternalServerError, "update failed")
    return
  }
  if cmd.RowsAffected() == 0 {
    writeError(w, http.StatusNotFound, "not found")
    return
  }

  writeJSON(w, http.StatusOK, map[string]string{"status": "updated"})
}
