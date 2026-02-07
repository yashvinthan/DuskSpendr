package handlers_test

import (
	"context"
	"testing"

	"duskspendr/gateway/internal/config"
	"duskspendr/gateway/internal/handlers"
	"duskspendr/gateway/internal/services"
	"github.com/jackc/pgx/v5/pgxpool"
)

type MockNotificationSender struct{}

func (m *MockNotificationSender) SendNotification(ctx context.Context, notif *services.Notification) error {
	return nil
}

func TestNewFiberAuthHandler(t *testing.T) {
	// We just pass nil for pointers where we don't dereference them in constructor
	// pool cannot be nil if dereferenced, but NewAuthHandler just assigns it.
	var pool *pgxpool.Pool
	cfg := config.Config{}
	jwtSvc := &services.JWTService{}
	notifSvc := &MockNotificationSender{}

	h := handlers.NewFiberAuthHandler(pool, cfg, jwtSvc, notifSvc)
	if h == nil {
		t.Error("NewFiberAuthHandler returned nil")
	}
}
