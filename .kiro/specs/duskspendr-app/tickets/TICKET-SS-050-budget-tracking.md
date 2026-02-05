# SS-050: Budget Tracking & Alerts

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-050 |
| **Epic** | Budget & Financial Tracking |
| **Type** | Feature |
| **Priority** | P0 - Critical |
| **Story Points** | 13 |
| **Sprint** | Sprint 4-5 |
| **Assignee** | TBD |
| **Labels** | `budget`, `alerts`, `notifications`, `flutter`, `go`, `postgresql` |

---

## User Story

**As a** student with limited pocket money  
**I want** to set budgets and get alerts when I'm overspending  
**So that** I don't run out of money before month-end

---

## Description

Implement a comprehensive budget tracking system that allows students to set spending limits by category or overall, visualize progress, and receive smart alerts at key thresholds. The system syncs across devices via PostgreSQL and sends push notifications through the Go notification service.

---

## Acceptance Criteria

### AC1: Budget Creation
```gherkin
Given I'm on the budget screen
When I create a new budget
Then I can set:
  | Field | Options |
  | Amount | ₹100 - ₹100,000 (slider + input) |
  | Period | Weekly, Monthly, Custom dates |
  | Category | All spending, or specific category |
  | Name | Custom name like "Food Budget" |
  | Rollover | Enable/disable surplus rollover |
And the budget should sync across all my devices
And show confirmation with daily allowance calculation
```

### AC2: Progress Tracking
```gherkin
Given I have an active budget
When I view the dashboard or budget screen
Then I should see:
  - Circular/linear progress indicator (spent vs budget)
  - Remaining amount in large font
  - Days left in current period
  - Daily allowance (remaining ÷ days left)
  - Trend indicator (on track, at risk, over)
And the UI should change colors:
  | Progress | Color |
  | 0-74% | Green |
  | 75-89% | Orange |
  | 90-99% | Red |
  | 100%+ | Dark Red with pulse animation |
```

### AC3: Smart Alerts
```gherkin
Given budget thresholds are configured
When spending reaches a threshold
Then send push notification:
  | Threshold | Title | Message |
  | 50% | "Halfway there!" | "You've used half your {budget}. ₹{remaining} left for {days} days" |
  | 75% | "Budget Alert ⚠️" | "75% of {budget} used. Consider slowing down spending" |
  | 90% | "Almost Depleted! 🔴" | "Only ₹{remaining} left in {budget}. Be careful!" |
  | 100% | "Budget Exceeded! 🚨" | "{budget} exceeded by ₹{over}. Track extra spending carefully" |
And notification should deep-link to budget details
And user can customize which alerts to receive
```

### AC4: Rollover Option
```gherkin
Given a budget period ends with ₹500 unspent
When the new period starts
Then if rollover is enabled:
  - New budget = base amount + ₹500
  - Show "Rollover: +₹500" badge
Else if rollover is disabled:
  - New budget = base amount only
  - Show surplus celebration ("Saved ₹500!")
```

### AC5: Budget History
```gherkin
Given I want to review past budgets
When I access budget history
Then show:
  - Past 12 periods with spent vs budget
  - Trend line visualization
  - Average spending per period
  - Success rate (% of periods under budget)
```

---

## Technical Implementation

### Flutter UI

```dart
// lib/features/budgets/presentation/screens/budget_screen.dart
class BudgetScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(activeBudgetsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/budgets/history'),
          ),
        ],
      ),
      body: budgets.when(
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, i) => BudgetCard(budget: list[i]),
        ),
        loading: () => const BudgetCardSkeleton(),
        error: (e, s) => ErrorView(error: e),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBudgetSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('New Budget'),
      ),
    );
  }
}

// lib/features/budgets/presentation/widgets/budget_card.dart
class BudgetCard extends StatelessWidget {
  final Budget budget;
  
  @override
  Widget build(BuildContext context) {
    final progress = budget.spent / budget.amount;
    final color = _getProgressColor(progress);
    final daysLeft = budget.endDate.difference(DateTime.now()).inDays;
    final dailyAllowance = budget.remaining / max(daysLeft, 1);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/budgets/${budget.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (budget.category != null)
                        Icon(budget.category!.icon, size: 20),
                      const SizedBox(width: 8),
                      Text(budget.name, style: context.textTheme.titleMedium),
                    ],
                  ),
                  _StatusChip(progress: progress),
                ],
              ),
              const SizedBox(height: 16),
              
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.clamp(0, 1),
                  minHeight: 12,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              const SizedBox(height: 12),
              
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    label: 'Spent',
                    value: '₹${budget.spent.toInt()}',
                  ),
                  _StatItem(
                    label: 'Remaining',
                    value: '₹${budget.remaining.toInt()}',
                    isHighlighted: true,
                  ),
                  _StatItem(
                    label: 'Daily',
                    value: '₹${dailyAllowance.toInt()}/day',
                  ),
                ],
              ),
              
              // Footer
              const SizedBox(height: 8),
              Text(
                '$daysLeft days left • ${budget.periodLabel}',
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getProgressColor(double progress) {
    if (progress >= 1.0) return Colors.red.shade700;
    if (progress >= 0.9) return Colors.red;
    if (progress >= 0.75) return Colors.orange;
    return Colors.green;
  }
}
```

### PostgreSQL Schema

```sql
-- Budgets table
CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    period VARCHAR(20) NOT NULL CHECK (period IN ('weekly', 'monthly', 'custom')),
    category_id INTEGER REFERENCES categories(id),
    start_date DATE NOT NULL,
    end_date DATE,
    is_active BOOLEAN DEFAULT true,
    rollover_enabled BOOLEAN DEFAULT false,
    alert_thresholds INTEGER[] DEFAULT '{50, 75, 90, 100}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Budget periods (historical tracking)
CREATE TABLE budget_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id UUID NOT NULL REFERENCES budgets(id) ON DELETE CASCADE,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    base_amount DECIMAL(12,2) NOT NULL,
    rollover_amount DECIMAL(12,2) DEFAULT 0,
    total_amount DECIMAL(12,2) GENERATED ALWAYS AS (base_amount + rollover_amount) STORED,
    spent DECIMAL(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'exceeded')),
    completed_at TIMESTAMP,
    UNIQUE(budget_id, period_start)
);

-- Alert history (prevent duplicate notifications)
CREATE TABLE budget_alerts_sent (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id UUID NOT NULL REFERENCES budgets(id) ON DELETE CASCADE,
    period_id UUID NOT NULL REFERENCES budget_periods(id) ON DELETE CASCADE,
    threshold INTEGER NOT NULL,
    sent_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(budget_id, period_id, threshold)
);

-- Indexes
CREATE INDEX idx_budgets_user_active ON budgets(user_id, is_active) WHERE is_active = true;
CREATE INDEX idx_budget_periods_active ON budget_periods(budget_id, status) WHERE status = 'active';
```

### Go Notification Service

```go
// internal/notifications/budget_service.go
package notifications

import (
    "context"
    "fmt"
    "time"

    "github.com/DuskSpendr/backend/internal/models"
    "github.com/DuskSpendr/backend/internal/push"
)

type BudgetAlertService struct {
    repo        models.BudgetRepository
    pushService *push.Service
    db          *sql.DB
}

func (s *BudgetAlertService) CheckAllBudgets(ctx context.Context) error {
    // Get all active budgets with spending data
    budgets, err := s.repo.GetActiveBudgetsWithSpending(ctx)
    if err != nil {
        return fmt.Errorf("failed to get budgets: %w", err)
    }

    for _, budget := range budgets {
        if err := s.checkBudgetThresholds(ctx, budget); err != nil {
            log.Printf("Error checking budget %s: %v", budget.ID, err)
        }
    }
    return nil
}

func (s *BudgetAlertService) checkBudgetThresholds(ctx context.Context, budget models.BudgetWithSpending) error {
    progress := budget.Spent / budget.TotalAmount
    progressPct := int(progress * 100)

    for _, threshold := range budget.AlertThresholds {
        if progressPct >= threshold {
            // Check if already sent
            sent, _ := s.repo.IsAlertSent(ctx, budget.ID, budget.PeriodID, threshold)
            if sent {
                continue
            }

            // Build notification
            notification := s.buildNotification(budget, threshold)
            
            // Send push
            if err := s.pushService.SendToUser(ctx, budget.UserID, notification); err != nil {
                return err
            }

            // Mark as sent
            s.repo.MarkAlertSent(ctx, budget.ID, budget.PeriodID, threshold)
        }
    }
    return nil
}

func (s *BudgetAlertService) buildNotification(budget models.BudgetWithSpending, threshold int) push.Notification {
    remaining := budget.TotalAmount - budget.Spent
    daysLeft := time.Until(budget.PeriodEnd).Hours() / 24

    var title, body string
    switch threshold {
    case 50:
        title = "Halfway there!"
        body = fmt.Sprintf("You've used half your %s. ₹%.0f left for %.0f days", 
            budget.Name, remaining, daysLeft)
    case 75:
        title = "Budget Alert ⚠️"
        body = fmt.Sprintf("75%% of %s used. Consider slowing down spending", budget.Name)
    case 90:
        title = "Almost Depleted! 🔴"
        body = fmt.Sprintf("Only ₹%.0f left in %s. Be careful!", remaining, budget.Name)
    case 100:
        over := budget.Spent - budget.TotalAmount
        title = "Budget Exceeded! 🚨"
        body = fmt.Sprintf("%s exceeded by ₹%.0f", budget.Name, over)
    }

    return push.Notification{
        Title: title,
        Body:  body,
        Data: map[string]string{
            "type":      "budget_alert",
            "budget_id": budget.ID,
            "threshold": fmt.Sprintf("%d", threshold),
        },
    }
}
```

---

## Definition of Done

- [ ] Budget CRUD in Flutter + Serverpod backend
- [ ] Progress visualization with color changes
- [ ] Threshold alerts at 50%, 75%, 90%, 100%
- [ ] Push notifications via Go service
- [ ] PostgreSQL schema + migrations
- [ ] Rollover logic implemented
- [ ] Budget history view
- [ ] Alert preferences (per budget)
- [ ] Widget tests
- [ ] Integration tests
- [ ] Code reviewed

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-002 | Blocks | Local DB for offline |
| SS-205 | Blocks | Transaction service (spending data) |
| SS-209 | Blocks | Notification service |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-060 | Dashboard (budget progress card) |
| SS-080 | Financial insights |

---

## Security Considerations

1. **User Isolation**: Users can only view/edit their own budgets
2. **Amount Validation**: Server-side validation of budget amounts
3. **Rate Limiting**: Prevent alert flooding

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Budget CRUD (Flutter) | 6 |
| Budget CRUD (Backend) | 4 |
| Progress visualization | 4 |
| Alert threshold system | 4 |
| Go notification integration | 4 |
| Rollover logic | 3 |
| Budget history view | 3 |
| PostgreSQL schema | 2 |
| Widget tests | 3 |
| Integration tests | 2 |
| **Total** | **35 hours** |

---

*Created: 2026-02-04 | Last Updated: 2026-02-05*
