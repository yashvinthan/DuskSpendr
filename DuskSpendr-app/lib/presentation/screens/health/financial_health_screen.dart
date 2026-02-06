import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../domain/entities/education.dart';
import '../../common/widgets/gamification/score_gauge.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../../providers/education_provider.dart';

/// SS-092: Financial Health Score Screen
/// 0-100 overall, sub-scores, trends, peer comparison
class FinancialHealthScreen extends ConsumerWidget {
  const FinancialHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthScoreAsync = ref.watch(financialHealthScoreProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppTopBar(title: 'Financial Health'),
      body: healthScoreAsync.when(
        data: (score) {
          if (score == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No health score data available',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Overall Score
                Card(
                  color: AppColors.darkSurface,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        ScoreGauge(
                          score: score.overall,
                          maxScore: 100,
                          label: score.rating,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              score.trend == HealthTrend.improving
                                  ? Icons.trending_up
                                  : score.trend == HealthTrend.declining
                                      ? Icons.trending_down
                                      : Icons.trending_flat,
                              color: score.trend == HealthTrend.improving
                                  ? AppColors.accent
                                  : score.trend == HealthTrend.declining
                                      ? AppColors.error
                                      : AppColors.textMuted,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              score.trend.name.toUpperCase(),
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Sub-scores
                Text(
                  'Health Breakdown',
                  style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                _SubScoreCard(
                  label: 'Budgeting',
                  score: score.budgetingScore,
                  weight: '30%',
                  color: AppColors.primary,
                ),
                _SubScoreCard(
                  label: 'Savings',
                  score: score.savingsScore,
                  weight: '25%',
                  color: AppColors.accent,
                ),
                _SubScoreCard(
                  label: 'Spending Discipline',
                  score: score.spendingDiscipline,
                  weight: '25%',
                  color: AppColors.info,
                ),
                _SubScoreCard(
                  label: 'Financial Literacy',
                  score: score.financialLiteracy,
                  weight: '20%',
                  color: AppColors.warning,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Improvement Suggestions
                if (score.improvements.isNotEmpty) ...[
                  Text(
                    'Improvement Suggestions',
                    style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...score.improvements.map(
                    (improvement) => Card(
                      color: AppColors.darkSurface,
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        leading: Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.warning,
                        ),
                        title: Text(
                          improvement,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Error loading health score',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubScoreCard extends StatelessWidget {
  final String label;
  final int score;
  final String weight;
  final Color color;

  const _SubScoreCard({
    required this.label,
    required this.score,
    required this.weight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = score / 100.0;
    return Card(
      color: AppColors.darkSurface,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  weight,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 8,
                      color: color,
                      backgroundColor: AppColors.darkCard,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '$score/100',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
