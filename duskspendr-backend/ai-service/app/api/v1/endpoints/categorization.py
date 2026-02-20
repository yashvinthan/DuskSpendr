"""Transaction categorization endpoints."""
import asyncio
from typing import Any

from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, Field

from app.core.logging import get_logger
from app.ml.categorizer import TransactionCategorizer, get_categorizer
from app.schemas.transaction import (
    TransactionInput,
    CategoryPrediction,
    BatchCategorizationRequest,
    BatchCategorizationResponse,
)

router = APIRouter()
logger = get_logger(__name__)


@router.post("", response_model=CategoryPrediction)
async def categorize_transaction(
    transaction: TransactionInput,
    categorizer: TransactionCategorizer = Depends(get_categorizer),
) -> CategoryPrediction:
    """
    Categorize a single transaction using AI.
    
    The model analyzes merchant name, description, and amount to predict
    the most likely category with confidence score.
    """
    try:
        result = await categorizer.predict(transaction)
        logger.info(
            "transaction_categorized",
            merchant=transaction.merchant_name,
            category=result.category,
            confidence=result.confidence,
        )
        return result
    except Exception as e:
        logger.error("categorization_failed", error=str(e))
        raise HTTPException(status_code=500, detail="Categorization failed")


@router.post("/batch", response_model=BatchCategorizationResponse)
async def categorize_batch(
    request: BatchCategorizationRequest,
    categorizer: TransactionCategorizer = Depends(get_categorizer),
) -> BatchCategorizationResponse:
    """
    Categorize multiple transactions in a single request.
    
    Efficiently processes batches of transactions, useful for
    initial sync or bulk imports.
    """
    async def process_transaction(tx):
        try:
            prediction = await categorizer.predict(tx)
            return {
                "transaction_id": tx.transaction_id,
                "prediction": prediction,
                "success": True,
            }
        except Exception as e:
            return {
                "transaction_id": tx.transaction_id,
                "prediction": None,
                "success": False,
                "error": str(e),
            }

    results = await asyncio.gather(*(process_transaction(tx) for tx in request.transactions))
    
    logger.info(
        "batch_categorization_complete",
        total=len(request.transactions),
        successful=sum(1 for r in results if r["success"]),
    )
    
    return BatchCategorizationResponse(
        results=results,
        total=len(results),
        successful=sum(1 for r in results if r["success"]),
    )


@router.get("/categories")
async def list_categories() -> dict[str, Any]:
    """List all available transaction categories."""
    categories = [
        {"id": "food_dining", "name": "Food & Dining", "icon": "restaurant"},
        {"id": "groceries", "name": "Groceries", "icon": "shopping_cart"},
        {"id": "transportation", "name": "Transportation", "icon": "directions_car"},
        {"id": "utilities", "name": "Utilities", "icon": "power"},
        {"id": "shopping", "name": "Shopping", "icon": "shopping_bag"},
        {"id": "entertainment", "name": "Entertainment", "icon": "movie"},
        {"id": "health", "name": "Health & Fitness", "icon": "fitness_center"},
        {"id": "travel", "name": "Travel", "icon": "flight"},
        {"id": "education", "name": "Education", "icon": "school"},
        {"id": "personal_care", "name": "Personal Care", "icon": "spa"},
        {"id": "home", "name": "Home & Garden", "icon": "home"},
        {"id": "finance", "name": "Finance & Fees", "icon": "account_balance"},
        {"id": "income", "name": "Income", "icon": "attach_money"},
        {"id": "transfer", "name": "Transfers", "icon": "swap_horiz"},
        {"id": "other", "name": "Other", "icon": "more_horiz"},
    ]
    return {"categories": categories}


@router.post("/feedback")
async def submit_categorization_feedback(
    transaction_id: str,
    predicted_category: str,
    correct_category: str,
    user_id: str,
) -> dict[str, Any]:
    """
    Submit feedback for incorrect categorization.
    
    This helps improve the model over time through supervised learning.
    """
    logger.info(
        "categorization_feedback",
        transaction_id=transaction_id,
        predicted=predicted_category,
        correct=correct_category,
        user_id=user_id,
    )
    
    # Store feedback for model retraining
    # In production, this would be queued for batch processing
    
    return {
        "success": True,
        "message": "Feedback recorded. Thank you for helping improve our AI!",
    }
