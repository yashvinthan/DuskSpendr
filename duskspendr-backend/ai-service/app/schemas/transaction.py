"""Transaction schemas for the AI service."""
from typing import Any

from pydantic import BaseModel, Field


class TransactionInput(BaseModel):
    """Input for transaction categorization."""
    
    transaction_id: str | None = Field(None, description="Optional transaction ID for tracking")
    merchant_name: str = Field(..., description="Name of the merchant")
    description: str | None = Field(None, description="Transaction description or memo")
    amount: float = Field(..., description="Transaction amount (positive for expenses)")
    currency: str = Field("INR", description="Currency code")
    
    class Config:
        json_schema_extra = {
            "example": {
                "transaction_id": "tx_123abc",
                "merchant_name": "Swiggy",
                "description": "Food delivery order",
                "amount": 450.00,
                "currency": "INR",
            }
        }


class CategoryPrediction(BaseModel):
    """Category prediction result."""
    
    category: str = Field(..., description="Predicted category ID")
    category_name: str = Field(..., description="Human-readable category name")
    confidence: float = Field(..., ge=0, le=1, description="Prediction confidence (0-1)")
    subcategory: str | None = Field(None, description="Optional subcategory")
    alternative_categories: list[dict[str, Any]] = Field(
        default_factory=list,
        description="Alternative category predictions with scores"
    )
    
    class Config:
        json_schema_extra = {
            "example": {
                "category": "food_dining",
                "category_name": "Food & Dining",
                "confidence": 0.94,
                "subcategory": "delivery",
                "alternative_categories": [
                    {"category": "groceries", "confidence": 0.03},
                    {"category": "shopping", "confidence": 0.02},
                ],
            }
        }


class BatchCategorizationRequest(BaseModel):
    """Request for batch categorization."""
    
    transactions: list[TransactionInput] = Field(
        ..., 
        min_length=1,
        max_length=100,
        description="List of transactions to categorize (max 100)"
    )


class BatchCategorizationResult(BaseModel):
    """Result for a single transaction in batch."""
    
    transaction_id: str | None
    prediction: CategoryPrediction | None
    success: bool
    error: str | None = None


class BatchCategorizationResponse(BaseModel):
    """Response for batch categorization."""
    
    results: list[dict[str, Any]]
    total: int
    successful: int
