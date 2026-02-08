// Package queue provides RabbitMQ message queue connections
package queue

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	amqp "github.com/rabbitmq/amqp091-go"
)

// Connection wraps an AMQP connection with reconnection logic
type Connection struct {
	conn    *amqp.Connection
	channel *amqp.Channel
	url     string
}

// NewConnection creates a new RabbitMQ connection
func NewConnection(url string) (*Connection, error) {
	if url == "" {
		return nil, fmt.Errorf("rabbitmq url is empty")
	}

	conn, err := amqp.Dial(url)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to RabbitMQ: %w", err)
	}

	channel, err := conn.Channel()
	if err != nil {
		conn.Close()
		return nil, fmt.Errorf("failed to open channel: %w", err)
	}

	return &Connection{
		conn:    conn,
		channel: channel,
		url:     url,
	}, nil
}

// Close closes the connection
func (c *Connection) Close() error {
	if c.channel != nil {
		c.channel.Close()
	}
	if c.conn != nil {
		return c.conn.Close()
	}
	return nil
}

// Channel returns the AMQP channel
func (c *Connection) Channel() *amqp.Channel {
	return c.channel
}

// GetAMQPConnection returns the raw AMQP connection
func (c *Connection) GetAMQPConnection() *amqp.Connection {
	return c.conn
}

// DeclareExchange declares an exchange
func (c *Connection) DeclareExchange(name, kind string) error {
	return c.channel.ExchangeDeclare(
		name,  // name
		kind,  // type
		true,  // durable
		false, // auto-deleted
		false, // internal
		false, // no-wait
		nil,   // arguments
	)
}

// DeclareQueue declares a queue
func (c *Connection) DeclareQueue(name string) (amqp.Queue, error) {
	return c.channel.QueueDeclare(
		name,  // name
		true,  // durable
		false, // delete when unused
		false, // exclusive
		false, // no-wait
		nil,   // arguments
	)
}

// BindQueue binds a queue to an exchange
func (c *Connection) BindQueue(queueName, routingKey, exchangeName string) error {
	return c.channel.QueueBind(
		queueName,    // queue name
		routingKey,   // routing key
		exchangeName, // exchange
		false,        // no-wait
		nil,          // arguments
	)
}

// Publish publishes a message to an exchange
func (c *Connection) Publish(ctx context.Context, exchange, routingKey string, body interface{}) error {
	data, err := json.Marshal(body)
	if err != nil {
		return fmt.Errorf("failed to marshal message: %w", err)
	}

	return c.channel.PublishWithContext(
		ctx,
		exchange,   // exchange
		routingKey, // routing key
		false,      // mandatory
		false,      // immediate
		amqp.Publishing{
			ContentType:  "application/json",
			Body:         data,
			DeliveryMode: amqp.Persistent,
			Timestamp:    time.Now(),
		},
	)
}

// Consume starts consuming messages from a queue
func (c *Connection) Consume(queueName, consumerTag string) (<-chan amqp.Delivery, error) {
	return c.channel.Consume(
		queueName,   // queue
		consumerTag, // consumer
		false,       // auto-ack
		false,       // exclusive
		false,       // no-local
		false,       // no-wait
		nil,         // args
	)
}

// PublishCategorizationRequest publishes a transaction for AI categorization
func (c *Connection) PublishCategorizationRequest(ctx context.Context, transactionID, merchantName string, amount float64) error {
	msg := map[string]interface{}{
		"transaction_id": transactionID,
		"merchant_name":  merchantName,
		"amount":         amount,
		"timestamp":      time.Now().UTC().Format(time.RFC3339),
	}

	return c.Publish(ctx, "ai", "categorization.request", msg)
}

// PublishNotification publishes a notification to be sent
func (c *Connection) PublishNotification(ctx context.Context, notification map[string]interface{}) error {
	return c.Publish(ctx, "notifications", "notification.send", notification)
}
