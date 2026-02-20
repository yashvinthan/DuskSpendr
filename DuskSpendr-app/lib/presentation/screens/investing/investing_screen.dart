import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import 'views/portfolio_dashboard_view.dart';
import 'views/stocks_portfolio_view.dart';

/// Investing Hub main screen - Portfolio overview
class InvestingScreen extends StatefulWidget {
  const InvestingScreen({super.key});

  @override
  State<InvestingScreen> createState() => _InvestingScreenState();
}

class _InvestingScreenState extends State<InvestingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
              children: const [
                PortfolioDashboardView(),
                StocksPortfolioView(),
                _MutualFundsTab(),
                _FDsTab(),
                _GoalsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for other tabs until their views are fully implemented

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
