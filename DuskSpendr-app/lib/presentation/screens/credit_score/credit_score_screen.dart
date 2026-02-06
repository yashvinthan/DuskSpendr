import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/education/credit_score_tracker.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';

/// SS-097: Credit Score Tracking Screen
/// CIBIL/Experian integration, manual entry, improvement tips
class CreditScoreScreen extends ConsumerStatefulWidget {
  const CreditScoreScreen({super.key});

  @override
  ConsumerState<CreditScoreScreen> createState() => _CreditScoreScreenState();
}

class _CreditScoreScreenState extends ConsumerState<CreditScoreScreen> {
  final CreditScoreTracker _tracker = CreditScoreTracker();
  CreditScore? _score;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    setState(() => _isLoading = true);
    final score = await _tracker.getCurrentScore();
    if (mounted) {
      setState(() {
        _score = score;
        _isLoading = false;
      });
    }
  }

  Future<void> _showManualEntryDialog() async {
    final controller = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(
          'Enter Credit Score',
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Score (300-900)',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textMuted),
            ),
          ),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 300 && value <= 900) {
                Navigator.pop(context);
                _tracker.setManualScore(value);
                _loadScore();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppTopBar(title: 'Credit Score'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  if (_score != null) ...[
                    // Score Display
                    Card(
                      color: AppColors.darkSurface,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            Text(
                              '${_score!.score}',
                              style: AppTypography.displayLarge.copyWith(
                                color: _getScoreColor(_score!.score),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              _score!.range,
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Last updated: ${_score!.provider.name}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Improvement Tips
                    Text(
                      'Improvement Tips',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ..._score!.tips.map(
                      (tip) => Card(
                        color: AppColors.darkSurface,
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: Icon(
                            Icons.check_circle_outline,
                            color: AppColors.accent,
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
                  ] else ...[
                    // No Score State
                    Card(
                      color: AppColors.darkSurface,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            Icon(
                              Icons.credit_score_outlined,
                              size: 64,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'No Credit Score Recorded',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Enter your credit score manually or connect to CIBIL/Experian',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ElevatedButton.icon(
                              onPressed: _showManualEntryDialog,
                              icon: const Icon(Icons.edit),
                              label: const Text('Enter Manually'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            OutlinedButton.icon(
                              onPressed: () {
                                // CIBIL integration requires API credentials and OAuth setup
                                // Will be implemented when API access is available
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('CIBIL integration coming soon'),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.link),
                              label: const Text('Connect CIBIL'),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Experian integration requires API credentials and OAuth setup
                                // Will be implemented when API access is available
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Experian integration coming soon'),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.link),
                              label: const Text('Connect Experian'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 750) return AppColors.accent;
    if (score >= 700) return AppColors.primary;
    if (score >= 650) return AppColors.warning;
    return AppColors.error;
  }
}
