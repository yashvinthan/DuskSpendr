// Package handlers provides Fiber HTTP handlers for the gateway
package handlers

import (
	"crypto/rand"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"math/big"
	"regexp"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"duskspendr/gateway/internal/config"
	"duskspendr/gateway/internal/services"
)

// AuthHandler handles authentication endpoints
type AuthHandler struct {
	Pool       *pgxpool.Pool
	Config     config.Config
	JWTService *services.JWTService
}

// NewAuthHandler creates a new auth handler
func NewAuthHandler(pool *pgxpool.Pool, cfg config.Config, jwtSvc *services.JWTService) *AuthHandler {
	return &AuthHandler{
		Pool:       pool,
		Config:     cfg,
		JWTService: jwtSvc,
	}
}

// AuthStartRequest represents the OTP start request
type AuthStartRequest struct {
	Phone string `json:"phone"`
}

// AuthStartResponse represents the OTP start response
type AuthStartResponse struct {
	OTPID     string    `json:"otp_id"`
	ExpiresAt time.Time `json:"expires_at"`
	DevCode   string    `json:"dev_code,omitempty"` // Only in development
}

// AuthVerifyRequest represents the OTP verify request
type AuthVerifyRequest struct {
	Phone string `json:"phone"`
	Code  string `json:"code"`
}

// AuthVerifyResponse represents the OTP verify response
type AuthVerifyResponse struct {
	AccessToken  string    `json:"access_token"`
	RefreshToken string    `json:"refresh_token"`
	UserID       string    `json:"user_id"`
	ExpiresIn    int       `json:"expires_in"`
	ExpiresAt    time.Time `json:"expires_at"`
}

// RefreshRequest represents the token refresh request
type RefreshRequest struct {
	RefreshToken string `json:"refresh_token"`
}

// RefreshResponse represents the token refresh response
type RefreshResponse struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	ExpiresIn    int    `json:"expires_in"`
}

// LogoutRequest represents the logout request
type LogoutRequest struct {
	RefreshToken string `json:"refresh_token"`
}

// Start initiates OTP authentication
func (h *AuthHandler) Start(c *fiber.Ctx) error {
	var req AuthStartRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_REQUEST", "message": "Invalid JSON body"},
		})
	}

	req.Phone = strings.TrimSpace(req.Phone)
	if !validatePhoneE164(req.Phone) {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_PHONE", "message": "Phone must be in E.164 format"},
		})
	}

	if h.Config.AuthPepper == "" {
		return c.Status(500).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "CONFIG_ERROR", "message": "Auth not configured"},
		})
	}

	// Enforce rate limits
	if err := h.enforceOTPSendLimits(c, req.Phone); err != nil {
		return c.Status(429).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "RATE_LIMITED", "message": err.Error()},
		})
	}

	// Ensure user exists
	userID, err := h.ensureUser(c, req.Phone)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "USER_ERROR", "message": "Failed to create user"},
		})
	}

	// Generate OTP
	code, err := generateOTP(6)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "OTP_ERROR", "message": "Failed to generate OTP"},
		})
	}

	otpID := uuid.New().String()
	expiresAt := time.Now().UTC().Add(5 * time.Minute)
	now := time.Now().UTC()
	sendIP := c.IP()

	// Invalidate previous OTPs
	_, _ = h.Pool.Exec(c.Context(), `
		UPDATE auth_otps SET consumed_at = $1 WHERE phone = $2 AND consumed_at IS NULL
	`, now, req.Phone)

	// Hash the OTP
	codeHash := hashOTP(h.Config.AuthPepper, otpID, code)

	// Store new OTP
	_, err = h.Pool.Exec(c.Context(), `
		INSERT INTO auth_otps (id, user_id, phone, code_hash, expires_at, created_at, attempts_remaining, send_ip)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`, otpID, userID, req.Phone, codeHash, expiresAt, now, h.Config.OTPMaxAttempts, sendIP)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "DB_ERROR", "message": "Failed to store OTP"},
		})
	}

	// In dev mode, return the code
	var devCode string
	if h.Config.Env == "local" || h.Config.Env == "development" {
		devCode = code
	}

	// TODO: Send OTP via SMS service

	return c.JSON(fiber.Map{
		"success": true,
		"data": AuthStartResponse{
			OTPID:     otpID,
			ExpiresAt: expiresAt,
			DevCode:   devCode,
		},
	})
}

// Verify validates OTP and returns tokens
func (h *AuthHandler) Verify(c *fiber.Ctx) error {
	var req AuthVerifyRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_REQUEST", "message": "Invalid JSON body"},
		})
	}

	req.Phone = strings.TrimSpace(req.Phone)
	req.Code = strings.TrimSpace(req.Code)

	if !validatePhoneE164(req.Phone) || req.Code == "" {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_INPUT", "message": "Phone and code are required"},
		})
	}

	// Get the latest OTP for this phone
	var userID uuid.UUID
	var otpID string
	var expiresAt time.Time
	var codeHash string
	var attemptsRemaining int

	err := h.Pool.QueryRow(c.Context(), `
		SELECT id, user_id, expires_at, code_hash, attempts_remaining
		FROM auth_otps
		WHERE phone = $1 AND consumed_at IS NULL
		ORDER BY created_at DESC
		LIMIT 1
	`, req.Phone).Scan(&otpID, &userID, &expiresAt, &codeHash, &attemptsRemaining)

	if err != nil {
		return c.Status(401).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_CODE", "message": "Invalid or expired code"},
		})
	}

	if time.Now().UTC().After(expiresAt) {
		return c.Status(401).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "CODE_EXPIRED", "message": "Code has expired"},
		})
	}

	if attemptsRemaining <= 0 {
		return c.Status(401).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "MAX_ATTEMPTS", "message": "Too many failed attempts"},
		})
	}

	// Verify the code
	expectedHash := hashOTP(h.Config.AuthPepper, otpID, req.Code)
	if !safeCompare(codeHash, expectedHash) {
		// Decrement attempts
		_, _ = h.Pool.Exec(c.Context(), `
			UPDATE auth_otps SET attempts_remaining = GREATEST(attempts_remaining - 1, 0) WHERE id = $1
		`, otpID)

		return c.Status(401).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_CODE", "message": "Invalid code"},
		})
	}

	// Get user email for JWT
	var email *string
	_ = h.Pool.QueryRow(c.Context(), `SELECT email FROM users WHERE id = $1`, userID).Scan(&email)

	userEmail := ""
	if email != nil {
		userEmail = *email
	}

	// Generate JWT tokens
	tokenPair, err := h.JWTService.GenerateTokenPair(userID.String(), userEmail, req.Phone)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "TOKEN_ERROR", "message": "Failed to generate tokens"},
		})
	}

	// Mark OTP as consumed
	_, _ = h.Pool.Exec(c.Context(), `
		UPDATE auth_otps SET consumed_at = $1, verify_ip = $2 WHERE id = $3
	`, time.Now().UTC(), c.IP(), otpID)

	return c.JSON(fiber.Map{
		"success": true,
		"data": AuthVerifyResponse{
			AccessToken:  tokenPair.AccessToken,
			RefreshToken: tokenPair.RefreshToken,
			UserID:       userID.String(),
			ExpiresIn:    int(tokenPair.ExpiresIn.Seconds()),
			ExpiresAt:    tokenPair.ExpiresAt,
		},
	})
}

// Refresh exchanges a refresh token for new tokens
func (h *AuthHandler) Refresh(c *fiber.Ctx) error {
	var req RefreshRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_REQUEST", "message": "Invalid JSON body"},
		})
	}

	if req.RefreshToken == "" {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "MISSING_TOKEN", "message": "Refresh token is required"},
		})
	}

	// Validate and refresh tokens
	tokenPair, err := h.JWTService.RefreshTokens(c.Context(), req.RefreshToken)
	if err != nil {
		if err == services.ErrTokenBlacklisted {
			return c.Status(401).JSON(fiber.Map{
				"success": false,
				"error":   fiber.Map{"code": "TOKEN_REVOKED", "message": "Refresh token has been revoked"},
			})
		}
		return c.Status(401).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_TOKEN", "message": "Invalid or expired refresh token"},
		})
	}

	return c.JSON(fiber.Map{
		"success": true,
		"data": RefreshResponse{
			AccessToken:  tokenPair.AccessToken,
			RefreshToken: tokenPair.RefreshToken,
			ExpiresIn:    int(tokenPair.ExpiresIn.Seconds()),
		},
	})
}

// Logout invalidates the user's session
func (h *AuthHandler) Logout(c *fiber.Ctx) error {
	// Get user ID from context (set by auth middleware)
	userID := c.Locals("user_id")
	if userID == nil {
		return c.Status(401).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "UNAUTHORIZED", "message": "Not authenticated"},
		})
	}

	// Invalidate refresh token if provided
	var req LogoutRequest
	if err := c.BodyParser(&req); err == nil && req.RefreshToken != "" {
		_ = h.JWTService.InvalidateToken(c.Context(), req.RefreshToken)
	}

	// Invalidate access token from header
	authHeader := c.Get("Authorization")
	parts := strings.Split(authHeader, " ")
	if len(parts) == 2 && strings.ToLower(parts[0]) == "bearer" {
		_ = h.JWTService.InvalidateToken(c.Context(), parts[1])
	}

	return c.JSON(fiber.Map{
		"success": true,
		"data":    fiber.Map{"message": "Logged out successfully"},
	})
}

// ensureUser creates or retrieves a user by phone
func (h *AuthHandler) ensureUser(c *fiber.Ctx, phone string) (uuid.UUID, error) {
	id := uuid.New()
	var userID uuid.UUID
	err := h.Pool.QueryRow(c.Context(), `
		INSERT INTO users (id, phone, created_at)
		VALUES ($1, $2, $3)
		ON CONFLICT (phone) DO UPDATE SET phone = EXCLUDED.phone
		RETURNING id
	`, id, phone, time.Now().UTC()).Scan(&userID)
	return userID, err
}

// enforceOTPSendLimits checks rate limits for OTP sending
func (h *AuthHandler) enforceOTPSendLimits(c *fiber.Ctx, phone string) error {
	// Check per-phone limit
	var recentCount int
	err := h.Pool.QueryRow(c.Context(), `
		SELECT COUNT(*) FROM auth_otps WHERE phone = $1 AND created_at > (now() - interval '1 hour')
	`, phone).Scan(&recentCount)
	if err != nil {
		return fmt.Errorf("rate limit check failed")
	}
	if recentCount >= h.Config.OTPMaxPerHour {
		return fmt.Errorf("too many OTP requests, please try again later")
	}

	// Check per-IP limit
	ip := c.IP()
	if ip != "" {
		var ipCount int
		err = h.Pool.QueryRow(c.Context(), `
			SELECT COUNT(*) FROM auth_otps WHERE send_ip = $1 AND created_at > (now() - interval '1 hour')
		`, ip).Scan(&ipCount)
		if err == nil && ipCount >= h.Config.OTPMaxPerIPPerHour {
			return fmt.Errorf("too many OTP requests from this IP")
		}
	}

	// Check minimum time between OTPs
	var lastCreated time.Time
	err = h.Pool.QueryRow(c.Context(), `
		SELECT created_at FROM auth_otps WHERE phone = $1 ORDER BY created_at DESC LIMIT 1
	`, phone).Scan(&lastCreated)
	if err == nil {
		if time.Since(lastCreated) < time.Duration(h.Config.OTPMinSecondsBetween)*time.Second {
			return fmt.Errorf("please wait before requesting another OTP")
		}
	}

	return nil
}

// Helper functions

func generateOTP(length int) (string, error) {
	if length <= 0 {
		return "", fmt.Errorf("invalid OTP length")
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

func validatePhoneE164(phone string) bool {
	re := regexp.MustCompile(`^\+[1-9]\d{7,14}$`)
	return re.MatchString(phone)
}

func hashOTP(pepper, otpID, code string) string {
	sum := sha256.Sum256([]byte(pepper + ":" + otpID + ":" + code))
	return hex.EncodeToString(sum[:])
}

func safeCompare(a, b string) bool {
	if len(a) != len(b) {
		return false
	}
	return subtle.ConstantTimeCompare([]byte(a), []byte(b)) == 1
}

func hashToken(token string) string {
	sum := sha256.Sum256([]byte(token))
	return hex.EncodeToString(sum[:])
}

func generateToken() (string, string, error) {
	raw := make([]byte, 32)
	if _, err := rand.Read(raw); err != nil {
		return "", "", err
	}
	token := base64.RawURLEncoding.EncodeToString(raw)
	return token, hashToken(token), nil
}
