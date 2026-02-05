"""
DuskSpendr AI Service
FastAPI-based machine learning service for transaction categorization and insights
"""
from contextlib import asynccontextmanager
from typing import Any

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator

from app.api.v1.router import api_router
from app.core.config import settings
from app.core.logging import setup_logging


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan events."""
    # Startup
    setup_logging()
    # Load ML models
    from app.ml.models import load_models
    await load_models()
    yield
    # Shutdown
    from app.ml.models import unload_models
    await unload_models()


app = FastAPI(
    title="DuskSpendr AI Service",
    description="AI/ML microservice for transaction categorization, insights, and predictions",
    version="1.0.0",
    openapi_url=f"{settings.API_V1_PREFIX}/openapi.json" if settings.ENABLE_DOCS else None,
    docs_url=f"{settings.API_V1_PREFIX}/docs" if settings.ENABLE_DOCS else None,
    redoc_url=f"{settings.API_V1_PREFIX}/redoc" if settings.ENABLE_DOCS else None,
    lifespan=lifespan,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Prometheus metrics
Instrumentator().instrument(app).expose(app)

# Include API router
app.include_router(api_router, prefix=settings.API_V1_PREFIX)


@app.get("/health")
async def health_check() -> dict[str, Any]:
    """Health check endpoint."""
    return {
        "status": "healthy",
        "service": "ai-service",
        "version": "1.0.0",
    }


@app.get("/ready")
async def readiness_check() -> dict[str, Any]:
    """Readiness check endpoint."""
    from app.ml.models import get_model_status
    models = await get_model_status()
    return {
        "ready": all(m["loaded"] for m in models.values()),
        "models": models,
    }
