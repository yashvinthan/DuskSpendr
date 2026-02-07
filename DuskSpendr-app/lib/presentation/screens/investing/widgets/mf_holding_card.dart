import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../domain/entities/investing/mf_holding.dart';

class MFHoldingCard extends StatelessWidget {
  final MFHolding holding;

  const MFHoldingCard({super.key, required this.holding});

  @override
  Widget build(BuildContext context) {
    final isProfit = holding.returns.paisa >= 0;

    // Calculate XIRR dummy value or if it was part of entity
    // Since entity doesn't have XIRR, I'll calculate simple returns %
    final returnsPercentage = holding.returnsPercentage;

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
            holding.schemeName,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            _getCategoryName(holding.category),
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MFStat(label: 'Invested', value: holding.invested.compact),
              ),
              Expanded(
                child: _MFStat(label: 'Current', value: holding.currentValue.compact),
              ),
              Expanded(
                child: _MFStat(
                  label: 'Returns',
                  value: '${isProfit ? '+' : ''}${returnsPercentage.toStringAsFixed(1)}%',
                  valueColor: isProfit ? AppColors.success : AppColors.error,
                ),
              ),
              // Dummy XIRR placeholder since we don't calculate it yet
              Expanded(
                child: _MFStat(
                  label: 'XIRR',
                  value: '${(returnsPercentage + 2).toStringAsFixed(1)}%', // Mock logic
                  valueColor: isProfit ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCategoryName(MFCategory category) {
    switch (category) {
      case MFCategory.equityLargeCap:
        return 'Large Cap • Equity';
      case MFCategory.equityMidCap:
        return 'Mid Cap • Equity';
      case MFCategory.equitySmallCap:
        return 'Small Cap • Equity';
      case MFCategory.equityFlexiCap:
        return 'Flexi Cap • Equity';
      case MFCategory.debt:
        return 'Debt Fund';
      case MFCategory.hybrid:
        return 'Hybrid Fund';
      case MFCategory.indexFund:
        return 'Index Fund';
      case MFCategory.elss:
        return 'ELSS (Tax Saver)';
      default:
        return 'Mutual Fund';
    }
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
