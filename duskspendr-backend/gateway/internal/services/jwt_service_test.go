package services_test

import (
	"context"
	"fmt"
	"testing"
	"time"

	"duskspendr/gateway/internal/services"
)

// mockStore implements services.TokenStore for testing
type mockStore struct {
	data map[string]string
}

func newMockStore() *mockStore {
	return &mockStore{
		data: make(map[string]string),
	}
}

func (m *mockStore) Set(ctx context.Context, key string, value interface{}, expiration time.Duration) error {
	m.data[key] = fmt.Sprintf("%v", value)
	return nil
}

func (m *mockStore) Get(ctx context.Context, key string) (string, error) {
	v, ok := m.data[key]
	if !ok {
		return "", fmt.Errorf("redis: nil")
	}
	return v, nil
}

func (m *mockStore) Exists(ctx context.Context, keys ...string) (int64, error) {
	var count int64
	for _, k := range keys {
		if _, ok := m.data[k]; ok {
			count++
		}
	}
	return count, nil
}

func (m *mockStore) TTL(ctx context.Context, key string) (time.Duration, error) {
	return 0, nil
}

func TestJWTService_Blacklist(t *testing.T) {
	store := newMockStore()
	svc := services.NewJWTService("secret", "refresh", store)
	ctx := context.Background()

	// Generate token
	pair, err := svc.GenerateTokenPair("u1", "e@mail.com", "+123")
	if err != nil {
		t.Fatalf("GenerateTokenPair failed: %v", err)
	}

	// Validate initially valid
	_, err = svc.ValidateRefreshToken(ctx, pair.RefreshToken)
	if err != nil {
		t.Fatalf("ValidateRefreshToken failed: %v", err)
	}

	// Invalidate
	err = svc.InvalidateToken(ctx, pair.RefreshToken)
	if err != nil {
		t.Fatalf("InvalidateToken failed: %v", err)
	}

	// Check if blacklisted
	isBlacklisted, err := svc.IsTokenBlacklisted(ctx, pair.RefreshToken)
	if err != nil {
		t.Fatalf("IsTokenBlacklisted failed: %v", err)
	}
	if !isBlacklisted {
		t.Error("Token should be blacklisted")
	}

	// Validate should fail
	_, err = svc.ValidateRefreshToken(ctx, pair.RefreshToken)
	if err == nil {
		t.Error("ValidateRefreshToken should fail for blacklisted token")
	}
	if err != services.ErrTokenBlacklisted {
		t.Errorf("Expected ErrTokenBlacklisted, got %v", err)
	}

	// Access token should also be blackistable
	err = svc.InvalidateToken(ctx, pair.AccessToken)
	if err != nil {
		t.Fatalf("InvalidateToken (access) failed: %v", err)
	}

	// Validate access token should fail
	_, err = svc.ValidateAccessToken(ctx, pair.AccessToken)
	if err == nil {
		t.Error("ValidateAccessToken should fail for blacklisted token")
	}
	if err != services.ErrTokenBlacklisted {
		t.Errorf("Expected ErrTokenBlacklisted, got %v", err)
	}
}
