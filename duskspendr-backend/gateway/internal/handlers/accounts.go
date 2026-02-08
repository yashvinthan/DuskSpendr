package handlers

import (
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"duskspendr-gateway/internal/models"
	"duskspendr-gateway/internal/services"
)

type AccountHandler struct {
	Pool    *pgxpool.Pool
	Service *services.AccountService
}

func NewAccountHandler(pool *pgxpool.Pool, service *services.AccountService) *AccountHandler {
	return &AccountHandler{
		Pool:    pool,
		Service: service,
	}
}

func (h *AccountHandler) List(c *fiber.Ctx) error {
	userID := c.Locals("userID").(string)

	rows, err := h.Pool.Query(c.Context(), `
    SELECT id, user_id, provider, account_number, account_name, upi_id,
           balance_paisa, status, last_synced_at, linked_at, provider_account_id
      FROM linked_accounts
     WHERE user_id = $1
     ORDER BY linked_at DESC
  `, userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Query failed",
		})
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
			&a.ProviderAccountID,
		); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Scan failed",
			})
		}
		items = append(items, a)
	}

	return c.JSON(fiber.Map{"items": items})
}

// Link initiates OAuth flow
func (h *AccountHandler) Link(c *fiber.Ctx) error {
	var req struct {
		Provider    string `json:"provider"`
		RedirectURI string `json:"redirect_uri"`
	}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid JSON",
		})
	}
	if req.Provider == "" || req.RedirectURI == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Provider and redirect_uri required",
		})
	}

	provider, err := h.Service.GetProvider(req.Provider)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	state := uuid.New().String()
	url, err := provider.InitiateLink(c.Context(), req.RedirectURI, state)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to initiate link",
		})
	}

	return c.JSON(fiber.Map{"url": url, "state": state})
}

// Callback handles OAuth callback
func (h *AccountHandler) Callback(c *fiber.Ctx) error {
	var req struct {
		Provider    string `json:"provider"`
		Code        string `json:"code"`
		RedirectURI string `json:"redirect_uri"`
	}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid JSON",
		})
	}

	provider, err := h.Service.GetProvider(req.Provider)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	tokens, err := provider.ExchangeToken(c.Context(), req.Code, req.RedirectURI)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Token exchange failed: " + err.Error(),
		})
	}

	// Encrypt tokens
	encAccess, err := h.Service.EncryptToken(tokens.AccessToken)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Encryption failed",
		})
	}
	encRefresh, err := h.Service.EncryptToken(tokens.RefreshToken)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Encryption failed",
		})
	}

	userID := c.Locals("userID").(string)

	id := uuid.New().String()
	now := time.Now().UTC()
	expiry := now.Add(time.Duration(tokens.ExpiresIn) * time.Second)

	_, err = h.Pool.Exec(c.Context(), `
		INSERT INTO linked_accounts (
			id, user_id, provider, status,
			access_token_enc, refresh_token_enc, token_expiry, provider_account_id,
			linked_at, last_synced_at
		) VALUES ($1, $2, $3, 'active', $4, $5, $6, $7, $8, $8)
	`, id, userID, req.Provider, encAccess, encRefresh, expiry, tokens.AccountID, now)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "DB save failed",
		})
	}

	return c.JSON(fiber.Map{"status": "linked", "id": id})
}

// Unlink revokes token
func (h *AccountHandler) Unlink(c *fiber.Ctx) error {
	userID := c.Locals("userID").(string)
	id := c.Params("id")

	// Ideally invoke provider revoke here

	cmd, err := h.Pool.Exec(c.Context(), `
    DELETE FROM linked_accounts
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

	return c.JSON(fiber.Map{"status": "unlinked"})
}

// Sync triggers manual sync for an account
func (h *AccountHandler) Sync(c *fiber.Ctx) error {
	id := c.Params("id")

	// Trigger sync logic (fetch transactions from provider and save to raw_transactions)
	// This would invoke h.Service.SyncAccount(ctx, id)
	// For now, just return OK
	return c.JSON(fiber.Map{"status": "sync_started", "id": id})
}
