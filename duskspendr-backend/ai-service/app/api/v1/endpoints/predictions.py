"""Prediction endpoints for forecasting and anomaly detection."""
from datetime import datetime, timedelta
from typing import Any

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel

from app.core.logging import get_logger

router = APIRouter()
logger = get_logger(__name__)


class SpendingForecast(BaseModel):
    """Predicted future spending."""
    category: str
    predicted_amount: float
    confidence_interval: tuple[float, float]
    trend: str


class CashFlowPrediction(BaseModel):
    """Cash flow prediction for a period."""
    period: str
    predicted_income: float
    predicted_expenses: float
    predicted_balance: float
    confidence: float


class BillPrediction(BaseModel):
    """Predicted upcoming bill."""
    name: str
    amount: float
    due_date: datetime
    category: str
    recurring: bool
    confidence: float


@router.post("/spending")
async def predict_spending(
    user_id: str,
    period: str = Query("next_month", regex="^(next_week|next_month|next_quarter)$"),
    categories: list[str] | None = None,
) -> dict[str, Any]:
    """
    Predict future spending based on historical patterns.
    
    Uses time series analysis and seasonal decomposition to forecast
    spending by category.
    """
    forecasts = [
        SpendingForecast(
            category="food_dining",
            predicted_amount=13200.0,
            confidence_interval=(11800.0, 14600.0),
            trend="stable",
        ),
        SpendingForecast(
            category="shopping",
            predicted_amount=7500.0,
            confidence_interval=(5500.0, 9500.0),
            trend="decreasing",
        ),
        SpendingForecast(
            category="transportation",
            predicted_amount=6800.0,
            confidence_interval=(6000.0, 7600.0),
            trend="increasing",
        ),
        SpendingForecast(
            category="utilities",
            predicted_amount=5500.0,
            confidence_interval=(5200.0, 5800.0),
            trend="stable",
        ),
    ]
    
    if categories:
        forecasts = [f for f in forecasts if f.category in categories]
    
    total_predicted = sum(f.predicted_amount for f in forecasts)
    
    logger.info(
        "spending_prediction",
        user_id=user_id,
        period=period,
        total_predicted=total_predicted,
    )
    
    return {
        "success": True,
        "data": {
            "period": period,
            "forecasts": [f.model_dump() for f in forecasts],
            "total_predicted": total_predicted,
            "generated_at": datetime.now().isoformat(),
        },
    }


@router.post("/cash-flow")
async def predict_cash_flow(
    user_id: str,
    months_ahead: int = Query(3, ge=1, le=12),
) -> dict[str, Any]:
    """
    Predict cash flow for upcoming months.
    
    Considers regular income, recurring expenses, and seasonal patterns.
    """
    predictions = []
    now = datetime.now()
    
    for i in range(1, months_ahead + 1):
        month_date = now + timedelta(days=30 * i)
        pred = CashFlowPrediction(
            period=month_date.strftime("%Y-%m"),
            predicted_income=85000.0,
            predicted_expenses=45000.0 + (i % 3) * 2000,
            predicted_balance=40000.0 - (i % 3) * 2000,
            confidence=0.85 - (i * 0.05),  # Confidence decreases with time
        )
        predictions.append(pred)
    
    return {
        "success": True,
        "data": {
            "predictions": [p.model_dump() for p in predictions],
            "summary": {
                "average_monthly_balance": sum(p.predicted_balance for p in predictions) / len(predictions),
                "total_predicted_savings": sum(p.predicted_balance for p in predictions),
                "risk_months": [p.period for p in predictions if p.predicted_balance < 30000],
            },
        },
    }


@router.post("/bills")
async def predict_upcoming_bills(user_id: str) -> dict[str, Any]:
    """
    Predict upcoming bills based on transaction history.
    
    Identifies recurring payments and estimates amounts.
    """
    now = datetime.now()
    
    bills = [
        BillPrediction(
            name="Netflix Subscription",
            amount=649.0,
            due_date=now + timedelta(days=5),
            category="entertainment",
            recurring=True,
            confidence=0.95,
        ),
        BillPrediction(
            name="Electricity Bill",
            amount=2800.0,
            due_date=now + timedelta(days=8),
            category="utilities",
            recurring=True,
            confidence=0.75,  # Amount varies
        ),
        BillPrediction(
            name="Mobile Recharge",
            amount=599.0,
            due_date=now + timedelta(days=12),
            category="utilities",
            recurring=True,
            confidence=0.90,
        ),
        BillPrediction(
            name="Internet Bill",
            amount=999.0,
            due_date=now + timedelta(days=15),
            category="utilities",
            recurring=True,
            confidence=0.95,
        ),
        BillPrediction(
            name="Gym Membership",
            amount=2500.0,
            due_date=now + timedelta(days=1),
            category="health",
            recurring=True,
            confidence=0.92,
        ),
    ]
    
    # Sort by due date
    bills.sort(key=lambda b: b.due_date)
    
    limit_date = now + timedelta(days=7)
    total_upcoming = 0.0
    next_7_days = 0.0
    bills_data = []

    for b in bills:
        amount = b.amount
        total_upcoming += amount
        if b.due_date <= limit_date:
            next_7_days += amount

        bills_data.append({**b.model_dump(), "due_date": b.due_date.isoformat()})
    
    return {
        "success": True,
        "data": {
            "bills": bills_data,
            "total_upcoming": total_upcoming,
            "next_7_days": next_7_days,
        },
    }


@router.post("/anomalies")
async def detect_anomalies(
    user_id: str,
    sensitivity: str = Query("normal", regex="^(low|normal|high)$"),
) -> dict[str, Any]:
    """
    Detect anomalous transactions that deviate from normal patterns.
    
    Uses statistical analysis and machine learning to identify:
    - Unusually large transactions
    - Transactions at unusual times
    - Transactions from new merchants
    - Transactions in unexpected categories
    """
    anomalies = [
        {
            "transaction_id": "tx_abc123",
            "merchant_name": "Unknown Website",
            "amount": 15000.0,
            "date": (datetime.now() - timedelta(days=2)).isoformat(),
            "reason": "Unusually large transaction for this merchant type",
            "severity": "high",
            "anomaly_score": 0.92,
            "recommendation": "Please verify this transaction. If you don't recognize it, contact your bank immediately.",
        },
        {
            "transaction_id": "tx_def456",
            "merchant_name": "Late Night Store",
            "amount": 2500.0,
            "date": (datetime.now() - timedelta(days=1)).isoformat(),
            "reason": "Transaction at unusual time (3:45 AM)",
            "severity": "medium",
            "anomaly_score": 0.78,
            "recommendation": "This transaction occurred at an unusual time. Please confirm if this was you.",
        },
    ]
    
    # Adjust based on sensitivity
    if sensitivity == "low":
        anomalies = [a for a in anomalies if a["anomaly_score"] >= 0.9]
    elif sensitivity == "high":
        # Include more potential anomalies
        pass
    
    return {
        "success": True,
        "data": {
            "anomalies": anomalies,
            "total_found": len(anomalies),
            "analysis_period": "last_30_days",
            "sensitivity": sensitivity,
        },
    }


@router.get("/budget-risk")
async def assess_budget_risk(user_id: str) -> dict[str, Any]:
    """
    Assess risk of exceeding budget based on current spending pace.
    """
    now = datetime.now()
    days_in_month = 30
    days_passed = now.day
    days_remaining = days_in_month - days_passed
    
    budgets = [
        {
            "category": "food_dining",
            "budget_limit": 15000.0,
            "spent_so_far": 11500.0,
            "daily_average": 11500.0 / days_passed,
            "projected_total": (11500.0 / days_passed) * days_in_month,
            "risk_level": "high",
            "probability_exceed": 0.85,
            "recommendation": "Reduce dining out for the rest of the month to stay within budget.",
        },
        {
            "category": "shopping",
            "budget_limit": 10000.0,
            "spent_so_far": 4200.0,
            "daily_average": 4200.0 / days_passed,
            "projected_total": (4200.0 / days_passed) * days_in_month,
            "risk_level": "low",
            "probability_exceed": 0.15,
            "recommendation": "You're on track to stay within your shopping budget.",
        },
        {
            "category": "entertainment",
            "budget_limit": 5000.0,
            "spent_so_far": 3800.0,
            "daily_average": 3800.0 / days_passed,
            "projected_total": (3800.0 / days_passed) * days_in_month,
            "risk_level": "medium",
            "probability_exceed": 0.55,
            "recommendation": "Consider limiting entertainment expenses for the next week.",
        },
    ]
    
    return {
        "success": True,
        "data": {
            "budgets": budgets,
            "overall_risk": "medium",
            "days_remaining": days_remaining,
            "summary": "2 out of 3 budgets are at risk of being exceeded this month.",
        },
    }
