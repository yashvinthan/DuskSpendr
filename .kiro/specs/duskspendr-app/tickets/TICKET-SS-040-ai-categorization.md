# SS-040: AI Transaction Categorization

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-040 |
| **Epic** | Transaction Management |
| **Type** | Feature |
| **Priority** | P0 - Critical |
| **Story Points** | 13 |
| **Sprint** | Sprint 4 |
| **Assignee** | TBD |
| **Labels** | `ai`, `ml`, `categorization`, `python`, `fastapi`, `postgresql` |

---

## User Story

**As a** DuskSpendr user  
**I want** my transactions automatically categorized by AI  
**So that** I see meaningful spending breakdowns without manual tagging

---

## Description

Build an AI-powered transaction categorization service using Python/FastAPI that analyzes merchant names and transaction descriptions to assign spending categories. The service uses a fine-tuned ML model with Redis caching for performance and learns from user corrections to improve accuracy over time.

---

## Acceptance Criteria

### AC1: Auto-Categorization
```gherkin
Given a new transaction is created
When it has no category assigned
Then the AI service should:
  - Analyze merchant name and description
  - Assign a category with confidence score
  - Auto-apply if confidence > 80%
  - Flag for user review if confidence 50-80%
  - Leave uncategorized if confidence < 50%
And response time should be < 100ms (cached) / < 500ms (uncached)
```

### AC2: Category Accuracy
```gherkin
Given 1000 test transactions from Indian merchants
When AI categorization runs
Then accuracy should be >90% for top categories:
  | Category | Example Merchants |
  | Food & Dining | Swiggy, Zomato, Dominos, McDonalds, local restaurants |
  | Transport | Uber, Ola, Metro, Rapido, fuel stations |
  | Shopping | Amazon, Flipkart, Myntra, BigBasket, DMart |
  | Entertainment | Netflix, Spotify, BookMyShow, PVR |
  | Utilities | Electricity, Gas, Jio, Airtel, Broadband |
  | Education | Coursera, Udemy, college fees |
  | Healthcare | Apollo, Practo, pharmacy |
  | Groceries | BigBasket, Blinkit, Zepto, kirana |
```

### AC3: User Learning
```gherkin
Given user corrects a category from "Shopping" to "Groceries"
When they save the change
Then the system should:
  - Store merchant → category mapping for this user
  - Apply same category to future transactions from this merchant
  - Contribute (anonymously) to model improvement
And user preference takes priority over AI suggestion
```

### AC4: Batch Categorization
```gherkin
Given 100 uncategorized transactions (initial sync)
When batch categorization runs
Then complete within 5 seconds
And return all results in single response
```

---

## Technical Implementation

### Python/FastAPI Service

```python
# app/main.py
from fastapi import FastAPI, Depends
from pydantic import BaseModel
from transformers import pipeline
import redis
from sqlalchemy.orm import Session

app = FastAPI(title="DuskSpendr AI Categorization", version="1.0.0")

# Load fine-tuned model on startup
classifier = None

@app.on_event("startup")
async def load_model():
    global classifier
    classifier = pipeline(
        "text-classification",
        model="./models/transaction_classifier_india",
        device=0  # GPU if available
    )

redis_client = redis.Redis(host='redis', port=6379, decode_responses=True)

# Category mapping
CATEGORIES = {
    "food_dining": {"id": 1, "name": "Food & Dining", "icon": "restaurant"},
    "transport": {"id": 2, "name": "Transport", "icon": "directions_car"},
    "shopping": {"id": 3, "name": "Shopping", "icon": "shopping_bag"},
    "entertainment": {"id": 4, "name": "Entertainment", "icon": "movie"},
    "utilities": {"id": 5, "name": "Utilities", "icon": "bolt"},
    "groceries": {"id": 6, "name": "Groceries", "icon": "local_grocery_store"},
    "healthcare": {"id": 7, "name": "Healthcare", "icon": "medical_services"},
    "education": {"id": 8, "name": "Education", "icon": "school"},
    "transfers": {"id": 9, "name": "Transfers", "icon": "swap_horiz"},
    "other": {"id": 10, "name": "Other", "icon": "category"},
}

class TransactionInput(BaseModel):
    merchant_name: str
    description: str | None = None
    amount: float
    user_id: str | None = None

class CategoryResult(BaseModel):
    category_id: int
    category_name: str
    icon: str
    confidence: float
    needs_review: bool

@app.post("/api/v1/ai/categorize", response_model=CategoryResult)
async def categorize(txn: TransactionInput, db: Session = Depends(get_db)):
    # 1. Check user-specific override first
    if txn.user_id:
        user_override = get_user_mapping(db, txn.user_id, txn.merchant_name)
        if user_override:
            cat = CATEGORIES[user_override.category_key]
            return CategoryResult(
                category_id=cat["id"],
                category_name=cat["name"],
                icon=cat["icon"],
                confidence=1.0,
                needs_review=False,
            )
    
    # 2. Check Redis cache
    cache_key = f"cat:{txn.merchant_name.lower().strip()}"
    cached = redis_client.get(cache_key)
    if cached:
        return CategoryResult.parse_raw(cached)
    
    # 3. Run ML model
    text = f"{txn.merchant_name} {txn.description or ''}"
    result = classifier(text, top_k=1)[0]
    
    cat_key = result["label"]
    cat = CATEGORIES.get(cat_key, CATEGORIES["other"])
    confidence = result["score"]
    
    response = CategoryResult(
        category_id=cat["id"],
        category_name=cat["name"],
        icon=cat["icon"],
        confidence=round(confidence, 3),
        needs_review=0.5 <= confidence < 0.8,
    )
    
    # 4. Cache for 24 hours
    redis_client.setex(cache_key, 86400, response.json())
    
    return response

@app.post("/api/v1/ai/categorize/batch")
async def categorize_batch(transactions: list[TransactionInput]):
    results = []
    for txn in transactions:
        result = await categorize(txn)
        results.append(result)
    return {"results": results}

@app.post("/api/v1/ai/learn")
async def learn_correction(
    user_id: str,
    merchant_name: str,
    category_id: int,
    db: Session = Depends(get_db)
):
    """Store user's category correction for future use"""
    save_user_mapping(db, user_id, merchant_name, category_id)
    # Invalidate cache for this merchant (user-specific)
    return {"status": "learned"}
```

### PostgreSQL Schema

```sql
-- Categories table (seeded data)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    key VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    icon_name VARCHAR(50) NOT NULL,
    color INTEGER NOT NULL,
    parent_id INTEGER REFERENCES categories(id),
    is_system BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Seed default categories
INSERT INTO categories (key, name, icon_name, color, is_system, display_order) VALUES
('food_dining', 'Food & Dining', 'restaurant', x'FFFF6B6B'::int, true, 1),
('transport', 'Transport', 'directions_car', x'FF4ECDC4'::int, true, 2),
('shopping', 'Shopping', 'shopping_bag', x'FF45B7D1'::int, true, 3),
('entertainment', 'Entertainment', 'movie', x'FF96CEB4'::int, true, 4),
('utilities', 'Utilities', 'bolt', x'FFFFCC5C'::int, true, 5),
('groceries', 'Groceries', 'local_grocery_store', x'FF88D8B0'::int, true, 6),
('healthcare', 'Healthcare', 'medical_services', x'FFFF6F61'::int, true, 7),
('education', 'Education', 'school', x'FF6B5B95'::int, true, 8),
('transfers', 'Transfers', 'swap_horiz', x'FF808080'::int, true, 9),
('other', 'Other', 'category', x'FF999999'::int, true, 10);

-- User category overrides (for personalized learning)
CREATE TABLE user_category_mappings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    merchant_pattern VARCHAR(255) NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, merchant_pattern)
);

-- Index for fast user-specific lookups
CREATE INDEX idx_user_category_mappings_lookup 
ON user_category_mappings(user_id, merchant_pattern);

-- Global merchant → category mappings (from aggregated learning)
CREATE TABLE global_merchant_categories (
    id SERIAL PRIMARY KEY,
    merchant_name VARCHAR(255) UNIQUE NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(id),
    confidence DECIMAL(4,3) NOT NULL,
    sample_count INTEGER DEFAULT 1,
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_global_merchant ON global_merchant_categories(merchant_name);
```

---

## Definition of Done

- [ ] FastAPI categorization endpoint deployed
- [ ] ML model trained with >90% accuracy on Indian merchants
- [ ] Redis caching for <100ms response time
- [ ] User correction learning endpoint
- [ ] PostgreSQL schema + seed data
- [ ] Batch categorization endpoint
- [ ] Unit tests (pytest)
- [ ] Load testing: 1000 req/s sustained
- [ ] Docker containerized
- [ ] API documentation (OpenAPI)
- [ ] Code reviewed

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-200 | Blocks | API Gateway for routing |
| SS-201 | Blocks | Auth service for user_id |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-050 | Budget tracking (uses category data) |
| SS-060 | Dashboard charts (spending by category) |
| SS-080 | Financial insights |

---

## Security Considerations

1. **No PII in ML**: Model trained on merchant names only, no user data
2. **User Isolation**: User overrides are per-user, never shared
3. **Rate Limiting**: Prevent abuse of categorization endpoint
4. **Input Validation**: Sanitize merchant names before processing

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| FastAPI service setup | 2 |
| ML model training/fine-tuning | 8 |
| Redis caching integration | 2 |
| User learning endpoint | 3 |
| PostgreSQL schema | 2 |
| Batch endpoint | 2 |
| Unit tests | 3 |
| Load testing | 2 |
| Documentation | 1 |
| **Total** | **25 hours** |

---

*Created: 2026-02-04 | Last Updated: 2026-02-05*
