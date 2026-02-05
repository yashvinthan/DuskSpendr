# Spec 5: Budget & Financial Tracking

## Overview

This specification covers student-focused budget management, balance tracking, bill reminders, and comprehensive financial product tracking including loans and investments.

**Priority:** P0 (Core Feature)  
**Estimated Effort:** 3 sprints  
**Dependencies:** Spec 1, Spec 3, Spec 4

---

## Goals

1. Enable students to set and track daily/weekly/monthly budgets
2. Provide intelligent overspending alerts before limits are exceeded
3. Track account balances across all linked sources
4. Set up bill payment reminders
5. Track financial products (loans, credit cards, investments)

---

## Budget Types

| Type | Reset Cycle | Use Case |
|------|-------------|----------|
| Daily | Every day | Daily pocket money limit |
| Weekly | Every Monday | Weekly allowance |
| Monthly | 1st of month | Monthly expenses |
| Category | Per category | Food budget, Entertainment limit |
| Custom | User-defined | Exam week, Festival season |

---

## Tickets

### SS-060: Implement daily/weekly/monthly budget system
**Priority:** P0 | **Points:** 8

**Description:**
Build the core budget tracking engine with multiple period types.

**Acceptance Criteria:**
- [ ] Create Budget domain model and database entity
- [ ] Implement budget repository with CRUD operations
- [ ] Support daily, weekly, monthly, custom periods
- [ ] Track spending against budget in real-time
- [ ] Calculate remaining budget automatically
- [ ] Handle period rollover (new day/week/month)
- [ ] Support overall budget and category-specific budgets
- [ ] Track budget history for trends
- [ ] Implement budget vs actual calculations

**Budget Model:**
```kotlin
data class Budget(
    val id: String,
    val name: String,
    val category: Category?,  // null = overall
    val amount: Money,
    val period: BudgetPeriod,
    val startDate: LocalDate,
    val alertThreshold: Float,  // 0.8 = 80%
    val isActive: Boolean
)
```

**Dependencies:** Spec 4 complete

---

### SS-061: Create budget creation/editing UI
**Priority:** P0 | **Points:** 5

**Description:**
Build user interface for creating and managing budgets.

**Acceptance Criteria:**
- [ ] Budget creation wizard
- [ ] Amount input with suggestions
- [ ] Period type selection
- [ ] Category selection (optional)
- [ ] Alert threshold slider
- [ ] Budget list view
- [ ] Edit existing budget
- [ ] Delete budget with confirmation
- [ ] Active/inactive toggle

**UI Flow:**
1. Select period type
2. Enter budget amount
3. Optionally select category
4. Set alert threshold
5. Save and activate

**Dependencies:** SS-060

---

### SS-062: Build overspending alert system
**Priority:** P0 | **Points:** 8

**Description:**
Implement intelligent alert system that warns before budget limits are exceeded.

**Acceptance Criteria:**
- [ ] Trigger alert at configurable threshold (default 80%)
- [ ] Send notification when approaching limit
- [ ] Send notification when limit exceeded
- [ ] In-app warning banners
- [ ] Daily summary notifications (optional)
- [ ] Predict overspending based on current pace
- [ ] Suggest spending adjustments
- [ ] Allow snoozing alerts
- [ ] Category-specific alerts

**Alert Types:**
- **Warning**: Approaching limit (80%)
- **Critical**: Exceeded limit
- **Predictive**: "At this pace, you'll exceed in 3 days"

**Dependencies:** SS-060, SS-061

---

### SS-063: Implement pocket money prediction
**Priority:** P1 | **Points:** 8

**Description:**
Predict future pocket money needs based on historical spending patterns.

**Acceptance Criteria:**
- [ ] Analyze 3-month spending history
- [ ] Calculate average spending per period
- [ ] Identify spending trends (increasing/decreasing)
- [ ] Account for seasonal variations (festivals, exams)
- [ ] Predict next month's spending
- [ ] Suggest optimal pocket money amount
- [ ] Show confidence level of prediction
- [ ] Display prediction insights UI

**Prediction Algorithm:**
1. Calculate weighted average (recent months weighted higher)
2. Detect trend (linear regression)
3. Adjust for known events
4. Add buffer for unexpected expenses

**Dependencies:** SS-060

---

### SS-064: Create account balance tracking
**Priority:** P0 | **Points:** 5

**Description:**
Track and display current balances for all linked accounts.

**Acceptance Criteria:**
- [ ] Store balance per linked account
- [ ] Update balance from SMS parsing
- [ ] Update balance from API sync
- [ ] Calculate transaction-based balance changes
- [ ] Show balance history timeline
- [ ] Handle multiple currencies (optional)
- [ ] Track wallet balances separately

**Dependencies:** Spec 3 complete

---

### SS-065: Build consolidated balance dashboard
**Priority:** P0 | **Points:** 8

**Description:**
Create dashboard showing total balance across all accounts.

**Acceptance Criteria:**
- [ ] Display total balance (sum of all accounts)
- [ ] Show individual account balances
- [ ] Pie chart of balance distribution
- [ ] Balance trend chart (7/30/90 days)
- [ ] Quick account switcher
- [ ] Hide/show balance option (privacy)
- [ ] Last updated timestamp
- [ ] Pull-to-refresh balance sync

**Dashboard Components:**
- Total balance card (big number)
- Account list with balances
- Balance trend sparkline
- Net worth summary

**Dependencies:** SS-064

---

### SS-066: Implement low balance alerts
**Priority:** P1 | **Points:** 5

**Description:**
Alert users when account balances fall below user-defined thresholds.

**Acceptance Criteria:**
- [ ] Set threshold per account
- [ ] Set overall minimum threshold
- [ ] Trigger notification when below threshold
- [ ] In-app low balance indicator
- [ ] Configurable alert frequency
- [ ] Quick action to add funds (link to bank app)

**Dependencies:** SS-064

---

### SS-067: Create bill payment reminder system
**Priority:** P1 | **Points:** 8

**Description:**
Detect recurring bills and send timely payment reminders.

**Acceptance Criteria:**
- [ ] Auto-detect recurring payments (Spec 3)
- [ ] Create bill reminder from detection
- [ ] Manual bill reminder creation
- [ ] Set reminder days before due
- [ ] Notification for upcoming bills
- [ ] Mark bill as paid
- [ ] Track payment history per bill
- [ ] Flag unusual bill amount changes
- [ ] Bill calendar view

**Bill Types:**
- Phone recharge
- Electricity
- Internet
- Subscriptions
- Rent
- Credit card
- Loan EMI

**Dependencies:** SS-039

---

### SS-068: Build loan/credit card tracking
**Priority:** P2 | **Points:** 8

**Description:**
Track personal loans, education loans, and credit card balances.

**Acceptance Criteria:**
- [ ] Add loan with principal, rate, tenure
- [ ] Track outstanding balance
- [ ] Record EMI payments
- [ ] Calculate remaining tenure
- [ ] Track credit card usage
- [ ] Credit card payment due dates
- [ ] Credit utilization percentage
- [ ] Loan completion progress bar
- [ ] Total debt summary

**Loan Model:**
```kotlin
data class Loan(
    val id: String,
    val name: String,
    val type: LoanType,
    val principal: Money,
    val interestRate: Float,
    val emiAmount: Money,
    val tenure: Int,  // months
    val startDate: LocalDate,
    val outstandingBalance: Money
)
```

**Dependencies:** Spec 4 complete

---

### SS-069: Implement investment tracking
**Priority:** P2 | **Points:** 13

**Description:**
Track investments including FDs, stocks, and mutual funds.

**Acceptance Criteria:**
- [ ] Track Fixed Deposits with maturity dates
- [ ] Track digital gold purchases
- [ ] Sync stock holdings (manual or API)
- [ ] Sync mutual fund holdings
- [ ] Track SIP payments
- [ ] Calculate portfolio value
- [ ] Show returns (absolute and percentage)
- [ ] Investment allocation pie chart
- [ ] Performance comparison to index

**Investment Types:**
- Fixed Deposits
- Digital Gold
- Stocks (Indian markets)
- Mutual Funds
- SIPs
- PPF/NPS

**Technical Notes:**
- May integrate with broker APIs (Zerodha, Groww)
- Or rely on manual entry + SMS tracking

**Dependencies:** Spec 4

---

### SS-070: Create financial calculators
**Priority:** P2 | **Points:** 5

**Description:**
Provide financial planning calculators for students.

**Acceptance Criteria:**
- [ ] EMI calculator
- [ ] Compound interest calculator
- [ ] SIP returns calculator
- [ ] Savings goal calculator
- [ ] Loan comparison tool
- [ ] Credit score impact estimator
- [ ] Export calculation results
- [ ] Save calculations for reference

**Calculator Formulas:**
```
EMI = P × r × (1 + r)^n / ((1 + r)^n - 1)
Compound Interest = P(1 + r/n)^(nt)
SIP Future Value = P × (((1 + r)^n - 1) / r) × (1 + r)
```

**Dependencies:** Spec 6 (UI)

---

## Verification Plan

### Unit Tests
- Budget calculation accuracy
- Period rollover logic
- Balance tracking calculations
- EMI and interest calculations
- Prediction algorithm accuracy

### Integration Tests
- Budget → Transaction → Alert flow
- Balance sync from multiple sources
- Bill detection and reminder flow

### UI Tests
- Budget creation flow
- Dashboard rendering
- Calculator inputs and outputs

---

## Definition of Done

- [ ] Daily/weekly/monthly budgets working
- [ ] Budget alerts triggering correctly
- [ ] Consolidated balance accurate
- [ ] Bill reminders functional
- [ ] All P0 and P1 tickets complete
- [ ] Calculator accuracy verified
