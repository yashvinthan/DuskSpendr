package handlers

import (
	"bytes"
	"duskspendr/gateway/internal/config"
	"encoding/json"
	"net/http/httptest"
	"testing"

	"github.com/gofiber/fiber/v2"
)

func TestUpstoxTokenExchange_Validation(t *testing.T) {
	app := fiber.New()
	cfg := config.Config{} // Empty config
	h := NewIntegrationsHandler(cfg)
	app.Post("/token", h.UpstoxTokenExchange)

	t.Run("Missing Body", func(t *testing.T) {
		req := httptest.NewRequest("POST", "/token", nil)
		resp, _ := app.Test(req)
		if resp.StatusCode != 400 {
			t.Errorf("Expected 400, got %d", resp.StatusCode)
		}
	})

	t.Run("Missing Code", func(t *testing.T) {
		body, _ := json.Marshal(map[string]string{})
		req := httptest.NewRequest("POST", "/token", bytes.NewReader(body))
		req.Header.Set("Content-Type", "application/json")
		resp, _ := app.Test(req)
		if resp.StatusCode != 400 {
			t.Errorf("Expected 400, got %d", resp.StatusCode)
		}
	})

	t.Run("Missing Config", func(t *testing.T) {
		body, _ := json.Marshal(map[string]string{"code": "123"})
		req := httptest.NewRequest("POST", "/token", bytes.NewReader(body))
		req.Header.Set("Content-Type", "application/json")
		resp, _ := app.Test(req)
		if resp.StatusCode != 500 {
			t.Errorf("Expected 500 (Config Error), got %d", resp.StatusCode)
		}
	})
}
