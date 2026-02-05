# SS-060: Student Dashboard UI

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-060 |
| **Epic** | User Interface |
| **Type** | Feature |
| **Priority** | P0 - Critical |
| **Story Points** | 13 |
| **Sprint** | Sprint 5-6 |
| **Assignee** | TBD |
| **Labels** | `ui`, `dashboard`, `flutter`, `charts`, `gamification` |

---

## User Story

**As a** student opening DuskSpendr  
**I want** to see a beautiful, informative dashboard at a glance  
**So that** I immediately understand my financial health without digging through menus

---

## Description

Design and implement an engaging, student-focused dashboard that displays key financial metrics, spending trends, budget status, and gamification elements. The UI should feel modern, fresh, and motivating while providing actionable insights at a glance.

---

## Acceptance Criteria

### AC1: Financial Summary Card
```gherkin
Given I'm on the dashboard
Then the top summary card should display:
  | Metric | Display |
  | Balance | Large font, primary color |
  | This month's spending | With trend arrow (↑↓) |
  | This month's income | Green color |
  | Savings rate | Percentage with gauge |
And support pull-to-refresh
And animate number changes
```

### AC2: Spending Breakdown Charts
```gherkin
Given I have transactions this month
When viewing the dashboard
Then show spending breakdown:
  - Donut/pie chart by category
  - Top 3 categories with amounts
  - "See all" link to detailed breakdown
And chart should be interactive:
  - Tap segment = highlight + show amount
  - Animate on first load
```

### AC3: Budget Progress
```gherkin
Given I have active budgets
Then dashboard should show:
  - Overall spending vs total budget (bar/ring)
  - Most at-risk budget (if any)
  - Quick action: "Create Budget" if none
And tap navigates to budget details
```

### AC4: Recent Transactions
```gherkin
Given I have transactions
Then show last 5 transactions:
  - Merchant icon/avatar
  - Merchant name
  - Amount (red for debit, green for credit)
  - Category pill
  - Relative time (today, yesterday, etc.)
And include "See All" button
And swipe to categorize (if uncategorized)
```

### AC5: Gamification Elements
```gherkin
Given the student-focused design
Then dashboard should include:
  | Element | Description |
  | Streak | "7-day tracking streak 🔥" |
  | Level | "Level 5 Budgeter" with XP bar |
  | Achievements | Recent badge earned (mini) |
  | Challenge | Weekly challenge progress |
And elements should be subtle, not overwhelming
```

### AC6: Quick Actions
```gherkin
Given I'm on the dashboard
Then provide quick action buttons:
  - "Add Transaction" (floating or chip)
  - "Scan Receipt" (if enabled)
  - "See Insights"
And actions should be reachable within 1 tap
```

### AC7: Empty States
```gherkin
Given I'm a new user with no data
Then show engaging empty states:
  | Section | Empty State |
  | Transactions | "No transactions yet. Link your bank or add manually" |
  | Budget | "Set your first budget! 🎯" |
  | Chart | "Start tracking to see your spending patterns" |
And include clear CTA buttons
```

---

## Design Specifications

### Visual Design

```yaml
Layout:
  - Safe area padding: 16dp
  - Card border radius: 16dp
  - Card elevation: 2dp (light) / 4dp (dark)
  - Space between cards: 16dp

Colors (Light Mode):
  primary: "#6366F1"      # Indigo
  secondary: "#14B8A6"    # Teal  
  surface: "#FFFFFF"
  background: "#F8FAFC"
  income: "#10B981"       # Emerald
  expense: "#EF4444"      # Red
  warning: "#F59E0B"      # Amber

Colors (Dark Mode):
  primary: "#818CF8"
  secondary: "#2DD4BF"
  surface: "#1E293B"
  background: "#0F172A"
  income: "#34D399"
  expense: "#F87171"

Typography:
  balance: 36sp, Bold
  cardTitle: 16sp, SemiBold
  metric: 24sp, Bold
  label: 12sp, Medium
  body: 14sp, Regular
```

---

## Technical Implementation

### Flutter Screen

```dart
// lib/features/dashboard/presentation/screens/dashboard_screen.dart
class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(dashboardDataProvider.future),
        child: CustomScrollView(
          slivers: [
            // Collapsing app bar with greeting
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: _GreetingHeader(),
              ),
            ),
            
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const BalanceSummaryCard(),
                  const SizedBox(height: 16),
                  const SpendingChartCard(),
                  const SizedBox(height: 16),
                  const BudgetProgressCard(),
                  const SizedBox(height: 16),
                  const GamificationRow(),
                  const SizedBox(height: 16),
                  const RecentTransactionsCard(),
                  const SizedBox(height: 80), // FAB clearance
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransaction(context),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}

// lib/features/dashboard/presentation/widgets/balance_summary_card.dart
class BalanceSummaryCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(monthlySummaryProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Balance', style: context.textTheme.labelMedium),
            const SizedBox(height: 4),
            AnimatedNumberText(
              value: summary.balance,
              prefix: '₹',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _MetricPill(
                  label: 'Income',
                  value: summary.income,
                  color: context.colorScheme.income,
                  icon: Icons.arrow_downward,
                ),
                const SizedBox(width: 12),
                _MetricPill(
                  label: 'Expenses', 
                  value: summary.expenses,
                  color: context.colorScheme.expense,
                  icon: Icons.arrow_upward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// lib/features/dashboard/presentation/widgets/spending_chart_card.dart
class SpendingChartCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spending = ref.watch(categorySpendingProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spending', style: context.textTheme.titleMedium),
                TextButton(
                  onPressed: () => context.push('/analytics'),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: spending.when(
                data: (data) => Row(
                  children: [
                    Expanded(
                      child: AnimatedPieChart(
                        data: data,
                        onSegmentTap: (category) {
                          // Show category detail
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TopCategoriesList(categories: data.take(3)),
                    ),
                  ],
                ),
                loading: () => const ChartSkeleton(),
                error: (e, _) => ErrorView(error: e),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/features/dashboard/presentation/widgets/gamification_row.dart
class GamificationRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _StreakChip(
            days: gamification.trackingStreak,
            isActive: gamification.trackedToday,
          ),
          const SizedBox(width: 12),
          _LevelChip(
            level: gamification.level,
            xp: gamification.xp,
            xpToNext: gamification.xpToNextLevel,
          ),
          const SizedBox(width: 12),
          if (gamification.recentBadge != null)
            _BadgeChip(badge: gamification.recentBadge!),
        ],
      ),
    );
  }
}
```

### Chart Library Integration

```dart
// lib/features/dashboard/presentation/widgets/animated_pie_chart.dart
import 'package:fl_chart/fl_chart.dart';

class AnimatedPieChart extends StatefulWidget {
  final List<CategorySpending> data;
  final Function(Category)? onSegmentTap;

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              touchedIndex = response?.touchedSection?.touchedSectionIndex;
            });
            if (event is FlTapUpEvent && touchedIndex != null) {
              widget.onSegmentTap?.call(widget.data[touchedIndex!].category);
            }
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: widget.data.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isTouched = i == touchedIndex;
          
          return PieChartSectionData(
            color: item.category.color,
            value: item.amount,
            title: isTouched ? '₹${item.amount.toInt()}' : '',
            radius: isTouched ? 60 : 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
      swapAnimationDuration: const Duration(milliseconds: 300),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
}
```

---

## Definition of Done

- [ ] All dashboard cards implemented
- [ ] Pull-to-refresh working
- [ ] Charts animate on load
- [ ] Gamification elements visible
- [ ] Empty states for all sections
- [ ] Dark mode support
- [ ] Responsive on all screen sizes
- [ ] Golden tests for visual regression
- [ ] Widget tests for interactions
- [ ] Performance: 60fps scrolling
- [ ] Accessibility labels
- [ ] Code reviewed

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-001 | Blocks | Project setup |
| SS-002 | Blocks | Local database |
| SS-205 | Blocks | Transaction data |
| SS-050 | Related | Budget data |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-080 | Financial insights (uses dashboard) |

---

## Security Considerations

1. **No Sensitive Data in Logs**: Avoid logging balance/amounts
2. **Obscure Mode**: Option to hide balances (privacy)
3. **Screen Capture**: Consider screenshot protection for balance

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Balance summary card | 3 |
| Spending chart (fl_chart) | 6 |
| Budget progress card | 3 |
| Recent transactions list | 3 |
| Gamification elements | 4 |
| Empty states | 2 |
| Dark mode styling | 3 |
| Animations | 3 |
| Widget tests | 4 |
| Golden tests | 2 |
| Accessibility | 2 |
| **Total** | **35 hours** |

---

## Related Links

- [fl_chart Documentation](https://pub.dev/packages/fl_chart)
- [Material Design 3](https://m3.material.io/)
- [Flutter Animations](https://docs.flutter.dev/ui/animations)

---

*Created: 2026-02-04 | Last Updated: 2026-02-05*
