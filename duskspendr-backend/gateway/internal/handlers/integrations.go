package handlers

import (
	"encoding/json"
	"io"
	"net/http"
	"net/url"
	"strings"

	"github.com/gofiber/fiber/v2"

	"duskspendr/gateway/internal/config"
)

type IntegrationsHandler struct {
	Config config.Config
}

func NewIntegrationsHandler(cfg config.Config) *IntegrationsHandler {
	return &IntegrationsHandler{
		Config: cfg,
	}
}

type UpstoxTokenRequest struct {
	Code        string `json:"code"`
	RedirectURI string `json:"redirect_uri,omitempty"`
}

func (h *IntegrationsHandler) UpstoxTokenExchange(c *fiber.Ctx) error {
	var req UpstoxTokenRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_REQUEST", "message": "Invalid JSON body"},
		})
	}

	if req.Code == "" {
		return c.Status(400).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "INVALID_INPUT", "message": "Authorization code is required"},
		})
	}

	// Use configured redirect URI if not provided, or if the provided one matches
	redirectURI := h.Config.UpstoxRedirectURI
	if req.RedirectURI != "" {
		redirectURI = req.RedirectURI
	}

	if h.Config.UpstoxClientSecret == "" || h.Config.UpstoxClientID == "" {
		return c.Status(500).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "CONFIG_ERROR", "message": "Provider not configured"},
		})
	}

	// Prepare request to Upstox
	data := url.Values{}
	data.Set("code", req.Code)
	data.Set("client_id", h.Config.UpstoxClientID)
	data.Set("client_secret", h.Config.UpstoxClientSecret)
	data.Set("redirect_uri", redirectURI)
	data.Set("grant_type", "authorization_code")

	// Make the request
	resp, err := http.Post(
		"https://api.upstox.com/v2/login/authorization/token",
		"application/x-www-form-urlencoded",
		strings.NewReader(data.Encode()),
	)
	if err != nil {
		return c.Status(502).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "UPSTREAM_ERROR", "message": "Failed to contact Upstox: " + err.Error()},
		})
	}
	defer resp.Body.Close()

	bodyBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return c.Status(502).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "UPSTREAM_ERROR", "message": "Failed to read Upstox response"},
		})
	}

	if resp.StatusCode != 200 {
		// Forward the error from Upstox
		var errorResp map[string]interface{}
		_ = json.Unmarshal(bodyBytes, &errorResp)
		return c.Status(resp.StatusCode).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "UPSTOX_ERROR", "message": "Upstox rejected the request", "details": errorResp},
		})
	}

	var tokenData map[string]interface{}
	if err := json.Unmarshal(bodyBytes, &tokenData); err != nil {
		return c.Status(502).JSON(fiber.Map{
			"success": false,
			"error":   fiber.Map{"code": "UPSTREAM_ERROR", "message": "Invalid response from Upstox"},
		})
	}

	return c.JSON(fiber.Map{
		"success": true,
		"data":    tokenData,
	})
}
