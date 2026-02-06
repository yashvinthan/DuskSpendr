import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/budget/budget_service.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/transaction_provider.dart';
import '../../common/widgets/navigation/top_app_bar.dart';

/// SS-063: Pocket Money Prediction Screen
/// 3-month analysis, trend detection, optimal amount suggestions
class WeeklyAllowanceScreen extends ConsumerStatefulWidget {
  const WeeklyAllowanceScreen({super.key});

  @override
  ConsumerState<WeeklyAllowanceScreen> createState() =>
      _WeeklyAllowanceScreenState();
}

class _WeeklyAllowanceScreenState extends ConsumerState<WeeklyAllowanceScreen> {
  PocketMoneyRecommendation? _recommendation;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _analyzePocketMoney());
  }

  Future<void> _analyzePocketMoney() async {
    setState(() => _isAnalyzing = true);
    try {
      final transactions = await ref.read(allTransactionsProvider.future);
      final last90Days = DateTime.now().subtract(const Duration(days: 90));
      final recentTx = transactions
          .where((t) => t.timestamp.isAfter(last90Days))
          .where((t) => t.type == TransactionType.debit)
          .toList();

      final summaries = recentTx.map((t) => TransactionSummary(
            id: t.id,
            amountPaisa: t.amount.paisa,
            date: t.timestamp,
            category: t.category.name,
            merchantName: t.merchantName,
          )).toList();

      final budgetService = BudgetService();
      const currentPocketMoney = 450000; // ₹4,500 - get from user settings
      final recommendation = budgetService.analyzePocketMoney(
        last90DaysTransactions: summaries,
        currentPocketMoney: currentPocketMoney,
      );

      if (mounted) {
        setState(() {
          _recommendation = recommendation;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
      final weeklySpending = ref.watch(weeklySpendingProvider);
      const weeklyBudget = 450000; // ₹4,500

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppTopBar(title: 'Pocket Money'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Week Status
            Card(
              color: AppColors.darkSurface,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Week',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    weeklySpending.when(
                      data: (spent) {
                        final spentPaisa = spent.paisa;
                        final percent = weeklyBudget > 0
                            ? (spentPaisa / weeklyBudget).clamp(0.0, 1.0)
                            : 0.0;
                        final remaining = weeklyBudget - spentPaisa;
                        final daysLeft = 7 - DateTime.now().weekday + 1;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${(spentPaisa / 100).toStringAsFixed(0)} of ₹${(weeklyBudget / 100).toStringAsFixed(0)} spent',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: percent,
                                minHeight: 8,
                                color: percent > 0.8
                                    ? AppColors.error
                                    : AppColors.accent,
                                backgroundColor: AppColors.darkCard,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '₹${(remaining / 100).toStringAsFixed(0)} left • $daysLeft days remaining',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Error loading data'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // SS-063: Pocket Money Prediction
            Card(
              color: AppColors.darkSurface,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AI Recommendation',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (_isAnalyzing)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            onPressed: _analyzePocketMoney,
                            color: AppColors.textSecondary,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_recommendation != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Suggested Amount',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '₹${(_recommendation!.suggestedAmount / 100).toStringAsFixed(0)}',
                                  style: AppTypography.h2.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Confidence',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '${(_recommendation!.confidence * 100).toStringAsFixed(0)}%',
                                style: AppTypography.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (_recommendation!.trend == SpendingTrend.increasing)
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: AppColors.warning,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Spending trend: Increasing',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_recommendation!.trend == SpendingTrend.decreasing)
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.trending_down,
                                color: AppColors.accent,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Spending trend: Decreasing',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_recommendation!.insights.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Insights',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ..._recommendation!.insights.map(
                          (insight) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    insight,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ] else if (!_isAnalyzing)
                      Center(
                        child: TextButton(
                          onPressed: _analyzePocketMoney,
                          child: const Text('Analyze Spending'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Leftover Options
            Text(
              'Leftover Options',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const _OptionTile(label: 'Roll over to next week', selected: true),
            const _OptionTile(label: 'Transfer to savings'),
            const _OptionTile(label: 'Add to fun money'),
            const _OptionTile(label: 'Reset each week (strict)'),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.gold400 : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.gold400 : AppColors.textMuted,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}

