import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/education_provider.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/cards/glass_card.dart';
import 'lesson_screen.dart';

/// SS-096: Learning Hub main screen
class LearningHubScreen extends ConsumerWidget {
  const LearningHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(learningProgressProvider);
    final topics = ref.watch(financialTopicsProvider);
    final nextLesson = ref.watch(nextRecommendedLessonProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Learn',
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events, color: AppColors.amber500),
            onPressed: () => _showAchievements(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Progress summary
          progress.when(
            data: (p) => _ProgressCard(progress: p),
            loading: () => const _ProgressCardPlaceholder(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Continue learning
          nextLesson.when(
            data: (lesson) => lesson != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue Learning',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _ContinueLessonCard(lesson: lesson),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Topics grid
          Text(
            'Topics',
            style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return _TopicCard(topic: topics[index]);
            },
          ),
        ],
      ),
    );
  }

  void _showAchievements(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AchievementsScreen()),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final LearningProgress progress;

  const _ProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = progress.totalLessons > 0
        ? progress.completedLessons / progress.totalLessons
        : 0.0;

    return GlassCard(
      gradient: const LinearGradient(
        colors: [AppColors.dusk700, AppColors.dusk500],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.amber500.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.school, color: AppColors.amber500),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Progress',
                      style: AppTypography.titleMedium.copyWith(color: Colors.white),
                    ),
                    Text(
                      '${progress.completedLessons} of ${progress.totalLessons} lessons completed',
                      style: AppTypography.caption.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Text(
                '${(percent * 100).toInt()}%',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.amber500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber500),
              minHeight: 8,
            ),
          ),
          if (progress.quizzesTaken > 0) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.quiz, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${progress.quizzesTaken} quizzes completed • Avg score: ${progress.averageQuizScore.toStringAsFixed(0)}%',
                  style: AppTypography.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressCardPlaceholder extends StatelessWidget {
  const _ProgressCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 16, decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 4),
                Container(width: 150, height: 12, decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueLessonCard extends StatelessWidget {
  final EducationalLesson lesson;

  const _ContinueLessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LessonScreen(lessonId: lesson.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              lesson.topic.color.withValues(alpha: 0.3),
              lesson.topic.color.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: lesson.topic.color.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: lesson.topic.color.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Text(
                  lesson.topic.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                  ),
                  Text(
                    lesson.subtitle,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.durationMinutes} min',
                        style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: lesson.topic.color,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends ConsumerWidget {
  final FinancialTopic topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(topicProgressProvider(topic));

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TopicLessonsScreen(topic: topic)),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: topic.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(topic.emoji, style: const TextStyle(fontSize: 28)),
                progressAsync.when(
                  data: (p) => p > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: topic.color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            '${(p * 100).toInt()}%',
                            style: AppTypography.caption.copyWith(color: topic.color),
                          ),
                        )
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const Spacer(),
            Text(
              topic.displayName,
              style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary),
            ),
            Text(
              _getTopicDescription(topic),
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getTopicDescription(FinancialTopic topic) {
    switch (topic) {
      case FinancialTopic.spending:
        return 'Track & control';
      case FinancialTopic.saving:
        return 'Build your future';
      case FinancialTopic.budgeting:
        return 'Plan wisely';
      case FinancialTopic.credit:
        return 'Score matters';
      case FinancialTopic.investing:
        return 'Grow wealth';
      case FinancialTopic.banking:
        return 'Money basics';
      case FinancialTopic.goals:
        return 'Dream big';
    }
  }
}

/// Topic lessons list screen
class TopicLessonsScreen extends ConsumerWidget {
  final FinancialTopic topic;

  const TopicLessonsScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(topicLessonsProvider(topic));
    final completedIds = ref.watch(completedLessonIdsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: topic.displayName,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: lessons.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final isCompleted = completedIds.valueOrNull?.contains(lesson.id) ?? false;

          return _LessonListItem(
            lesson: lesson,
            isCompleted: isCompleted,
            index: index + 1,
          );
        },
      ),
    );
  }
}

class _LessonListItem extends StatelessWidget {
  final EducationalLesson lesson;
  final bool isCompleted;
  final int index;

  const _LessonListItem({
    required this.lesson,
    required this.isCompleted,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LessonScreen(lessonId: lesson.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: isCompleted
              ? Border.all(color: AppColors.success.withValues(alpha: 0.5))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.2)
                    : lesson.topic.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: AppColors.success, size: 20)
                    : Text(
                        '$index',
                        style: AppTypography.titleMedium.copyWith(color: lesson.topic.color),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    lesson.subtitle,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.timer, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${lesson.durationMinutes}m',
                  style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(width: AppSpacing.sm),
                if (lesson.quiz.isNotEmpty)
                  Icon(Icons.quiz, size: 14, color: AppColors.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Achievements screen
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Achievements',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _AchievementCard(
            icon: Icons.school,
            title: 'First Steps',
            description: 'Complete your first lesson',
            isUnlocked: true,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          _AchievementCard(
            icon: Icons.local_fire_department,
            title: 'On Fire!',
            description: 'Complete 5 lessons in a row',
            isUnlocked: false,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.sm),
          _AchievementCard(
            icon: Icons.quiz,
            title: 'Quiz Master',
            description: 'Score 100% on 3 quizzes',
            isUnlocked: false,
            color: AppColors.amber500,
          ),
          const SizedBox(height: AppSpacing.sm),
          _AchievementCard(
            icon: Icons.emoji_events,
            title: 'Financial Expert',
            description: 'Complete all lessons',
            isUnlocked: false,
            color: AppColors.dusk500,
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final Color color;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: isUnlocked ? Border.all(color: color.withValues(alpha: 0.5)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isUnlocked ? color.withValues(alpha: 0.2) : AppColors.darkSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isUnlocked ? color : AppColors.textMuted,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                Text(
                  description,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'Unlocked!',
                style: AppTypography.caption.copyWith(color: color),
              ),
            )
          else
            Icon(Icons.lock, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

// Extension for topic colors
extension FinancialTopicColor on FinancialTopic {
  Color get color {
    switch (this) {
      case FinancialTopic.spending:
        return AppColors.error;
      case FinancialTopic.saving:
        return AppColors.success;
      case FinancialTopic.budgeting:
        return AppColors.dusk500;
      case FinancialTopic.credit:
        return AppColors.amber500;
      case FinancialTopic.investing:
        return AppColors.sunset500;
      case FinancialTopic.banking:
        return AppColors.info;
      case FinancialTopic.goals:
        return const Color(0xFF9C27B0); // Purple
    }
  }
}
