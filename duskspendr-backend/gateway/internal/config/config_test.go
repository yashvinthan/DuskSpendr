package config

import (
	"os"
	"testing"
)

func TestLoad(t *testing.T) {
	// Helper to restore environment variables
	restoreEnv := func(key string) func() {
		val, exists := os.LookupEnv(key)
		return func() {
			if exists {
				os.Setenv(key, val)
			} else {
				os.Unsetenv(key)
			}
		}
	}

	defer restoreEnv("JWT_SECRET")()

	// Test missing JWT_SECRET
	os.Unsetenv("JWT_SECRET")
	_, err := Load()
	if err == nil {
		t.Error("Expected error when JWT_SECRET is missing, got nil")
	}

	// Test insecure default JWT_SECRET
	os.Setenv("JWT_SECRET", "your-super-secret-key-change-in-production")
	_, err = Load()
	if err == nil {
		t.Error("Expected error when JWT_SECRET uses insecure default, got nil")
	}

	// Test valid config
	os.Setenv("JWT_SECRET", "secure-access-secret")
	cfg, err := Load()
	if err != nil {
		t.Errorf("Expected no error for valid config, got: %v", err)
	}
	if cfg.JWTSecret != "secure-access-secret" {
		t.Errorf("Expected JWTSecret to be 'secure-access-secret', got '%s'", cfg.JWTSecret)
	}
}
