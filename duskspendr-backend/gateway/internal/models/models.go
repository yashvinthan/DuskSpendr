package models

import "time"

type Transaction struct {
  ID                 string    `json:"id"`
  UserID             string    `json:"user_id"`
  AmountPaisa        int64     `json:"amount_paisa"`
  Type               string    `json:"type"`
  Category           string    `json:"category"`
  MerchantName       *string   `json:"merchant_name,omitempty"`
  Description        *string   `json:"description,omitempty"`
  Timestamp          time.Time `json:"timestamp"`
  Source             string    `json:"source"`
  PaymentMethod      *string   `json:"payment_method,omitempty"`
  LinkedAccountID    *string   `json:"linked_account_id,omitempty"`
  ReferenceID        *string   `json:"reference_id,omitempty"`
  CategoryConfidence *float64  `json:"category_confidence,omitempty"`
  IsRecurring        bool      `json:"is_recurring"`
  IsShared           bool      `json:"is_shared"`
  Tags               []string  `json:"tags"`
  Notes              *string   `json:"notes,omitempty"`
  CreatedAt          time.Time `json:"created_at"`
  UpdatedAt          time.Time `json:"updated_at"`
}

type TransactionInput struct {
  AmountPaisa        int64     `json:"amount_paisa"`
  Type               string    `json:"type"`
  Category           string    `json:"category"`
  MerchantName       *string   `json:"merchant_name,omitempty"`
  Description        *string   `json:"description,omitempty"`
  Timestamp          time.Time `json:"timestamp"`
  Source             string    `json:"source"`
  PaymentMethod      *string   `json:"payment_method,omitempty"`
  LinkedAccountID    *string   `json:"linked_account_id,omitempty"`
  ReferenceID        *string   `json:"reference_id,omitempty"`
  CategoryConfidence *float64  `json:"category_confidence,omitempty"`
  IsRecurring        bool      `json:"is_recurring"`
  IsShared           bool      `json:"is_shared"`
  Tags               []string  `json:"tags"`
  Notes              *string   `json:"notes,omitempty"`
}

type LinkedAccount struct {
  ID              string    `json:"id"`
  UserID          string    `json:"user_id"`
  Provider        string    `json:"provider"`
  AccountNumber   *string   `json:"account_number,omitempty"`
  AccountName     *string   `json:"account_name,omitempty"`
  UpiID           *string   `json:"upi_id,omitempty"`
  BalancePaisa    *int64    `json:"balance_paisa,omitempty"`
  Status          string    `json:"status"`
  LastSyncedAt    time.Time `json:"last_synced_at"`
  LinkedAt        time.Time `json:"linked_at"`
}

type LinkedAccountInput struct {
  Provider      string  `json:"provider"`
  AccountNumber *string `json:"account_number,omitempty"`
  AccountName   *string `json:"account_name,omitempty"`
  UpiID         *string `json:"upi_id,omitempty"`
  BalancePaisa  *int64  `json:"balance_paisa,omitempty"`
  Status        string  `json:"status"`
}

type Budget struct {
  ID             string    `json:"id"`
  UserID         string    `json:"user_id"`
  Name           string    `json:"name"`
  LimitPaisa     int64     `json:"limit_paisa"`
  SpentPaisa     int64     `json:"spent_paisa"`
  Period         string    `json:"period"`
  Category       *string   `json:"category,omitempty"`
  AlertThreshold float64   `json:"alert_threshold"`
  IsActive       bool      `json:"is_active"`
  CreatedAt      time.Time `json:"created_at"`
  UpdatedAt      time.Time `json:"updated_at"`
}

type BudgetInput struct {
  Name           string   `json:"name"`
  LimitPaisa     int64    `json:"limit_paisa"`
  Period         string   `json:"period"`
  Category       *string  `json:"category,omitempty"`
  AlertThreshold *float64 `json:"alert_threshold,omitempty"`
  IsActive       *bool    `json:"is_active,omitempty"`
}

type User struct {
  ID        string    `json:"id"`
  Phone     string    `json:"phone"`
  CreatedAt time.Time `json:"created_at"`
}

type UserInput struct {
  Phone string `json:"phone"`
}

type AuthStartInput struct {
  Phone string `json:"phone"`
}

type AuthStartResponse struct {
  OTPID     string    `json:"otp_id"`
  ExpiresAt time.Time `json:"expires_at"`
  DevCode   string    `json:"dev_code,omitempty"`
}

type AuthVerifyInput struct {
  Phone string `json:"phone"`
  Code  string `json:"code"`
}

type AuthVerifyResponse struct {
  Token     string    `json:"token"`
  UserID    string    `json:"user_id"`
  ExpiresAt time.Time `json:"expires_at"`
}

type SyncIngestItem struct {
  ID                 string   `json:"id"`
  AmountPaisa        int64    `json:"amount_paisa"`
  Type               string   `json:"type"`
  Category           string   `json:"category"`
  MerchantName       *string  `json:"merchant_name,omitempty"`
  Description        *string  `json:"description,omitempty"`
  Timestamp          time.Time `json:"timestamp"`
  Source             string   `json:"source"`
  PaymentMethod      *string  `json:"payment_method,omitempty"`
  LinkedAccountID    *string  `json:"linked_account_id,omitempty"`
  ReferenceID        *string  `json:"reference_id,omitempty"`
  CategoryConfidence *float64 `json:"category_confidence,omitempty"`
  IsRecurring        bool     `json:"is_recurring"`
  IsShared           bool     `json:"is_shared"`
  Tags               []string `json:"tags"`
  Notes              *string  `json:"notes,omitempty"`
}

type SyncIngestRequest struct {
  Items []SyncIngestItem `json:"items"`
}
