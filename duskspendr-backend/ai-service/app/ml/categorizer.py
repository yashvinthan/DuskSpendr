"""Transaction categorizer ML model."""
import re
from typing import Any

from app.core.config import settings
from app.core.logging import get_logger
from app.schemas.transaction import TransactionInput, CategoryPrediction

logger = get_logger(__name__)

# Category mapping with keywords
CATEGORY_KEYWORDS = {
    "food_dining": {
        "name": "Food & Dining",
        "keywords": ["swiggy", "zomato", "restaurant", "cafe", "food", "dining", "pizza", 
                     "burger", "biryani", "hotel", "kitchen", "dhaba", "bakery"],
        "subcategories": {"delivery": ["swiggy", "zomato", "uber eats"], 
                          "restaurant": ["restaurant", "cafe", "hotel"]}
    },
    "groceries": {
        "name": "Groceries",
        "keywords": ["bigbasket", "blinkit", "zepto", "instamart", "grocery", "supermarket",
                     "dmart", "reliance", "more", "nature's basket", "vegetables", "fruits"],
        "subcategories": {}
    },
    "transportation": {
        "name": "Transportation",
        "keywords": ["uber", "ola", "rapido", "taxi", "cab", "auto", "metro", "bus",
                     "petrol", "diesel", "fuel", "parking", "toll", "irctc", "railway"],
        "subcategories": {"ride": ["uber", "ola", "rapido"], "fuel": ["petrol", "diesel", "fuel"]}
    },
    "utilities": {
        "name": "Utilities",
        "keywords": ["electricity", "water", "gas", "internet", "wifi", "broadband",
                     "mobile", "recharge", "postpaid", "prepaid", "jio", "airtel", "vi"],
        "subcategories": {}
    },
    "shopping": {
        "name": "Shopping",
        "keywords": ["amazon", "flipkart", "myntra", "ajio", "nykaa", "meesho",
                     "mall", "clothes", "fashion", "electronics", "appliances"],
        "subcategories": {}
    },
    "entertainment": {
        "name": "Entertainment",
        "keywords": ["netflix", "prime", "hotstar", "spotify", "youtube", "movie",
                     "cinema", "pvr", "inox", "gaming", "playstation", "xbox"],
        "subcategories": {}
    },
    "health": {
        "name": "Health & Fitness",
        "keywords": ["pharmacy", "medical", "doctor", "hospital", "clinic", "gym",
                     "fitness", "yoga", "medicine", "apollo", "practo", "pharmeasy"],
        "subcategories": {}
    },
    "education": {
        "name": "Education",
        "keywords": ["school", "college", "university", "course", "udemy", "coursera",
                     "books", "tuition", "coaching", "education", "learning"],
        "subcategories": {}
    },
    "finance": {
        "name": "Finance & Fees",
        "keywords": ["bank", "atm", "fee", "charge", "interest", "emi", "loan",
                     "insurance", "premium", "investment", "mutual fund"],
        "subcategories": {}
    },
    "transfer": {
        "name": "Transfers",
        "keywords": ["transfer", "neft", "imps", "upi", "sent to", "received from"],
        "subcategories": {}
    },
}


class TransactionCategorizer:
    """ML-based transaction categorizer."""
    
    def __init__(self):
        self.model_loaded = False
        self._categories = CATEGORY_KEYWORDS
    
    async def load_model(self) -> None:
        """Load the ML model."""
        # In production, this would load a trained model
        # For now, using keyword matching as fallback
        logger.info("categorizer_model_loaded", model_path=settings.CATEGORIZER_MODEL_PATH)
        self.model_loaded = True
    
    async def predict(self, transaction: TransactionInput) -> CategoryPrediction:
        """Predict category for a transaction."""
        text = f"{transaction.merchant_name} {transaction.description or ''}".lower()
        
        # Score each category
        scores: dict[str, float] = {}
        for category_id, category_data in self._categories.items():
            score = 0.0
            for keyword in category_data["keywords"]:
                if keyword in text:
                    # Weight by keyword position (earlier = higher weight)
                    pos = text.find(keyword)
                    weight = 1.0 - (pos / max(len(text), 1)) * 0.3
                    score += weight
            scores[category_id] = score
        
        # Get best match
        if not any(scores.values()):
            # No keywords matched, return "other" with low confidence
            return CategoryPrediction(
                category="other",
                category_name="Other",
                confidence=0.3,
                subcategory=None,
                alternative_categories=[],
            )
        
        # Sort by score
        sorted_categories = sorted(scores.items(), key=lambda x: x[1], reverse=True)
        best_category = sorted_categories[0][0]
        best_score = sorted_categories[0][1]
        
        # Normalize confidence
        total_score = sum(s for _, s in sorted_categories if s > 0)
        confidence = min(best_score / max(total_score, 0.1), 1.0) * 0.95  # Cap at 0.95
        
        # Check for subcategory
        subcategory = self._get_subcategory(best_category, text)
        
        # Get alternatives
        alternatives = [
            {"category": cat, "confidence": round(score / max(total_score, 0.1), 3)}
            for cat, score in sorted_categories[1:4]
            if score > 0
        ]
        
        return CategoryPrediction(
            category=best_category,
            category_name=self._categories[best_category]["name"],
            confidence=round(confidence, 3),
            subcategory=subcategory,
            alternative_categories=alternatives,
        )
    
    def _get_subcategory(self, category: str, text: str) -> str | None:
        """Determine subcategory if available."""
        subcategories = self._categories.get(category, {}).get("subcategories", {})
        for subcat, keywords in subcategories.items():
            if any(kw in text for kw in keywords):
                return subcat
        return None


# Singleton instance
_categorizer: TransactionCategorizer | None = None


async def get_categorizer() -> TransactionCategorizer:
    """Get or create categorizer instance."""
    global _categorizer
    if _categorizer is None:
        _categorizer = TransactionCategorizer()
        await _categorizer.load_model()
    return _categorizer
