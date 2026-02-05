"""Configuration settings for AI service."""
from functools import lru_cache
from typing import Any

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
    )

    # API
    API_V1_PREFIX: str = "/api/v1/ai"
    ENABLE_DOCS: bool = True
    
    # Environment
    ENV: str = "development"
    DEBUG: bool = False
    
    # CORS
    ALLOWED_ORIGINS: list[str] = ["*"]
    
    @field_validator("ALLOWED_ORIGINS", mode="before")
    @classmethod
    def parse_origins(cls, v: Any) -> list[str]:
        if isinstance(v, str):
            return [origin.strip() for origin in v.split(",")]
        return v
    
    # Database
    DATABASE_URL: str = "postgresql://postgres:postgres@localhost:5432/duskspendr"
    
    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"
    
    # RabbitMQ
    RABBITMQ_URL: str = "amqp://guest:guest@localhost:5672/"
    
    # ML Models
    CATEGORIZER_MODEL_PATH: str = "./models/transaction_categorizer"
    SENTIMENT_MODEL_PATH: str = "./models/sentiment_analyzer"
    ANOMALY_MODEL_PATH: str = "./models/anomaly_detector"
    
    # Model settings
    CATEGORIZATION_CONFIDENCE_THRESHOLD: float = 0.7
    ANOMALY_SCORE_THRESHOLD: float = 0.85
    
    # Gateway service
    GATEWAY_URL: str = "http://localhost:8000"
    
    # OpenTelemetry
    OTEL_EXPORTER_OTLP_ENDPOINT: str = "http://localhost:4317"
    OTEL_SERVICE_NAME: str = "duskspendr-ai-service"


@lru_cache
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()


settings = get_settings()
