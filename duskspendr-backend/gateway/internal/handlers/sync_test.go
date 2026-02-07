package handlers

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"

	"duskspendr/gateway/internal/models"
)

type MockDB struct {
	ExecCount     int
	BatchCount    int
	LastExecSQL   string
	LastBatchSize int
}

func (m *MockDB) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	m.ExecCount++
	m.LastExecSQL = sql
	return pgconn.NewCommandTag("INSERT 1"), nil
}

func (m *MockDB) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults {
	m.BatchCount++
	m.LastBatchSize = b.Len()
	return &MockBatchResults{Batch: b}
}

func (m *MockDB) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	return nil, fmt.Errorf("not implemented")
}

func (m *MockDB) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row {
	return nil
}

type MockBatchResults struct {
	Batch   *pgx.Batch
	Current int
}

func (m *MockBatchResults) Exec() (pgconn.CommandTag, error) {
	if m.Current >= m.Batch.Len() {
		return pgconn.CommandTag{}, fmt.Errorf("no more results")
	}
	m.Current++
	return pgconn.NewCommandTag("INSERT 1"), nil
}

func (m *MockBatchResults) Query() (pgx.Rows, error) {
	return nil, fmt.Errorf("not implemented")
}

func (m *MockBatchResults) QueryRow() pgx.Row {
	return nil
}

func (m *MockBatchResults) Close() error {
	return nil
}

func TestIngestTransactions_Performance(t *testing.T) {
	// Setup
	mockDB := &MockDB{}
	handler := &SyncHandler{
		Pool: mockDB,
	}

	// Create input with 5 items
	items := make([]models.SyncIngestItem, 5)
	for i := 0; i < 5; i++ {
		items[i] = models.SyncIngestItem{
			ID:          uuid.New().String(),
			AmountPaisa: 1000,
			Type:        "debit",
			Category:    "food",
			Source:      "manual",
			Timestamp:   time.Now().UTC(),
		}
	}
	reqBody := models.SyncIngestRequest{Items: items}
	bodyBytes, _ := json.Marshal(reqBody)

	// Create request
	req := httptest.NewRequest("POST", "/sync/ingest", bytes.NewReader(bodyBytes))

	// Inject user ID into context
	userID := uuid.New()
	ctx := context.WithValue(req.Context(), userIDKey, userID)
	req = req.WithContext(ctx)

	w := httptest.NewRecorder()

	// Execute
	handler.IngestTransactions(w, req)

	// Verify response
	resp := w.Result()
	if resp.StatusCode != http.StatusOK {
		t.Errorf("expected status 200, got %d", resp.StatusCode)
	}

	var respData map[string]any
	json.NewDecoder(resp.Body).Decode(&respData)
	if inserted, ok := respData["inserted"].(float64); !ok || int(inserted) != 5 {
		t.Errorf("expected 5 inserted, got %v", respData["inserted"])
	}

	// Verify DB usage
	// After optimization, we expect 0 Exec calls (for inserts) and 1 Batch call.
	if mockDB.ExecCount != 0 {
		t.Errorf("Optimization check: expected 0 Exec calls, got %d", mockDB.ExecCount)
	}
	if mockDB.BatchCount != 1 {
		t.Errorf("Optimization check: expected 1 Batch call, got %d", mockDB.BatchCount)
	}

	// Verify batch size
	if mockDB.LastBatchSize != 5 {
		t.Errorf("expected batch size 5, got %d", mockDB.LastBatchSize)
	}
}
