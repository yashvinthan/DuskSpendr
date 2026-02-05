// Package services contains business logic services
package services

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	amqp "github.com/rabbitmq/amqp091-go"
)

// NotificationType represents the type of notification
type NotificationType string

const (
	NotificationTypePush    NotificationType = "push"
	NotificationTypeEmail   NotificationType = "email"
	NotificationTypeSMS     NotificationType = "sms"
	NotificationTypeInApp   NotificationType = "in_app"
)

// NotificationPriority represents notification urgency
type NotificationPriority string

const (
	PriorityLow      NotificationPriority = "low"
	PriorityNormal   NotificationPriority = "normal"
	PriorityHigh     NotificationPriority = "high"
	PriorityCritical NotificationPriority = "critical"
)

// Notification represents a notification to send
type Notification struct {
	ID        string               `json:"id"`
	UserID    string               `json:"user_id"`
	Type      NotificationType     `json:"type"`
	Priority  NotificationPriority `json:"priority"`
	Title     string               `json:"title"`
	Body      string               `json:"body"`
	Data      map[string]any       `json:"data,omitempty"`
	Category  string               `json:"category,omitempty"`
	ActionURL string               `json:"action_url,omitempty"`
	SendAt    *time.Time           `json:"send_at,omitempty"`
	CreatedAt time.Time            `json:"created_at"`
}

// BudgetAlertPayload for budget threshold notifications
type BudgetAlertPayload struct {
	BudgetID       string  `json:"budget_id"`
	BudgetName     string  `json:"budget_name"`
	Category       string  `json:"category"`
	SpentAmount    float64 `json:"spent_amount"`
	BudgetLimit    float64 `json:"budget_limit"`
	PercentageUsed float64 `json:"percentage_used"`
	ThresholdType  string  `json:"threshold_type"` // "warning", "critical", "exceeded"
}

// TransactionAlertPayload for unusual transaction notifications
type TransactionAlertPayload struct {
	TransactionID string  `json:"transaction_id"`
	MerchantName  string  `json:"merchant_name"`
	Amount        float64 `json:"amount"`
	Category      string  `json:"category"`
	AlertReason   string  `json:"alert_reason"` // "large_amount", "unusual_merchant", "fraud_suspected"
}

// NotificationService handles notification dispatching
type NotificationService struct {
	mqConn    *amqp.Connection
	mqChannel *amqp.Channel
	exchange  string
}

// NewNotificationService creates a new notification service
func NewNotificationService(mqConn *amqp.Connection) *NotificationService {
	svc := &NotificationService{
		mqConn:   mqConn,
		exchange: "notifications",
	}

	if mqConn != nil {
		channel, err := mqConn.Channel()
		if err == nil {
			svc.mqChannel = channel
			// Declare exchange
			_ = channel.ExchangeDeclare(
				svc.exchange, // name
				"topic",      // type
				true,         // durable
				false,        // auto-deleted
				false,        // internal
				false,        // no-wait
				nil,          // arguments
			)
		}
	}

	return svc
}

// SendNotification queues a notification for sending
func (s *NotificationService) SendNotification(ctx context.Context, notif *Notification) error {
	if s.mqChannel == nil {
		// Fallback: log and return (or use direct send)
		return fmt.Errorf("message queue not available")
	}

	body, err := json.Marshal(notif)
	if err != nil {
		return fmt.Errorf("failed to marshal notification: %w", err)
	}

	routingKey := fmt.Sprintf("notification.%s.%s", notif.Type, notif.Priority)

	err = s.mqChannel.PublishWithContext(
		ctx,
		s.exchange,  // exchange
		routingKey,  // routing key
		false,       // mandatory
		false,       // immediate
		amqp.Publishing{
			ContentType:  "application/json",
			Body:         body,
			DeliveryMode: amqp.Persistent,
			Timestamp:    time.Now(),
		},
	)

	if err != nil {
		return fmt.Errorf("failed to publish notification: %w", err)
	}

	return nil
}

// SendBudgetAlert sends a budget threshold alert
func (s *NotificationService) SendBudgetAlert(ctx context.Context, userID string, alert BudgetAlertPayload) error {
	var title, body string
	var priority NotificationPriority

	switch alert.ThresholdType {
	case "warning":
		title = fmt.Sprintf("Budget Alert: %s", alert.BudgetName)
		body = fmt.Sprintf("You've used %.0f%% of your %s budget (₹%.2f of ₹%.2f)", 
			alert.PercentageUsed, alert.Category, alert.SpentAmount, alert.BudgetLimit)
		priority = PriorityNormal
	case "critical":
		title = fmt.Sprintf("⚠️ Budget Critical: %s", alert.BudgetName)
		body = fmt.Sprintf("You've used %.0f%% of your %s budget. Only ₹%.2f remaining!", 
			alert.PercentageUsed, alert.Category, alert.BudgetLimit-alert.SpentAmount)
		priority = PriorityHigh
	case "exceeded":
		title = fmt.Sprintf("🚨 Budget Exceeded: %s", alert.BudgetName)
		body = fmt.Sprintf("You've exceeded your %s budget by ₹%.2f!", 
			alert.Category, alert.SpentAmount-alert.BudgetLimit)
		priority = PriorityCritical
	}

	notif := &Notification{
		UserID:    userID,
		Type:      NotificationTypePush,
		Priority:  priority,
		Title:     title,
		Body:      body,
		Category:  "budget_alert",
		Data: map[string]any{
			"budget_id":       alert.BudgetID,
			"percentage_used": alert.PercentageUsed,
		},
		CreatedAt: time.Now(),
	}

	// Also send in-app notification
	inAppNotif := *notif
	inAppNotif.Type = NotificationTypeInApp
	
	if err := s.SendNotification(ctx, notif); err != nil {
		return err
	}
	return s.SendNotification(ctx, &inAppNotif)
}

// SendTransactionAlert sends a transaction-related alert
func (s *NotificationService) SendTransactionAlert(ctx context.Context, userID string, alert TransactionAlertPayload) error {
	var title, body string
	priority := PriorityHigh

	switch alert.AlertReason {
	case "large_amount":
		title = "Large Transaction Detected"
		body = fmt.Sprintf("₹%.2f spent at %s", alert.Amount, alert.MerchantName)
	case "unusual_merchant":
		title = "New Merchant Transaction"
		body = fmt.Sprintf("First transaction at %s: ₹%.2f", alert.MerchantName, alert.Amount)
		priority = PriorityNormal
	case "fraud_suspected":
		title = "🚨 Unusual Activity Detected"
		body = fmt.Sprintf("Please verify: ₹%.2f at %s", alert.Amount, alert.MerchantName)
		priority = PriorityCritical
	}

	notif := &Notification{
		UserID:    userID,
		Type:      NotificationTypePush,
		Priority:  priority,
		Title:     title,
		Body:      body,
		Category:  "transaction_alert",
		Data: map[string]any{
			"transaction_id": alert.TransactionID,
			"merchant":       alert.MerchantName,
			"amount":         alert.Amount,
		},
		CreatedAt: time.Now(),
	}

	return s.SendNotification(ctx, notif)
}

// Close closes the notification service connections
func (s *NotificationService) Close() error {
	if s.mqChannel != nil {
		return s.mqChannel.Close()
	}
	return nil
}
