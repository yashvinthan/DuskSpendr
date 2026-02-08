package handlers

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

type MockDBPool struct{}

func (m *MockDBPool) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	return pgconn.NewCommandTag("DELETE 1"), nil
}

func (m *MockDBPool) Query(ctx context.Context, sql string, arguments ...any) (pgx.Rows, error) {
	return nil, nil
}

func (m *MockDBPool) QueryRow(ctx context.Context, sql string, arguments ...any) pgx.Row {
	return nil
}

func (m *MockDBPool) Begin(ctx context.Context) (pgx.Tx, error) {
	return nil, nil
}

func BenchmarkDeleteTransactions(b *testing.B) {
	handler := &TransactionHandler{Pool: &MockDBPool{}}
	r := chi.NewRouter()
	r.Delete("/transactions/{id}", handler.Delete)

	userID := uuid.New()
	// Create a context with user ID, simulating Auth middleware

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		// Simulate deleting 10 transactions one by one
		for j := 0; j < 10; j++ {
			req := httptest.NewRequest(http.MethodDelete, "/transactions/"+uuid.New().String(), nil)
			ctx := context.WithValue(req.Context(), userIDKey, userID)
			w := httptest.NewRecorder()
			r.ServeHTTP(w, req.WithContext(ctx))
		}
	}
}

func BenchmarkBulkDeleteTransactions(b *testing.B) {
	handler := &TransactionHandler{Pool: &MockDBPool{}}
	r := chi.NewRouter()
	r.Post("/transactions/bulk-delete", handler.BulkDelete)

	userID := uuid.New()

	// Prepare IDs for bulk delete (10 IDs)
	ids := make([]string, 10)
	for i := 0; i < 10; i++ {
		ids[i] = uuid.New().String()
	}
	body, _ := json.Marshal(map[string]interface{}{"ids": ids})

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		req := httptest.NewRequest(http.MethodPost, "/transactions/bulk-delete", bytes.NewReader(body))
		ctx := context.WithValue(req.Context(), userIDKey, userID)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req.WithContext(ctx))
	}
}
