import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../common/widgets/gamification/score_gauge.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../../providers/gamification_provider.dart';

/// SS-083: Student Finance Score Detail Screen
/// 0-100 score, level tiers, achievements, badges, sharing
class FinanceScoreScreen extends ConsumerWidget {
  const FinanceScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(financeScoreProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppTopBar(title: 'Finance Score'),
      body: scoreAsync.when(
        data: (score) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Main Score Display
              Card(
                color: AppColors.darkSurface,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      ScoreGauge(
                        score: score.totalScore,
                        maxScore: 100,
                        label: score.levelName,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Level ${score.level}',
                        style: AppTypography.h3.copyWith(
                          color: AppColors.getScoreColor(score.totalScore),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        score.levelName,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Sub-scores Breakdown
              Text(
                'Score Breakdown',
                style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.md),
              _ScoreBreakdownCard(
                label: 'Budget Score',
                score: score.budgetScore,
                maxScore: 100,
                weight: '30%',
                color: AppColors.primary,
              ),
              _ScoreBreakdownCard(
                label: 'Savings Score',
                score: score.savingsScore,
                maxScore: 100,
                weight: '25%',
                color: AppColors.accent,
              ),
              _ScoreBreakdownCard(
                label: 'Consistency Score',
                score: score.consistencyScore,
                maxScore: 100,
                weight: '20%',
                color: AppColors.info,
              ),
              _ScoreBreakdownCard(
                label: 'Categorization Score',
                score: score.categorizationScore,
                maxScore: 100,
                weight: '15%',
                color: AppColors.warning,
              ),
              _ScoreBreakdownCard(
                label: 'Goal Score',
                score: score.goalScore,
                maxScore: 100,
                weight: '10%',
                color: AppColors.danger,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tips for Improvement
              if (score.tips.isNotEmpty) ...[
                Text(
                  'Tips to Improve',
                  style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                ...score.tips.map(
                  (tip) => Card(
                    color: AppColors.darkSurface,
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.warning,
                      ),
                      title: Text(
                        tip,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Share Button
              ElevatedButton.icon(
                onPressed: () {
                  // Share functionality can be implemented using share_plus package
                  // Example: Share.share('My Finance Score: ${score.totalScore}');
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Score'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Error loading score',
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

class _ScoreBreakdownCard extends StatelessWidget {
  final String label;
  final int score;
  final int maxScore;
  final String weight;
  final Color color;

  const _ScoreBreakdownCard({
    required this.label,
    required this.score,
    required this.maxScore,
    required this.weight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = score / maxScore;
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
                  '$score/$maxScore',
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
