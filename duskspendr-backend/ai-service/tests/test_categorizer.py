import pytest
from app.ml.categorizer import TransactionCategorizer
from app.schemas.transaction import TransactionInput

@pytest.mark.asyncio
async def test_predict_exact_match():
    categorizer = TransactionCategorizer()
    await categorizer.load_model()

    transaction = TransactionInput(
        merchant_name="Swiggy",
        amount=500.0,
        currency="INR"
    )
    prediction = await categorizer.predict(transaction)

    assert prediction.category == "food_dining"
    assert prediction.subcategory == "delivery"
    assert prediction.confidence > 0.8

@pytest.mark.asyncio
async def test_predict_partial_match():
    categorizer = TransactionCategorizer()
    await categorizer.load_model()

    transaction = TransactionInput(
        merchant_name="Starbucks Cafe",
        amount=350.0,
        currency="INR"
    )
    prediction = await categorizer.predict(transaction)

    assert prediction.category == "food_dining"
    assert prediction.subcategory == "restaurant"

@pytest.mark.asyncio
async def test_predict_no_match():
    categorizer = TransactionCategorizer()
    await categorizer.load_model()

    transaction = TransactionInput(
        merchant_name="Unknown Merchant",
        description="Random payment",
        amount=100.0,
        currency="INR"
    )
    prediction = await categorizer.predict(transaction)

    assert prediction.category == "other"
    assert prediction.confidence <= 0.3

@pytest.mark.asyncio
async def test_predict_case_insensitive():
    categorizer = TransactionCategorizer()
    await categorizer.load_model()

    transaction = TransactionInput(
        merchant_name="SWIGGY",
        amount=500.0,
        currency="INR"
    )
    prediction = await categorizer.predict(transaction)

    assert prediction.category == "food_dining"

@pytest.mark.asyncio
async def test_predict_empty_description():
    categorizer = TransactionCategorizer()
    await categorizer.load_model()

    transaction = TransactionInput(
        merchant_name="Uber",
        description=None,
        amount=250.0,
        currency="INR"
    )
    prediction = await categorizer.predict(transaction)

    assert prediction.category == "transportation"
    assert prediction.subcategory == "ride"

@pytest.mark.asyncio
async def test_predict_multiple_keywords():
    categorizer = TransactionCategorizer()
    await categorizer.load_model()

    # "amazon" matches shopping, "food" matches food_dining
    # "amazon" is first, so it should have higher weight
    transaction = TransactionInput(
        merchant_name="Amazon",
        description="Food order payment",
        amount=1000.0,
        currency="INR"
    )
    prediction = await categorizer.predict(transaction)

    # Depending on implementation, "amazon" (shopping) might win due to position weight
    # Or "food" might win if it appears multiple times or has higher base weight?
    # Let's check logic: weight = 1.0 - (pos / len) * 0.3
    # "amazon" is at 0. weight ~ 1.0.
    # "food" is later. weight < 1.0.
    # So shopping should win.
    assert prediction.category == "shopping"

    # Verify alternatives contain food_dining
    alternatives = [alt['category'] for alt in prediction.alternative_categories]
    assert "food_dining" in alternatives

from app.ml.categorizer import get_categorizer

@pytest.mark.asyncio
async def test_get_categorizer():
    cat1 = await get_categorizer()
    cat2 = await get_categorizer()
    assert cat1 is cat2
    assert cat1.model_loaded is True

@pytest.mark.asyncio
async def test_predict_empty_text():
    categorizer = TransactionCategorizer()
    await categorizer.load_model()

    transaction = TransactionInput(
        merchant_name="",
        amount=100.0,
        currency="INR"
    )
    prediction = await categorizer.predict(transaction)
    assert prediction.category == "other"
