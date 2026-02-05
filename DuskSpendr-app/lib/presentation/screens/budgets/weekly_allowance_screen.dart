import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';

class WeeklyAllowanceScreen extends StatelessWidget {
  const WeeklyAllowanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientNight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                ),
                Text('Weekly Allowance',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('This Week',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          )),
                      const SizedBox(height: AppSpacing.sm),
                      Text('₹3,200 of ₹4,500 spent',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                          )),
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: 0.71,
                          minHeight: 8,
                          color: AppColors.sunset500,
                          backgroundColor:
                              AppColors.dusk700.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('₹1,300 left • 4 days remaining',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Leftover Options',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: AppSpacing.sm),
                _OptionTile(label: 'Roll over to next week', selected: true),
                _OptionTile(label: 'Transfer to savings'),
                _OptionTile(label: 'Add to fun money'),
                _OptionTile(label: 'Reset each week (strict)'),
              ],
            ),
          ),
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

