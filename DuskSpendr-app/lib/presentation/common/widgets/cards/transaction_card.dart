import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import 'glass_card.dart';

/// Transaction card for displaying a single transaction item.
/// Enhanced with WCAG 2.1 AA accessibility support.
class TransactionCard extends StatelessWidget {
  final String merchantName;
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;
  final double amount;
  final bool isExpense;
  final DateTime dateTime;
  final String? paymentMethod;
  final double? confidence;
  final VoidCallback? onTap;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const TransactionCard({
    super.key,
    required this.merchantName,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
    required this.amount,
    required this.isExpense,
    required this.dateTime,
    this.paymentMethod,
    this.confidence,
    this.onTap,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  String get _formattedAmount {
    final sign = isExpense ? '-' : '+';
    return '$sign₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }

  String get _formattedTime {
    final now = DateTime.now();
    final isToday = dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year;
    final isYesterday = dateTime.day == now.day - 1 &&
        dateTime.month == now.month &&
        dateTime.year == now.year;

    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (isToday) return 'Today $time';
    if (isYesterday) return 'Yesterday';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  /// Semantic label for screen readers
  String get _semanticLabel {
    final type = isExpense ? 'Expense' : 'Income';
    final amountPart = '₹${amount.toStringAsFixed(2)}';
    final paymentPart = paymentMethod != null ? ' via $paymentMethod' : '';
    return '$type of $amountPart at $merchantName. Category: $category$paymentPart. $_formattedTime. Double tap to view details.';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: _semanticLabel,
      excludeSemantics: true,
      child: Dismissible(
        key: Key(merchantName + dateTime.toIso8601String()),
        direction: (onSwipeLeft != null || onSwipeRight != null)
            ? DismissDirection.horizontal
            : DismissDirection.none,
        background: _buildSwipeBackground(true),
        secondaryBackground: _buildSwipeBackground(false),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            HapticFeedback.lightImpact();
            onSwipeRight?.call();
          } else {
            HapticFeedback.lightImpact();
            onSwipeLeft?.call();
          }
          return false;
        },
        child: AppCard(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap?.call();
          },
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchantName,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          category,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (paymentMethod != null) ...[
                          Text(
                            ' via $paymentMethod',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                        Text(
                          ' • $_formattedTime',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    if (confidence != null && confidence! < 0.9) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: AppColors.dusk500.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'AI: ${(confidence! * 100).toInt()}% confident',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: AppColors.dusk500.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Amount
              Text(
                _formattedAmount,
                style: AppTypography.amountSmall.copyWith(
                  color: isExpense ? AppColors.error : AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isLeft) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      color: isLeft ? AppColors.success : AppColors.dusk500,
      child: Icon(
        isLeft ? Icons.edit : Icons.category,
        color: AppColors.textPrimary,
      ),
    );
  }
}
