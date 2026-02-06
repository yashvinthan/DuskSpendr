import 'package:flutter/material.dart';

/// SS-071 to SS-080: Student Dashboard UI
/// Modern student-themed interface with gamification

/// Gamification Service
class GamificationService {
  final Map<String, Achievement> _achievements = {};
  final List<AchievementUnlock> _unlockedAchievements = [];
  int _totalXp = 0;
  int _currentStreak = 0;

  GamificationService() {
    _initializeAchievements();
  }

  void _initializeAchievements() {
    final defaultAchievements = [
      // Saving Achievements
      const Achievement(
        id: 'first_save',
        name: 'First Steps',
        description: 'Save your first ₹100',
        iconPath: 'assets/icons/achievements/first_save.png',
        xpReward: 50,
        tier: AchievementTier.bronze,
        category: AchievementCategory.saving,
      ),
      const Achievement(
        id: 'week_saver',
        name: 'Week Warrior',
        description: 'Save money for 7 consecutive days',
        iconPath: 'assets/icons/achievements/week_saver.png',
        xpReward: 100,
        tier: AchievementTier.silver,
        category: AchievementCategory.saving,
      ),
      const Achievement(
        id: 'month_master',
        name: 'Month Master',
        description: 'Stay under budget for entire month',
        iconPath: 'assets/icons/achievements/month_master.png',
        xpReward: 300,
        tier: AchievementTier.gold,
        category: AchievementCategory.saving,
      ),

      // Budget Achievements
      const Achievement(
        id: 'budget_creator',
        name: 'Budget Boss',
        description: 'Create your first budget',
        iconPath: 'assets/icons/achievements/budget_creator.png',
        xpReward: 25,
        tier: AchievementTier.bronze,
        category: AchievementCategory.budgeting,
      ),
      const Achievement(
        id: 'budget_streak_7',
        name: 'Discipline Master',
        description: 'Stay under all budgets for 7 days',
        iconPath: 'assets/icons/achievements/budget_streak.png',
        xpReward: 150,
        tier: AchievementTier.silver,
        category: AchievementCategory.budgeting,
      ),

      // Learning Achievements
      const Achievement(
        id: 'first_lesson',
        name: 'Knowledge Seeker',
        description: 'Complete your first financial lesson',
        iconPath: 'assets/icons/achievements/first_lesson.png',
        xpReward: 30,
        tier: AchievementTier.bronze,
        category: AchievementCategory.learning,
      ),
      const Achievement(
        id: 'quiz_master',
        name: 'Quiz Master',
        description: 'Score 100% on 5 quizzes',
        iconPath: 'assets/icons/achievements/quiz_master.png',
        xpReward: 200,
        tier: AchievementTier.gold,
        category: AchievementCategory.learning,
      ),

      // Tracking Achievements
      const Achievement(
        id: 'tracker_50',
        name: 'Transaction Tracker',
        description: 'Track 50 transactions',
        iconPath: 'assets/icons/achievements/tracker.png',
        xpReward: 75,
        tier: AchievementTier.bronze,
        category: AchievementCategory.tracking,
      ),
      const Achievement(
        id: 'categorizer',
        name: 'Organized One',
        description: 'Categorize 100 transactions',
        iconPath: 'assets/icons/achievements/categorizer.png',
        xpReward: 100,
        tier: AchievementTier.silver,
        category: AchievementCategory.tracking,
      ),

      // Social Achievements
      const Achievement(
        id: 'first_split',
        name: 'Fair Friend',
        description: 'Split your first expense',
        iconPath: 'assets/icons/achievements/first_split.png',
        xpReward: 40,
        tier: AchievementTier.bronze,
        category: AchievementCategory.social,
      ),
      const Achievement(
        id: 'settlement_king',
        name: 'Settlement King',
        description: 'Settle 10 group expenses',
        iconPath: 'assets/icons/achievements/settlement.png',
        xpReward: 150,
        tier: AchievementTier.silver,
        category: AchievementCategory.social,
      ),

      // Streak Achievements
      const Achievement(
        id: 'streak_30',
        name: 'Habit Former',
        description: 'Use app for 30 consecutive days',
        iconPath: 'assets/icons/achievements/streak_30.png',
        xpReward: 500,
        tier: AchievementTier.platinum,
        category: AchievementCategory.engagement,
      ),
    ];

    for (final achievement in defaultAchievements) {
      _achievements[achievement.id] = achievement;
    }
  }

  /// Check and unlock achievement
  AchievementUnlock? checkAchievement(String achievementId) {
    final achievement = _achievements[achievementId];
    if (achievement == null) return null;

    final alreadyUnlocked = _unlockedAchievements.any(
      (u) => u.achievementId == achievementId,
    );
    if (alreadyUnlocked) return null;

    final unlock = AchievementUnlock(
      achievementId: achievementId,
      unlockedAt: DateTime.now(),
    );
    _unlockedAchievements.add(unlock);
    _totalXp += achievement.xpReward;

    return unlock;
  }

  /// Get current level from XP
  UserLevel getCurrentLevel() {
    int level = 1;
    int xpForNextLevel = 100;
    int remainingXp = _totalXp;

    while (remainingXp >= xpForNextLevel && level < 100) {
      remainingXp -= xpForNextLevel;
      level++;
      xpForNextLevel = (xpForNextLevel * 1.5).round();
    }

    return UserLevel(
      level: level,
      currentXp: _totalXp,
      xpForNext: xpForNextLevel,
      xpInCurrentLevel: remainingXp,
      title: _getLevelTitle(level),
    );
  }

  String _getLevelTitle(int level) {
    if (level >= 50) return 'Finance Master';
    if (level >= 40) return 'Money Guru';
    if (level >= 30) return 'Budget Expert';
    if (level >= 20) return 'Savings Pro';
    if (level >= 10) return 'Smart Spender';
    if (level >= 5) return 'Rising Star';
    return 'Finance Beginner';
  }

  /// Get all achievements with unlock status
  List<AchievementStatus> getAllAchievements() {
    return _achievements.values.map((achievement) {
      final unlock = _unlockedAchievements.firstWhere(
        (u) => u.achievementId == achievement.id,
        orElse: () => AchievementUnlock(achievementId: '', unlockedAt: DateTime(1970)),
      );

      return AchievementStatus(
        achievement: achievement,
        isUnlocked: unlock.achievementId.isNotEmpty,
        unlockedAt: unlock.achievementId.isNotEmpty ? unlock.unlockedAt : null,
      );
    }).toList();
  }

  /// Record daily check-in
  StreakUpdate recordCheckIn() {
    final previousStreak = _currentStreak;
    _currentStreak++;

    // Bonus XP for streaks
    int xpBonus = 5;
    if (_currentStreak >= 30) {
      xpBonus = 25;
    } else if (_currentStreak >= 7) {
      xpBonus = 15;
    }
    _totalXp += xpBonus;

    return StreakUpdate(
      previousStreak: previousStreak,
      currentStreak: _currentStreak,
      xpEarned: xpBonus,
    );
  }

  int get currentStreak => _currentStreak;
  int get totalXp => _totalXp;
}

/// Chart Data Generator for Dashboard
class DashboardChartService {
  /// Generate spending pie chart data
  List<ChartSegment> getSpendingByCategory(Map<String, int> categoryTotals) {
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF10B981), // Emerald
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFEF4444), // Red
      const Color(0xFF14B8A6), // Teal
    ];

    final total = categoryTotals.values.fold<int>(0, (s, v) => s + v);
    if (total == 0) return [];

    int index = 0;
    return categoryTotals.entries.map((e) {
      final percentage = e.value / total;
      final segment = ChartSegment(
        label: e.key,
        value: e.value,
        percentage: percentage,
        color: colors[index % colors.length],
      );
      index++;
      return segment;
    }).toList();
  }

  /// Generate spending trend line data
  List<TrendPoint> getSpendingTrend(
    List<DailySpending> dailyData,
    int days,
  ) {
    final now = DateTime.now();
    final points = <TrendPoint>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayData = dailyData.firstWhere(
        (d) => _isSameDay(d.date, date),
        orElse: () => DailySpending(date: date, amountPaisa: 0),
      );

      points.add(TrendPoint(
        date: date,
        value: dayData.amountPaisa.toDouble(),
      ));
    }

    return points;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Generate budget progress bar data
  List<BudgetProgressBar> getBudgetProgressBars(
    List<BudgetWithSpent> budgets,
  ) {
    return budgets.map((b) {
      final percentage = b.limitPaisa > 0
          ? (b.spentPaisa / b.limitPaisa).clamp(0.0, 1.5)
          : 0.0;

      Color color;
      if (percentage >= 1.0) {
        color = const Color(0xFFEF4444); // Red
      } else if (percentage >= 0.8) {
        color = const Color(0xFFF59E0B); // Amber
      } else {
        color = const Color(0xFF10B981); // Green
      }

      return BudgetProgressBar(
        name: b.name,
        percentage: percentage,
        spentPaisa: b.spentPaisa,
        limitPaisa: b.limitPaisa,
        color: color,
      );
    }).toList();
  }

  /// Generate income vs expense comparison
  IncomeExpenseComparison getIncomeExpenseData(
    int incomePaisa,
    int expensePaisa,
  ) {
    final savings = incomePaisa - expensePaisa;
    final savingsRate = incomePaisa > 0 ? savings / incomePaisa : 0.0;

    return IncomeExpenseComparison(
      incomePaisa: incomePaisa,
      expensePaisa: expensePaisa,
      savingsPaisa: savings,
      savingsRatePercent: savingsRate * 100,
    );
  }
}

/// Onboarding Flow
class OnboardingService {
  final List<OnboardingStep> _steps = [
    const OnboardingStep(
      id: 'welcome',
      title: 'Welcome to DuskSpendr! 🌙',
      description: 'Your privacy-first finance buddy designed for students',
      imagePath: 'assets/images/onboarding/welcome.png',
      actions: [],
    ),
    const OnboardingStep(
      id: 'security',
      title: 'Your Data, Your Control',
      description: 'All data stays on your device. We never see your finances.',
      imagePath: 'assets/images/onboarding/security.png',
      actions: [
        OnboardingAction(
          label: 'Set up PIN',
          actionId: 'setup_pin',
        ),
        OnboardingAction(
          label: 'Enable Biometric',
          actionId: 'setup_biometric',
        ),
      ],
    ),
    const OnboardingStep(
      id: 'accounts',
      title: 'Connect Your Accounts',
      description: 'Link banks, UPI, and wallets to auto-track transactions',
      imagePath: 'assets/images/onboarding/accounts.png',
      actions: [
        OnboardingAction(
          label: 'Link Now',
          actionId: 'link_accounts',
        ),
        OnboardingAction(
          label: 'Skip for Now',
          actionId: 'skip_linking',
        ),
      ],
    ),
    const OnboardingStep(
      id: 'sms',
      title: 'Smart SMS Tracking',
      description: 'Grant SMS access to auto-detect transactions from banks',
      imagePath: 'assets/images/onboarding/sms.png',
      actions: [
        OnboardingAction(
          label: 'Grant Permission',
          actionId: 'grant_sms',
        ),
        OnboardingAction(
          label: 'Manual Entry Only',
          actionId: 'skip_sms',
        ),
      ],
    ),
    const OnboardingStep(
      id: 'budget',
      title: 'Set Your First Budget',
      description: 'Start with a monthly spending limit',
      imagePath: 'assets/images/onboarding/budget.png',
      actions: [
        OnboardingAction(
          label: 'Create Budget',
          actionId: 'create_budget',
        ),
      ],
    ),
    const OnboardingStep(
      id: 'complete',
      title: 'You\'re All Set! 🎉',
      description: 'Start your journey to financial freedom',
      imagePath: 'assets/images/onboarding/complete.png',
      actions: [
        OnboardingAction(
          label: 'Get Started',
          actionId: 'finish',
        ),
      ],
    ),
  ];

  List<OnboardingStep> get steps => _steps;

  OnboardingStep getStep(int index) {
    if (index < 0 || index >= _steps.length) {
      return _steps.last;
    }
    return _steps[index];
  }

  bool isLastStep(int index) => index >= _steps.length - 1;
}

/// Quick Actions Widget Data
class QuickActionsService {
  List<QuickAction> getQuickActions() {
    return [
      const QuickAction(
        id: 'add_expense',
        label: 'Add Expense',
        icon: Icons.remove_circle_outline,
        color: Color(0xFFEF4444),
        route: '/add-transaction?type=expense',
      ),
      const QuickAction(
        id: 'add_income',
        label: 'Add Income',
        icon: Icons.add_circle_outline,
        color: Color(0xFF10B981),
        route: '/add-transaction?type=income',
      ),
      const QuickAction(
        id: 'split',
        label: 'Split Expense',
        icon: Icons.call_split,
        color: Color(0xFF6366F1),
        route: '/split-expense',
      ),
      const QuickAction(
        id: 'scan',
        label: 'Scan Receipt',
        icon: Icons.document_scanner_outlined,
        color: Color(0xFF8B5CF6),
        route: '/scan-receipt',
      ),
    ];
  }
}

// ====== Data Classes ======

enum AchievementTier { bronze, silver, gold, platinum }

enum AchievementCategory {
  saving,
  budgeting,
  learning,
  tracking,
  social,
  engagement,
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final int xpReward;
  final AchievementTier tier;
  final AchievementCategory category;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.xpReward,
    required this.tier,
    required this.category,
  });
}

class AchievementUnlock {
  final String achievementId;
  final DateTime unlockedAt;

  const AchievementUnlock({
    required this.achievementId,
    required this.unlockedAt,
  });
}

class AchievementStatus {
  final Achievement achievement;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementStatus({
    required this.achievement,
    required this.isUnlocked,
    this.unlockedAt,
  });
}

class UserLevel {
  final int level;
  final int currentXp;
  final int xpForNext;
  final int xpInCurrentLevel;
  final String title;

  const UserLevel({
    required this.level,
    required this.currentXp,
    required this.xpForNext,
    required this.xpInCurrentLevel,
    required this.title,
  });
}

class StreakUpdate {
  final int previousStreak;
  final int currentStreak;
  final int xpEarned;

  const StreakUpdate({
    required this.previousStreak,
    required this.currentStreak,
    required this.xpEarned,
  });
}

class ChartSegment {
  final String label;
  final int value;
  final double percentage;
  final Color color;

  const ChartSegment({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });
}

class TrendPoint {
  final DateTime date;
  final double value;

  const TrendPoint({
    required this.date,
    required this.value,
  });
}

class DailySpending {
  final DateTime date;
  final int amountPaisa;

  const DailySpending({
    required this.date,
    required this.amountPaisa,
  });
}

class BudgetWithSpent {
  final String name;
  final int limitPaisa;
  final int spentPaisa;

  const BudgetWithSpent({
    required this.name,
    required this.limitPaisa,
    required this.spentPaisa,
  });
}

class BudgetProgressBar {
  final String name;
  final double percentage;
  final int spentPaisa;
  final int limitPaisa;
  final Color color;

  const BudgetProgressBar({
    required this.name,
    required this.percentage,
    required this.spentPaisa,
    required this.limitPaisa,
    required this.color,
  });
}

class IncomeExpenseComparison {
  final int incomePaisa;
  final int expensePaisa;
  final int savingsPaisa;
  final double savingsRatePercent;

  const IncomeExpenseComparison({
    required this.incomePaisa,
    required this.expensePaisa,
    required this.savingsPaisa,
    required this.savingsRatePercent,
  });
}

class OnboardingStep {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final List<OnboardingAction> actions;

  const OnboardingStep({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.actions,
  });
}

class OnboardingAction {
  final String label;
  final String actionId;

  const OnboardingAction({
    required this.label,
    required this.actionId,
  });
}

class QuickAction {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  const QuickAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });
}
