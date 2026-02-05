"""API v1 router combining all endpoints."""
from fastapi import APIRouter

from app.api.v1.endpoints import events, metrics, dashboard

router = APIRouter()

router.include_router(events.router, prefix="/events", tags=["events"])
router.include_router(metrics.router, prefix="/metrics", tags=["metrics"])
router.include_router(dashboard.router, prefix="/dashboard", tags=["dashboard"])
