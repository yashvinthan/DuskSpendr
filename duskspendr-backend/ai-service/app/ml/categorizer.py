"""Transaction categorizer ML model."""
import asyncio
import re  # noqa: F401
from typing import Any  # noqa: F401

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
        self._init_regex()

    def _init_regex(self) -> None:
        """Initialize regex for keywords."""
        self._keyword_map: dict[str, list[str]] = {}
        self._prefix_map: dict[str, list[str]] = {}
        all_keywords = set()

        for category_id, category_data in self._categories.items():
            for keyword in category_data["keywords"]:
                all_keywords.add(keyword)
                if keyword not in self._keyword_map:
                    self._keyword_map[keyword] = []
                self._keyword_map[keyword].append(category_id)

        # Pre-compute prefixes. Since the regex matches the longest possible keyword at a position,
        # we need to manually account for any prefixes that are also valid keywords.
        # e.g., if "coursera" matches, we also want to credit "course".
        for kw1 in all_keywords:
            self._prefix_map[kw1] = []
            for kw2 in all_keywords:
                if kw1 != kw2 and kw1.startswith(kw2):
                    self._prefix_map[kw1].append(kw2)

        # Sort by length descending to ensure longest match consumes the text in Trie construction order
        sorted_keywords = sorted(all_keywords, key=len, reverse=True)

        if sorted_keywords:
            trie_pattern = self._build_regex_pattern(sorted_keywords)
            # Use lookahead to find all overlapping matches without consuming characters
            # Group 1 captures the matched keyword
            self._regex = re.compile(f"(?=({trie_pattern}))")
        else:
            self._regex = None

    def _build_regex_pattern(self, keywords: list[str]) -> str:
        """Build an optimized regex pattern using a Trie structure."""
        if not keywords:
            return ""

        trie: dict[str, Any] = {}
        for word in keywords:
            curr = trie
            for char in word:
                if char not in curr:
                    curr[char] = {}
                curr = curr[char]
            curr['__end__'] = True

        def _regex_from_trie(node: dict) -> str:
            if not node:
                return ""

            is_end = '__end__' in node
            # Sort keys to ensure deterministic output
            next_chars = sorted([k for k in node.keys() if k != '__end__'])

            if not next_chars:
                return ""

            alternatives = []
            for char in next_chars:
                sub_regex = _regex_from_trie(node[char])
                if sub_regex:
                    alternatives.append(re.escape(char) + sub_regex)
                else:
                    alternatives.append(re.escape(char))

            if len(alternatives) == 1:
                res = alternatives[0]
            else:
                res = "(?:" + "|".join(alternatives) + ")"

            if is_end:
                 res = f"(?:{res})?"

            return res

        return _regex_from_trie(trie)

    async def load_model(self) -> None:
        """Load the ML model."""
        # In production, this would load a trained model
        # For now, using keyword matching as fallback
        logger.info("categorizer_model_loaded", model_path=settings.CATEGORIZER_MODEL_PATH)
        self.model_loaded = True
    
    async def predict(self, transaction: TransactionInput) -> CategoryPrediction:
        """Predict category for a transaction."""
        loop = asyncio.get_running_loop()
        return await loop.run_in_executor(None, self._predict_sync, transaction)

    def _predict_sync(self, transaction: TransactionInput) -> CategoryPrediction:
        """Synchronous prediction logic to be run in executor."""
        text = f"{transaction.merchant_name} {transaction.description or ''}".lower()
        text_len = max(len(text), 1)
        
        # Score each category
        scores: dict[str, float] = {cat: 0.0 for cat in self._categories}

        if self._regex:
            # Use regex to find all matches
            matches = self._regex.finditer(text)

            # Track processed keywords per category to avoid double counting same keyword
            processed_keywords: dict[str, set[str]] = {cat: set() for cat in self._categories}

            for match in matches:
                # With lookahead, group(1) contains the actual match. Group 0 is empty.
                keyword = match.group(1)
                start_pos = match.start()

                # Process the main matched keyword
                keywords_to_process = [keyword]

                # Also process any valid prefixes starting at the same position
                # e.g., "coursera" found -> also credit "course"
                if keyword in self._prefix_map:
                    keywords_to_process.extend(self._prefix_map[keyword])

                for kw in keywords_to_process:
                    # Calculate weight (all share same start_pos)
                    weight = 1.0 - (start_pos / text_len) * 0.3

                    # Update scores for all categories containing this keyword
                    for category_id in self._keyword_map.get(kw, []):
                        if kw not in processed_keywords[category_id]:
                            scores[category_id] += weight
                            processed_keywords[category_id].add(kw)
        
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
