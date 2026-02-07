// Package services contains business logic services
package services

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var (
	ErrInvalidToken     = errors.New("invalid token")
	ErrExpiredToken     = errors.New("token expired")
	ErrInvalidTokenType = errors.New("invalid token type")
	ErrTokenBlacklisted = errors.New("token is blacklisted")
)

// TokenStore defines the interface for token storage (e.g. Redis)
type TokenStore interface {
	Set(ctx context.Context, key string, value interface{}, expiration time.Duration) error
	Get(ctx context.Context, key string) (string, error)
	Exists(ctx context.Context, keys ...string) (int64, error)
	TTL(ctx context.Context, key string) (time.Duration, error)
}

// TokenPair represents access and refresh tokens
type TokenPair struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	ExpiresIn    int64  `json:"expires_in"`
	TokenType    string `json:"token_type"`
}

// Claims represents JWT claims
type Claims struct {
	UserID    string `json:"user_id"`
	Email     string `json:"email,omitempty"`
	Phone     string `json:"phone,omitempty"`
	TokenType string `json:"token_type"`
	jwt.RegisteredClaims
}

// JWTService handles JWT token operations
type JWTService struct {
	accessSecret      []byte
	refreshSecret     []byte
	accessExpiration  time.Duration
	refreshExpiration time.Duration
	tokenStore        TokenStore
}

// NewJWTService creates a new JWT service
func NewJWTService(accessSecret, refreshSecret string, tokenStore TokenStore) *JWTService {
	return &JWTService{
		accessSecret:      []byte(accessSecret),
		refreshSecret:     []byte(refreshSecret),
		accessExpiration:  15 * time.Minute,
		refreshExpiration: 7 * 24 * time.Hour,
		tokenStore:        tokenStore,
	}
}

// GenerateTokenPair creates access and refresh tokens
func (s *JWTService) GenerateTokenPair(userID, email, phone string) (*TokenPair, error) {
	now := time.Now()
	jti, err := generateJTI()
	if err != nil {
		return nil, err
	}

	// Access token
	accessClaims := Claims{
		UserID:    userID,
		Email:     email,
		Phone:     phone,
		TokenType: "access",
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   userID,
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(now.Add(s.accessExpiration)),
			ID:        jti,
			Issuer:    "duskspendr",
		},
	}

	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims)
	accessTokenString, err := accessToken.SignedString(s.accessSecret)
	if err != nil {
		return nil, err
	}

	// Refresh token
	refreshJTI, err := generateJTI()
	if err != nil {
		return nil, err
	}

	refreshClaims := Claims{
		UserID:    userID,
		TokenType: "refresh",
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   userID,
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(now.Add(s.refreshExpiration)),
			ID:        refreshJTI,
			Issuer:    "duskspendr",
		},
	}

	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims)
	refreshTokenString, err := refreshToken.SignedString(s.refreshSecret)
	if err != nil {
		return nil, err
	}

	return &TokenPair{
		AccessToken:  accessTokenString,
		RefreshToken: refreshTokenString,
		ExpiresIn:    int64(s.accessExpiration.Seconds()),
		TokenType:    "Bearer",
	}, nil
}

// ValidateAccessToken validates an access token and returns claims
func (s *JWTService) ValidateAccessToken(ctx context.Context, tokenString string) (*Claims, error) {
	claims, err := s.validateToken(tokenString, s.accessSecret, "access")
	if err != nil {
		return nil, err
	}

	// Check blacklist
	blacklisted, err := s.IsTokenBlacklisted(ctx, tokenString)
	if err != nil {
		// Fail secure: if we can't check blacklist, reject token
		return nil, fmt.Errorf("failed to check token blacklist: %w", err)
	}
	if blacklisted {
		return nil, ErrTokenBlacklisted
	}

	return claims, nil
}

// ValidateRefreshToken validates a refresh token and returns claims
func (s *JWTService) ValidateRefreshToken(ctx context.Context, tokenString string) (*Claims, error) {
	claims, err := s.validateToken(tokenString, s.refreshSecret, "refresh")
	if err != nil {
		return nil, err
	}

	// Check blacklist
	blacklisted, err := s.IsTokenBlacklisted(ctx, tokenString)
	if err != nil {
		return nil, fmt.Errorf("failed to check token blacklist: %w", err)
	}
	if blacklisted {
		return nil, ErrTokenBlacklisted
	}

	return claims, nil
}

// validateToken validates a token with the given secret
func (s *JWTService) validateToken(tokenString string, secret []byte, expectedType string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, ErrInvalidToken
		}
		return secret, nil
	})

	if err != nil {
		if errors.Is(err, jwt.ErrTokenExpired) {
			return nil, ErrExpiredToken
		}
		return nil, ErrInvalidToken
	}

	claims, ok := token.Claims.(*Claims)
	if !ok || !token.Valid {
		return nil, ErrInvalidToken
	}

	if claims.TokenType != expectedType {
		return nil, ErrInvalidTokenType
	}

	return claims, nil
}

// RefreshTokens generates new tokens from a valid refresh token
func (s *JWTService) RefreshTokens(ctx context.Context, refreshToken string) (*TokenPair, error) {
	claims, err := s.ValidateRefreshToken(ctx, refreshToken)
	if err != nil {
		return nil, err
	}

	return s.GenerateTokenPair(claims.UserID, claims.Email, claims.Phone)
}

// InvalidateToken adds a token to the blacklist
func (s *JWTService) InvalidateToken(ctx context.Context, tokenString string) error {
	// Parse without verification first to get claims (we want to invalidate even if expired or invalid signature,
    // although if signature is invalid it doesn't matter much, but let's be safe)
	token, _, err := new(jwt.Parser).ParseUnverified(tokenString, &Claims{})
	if err != nil {
		return ErrInvalidToken
	}

	claims, ok := token.Claims.(*Claims)
	if !ok {
		return ErrInvalidToken
	}

	// Calculate remaining time
	if claims.ExpiresAt == nil {
		return ErrInvalidToken
	}
	expiresAt := claims.ExpiresAt.Time
	ttl := time.Until(expiresAt)
	if ttl <= 0 {
		return nil // Already expired
	}

	// Store JTI in blacklist
	// Use a prefix to avoid collisions
	key := fmt.Sprintf("blacklist:%s", claims.ID)
	return s.tokenStore.Set(ctx, key, "1", ttl)
}

// IsTokenBlacklisted checks if a token is in the blacklist
func (s *JWTService) IsTokenBlacklisted(ctx context.Context, tokenString string) (bool, error) {
	// Parse without verification first to get claims
	token, _, err := new(jwt.Parser).ParseUnverified(tokenString, &Claims{})
	if err != nil {
		return false, ErrInvalidToken
	}

	claims, ok := token.Claims.(*Claims)
	if !ok {
		return false, ErrInvalidToken
	}

	if claims.ID == "" {
        // If no JTI, we can't blacklist effectively. Assume valid? Or invalid?
        // Standard JWTs should have JTI if we generate them.
		return false, nil
	}

	key := fmt.Sprintf("blacklist:%s", claims.ID)
	n, err := s.tokenStore.Exists(ctx, key)
	if err != nil {
		return false, err
	}

	return n > 0, nil
}

// generateJTI creates a unique token ID
func generateJTI() (string, error) {
	b := make([]byte, 16)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}
