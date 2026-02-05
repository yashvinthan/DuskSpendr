import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/gamification/finance_score_service.dart';
import 'budget_provider.dart';
import 'transaction_provider.dart';

/// SS-083: Gamification providers - Finance Score and Achievements

// ====== Finance Score Service ======

final financeScoreServiceProvider = Provider<FinanceScoreService>((ref) {
  return FinanceScoreService();
});

// ====== Finance Score ======

/// Current finance score
final financeScoreProvider = FutureProvider<FinanceScore>((ref) async {
  final service = ref.watch(financeScoreServiceProvider);
  final budgets = await ref.watch(activeBudgetsProvider.future);
  final transactions = await ref.watch(allTransactionsProvider.future);
  
  // Calculate days since first transaction (or account creation)
  int daysTracking = 30; // Default
  if (transactions.isNotEmpty) {
    final oldest = transactions.reduce((a, b) => 
      a.timestamp.isBefore(b.timestamp) ? a : b);
    daysTracking = DateTime.now().difference(oldest.timestamp).inDays;
  }

  return await service.calculateScore(
    budgets: budgets,
    transactions: transactions,
    daysTracking: daysTracking,
  );
});

/// Finance score stream for real-time updates
final financeScoreStreamProvider = StreamProvider<FinanceScore>((ref) {
  final service = ref.watch(financeScoreServiceProvider);
  return service.scoreStream;
});

// ====== Achievements ======

/// Unlocked achievement IDs persisted in shared preferences
final unlockedAchievementsProvider = FutureProvider<Set<String>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final ids = prefs.getStringList('unlocked_achievements') ?? [];
  return ids.toSet();
});

/// All achievements with unlock status
final allAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final service = ref.watch(financeScoreServiceProvider);
  final unlocked = await ref.watch(unlockedAchievementsProvider.future);
  return service.getAllAchievements(unlocked);
});

/// Check for new achievements
final newAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final service = ref.watch(financeScoreServiceProvider);
  final budgets = await ref.watch(activeBudgetsProvider.future);
  final transactions = await ref.watch(allTransactionsProvider.future);
  final unlocked = await ref.watch(unlockedAchievementsProvider.future);

  final newlyUnlocked = await service.checkAchievements(
    budgets: budgets,
    transactions: transactions,
    unlockedIds: unlocked,
  );

  // Persist newly unlocked achievements
  if (newlyUnlocked.isNotEmpty) {
    final prefs = await SharedPreferences.getInstance();
    final allUnlocked = {...unlocked, ...newlyUnlocked.map((a) => a.id)};
    await prefs.setStringList('unlocked_achievements', allUnlocked.toList());
  }

  return newlyUnlocked;
});

/// Stream of new achievement unlocks
final achievementUnlockStreamProvider = StreamProvider<Achievement>((ref) {
  final service = ref.watch(financeScoreServiceProvider);
  return service.newAchievements;
});

/// Total achievement points
final totalAchievementPointsProvider = FutureProvider<int>((ref) async {
  final achievements = await ref.watch(allAchievementsProvider.future);
  var total = 0;
  for (final achievement in achievements) {
    if (achievement.isUnlocked) {
      total += achievement.points;
    }
  }
  return total;
});

// ====== Score Level ======

/// Current score level (1-5)
final scoreLevelProvider = FutureProvider<int>((ref) async {
  final score = await ref.watch(financeScoreProvider.future);
  return score.level;
});

/// Level name
final scoreLevelNameProvider = FutureProvider<String>((ref) async {
  final score = await ref.watch(financeScoreProvider.future);
  return score.levelName;
});

// ====== Weekly Change ======

/// Weekly score change tracking
class WeeklyScoreNotifier extends StateNotifier<int> {
  static const _key = 'last_week_score';

  WeeklyScoreNotifier() : super(0);

  Future<int> getWeeklyChange(int currentScore) async {
    final prefs = await SharedPreferences.getInstance();
    final lastWeekScore = prefs.getInt(_key) ?? currentScore;
    
    // Update stored score (in production, do this weekly)
    await prefs.setInt(_key, currentScore);
    
    state = currentScore - lastWeekScore;
    return state;
  }
}

final weeklyScoreChangeProvider = StateNotifierProvider<WeeklyScoreNotifier, int>((ref) {
  return WeeklyScoreNotifier();
});

// ====== Helper Providers ======

/// Quick access to total score for widgets
final quickScoreProvider = Provider<AsyncValue<int>>((ref) {
  return ref.watch(financeScoreProvider).whenData((score) => score.totalScore);
});

/// Score tips for improvement
final scoreTipsProvider = FutureProvider<List<String>>((ref) async {
  final score = await ref.watch(financeScoreProvider.future);
  return score.tips;
});
