package services

import (
	"context"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"

	"duskspendr-gateway/internal/config"
	"duskspendr-gateway/internal/models"
)

// AccountService handles account linking and token management
type AccountService struct {
	Pool   *pgxpool.Pool
	Config config.Config
	// In a real app, this would map provider names to implementations
	Providers map[string]BankProvider
}

// NewAccountService creates a new AccountService
func NewAccountService(pool *pgxpool.Pool, cfg config.Config) *AccountService {
	s := &AccountService{
		Pool:      pool,
		Config:    cfg,
		Providers: make(map[string]BankProvider),
	}
	// Register mock providers
	s.Providers["sbi"] = &MockBankProvider{ProviderName: "SBI"}
	s.Providers["hdfc"] = &MockBankProvider{ProviderName: "HDFC"}
	s.Providers["icici"] = &MockBankProvider{ProviderName: "ICICI"}
	s.Providers["axis"] = &MockBankProvider{ProviderName: "Axis"}
	s.Providers["gpay"] = &MockBankProvider{ProviderName: "Google Pay"}
	s.Providers["phonepe"] = &MockBankProvider{ProviderName: "PhonePe"}
	return s
}

func (s *AccountService) GetProvider(name string) (BankProvider, error) {
	if p, ok := s.Providers[name]; ok {
		return p, nil
	}
	return nil, fmt.Errorf("provider not found: %s", name)
}

// EncryptToken encrypts a sensitive token using AES-GCM
func (s *AccountService) EncryptToken(token string) (string, error) {
	key, err := hex.DecodeString(s.Config.DataEncryptionKey)
	if err != nil {
		return "", fmt.Errorf("invalid encryption key: %w", err)
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", err
	}

	nonce := make([]byte, gcm.NonceSize())
	if _, err = io.ReadFull(rand.Reader, nonce); err != nil {
		return "", err
	}

	ciphertext := gcm.Seal(nonce, nonce, []byte(token), nil)
	return base64.StdEncoding.EncodeToString(ciphertext), nil
}

// DecryptToken decrypts a sensitive token
func (s *AccountService) DecryptToken(encrypted string) (string, error) {
	key, err := hex.DecodeString(s.Config.DataEncryptionKey)
	if err != nil {
		return "", fmt.Errorf("invalid encryption key: %w", err)
	}

	data, err := base64.StdEncoding.DecodeString(encrypted)
	if err != nil {
		return "", err
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", err
	}

	nonceSize := gcm.NonceSize()
	if len(data) < nonceSize {
		return "", errors.New("ciphertext too short")
	}

	nonce, ciphertext := data[:nonceSize], data[nonceSize:]
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		return "", err
	}

	return string(plaintext), nil
}

// BankProvider defines the interface for interacting with bank/provider APIs
type BankProvider interface {
	InitiateLink(ctx context.Context, redirectURI, state string) (string, error)
	ExchangeToken(ctx context.Context, code, redirectURI string) (*TokenResponse, error)
	RefreshToken(ctx context.Context, refreshToken string) (*TokenResponse, error)
	GetBalance(ctx context.Context, accessToken, accountID string) (int64, error)
	GetTransactions(ctx context.Context, accessToken, accountID string, from time.Time) ([]models.RawTransaction, error)
}

// TokenResponse contains OAuth token data
type TokenResponse struct {
	AccessToken  string
	RefreshToken string
	ExpiresIn    int
	AccountID    string // Provider's account ID
}

// MockBankProvider implements BankProvider for testing/development
type MockBankProvider struct {
	ProviderName string
}

// Ensure MockBankProvider implements BankProvider
var _ BankProvider = (*MockBankProvider)(nil)

func (m *MockBankProvider) InitiateLink(ctx context.Context, redirectURI, state string) (string, error) {
	// Return a mock URL that the app can intercept or browser can show
	return fmt.Sprintf("https://mock-bank.com/login?provider=%s&redirect_uri=%s&state=%s",
		m.ProviderName, redirectURI, state), nil
}

func (m *MockBankProvider) ExchangeToken(ctx context.Context, code, redirectURI string) (*TokenResponse, error) {
	// Simulate success if code starts with "mock_code_"
	if len(code) > 0 {
		return &TokenResponse{
			AccessToken:  fmt.Sprintf("mock_access_token_%s_%d", m.ProviderName, time.Now().Unix()),
			RefreshToken: fmt.Sprintf("mock_refresh_token_%s_%d", m.ProviderName, time.Now().Unix()),
			ExpiresIn:    3600, // 1 hour
			AccountID:    fmt.Sprintf("acc_%s_%d", m.ProviderName, time.Now().Unix()),
		}, nil
	}
	return nil, errors.New("invalid authorization code")
}

func (m *MockBankProvider) RefreshToken(ctx context.Context, refreshToken string) (*TokenResponse, error) {
	return &TokenResponse{
		AccessToken:  fmt.Sprintf("mock_access_token_refreshed_%s_%d", m.ProviderName, time.Now().Unix()),
		RefreshToken: fmt.Sprintf("mock_refresh_token_refreshed_%s_%d", m.ProviderName, time.Now().Unix()),
		ExpiresIn:    3600,
		AccountID:    "same_account_id",
	}, nil
}

func (m *MockBankProvider) GetBalance(ctx context.Context, accessToken, accountID string) (int64, error) {
	// Return random balance between 1000 and 100000 rupees (in paisa)
	return 5000000, nil // 50,000.00 INR
}

func (m *MockBankProvider) GetTransactions(ctx context.Context, accessToken, accountID string, from time.Time) ([]models.RawTransaction, error) {
	// Return dummy transactions
	txs := []models.RawTransaction{
		{
			AmountPaisa: -15000, // -150.00
			Type:        "debit",
			Category:    "food",
			MerchantName: func() *string { s := "Swiggy"; return &s }(),
			Description:  func() *string { s := "Food delivery"; return &s }(),
			Timestamp:    time.Now().Add(-1 * time.Hour),
			Source:       "bankApi",
		},
		{
			AmountPaisa: -50000, // -500.00
			Type:        "debit",
			Category:    "transportation",
			MerchantName: func() *string { s := "Uber"; return &s }(),
			Description:  func() *string { s := "Ride to college"; return &s }(),
			Timestamp:    time.Now().Add(-24 * time.Hour),
			Source:       "bankApi",
		},
	}
	return txs, nil
}
