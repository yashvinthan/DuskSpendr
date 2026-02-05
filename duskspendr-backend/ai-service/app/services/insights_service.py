"""Insights generation service."""
from datetime import datetime, timedelta
from typing import Any

from app.core.logging import get_logger

logger = get_logger(__name__)


class SpendingPattern:
    """Spending pattern analysis."""
    def __init__(
        self,
        category: str,
        current_amount: float,
        previous_amount: float,
        change_percentage: float,
        trend: str,
        insight: str,
    ):
        self.category = category
        self.current_amount = current_amount
        self.previous_amount = previous_amount
        self.change_percentage = change_percentage
        self.trend = trend
        self.insight = insight


class AnomalyAlert:
    """Unusual transaction alert."""
    def __init__(
        self,
        transaction_id: str,
        merchant_name: str,
        amount: float,
        reason: str,
        severity: str,
        recommendation: str,
    ):
        self.transaction_id = transaction_id
        self.merchant_name = merchant_name
        self.amount = amount
        self.reason = reason
        self.severity = severity
        self.recommendation = recommendation


class SavingsOpportunity:
    """Suggested savings opportunity."""
    def __init__(
        self,
        category: str,
        potential_savings: float,
        description: str,
        difficulty: str,
        impact: str,
    ):
        self.category = category
        self.potential_savings = potential_savings
        self.description = description
        self.difficulty = difficulty
        self.impact = impact


class InsightsResponse:
    """Complete insights response."""
    def __init__(
        self,
        spending_patterns: list,
        anomalies: list,
        savings_opportunities: list,
        summary: str,
        health_score: int,
    ):
        self.spending_patterns = spending_patterns
        self.anomalies = anomalies
        self.savings_opportunities = savings_opportunities
        self.summary = summary
        self.health_score = health_score


class InsightsService:
    """Service for generating financial insights."""
    
    async def generate_for_user(self, user_id: str, period: str) -> InsightsResponse:
        """Generate comprehensive insights for a user."""
        
        # In production, this would fetch real transaction data
        # For now, generate mock insights
        
        spending_patterns = [
            SpendingPattern(
                category="food_dining",
                current_amount=12500.0,
                previous_amount=14200.0,
                change_percentage=-12.0,
                trend="decreasing",
                insight="Great job! You've reduced dining expenses by 12% this month.",
            ),
            SpendingPattern(
                category="shopping",
                current_amount=8900.0,
                previous_amount=6500.0,
                change_percentage=36.9,
                trend="increasing",
                insight="Shopping expenses increased significantly. Consider setting a budget.",
            ),
            SpendingPattern(
                category="transportation",
                current_amount=6500.0,
                previous_amount=6200.0,
                change_percentage=4.8,
                trend="stable",
                insight="Transportation costs are relatively stable.",
            ),
        ]
        
        anomalies = [
            AnomalyAlert(
                transaction_id="tx_unusual_001",
                merchant_name="International Website",
                amount=25000.0,
                reason="Unusually large international transaction",
                severity="high",
                recommendation="Please verify this transaction if you don't recognize it.",
            ),
        ]
        
        savings_opportunities = [
            SavingsOpportunity(
                category="food_dining",
                potential_savings=3000.0,
                description="Cooking at home 2 more days/week could save ₹3,000/month",
                difficulty="easy",
                impact="Save ₹36,000/year",
            ),
            SavingsOpportunity(
                category="entertainment",
                potential_savings=1500.0,
                description="Consider annual subscriptions instead of monthly (20% cheaper)",
                difficulty="easy",
                impact="Save ₹18,000/year",
            ),
            SavingsOpportunity(
                category="shopping",
                potential_savings=2000.0,
                description="Wait 48 hours before non-essential purchases to avoid impulse buying",
                difficulty="medium",
                impact="Save ₹24,000/year",
            ),
        ]
        
        # Calculate health score (0-100)
        health_score = self._calculate_health_score(spending_patterns, anomalies)
        
        summary = self._generate_summary(
            spending_patterns,
            anomalies,
            savings_opportunities,
            health_score,
        )
        
        return InsightsResponse(
            spending_patterns=spending_patterns,
            anomalies=anomalies,
            savings_opportunities=savings_opportunities,
            summary=summary,
            health_score=health_score,
        )
    
    def _calculate_health_score(
        self,
        patterns: list,
        anomalies: list,
    ) -> int:
        """Calculate financial health score."""
        score = 70  # Base score
        
        # Adjust based on spending trends
        for pattern in patterns:
            if pattern.trend == "decreasing":
                score += 5
            elif pattern.trend == "increasing":
                score -= 3
        
        # Penalize for anomalies
        score -= len(anomalies) * 5
        
        return max(0, min(100, score))
    
    def _generate_summary(
        self,
        patterns: list,
        anomalies: list,
        opportunities: list,
        health_score: int,
    ) -> str:
        """Generate a natural language summary."""
        parts = []
        
        if health_score >= 80:
            parts.append("Your finances are in excellent shape!")
        elif health_score >= 60:
            parts.append("Your finances are generally healthy with room for improvement.")
        else:
            parts.append("There are some areas of concern in your spending.")
        
        # Highlight positive trend
        decreasing = [p for p in patterns if p.trend == "decreasing"]
        if decreasing:
            parts.append(f"Great progress on reducing {decreasing[0].category} expenses.")
        
        # Mention savings potential
        total_savings = sum(o.potential_savings for o in opportunities)
        if total_savings > 0:
            parts.append(f"We've identified ₹{total_savings:,.0f} in potential monthly savings.")
        
        # Alert about anomalies
        if anomalies:
            parts.append(f"Please review {len(anomalies)} flagged transaction(s).")
        
        return " ".join(parts)
