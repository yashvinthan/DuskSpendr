import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/charts/donut_chart.dart';
import '../../common/widgets/charts/line_chart.dart';
import '../../common/widgets/cards/glass_card.dart';

/// Analytics screen with spending insights
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Analytics',
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_today, color: AppColors.textPrimary),
            onSelected: (value) => setState(() => _selectedPeriod = value),
            itemBuilder: (context) => [
              'This Week',
              'This Month',
              'Last 3 Months',
              'This Year',
            ].map((period) => PopupMenuItem(
                  value: period,
                  child: Text(period),
                )).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary cards
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Total Spent',
                    value: '₹32,450',
                    change: '+12%',
                    isPositive: false,
                    icon: Icons.arrow_upward,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SummaryCard(
                    label: 'Saved',
                    value: '₹8,500',
                    change: '+25%',
                    isPositive: true,
                    icon: Icons.savings,
                  ),
                ),
              ],
            ),
          ),
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.dusk500,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTypography.labelLarge,
              tabs: const [
                Tab(text: 'Spending'),
                Tab(text: 'Income'),
                Tab(text: 'Trends'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _SpendingTab(),
                _IncomeTab(),
                _TrendsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isPositive ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: AppTypography.caption.copyWith(
                  color: isPositive ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingTab extends StatelessWidget {
  const _SpendingTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        // Category breakdown
        Text(
          'By Category',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Center(
          child: DonutChart(
            segments: [
              DonutSegment(value: 35, color: AppColors.sunset500, label: 'Food'),
              DonutSegment(value: 25, color: AppColors.dusk500, label: 'Shopping'),
              DonutSegment(value: 20, color: AppColors.info, label: 'Transport'),
              DonutSegment(value: 12, color: AppColors.success, label: 'Bills'),
              DonutSegment(value: 8, color: AppColors.warning, label: 'Other'),
            ],
            size: 180,
            centerLabel: '₹32.4K',
            centerSubLabel: 'Total',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Category list
        _CategoryRow(
          icon: Icons.restaurant,
          name: 'Food & Dining',
          amount: 11350,
          percentage: 35,
          color: AppColors.sunset500,
        ),
        _CategoryRow(
          icon: Icons.shopping_bag,
          name: 'Shopping',
          amount: 8100,
          percentage: 25,
          color: AppColors.dusk500,
        ),
        _CategoryRow(
          icon: Icons.directions_car,
          name: 'Transport',
          amount: 6490,
          percentage: 20,
          color: AppColors.info,
        ),
        _CategoryRow(
          icon: Icons.receipt,
          name: 'Bills & Utilities',
          amount: 3890,
          percentage: 12,
          color: AppColors.success,
        ),
        _CategoryRow(
          icon: Icons.more_horiz,
          name: 'Other',
          amount: 2620,
          percentage: 8,
          color: AppColors.warning,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final IconData icon;
  final String name;
  final double amount;
  final int percentage;
  final Color color;

  const _CategoryRow({
    required this.icon,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppColors.darkSurface,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeTab extends StatelessWidget {
  const _IncomeTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        GlassCard(
          child: Column(
            children: [
              Text(
                'Total Income',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹45,000',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '+₹5,000 from last month',
                style: AppTypography.caption.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Income Sources',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _IncomeSource(
          icon: Icons.work,
          name: 'Salary',
          amount: 40000,
          color: AppColors.success,
        ),
        _IncomeSource(
          icon: Icons.card_giftcard,
          name: 'Pocket Money',
          amount: 5000,
          color: AppColors.dusk500,
        ),
      ],
    );
  }
}

class _IncomeSource extends StatelessWidget {
  final IconData icon;
  final String name;
  final double amount;
  final Color color;

  const _IncomeSource({
    required this.icon,
    required this.name,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendsTab extends StatelessWidget {
  const _TrendsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        Text(
          'Spending Over Time',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 200,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: const SpendingLineChart(
            dataPoints: [28, 32, 25, 35, 30, 38, 32, 28, 35, 40, 33, 32],
            height: 180,
            showGradient: true,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Insights',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _InsightCard(
          icon: Icons.trending_up,
          title: 'Spending Increased',
          description: 'Food expenses up 15% this month compared to last',
          color: AppColors.warning,
        ),
        _InsightCard(
          icon: Icons.savings,
          title: 'Great Savings!',
          description: 'You saved 25% more than your target this month',
          color: AppColors.success,
        ),
        _InsightCard(
          icon: Icons.lightbulb,
          title: 'Tip',
          description: 'Consider meal prepping to reduce food delivery costs',
          color: AppColors.dusk500,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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
