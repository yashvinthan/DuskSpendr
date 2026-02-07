import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../domain/entities/investing/stock_holding.dart';

class StockHoldingCard extends StatelessWidget {
  final StockHolding holding;

  const StockHoldingCard({super.key, required this.holding});

  @override
  Widget build(BuildContext context) {
    final isProfit = holding.returns.paisa >= 0;

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
                    holding.symbol[0],
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
                      holding.symbol,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${holding.quantity} shares • Avg ${holding.buyPrice.compact}',
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
                    holding.currentPrice.formatted,
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
                        '${holding.returnsPercentage.toStringAsFixed(1)}%',
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
                'Current: ${holding.totalValue.formatted}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${isProfit ? '+' : ''}${holding.returns.formatted}',
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
