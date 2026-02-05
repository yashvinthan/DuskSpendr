"""Metrics endpoints for analytics."""
from datetime import datetime, timedelta
from typing import Any

import structlog
from fastapi import APIRouter, Query
from pydantic import BaseModel, Field

logger = structlog.get_logger()
router = APIRouter()


class MetricValue(BaseModel):
    """Metric value with timestamp."""
    timestamp: datetime
    value: float


class MetricSeries(BaseModel):
    """Time series metric data."""
    name: str
    unit: str
    values: list[MetricValue]
    total: float | None = None
    average: float | None = None


class UserMetrics(BaseModel):
    """User activity metrics."""
    active_users_daily: int
    active_users_weekly: int
    active_users_monthly: int
    new_users_today: int
    retention_rate: float


class TransactionMetrics(BaseModel):
    """Transaction metrics."""
    total_transactions: int
    total_amount: float
    average_transaction: float
    transactions_today: int
    amount_today: float


@router.get("/users", response_model=UserMetrics)
async def get_user_metrics() -> UserMetrics:
    """
    Get user activity metrics.

    Returns daily, weekly, and monthly active user counts.
    """
    # Mock data - replace with real database queries
    return UserMetrics(
        active_users_daily=1250,
        active_users_weekly=4820,
        active_users_monthly=12450,
        new_users_today=45,
        retention_rate=0.72,
    )


@router.get("/transactions", response_model=TransactionMetrics)
async def get_transaction_metrics() -> TransactionMetrics:
    """
    Get transaction metrics.

    Returns totals, averages, and daily counts.
    """
    # Mock data - replace with real database queries
    return TransactionMetrics(
        total_transactions=285420,
        total_amount=15842650.50,
        average_transaction=55.50,
        transactions_today=1240,
        amount_today=68420.25,
    )


@router.get("/time-series/{metric_name}")
async def get_time_series(
    metric_name: str,
    start_date: datetime = Query(default=None, description="Start date"),
    end_date: datetime = Query(default=None, description="End date"),
    granularity: str = Query(default="day", description="Data granularity: hour, day, week"),
) -> MetricSeries:
    """
    Get time series data for a specific metric.

    Supported metrics:
    - active_users: Active user count over time
    - transactions: Transaction count over time
    - transaction_amount: Total transaction amount over time
    - signups: New user signups over time
    """
    if end_date is None:
        end_date = datetime.utcnow()
    if start_date is None:
        start_date = end_date - timedelta(days=30)

    # Generate mock time series data
    values: list[MetricValue] = []
    current = start_date
    delta = timedelta(days=1) if granularity == "day" else (
        timedelta(hours=1) if granularity == "hour" else timedelta(weeks=1)
    )

    import random
    random.seed(42)  # Consistent mock data

    base_value = {
        "active_users": 1000,
        "transactions": 500,
        "transaction_amount": 25000,
        "signups": 50,
    }.get(metric_name, 100)

    while current <= end_date:
        value = base_value + random.randint(-int(base_value * 0.2), int(base_value * 0.3))
        values.append(MetricValue(timestamp=current, value=float(value)))
        current += delta

    total = sum(v.value for v in values)
    average = total / len(values) if values else 0

    unit = {
        "active_users": "users",
        "transactions": "count",
        "transaction_amount": "INR",
        "signups": "users",
    }.get(metric_name, "count")

    return MetricSeries(
        name=metric_name,
        unit=unit,
        values=values,
        total=total,
        average=average,
    )


@router.get("/feature-usage")
async def get_feature_usage() -> dict[str, Any]:
    """
    Get feature usage statistics.

    Returns usage counts for different app features.
    """
    return {
        "features": [
            {"name": "transaction_add", "count": 45280, "percentage": 95.2},
            {"name": "budget_create", "count": 12450, "percentage": 26.2},
            {"name": "budget_alert", "count": 8920, "percentage": 18.8},
            {"name": "category_view", "count": 38500, "percentage": 81.0},
            {"name": "analytics_view", "count": 22100, "percentage": 46.5},
            {"name": "export_data", "count": 5420, "percentage": 11.4},
            {"name": "split_expense", "count": 3280, "percentage": 6.9},
            {"name": "recurring_setup", "count": 4150, "percentage": 8.7},
        ],
        "total_users": 47560,
        "period": "last_30_days",
    }


@router.get("/conversion")
async def get_conversion_metrics() -> dict[str, Any]:
    """
    Get conversion funnel metrics.

    Returns conversion rates through key user journeys.
    """
    return {
        "funnels": [
            {
                "name": "onboarding",
                "steps": [
                    {"name": "app_open", "count": 50000, "rate": 1.0},
                    {"name": "signup_start", "count": 35000, "rate": 0.70},
                    {"name": "signup_complete", "count": 28000, "rate": 0.80},
                    {"name": "first_transaction", "count": 18500, "rate": 0.66},
                    {"name": "first_budget", "count": 8400, "rate": 0.45},
                ],
                "overall_rate": 0.168,
            },
            {
                "name": "budget_creation",
                "steps": [
                    {"name": "budget_page_view", "count": 25000, "rate": 1.0},
                    {"name": "budget_form_start", "count": 15000, "rate": 0.60},
                    {"name": "budget_saved", "count": 12450, "rate": 0.83},
                ],
                "overall_rate": 0.498,
            },
        ],
        "period": "last_30_days",
    }
