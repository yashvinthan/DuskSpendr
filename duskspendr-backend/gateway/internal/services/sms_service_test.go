package services

import (
	"context"
	"testing"
)

func TestLogSender(t *testing.T) {
	sender := NewLogSender()
	err := sender.SendSMS(context.Background(), "+1234567890", "Test message")
	if err != nil {
		t.Errorf("LogSender.SendSMS returned error: %v", err)
	}
}
