import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../domain/entities/investing/portfolio_summary.dart';
import '../../../common/widgets/cards/glass_card.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final PortfolioSummary summary;

  const PortfolioSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final isProfit = summary.returns.rupees >= 0;

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
                    summary.totalValue.formatted,
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
                  color: (isProfit ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(
                      isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: isProfit ? AppColors.success : AppColors.error,
                    ),
                    Text(
                      '${isProfit ? '+' : ''}${summary.returnsPercentage.toStringAsFixed(2)}%',
                      style: AppTypography.labelLarge.copyWith(
                        color: isProfit ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Invested',
                  value: summary.invested.compact,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Returns',
                  value:
                      '${isProfit ? '+' : ''}${summary.returns.compact}',
                  valueColor:
                      isProfit ? AppColors.success : AppColors.error,
                ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
