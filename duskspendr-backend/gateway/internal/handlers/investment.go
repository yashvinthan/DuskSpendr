package handlers

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"

	"github.com/gofiber/fiber/v2"

	"duskspendr/gateway/internal/config"
)

// InvestmentHandler handles investment platform integrations
type InvestmentHandler struct {
	Config config.Config
}

// NewInvestmentHandler creates a new investment handler
func NewInvestmentHandler(cfg config.Config) *InvestmentHandler {
	return &InvestmentHandler{
		Config: cfg,
	}
}

// ZerodhaExchangeRequest represents the token exchange request
type ZerodhaExchangeRequest struct {
	Code string `json:"code"`
}

// ZerodhaExchange handles the token exchange for Zerodha Kite
func (h *InvestmentHandler) ZerodhaExchange(c *fiber.Ctx) error {
	var req ZerodhaExchangeRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_REQUEST", "message": "Invalid JSON body"},
		})
	}

	req.Code = strings.TrimSpace(req.Code)
	if req.Code == "" {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "MISSING_CODE", "message": "Authorization code is required"},
		})
	}

	apiKey := h.Config.ZerodhaApiKey
	apiSecret := h.Config.ZerodhaApiSecret

	if apiKey == "" || apiSecret == "" {
		return c.Status(500).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "CONFIG_ERROR", "message": "Zerodha provider not configured"},
		})
	}

	// Calculate checksum: SHA256(api_key + request_token + api_secret)
	checksumInput := fmt.Sprintf("%s%s%s", apiKey, req.Code, apiSecret)
	hash := sha256.Sum256([]byte(checksumInput))
	checksum := hex.EncodeToString(hash[:])

	// Prepare form data for Zerodha API
	formData := url.Values{}
	formData.Set("api_key", apiKey)
	formData.Set("request_token", req.Code)
	formData.Set("checksum", checksum)

	// Call Zerodha API
	resp, err := http.PostForm("https://api.kite.trade/session/token", formData)
	if err != nil {
		return c.Status(502).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "UPSTREAM_ERROR", "message": "Failed to contact Zerodha"},
		})
	}
	defer resp.Body.Close()

	// Parse response
	var result map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return c.Status(502).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "UPSTREAM_ERROR", "message": "Invalid response from Zerodha"},
		})
	}

	// Return the response as is (Zerodha returns status 200 on success)
	// If Zerodha returns error (e.g. 403), we forward that too.
	return c.Status(resp.StatusCode).JSON(result)
}
