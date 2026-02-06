import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../data/local/daos/education_dao.dart';
import '../../domain/entities/entities.dart';

/// SS-090, SS-091, SS-092, SS-093: Financial Educator service
/// Provides personalized tips, health scoring, and improvement suggestions

class FinancialEducatorService {
  final EducationDao _educationDao;
  static const uuid = Uuid();

  FinancialEducatorService({required EducationDao educationDao})
      : _educationDao = educationDao;

  // ====== SS-091: Personalized Tips ======

  /// Generate personalized tips based on spending patterns
  Future<List<FinancialTip>> generatePersonalizedTips({
    required SpendingPattern pattern,
    int limit = 2,
  }) async {
    final recentlyShown = await _educationDao.getRecentlyShownTipIds(days: 7);
    final tips = <FinancialTip>[];

    // Pattern-based tips
    tips.addAll(_generatePatternTips(pattern, recentlyShown));

    // Spending reduction tips
    tips.addAll(_generateSpendingReductionTips(pattern, recentlyShown));

    // Achievement tips
    tips.addAll(_generateAchievementTips(pattern, recentlyShown));

    // Educational tips
    tips.addAll(_generateEducationalTips(recentlyShown));

    // Time-based tips (e.g., weekend tips on Friday)
    tips.addAll(_generateTimedTips(recentlyShown));

    // Sort by priority and filter already shown
    final filtered = tips
        .where((t) => !recentlyShown.contains(t.id))
        .toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    return filtered.take(limit).toList();
  }

  List<FinancialTip> _generatePatternTips(
      SpendingPattern pattern, Set<String> shown) {
    final tips = <FinancialTip>[];

    // Weekend spending pattern
    if (pattern.weekendSpendingRatio > 1.5) {
      tips.add(FinancialTip(
        id: 'pattern_weekend_high',
        type: TipType.patternObservation,
        title: 'Weekend Spender Alert! 🎉',
        message:
            'You spend ${(pattern.weekendSpendingRatio * 100).toInt() - 100}% more on weekends. '
            'Try planning weekend activities in advance to stay on budget.',
        priority: 7,
        relatedTopic: FinancialTopic.spending,
      ));
    }

    // Late night spending
    if (pattern.lateNightSpendingPercent > 20) {
      tips.add(FinancialTip(
        id: 'pattern_late_night',
        type: TipType.patternObservation,
        title: 'Night Owl Spending 🦉',
        message:
            '${pattern.lateNightSpendingPercent.toInt()}% of your spending happens after 10 PM. '
            'Late-night purchases are often impulsive - sleep on it!',
        priority: 6,
        actionLabel: 'Learn about impulse control',
        relatedTopic: FinancialTopic.spending,
      ));
    }

    // Single category dominance
    if (pattern.topCategoryPercent > 40) {
      tips.add(FinancialTip(
        id: 'pattern_category_${pattern.topCategory}',
        type: TipType.patternObservation,
        title: 'Category Focus 📊',
        message:
            '${pattern.topCategoryPercent.toInt()}% of your spending goes to ${pattern.topCategory}. '
            'Consider if this aligns with your priorities.',
        priority: 5,
        relatedTopic: FinancialTopic.budgeting,
      ));
    }

    return tips;
  }

  List<FinancialTip> _generateSpendingReductionTips(
      SpendingPattern pattern, Set<String> shown) {
    final tips = <FinancialTip>[];

    // Food spending high
    if (pattern.categoryPercentages['food'] != null &&
        pattern.categoryPercentages['food']! > 30) {
      tips.add(FinancialTip(
        id: 'reduction_food_high',
        type: TipType.spendingReduction,
        title: 'Food Budget Alert 🍔',
        message:
            'You spent ${pattern.categoryPercentages['food']!.toInt()}% on food. '
            'Try meal prepping on Sunday - it could save you ₹2000/month!',
        priority: 8,
        actionLabel: 'Set food budget',
        relatedTopic: FinancialTopic.spending,
      ));
    }

    // Subscription overload
    if (pattern.subscriptionCount > 5) {
      tips.add(FinancialTip(
        id: 'reduction_subs',
        type: TipType.spendingReduction,
        title: 'Subscription Audit Time 📱',
        message:
            'You have ${pattern.subscriptionCount} active subscriptions. '
            'Review them - unused ones cost ₹${pattern.monthlySubscriptionCost}/month.',
        priority: 7,
        actionLabel: 'Review subscriptions',
        relatedTopic: FinancialTopic.spending,
      ));
    }

    return tips;
  }

  List<FinancialTip> _generateAchievementTips(
      SpendingPattern pattern, Set<String> shown) {
    final tips = <FinancialTip>[];

    // Under budget achievement
    if (pattern.budgetUtilization < 80) {
      tips.add(FinancialTip(
        id: 'achievement_under_budget_${DateTime.now().month}',
        type: TipType.achievement,
        title: 'Budget Champion! 🏆',
        message:
            'Amazing! You used only ${pattern.budgetUtilization.toInt()}% of your budget. '
            'Transfer the savings to your goals!',
        priority: 9,
        relatedTopic: FinancialTopic.budgeting,
      ));
    }

    // Savings milestone
    if (pattern.savingsRate >= 20) {
      tips.add(FinancialTip(
        id: 'achievement_savings_${pattern.savingsRate.toInt()}',
        type: TipType.achievement,
        title: 'Super Saver! 💰',
        message:
            'You saved ${pattern.savingsRate.toInt()}% of your income this month. '
            'That\'s excellent discipline!',
        priority: 8,
        relatedTopic: FinancialTopic.saving,
      ));
    }

    return tips;
  }

  List<FinancialTip> _generateEducationalTips(Set<String> shown) {
    final tips = <FinancialTip>[];
    final random = Random();

    final educationalContent = [
      const FinancialTip(
        id: 'edu_50_30_20',
        type: TipType.educational,
        title: 'The 50/30/20 Rule 📚',
        message:
            '50% needs, 30% wants, 20% savings. This simple rule can transform your finances!',
        priority: 4,
        actionLabel: 'Learn more',
        relatedTopic: FinancialTopic.budgeting,
      ),
      const FinancialTip(
        id: 'edu_compound_interest',
        type: TipType.educational,
        title: 'The Magic of Compound Interest ✨',
        message:
            '₹1000/month at 12% annual return becomes ₹35 lakhs in 30 years. Start early!',
        priority: 4,
        actionLabel: 'Learn more',
        relatedTopic: FinancialTopic.investing,
      ),
      const FinancialTip(
        id: 'edu_emergency_fund',
        type: TipType.educational,
        title: 'Emergency Fund Basics 🏥',
        message:
            'Aim for 3-6 months of expenses saved. Start with just ₹500/week!',
        priority: 4,
        actionLabel: 'Start saving',
        relatedTopic: FinancialTopic.saving,
      ),
      const FinancialTip(
        id: 'edu_credit_score',
        type: TipType.educational,
        title: 'Credit Score 101 💳',
        message:
            'Your credit score affects loan rates. Pay bills on time and keep credit usage under 30%.',
        priority: 4,
        actionLabel: 'Learn more',
        relatedTopic: FinancialTopic.credit,
      ),
    ];

    // Pick random educational tip not recently shown
    final available = educationalContent.where((t) => !shown.contains(t.id)).toList();
    if (available.isNotEmpty) {
      tips.add(available[random.nextInt(available.length)]);
    }

    return tips;
  }

  List<FinancialTip> _generateTimedTips(Set<String> shown) {
    final tips = <FinancialTip>[];
    final now = DateTime.now();
    final dayOfWeek = now.weekday;

    // Friday tip for weekend spending
    if (dayOfWeek == DateTime.friday) {
      tips.add(FinancialTip(
        id: 'timed_friday_weekend',
        type: TipType.actionable,
        title: 'Weekend Ahead! 🗓️',
        message:
            'Plan your weekend spending now. Set a ₹1000 fun budget and stick to it!',
        priority: 6,
        validUntil: now.add(const Duration(days: 1)),
        relatedTopic: FinancialTopic.spending,
      ));
    }

    // Month end tip
    if (now.day >= 25) {
      tips.add(FinancialTip(
        id: 'timed_month_end_${now.month}',
        type: TipType.actionable,
        title: 'Month-End Review 📋',
        message:
            'Only ${30 - now.day} days left this month. Check your budget status!',
        priority: 5,
        validUntil: DateTime(now.year, now.month + 1, 1),
        relatedTopic: FinancialTopic.budgeting,
      ));
    }

    return tips;
  }

  /// Record that a tip was shown
  Future<void> recordShownTip(String tipId) async {
    await _educationDao.recordShownTip(ShownTip(
      id: uuid.v4(),
      tipId: tipId,
      shownAt: DateTime.now(),
    ));
  }

  /// Update tip interaction (dismissed, saved, acted on)
  Future<void> updateTipInteraction(
    String id, {
    bool? dismissed,
    bool? saved,
    bool? actedOn,
  }) async {
    await _educationDao.updateTipInteraction(
      id,
      dismissed: dismissed,
      saved: saved,
      actedOn: actedOn,
    );
  }

  // ====== SS-092: Financial Health Score ======

  /// Calculate comprehensive financial health score
  Future<FinancialHealthScore> calculateHealthScore({
    required SpendingPattern spendingPattern,
    required BudgetStatus budgetStatus,
    required SavingsData savingsData,
  }) async {
    // Calculate sub-scores
    final budgetingScore = _calculateBudgetingScore(budgetStatus);
    final savingsScore = _calculateSavingsScore(savingsData);
    final disciplineScore = _calculateDisciplineScore(spendingPattern);
    final literacyScore = await _calculateLiteracyScore();

    // Weighted average
    final overall = (budgetingScore * 0.30 +
            savingsScore * 0.25 +
            disciplineScore * 0.25 +
            literacyScore * 0.20)
        .round();

    // Determine trend
    final trend = _determineTrend(overall, spendingPattern.previousMonthScore);

    // Generate improvements
    final improvements = _generateImprovements(
      budgetingScore: budgetingScore,
      savingsScore: savingsScore,
      disciplineScore: disciplineScore,
      literacyScore: literacyScore,
    );

    return FinancialHealthScore(
      overall: overall.clamp(0, 100),
      budgetingScore: budgetingScore,
      savingsScore: savingsScore,
      spendingDiscipline: disciplineScore,
      financialLiteracy: literacyScore,
      trend: trend,
      improvements: improvements,
      calculatedAt: DateTime.now(),
    );
  }

  int _calculateBudgetingScore(BudgetStatus status) {
    int score = 0;

    // Has budgets set? (20 points)
    if (status.hasBudgets) score += 20;

    // Budget utilization (40 points)
    if (status.averageUtilization <= 80) {
      score += 40;
    } else if (status.averageUtilization <= 100) {
      score += (40 * (100 - status.averageUtilization) / 20).round();
    }

    // Category budgets set (20 points)
    score += (status.categoryBudgetCount / 5 * 20).round().clamp(0, 20);

    // Consistency - stayed within budget (20 points)
    score += (status.daysUnderBudget / 30 * 20).round().clamp(0, 20);

    return score.clamp(0, 100);
  }

  int _calculateSavingsScore(SavingsData data) {
    int score = 0;

    // Savings rate (50 points)
    if (data.savingsRate >= 20) {
      score += 50;
    } else if (data.savingsRate >= 10) {
      score += (data.savingsRate * 2.5).round();
    } else {
      score += (data.savingsRate * 2).round();
    }

    // Consistency - saved every month (30 points)
    score += (data.consecutiveMonthsSaving / 6 * 30).round().clamp(0, 30);

    // Emergency fund progress (20 points)
    score += (data.emergencyFundProgress * 20).round().clamp(0, 20);

    return score.clamp(0, 100);
  }

  int _calculateDisciplineScore(SpendingPattern pattern) {
    int score = 100;

    // Deduct for impulsive patterns
    if (pattern.weekendSpendingRatio > 1.5) score -= 15;
    if (pattern.lateNightSpendingPercent > 20) score -= 15;
    if (pattern.topCategoryPercent > 50) score -= 10;
    if (pattern.transactionFrequencyPerDay > 5) score -= 10;

    // Add for good patterns
    if (pattern.consistentSpendingDays > 20) score += 10;
    if (pattern.usedNotesOrTags) score += 5;

    return score.clamp(0, 100);
  }

  Future<int> _calculateLiteracyScore() async {
    final completedCount = (await _educationDao.getCompletedLessonIds()).length;
    final quizScore = await _educationDao.getTotalQuizScore();
    final quizCount = await _educationDao.getQuizzesTakenCount();

    int score = 0;

    // Lessons completed (50 points)
    score += (completedCount / 10 * 50).round().clamp(0, 50);

    // Quiz performance (50 points)
    if (quizCount > 0) {
      final avgQuiz = quizScore / quizCount;
      score += (avgQuiz / 100 * 50).round().clamp(0, 50);
    }

    return score.clamp(0, 100);
  }

  HealthTrend _determineTrend(int current, int? previous) {
    if (previous == null) return HealthTrend.stable;
    final diff = current - previous;
    if (diff > 5) return HealthTrend.improving;
    if (diff < -5) return HealthTrend.declining;
    return HealthTrend.stable;
  }

  // ====== SS-093: Improvement Suggestions ======

  List<String> _generateImprovements({
    required int budgetingScore,
    required int savingsScore,
    required int disciplineScore,
    required int literacyScore,
  }) {
    final improvements = <String>[];

    if (budgetingScore < 50) {
      improvements.add('Set up category budgets for your top 3 spending areas');
      improvements.add('Review your budget weekly instead of monthly');
    } else if (budgetingScore < 70) {
      improvements.add('Try reducing your food budget by 10% next month');
    }

    if (savingsScore < 50) {
      improvements.add('Start with saving just ₹100 per week');
      improvements.add('Set up automatic savings on payday');
    } else if (savingsScore < 70) {
      improvements.add('Increase your savings rate by 5%');
    }

    if (disciplineScore < 50) {
      improvements.add('Wait 24 hours before non-essential purchases over ₹500');
      improvements.add('Avoid shopping apps after 10 PM');
    } else if (disciplineScore < 70) {
      improvements.add('Plan your weekend spending in advance');
    }

    if (literacyScore < 50) {
      improvements.add('Complete 2 financial lessons this week');
      improvements.add('Take the budgeting basics quiz');
    }

    return improvements.take(4).toList();
  }

  /// Get specific improvement suggestions for weak areas
  Future<List<Improvement>> suggestImprovements({
    required List<String> weakAreas,
  }) async {
    final suggestions = <Improvement>[];

    for (final area in weakAreas) {
      switch (area.toLowerCase()) {
        case 'budgeting':
          suggestions.add(const Improvement(
            id: 'improve_budget_1',
            title: 'Set a Daily Food Budget',
            description:
                'Food is often the biggest spending category. Start with ₹200/day.',
            impact: 4,
            targetArea: 'budgeting',
            steps: [
              'Open Budgets section',
              'Create new budget for Food category',
              'Set daily limit of ₹200',
              'Enable notifications at 80%'
            ],
          ));
          break;
        case 'savings':
          suggestions.add(const Improvement(
            id: 'improve_savings_1',
            title: 'Start a ₹100/Week Challenge',
            description: 'Small consistent savings beat large irregular ones.',
            impact: 5,
            targetArea: 'savings',
            steps: [
              'Set a weekly reminder for Sunday',
              'Transfer ₹100 to a savings account',
              'Track your streak in the app',
              'Increase by ₹50 after 4 weeks'
            ],
          ));
          break;
        case 'discipline':
          suggestions.add(const Improvement(
            id: 'improve_discipline_1',
            title: '24-Hour Rule for Big Purchases',
            description: 'Wait a day before buying anything over ₹500.',
            impact: 4,
            targetArea: 'discipline',
            steps: [
              'Add item to your wishlist instead of buying',
              'Wait 24 hours',
              'Ask: Do I still want this?',
              'Check if it fits your budget'
            ],
          ));
          break;
        case 'literacy':
          suggestions.add(const Improvement(
            id: 'improve_literacy_1',
            title: 'Complete Budgeting 101',
            description: 'Learn the 50/30/20 rule and apply it to your finances.',
            impact: 3,
            targetArea: 'literacy',
            actionLabel: 'Start Lesson',
            actionRoute: '/learn/budgeting/basics',
            steps: [
              'Watch the 3-minute lesson',
              'Take the quiz',
              'Apply the rule to your income'
            ],
          ));
          break;
      }
    }

    return suggestions;
  }
}

/// Spending pattern data for analysis
class SpendingPattern {
  final double weekendSpendingRatio; // Ratio of weekend to weekday spending
  final double lateNightSpendingPercent; // % after 10 PM
  final String topCategory;
  final double topCategoryPercent;
  final Map<String, double> categoryPercentages;
  final int subscriptionCount;
  final int monthlySubscriptionCost;
  final double budgetUtilization;
  final double savingsRate;
  final int transactionFrequencyPerDay;
  final int consistentSpendingDays;
  final bool usedNotesOrTags;
  final int? previousMonthScore;

  const SpendingPattern({
    required this.weekendSpendingRatio,
    required this.lateNightSpendingPercent,
    required this.topCategory,
    required this.topCategoryPercent,
    required this.categoryPercentages,
    required this.subscriptionCount,
    required this.monthlySubscriptionCost,
    required this.budgetUtilization,
    required this.savingsRate,
    required this.transactionFrequencyPerDay,
    required this.consistentSpendingDays,
    required this.usedNotesOrTags,
    this.previousMonthScore,
  });
}

/// Budget status for health score
class BudgetStatus {
  final bool hasBudgets;
  final double averageUtilization;
  final int categoryBudgetCount;
  final int daysUnderBudget;

  const BudgetStatus({
    required this.hasBudgets,
    required this.averageUtilization,
    required this.categoryBudgetCount,
    required this.daysUnderBudget,
  });
}

/// Savings data for health score
class SavingsData {
  final double savingsRate;
  final int consecutiveMonthsSaving;
  final double emergencyFundProgress; // 0-1

  const SavingsData({
    required this.savingsRate,
    required this.consecutiveMonthsSaving,
    required this.emergencyFundProgress,
  });
}
