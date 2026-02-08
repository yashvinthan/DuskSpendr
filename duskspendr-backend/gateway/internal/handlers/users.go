package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"duskspendr-gateway/internal/models"
)

type UserHandler struct {
	Pool *pgxpool.Pool
}

func NewUserHandler(pool *pgxpool.Pool) *UserHandler {
	return &UserHandler{
		Pool: pool,
	}
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

// GetProfile returns the current user's profile
func (h *UserHandler) GetProfile(c *fiber.Ctx) error {
	userID := c.Locals("userID").(string)

	var user models.User
	err := h.Pool.QueryRow(c.Context(), `
    SELECT id, phone, created_at
    FROM users
    WHERE id = $1
  `, userID).Scan(&user.ID, &user.Phone, &user.CreatedAt)

	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "User not found",
		})
	}

	return c.JSON(user)
}

// UpdateProfile updates the current user's profile
func (h *UserHandler) UpdateProfile(c *fiber.Ctx) error {
	// TODO: Implement profile update logic
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Profile updated",
	})
}

// GetPreferences returns the current user's preferences
func (h *UserHandler) GetPreferences(c *fiber.Ctx) error {
	// TODO: Implement preferences retrieval logic
	return c.JSON(fiber.Map{})
}

// UpdatePreferences updates the current user's preferences
func (h *UserHandler) UpdatePreferences(c *fiber.Ctx) error {
	// TODO: Implement preferences update logic
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Preferences updated",
	})
}
