package config

import (
	"os"
	"strconv"
	"time"
)

type Config struct {
	// Environment
	Env      string
	HTTPAddr string
	LogLevel string

	// Database
	DatabaseURL string

	// Redis
	RedisURL string

	// RabbitMQ
	RabbitMQURL string

	// Serverpod
	ServerpodURL string

	// JWT
	JWTSecret            string
	JWTRefreshSecret     string
	JWTAccessExpiry      time.Duration
	JWTRefreshExpiry     time.Duration
	AllowedOrigins       string

	// Auth
	AuthPepper           string
	DataEncryptionKey    string
	OTPMaxPerHour        int
	OTPMinSecondsBetween int
	OTPMaxAttempts       int
	OTPMaxPerIPPerHour   int

	// Services
	AIServiceURL        string
	AnalyticsServiceURL string

	// Rate limiting
	RateLimitRequests int
	RateLimitWindow   time.Duration

	// Sync
	SyncSharedSecret string
	SyncIngestRPM    int
	SyncIngestBurst  int
	SyncIngestIPRPM  int
}

func Load() Config {
	return Config{
		// Environment
		Env:      getEnv("APP_ENV", "local"),
		HTTPAddr: getEnv("HTTP_ADDR", ":8000"),
		LogLevel: getEnv("LOG_LEVEL", "info"),

		// Database
		DatabaseURL: getEnv("DATABASE_URL", ""),

		// Redis
		RedisURL: getEnv("REDIS_URL", "redis://localhost:6379/0"),

		// RabbitMQ
		RabbitMQURL: getEnv("RABBITMQ_URL", "amqp://guest:guest@localhost:5672/"),

		// Serverpod
		ServerpodURL: getEnv("SERVERPOD_URL", "http://localhost:8090"),

		// JWT
		JWTSecret:        getEnv("JWT_SECRET", "your-super-secret-key-change-in-production"),
		JWTRefreshSecret: getEnv("JWT_REFRESH_SECRET", "your-refresh-secret-key-change-in-production"),
		JWTAccessExpiry:  getDurationEnv("JWT_ACCESS_EXPIRY", 15*time.Minute),
		JWTRefreshExpiry: getDurationEnv("JWT_REFRESH_EXPIRY", 7*24*time.Hour),
		AllowedOrigins:   getEnv("ALLOWED_ORIGINS", "*"),

		// Auth
		AuthPepper:           getEnv("AUTH_PEPPER", ""),
		DataEncryptionKey:    getEnv("DATA_ENCRYPTION_KEY", "0123456789abcdef0123456789abcdef"),
		OTPMaxPerHour:        getEnvInt("OTP_MAX_PER_HOUR", 5),
		OTPMinSecondsBetween: getEnvInt("OTP_MIN_SECONDS_BETWEEN", 60),
		OTPMaxAttempts:       getEnvInt("OTP_MAX_ATTEMPTS", 5),
		OTPMaxPerIPPerHour:   getEnvInt("OTP_MAX_PER_IP_PER_HOUR", 30),

		// Services
		AIServiceURL:        getEnv("AI_SERVICE_URL", "http://localhost:8001"),
		AnalyticsServiceURL: getEnv("ANALYTICS_SERVICE_URL", "http://localhost:8002"),

		// Rate limiting
		RateLimitRequests: getEnvInt("RATE_LIMIT_REQUESTS", 100),
		RateLimitWindow:   getDurationEnv("RATE_LIMIT_WINDOW", time.Minute),

		// Sync
		SyncSharedSecret: getEnv("SYNC_SHARED_SECRET", ""),
		SyncIngestRPM:    getEnvInt("SYNC_INGEST_RPM", 120),
		SyncIngestBurst:  getEnvInt("SYNC_INGEST_BURST", 60),
		SyncIngestIPRPM:  getEnvInt("SYNC_INGEST_IP_RPM", 600),
	}
}

func getEnv(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}

func getEnvInt(key string, def int) int {
	if v := os.Getenv(key); v != "" {
		if parsed, err := strconv.Atoi(v); err == nil {
			return parsed
		}
	}
	return def
}

func getDurationEnv(key string, def time.Duration) time.Duration {
	if v := os.Getenv(key); v != "" {
		if parsed, err := time.ParseDuration(v); err == nil {
			return parsed
		}
	}
	return def
}
