"""Financial insights endpoints."""
from datetime import datetime, timedelta
from typing import Any

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel

from app.core.logging import get_logger
from app.services.insights_service import InsightsService

router = APIRouter()
logger = get_logger(__name__)


class SpendingPattern(BaseModel):
    """Spending pattern analysis."""
    category: str
    current_amount: float
    previous_amount: float
    change_percentage: float
    trend: str  # "increasing", "decreasing", "stable"
    insight: str


class AnomalyAlert(BaseModel):
    """Unusual transaction alert."""
    transaction_id: str
    merchant_name: str
    amount: float
    reason: str
    severity: str  # "low", "medium", "high"
    recommendation: str


class SavingsOpportunity(BaseModel):
    """Suggested savings opportunity."""
    category: str
    potential_savings: float
    description: str
    difficulty: str  # "easy", "medium", "hard"
    impact: str


class InsightsResponse(BaseModel):
    """Complete insights response."""
    spending_patterns: list[SpendingPattern]
    anomalies: list[AnomalyAlert]
    savings_opportunities: list[SavingsOpportunity]
    summary: str
    health_score: int  # 0-100


@router.post("", response_model=InsightsResponse)
async def generate_insights(
    user_id: str,
    period: str = Query("month", regex="^(week|month|quarter|year)$"),
) -> InsightsResponse:
    """
    Generate personalized financial insights for a user.
    
    Analyzes spending patterns, detects anomalies, and suggests
    savings opportunities based on transaction history.
    """
    try:
        service = InsightsService()
        insights = await service.generate_for_user(user_id, period)
        
        logger.info(
            "insights_generated",
            user_id=user_id,
            period=period,
            patterns_count=len(insights.spending_patterns),
            anomalies_count=len(insights.anomalies),
        )
        
        return insights
    except Exception as e:
        logger.error("insights_generation_failed", user_id=user_id, error=str(e))
        raise HTTPException(status_code=500, detail="Failed to generate insights")


@router.get("/spending-analysis")
async def analyze_spending(
    user_id: str,
    start_date: datetime | None = None,
    end_date: datetime | None = None,
) -> dict[str, Any]:
    """
    Detailed spending analysis by category and time period.
    """
    if end_date is None:
        end_date = datetime.now()
    if start_date is None:
        start_date = end_date - timedelta(days=30)
    
    # Mock analysis - in production, this queries actual data
    analysis = {
        "period": {
            "start": start_date.isoformat(),
            "end": end_date.isoformat(),
        },
        "total_spent": 45670.50,
        "total_income": 85000.00,
        "net_savings": 39329.50,
        "savings_rate": 46.3,
        "by_category": {
            "food_dining": {"amount": 12500.00, "percentage": 27.4, "transactions": 45},
            "shopping": {"amount": 8900.00, "percentage": 19.5, "transactions": 23},
            "transportation": {"amount": 6500.00, "percentage": 14.2, "transactions": 30},
            "utilities": {"amount": 5200.00, "percentage": 11.4, "transactions": 8},
            "entertainment": {"amount": 4800.00, "percentage": 10.5, "transactions": 15},
            "other": {"amount": 7770.50, "percentage": 17.0, "transactions": 28},
        },
        "daily_average": 1522.35,
        "comparison": {
            "vs_previous_period": -8.5,  # Spent 8.5% less
            "vs_similar_users": "+12.3",  # Spends 12.3% more than average
        },
    }
    
    return {"success": True, "data": analysis}


@router.get("/trends")
async def get_spending_trends(
    user_id: str,
    months: int = Query(6, ge=1, le=24),
) -> dict[str, Any]:
    """
    Get monthly spending trends over time.
    """
    # Generate mock trend data
    trends = []
    now = datetime.now()
    
    for i in range(months - 1, -1, -1):
        month_date = now - timedelta(days=30 * i)
        trends.append({
            "month": month_date.strftime("%Y-%m"),
            "spent": 40000 + (i * 1500) + (i % 3) * 2000,
            "income": 85000,
            "categories": {
                "food_dining": 10000 + (i % 4) * 500,
                "shopping": 7000 + (i % 3) * 1000,
                "transportation": 5500 + (i % 2) * 500,
            },
        })
    
    return {
        "success": True,
        "data": {
            "trends": trends,
            "overall_trend": "decreasing",  # spending is decreasing
            "best_month": trends[-2]["month"],
            "worst_month": trends[0]["month"],
        },
    }


@router.get("/recommendations")
async def get_recommendations(user_id: str) -> dict[str, Any]:
    """
    Get personalized financial recommendations.
    """
    recommendations = [
        {
            "id": "rec_001",
            "type": "savings",
            "title": "Reduce dining out",
            "description": "You spent ₹12,500 on dining this month. Cooking at home 2 more days/week could save ₹3,000/month.",
            "potential_savings": 3000,
            "priority": "high",
            "category": "food_dining",
        },
        {
            "id": "rec_002",
            "type": "investment",
            "title": "Start a SIP",
            "description": "Based on your income and expenses, you could invest ₹10,000/month in a diversified mutual fund.",
            "potential_roi": "12-15% annually",
            "priority": "medium",
            "category": "investment",
        },
        {
            "id": "rec_003",
            "type": "budget",
            "title": "Set category budgets",
            "description": "Your shopping expenses vary a lot. Setting a ₹8,000 monthly limit could help control spending.",
            "potential_savings": 2000,
            "priority": "medium",
            "category": "shopping",
        },
    ]
    
    return {"success": True, "recommendations": recommendations}
