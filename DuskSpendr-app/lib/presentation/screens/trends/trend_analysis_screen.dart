import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/budget_provider.dart';

/// SS-085: Spending Trend Analysis Screen
/// Shows 3-6 month spending trends with category comparisons

class TrendAnalysisScreen extends ConsumerStatefulWidget {
  const TrendAnalysisScreen({super.key});

  @override
  ConsumerState<TrendAnalysisScreen> createState() => _TrendAnalysisScreenState();
}

class _TrendAnalysisScreenState extends ConsumerState<TrendAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 3; // 3, 6 months

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Spending Trends'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.calendar_today),
            onSelected: (period) => setState(() => _selectedPeriod = period),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    if (_selectedPeriod == 3)
                      const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('Last 3 Months'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 6,
                child: Row(
                  children: [
                    if (_selectedPeriod == 6)
                      const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('Last 6 Months'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(months: _selectedPeriod),
          _CategoriesTab(months: _selectedPeriod),
        ],
      ),
    );
  }
}

/// Overview tab showing total spending trend
class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({required this.months});

  final int months;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allTx = ref.watch(allTransactionsProvider);

    return allTx.when(
      data: (transactions) {
        final monthlyData = _calculateMonthlySpending(transactions, months);
        final avgSpending = monthlyData.isEmpty
            ? 0.0
            : monthlyData.values.reduce((a, b) => a + b) / monthlyData.length;
        final trend = _calculateTrend(monthlyData);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary stats
              _SummaryCard(
                monthlyData: monthlyData,
                avgSpending: avgSpending,
                trend: trend,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Spending chart
              Text('Monthly Spending', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              Container(
                height: 250,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _MonthlyBarChart(data: monthlyData),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Insights
              Text('Insights', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              ..._generateInsights(monthlyData, trend).map((insight) =>
                _InsightCard(
                  icon: insight.icon,
                  title: insight.title,
                  description: insight.description,
                  color: insight.color,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading trends')),
    );
  }

  Map<String, double> _calculateMonthlySpending(
    List<Transaction> transactions,
    int months,
  ) {
    final now = DateTime.now();
    final Map<String, double> monthly = {};
    final formatter = DateFormat('MMM');

    for (int i = months - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      monthly[formatter.format(date)] = 0;
    }

    for (final tx in transactions) {
      if (tx.type == TransactionType.debit) {
        final monthAgo = now.month - tx.timestamp.month +
            (now.year - tx.timestamp.year) * 12;
        if (monthAgo >= 0 && monthAgo < months) {
          final key = formatter.format(tx.timestamp);
          monthly[key] = (monthly[key] ?? 0) + tx.amount.rupees;
        }
      }
    }

    return monthly;
  }

  double _calculateTrend(Map<String, double> data) {
    if (data.length < 2) return 0;
    final values = data.values.toList();
    final recent = values.last;
    final previous = values[values.length - 2];
    if (previous == 0) return 0;
    return ((recent - previous) / previous) * 100;
  }

  List<_Insight> _generateInsights(Map<String, double> data, double trend) {
    final insights = <_Insight>[];

    if (trend > 10) {
      insights.add(_Insight(
        icon: Icons.trending_up,
        title: 'Spending Increased',
        description: 'Your spending is up ${trend.abs().toStringAsFixed(1)}% from last month. Consider reviewing your expenses.',
        color: AppColors.danger,
      ));
    } else if (trend < -10) {
      insights.add(_Insight(
        icon: Icons.trending_down,
        title: 'Great Progress!',
        description: 'You reduced spending by ${trend.abs().toStringAsFixed(1)}% this month. Keep it up!',
        color: AppColors.accent,
      ));
    } else {
      insights.add(_Insight(
        icon: Icons.remove,
        title: 'Stable Spending',
        description: 'Your spending is consistent with last month.',
        color: AppColors.primary,
      ));
    }

    final values = data.values.toList();
    if (values.isNotEmpty) {
      final highest = values.reduce((a, b) => a > b ? a : b);
      final highestMonth = data.entries.firstWhere((e) => e.value == highest).key;
      insights.add(_Insight(
        icon: Icons.calendar_month,
        title: 'Peak Month',
        description: '$highestMonth had your highest spending at ₹${_formatAmount(highest)}.',
        color: AppColors.warning,
      ));
    }

    return insights;
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat.compact(locale: 'en_IN');
    return formatter.format(amount);
  }
}

class _Insight {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  _Insight({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

/// Monthly summary card
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.monthlyData,
    required this.avgSpending,
    required this.trend,
  });

  final Map<String, double> monthlyData;
  final double avgSpending;
  final double trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final total = monthlyData.values.fold(0.0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.8),
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spent (${monthlyData.length} months)',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            formatter.format(total),
            style: AppTypography.displayLarge.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _StatItem(
                label: 'Monthly Avg',
                value: formatter.format(avgSpending),
              ),
              const SizedBox(width: AppSpacing.xl),
              _StatItem(
                label: 'Trend',
                value: '${trend >= 0 ? '+' : ''}${trend.toStringAsFixed(1)}%',
                valueColor: trend > 0 ? AppColors.danger : AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: AppTypography.h3.copyWith(
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Bar chart for monthly spending
class _MonthlyBarChart extends StatelessWidget {
  const _MonthlyBarChart({required this.data});

  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxY = data.values.isEmpty
        ? 100.0
        : data.values.reduce((a, b) => a > b ? a : b) * 1.2;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final month = data.keys.elementAt(group.x);
              return BarTooltipItem(
                '₹${NumberFormat.compact().format(rod.toY)}',
                AppTypography.bodyMedium.copyWith(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final months = data.keys.toList();
                if (value >= 0 && value < months.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      months[value.toInt()],
                      style: AppTypography.caption.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${NumberFormat.compact().format(value)}',
                  style: AppTypography.caption.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: AppColors.primary,
                width: 24,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Categories tab
class _CategoriesTab extends ConsumerWidget {
  const _CategoriesTab({required this.months});

  final int months;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allTx = ref.watch(allTransactionsProvider);

    return allTx.when(
      data: (transactions) {
        final categoryData = _calculateCategorySpending(transactions, months);
        final sortedCategories = categoryData.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final total = categoryData.values.fold(0.0, (a, b) => a + b);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pie chart
              Container(
                height: 220,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _CategoryPieChart(data: categoryData),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category breakdown
              Text('Category Breakdown', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              ...sortedCategories.map((entry) {
                final percentage = total > 0 ? (entry.value / total) * 100 : 0;
                return _CategoryRow(
                  category: entry.key,
                  amount: entry.value,
                  percentage: percentage,
                  total: total,
                );
              }),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading categories')),
    );
  }

  Map<TransactionCategory, double> _calculateCategorySpending(
    List<Transaction> transactions,
    int months,
  ) {
    final now = DateTime.now();
    final Map<TransactionCategory, double> categories = {};

    for (final tx in transactions) {
      if (tx.type == TransactionType.debit) {
        final monthAgo = now.month - tx.timestamp.month +
            (now.year - tx.timestamp.year) * 12;
        if (monthAgo >= 0 && monthAgo < months) {
          categories[tx.category] =
              (categories[tx.category] ?? 0) + tx.amount.rupees;
        }
      }
    }

    return categories;
  }
}

/// Category pie chart
class _CategoryPieChart extends StatelessWidget {
  const _CategoryPieChart({required this.data});

  final Map<TransactionCategory, double> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No spending data'));
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: data.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value,
            color: AppColors.getCategoryColor(entry.key.name),
            radius: 50,
            title: '',
            badgeWidget: null,
          );
        }).toList(),
      ),
    );
  }
}

/// Category row with progress
class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.total,
  });

  final TransactionCategory category;
  final double amount;
  final double percentage;
  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final color = AppColors.getCategoryColor(category.name);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _getCategoryEmoji(category),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name[0].toUpperCase() + category.name.substring(1),
                      style: AppTypography.bodyLarge.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}% of total',
                      style: AppTypography.caption.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatter.format(amount),
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 4,
              color: color,
              backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryEmoji(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return '🍔';
      case TransactionCategory.transport:
        return '🚗';
      case TransactionCategory.entertainment:
        return '🎮';
      case TransactionCategory.shopping:
        return '🛍️';
      case TransactionCategory.bills:
        return '📱';
      case TransactionCategory.health:
        return '💊';
      case TransactionCategory.education:
        return '📚';
      case TransactionCategory.groceries:
        return '🛒';
      case TransactionCategory.travel:
        return '✈️';
      case TransactionCategory.investment:
        return '📈';
      case TransactionCategory.salary:
        return '💰';
      case TransactionCategory.gift:
        return '🎁';
      case TransactionCategory.other:
      default:
        return '💳';
    }
  }
}

/// Insight card widget
class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
