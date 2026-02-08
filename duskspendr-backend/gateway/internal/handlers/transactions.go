package handlers

import (
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"duskspendr-gateway/internal/models"
	"duskspendr-gateway/internal/queue"
)

type TransactionHandler struct {
	Pool *pgxpool.Pool
	MQ   *queue.Connection
}

func NewTransactionHandler(pool *pgxpool.Pool, mq *queue.Connection) *TransactionHandler {
	return &TransactionHandler{
		Pool: pool,
		MQ:   mq,
	}
}

func (h *TransactionHandler) List(c *fiber.Ctx) error {
	userID := c.Locals("userID").(string)

	queryText := c.Query("q")
	categoryFilter := c.Query("category")

	limit := c.QueryInt("limit", 50)
	if limit <= 0 || limit > 200 {
		limit = 50
	}
	offset := c.QueryInt("offset", 0)
	if offset < 0 {
		offset = 0
	}

	sql := `
    SELECT id, user_id, amount_paisa, type, category, merchant_name, description,
           timestamp, source, payment_method, linked_account_id, reference_id,
           category_confidence, is_recurring, is_shared, tags, notes,
           created_at, updated_at
      FROM raw_transactions
     WHERE user_id = $1`

	args := []any{userID}
	idx := 2
	if categoryFilter != "" {
		sql += " AND category = $" + strconv.Itoa(idx)
		args = append(args, categoryFilter)
		idx++
	}
	if queryText != "" {
		sql += " AND (lower(coalesce(merchant_name, '')) LIKE $" + strconv.Itoa(idx) +
			" OR lower(coalesce(description, '')) LIKE $" + strconv.Itoa(idx) + ")"
		args = append(args, "%"+strings.ToLower(queryText)+"%")
		idx++
	}

	sql += " ORDER BY timestamp DESC LIMIT $" + strconv.Itoa(idx)
	args = append(args, limit+1)
	idx++
	sql += " OFFSET $" + strconv.Itoa(idx)
	args = append(args, offset)

	rows, err := h.Pool.Query(c.Context(), sql, args...)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Query failed",
		})
	}
	defer rows.Close()

	items := make([]models.RawTransaction, 0, limit)
	for rows.Next() {
		var t models.RawTransaction
		var tagsRaw []byte
		if err := rows.Scan(
			&t.ID,
			&t.UserID,
			&t.AmountPaisa,
			&t.Type,
			&t.Category,
			&t.MerchantName,
			&t.Description,
			&t.Timestamp,
			&t.Source,
			&t.PaymentMethod,
			&t.LinkedAccountID,
			&t.ReferenceID,
			&t.CategoryConfidence,
			&t.IsRecurring,
			&t.IsShared,
			&tagsRaw,
			&t.Notes,
			&t.CreatedAt,
			&t.UpdatedAt,
		); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Scan failed",
			})
		}
		t.Tags = decodeTags(tagsRaw)
		items = append(items, t)
	}

	nextOffset := 0
	if len(items) > limit {
		items = items[:limit]
		nextOffset = offset + limit
	}

	resp := fiber.Map{"items": items}
	if nextOffset > 0 {
		resp["next_offset"] = nextOffset
	}

	return c.JSON(resp)
}

func (h *TransactionHandler) Get(c *fiber.Ctx) error {
	userID := c.Locals("userID").(string)
	id := c.Params("id")

	var t models.RawTransaction
	var tagsRaw []byte
	err := h.Pool.QueryRow(c.Context(), `
    SELECT id, user_id, amount_paisa, type, category, merchant_name, description,
           timestamp, source, payment_method, linked_account_id, reference_id,
           category_confidence, is_recurring, is_shared, tags, notes,
           created_at, updated_at
      FROM raw_transactions
     WHERE user_id = $1 AND id = $2
  `, userID, id).Scan(
		&t.ID,
		&t.UserID,
		&t.AmountPaisa,
		&t.Type,
		&t.Category,
		&t.MerchantName,
		&t.Description,
		&t.Timestamp,
		&t.Source,
		&t.PaymentMethod,
		&t.LinkedAccountID,
		&t.ReferenceID,
		&t.CategoryConfidence,
		&t.IsRecurring,
		&t.IsShared,
		&tagsRaw,
		&t.Notes,
		&t.CreatedAt,
		&t.UpdatedAt,
	)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Not found",
		})
	}
	t.Tags = decodeTags(tagsRaw)

	return c.JSON(t)
}

func (h *TransactionHandler) Create(c *fiber.Ctx) error {
	userID := c.Locals("userID").(string)

	var input models.TransactionInput
	if err := c.BodyParser(&input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid JSON",
		})
	}
	if err := validateTransactionInput(input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	now := time.Now().UTC()
	id := uuid.New().String()
	tagsBytes, _ := json.Marshal(normalizeTags(input.Tags))

	_, err := h.Pool.Exec(c.Context(), `
    INSERT INTO raw_transactions (
      id, user_id, amount_paisa, type, category, merchant_name, description,
      timestamp, source, payment_method, linked_account_id, reference_id,
      category_confidence, is_recurring, is_shared, tags, notes,
      created_at, updated_at
    ) VALUES (
      $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19
    )
  `,
		id,
		userID,
		input.AmountPaisa,
		input.Type,
		input.Category,
		input.MerchantName,
		input.Description,
		input.Timestamp,
		input.Source,
		input.PaymentMethod,
		input.LinkedAccountID,
		input.ReferenceID,
		input.CategoryConfidence,
		input.IsRecurring,
		input.IsShared,
		tagsBytes,
		input.Notes,
		now,
		now,
	)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Insert failed",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"id": id})
}

func (h *TransactionHandler) Update(c *fiber.Ctx) error {
	userID := c.Locals("userID").(string)
	id := c.Params("id")

	var input models.TransactionInput
	if err := c.BodyParser(&input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid JSON",
		})
	}
	if err := validateTransactionInput(input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	now := time.Now().UTC()
	tagsBytes, _ := json.Marshal(normalizeTags(input.Tags))

	cmd, err := h.Pool.Exec(c.Context(), `
    UPDATE raw_transactions
       SET amount_paisa = $1,
           type = $2,
           category = $3,
           merchant_name = $4,
           description = $5,
           timestamp = $6,
           source = $7,
           payment_method = $8,
           linked_account_id = $9,
           reference_id = $10,
           category_confidence = $11,
           is_recurring = $12,
           is_shared = $13,
           tags = $14,
           notes = $15,
           updated_at = $16
     WHERE user_id = $17 AND id = $18
  `,
		input.AmountPaisa,
		input.Type,
		input.Category,
		input.MerchantName,
		input.Description,
		input.Timestamp,
		input.Source,
		input.PaymentMethod,
		input.LinkedAccountID,
		input.ReferenceID,
		input.CategoryConfidence,
		input.IsRecurring,
		input.IsShared,
		tagsBytes,
		input.Notes,
		now,
		userID,
		id,
	)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Update failed",
		})
	}
	if cmd.RowsAffected() == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Not found",
		})
	}

	return c.JSON(fiber.Map{"status": "updated"})
}

func (h *TransactionHandler) Delete(c *fiber.Ctx) error {
	userID := c.Locals("userID").(string)
	id := c.Params("id")

	cmd, err := h.Pool.Exec(c.Context(), `
    DELETE FROM raw_transactions
     WHERE user_id = $1 AND id = $2
  `, userID, id)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Delete failed",
		})
	}
	if cmd.RowsAffected() == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Not found",
		})
	}

	return c.JSON(fiber.Map{"status": "deleted"})
}

// Sync triggers sync logic
func (h *TransactionHandler) Sync(c *fiber.Ctx) error {
	// TODO: Implement sync logic
	return c.JSON(fiber.Map{"status": "sync_started"})
}

// Helper methods needed for compiling
func (h *TransactionHandler) ListHttp(w http.ResponseWriter, r *http.Request) {
	userID, ok := UserIDFromContext(r.Context())
	if !ok {
		writeError(w, http.StatusBadRequest, "missing user context")
		return
	}

	queryText := r.URL.Query().Get("q")
	categoryFilter := r.URL.Query().Get("category")

	limit := 50
	if v := r.URL.Query().Get("limit"); v != "" {
		if n, err := strconv.Atoi(v); err == nil {
			if n > 0 && n <= 200 {
				limit = n
			}
		}
	}
	offset := 0
	if v := r.URL.Query().Get("offset"); v != "" {
		if n, err := strconv.Atoi(v); err == nil && n >= 0 {
			offset = n
		}
	}

	sql := `
    SELECT id, user_id, amount_paisa, type, category, merchant_name, description,
           timestamp, source, payment_method, linked_account_id, reference_id,
           category_confidence, is_recurring, is_shared, tags, notes,
           created_at, updated_at
      FROM raw_transactions
     WHERE user_id = $1`

	args := []any{userID}
	idx := 2
	if categoryFilter != "" {
		sql += " AND category = $" + strconv.Itoa(idx)
		args = append(args, categoryFilter)
		idx++
	}
	if queryText != "" {
		sql += " AND (lower(coalesce(merchant_name, '')) LIKE $" + strconv.Itoa(idx) +
			" OR lower(coalesce(description, '')) LIKE $" + strconv.Itoa(idx) + ")"
		args = append(args, "%"+strings.ToLower(queryText)+"%")
		idx++
	}

	sql += " ORDER BY timestamp DESC LIMIT $" + strconv.Itoa(idx)
	args = append(args, limit+1)
	idx++
	sql += " OFFSET $" + strconv.Itoa(idx)
	args = append(args, offset)

	rows, err := h.Pool.Query(r.Context(), sql, args...)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "query failed")
		return
	}
	defer rows.Close()

	items := make([]models.RawTransaction, 0, limit)
	for rows.Next() {
		var t models.RawTransaction
		var tagsRaw []byte
		if err := rows.Scan(
			&t.ID,
			&t.UserID,
			&t.AmountPaisa,
			&t.Type,
			&t.Category,
			&t.MerchantName,
			&t.Description,
			&t.Timestamp,
			&t.Source,
			&t.PaymentMethod,
			&t.LinkedAccountID,
			&t.ReferenceID,
			&t.CategoryConfidence,
			&t.IsRecurring,
			&t.IsShared,
			&tagsRaw,
			&t.Notes,
			&t.CreatedAt,
			&t.UpdatedAt,
		); err != nil {
			writeError(w, http.StatusInternalServerError, "scan failed")
			return
		}
		t.Tags = decodeTags(tagsRaw)
		items = append(items, t)
	}

	nextOffset := 0
	if len(items) > limit {
		items = items[:limit]
		nextOffset = offset + limit
	}

	resp := map[string]any{"items": items}
	if nextOffset > 0 {
		resp["next_offset"] = nextOffset
	}

	writeJSON(w, http.StatusOK, resp)
}

func (h *TransactionHandler) GetHttp(w http.ResponseWriter, r *http.Request) {
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

	var t models.RawTransaction
	var tagsRaw []byte
	err := h.Pool.QueryRow(r.Context(), `
    SELECT id, user_id, amount_paisa, type, category, merchant_name, description,
           timestamp, source, payment_method, linked_account_id, reference_id,
           category_confidence, is_recurring, is_shared, tags, notes,
           created_at, updated_at
      FROM raw_transactions
     WHERE user_id = $1 AND id = $2
  `, userID, id).Scan(
		&t.ID,
		&t.UserID,
		&t.AmountPaisa,
		&t.Type,
		&t.Category,
		&t.MerchantName,
		&t.Description,
		&t.Timestamp,
		&t.Source,
		&t.PaymentMethod,
		&t.LinkedAccountID,
		&t.ReferenceID,
		&t.CategoryConfidence,
		&t.IsRecurring,
		&t.IsShared,
		&tagsRaw,
		&t.Notes,
		&t.CreatedAt,
		&t.UpdatedAt,
	)
	if err != nil {
		writeError(w, http.StatusNotFound, "not found")
		return
	}
	t.Tags = decodeTags(tagsRaw)

	writeJSON(w, http.StatusOK, t)
}

func (h *TransactionHandler) CreateHttp(w http.ResponseWriter, r *http.Request) {
	userID, ok := UserIDFromContext(r.Context())
	if !ok {
		writeError(w, http.StatusBadRequest, "missing user context")
		return
	}

	var input models.TransactionInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, http.StatusBadRequest, "invalid json")
		return
	}
	if err := validateTransactionInput(input); err != nil {
		writeError(w, http.StatusBadRequest, err.Error())
		return
	}

	now := time.Now().UTC()
	id := uuid.New().String()
	tagsBytes, _ := json.Marshal(normalizeTags(input.Tags))

	_, err := h.Pool.Exec(r.Context(), `
    INSERT INTO raw_transactions (
      id, user_id, amount_paisa, type, category, merchant_name, description,
      timestamp, source, payment_method, linked_account_id, reference_id,
      category_confidence, is_recurring, is_shared, tags, notes,
      created_at, updated_at
    ) VALUES (
      $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19
    )
  `,
		id,
		userID,
		input.AmountPaisa,
		input.Type,
		input.Category,
		input.MerchantName,
		input.Description,
		input.Timestamp,
		input.Source,
		input.PaymentMethod,
		input.LinkedAccountID,
		input.ReferenceID,
		input.CategoryConfidence,
		input.IsRecurring,
		input.IsShared,
		tagsBytes,
		input.Notes,
		now,
		now,
	)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "insert failed")
		return
	}

	writeJSON(w, http.StatusCreated, map[string]string{"id": id})
}

func (h *TransactionHandler) UpdateHttp(w http.ResponseWriter, r *http.Request) {
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

	var input models.TransactionInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, http.StatusBadRequest, "invalid json")
		return
	}
	if err := validateTransactionInput(input); err != nil {
		writeError(w, http.StatusBadRequest, err.Error())
		return
	}

	now := time.Now().UTC()
	tagsBytes, _ := json.Marshal(normalizeTags(input.Tags))

	cmd, err := h.Pool.Exec(r.Context(), `
    UPDATE raw_transactions
       SET amount_paisa = $1,
           type = $2,
           category = $3,
           merchant_name = $4,
           description = $5,
           timestamp = $6,
           source = $7,
           payment_method = $8,
           linked_account_id = $9,
           reference_id = $10,
           category_confidence = $11,
           is_recurring = $12,
           is_shared = $13,
           tags = $14,
           notes = $15,
           updated_at = $16
     WHERE user_id = $17 AND id = $18
  `,
		input.AmountPaisa,
		input.Type,
		input.Category,
		input.MerchantName,
		input.Description,
		input.Timestamp,
		input.Source,
		input.PaymentMethod,
		input.LinkedAccountID,
		input.ReferenceID,
		input.CategoryConfidence,
		input.IsRecurring,
		input.IsShared,
		tagsBytes,
		input.Notes,
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

func (h *TransactionHandler) DeleteHttp(w http.ResponseWriter, r *http.Request) {
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

	cmd, err := h.Pool.Exec(r.Context(), `
    DELETE FROM raw_transactions
     WHERE user_id = $1 AND id = $2
  `, userID, id)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "delete failed")
		return
	}
	if cmd.RowsAffected() == 0 {
		writeError(w, http.StatusNotFound, "not found")
		return
	}

	writeJSON(w, http.StatusOK, map[string]string{"status": "deleted"})
}

func validateTransactionInput(input models.TransactionInput) error {
	if input.AmountPaisa == 0 {
		return errInvalid("amount_paisa is required")
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
	return nil
}

func normalizeTags(tags []string) []string {
	if tags == nil {
		return []string{}
	}
	return tags
}

func decodeTags(raw []byte) []string {
	if len(raw) == 0 {
		return []string{}
	}
	var tags []string
	if err := json.Unmarshal(raw, &tags); err != nil {
		return []string{}
	}
	return tags
}

type invalidError struct{ msg string }

func (e invalidError) Error() string { return e.msg }

func errInvalid(msg string) error { return invalidError{msg: msg} }
