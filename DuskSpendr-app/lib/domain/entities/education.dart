/// SS-090: Financial Education domain entities

/// Financial topic categories
enum FinancialTopic {
  spending,    // Smart spending habits
  saving,      // Building savings habits
  budgeting,   // Budget fundamentals
  credit,      // Understanding credit
  investing,   // Basic investing concepts
  banking,     // Banking basics
  goals,       // Financial goal setting
}

extension FinancialTopicExt on FinancialTopic {
  String get displayName {
    switch (this) {
      case FinancialTopic.spending: return 'Smart Spending';
      case FinancialTopic.saving: return 'Saving';
      case FinancialTopic.budgeting: return 'Budgeting';
      case FinancialTopic.credit: return 'Credit';
      case FinancialTopic.investing: return 'Investing';
      case FinancialTopic.banking: return 'Banking';
      case FinancialTopic.goals: return 'Goals';
    }
  }

  String get emoji {
    switch (this) {
      case FinancialTopic.spending: return '💸';
      case FinancialTopic.saving: return '💰';
      case FinancialTopic.budgeting: return '📊';
      case FinancialTopic.credit: return '💳';
      case FinancialTopic.investing: return '📈';
      case FinancialTopic.banking: return '🏦';
      case FinancialTopic.goals: return '🎯';
    }
  }

  String get description {
    switch (this) {
      case FinancialTopic.spending: return 'Learn to spend wisely - needs vs wants, impulse control';
      case FinancialTopic.saving: return 'Build savings habits - emergency fund, goal-based saving';
      case FinancialTopic.budgeting: return 'Master budgeting - 50/30/20 rule, tracking';
      case FinancialTopic.credit: return 'Understand credit - scores, responsible usage';
      case FinancialTopic.investing: return 'Investing basics - compound interest, SIPs';
      case FinancialTopic.banking: return 'Banking basics - accounts, UPI, digital safety';
      case FinancialTopic.goals: return 'Set financial goals - short-term vs long-term';
    }
  }
}

/// Tip types
enum TipType {
  spendingReduction,   // "You spent 40% more on food this week"
  patternObservation,  // "You spend most on weekends"
  goalReminder,        // "Save ₹200 more to reach your goal"
  achievement,         // "Great job staying under budget!"
  educational,         // "Did you know: 50/30/20 rule..."
  actionable,          // "Try cooking once this week"
}

/// Financial tip
class FinancialTip {
  final String id;
  final TipType type;
  final String title;
  final String message;
  final String? actionLabel;
  final String? actionRoute;
  final FinancialTopic? relatedTopic;
  final int priority; // Higher = more important
  final DateTime? validUntil; // Time-sensitive tips
  final Map<String, dynamic>? metadata;

  const FinancialTip({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionRoute,
    this.relatedTopic,
    this.priority = 0,
    this.validUntil,
    this.metadata,
  });
}

/// Financial health score
class FinancialHealthScore {
  final int overall;           // 0-100
  final int budgetingScore;    // Track budgets, stay within
  final int savingsScore;      // % saved, consistency
  final int spendingDiscipline; // Impulse control, patterns
  final int financialLiteracy;  // Lessons completed, quiz scores
  final HealthTrend trend;      // IMPROVING, STABLE, DECLINING
  final List<String> improvements;
  final DateTime calculatedAt;

  const FinancialHealthScore({
    required this.overall,
    required this.budgetingScore,
    required this.savingsScore,
    required this.spendingDiscipline,
    required this.financialLiteracy,
    required this.trend,
    required this.improvements,
    required this.calculatedAt,
  });

  /// Get rating text
  String get rating {
    if (overall >= 80) return 'Excellent';
    if (overall >= 60) return 'Good';
    if (overall >= 40) return 'Fair';
    if (overall >= 20) return 'Needs Work';
    return 'Getting Started';
  }
}

/// Health score trend
enum HealthTrend { improving, stable, declining }

/// Improvement suggestion
class Improvement {
  final String id;
  final String title;
  final String description;
  final String? actionLabel;
  final String? actionRoute;
  final int impact; // 1-5 stars
  final String targetArea; // budgeting, savings, etc.
  final List<String> steps;

  const Improvement({
    required this.id,
    required this.title,
    required this.description,
    this.actionLabel,
    this.actionRoute,
    required this.impact,
    required this.targetArea,
    required this.steps,
  });
}

/// Educational lesson
class EducationalLesson {
  final String id;
  final FinancialTopic topic;
  final String title;
  final String subtitle;
  final String description;
  final String thumbnailUrl;
  final int durationMinutes;
  final List<LessonSection> sections;
  final List<QuizQuestion> quiz;
  final int order; // Order within topic
  final bool isPremium;

  const EducationalLesson({
    required this.id,
    required this.topic,
    required this.title,
    this.subtitle = '',
    this.description = '',
    this.thumbnailUrl = '',
    required this.durationMinutes,
    required this.sections,
    this.quiz = const [],
    this.order = 0,
    this.isPremium = false,
  });
}

/// Lesson section
class LessonSection {
  final String id;
  final LessonSectionType type;
  final String title;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final Map<String, dynamic>? interactiveData;

  const LessonSection({
    this.id = '',
    required this.type,
    required this.title,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    this.interactiveData,
  });
}

enum LessonSectionType {
  text,
  image,
  video,
  interactive,
  example,
  hook,
  concept,
  takeaway
}

/// Quiz question
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    this.id = '',
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

/// Completed lesson record
class CompletedLesson {
  final String id;
  final String lessonId;
  final String topicId;
  final int? quizScore;
  final int timeSpentSeconds;
  final DateTime completedAt;

  const CompletedLesson({
    required this.id,
    required this.lessonId,
    required this.topicId,
    this.quizScore,
    required this.timeSpentSeconds,
    required this.completedAt,
  });
}

/// Learning progress
class LearningProgress {
  final int totalLessons;
  final int completedLessons;
  final Map<FinancialTopic, int> completedByTopic;
  final int totalQuizScore;
  final int quizzesTaken;
  final List<String> badges;

  const LearningProgress({
    required this.totalLessons,
    required this.completedLessons,
    required this.completedByTopic,
    required this.totalQuizScore,
    required this.quizzesTaken,
    required this.badges,
  });

  double get completionPercentage =>
      totalLessons > 0 ? completedLessons / totalLessons : 0;

  double get averageQuizScore =>
      quizzesTaken > 0 ? totalQuizScore / quizzesTaken : 0;
}

/// Credit score data
class CreditScoreData {
  final int score;
  final String source; // CIBIL, Experian, etc.
  final CreditRating rating;
  final List<CreditFactor> factors;
  final DateTime fetchedAt;
  final int? previousScore;
  final DateTime? previousFetchedAt;

  const CreditScoreData({
    required this.score,
    required this.source,
    required this.rating,
    required this.factors,
    required this.fetchedAt,
    this.previousScore,
    this.previousFetchedAt,
  });

  int? get change => previousScore != null ? score - previousScore! : null;
}

/// Credit score rating
enum CreditRating { excellent, good, fair, poor, veryPoor }

extension CreditRatingExt on CreditRating {
  String get displayName {
    switch (this) {
      case CreditRating.excellent: return 'Excellent';
      case CreditRating.good: return 'Good';
      case CreditRating.fair: return 'Fair';
      case CreditRating.poor: return 'Poor';
      case CreditRating.veryPoor: return 'Very Poor';
    }
  }

  static CreditRating fromScore(int score) {
    if (score >= 750) return CreditRating.excellent;
    if (score >= 700) return CreditRating.good;
    if (score >= 650) return CreditRating.fair;
    if (score >= 550) return CreditRating.poor;
    return CreditRating.veryPoor;
  }
}

/// Credit score factor
class CreditFactor {
  final String name;
  final String impact; // positive, negative, neutral
  final String description;

  const CreditFactor({
    required this.name,
    required this.impact,
    required this.description,
  });
}

/// Shown tip record
class ShownTip {
  final String id;
  final String tipId;
  final bool wasDismissed;
  final bool wasSaved;
  final bool wasActedOn;
  final DateTime shownAt;

  const ShownTip({
    required this.id,
    required this.tipId,
    this.wasDismissed = false,
    this.wasSaved = false,
    this.wasActedOn = false,
    required this.shownAt,
  });
}
