package services

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"strings"
	"time"
)

// SMSSender sends SMS messages
type SMSSender interface {
	SendSMS(ctx context.Context, to, body string) error
}

// LogSender logs the SMS content to stdout (for dev/local)
type LogSender struct{}

func NewLogSender() *LogSender {
	return &LogSender{}
}

func (s *LogSender) SendSMS(ctx context.Context, to, body string) error {
	log.Printf("[SMS] To: %s, Body: %s", to, body)
	return nil
}

// TwilioSender sends SMS via Twilio
type TwilioSender struct {
	AccountSID string
	AuthToken  string
	FromNumber string
	HTTPClient *http.Client
}

func NewTwilioSender(accountSID, authToken, fromNumber string) *TwilioSender {
	return &TwilioSender{
		AccountSID: accountSID,
		AuthToken:  authToken,
		FromNumber: fromNumber,
		HTTPClient: &http.Client{Timeout: 10 * time.Second},
	}
}

func (s *TwilioSender) SendSMS(ctx context.Context, to, body string) error {
	if s.AccountSID == "" || s.AuthToken == "" || s.FromNumber == "" {
		return fmt.Errorf("twilio credentials missing")
	}

	apiURL := fmt.Sprintf("https://api.twilio.com/2010-04-01/Accounts/%s/Messages.json", s.AccountSID)

	data := url.Values{}
	data.Set("To", to)
	data.Set("From", s.FromNumber)
	data.Set("Body", body)

	req, err := http.NewRequestWithContext(ctx, "POST", apiURL, strings.NewReader(data.Encode()))
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	req.SetBasicAuth(s.AccountSID, s.AuthToken)
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	resp, err := s.HTTPClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		return nil
	}

	var twilioErr map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&twilioErr); err != nil {
		return fmt.Errorf("twilio error (status %d)", resp.StatusCode)
	}

	return fmt.Errorf("twilio error: %v", twilioErr["message"])
}
