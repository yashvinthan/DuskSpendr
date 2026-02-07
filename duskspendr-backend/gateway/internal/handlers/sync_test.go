package handlers

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"duskspendr/gateway/internal/models"
)

// MockDB implements DBPool for testing
type MockDB struct {
	ExecCalls      int
	SendBatchCalls int
	ExecFunc       func(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error)
	SendBatchFunc  func(ctx context.Context, b *pgx.Batch) pgx.BatchResults
}

func (m *MockDB) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	m.ExecCalls++
	if m.ExecFunc != nil {
		return m.ExecFunc(ctx, sql, arguments...)
	}
	return pgconn.NewCommandTag("INSERT 0 1"), nil
}

func (m *MockDB) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	return nil, nil
}

func (m *MockDB) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row {
	return nil
}

func (m *MockDB) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults {
	m.SendBatchCalls++
	if m.SendBatchFunc != nil {
		return m.SendBatchFunc(ctx, b)
	}
	return &MockBatchResults{Count: b.Len()}
}

type MockBatchResults struct {
	Count int
	Current int
}

func (m *MockBatchResults) Exec() (pgconn.CommandTag, error) {
	if m.Current >= m.Count {
		return pgconn.CommandTag{}, nil
	}
	m.Current++
	return pgconn.NewCommandTag("INSERT 0 1"), nil
}

func (m *MockBatchResults) Query() (pgx.Rows, error) {
	return nil, nil
}

func (m *MockBatchResults) QueryRow() pgx.Row {
	return nil
}

func (m *MockBatchResults) Close() error {
	return nil
}

func TestIngestTransactions_Performance(t *testing.T) {
	mockDB := &MockDB{}
	handler := &SyncHandler{Pool: mockDB}

	// Create 10 items
	items := make([]models.SyncIngestItem, 10)
	for i := 0; i < 10; i++ {
		items[i] = models.SyncIngestItem{
			ID:          uuid.New().String(),
			AmountPaisa: 1000,
			Type:        "debit",
			Category:    "food",
			Source:      "manual",
			Timestamp:   time.Now().UTC(),
		}
	}

	reqBody, _ := json.Marshal(models.SyncIngestRequest{Items: items})
	req := httptest.NewRequest("POST", "/sync/transactions/ingest", bytes.NewReader(reqBody))

	// Add user ID to context (simulating auth middleware)
	ctx := context.WithValue(req.Context(), userIDKey, uuid.New())
	req = req.WithContext(ctx)

	w := httptest.NewRecorder()
	handler.IngestTransactions(w, req)

	resp := w.Result()
	if resp.StatusCode != http.StatusOK {
		t.Errorf("expected status 200, got %d", resp.StatusCode)
	}

	// Verify counts
	// AFTER OPTIMIZATION: ExecCalls should be 0, SendBatchCalls should be 1

	if mockDB.ExecCalls != 0 {
		t.Errorf("Optimization check failed: expected 0 Exec calls, got %d", mockDB.ExecCalls)
	}
	if mockDB.SendBatchCalls != 1 {
		t.Errorf("Optimization check failed: expected 1 SendBatch call, got %d", mockDB.SendBatchCalls)
	}
}
