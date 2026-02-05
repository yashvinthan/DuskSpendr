import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import 'glass_card.dart';

enum BudgetStatus { onTrack, warning, exceeded }

/// Budget card showing spending progress for a category or overall.
class BudgetCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final double spent;
  final double limit;
  final String? statusMessage;
  final VoidCallback? onTap;
  final bool isOverall;

  const BudgetCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.spent,
    required this.limit,
    this.statusMessage,
    this.onTap,
    this.isOverall = false,
  });

  double get _percentage => limit > 0 ? (spent / limit * 100).clamp(0, 100) : 0;
  double get _actualPercentage => limit > 0 ? spent / limit * 100 : 0;

  BudgetStatus get _status {
    if (_actualPercentage >= 100) return BudgetStatus.exceeded;
    if (_actualPercentage >= 80) return BudgetStatus.warning;
    return BudgetStatus.onTrack;
  }

  Color get _progressColor {
    switch (_status) {
      case BudgetStatus.exceeded:
        return AppColors.error;
      case BudgetStatus.warning:
        return AppColors.warning;
      case BudgetStatus.onTrack:
        return color;
    }
  }

  String get _statusText {
    if (statusMessage != null) return statusMessage!;
    switch (_status) {
      case BudgetStatus.exceeded:
        return '❌ Over by ₹${(spent - limit).toStringAsFixed(0)}';
      case BudgetStatus.warning:
        return '⚠️ On track to exceed!';
      case BudgetStatus.onTrack:
        return '✓ Looking good!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = (limit - spent).clamp(0, double.infinity);

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 22),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isOverall) ...[
                        const SizedBox(height: 2),
                        Text(
                          '₹${remaining.toStringAsFixed(0)} left',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_actualPercentage.toStringAsFixed(0)}%',
                      style: AppTypography.amountSmall.copyWith(
                        color: _progressColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${spent.toStringAsFixed(0)} / ₹${limit.toStringAsFixed(0)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Container(
                        height: 8,
                        width: double.infinity,
                        color: AppColors.darkSurface,
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            height: 8,
                            width: constraints.maxWidth * (_percentage / 100),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _progressColor,
                                  _progressColor.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Status message
            Text(
              _statusText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: _status == BudgetStatus.onTrack
                    ? AppColors.success
                    : (_status == BudgetStatus.warning
                        ? AppColors.warning
                        : AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
