"""Dashboard endpoints for analytics."""
from datetime import datetime, timedelta
from typing import Any

import structlog
from fastapi import APIRouter, Query
from pydantic import BaseModel, Field

logger = structlog.get_logger()
router = APIRouter()


class DashboardSummary(BaseModel):
    """Dashboard summary metrics."""
    total_users: int
    active_users_today: int
    total_transactions: int
    transactions_today: int
    total_volume: float
    volume_today: float
    avg_transactions_per_user: float
    user_growth_rate: float
    transaction_growth_rate: float


class CategoryBreakdown(BaseModel):
    """Category spending breakdown."""
    category: str
    amount: float
    percentage: float
    transaction_count: int
    trend: str  # up, down, stable


class TopMerchant(BaseModel):
    """Top merchant by transaction volume."""
    name: str
    transaction_count: int
    total_amount: float


@router.get("/summary", response_model=DashboardSummary)
async def get_dashboard_summary() -> DashboardSummary:
    """
    Get dashboard summary with key metrics.

    Returns aggregated metrics for the dashboard overview.
    """
    return DashboardSummary(
        total_users=47560,
        active_users_today=8420,
        total_transactions=285420,
        transactions_today=4520,
        total_volume=15842650.50,
        volume_today=245820.75,
        avg_transactions_per_user=6.0,
        user_growth_rate=0.045,
        transaction_growth_rate=0.062,
    )


@router.get("/categories")
async def get_category_breakdown(
    user_id: str | None = Query(None, description="Filter by user ID"),
    start_date: datetime | None = Query(None, description="Start date"),
    end_date: datetime | None = Query(None, description="End date"),
) -> dict[str, Any]:
    """
    Get spending breakdown by category.

    Returns category-wise spending analysis.
    """
    categories = [
        CategoryBreakdown(
            category="Food & Dining",
            amount=45280.50,
            percentage=28.5,
            transaction_count=892,
            trend="up",
        ),
        CategoryBreakdown(
            category="Shopping",
            amount=32150.25,
            percentage=20.2,
            transaction_count=456,
            trend="stable",
        ),
        CategoryBreakdown(
            category="Transportation",
            amount=18420.00,
            percentage=11.6,
            transaction_count=324,
            trend="down",
        ),
        CategoryBreakdown(
            category="Entertainment",
            amount=15840.75,
            percentage=10.0,
            transaction_count=198,
            trend="up",
        ),
        CategoryBreakdown(
            category="Bills & Utilities",
            amount=24560.00,
            percentage=15.4,
            transaction_count=86,
            trend="stable",
        ),
        CategoryBreakdown(
            category="Healthcare",
            amount=8420.50,
            percentage=5.3,
            transaction_count=42,
            trend="up",
        ),
        CategoryBreakdown(
            category="Other",
            amount=14328.00,
            percentage=9.0,
            transaction_count=215,
            trend="stable",
        ),
    ]

    return {
        "categories": [c.model_dump() for c in categories],
        "total_amount": sum(c.amount for c in categories),
        "period": {
            "start": start_date or (datetime.utcnow() - timedelta(days=30)),
            "end": end_date or datetime.utcnow(),
        },
    }


@router.get("/merchants/top")
async def get_top_merchants(
    limit: int = Query(10, ge=1, le=50, description="Number of merchants to return"),
) -> dict[str, Any]:
    """
    Get top merchants by transaction volume.

    Returns most frequently used merchants.
    """
    merchants = [
        TopMerchant(name="Amazon", transaction_count=1542, total_amount=125480.50),
        TopMerchant(name="Swiggy", transaction_count=892, total_amount=35620.25),
        TopMerchant(name="Uber", transaction_count=654, total_amount=28450.00),
        TopMerchant(name="BigBasket", transaction_count=423, total_amount=42180.75),
        TopMerchant(name="Netflix", transaction_count=380, total_amount=6080.00),
        TopMerchant(name="Zomato", transaction_count=356, total_amount=14240.50),
        TopMerchant(name="Flipkart", transaction_count=298, total_amount=85420.25),
        TopMerchant(name="PhonePe Recharge", transaction_count=245, total_amount=12250.00),
        TopMerchant(name="Ola", transaction_count=234, total_amount=11700.00),
        TopMerchant(name="Zepto", transaction_count=189, total_amount=9450.50),
    ]

    return {
        "merchants": [m.model_dump() for m in merchants[:limit]],
        "total_merchants": len(merchants),
    }


@router.get("/trends")
async def get_spending_trends(
    period: str = Query("weekly", description="Trend period: daily, weekly, monthly"),
) -> dict[str, Any]:
    """
    Get spending trends over time.

    Returns trend data for visualization.
    """
    import random
    random.seed(42)

    if period == "daily":
        points = 30
        delta = timedelta(days=1)
        base = 8000
    elif period == "weekly":
        points = 12
        delta = timedelta(weeks=1)
        base = 56000
    else:  # monthly
        points = 12
        delta = timedelta(days=30)
        base = 240000

    now = datetime.utcnow()
    trends = []

    for i in range(points):
        date = now - (delta * (points - i - 1))
        value = base + random.randint(-int(base * 0.15), int(base * 0.2))
        trends.append({
            "date": date.isoformat(),
            "amount": value,
            "transaction_count": value // 55,
        })

    return {
        "period": period,
        "data": trends,
        "summary": {
            "total": sum(t["amount"] for t in trends),
            "average": sum(t["amount"] for t in trends) / len(trends),
            "min": min(t["amount"] for t in trends),
            "max": max(t["amount"] for t in trends),
        },
    }


@router.get("/insights")
async def get_user_insights(
    user_id: str | None = Query(None, description="Filter by user ID"),
) -> dict[str, Any]:
    """
    Get personalized spending insights.

    Returns AI-generated insights about spending patterns.
    """
    return {
        "insights": [
            {
                "type": "spending_spike",
                "title": "Unusual spending in Entertainment",
                "description": "Your entertainment spending increased by 45% compared to last month.",
                "severity": "info",
                "category": "Entertainment",
                "amount_change": 2450.50,
                "percentage_change": 45.2,
            },
            {
                "type": "budget_warning",
                "title": "Food budget at 85%",
                "description": "You've used 85% of your monthly food budget with 8 days remaining.",
                "severity": "warning",
                "category": "Food & Dining",
                "budget_used": 0.85,
                "days_remaining": 8,
            },
            {
                "type": "saving_opportunity",
                "title": "Potential savings identified",
                "description": "Switching to a yearly Netflix subscription could save ₹960/year.",
                "severity": "info",
                "potential_savings": 960.00,
                "merchant": "Netflix",
            },
            {
                "type": "positive_trend",
                "title": "Great progress on Transportation",
                "description": "You've reduced transportation spending by 12% compared to last month.",
                "severity": "success",
                "category": "Transportation",
                "amount_saved": 1850.25,
                "percentage_change": -12.3,
            },
        ],
        "generated_at": datetime.utcnow().isoformat(),
    }
