import pytest
import sys
import os
import asyncio

# Ensure the correct path is added so we can import 'app'
# Assuming this script is in duskspendr-backend/ai-service/tests/
current_dir = os.path.dirname(os.path.abspath(__file__))
service_root = os.path.dirname(current_dir)
sys.path.insert(0, service_root)

from app.ml.categorizer import TransactionCategorizer
from app.schemas.transaction import TransactionInput

@pytest.fixture
def categorizer():
    cat = TransactionCategorizer()
    # Mock load_model if needed, but here it's simple
    asyncio.run(cat.load_model())
    return cat

@pytest.mark.asyncio
async def test_categorizer_basic(categorizer):
    tx = TransactionInput(merchant_name="Swiggy", amount=100.0, currency="INR")
    pred = await categorizer.predict(tx)
    assert pred.category == "food_dining"
    assert pred.confidence > 0.8

@pytest.mark.asyncio
async def test_categorizer_overlap_suffix(categorizer):
    # 'ajio' matches 'shopping'. 'jio' matches 'utilities'.
    # Both should be found.
    tx = TransactionInput(merchant_name="ajio", amount=100.0, currency="INR")
    pred = await categorizer.predict(tx)

    # Shopping should win because 'ajio' is longer/more specific?
    # Or just because score accumulation.
    # ajio: 1.0 (shopping)
    # jio: ~0.9 (utilities)
    # Shopping wins.
    assert pred.category == "shopping"

    # Check alternatives contain utilities
    alts = [a['category'] for a in pred.alternative_categories]
    assert "utilities" in alts

@pytest.mark.asyncio
async def test_categorizer_overlap_prefix(categorizer):
    # 'coursera' matches 'education'. 'course' matches 'education'.
    # Ideally both found in original logic.
    # If optimization misses 'course', score might drop slightly but category should remain 'education'.
    tx = TransactionInput(merchant_name="coursera", amount=100.0, currency="INR")
    pred = await categorizer.predict(tx)
    assert pred.category == "education"
    assert pred.confidence > 0.8

@pytest.mark.asyncio
async def test_categorizer_overlap_substring(categorizer):
    # 'movie' matches 'entertainment'. 'vi' matches 'utilities'.
    tx = TransactionInput(merchant_name="movie", amount=100.0, currency="INR")
    pred = await categorizer.predict(tx)
    assert pred.category == "entertainment"

    alts = [a['category'] for a in pred.alternative_categories]
    assert "utilities" in alts

@pytest.mark.asyncio
async def test_categorizer_multiple_keywords(categorizer):
    # "swiggy zomato" -> both in food_dining.
    # Should get higher score than single keyword?
    tx1 = TransactionInput(merchant_name="swiggy", amount=100.0, currency="INR")
    pred1 = await categorizer.predict(tx1)

    tx2 = TransactionInput(merchant_name="swiggy zomato", amount=100.0, currency="INR")
    pred2 = await categorizer.predict(tx2)

    # Since confidence is capped at 0.95, we might not see difference in confidence.
    # But internal score should be higher.
    # We can check if category is correct.
    assert pred2.category == "food_dining"

@pytest.mark.asyncio
async def test_categorizer_no_match(categorizer):
    tx = TransactionInput(merchant_name="randomstore123", amount=100.0, currency="INR")
    pred = await categorizer.predict(tx)
    assert pred.category == "other"
    assert pred.confidence <= 0.3
