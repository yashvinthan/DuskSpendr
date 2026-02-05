import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/education_provider.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/buttons/primary_button.dart';
import 'learning_hub_screen.dart';

/// Individual lesson view screen
class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _lessonCompleted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = ref.watch(lessonByIdProvider(widget.lessonId));

    if (lesson == null) {
      return Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppTopBar(
          title: 'Lesson',
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final totalPages = lesson.sections.length + (lesson.quiz.isNotEmpty ? 1 : 0);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: lesson.topic.displayName,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: lesson.topic.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                '${_currentPage + 1}/$totalPages',
                style: AppTypography.labelMedium.copyWith(color: lesson.topic.color),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentPage + 1) / totalPages,
            backgroundColor: AppColors.darkCard,
            valueColor: AlwaysStoppedAnimation<Color>(lesson.topic.color),
            minHeight: 4,
          ),

          // Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemCount: totalPages,
              itemBuilder: (context, index) {
                if (index < lesson.sections.length) {
                  return _SectionPage(
                    section: lesson.sections[index],
                    color: lesson.topic.color,
                  );
                } else {
                  return _QuizPage(
                    questions: lesson.quiz,
                    color: lesson.topic.color,
                    onComplete: (score) => _completeLesson(lesson, score),
                  );
                }
              },
            ),
          ),

          // Navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.darkCard),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: _currentPage < totalPages - 1
                        ? PrimaryButton(
                            label: 'Continue',
                            onPressed: _nextPage,
                          )
                        : lesson.quiz.isEmpty
                            ? PrimaryButton(
                                label: 'Complete Lesson',
                                onPressed: () => _completeLesson(lesson, null),
                              )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeLesson(EducationalLesson lesson, int? quizScore) async {
    if (_lessonCompleted) return;
    _lessonCompleted = true;

    await ref.read(educationNotifierProvider.notifier).completeLesson(
          lessonId: lesson.id,
          quizScore: quizScore,
          quizTotal: lesson.quiz.isNotEmpty ? lesson.quiz.length : null,
        );

    if (mounted) {
      _showCompletionDialog(lesson, quizScore);
    }
  }

  void _showCompletionDialog(EducationalLesson lesson, int? quizScore) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration, color: AppColors.success, size: 48),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Lesson Complete! 🎉',
              style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You finished "${lesson.title}"',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (quizScore != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.amber500.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.quiz, color: AppColors.amber500, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Quiz Score: $quizScore/${lesson.quiz.length}',
                      style: AppTypography.labelLarge.copyWith(color: AppColors.amber500),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to hub
              },
              child: Text(
                'Continue Learning',
                style: AppTypography.labelLarge.copyWith(color: AppColors.dusk500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionPage extends StatelessWidget {
  final LessonSection section;
  final Color color;

  const _SectionPage({required this.section, required this.color});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section type indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getSectionIcon(section.type), size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  section.type.name.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            section.title,
            style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Content
          _renderContent(section),
        ],
      ),
    );
  }

  Widget _renderContent(LessonSection section) {
    // Parse content for special formatting
    final lines = section.content.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        // Check for bullet points
        if (line.startsWith('•') || line.startsWith('-')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    line.substring(1).trim(),
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          );
        }

        // Check for emphasis (lines starting with numbers or special chars)
        if (RegExp(r'^\d+%').hasMatch(line)) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                line,
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
              ),
            ),
          );
        }

        if (line.isEmpty) {
          return const SizedBox(height: 8);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            line,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getSectionIcon(LessonSectionType type) {
    switch (type) {
      case LessonSectionType.hook:
        return Icons.lightbulb_outline;
      case LessonSectionType.concept:
        return Icons.school_outlined;
      case LessonSectionType.example:
        return Icons.auto_stories_outlined;
      case LessonSectionType.interactive:
        return Icons.touch_app_outlined;
      case LessonSectionType.takeaway:
        return Icons.bookmark_outline;
    }
  }
}

class _QuizPage extends StatefulWidget {
  final List<QuizQuestion> questions;
  final Color color;
  final Function(int score) onComplete;

  const _QuizPage({
    required this.questions,
    required this.color,
    required this.onComplete,
  });

  @override
  State<_QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<_QuizPage> {
  int _currentQuestion = 0;
  final Map<int, int?> _answers = {};
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return _buildResults();
    }

    final question = widget.questions[_currentQuestion];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.amber500.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.quiz, size: 16, color: AppColors.amber500),
                    const SizedBox(width: 6),
                    Text(
                      'QUIZ',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.amber500,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${_currentQuestion + 1}/${widget.questions.length}',
                style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Question
          Text(
            question.question,
            style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _answers[_currentQuestion] == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => _selectAnswer(index),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.color.withValues(alpha: 0.2)
                        : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isSelected ? widget.color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? widget.color
                              : AppColors.darkSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: AppTypography.labelLarge.copyWith(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          option,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.xl),

          // Next button
          if (_answers[_currentQuestion] != null)
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: _currentQuestion < widget.questions.length - 1
                    ? 'Next Question'
                    : 'See Results',
                onPressed: _nextQuestion,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    int correct = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (_answers[i] == widget.questions[i].correctIndex) {
        correct++;
      }
    }

    final percent = (correct / widget.questions.length * 100).round();
    final passed = percent >= 70;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),

          // Score circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (passed ? AppColors.success : AppColors.amber500).withValues(alpha: 0.2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$correct/${widget.questions.length}',
                    style: AppTypography.headlineMedium.copyWith(
                      color: passed ? AppColors.success : AppColors.amber500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: AppTypography.labelMedium.copyWith(
                      color: passed ? AppColors.success : AppColors.amber500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(
            passed ? 'Great Job! 🎉' : 'Keep Learning! 📚',
            style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            passed
                ? 'You passed the quiz with flying colors!'
                : 'Review the lesson and try again to improve.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xl),

          // Answers review
          ...widget.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            final userAnswer = _answers[index];
            final isCorrect = userAnswer == question.correctIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: (isCorrect ? AppColors.success : AppColors.error).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? AppColors.success : AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.question,
                          style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  if (!isCorrect && question.explanation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      question.explanation!,
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            );
          }),

          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Complete Lesson',
              onPressed: () => widget.onComplete(correct),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAnswer(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _answers[_currentQuestion] = index;
    });
  }

  void _nextQuestion() {
    HapticFeedback.lightImpact();
    if (_currentQuestion < widget.questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      setState(() {
        _showResult = true;
      });
    }
  }
}
