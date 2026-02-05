import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/education/educational_content_service.dart';
import '../core/education/financial_educator_service.dart';
import '../domain/entities/entities.dart' hide BudgetStatus;
import 'database_provider.dart';

// ====== SS-090-096: Education Providers ======

/// Educational content service provider
final educationalContentProvider = Provider<EducationalContentService>((ref) {
  return EducationalContentService();
});

/// Financial educator service provider
final financialEducatorProvider = Provider<FinancialEducatorService>((ref) {
  return FinancialEducatorService(
    educationDao: ref.watch(educationDaoProvider),
  );
});

// ====== Topics & Lessons Providers ======

/// All available topics
final financialTopicsProvider = Provider<List<FinancialTopic>>((ref) {
  return ref.watch(educationalContentProvider).getAllTopics();
});

/// Lessons for a topic
final topicLessonsProvider =
    Provider.family<List<EducationalLesson>, FinancialTopic>((ref, topic) {
  return ref.watch(educationalContentProvider).getLessonsForTopic(topic);
});

/// Single lesson by ID
final lessonByIdProvider =
    Provider.family<EducationalLesson?, String>((ref, id) {
  return ref.watch(educationalContentProvider).getLesson(id);
});

/// Completed lesson IDs
final completedLessonIdsProvider = FutureProvider<Set<String>>((ref) async {
  return ref.watch(educationDaoProvider).getCompletedLessonIds();
});

/// Next recommended lesson
final nextRecommendedLessonProvider = FutureProvider<EducationalLesson?>((ref) async {
  final completedIds = await ref.watch(completedLessonIdsProvider.future);
  return ref.watch(educationalContentProvider).getNextRecommendedLesson(completedIds);
});

/// Learning progress summary
final learningProgressProvider = FutureProvider<LearningProgress>((ref) async {
  final content = ref.watch(educationalContentProvider);
  final dao = ref.watch(educationDaoProvider);
  
  final completedIds = await dao.getCompletedLessonIds();
  int totalLessons = 0;
  final completedByTopic = <FinancialTopic, int>{};
  
  for (final topic in FinancialTopic.values) {
    final lessons = content.getLessonsForTopic(topic);
    totalLessons += lessons.length;
    
    final completedInTopic =
        lessons.where((l) => completedIds.contains(l.id)).length;
    completedByTopic[topic] = completedInTopic;
  }
  
  final totalQuizScore = await dao.getTotalQuizScore();
  final quizzesTaken = await dao.getQuizzesTakenCount();
  
  return LearningProgress(
    completedLessons: completedIds.length,
    totalLessons: totalLessons,
    completedByTopic: completedByTopic,
    totalQuizScore: totalQuizScore,
    quizzesTaken: quizzesTaken,
    badges: const [],
  );
});

/// Topic progress (percentage complete)
final topicProgressProvider =
    FutureProvider.family<double, FinancialTopic>((ref, topic) async {
  final completedIds = await ref.watch(completedLessonIdsProvider.future);
  final lessons = ref.watch(topicLessonsProvider(topic));
  
  if (lessons.isEmpty) return 0;
  final completed = lessons.where((l) => completedIds.contains(l.id)).length;
  return completed / lessons.length;
});

// ====== Tips Providers ======

/// Current spending pattern (populated by transaction provider)
final spendingPatternProvider = StateProvider<SpendingPattern?>((ref) => null);

/// Budget status for health score
final budgetStatusProvider = StateProvider<BudgetStatus?>((ref) => null);

/// Savings data for health score
final savingsDataProvider = StateProvider<SavingsData?>((ref) => null);

/// Personalized tips based on spending pattern
final personalizedTipsProvider = FutureProvider<List<FinancialTip>>((ref) async {
  final pattern = ref.watch(spendingPatternProvider);
  if (pattern == null) return [];
  
  final educator = ref.watch(financialEducatorProvider);
  return educator.generatePersonalizedTips(pattern: pattern);
});

/// Daily tip (shown on dashboard)
final dailyTipProvider = FutureProvider<FinancialTip?>((ref) async {
  final tips = await ref.watch(personalizedTipsProvider.future);
  return tips.isNotEmpty ? tips.first : null;
});

// ====== Health Score Providers ======

/// Financial health score
final financialHealthScoreProvider = FutureProvider<FinancialHealthScore?>((ref) async {
  final pattern = ref.watch(spendingPatternProvider);
  final budgetStatus = ref.watch(budgetStatusProvider);
  final savingsData = ref.watch(savingsDataProvider);
  
  if (pattern == null || budgetStatus == null || savingsData == null) return null;
  
  final educator = ref.watch(financialEducatorProvider);
  return educator.calculateHealthScore(
    spendingPattern: pattern,
    budgetStatus: budgetStatus,
    savingsData: savingsData,
  );
});

/// Improvement suggestions
final improvementSuggestionsProvider = FutureProvider<List<Improvement>>((ref) async {
  final healthScore = await ref.watch(financialHealthScoreProvider.future);
  if (healthScore == null) return [];
  
  final weakAreas = <String>[];
  if (healthScore.budgetingScore < 60) weakAreas.add('budgeting');
  if (healthScore.savingsScore < 60) weakAreas.add('savings');
  if (healthScore.spendingDiscipline < 60) weakAreas.add('discipline');
  if (healthScore.financialLiteracy < 60) weakAreas.add('literacy');
  
  if (weakAreas.isEmpty) return [];
  
  final educator = ref.watch(financialEducatorProvider);
  return educator.suggestImprovements(weakAreas: weakAreas);
});

// ====== Credit Score Providers ======

/// Latest credit score
final latestCreditScoreProvider = FutureProvider<CreditScoreData?>((ref) async {
  return ref.watch(educationDaoProvider).getLatestCreditScore();
});

/// Credit score history
final creditScoreHistoryProvider = FutureProvider<List<CreditScoreData>>((ref) async {
  return ref.watch(educationDaoProvider).getCreditScoreHistory(limit: 12);
});

// ====== Education Notifier ======

class EducationNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  EducationNotifier(this._ref) : super(const AsyncValue.data(null));

  /// Complete a lesson
  Future<void> completeLesson({
    required String lessonId,
    required String topicId,
    required int timeSpentSeconds,
    int? quizScore,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(educationDaoProvider).completeLesson(
            CompletedLesson(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              lessonId: lessonId,
              topicId: topicId,
              timeSpentSeconds: timeSpentSeconds,
              completedAt: DateTime.now(),
              quizScore: quizScore,
            ),
          );
      _ref.invalidate(completedLessonIdsProvider);
      _ref.invalidate(learningProgressProvider);
      _ref.invalidate(nextRecommendedLessonProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Record tip as shown
  Future<void> recordTipShown(String tipId) async {
    try {
      await _ref.read(financialEducatorProvider).recordShownTip(tipId);
      _ref.invalidate(personalizedTipsProvider);
    } catch (_) {
      // Ignore errors for tip tracking
    }
  }

  /// Mark tip as acted on
  Future<void> markTipActedOn(String id) async {
    try {
      await _ref.read(financialEducatorProvider).updateTipInteraction(
            id,
            actedOn: true,
          );
    } catch (_) {}
  }

  /// Mark tip as saved
  Future<void> saveTip(String id) async {
    try {
      await _ref.read(financialEducatorProvider).updateTipInteraction(
            id,
            saved: true,
          );
    } catch (_) {}
  }

  /// Dismiss tip
  Future<void> dismissTip(String id) async {
    try {
      await _ref.read(financialEducatorProvider).updateTipInteraction(
            id,
            dismissed: true,
          );
      _ref.invalidate(personalizedTipsProvider);
    } catch (_) {}
  }

  /// Record credit score
  Future<void> recordCreditScore({
    required int score,
    required String source,
    List<CreditFactor>? factors,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(educationDaoProvider).insertCreditScore(
            id: DateTime.now().toIso8601String(),
            score: score,
            source: source,
            factors: factors,
          );
      _ref.invalidate(latestCreditScoreProvider);
      _ref.invalidate(creditScoreHistoryProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final educationNotifierProvider =
    StateNotifierProvider<EducationNotifier, AsyncValue<void>>((ref) {
  return EducationNotifier(ref);
});
