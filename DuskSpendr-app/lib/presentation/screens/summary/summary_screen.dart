import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/transaction_provider.dart';

/// SS-084: Weekly/Monthly Spending Summary Screen
class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _weekPageController = PageController();
  final PageController _monthPageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weekPageController.dispose();
    _monthPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text('Spending Summary',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareSummary,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WeeklySummaryView(pageController: _weekPageController),
          _MonthlySummaryView(pageController: _monthPageController),
        ],
      ),
    );
  }

  void _shareSummary() {
    // TODO: Generate summary image and share
    Share.share('Check out my spending summary on DuskSpendr!');
  }
}

// ====== Weekly Summary ======

class _WeeklySummaryView extends ConsumerWidget {
  final PageController pageController;

  const _WeeklySummaryView({required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView.builder(
      controller: pageController,
      reverse: true, // Latest week first
      itemCount: 12, // Show last 12 weeks
      itemBuilder: (context, index) {
        return _WeeklySummaryCard(weeksAgo: index);
      },
    );
  }
}

class _WeeklySummaryCard extends ConsumerWidget {
  final int weeksAgo;

  const _WeeklySummaryCard({required this.weeksAgo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final weekEnd = now.subtract(Duration(days: now.weekday - 7 + (weeksAgo * 7)));
    final weekStart = weekEnd.subtract(const Duration(days: 6));

    final weeklySpending = ref.watch(weeklySpendingProvider);
    final categoryBreakdown = ref.watch(categorySpendingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week header
          _WeekHeader(start: weekStart, end: weekEnd),
          const SizedBox(height: AppSpacing.lg),

          // Total spent card
          weeklySpending.when(
            data: (total) => _SpendingTotalCard(
              amount: total,
              label: 'This Week',
              changePercent: weeksAgo == 0 ? null : 0, // TODO: Calculate
            ),
            loading: () => const _LoadingCard(),
            error: (e, _) => _ErrorCard(message: e.toString()),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Daily breakdown chart
          _DailyBreakdownChart(weekStart: weekStart),
          const SizedBox(height: AppSpacing.lg),

          // Category breakdown
          Text('Category Breakdown',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          categoryBreakdown.when(
            data: (categories) => _CategoryBreakdown(categories: categories),
            loading: () => const _LoadingCard(),
            error: (e, _) => _ErrorCard(message: e.toString()),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Insights
          _WeeklyInsights(weekStart: weekStart),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  final DateTime start;
  final DateTime end;

  const _WeekHeader({required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    final startStr = '${start.day} ${_monthName(start.month)}';
    final endStr = '${end.day} ${_monthName(end.month)}';

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: AppColors.textSecondary,
          onPressed: () {}, // Handled by PageView
        ),
        Expanded(
          child: Center(
            child: Text(
              '$startStr - $endStr',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: AppColors.textSecondary,
          onPressed: () {},
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

// ====== Monthly Summary ======

class _MonthlySummaryView extends ConsumerWidget {
  final PageController pageController;

  const _MonthlySummaryView({required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView.builder(
      controller: pageController,
      reverse: true,
      itemCount: 12, // Show last 12 months
      itemBuilder: (context, index) {
        return _MonthlySummaryCard(monthsAgo: index);
      },
    );
  }
}

class _MonthlySummaryCard extends ConsumerWidget {
  final int monthsAgo;

  const _MonthlySummaryCard({required this.monthsAgo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final targetMonth = DateTime(now.year, now.month - monthsAgo, 1);

    final monthlySpending = ref.watch(thisMonthSpendingProvider);
    final categoryBreakdown = ref.watch(categorySpendingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          _MonthHeader(month: targetMonth),
          const SizedBox(height: AppSpacing.lg),

          // Total spent vs budget
          monthlySpending.when(
            data: (total) => _BudgetComparisonCard(
              spent: total,
              budget: Money.fromPaisa(2000000), // TODO: Get from budget provider
            ),
            loading: () => const _LoadingCard(),
            error: (e, _) => _ErrorCard(message: e.toString()),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Category trend bars
          Text('Category Spending',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          categoryBreakdown.when(
            data: (categories) => _CategoryTrendBars(categories: categories),
            loading: () => const _LoadingCard(),
            error: (e, _) => _ErrorCard(message: e.toString()),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Monthly highlights
          _MonthlyHighlights(),
          const SizedBox(height: AppSpacing.lg),

          // Weekly mini chart
          Text('Weekly Breakdown',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          _WeeklyMiniChart(month: targetMonth),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

}

class _MonthHeader extends StatelessWidget {
  final DateTime month;

  const _MonthHeader({required this.month});

  @override
  Widget build(BuildContext context) {
    final monthName = _fullMonthName(month.month);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: AppColors.textSecondary,
          onPressed: () {},
        ),
        Expanded(
          child: Center(
            child: Text(
              '$monthName ${month.year}',
              style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: AppColors.textSecondary,
          onPressed: () {},
        ),
      ],
    );
  }

  String _fullMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }
}

// ====== Shared Components ======

class _SpendingTotalCard extends StatelessWidget {
  final Money amount;
  final String label;
  final double? changePercent;

  const _SpendingTotalCard({
    required this.amount,
    required this.label,
    this.changePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.gradientPrimary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              )),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amount.formatted,
            style: AppTypography.amountLarge.copyWith(color: Colors.white),
          ),
          if (changePercent != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  changePercent! >= 0 ? Icons.trending_up : Icons.trending_down,
                  color: changePercent! >= 0 ? AppColors.danger : AppColors.accent,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${changePercent!.abs().toStringAsFixed(1)}% vs last period',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BudgetComparisonCard extends StatelessWidget {
  final Money spent;
  final Money budget;

  const _BudgetComparisonCard({
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final progress = budget.paisa > 0 
        ? (spent.paisa / budget.paisa).clamp(0.0, 1.0)
        : 0.0;
    final remaining = Money.fromPaisa(
      (budget.paisa - spent.paisa).clamp(0, budget.paisa),
    );
    final isOverBudget = spent.paisa > budget.paisa;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isOverBudget ? AppColors.danger.withValues(alpha: 0.5) : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Budget Progress',
                  style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: AppTypography.h3.copyWith(
                  color: isOverBudget ? AppColors.danger : AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppColors.dusk700.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation(
                isOverBudget ? AppColors.danger : AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Spent', style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  )),
                  Text(spent.formatted, style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(isOverBudget ? 'Over by' : 'Remaining',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      )),
                  Text(
                    isOverBudget 
                        ? '-${Money.fromPaisa(spent.paisa - budget.paisa).formatted}'
                        : remaining.formatted,
                    style: AppTypography.bodyLarge.copyWith(
                      color: isOverBudget ? AppColors.danger : AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  final Map<TransactionCategory, Money> categories;

  const _CategoryBreakdown({required this.categories});

  @override
  Widget build(BuildContext context) {
    final sorted = categories.entries.toList()
      ..sort((a, b) => b.value.paisa.compareTo(a.value.paisa));
    final total = sorted.fold<int>(0, (sum, e) => sum + e.value.paisa);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: sorted.take(5).map((entry) {
          final percent = total > 0 ? (entry.value.paisa / total) * 100 : 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _CategoryBar(
              category: entry.key,
              amount: entry.value,
              percent: percent.toDouble(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final TransactionCategory category;
  final Money amount;
  final double percent;

  const _CategoryBar({
    required this.category,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getCategoryColor(category.name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  category.name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              '${amount.formatted} (${percent.toStringAsFixed(0)}%)',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: AppColors.dusk700.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _CategoryTrendBars extends StatelessWidget {
  final Map<TransactionCategory, Money> categories;

  const _CategoryTrendBars({required this.categories});

  @override
  Widget build(BuildContext context) {
    // Simplified - shows same as CategoryBreakdown
    return _CategoryBreakdown(categories: categories);
  }
}

class _DailyBreakdownChart extends StatelessWidget {
  final DateTime weekStart;

  const _DailyBreakdownChart({required this.weekStart});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final data = [1200, 800, 1500, 600, 2100, 900, 1100];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Spending',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final height = maxValue > 0 ? (data[index] / maxValue) * 120 : 0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '₹${(data[index] / 100).toStringAsFixed(0)}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height.toDouble(),
                          decoration: BoxDecoration(
                            color: index == DateTime.now().weekday - 1
                                ? AppColors.primary
                                : AppColors.dusk600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          days[index],
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyMiniChart extends StatelessWidget {
  final DateTime month;

  const _WeeklyMiniChart({required this.month});

  @override
  Widget build(BuildContext context) {
    // Placeholder - 4 weeks
    final weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    final data = [5200, 4800, 6100, 3900];
    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: List.generate(4, (index) {
          final height = maxValue > 0 ? (data[index] / maxValue) * 80 : 0;
          return Expanded(
            child: Column(
              children: [
                Text(
                  '₹${(data[index] / 100).toStringAsFixed(0)}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: height.toDouble(),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weeks[index],
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _WeeklyInsights extends StatelessWidget {
  final DateTime weekStart;

  const _WeeklyInsights({required this.weekStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insights',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          _InsightRow(
            emoji: '📅',
            text: 'Friday was your highest spending day',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InsightRow(
            emoji: '🍔',
            text: 'Food is your top category at 42%',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InsightRow(
            emoji: '💰',
            text: 'You saved ₹800 compared to last week',
            isPositive: true,
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final String emoji;
  final String text;
  final bool isPositive;

  const _InsightRow({
    required this.emoji,
    required this.text,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              color: isPositive ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthlyHighlights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Highlights',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _HighlightItem(
                  icon: Icons.shopping_bag,
                  label: 'Biggest Expense',
                  value: 'Flipkart ₹2,500',
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _HighlightItem(
                  icon: Icons.savings,
                  label: 'Saved',
                  value: '₹3,200',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _HighlightItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          )),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.danger),
      ),
    );
  }
}

