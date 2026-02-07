package services

import (
	"testing"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

// newTestJWTService creates a JWTService with hardcoded secrets for testing
func newTestJWTService() *JWTService {
	return NewJWTService("access-secret", "refresh-secret")
}

func TestGenerateTokenPair(t *testing.T) {
	service := newTestJWTService()
	userID := "user123"
	email := "test@example.com"
	phone := "1234567890"

	tokenPair, err := service.GenerateTokenPair(userID, email, phone)
	if err != nil {
		t.Fatalf("GenerateTokenPair failed: %v", err)
	}

	if tokenPair == nil {
		t.Fatal("GenerateTokenPair returned nil tokenPair")
	}

	if tokenPair.AccessToken == "" {
		t.Error("AccessToken is empty")
	}

	if tokenPair.RefreshToken == "" {
		t.Error("RefreshToken is empty")
	}

	if tokenPair.ExpiresIn != 900 {
		t.Errorf("Expected ExpiresIn to be 900, got %d", tokenPair.ExpiresIn)
	}

	// Validate Access Token Claims
	accessToken, err := jwt.ParseWithClaims(tokenPair.AccessToken, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte("access-secret"), nil
	})
	if err != nil {
		t.Fatalf("Failed to parse access token: %v", err)
	}

	if claims, ok := accessToken.Claims.(*Claims); ok && accessToken.Valid {
		if claims.UserID != userID {
			t.Errorf("Access Token UserID mismatch: expected %s, got %s", userID, claims.UserID)
		}
		if claims.Email != email {
			t.Errorf("Access Token Email mismatch: expected %s, got %s", email, claims.Email)
		}
		if claims.Phone != phone {
			t.Errorf("Access Token Phone mismatch: expected %s, got %s", phone, claims.Phone)
		}
		if claims.TokenType != "access" {
			t.Errorf("Access Token TokenType mismatch: expected access, got %s", claims.TokenType)
		}
		if claims.Issuer != "duskspendr" {
			t.Errorf("Access Token Issuer mismatch: expected duskspendr, got %s", claims.Issuer)
		}
	} else {
		t.Error("Access Token is invalid")
	}

	// Validate Refresh Token Claims
	refreshToken, err := jwt.ParseWithClaims(tokenPair.RefreshToken, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte("refresh-secret"), nil
	})
	if err != nil {
		t.Fatalf("Failed to parse refresh token: %v", err)
	}

	if claims, ok := refreshToken.Claims.(*Claims); ok && refreshToken.Valid {
		if claims.UserID != userID {
			t.Errorf("Refresh Token UserID mismatch: expected %s, got %s", userID, claims.UserID)
		}
		if claims.TokenType != "refresh" {
			t.Errorf("Refresh Token TokenType mismatch: expected refresh, got %s", claims.TokenType)
		}
		if claims.Issuer != "duskspendr" {
			t.Errorf("Refresh Token Issuer mismatch: expected duskspendr, got %s", claims.Issuer)
		}
	} else {
		t.Error("Refresh Token is invalid")
	}
}

func TestValidateAccessToken(t *testing.T) {
	service := newTestJWTService()
	userID := "user123"

	// 1. Valid Access Token
	tokenPair, _ := service.GenerateTokenPair(userID, "", "")
	claims, err := service.ValidateAccessToken(tokenPair.AccessToken)
	if err != nil {
		t.Errorf("ValidateAccessToken failed for valid token: %v", err)
	}
	if claims == nil || claims.UserID != userID {
		t.Error("ValidateAccessToken returned incorrect claims")
	}

	// 2. Invalid Token (Refresh Token passed as Access Token)
	_, err = service.ValidateAccessToken(tokenPair.RefreshToken)
	if err == nil {
		t.Error("ValidateAccessToken should fail for refresh token")
	}

	// 3. Invalid Signature
	wrongSecretToken := jwt.NewWithClaims(jwt.SigningMethodHS256, &Claims{
		UserID:    userID,
		TokenType: "access",
	})
	wrongSecretString, _ := wrongSecretToken.SignedString([]byte("wrong-secret"))
	_, err = service.ValidateAccessToken(wrongSecretString)
	if err != ErrInvalidToken {
		t.Errorf("Expected ErrInvalidToken for wrong signature, got %v", err)
	}

	// 4. Expired Token
	expiredClaims := Claims{
		UserID:    userID,
		TokenType: "access",
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(-1 * time.Hour)),
		},
	}
	expiredToken := jwt.NewWithClaims(jwt.SigningMethodHS256, expiredClaims)
	expiredString, _ := expiredToken.SignedString([]byte("access-secret"))
	_, err = service.ValidateAccessToken(expiredString)
	if err != ErrExpiredToken {
		t.Errorf("Expected ErrExpiredToken for expired token, got %v", err)
	}
}

func TestValidateRefreshToken(t *testing.T) {
	service := newTestJWTService()
	userID := "user123"

	// 1. Valid Refresh Token
	tokenPair, _ := service.GenerateTokenPair(userID, "", "")
	claims, err := service.ValidateRefreshToken(tokenPair.RefreshToken)
	if err != nil {
		t.Errorf("ValidateRefreshToken failed for valid token: %v", err)
	}
	if claims == nil || claims.UserID != userID {
		t.Error("ValidateRefreshToken returned incorrect claims")
	}

	// 2. Invalid Token (Access Token passed as Refresh Token)
	_, err = service.ValidateRefreshToken(tokenPair.AccessToken)
	if err == nil {
		t.Error("ValidateRefreshToken should fail for access token")
	}

	// 3. Invalid Signature
	wrongSecretToken := jwt.NewWithClaims(jwt.SigningMethodHS256, &Claims{
		UserID:    userID,
		TokenType: "refresh",
	})
	wrongSecretString, _ := wrongSecretToken.SignedString([]byte("wrong-secret"))
	_, err = service.ValidateRefreshToken(wrongSecretString)
	if err != ErrInvalidToken {
		t.Errorf("Expected ErrInvalidToken for wrong signature, got %v", err)
	}
}

func TestRefreshTokens(t *testing.T) {
	service := newTestJWTService()
	userID := "user123"
	tokenPair, _ := service.GenerateTokenPair(userID, "", "")

	// 1. Success
	newPair, err := service.RefreshTokens(tokenPair.RefreshToken)
	if err != nil {
		t.Fatalf("RefreshTokens failed: %v", err)
	}
	if newPair == nil {
		t.Fatal("RefreshTokens returned nil")
	}
	if newPair.AccessToken == "" || newPair.RefreshToken == "" {
		t.Error("RefreshTokens returned empty tokens")
	}

	// 2. Fail with invalid token
	_, err = service.RefreshTokens("invalid-token")
	if err == nil {
		t.Error("RefreshTokens should fail with invalid token")
	}
}
