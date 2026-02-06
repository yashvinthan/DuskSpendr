import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/cards/glass_card.dart';
import '../../common/widgets/charts/line_chart.dart';

/// Investing Hub main screen - Portfolio overview
class InvestingScreen extends StatefulWidget {
  const InvestingScreen({super.key});

  @override
  State<InvestingScreen> createState() => _InvestingScreenState();
}

class _InvestingScreenState extends State<InvestingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeframe = '1M';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        title: 'Investments',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Portfolio summary
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _PortfolioSummaryCard(),
          ),
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.dusk500,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTypography.labelLarge,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Stocks'),
                Tab(text: 'Mutual Funds'),
                Tab(text: 'FDs'),
                Tab(text: 'Goals'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(
                  selectedTimeframe: _selectedTimeframe,
                  onTimeframeChanged: (tf) =>
                      setState(() => _selectedTimeframe = tf),
                ),
                const _StocksTab(),
                const _MutualFundsTab(),
                const _FDsTab(),
                const _GoalsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Portfolio',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹2,45,890',
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      size: 14,
                      color: AppColors.success,
                    ),
                    Text(
                      '+12.5%',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: [
              _StatItem(
                label: 'Invested',
                value: '₹2,18,500',
              ),
              _StatItem(
                label: 'Returns',
                value: '+₹27,390',
                valueColor: AppColors.success,
              ),
              _StatItem(
                label: 'Today',
                value: '+₹1,240',
                valueColor: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final String selectedTimeframe;
  final ValueChanged<String> onTimeframeChanged;

  const _OverviewTab({
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        // Timeframe selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1D', '1W', '1M', '3M', '1Y', 'ALL'].map((tf) {
            final isSelected = tf == selectedTimeframe;
            return GestureDetector(
              onTap: () => onTimeframeChanged(tf),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.dusk500 : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  tf,
                  style: AppTypography.labelMedium.copyWith(
                    color:
                        isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        // Chart placeholder
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: SpendingLineChart(
            points: [
              LineChartPoint(date: DateTime.now().subtract(const Duration(days: 8)), value: 100),
              LineChartPoint(date: DateTime.now().subtract(const Duration(days: 7)), value: 120),
              LineChartPoint(date: DateTime.now().subtract(const Duration(days: 6)), value: 115),
              LineChartPoint(date: DateTime.now().subtract(const Duration(days: 5)), value: 140),
              LineChartPoint(date: DateTime.now().subtract(const Duration(days: 4)), value: 135),
              LineChartPoint(date: DateTime.now().subtract(const Duration(days: 3)), value: 160),
              LineChartPoint(date: DateTime.now().subtract(const Duration(days: 2)), value: 180),
              LineChartPoint(date: DateTime.now().subtract(const Duration(days: 1)), value: 175),
              LineChartPoint(date: DateTime.now(), value: 200),
            ],
            height: 200,
            showGradient: true,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Allocation
        Text(
          'Asset Allocation',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const _AllocationRow(label: 'Stocks', value: 45, color: AppColors.dusk500),
        const _AllocationRow(label: 'Mutual Funds', value: 35, color: AppColors.sunset500),
        const _AllocationRow(label: 'Fixed Deposits', value: 15, color: AppColors.success),
        const _AllocationRow(label: 'Gold', value: 5, color: AppColors.warning),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _AllocationRow extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _AllocationRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
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
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '$value%',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StocksTab extends StatelessWidget {
  const _StocksTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: const [
        _StockCard(
          name: 'Reliance Industries',
          symbol: 'RELIANCE',
          quantity: 10,
          avgPrice: 2450,
          currentPrice: 2580,
          change: 5.3,
        ),
        _StockCard(
          name: 'HDFC Bank',
          symbol: 'HDFCBANK',
          quantity: 15,
          avgPrice: 1620,
          currentPrice: 1585,
          change: -2.2,
        ),
        _StockCard(
          name: 'Infosys',
          symbol: 'INFY',
          quantity: 20,
          avgPrice: 1450,
          currentPrice: 1520,
          change: 4.8,
        ),
      ],
    );
  }
}

class _StockCard extends StatelessWidget {
  final String name;
  final String symbol;
  final int quantity;
  final double avgPrice;
  final double currentPrice;
  final double change;

  const _StockCard({
    required this.name,
    required this.symbol,
    required this.quantity,
    required this.avgPrice,
    required this.currentPrice,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = change >= 0;
    final totalValue = quantity * currentPrice;
    final invested = quantity * avgPrice;
    final returns = totalValue - invested;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.dusk500.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(
                  child: Text(
                    symbol[0],
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.dusk500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '$quantity shares • Avg ₹${avgPrice.toStringAsFixed(0)}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${currentPrice.toStringAsFixed(0)}',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isProfit ? AppColors.success : AppColors.error,
                      ),
                      Text(
                        '${change.abs().toStringAsFixed(1)}%',
                        style: AppTypography.caption.copyWith(
                          color: isProfit ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.darkSurface, height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current: ₹${totalValue.toStringAsFixed(0)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${isProfit ? '+' : ''}₹${returns.toStringAsFixed(0)}',
                style: AppTypography.bodySmall.copyWith(
                  color: isProfit ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MutualFundsTab extends StatelessWidget {
  const _MutualFundsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: const [
        _MFCard(
          name: 'Axis Bluechip Fund',
          category: 'Large Cap • Equity',
          invested: 50000,
          currentValue: 58500,
          returns: 17.0,
          xirr: 22.5,
        ),
        _MFCard(
          name: 'Parag Parikh Flexi Cap',
          category: 'Flexi Cap • Equity',
          invested: 25000,
          currentValue: 28200,
          returns: 12.8,
          xirr: 18.2,
        ),
        _MFCard(
          name: 'SBI Small Cap Fund',
          category: 'Small Cap • Equity',
          invested: 15000,
          currentValue: 13800,
          returns: -8.0,
          xirr: -12.5,
        ),
      ],
    );
  }
}

class _MFCard extends StatelessWidget {
  final String name;
  final String category;
  final double invested;
  final double currentValue;
  final double returns;
  final double xirr;

  const _MFCard({
    required this.name,
    required this.category,
    required this.invested,
    required this.currentValue,
    required this.returns,
    required this.xirr,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = returns >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            category,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MFStat(label: 'Invested', value: '₹${(invested/1000).toStringAsFixed(1)}K'),
              ),
              Expanded(
                child: _MFStat(label: 'Current', value: '₹${(currentValue/1000).toStringAsFixed(1)}K'),
              ),
              Expanded(
                child: _MFStat(
                  label: 'Returns',
                  value: '${isProfit ? '+' : ''}${returns.toStringAsFixed(1)}%',
                  valueColor: isProfit ? AppColors.success : AppColors.error,
                ),
              ),
              Expanded(
                child: _MFStat(
                  label: 'XIRR',
                  value: '${xirr >= 0 ? '+' : ''}${xirr.toStringAsFixed(1)}%',
                  valueColor: xirr >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MFStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MFStat({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FDsTab extends StatelessWidget {
  const _FDsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: const [
        _FDCard(
          bank: 'HDFC Bank',
          principal: 100000,
          rate: 7.25,
          maturityAmount: 107250,
          maturityDate: 'Dec 15, 2024',
        ),
        _FDCard(
          bank: 'SBI',
          principal: 50000,
          rate: 6.80,
          maturityAmount: 53400,
          maturityDate: 'Mar 20, 2025',
        ),
      ],
    );
  }
}

class _FDCard extends StatelessWidget {
  final String bank;
  final double principal;
  final double rate;
  final double maturityAmount;
  final String maturityDate;

  const _FDCard({
    required this.bank,
    required this.principal,
    required this.rate,
    required this.maturityAmount,
    required this.maturityDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '$rate% p.a.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${(maturityAmount / 1000).toStringAsFixed(1)}K',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Maturity',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.darkSurface, height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Principal: ₹${(principal / 1000).toStringAsFixed(0)}K',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Matures: $maturityDate',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalsTab extends StatelessWidget {
  const _GoalsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: const [
        _GoalCard(
          name: 'Emergency Fund',
          icon: Icons.shield,
          target: 100000,
          current: 65000,
          monthlyContribution: 5000,
        ),
        _GoalCard(
          name: 'New Laptop',
          icon: Icons.laptop,
          target: 80000,
          current: 32000,
          monthlyContribution: 8000,
        ),
        _GoalCard(
          name: 'Vacation Fund',
          icon: Icons.flight,
          target: 50000,
          current: 12500,
          monthlyContribution: 3000,
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final double target;
  final double current;
  final double monthlyContribution;

  const _GoalCard({
    required this.name,
    required this.icon,
    required this.target,
    required this.current,
    required this.monthlyContribution,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0, 1).toDouble();
    final remaining = target - current;
    final monthsLeft = (remaining / monthlyContribution).ceil();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.dusk500.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: AppColors.dusk500),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '₹${(current / 1000).toStringAsFixed(0)}K of ₹${(target / 1000).toStringAsFixed(0)}K',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.dusk500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.darkSurface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.dusk500),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${monthlyContribution.toStringAsFixed(0)}/month',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                monthsLeft > 0 ? '$monthsLeft months to go' : 'Goal reached!',
                style: AppTypography.caption.copyWith(
                  color: monthsLeft > 0 ? AppColors.textMuted : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
