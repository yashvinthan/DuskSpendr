import 'dart:async';

import '../../domain/entities/entities.dart';

/// SS-083: Student Finance Score calculation and gamification
/// Score Calculation:
/// - Budget Score (30%): How often under budget
/// - Savings Score (25%): Percentage saved vs spent
/// - Consistency Score (20%): Regular tracking habits
/// - Categorization Score (15%): Accuracy of categories
/// - Goal Score (10%): Progress toward goals

class FinanceScoreService {
  final _scoreController = StreamController<FinanceScore>.broadcast();
  final _achievementController = StreamController<Achievement>.broadcast();

  Stream<FinanceScore> get scoreStream => _scoreController.stream;
  Stream<Achievement> get newAchievements => _achievementController.stream;

  FinanceScoreService();

  // ====== Score Calculation ======

  /// Calculate complete Finance Score
  Future<FinanceScore> calculateScore({
    required List<Budget> budgets,
    required List<Transaction> transactions,
    required int daysTracking,
  }) async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    // Filter to recent transactions
    final recentTx = transactions.where((t) => 
      t.timestamp.isAfter(thirtyDaysAgo)
    ).toList();

    // Calculate sub-scores
    final budgetScore = _calculateBudgetScore(budgets);
    final savingsScore = _calculateSavingsScore(recentTx);
    final consistencyScore = _calculateConsistencyScore(recentTx, daysTracking);
    final categorizationScore = _calculateCategorizationScore(recentTx);
    final goalScore = _calculateGoalScore(budgets);

    // Weighted total (0-100)
    final totalScore = (
      budgetScore * 0.30 +
      savingsScore * 0.25 +
      consistencyScore * 0.20 +
      categorizationScore * 0.15 +
      goalScore * 0.10
    ).round().clamp(0, 100);

    final score = FinanceScore(
      totalScore: totalScore,
      budgetScore: budgetScore.round(),
      savingsScore: savingsScore.round(),
      consistencyScore: consistencyScore.round(),
      categorizationScore: categorizationScore.round(),
      goalScore: goalScore.round(),
      level: _getLevel(totalScore),
      levelName: _getLevelName(totalScore),
      weeklyChange: 0, // TODO: Compare with last week
      calculatedAt: now,
      tips: _generateTips(
        budgetScore: budgetScore,
        savingsScore: savingsScore,
        consistencyScore: consistencyScore,
      ),
    );

    _scoreController.add(score);
    return score;
  }

  double _calculateBudgetScore(List<Budget> budgets) {
    if (budgets.isEmpty) return 50.0; // Neutral if no budgets

    int underBudgetCount = 0;
    for (final budget in budgets) {
      if (budget.spent.paisa <= budget.limit.paisa) {
        underBudgetCount++;
      }
    }

    final ratio = underBudgetCount / budgets.length;
    return ratio * 100;
  }

  double _calculateSavingsScore(List<Transaction> transactions) {
    if (transactions.isEmpty) return 50.0;

    int totalIncome = 0;
    int totalSpent = 0;

    for (final tx in transactions) {
      if (tx.type == TransactionType.credit) {
        totalIncome += tx.amount.paisa;
      } else if (tx.type == TransactionType.debit) {
        totalSpent += tx.amount.paisa;
      }
    }

    if (totalIncome == 0) return 30.0; // No income recorded

    final savingsRatio = 1 - (totalSpent / totalIncome);
    
    // Target: Save at least 20%
    // 0% saved = 0 score, 20%+ saved = 100 score
    return (savingsRatio * 500).clamp(0.0, 100.0);
  }

  double _calculateConsistencyScore(
    List<Transaction> transactions,
    int daysTracking,
  ) {
    if (daysTracking < 7) return 60.0; // Too early to judge

    // Group transactions by day
    final dayMap = <String, int>{};
    for (final tx in transactions) {
      final key = '${tx.timestamp.year}-${tx.timestamp.month}-${tx.timestamp.day}';
      dayMap[key] = (dayMap[key] ?? 0) + 1;
    }

    // Calculate active days ratio
    final activeDays = dayMap.length;
    final expectedDays = daysTracking.clamp(1, 30);
    final ratio = activeDays / expectedDays;

    // Award bonus for consistent daily tracking
    return (ratio * 100).clamp(0.0, 100.0);
  }

  double _calculateCategorizationScore(List<Transaction> transactions) {
    if (transactions.isEmpty) return 70.0;

    int categorized = 0;
    for (final tx in transactions) {
      if (tx.category != TransactionCategory.other) {
        categorized++;
      }
    }

    final ratio = categorized / transactions.length;
    return ratio * 100;
  }

  double _calculateGoalScore(List<Budget> budgets) {
    if (budgets.isEmpty) return 50.0;

    double totalProgress = 0;
    int activeBudgets = 0;

    for (final budget in budgets) {
      if (budget.limit.paisa > 0) {
        // Progress is inverse - less spent = more progress toward saving goal
        final remaining = 1 - (budget.spent.paisa / budget.limit.paisa);
        totalProgress += remaining.clamp(0.0, 1.0);
        activeBudgets++;
      }
    }

    if (activeBudgets == 0) return 50.0;
    return (totalProgress / activeBudgets) * 100;
  }

  // ====== Levels ======

  int _getLevel(int score) {
    if (score >= 81) return 5;
    if (score >= 61) return 4;
    if (score >= 41) return 3;
    if (score >= 21) return 2;
    return 1;
  }

  String _getLevelName(int score) {
    if (score >= 81) return 'Finance Wizard';
    if (score >= 61) return 'Money Master';
    if (score >= 41) return 'Smart Spender';
    if (score >= 21) return 'Saver';
    return 'Beginner';
  }

  // ====== Tips ======

  List<String> _generateTips({
    required double budgetScore,
    required double savingsScore,
    required double consistencyScore,
  }) {
    final tips = <String>[];

    if (budgetScore < 60) {
      tips.add('Try setting smaller daily budgets to stay on track');
    }
    if (savingsScore < 50) {
      tips.add('Aim to save at least 20% of your pocket money');
    }
    if (consistencyScore < 50) {
      tips.add('Log your expenses daily for better tracking');
    }
    if (tips.isEmpty) {
      tips.add('Great job! Keep maintaining your financial habits');
    }

    return tips;
  }

  // ====== Achievements ======

  /// Check and unlock achievements
  Future<List<Achievement>> checkAchievements({
    required List<Budget> budgets,
    required List<Transaction> transactions,
    required Set<String> unlockedIds,
  }) async {
    final newlyUnlocked = <Achievement>[];

    for (final achievement in _allAchievements) {
      if (unlockedIds.contains(achievement.id)) continue;

      final unlocked = _checkAchievementCriteria(
        achievement,
        budgets: budgets,
        transactions: transactions,
      );

      if (unlocked) {
        newlyUnlocked.add(achievement.copyWith(
          unlockedAt: DateTime.now(),
          isUnlocked: true,
        ));
        _achievementController.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  bool _checkAchievementCriteria(
    Achievement achievement, {
    required List<Budget> budgets,
    required List<Transaction> transactions,
  }) {
    switch (achievement.id) {
      case 'first_budget':
        return budgets.isNotEmpty;
      
      case 'week_under_budget':
        // Check if all budgets are under limit
        return budgets.isNotEmpty && 
          budgets.every((b) => b.spent.paisa < b.limit.paisa);
      
      case 'saved_20_percent':
        int income = 0, spent = 0;
        for (final tx in transactions) {
          if (tx.type == TransactionType.credit) income += tx.amount.paisa;
          if (tx.type == TransactionType.debit) spent += tx.amount.paisa;
        }
        return income > 0 && (1 - spent / income) >= 0.20;
      
      case 'categorized_100':
        final categorized = transactions.where(
          (t) => t.category != TransactionCategory.other
        ).length;
        return categorized >= 100;
      
      case 'first_transaction':
        return transactions.isNotEmpty;
      
      case 'streak_7_days':
        return _hasConsecutiveDays(transactions, 7);
      
      case 'streak_30_days':
        return _hasConsecutiveDays(transactions, 30);
      
      case 'no_overspend_month':
        // No budget exceeded in the last 30 days
        return budgets.isNotEmpty &&
            budgets.every((b) => b.percentSpent < 100);
      
      default:
        return false;
    }
  }

  bool _hasConsecutiveDays(List<Transaction> transactions, int days) {
    if (transactions.length < days) return false;

    final today = DateTime.now();
    final daySet = <String>{};
    
    for (final tx in transactions) {
      final key = '${tx.timestamp.year}-${tx.timestamp.month}-${tx.timestamp.day}';
      daySet.add(key);
    }

    // Check if we have entries for the last N consecutive days
    for (int i = 0; i < days; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final key = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      if (!daySet.contains(key)) return false;
    }

    return true;
  }

  /// All available achievements
  static final List<Achievement> _allAchievements = [
    Achievement(
      id: 'first_transaction',
      name: 'First Step',
      description: 'Log your first transaction',
      icon: '🚀',
      points: 10,
      category: AchievementCategory.beginner,
    ),
    Achievement(
      id: 'first_budget',
      name: 'Budget Boss',
      description: 'Create your first budget',
      icon: '📊',
      points: 20,
      category: AchievementCategory.beginner,
    ),
    Achievement(
      id: 'week_under_budget',
      name: 'Week Warrior',
      description: 'Stay under budget for a week',
      icon: '🏆',
      points: 50,
      category: AchievementCategory.budgeting,
    ),
    Achievement(
      id: 'saved_20_percent',
      name: 'Super Saver',
      description: 'Save 20% of your pocket money',
      icon: '💰',
      points: 75,
      category: AchievementCategory.savings,
    ),
    Achievement(
      id: 'categorized_100',
      name: 'Organization Pro',
      description: 'Categorize 100 transactions',
      icon: '🏷️',
      points: 40,
      category: AchievementCategory.tracking,
    ),
    Achievement(
      id: 'streak_7_days',
      name: 'Week Streak',
      description: 'Track expenses for 7 consecutive days',
      icon: '🔥',
      points: 30,
      category: AchievementCategory.consistency,
    ),
    Achievement(
      id: 'streak_30_days',
      name: 'Month Master',
      description: 'Track expenses for 30 consecutive days',
      icon: '⭐',
      points: 100,
      category: AchievementCategory.consistency,
    ),
    Achievement(
      id: 'no_overspend_month',
      name: 'Discipline Champion',
      description: 'No budget exceeded for a full month',
      icon: '🎯',
      points: 100,
      category: AchievementCategory.budgeting,
    ),
  ];

  /// Get all achievements with unlock status
  List<Achievement> getAllAchievements(Set<String> unlockedIds) {
    return _allAchievements.map((a) {
      if (unlockedIds.contains(a.id)) {
        return a.copyWith(isUnlocked: true);
      }
      return a;
    }).toList();
  }

  void dispose() {
    _scoreController.close();
    _achievementController.close();
  }
}

// ====== Data Classes ======

class FinanceScore {
  final int totalScore;
  final int budgetScore;
  final int savingsScore;
  final int consistencyScore;
  final int categorizationScore;
  final int goalScore;
  final int level;
  final String levelName;
  final int weeklyChange;
  final DateTime calculatedAt;
  final List<String> tips;

  const FinanceScore({
    required this.totalScore,
    required this.budgetScore,
    required this.savingsScore,
    required this.consistencyScore,
    required this.categorizationScore,
    required this.goalScore,
    required this.level,
    required this.levelName,
    this.weeklyChange = 0,
    required this.calculatedAt,
    this.tips = const [],
  });

  /// Score breakdown as list for display
  List<ScoreBreakdown> get breakdown => [
    ScoreBreakdown('Budget', budgetScore, 30, '📊'),
    ScoreBreakdown('Savings', savingsScore, 25, '💰'),
    ScoreBreakdown('Consistency', consistencyScore, 20, '🔥'),
    ScoreBreakdown('Categories', categorizationScore, 15, '🏷️'),
    ScoreBreakdown('Goals', goalScore, 10, '🎯'),
  ];

  /// Is score improving?
  bool get isImproving => weeklyChange > 0;
}

class ScoreBreakdown {
  final String name;
  final int score;
  final int weight;
  final String emoji;

  const ScoreBreakdown(this.name, this.score, this.weight, this.emoji);

  double get weighted => score * (weight / 100);
}

enum AchievementCategory {
  beginner,
  budgeting,
  savings,
  tracking,
  consistency,
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int points;
  final AchievementCategory category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int? progress;
  final int? maxProgress;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.points,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress,
    this.maxProgress,
  });

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? progress,
  }) {
    return Achievement(
      id: id,
      name: name,
      description: description,
      icon: icon,
      points: points,
      category: category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      maxProgress: maxProgress,
    );
  }
}
