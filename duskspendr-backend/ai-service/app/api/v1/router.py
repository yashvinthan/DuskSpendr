"""API v1 router."""
from fastapi import APIRouter

from app.api.v1.endpoints import categorization, insights, predictions

api_router = APIRouter()

api_router.include_router(
    categorization.router,
    prefix="/categorize",
    tags=["Categorization"],
)

api_router.include_router(
    insights.router,
    prefix="/insights",
    tags=["Insights"],
)

api_router.include_router(
    predictions.router,
    prefix="/predict",
    tags=["Predictions"],
)
