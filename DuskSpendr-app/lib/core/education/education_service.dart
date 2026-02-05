/// SS-081 to SS-088: Financial Education Module
/// AI Insights, Tips, Lessons, Quizzes

/// AI-Powered Financial Insights
class InsightsEngine {
  /// Analyze spending and generate insights
  List<FinancialInsight> generateInsights({
    required SpendingData spendingData,
    required List<BudgetData> budgets,
    required UserProfile profile,
  }) {
    final insights = <FinancialInsight>[];

    // Spending pattern insights
    insights.addAll(_analyzeSpendingPatterns(spendingData));

    // Budget insights
    insights.addAll(_analyzeBudgets(budgets, spendingData));

    // Savings opportunities
    insights.addAll(_findSavingsOpportunities(spendingData, profile));

    // Comparison insights
    insights.addAll(_generateComparisons(spendingData, profile));

    // Sort by priority
    insights.sort((a, b) => b.priority.compareTo(a.priority));

    return insights.take(5).toList();
  }

  List<FinancialInsight> _analyzeSpendingPatterns(SpendingData data) {
    final insights = <FinancialInsight>[];

    // Weekend vs weekday spending
    if (data.weekendSpendingPaisa > data.weekdaySpendingPaisa * 1.5) {
      insights.add(FinancialInsight(
        id: 'weekend_spending',
        type: InsightType.pattern,
        title: 'Weekend Splurge Alert',
        description: 'You spend ${((data.weekendSpendingPaisa / data.weekdaySpendingPaisa - 1) * 100).round()}% more on weekends. Consider planning weekend activities.',
        priority: 8,
        actionable: true,
        suggestedAction: 'Set a weekend budget',
        potentialSavingsPaisa: (data.weekendSpendingPaisa * 0.2).round(),
      ));
    }

    // Category concentration
    final topCategory = data.categoryBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    final totalSpending = data.categoryBreakdown.values.fold<int>(0, (s, v) => s + v);
    final topCategoryPercent = topCategory.value / totalSpending;

    if (topCategoryPercent > 0.4) {
      insights.add(FinancialInsight(
        id: 'category_concentration',
        type: InsightType.pattern,
        title: '${topCategory.key} Dominates Spending',
        description: '${(topCategoryPercent * 100).round()}% of your spending is on ${topCategory.key}. Review if this aligns with your priorities.',
        priority: 6,
        actionable: true,
        suggestedAction: 'Review ${topCategory.key} expenses',
      ));
    }

    // Subscription creep
    if (data.subscriptionsPaisa > totalSpending * 0.15) {
      insights.add(FinancialInsight(
        id: 'subscription_creep',
        type: InsightType.warning,
        title: 'Subscription Overload',
        description: 'Subscriptions are eating ${(data.subscriptionsPaisa / totalSpending * 100).round()}% of your budget. Review what you actually use.',
        priority: 7,
        actionable: true,
        suggestedAction: 'Audit subscriptions',
        potentialSavingsPaisa: (data.subscriptionsPaisa * 0.3).round(),
      ));
    }

    return insights;
  }

  List<FinancialInsight> _analyzeBudgets(
    List<BudgetData> budgets,
    SpendingData spending,
  ) {
    final insights = <FinancialInsight>[];

    for (final budget in budgets) {
      final percentUsed = budget.spentPaisa / budget.limitPaisa;

      // Approaching limit
      if (percentUsed >= 0.8 && percentUsed < 1.0) {
        final daysRemaining = budget.daysRemaining;
        insights.add(FinancialInsight(
          id: 'budget_warning_${budget.name}',
          type: InsightType.warning,
          title: '${budget.name} Budget at Risk',
          description: 'You\'ve used ${(percentUsed * 100).round()}% with $daysRemaining days left.',
          priority: 9,
          actionable: true,
          suggestedAction: 'Limit spending to ₹${(budget.limitPaisa - budget.spentPaisa) ~/ daysRemaining ~/ 100}/day',
        ));
      }

      // Under budget streak
      if (budget.consecutiveMonthsUnder >= 3) {
        insights.add(FinancialInsight(
          id: 'budget_streak_${budget.name}',
          type: InsightType.achievement,
          title: 'Budget Champion!',
          description: 'You\'ve stayed under ${budget.name} budget for ${budget.consecutiveMonthsUnder} months!',
          priority: 5,
          actionable: false,
        ));
      }
    }

    return insights;
  }

  List<FinancialInsight> _findSavingsOpportunities(
    SpendingData data,
    UserProfile profile,
  ) {
    final insights = <FinancialInsight>[];

    // Food delivery savings
    final foodDelivery = data.merchantBreakdown['FoodDelivery'] ?? 0;
    if (foodDelivery > 200000) { // ₹2000+
      insights.add(FinancialInsight(
        id: 'food_delivery_savings',
        type: InsightType.opportunity,
        title: 'Cook More, Save More',
        description: 'You spent ₹${foodDelivery ~/ 100} on food delivery. Cooking 2x more weekly could save you ₹${foodDelivery ~/ 400}/month.',
        priority: 7,
        actionable: true,
        suggestedAction: 'Plan 2 home-cooked meals',
        potentialSavingsPaisa: foodDelivery ~/ 4,
      ));
    }

    // Transportation savings
    final transport = data.categoryBreakdown['Transport'] ?? 0;
    if (transport > 100000 && profile.hasPublicTransit) {
      insights.add(FinancialInsight(
        id: 'transport_savings',
        type: InsightType.opportunity,
        title: 'Public Transit Opportunity',
        description: 'Consider using public transit for routine trips. Potential savings of ₹${transport ~/ 300}/month.',
        priority: 5,
        actionable: true,
        suggestedAction: 'Get a transit pass',
        potentialSavingsPaisa: transport ~/ 3,
      ));
    }

    return insights;
  }

  List<FinancialInsight> _generateComparisons(
    SpendingData data,
    UserProfile profile,
  ) {
    final insights = <FinancialInsight>[];

    // Compare to previous month
    if (data.previousMonthTotal > 0) {
      final change = (data.currentMonthTotal - data.previousMonthTotal) / 
                     data.previousMonthTotal;

      if (change > 0.2) {
        insights.add(FinancialInsight(
          id: 'month_increase',
          type: InsightType.warning,
          title: 'Spending Up ${(change * 100).round()}%',
          description: 'This month\'s spending is significantly higher than last month.',
          priority: 8,
          actionable: true,
          suggestedAction: 'Review recent expenses',
        ));
      } else if (change < -0.1) {
        insights.add(FinancialInsight(
          id: 'month_decrease',
          type: InsightType.achievement,
          title: 'Great Progress!',
          description: 'You\'ve reduced spending by ${(-change * 100).round()}% this month!',
          priority: 4,
          actionable: false,
        ));
      }
    }

    return insights;
  }
}

/// Financial Tips Service
class TipsService {
  final List<FinancialTip> _tips = [];

  TipsService() {
    _initializeTips();
  }

  void _initializeTips() {
    final tips = [
      // Saving Tips
      FinancialTip(
        id: 'tip_50_30_20',
        title: 'The 50/30/20 Rule',
        content: 'Allocate 50% of income to needs, 30% to wants, and 20% to savings. As a student, try 60/25/15 if needed.',
        category: TipCategory.saving,
        difficulty: TipDifficulty.beginner,
        estimatedReadTime: 2,
      ),
      FinancialTip(
        id: 'tip_round_up',
        title: 'Round Up Savings',
        content: 'Round up every purchase to the nearest ₹10 or ₹100 and save the difference. It adds up quickly!',
        category: TipCategory.saving,
        difficulty: TipDifficulty.beginner,
        estimatedReadTime: 1,
      ),
      FinancialTip(
        id: 'tip_24_hour_rule',
        title: 'The 24-Hour Rule',
        content: 'Before any purchase over ₹500, wait 24 hours. Most impulse buys fade away.',
        category: TipCategory.saving,
        difficulty: TipDifficulty.beginner,
        estimatedReadTime: 1,
      ),

      // Budgeting Tips
      FinancialTip(
        id: 'tip_envelope',
        title: 'Digital Envelope Method',
        content: 'Create separate "envelopes" (budgets) for each spending category. When it\'s empty, stop spending.',
        category: TipCategory.budgeting,
        difficulty: TipDifficulty.intermediate,
        estimatedReadTime: 3,
      ),
      FinancialTip(
        id: 'tip_zero_budget',
        title: 'Zero-Based Budgeting',
        content: 'Give every rupee a job. Income minus all expenses (including savings) should equal zero.',
        category: TipCategory.budgeting,
        difficulty: TipDifficulty.advanced,
        estimatedReadTime: 4,
      ),

      // Student-Specific Tips
      FinancialTip(
        id: 'tip_student_discount',
        title: 'Student Discounts Everywhere',
        content: 'Always ask for student discounts. Spotify, Apple Music, Amazon Prime, software - many offer 50%+ off.',
        category: TipCategory.studentLife,
        difficulty: TipDifficulty.beginner,
        estimatedReadTime: 2,
      ),
      FinancialTip(
        id: 'tip_textbook',
        title: 'Textbook Savings',
        content: 'Buy used, rent, or use library copies. Check for PDF versions or older editions.',
        category: TipCategory.studentLife,
        difficulty: TipDifficulty.beginner,
        estimatedReadTime: 2,
      ),
      FinancialTip(
        id: 'tip_meal_prep',
        title: 'Meal Prep Sunday',
        content: 'Prepare meals for the week on Sunday. Saves money AND time during busy weekdays.',
        category: TipCategory.studentLife,
        difficulty: TipDifficulty.intermediate,
        estimatedReadTime: 3,
      ),

      // Investing Tips
      FinancialTip(
        id: 'tip_start_sip',
        title: 'Start with ₹500 SIP',
        content: 'Begin investing with a small SIP in an index fund. Time in market beats timing the market.',
        category: TipCategory.investing,
        difficulty: TipDifficulty.intermediate,
        estimatedReadTime: 3,
      ),
      FinancialTip(
        id: 'tip_compound',
        title: 'Power of Compounding',
        content: 'Starting at 20 vs 30 can double your retirement corpus. Even ₹100/month matters!',
        category: TipCategory.investing,
        difficulty: TipDifficulty.beginner,
        estimatedReadTime: 2,
      ),

      // Credit Tips
      FinancialTip(
        id: 'tip_credit_card',
        title: 'Credit Card Basics',
        content: 'Always pay full balance. Never just minimum. Interest rates are 30-40% per year!',
        category: TipCategory.credit,
        difficulty: TipDifficulty.beginner,
        estimatedReadTime: 2,
      ),
      FinancialTip(
        id: 'tip_bnpl',
        title: 'BNPL Warning',
        content: 'Buy Now Pay Later is still debt. Track all BNPL purchases like regular expenses.',
        category: TipCategory.credit,
        difficulty: TipDifficulty.beginner,
        estimatedReadTime: 2,
      ),
    ];

    _tips.addAll(tips);
  }

  /// Get tip of the day
  FinancialTip getTipOfTheDay() {
    final today = DateTime.now();
    final index = (today.year * 1000 + today.month * 100 + today.day) % _tips.length;
    return _tips[index];
  }

  /// Get tips by category
  List<FinancialTip> getTipsByCategory(TipCategory category) {
    return _tips.where((t) => t.category == category).toList();
  }

  /// Get contextual tips based on spending
  List<FinancialTip> getContextualTips(SpendingContext context) {
    final tips = <FinancialTip>[];

    if (context.isOverspendingFood) {
      tips.add(_tips.firstWhere((t) => t.id == 'tip_meal_prep'));
    }
    if (context.hasCreditCardDebt) {
      tips.add(_tips.firstWhere((t) => t.id == 'tip_credit_card'));
    }
    if (context.noInvestments) {
      tips.add(_tips.firstWhere((t) => t.id == 'tip_start_sip'));
    }

    return tips;
  }
}

/// Financial Lessons Module
class LessonsService {
  final List<FinancialLesson> _lessons = [];

  LessonsService() {
    _initializeLessons();
  }

  void _initializeLessons() {
    final lessons = [
      FinancialLesson(
        id: 'lesson_budgeting_101',
        title: 'Budgeting 101',
        description: 'Learn the fundamentals of creating and sticking to a budget',
        category: LessonCategory.budgeting,
        difficulty: LessonDifficulty.beginner,
        estimatedMinutes: 10,
        chapters: [
          LessonChapter(
            id: 'ch1',
            title: 'What is a Budget?',
            content: 'A budget is a spending plan based on income and expenses...',
            order: 1,
          ),
          LessonChapter(
            id: 'ch2',
            title: 'Track Your Income',
            content: 'List all sources of money: pocket money, part-time job, gifts...',
            order: 2,
          ),
          LessonChapter(
            id: 'ch3',
            title: 'Categorize Expenses',
            content: 'Group your spending: needs vs wants, fixed vs variable...',
            order: 3,
          ),
          LessonChapter(
            id: 'ch4',
            title: 'Set Limits',
            content: 'Assign a maximum amount to each category...',
            order: 4,
          ),
        ],
        quiz: LessonQuiz(
          questions: [
            QuizQuestion(
              id: 'q1',
              question: 'What percentage should go to savings in the 50/30/20 rule?',
              options: ['50%', '30%', '20%', '10%'],
              correctIndex: 2,
              explanation: '20% of income should be saved in the 50/30/20 rule.',
            ),
            QuizQuestion(
              id: 'q2',
              question: 'Which is a "need" expense?',
              options: ['Netflix subscription', 'Rent', 'Concert tickets', 'New sneakers'],
              correctIndex: 1,
              explanation: 'Rent is a necessity; the others are wants.',
            ),
          ],
          passingScore: 0.7,
        ),
        xpReward: 50,
      ),

      FinancialLesson(
        id: 'lesson_saving_goals',
        title: 'Setting Saving Goals',
        description: 'How to set and achieve financial goals as a student',
        category: LessonCategory.saving,
        difficulty: LessonDifficulty.beginner,
        estimatedMinutes: 8,
        chapters: [
          LessonChapter(
            id: 'ch1',
            title: 'SMART Goals',
            content: 'Goals should be Specific, Measurable, Achievable, Relevant, Time-bound...',
            order: 1,
          ),
          LessonChapter(
            id: 'ch2',
            title: 'Short-term vs Long-term',
            content: 'Emergency fund, phone upgrade vs car, house down payment...',
            order: 2,
          ),
          LessonChapter(
            id: 'ch3',
            title: 'Automating Savings',
            content: 'Set up automatic transfers on payday...',
            order: 3,
          ),
        ],
        quiz: LessonQuiz(
          questions: [
            QuizQuestion(
              id: 'q1',
              question: 'What does SMART stand for in goal-setting?',
              options: [
                'Simple, Manageable, Achievable, Relevant, Timely',
                'Specific, Measurable, Achievable, Relevant, Time-bound',
                'Strategic, Meaningful, Actionable, Realistic, Tracked',
                'Simple, Measured, Attainable, Reasonable, Tested',
              ],
              correctIndex: 1,
              explanation: 'SMART = Specific, Measurable, Achievable, Relevant, Time-bound.',
            ),
          ],
          passingScore: 0.7,
        ),
        xpReward: 40,
      ),

      FinancialLesson(
        id: 'lesson_investing_basics',
        title: 'Investing Basics',
        description: 'Introduction to investing for beginners',
        category: LessonCategory.investing,
        difficulty: LessonDifficulty.intermediate,
        estimatedMinutes: 15,
        chapters: [
          LessonChapter(
            id: 'ch1',
            title: 'Why Invest?',
            content: 'Beat inflation, grow wealth, achieve long-term goals...',
            order: 1,
          ),
          LessonChapter(
            id: 'ch2',
            title: 'Risk and Return',
            content: 'Higher potential returns = higher risk. Understand your risk tolerance...',
            order: 2,
          ),
          LessonChapter(
            id: 'ch3',
            title: 'Investment Options',
            content: 'Stocks, mutual funds, ETFs, FDs, PPF, gold...',
            order: 3,
          ),
          LessonChapter(
            id: 'ch4',
            title: 'SIP: Start Small',
            content: 'Systematic Investment Plans let you invest small amounts regularly...',
            order: 4,
          ),
          LessonChapter(
            id: 'ch5',
            title: 'Power of Compounding',
            content: 'Interest earning interest. Starting early matters more than amount...',
            order: 5,
          ),
        ],
        quiz: LessonQuiz(
          questions: [
            QuizQuestion(
              id: 'q1',
              question: 'What is the benefit of starting to invest early?',
              options: [
                'Higher salary',
                'More compound interest time',
                'Lower taxes',
                'Better stock prices',
              ],
              correctIndex: 1,
              explanation: 'More time = more compounding = significantly higher returns.',
            ),
            QuizQuestion(
              id: 'q2',
              question: 'What does SIP stand for?',
              options: [
                'Simple Investment Plan',
                'Systematic Investment Plan',
                'Stock Investment Portfolio',
                'Savings Interest Program',
              ],
              correctIndex: 1,
              explanation: 'SIP = Systematic Investment Plan.',
            ),
          ],
          passingScore: 0.7,
        ),
        xpReward: 75,
      ),

      FinancialLesson(
        id: 'lesson_credit_understanding',
        title: 'Understanding Credit',
        description: 'Learn about credit scores, cards, and responsible borrowing',
        category: LessonCategory.credit,
        difficulty: LessonDifficulty.intermediate,
        estimatedMinutes: 12,
        chapters: [
          LessonChapter(
            id: 'ch1',
            title: 'What is Credit?',
            content: 'Borrowing money with promise to repay with interest...',
            order: 1,
          ),
          LessonChapter(
            id: 'ch2',
            title: 'Credit Score Explained',
            content: 'A number (300-900) representing your creditworthiness...',
            order: 2,
          ),
          LessonChapter(
            id: 'ch3',
            title: 'Credit Cards 101',
            content: 'How they work, interest rates, minimum payments trap...',
            order: 3,
          ),
          LessonChapter(
            id: 'ch4',
            title: 'Good Debt vs Bad Debt',
            content: 'Education loans vs credit card debt...',
            order: 4,
          ),
        ],
        quiz: LessonQuiz(
          questions: [
            QuizQuestion(
              id: 'q1',
              question: 'What is a good credit score in India?',
              options: ['Below 300', '300-500', '500-700', '750+'],
              correctIndex: 3,
              explanation: 'A score of 750+ is considered excellent in India.',
            ),
            QuizQuestion(
              id: 'q2',
              question: 'Paying only minimum balance on credit card is...',
              options: [
                'A smart strategy',
                'Recommended',
                'Expensive due to high interest',
                'Free money',
              ],
              correctIndex: 2,
              explanation: 'Interest rates of 30-40% make minimum payments very expensive.',
            ),
          ],
          passingScore: 0.7,
        ),
        xpReward: 60,
      ),
    ];

    _lessons.addAll(lessons);
  }

  List<FinancialLesson> getAllLessons() => _lessons;

  FinancialLesson? getLesson(String id) {
    try {
      return _lessons.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  List<FinancialLesson> getLessonsByCategory(LessonCategory category) {
    return _lessons.where((l) => l.category == category).toList();
  }

  List<FinancialLesson> getRecommendedLessons(List<String> completedIds) {
    return _lessons.where((l) => !completedIds.contains(l.id)).take(3).toList();
  }
}

/// Learning Progress Tracker
class LearningProgressTracker {
  final Map<String, LessonProgress> _progress = {};

  void startLesson(String lessonId) {
    _progress[lessonId] = LessonProgress(
      lessonId: lessonId,
      startedAt: DateTime.now(),
      lastChapterCompleted: 0,
      quizScore: null,
      isCompleted: false,
    );
  }

  void completeChapter(String lessonId, int chapterIndex) {
    final progress = _progress[lessonId];
    if (progress != null) {
      _progress[lessonId] = progress.copyWith(
        lastChapterCompleted: chapterIndex,
      );
    }
  }

  void recordQuizScore(String lessonId, double score) {
    final progress = _progress[lessonId];
    if (progress != null) {
      _progress[lessonId] = progress.copyWith(
        quizScore: score,
        isCompleted: true,
        completedAt: DateTime.now(),
      );
    }
  }

  LessonProgress? getProgress(String lessonId) => _progress[lessonId];

  List<String> getCompletedLessonIds() {
    return _progress.entries
        .where((e) => e.value.isCompleted)
        .map((e) => e.key)
        .toList();
  }

  int getTotalXpEarned(List<FinancialLesson> allLessons) {
    int xp = 0;
    for (final entry in _progress.entries) {
      if (entry.value.isCompleted) {
        final lesson = allLessons.firstWhere(
          (l) => l.id == entry.key,
          orElse: () => FinancialLesson(
            id: '',
            title: '',
            description: '',
            category: LessonCategory.budgeting,
            difficulty: LessonDifficulty.beginner,
            estimatedMinutes: 0,
            chapters: [],
            quiz: LessonQuiz(questions: [], passingScore: 0),
            xpReward: 0,
          ),
        );
        xp += lesson.xpReward;
      }
    }
    return xp;
  }
}

// ====== Data Classes ======

enum InsightType { pattern, warning, opportunity, achievement }

class FinancialInsight {
  final String id;
  final InsightType type;
  final String title;
  final String description;
  final int priority;
  final bool actionable;
  final String? suggestedAction;
  final int? potentialSavingsPaisa;

  const FinancialInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.priority,
    required this.actionable,
    this.suggestedAction,
    this.potentialSavingsPaisa,
  });
}

class SpendingData {
  final int currentMonthTotal;
  final int previousMonthTotal;
  final int weekdaySpendingPaisa;
  final int weekendSpendingPaisa;
  final int subscriptionsPaisa;
  final Map<String, int> categoryBreakdown;
  final Map<String, int> merchantBreakdown;

  const SpendingData({
    required this.currentMonthTotal,
    required this.previousMonthTotal,
    required this.weekdaySpendingPaisa,
    required this.weekendSpendingPaisa,
    required this.subscriptionsPaisa,
    required this.categoryBreakdown,
    required this.merchantBreakdown,
  });
}

class BudgetData {
  final String name;
  final int limitPaisa;
  final int spentPaisa;
  final int daysRemaining;
  final int consecutiveMonthsUnder;

  const BudgetData({
    required this.name,
    required this.limitPaisa,
    required this.spentPaisa,
    required this.daysRemaining,
    required this.consecutiveMonthsUnder,
  });
}

class UserProfile {
  final bool hasPublicTransit;
  final bool isHosteler;
  final int monthlyIncomePaisa;

  const UserProfile({
    required this.hasPublicTransit,
    required this.isHosteler,
    required this.monthlyIncomePaisa,
  });
}

class SpendingContext {
  final bool isOverspendingFood;
  final bool hasCreditCardDebt;
  final bool noInvestments;

  const SpendingContext({
    required this.isOverspendingFood,
    required this.hasCreditCardDebt,
    required this.noInvestments,
  });
}

enum TipCategory {
  saving,
  budgeting,
  investing,
  credit,
  studentLife,
}

enum TipDifficulty { beginner, intermediate, advanced }

class FinancialTip {
  final String id;
  final String title;
  final String content;
  final TipCategory category;
  final TipDifficulty difficulty;
  final int estimatedReadTime;

  const FinancialTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.difficulty,
    required this.estimatedReadTime,
  });
}

enum LessonCategory {
  budgeting,
  saving,
  investing,
  credit,
  taxes,
}

enum LessonDifficulty { beginner, intermediate, advanced }

class FinancialLesson {
  final String id;
  final String title;
  final String description;
  final LessonCategory category;
  final LessonDifficulty difficulty;
  final int estimatedMinutes;
  final List<LessonChapter> chapters;
  final LessonQuiz quiz;
  final int xpReward;

  const FinancialLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.chapters,
    required this.quiz,
    required this.xpReward,
  });
}

class LessonChapter {
  final String id;
  final String title;
  final String content;
  final int order;

  const LessonChapter({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
  });
}

class LessonQuiz {
  final List<QuizQuestion> questions;
  final double passingScore;

  const LessonQuiz({
    required this.questions,
    required this.passingScore,
  });
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class LessonProgress {
  final String lessonId;
  final DateTime startedAt;
  final int lastChapterCompleted;
  final double? quizScore;
  final bool isCompleted;
  final DateTime? completedAt;

  const LessonProgress({
    required this.lessonId,
    required this.startedAt,
    required this.lastChapterCompleted,
    this.quizScore,
    required this.isCompleted,
    this.completedAt,
  });

  LessonProgress copyWith({
    String? lessonId,
    DateTime? startedAt,
    int? lastChapterCompleted,
    double? quizScore,
    bool? isCompleted,
    DateTime? completedAt,
  }) =>
      LessonProgress(
        lessonId: lessonId ?? this.lessonId,
        startedAt: startedAt ?? this.startedAt,
        lastChapterCompleted: lastChapterCompleted ?? this.lastChapterCompleted,
        quizScore: quizScore ?? this.quizScore,
        isCompleted: isCompleted ?? this.isCompleted,
        completedAt: completedAt ?? this.completedAt,
      );
}
