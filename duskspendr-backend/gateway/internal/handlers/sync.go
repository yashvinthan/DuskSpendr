package handlers

import (
  "encoding/json"
  "net/http"
  "strings"
  "time"

  "github.com/google/uuid"
  "github.com/jackc/pgx/v5/pgxpool"

  "duskspendr-gateway/internal/models"
  "duskspendr-gateway/internal/serverpod"
)

type SyncHandler struct {
  Pool   *pgxpool.Pool
  Client *serverpod.Client
}

func (h *SyncHandler) SyncTransactions(w http.ResponseWriter, r *http.Request) {
  userID, ok := UserIDFromContext(r.Context())
  if !ok {
    writeError(w, http.StatusBadRequest, "missing user context")
    return
  }
  if h.Client == nil {
    writeError(w, http.StatusServiceUnavailable, "serverpod unavailable")
    return
  }

  payload, err := h.loadTransactions(r, userID.String())
  if err != nil {
    writeError(w, http.StatusInternalServerError, "failed to load transactions")
    return
  }
  ok = h.Client.SyncTransactions(r.Context(), userID.String(), payload)
  if !ok {
    writeError(w, http.StatusBadGateway, "sync failed")
    return
  }
  writeJSON(w, http.StatusOK, map[string]string{"status": "queued"})
}

func (h *SyncHandler) IngestTransactions(w http.ResponseWriter, r *http.Request) {
  userID, ok := UserIDFromContext(r.Context())
  if !ok {
    writeError(w, http.StatusBadRequest, "missing user context")
    return
  }

  decoder := json.NewDecoder(r.Body)
  decoder.DisallowUnknownFields()
  var input models.SyncIngestRequest
  if err := decoder.Decode(&input); err != nil {
    writeError(w, http.StatusBadRequest, "invalid json")
    return
  }

  if len(input.Items) == 0 {
    writeJSON(w, http.StatusOK, map[string]any{"inserted": 0})
    return
  }
  if len(input.Items) > 500 {
    writeError(w, http.StatusBadRequest, "too many items")
    return
  }

  now := time.Now().UTC()
  inserted := 0

  for _, item := range input.Items {
    if err := validateIngestItem(item); err != nil {
      writeError(w, http.StatusBadRequest, err.Error())
      return
    }
    if _, err := uuid.Parse(item.ID); err != nil {
      writeError(w, http.StatusBadRequest, "invalid id")
      return
    }
  }

  for _, item := range input.Items {
    tagsBytes, _ := json.Marshal(normalizeTags(item.Tags))

    var linkedAccountID *string
    if item.LinkedAccountID != nil && strings.TrimSpace(*item.LinkedAccountID) != "" {
      val := strings.TrimSpace(*item.LinkedAccountID)
      if _, err := uuid.Parse(val); err != nil {
        writeError(w, http.StatusBadRequest, "invalid linked_account_id")
        return
      }
      linkedAccountID = &val
    }

    cmd, err := h.Pool.Exec(r.Context(), `
      INSERT INTO transactions (
        id, user_id, amount_paisa, type, category, merchant_name, description,
        timestamp, source, payment_method, linked_account_id, reference_id,
        category_confidence, is_recurring, is_shared, tags, notes,
        created_at, updated_at
      ) VALUES (
        $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19
      )
      ON CONFLICT (id) DO UPDATE SET
        amount_paisa = EXCLUDED.amount_paisa,
        type = EXCLUDED.type,
        category = EXCLUDED.category,
        merchant_name = EXCLUDED.merchant_name,
        description = EXCLUDED.description,
        timestamp = EXCLUDED.timestamp,
        source = EXCLUDED.source,
        payment_method = EXCLUDED.payment_method,
        linked_account_id = EXCLUDED.linked_account_id,
        reference_id = EXCLUDED.reference_id,
        category_confidence = EXCLUDED.category_confidence,
        is_recurring = EXCLUDED.is_recurring,
        is_shared = EXCLUDED.is_shared,
        tags = EXCLUDED.tags,
        notes = EXCLUDED.notes,
        updated_at = EXCLUDED.updated_at
      WHERE transactions.user_id = EXCLUDED.user_id
    `,
      item.ID,
      userID,
      item.AmountPaisa,
      item.Type,
      item.Category,
      item.MerchantName,
      item.Description,
      item.Timestamp,
      item.Source,
      item.PaymentMethod,
      linkedAccountID,
      item.ReferenceID,
      item.CategoryConfidence,
      item.IsRecurring,
      item.IsShared,
      tagsBytes,
      item.Notes,
      now,
      now,
    )
    if err != nil {
      writeError(w, http.StatusInternalServerError, "insert failed")
      return
    }
    if cmd.RowsAffected() > 0 {
      inserted++
    }
  }

  writeJSON(w, http.StatusOK, map[string]any{"inserted": inserted})
}

func (h *SyncHandler) loadTransactions(r *http.Request, userID string) ([]byte, error) {
  rows, err := h.Pool.Query(r.Context(), `
    SELECT id, amount_paisa, type, category, merchant_name, description, timestamp, source
      FROM transactions
     WHERE user_id = $1
     ORDER BY timestamp DESC
     LIMIT 500
  `, userID)
  if err != nil {
    return nil, err
  }
  defer rows.Close()

  type tx struct {
    ID           string  `json:"id"`
    AmountPaisa  int64   `json:"amount_paisa"`
    Type         string  `json:"type"`
    Category     string  `json:"category"`
    MerchantName *string `json:"merchant_name,omitempty"`
    Description  *string `json:"description,omitempty"`
    Timestamp    string  `json:"timestamp"`
    Source       string  `json:"source"`
  }

  items := []tx{}
  for rows.Next() {
    var item tx
    var ts time.Time
    if err := rows.Scan(
      &item.ID,
      &item.AmountPaisa,
      &item.Type,
      &item.Category,
      &item.MerchantName,
      &item.Description,
      &ts,
      &item.Source,
    ); err != nil {
      return nil, err
    }
    item.Timestamp = ts.UTC().Format(time.RFC3339)
    items = append(items, item)
  }

  return json.Marshal(map[string]any{
    "items": items,
  })
}

func validateIngestItem(input models.SyncIngestItem) error {
  if input.ID == "" {
    return errInvalid("id is required")
  }
  if input.AmountPaisa == 0 {
    return errInvalid("amount_paisa is required")
  }
  if input.AmountPaisa < 0 || input.AmountPaisa > 10000000000 {
    return errInvalid("amount_paisa out of range")
  }
  if input.Type == "" {
    return errInvalid("type is required")
  }
  if input.Category == "" {
    return errInvalid("category is required")
  }
  if input.Source == "" {
    return errInvalid("source is required")
  }
  if input.Timestamp.IsZero() {
    return errInvalid("timestamp is required")
  }
  if err := validateIngestEnums(input); err != nil {
    return err
  }
  if err := validateIngestStrings(input); err != nil {
    return err
  }
  if err := validateIngestTags(input.Tags); err != nil {
    return err
  }
  if input.CategoryConfidence != nil {
    if *input.CategoryConfidence < 0 || *input.CategoryConfidence > 1 {
      return errInvalid("category_confidence out of range")
    }
  }
  if !validateIngestTimestamp(input.Timestamp) {
    return errInvalid("timestamp out of range")
  }
  return nil
}

func validateIngestEnums(input models.SyncIngestItem) error {
  allowedTypes := map[string]bool{"debit": true, "credit": true}
  allowedSources := map[string]bool{
    "manual": true,
    "sms": true,
    "upiNotification": true,
    "bankApi": true,
    "imported": true,
  }
  allowedCategories := map[string]bool{
    "food": true,
    "transportation": true,
    "entertainment": true,
    "education": true,
    "shopping": true,
    "utilities": true,
    "healthcare": true,
    "subscriptions": true,
    "investments": true,
    "loans": true,
    "shared": true,
    "pocketMoney": true,
    "other": true,
  }
  allowedPayments := map[string]bool{
    "upi": true,
    "card": true,
    "netBanking": true,
    "cash": true,
    "wallet": true,
    "bnpl": true,
  }

  if !allowedTypes[input.Type] {
    return errInvalid("invalid type")
  }
  if !allowedSources[input.Source] {
    return errInvalid("invalid source")
  }
  if !allowedCategories[input.Category] {
    return errInvalid("invalid category")
  }
  if input.PaymentMethod != nil && *input.PaymentMethod != "" {
    if !allowedPayments[*input.PaymentMethod] {
      return errInvalid("invalid payment_method")
    }
  }

  return nil
}

func validateIngestStrings(input models.SyncIngestItem) error {
  if input.MerchantName != nil && len(*input.MerchantName) > 120 {
    return errInvalid("merchant_name too long")
  }
  if input.Description != nil && len(*input.Description) > 500 {
    return errInvalid("description too long")
  }
  if input.ReferenceID != nil && len(*input.ReferenceID) > 100 {
    return errInvalid("reference_id too long")
  }
  if input.Notes != nil && len(*input.Notes) > 500 {
    return errInvalid("notes too long")
  }
  return nil
}

func validateIngestTags(tags []string) error {
  if tags == nil {
    return nil
  }
  if len(tags) > 20 {
    return errInvalid("too many tags")
  }
  for _, tag := range tags {
    if tag == "" {
      return errInvalid("invalid tag")
    }
    if len(tag) > 32 {
      return errInvalid("tag too long")
    }
  }
  return nil
}

func validateIngestTimestamp(ts time.Time) bool {
  now := time.Now().UTC()
  if ts.After(now.Add(24 * time.Hour)) {
    return false
  }
  if ts.Before(now.Add(-5 * 365 * 24 * time.Hour)) {
    return false
  }
  return true
}
