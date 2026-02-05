import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../providers/data_providers.dart';
import 'budget_create_screen.dart';
import 'budget_edit_screen.dart';
import 'budget_alerts_screen.dart';
import 'weekly_allowance_screen.dart';

class BudgetOverviewScreen extends ConsumerWidget {
  const BudgetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(budgetsProvider);

    return Container(
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
              Row(
                children: [
                  Expanded(
                    child: Text('My Budget',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.textPrimary,
                        )),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BudgetCreateScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle,
                        color: AppColors.gold400),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BudgetAlertsScreen(),
                          ),
                        );
                      },
                      child: const Text('Alerts'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WeeklyAllowanceScreen(),
                          ),
                        );
                      },
                      child: const Text('Weekly Allowance'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: asyncItems.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'No budgets yet',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final budget = items[index];
                        final spent = budget.spentPaisa / 100;
                        final limit = budget.limitPaisa / 100;
                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.darkCard,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(budget.name,
                                        style: AppTypography.h3.copyWith(
                                          color: AppColors.textPrimary,
                                        )),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              BudgetEditScreen(budget: budget),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                '₹${spent.toStringAsFixed(0)} / ₹${limit.toStringAsFixed(0)}',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: budget.progress.clamp(0, 1),
                                  minHeight: 8,
                                  color: budget.progress > 1
                                      ? AppColors.error
                                      : AppColors.sunset500,
                                  backgroundColor:
                                      AppColors.dusk700.withValues(alpha: 0.4),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                budget.isExceeded
                                    ? 'Over budget'
                                    : budget.isWarning
                                        ? 'Approaching limit'
                                        : 'On track',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: budget.isExceeded
                                      ? AppColors.error
                                      : budget.isWarning
                                          ? AppColors.warning
                                          : AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, _) => Center(
                    child: Text(
                      err.toString(),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

