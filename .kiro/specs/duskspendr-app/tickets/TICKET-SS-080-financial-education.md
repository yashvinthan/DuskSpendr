# SS-080: Financial Education & AI Insights

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-080 |
| **Epic** | AI & Insights |
| **Type** | Feature |
| **Priority** | P1 - High |
| **Story Points** | 13 |
| **Sprint** | Sprint 7-8 |
| **Assignee** | TBD |
| **Labels** | `ai`, `insights`, `education`, `gamification`, `python`, `fastapi`, `postgresql` |

---

## User Story

**As a** student new to managing finances  
**I want** personalized tips and a financial health score  
**So that** I learn good money habits while using the app

---

## Description

Build an AI-powered financial education and insights engine that analyzes user spending patterns to provide personalized recommendations, a dynamic financial health score, and engaging educational content. The feature promotes financial literacy while making learning feel rewarding through gamification elements.

---

## Acceptance Criteria

### AC1: Financial Health Score
```gherkin
Given I have at least 2 weeks of transaction history
When I view my financial health score
Then I see:
  | Component | Weight | Score Range |
  | Savings Rate | 30% | 0-100 |
  | Budget Adherence | 25% | 0-100 |
  | Spending Consistency | 20% | 0-100 |
  | Category Balance | 15% | 0-100 |
  | Bill Timeliness | 10% | 0-100 |
And overall score displayed as 0-100 with grade (A+ to F)
And trend arrow showing change from last week
And breakdown accessible on tap
```

### AC2: Health Score Visualization
```gherkin
Given my health score is calculated
Then display:
  - Animated ring/gauge with score
  - Grade letter (A+, A, B+, B, C+, C, D, F)
  - Color coding:
    | Range | Color | Grade |
    | 90-100 | Gold | A+ |
    | 80-89 | Green | A/B+ |
    | 70-79 | Lime | B/B+ |
    | 60-69 | Yellow | C+ |
    | 50-59 | Orange | C |
    | Below 50 | Red | D/F |
  - Motivational message based on score
```

### AC3: Personalized Tips
```gherkin
Given my spending patterns are analyzed
When AI generates tips
Then tips should:
  - Be specific to MY data (not generic)
  - Include actionable advice
  - Show potential savings amount
  - Have dismissible/snooze option
  - Max 3 active tips at a time

Examples:
| Pattern | Tip |
| High food delivery spending | "You spent ₹4,500 on food delivery this month (40% of food budget). Cooking at home 3x/week could save ₹1,500" |
| Frequent small purchases | "12 purchases under ₹100 this week (₹800 total). Consider a weekly snack budget to reduce impulse buys" |
| Improved savings | "Great job! Your savings rate improved from 10% to 15%. Keep it up! 🎉" |
```

### AC4: Spending Predictions
```gherkin
Given I have 30+ days of history
When viewing dashboard or insights
Then show predictions:
  - "At current pace, you'll spend ₹15,000 by month-end"
  - "You might exceed your Budget by ₹2,000"
  - "If you save ₹200/week, you'll have ₹12,000 by semester end"
And predictions update weekly
```

### AC5: Educational Content
```gherkin
Given I'm a student learning finance
Then provide educational modules:
  | Topic | Format |
  | Budgeting Basics | Interactive cards |
  | Emergency Funds | Short articles + quiz |
  | Credit Score 101 | Video links + summary |
  | Student Discounts | Curated list |
  | Investment Basics | Beginner guide |
And track module completion
And award XP/badges for completion
```

### AC6: Achievements & Badges
```gherkin
Given gamification is enabled
Then award badges for:
  | Badge | Criteria |
  | First Budget | Create first budget |
  | Week Streak | 7 days of tracking |
  | Under Budget | Finish month under budget |
  | Savings Star | Save 20%+ of income |
  | Learning Machine | Complete 5 modules |
  | Social Spender | Split 10 bills |
And display badges on profile
And notify on unlock
```

---

## Technical Implementation

### Python AI Service

```python
# app/services/insights_service.py
from fastapi import FastAPI, Depends
from pydantic import BaseModel
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
import numpy as np

app = FastAPI(title="DuskSpendr Insights Service")

class HealthScoreInput(BaseModel):
    user_id: str
    start_date: datetime
    end_date: datetime

class HealthScoreResult(BaseModel):
    overall_score: int
    grade: str
    trend: str  # 'up', 'down', 'stable'
    trend_delta: int
    components: list[dict]
    message: str

class InsightTip(BaseModel):
    id: str
    type: str  # 'warning', 'suggestion', 'celebration'
    title: str
    message: str
    potential_savings: float | None
    action_url: str | None
    priority: int

@app.post("/api/v1/insights/health-score", response_model=HealthScoreResult)
async def calculate_health_score(input: HealthScoreInput, db: Session = Depends(get_db)):
    """Calculate comprehensive financial health score for a user"""
    
    # Get user's financial data
    transactions = await get_transactions(db, input.user_id, input.start_date, input.end_date)
    budgets = await get_active_budgets(db, input.user_id)
    
    # Calculate component scores
    components = []
    
    # 1. Savings Rate (30%)
    income = sum(t.amount for t in transactions if t.amount > 0)
    expenses = abs(sum(t.amount for t in transactions if t.amount < 0))
    savings_rate = max(0, (income - expenses) / income) if income > 0 else 0
    savings_score = min(100, int(savings_rate * 500))  # 20% savings = 100
    components.append({
        "name": "Savings Rate",
        "score": savings_score,
        "weight": 30,
        "detail": f"{savings_rate*100:.1f}% saved"
    })
    
    # 2. Budget Adherence (25%)
    budget_adherence = calculate_budget_adherence(transactions, budgets)
    budget_score = int(budget_adherence * 100)
    components.append({
        "name": "Budget Adherence",
        "score": budget_score,
        "weight": 25,
        "detail": f"{budget_adherence*100:.0f}% on track"
    })
    
    # 3. Spending Consistency (20%)
    daily_spending = get_daily_spending(transactions)
    consistency = 1 - min(np.std(daily_spending) / np.mean(daily_spending), 1) if np.mean(daily_spending) > 0 else 0.5
    consistency_score = int(consistency * 100)
    components.append({
        "name": "Spending Consistency",
        "score": consistency_score,
        "weight": 20,
        "detail": "Stable" if consistency > 0.7 else "Variable"
    })
    
    # 4. Category Balance (15%)
    category_balance = calculate_category_balance(transactions)
    balance_score = int(category_balance * 100)
    components.append({
        "name": "Category Balance",
        "score": balance_score,
        "weight": 15,
        "detail": "Well distributed" if category_balance > 0.7 else "Could diversify"
    })
    
    # 5. Bill Timeliness (10%)
    timeliness_score = 80  # Default, would come from bill tracking
    components.append({
        "name": "Bill Timeliness",
        "score": timeliness_score,
        "weight": 10,
        "detail": "On time"
    })
    
    # Calculate weighted overall score
    overall_score = sum(c["score"] * c["weight"] for c in components) // 100
    
    # Determine grade
    grade = get_grade(overall_score)
    
    # Get previous score for trend
    prev_score = await get_previous_score(db, input.user_id)
    trend = "up" if overall_score > prev_score else ("down" if overall_score < prev_score else "stable")
    
    # Generate motivational message
    message = get_motivational_message(overall_score, grade trend)
    
    # Save score for history
    await save_health_score(db, input.user_id, overall_score, components)
    
    return HealthScoreResult(
        overall_score=overall_score,
        grade=grade,
        trend=trend,
        trend_delta=overall_score - prev_score,
        components=components,
        message=message,
    )

@app.post("/api/v1/insights/tips", response_model=list[InsightTip])
async def generate_tips(user_id: str, db: Session = Depends(get_db)):
    """Generate personalized financial tips based on user's spending patterns"""
    
    transactions = await get_recent_transactions(db, user_id, days=30)
    tips = []
    
    # Analyze patterns and generate specific tips
    
    # 1. High category spending
    category_totals = get_category_totals(transactions)
    for category, total in category_totals.items():
        if total > get_category_benchmark(category) * 1.5:
            tips.append(InsightTip(
                id=f"high_{category}_{datetime.now().strftime('%Y%m')}",
                type="warning",
                title=f"High {category} Spending",
                message=f"You've spent ₹{total:,.0f} on {category} this month, "
                        f"50% above typical. Consider reviewing these expenses.",
                potential_savings=total * 0.3,
                action_url=f"/analytics?category={category}",
                priority=1,
            ))
    
    # 2. Frequent small purchases
    small_txns = [t for t in transactions if 0 < abs(t.amount) < 100]
    if len(small_txns) > 20:
        total_small = sum(abs(t.amount) for t in small_txns)
        tips.append(InsightTip(
            id=f"small_purchases_{datetime.now().strftime('%Y%m')}",
            type="suggestion",
            title="Small Purchases Add Up",
            message=f"{len(small_txns)} purchases under ₹100 totaling ₹{total_small:,.0f}. "
                    f"Consider a weekly discretionary budget.",
            potential_savings=total_small * 0.4,
            action_url="/budgets/create",
            priority=2,
        ))
    
    # 3. Positive trends (celebrations)
    savings_trend = calculate_savings_trend(transactions)
    if savings_trend > 0.1:
        tips.append(InsightTip(
            id=f"savings_up_{datetime.now().strftime('%Y%m')}",
            type="celebration",
            title="You're Saving More! 🎉",
            message=f"Your savings rate improved by {savings_trend*100:.0f}% this month. Keep it up!",
            potential_savings=None,
            action_url=None,
            priority=3,
        ))
    
    # Limit to top 3 tips by priority
    tips.sort(key=lambda t: t.priority)
    return tips[:3]

def get_grade(score: int) -> str:
    """Convert score to letter grade"""
    if score >= 95: return "A+"
    if score >= 90: return "A"
    if score >= 85: return "A-"
    if score >= 80: return "B+"
    if score >= 75: return "B"
    if score >= 70: return "B-"
    if score >= 65: return "C+"
    if score >= 60: return "C"
    if score >= 55: return "C-"
    if score >= 50: return "D"
    return "F"

def get_motivational_message(score: int, grade: str, trend: str) -> str:
    """Generate contextual motivational message"""
    if score >= 90:
        return "Outstanding! You're a financial rockstar! 🌟"
    if score >= 80:
        return "Great job! Your finances are in excellent shape."
    if score >= 70:
        return "You're doing well! A few tweaks could boost your score."
    if score >= 60:
        return "Good progress! Check your tips for improvement ideas."
    if trend == "up":
        return "You're improving! Keep building those good habits."
    return "Let's work on this together. Small changes make a big difference!"
```

### PostgreSQL Schema

```sql
-- Financial health score history
CREATE TABLE health_scores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    overall_score INTEGER NOT NULL CHECK (overall_score BETWEEN 0 AND 100),
    grade VARCHAR(2) NOT NULL,
    components JSONB NOT NULL,
    calculated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_health_scores_user_date ON health_scores(user_id, calculated_at DESC);

-- Insight tips (for tracking dismissals/snoozes)
CREATE TABLE insight_tips (
    id VARCHAR(100) PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    potential_savings DECIMAL(12,2),
    action_url VARCHAR(255),
    priority INTEGER DEFAULT 5,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'dismissed', 'snoozed', 'acted')),
    snoozed_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_insight_tips_user_active ON insight_tips(user_id, status) WHERE status = 'active';

-- Educational modules
CREATE TABLE education_modules (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    difficulty VARCHAR(20) CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
    xp_reward INTEGER DEFAULT 50,
    estimated_minutes INTEGER DEFAULT 5,
    content JSONB NOT NULL,  -- Cards, quizzes, etc.
    display_order INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT true
);

-- User education progress
CREATE TABLE user_education_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    module_id INTEGER NOT NULL REFERENCES education_modules(id),
    progress_percent INTEGER DEFAULT 0 CHECK (progress_percent BETWEEN 0 AND 100),
    completed_at TIMESTAMP,
    quiz_score INTEGER,
    xp_earned INTEGER DEFAULT 0,
    started_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, module_id)
);

-- Achievements/badges
CREATE TABLE achievements (
    id SERIAL PRIMARY KEY,
    key VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    icon_name VARCHAR(50) NOT NULL,
    xp_reward INTEGER DEFAULT 100,
    criteria JSONB NOT NULL,  -- Conditions to unlock
    is_hidden BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0
);

-- User achievements
CREATE TABLE user_achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_id INTEGER NOT NULL REFERENCES achievements(id),
    unlocked_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, achievement_id)
);

-- User XP and level
CREATE TABLE user_gamification (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_xp INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    tracking_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_tracked_at DATE,
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Seed achievements
INSERT INTO achievements (key, name, description, icon_name, xp_reward, criteria) VALUES
('first_budget', 'First Budget', 'Created your first budget', 'savings', 50, '{"type": "budget_created", "count": 1}'),
('week_streak', 'Week Warrior', '7-day tracking streak', 'local_fire_department', 100, '{"type": "streak", "days": 7}'),
('under_budget', 'Budget Boss', 'Finished a month under budget', 'emoji_events', 150, '{"type": "budget_status", "status": "under"}'),
('savings_star', 'Savings Star', 'Saved 20% or more of income', 'star', 200, '{"type": "savings_rate", "min": 0.20}'),
('learning_machine', 'Knowledge Seeker', 'Completed 5 education modules', 'school', 100, '{"type": "modules_completed", "count": 5}'),
('social_spender', 'Bill Splitter Pro', 'Split 10 bills with friends', 'groups', 75, '{"type": "bills_split", "count": 10}');
```

### Flutter UI Components

```dart
// lib/features/insights/presentation/widgets/health_score_card.dart
class HealthScoreCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(healthScoreProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: score.when(
          data: (s) => Column(
            children: [
              // Animated score ring
              SizedBox(
                height: 160,
                width: 160,
                child: AnimatedHealthScoreRing(
                  score: s.overallScore,
                  grade: s.grade,
                  color: _getScoreColor(s.overallScore),
                ),
              ),
              const SizedBox(height: 16),
              
              // Trend indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    s.trend == 'up' ? Icons.trending_up :
                    s.trend == 'down' ? Icons.trending_down :
                    Icons.trending_flat,
                    color: s.trend == 'up' ? Colors.green :
                           s.trend == 'down' ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${s.trendDelta >= 0 ? "+" : ""}${s.trendDelta} from last week',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Message
              Text(
                s.message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              
              // View breakdown button
              TextButton(
                onPressed: () => _showBreakdown(context, s),
                child: const Text('See Breakdown'),
              ),
            ],
          ),
          loading: () => const HealthScoreSkeleton(),
          error: (e, _) => _InsufficientDataView(),
        ),
      ),
    );
  }
}

// lib/features/insights/presentation/widgets/tip_card.dart
class InsightTipCard extends StatelessWidget {
  final InsightTip tip;
  final VoidCallback onDismiss;
  final VoidCallback? onAction;
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(tip.id),
      onDismissed: (_) => onDismiss(),
      child: Card(
        color: _getTipColor(tip.type),
        child: ListTile(
          leading: _getTipIcon(tip.type),
          title: Text(tip.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tip.message),
              if (tip.potentialSavings != null)
                Chip(
                  label: Text('Save ₹${tip.potentialSavings!.toInt()}/month'),
                  backgroundColor: Colors.green.shade100,
                ),
            ],
          ),
          trailing: tip.actionUrl != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: onAction,
                )
              : null,
        ),
      ),
    );
  }
}
```

---

## Definition of Done

- [ ] Health score calculation (5 components)
- [ ] Animated score visualization
- [ ] Personalized tips (3 max)
- [ ] Spending predictions
- [ ] Education modules (5 initial)
- [ ] Achievement system (6 badges)
- [ ] XP and leveling system
- [ ] Streak tracking
- [ ] PostgreSQL schema + seeds
- [ ] Widget tests
- [ ] AI service unit tests
- [ ] Code reviewed

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-040 | Blocks | Category data for analysis |
| SS-050 | Blocks | Budget data for adherence |
| SS-205 | Blocks | Transaction data |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-060 | Dashboard (health score widget) |

---

## Security Considerations

1. **Data Minimization**: Only aggregate data sent to AI service
2. **No Raw Transactions**: Insights service gets summaries only
3. **User Opt-Out**: Allow disabling insights/tips

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Health score algorithm | 6 |
| Score visualization | 4 |
| Tip generation AI | 6 |
| Spending predictions | 4 |
| Education modules UI | 4 |
| Achievement system | 4 |
| XP/leveling logic | 3 |
| PostgreSQL schema | 3 |
| Widget tests | 3 |
| AI service tests | 3 |
| **Total** | **40 hours** |

---

*Created: 2026-02-04 | Last Updated: 2026-02-05*
