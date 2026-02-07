package utils

import (
	"testing"
)

func TestHashToken(t *testing.T) {
	token := "test-token"
	hash := HashToken(token)
	if len(hash) != 64 { // SHA256 hex string length
		t.Errorf("expected hash length 64, got %d", len(hash))
	}
	// Verify deterministic
	if HashToken(token) != hash {
		t.Errorf("HashToken is not deterministic")
	}
}

func TestSafeCompare(t *testing.T) {
	if !SafeCompare("a", "a") {
		t.Errorf("SafeCompare failed for equal strings")
	}
	if SafeCompare("a", "b") {
		t.Errorf("SafeCompare passed for different strings")
	}
	if SafeCompare("a", "ab") {
		t.Errorf("SafeCompare passed for different length strings")
	}
}

func TestHashOTP(t *testing.T) {
	pepper := "pepper"
	otpID := "otp-id"
	code := "123456"
	hash := HashOTP(pepper, otpID, code)
	if len(hash) != 64 {
		t.Errorf("expected hash length 64, got %d", len(hash))
	}
}

func TestGenerateOTP(t *testing.T) {
	otp, err := GenerateOTP(6)
	if err != nil {
		t.Errorf("GenerateOTP failed: %v", err)
	}
	if len(otp) != 6 {
		t.Errorf("expected OTP length 6, got %d", len(otp))
	}
	for _, c := range otp {
		if c < '0' || c > '9' {
			t.Errorf("expected numeric OTP, got %s", otp)
		}
	}
}

func TestGenerateToken(t *testing.T) {
	token, hash, err := GenerateToken()
	if err != nil {
		t.Errorf("GenerateToken failed: %v", err)
	}
	if token == "" {
		t.Errorf("expected token, got empty string")
	}
	if hash == "" {
		t.Errorf("expected hash, got empty string")
	}
	if HashToken(token) != hash {
		t.Errorf("hash does not match token")
	}
}

func TestValidatePhoneE164(t *testing.T) {
	valid := []string{"+1234567890", "+919876543210"}
	invalid := []string{"1234567890", "+", "abc", "+123456"}

	for _, phone := range valid {
		if !ValidatePhoneE164(phone) {
			t.Errorf("expected valid for %s", phone)
		}
	}

	for _, phone := range invalid {
		if ValidatePhoneE164(phone) {
			t.Errorf("expected invalid for %s", phone)
		}
	}
}
