import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'category.dart';
import 'money.dart';

/// Budget period type
enum BudgetPeriod {
  daily('Daily'),
  weekly('Weekly'),
  monthly('Monthly');

  final String label;

  const BudgetPeriod(this.label);

  /// Get start of current period
  DateTime get periodStart {
    final now = DateTime.now();
    switch (this) {
      case BudgetPeriod.daily:
        return DateTime(now.year, now.month, now.day);
      case BudgetPeriod.weekly:
        final weekday = now.weekday;
        return DateTime(now.year, now.month, now.day - weekday + 1);
      case BudgetPeriod.monthly:
        return DateTime(now.year, now.month, 1);
    }
  }

  /// Get end of current period
  DateTime get periodEnd {
    final now = DateTime.now();
    switch (this) {
      case BudgetPeriod.daily:
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case BudgetPeriod.weekly:
        final weekday = now.weekday;
        return DateTime(
          now.year,
          now.month,
          now.day + (7 - weekday),
          23,
          59,
          59,
        );
      case BudgetPeriod.monthly:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }
  }

  /// Days remaining in period
  int get daysRemaining {
    return periodEnd.difference(DateTime.now()).inDays + 1;
  }
}

/// Alert severity for budget alerts
enum AlertSeverity { info, warning, critical }

/// Budget entity
class Budget extends Equatable {
  final String id;
  final String name;
  final Money limit;
  final Money spent;
  final BudgetPeriod period;
  final TransactionCategory? category; // null = overall budget
  final double alertThreshold; // 0.0 - 1.0, default 0.8
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Budget({
    String? id,
    required this.name,
    required this.limit,
    Money? spent,
    required this.period,
    this.category,
    this.alertThreshold = 0.8,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        spent = spent ?? Money.zero,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Remaining amount
  Money get remaining => limit - spent;

  /// Progress as 0.0 - 1.0
  double get progress {
    if (limit.paisa == 0) return 0;
    return (spent.paisa / limit.paisa).clamp(0.0, 1.0);
  }

  /// Percentage spent
  int get percentSpent => (progress * 100).round();

  /// Daily allowance remaining
  Money get dailyAllowance {
    final days = period.daysRemaining;
    if (days <= 0) return Money.zero;
    return remaining / days;
  }

  /// Check if over budget
  bool get isOverBudget => spent > limit;

  /// Check if at alert threshold
  bool get isAtAlertThreshold => progress >= alertThreshold;

  /// Budget status for UI
  BudgetStatus get status {
    if (isOverBudget) return BudgetStatus.exceeded;
    if (isAtAlertThreshold) return BudgetStatus.warning;
    return BudgetStatus.onTrack;
  }

  Budget copyWith({
    String? id,
    String? name,
    Money? limit,
    Money? spent,
    BudgetPeriod? period,
    TransactionCategory? category,
    double? alertThreshold,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      period: period ?? this.period,
      category: category ?? this.category,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        limit.paisa,
        spent.paisa,
        period,
        category,
        alertThreshold,
        isActive,
      ];
}

/// Budget status for styling
enum BudgetStatus { onTrack, warning, exceeded }

/// Alert types
enum BudgetAlertType {
  threshold,
  exceeded,
  predictive,
  dailySummary,
}

/// Unified Budget Alert class
class BudgetAlert {
  final BudgetAlertType type;
  final Budget budget;
  final String message;
  final AlertSeverity severity;
  final double? percentUsed;
  final DateTime timestamp;
  final SpendingPrediction? prediction;

  BudgetAlert({
    required this.type,
    required this.budget,
    required this.message,
    required this.severity,
    this.percentUsed,
    DateTime? timestamp,
    this.prediction,
  }) : timestamp =
            timestamp ?? DateTime.now(); // Default to now if not provided
}

/// Unified Spending Prediction class
class SpendingPrediction {
  final bool willExceed;
  final int predictedTotalPaisa;
  final int predictedOveragePaisa;
  final double confidence;
  final int? suggestedDailyLimit;
  final int? daysToExceed;
  final String? message;

  const SpendingPrediction({
    required this.willExceed,
    required this.predictedTotalPaisa,
    required this.predictedOveragePaisa,
    required this.confidence,
    this.suggestedDailyLimit,
    this.daysToExceed,
    this.message,
  });
}
