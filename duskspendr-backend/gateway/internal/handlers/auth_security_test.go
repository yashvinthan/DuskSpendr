package handlers

import (
	"encoding/json"
	"testing"
	"time"

	"duskspendr/gateway/internal/models"
)

func TestAuthStartResponse_NoDevCode(t *testing.T) {
	// Test the struct from auth_fiber.go (local to package handlers)
	// This struct is defined in auth_fiber.go
	resp := AuthStartResponse{
		OTPID:     "test-otp-id",
		ExpiresAt: time.Now(),
	}

	data, err := json.Marshal(resp)
	if err != nil {
		t.Fatalf("Failed to marshal AuthStartResponse: %v", err)
	}

	// Verify dev_code is not in the JSON output
	var resultMap map[string]interface{}
	if err := json.Unmarshal(data, &resultMap); err != nil {
		t.Fatalf("Failed to unmarshal JSON: %v", err)
	}

	if _, exists := resultMap["dev_code"]; exists {
		t.Error("AuthStartResponse (fiber) contains dev_code field")
	}

	// Test the struct from models package (used in auth.go)
	modelResp := models.AuthStartResponse{
		OTPID:     "test-otp-id",
		ExpiresAt: time.Now(),
	}

	modelData, err := json.Marshal(modelResp)
	if err != nil {
		t.Fatalf("Failed to marshal models.AuthStartResponse: %v", err)
	}

	var modelResultMap map[string]interface{}
	if err := json.Unmarshal(modelData, &modelResultMap); err != nil {
		t.Fatalf("Failed to unmarshal JSON: %v", err)
	}

	if _, exists := modelResultMap["dev_code"]; exists {
		t.Error("models.AuthStartResponse contains dev_code field")
	}
}
