"""Application configuration using pydantic-settings."""
from functools import lru_cache
from typing import Annotated, Any

from pydantic import BeforeValidator
from pydantic_settings import BaseSettings, SettingsConfigDict


def parse_cors(v: Any) -> list[str] | str:
    if isinstance(v, str) and not v.startswith("["):
        return [i.strip() for i in v.split(",")]
    elif isinstance(v, list):
        return v
    elif isinstance(v, str) and v.startswith("["):
        return v
    return v


class Settings(BaseSettings):
    """Analytics service configuration."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # Application
    app_name: str = "DuskSpendr Analytics Service"
    app_version: str = "1.0.0"
    environment: str = "development"
    debug: bool = False

    # Server
    host: str = "0.0.0.0"
    port: int = 8002

    # Database
    database_url: str = "postgresql+asyncpg://duskspendr:password@localhost:5432/duskspendr"

    # Redis
    redis_url: str = "redis://localhost:6379/1"

    # CORS
    cors_origins: Annotated[list[str] | str, BeforeValidator(parse_cors)] = []

    # Logging
    log_level: str = "INFO"
    log_format: str = "json"


@lru_cache
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()
