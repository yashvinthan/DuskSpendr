import 'dart:math';

import '../../domain/entities/budget.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/money.dart';

/// SS-060 to SS-070: Budget & Financial Tracking
/// Budgets, alerts, predictions, balance tracking, bills, loans, investments, calculators

/// Budget Management Service
class BudgetService {
  final SpendingAnalyzer _spendingAnalyzer;
  final AlertEngine _alertEngine;
  final PredictionEngine _predictionEngine;

  BudgetService({
    SpendingAnalyzer? spendingAnalyzer,
    AlertEngine? alertEngine,
    PredictionEngine? predictionEngine,
  })  : _spendingAnalyzer = spendingAnalyzer ?? SpendingAnalyzer(),
        _alertEngine = alertEngine ?? AlertEngine(),
        _predictionEngine = predictionEngine ?? PredictionEngine();

  // ====== SS-060: Daily/Weekly/Monthly Budgets ======

  /// Create a new budget
  Budget createBudget({
    required String name,
    required int limitPaisa,
    required BudgetPeriod period,
    String? categoryId,
    double alertThreshold = 0.8,
  }) {
    TransactionCategory? category;
    if (categoryId != null) {
      for (final value in TransactionCategory.values) {
        if (value.name == categoryId) {
          category = value;
          break;
        }
      }
    }

    return Budget(
      name: name,
      limit: Money.fromPaisa(limitPaisa),
      spent: Money.zero,
      period: period,
      category: category,
      alertThreshold: alertThreshold,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Calculate budget progress
  BudgetProgress calculateProgress(Budget budget) {
    final limitPaisa = budget.limit.paisa;
    final spentPaisa = budget.spent.paisa;

    final percentUsed = limitPaisa > 0
        ? (spentPaisa / limitPaisa).clamp(0.0, 2.0).toDouble()
        : 0.0;

    final remainingPaisa = limitPaisa - spentPaisa;
    final daysRemaining = budget.period.daysRemaining;
    final dailyBudgetPaisa = daysRemaining > 0
        ? (remainingPaisa / daysRemaining).round()
        : remainingPaisa;

    BudgetStatus status;
    if (percentUsed >= 1.0) {
      status = BudgetStatus.exceeded;
    } else if (percentUsed >= budget.alertThreshold) {
      status = BudgetStatus.warning;
    } else {
      status = BudgetStatus.onTrack;
    }

    return BudgetProgress(
      budget: budget,
      percentUsed: percentUsed,
      remainingPaisa: remainingPaisa,
      dailyBudgetPaisa: dailyBudgetPaisa,
      daysRemaining: daysRemaining,
      status: status,
    );
  }

  /// Handle period rollover
  Budget rolloverBudget(Budget budget) {
    return budget.copyWith(
      spent: Money.zero,
      updatedAt: DateTime.now(),
    );
  }

  // ====== SS-062: Overspending Alert System ======

  /// Check budget and generate alerts
  List<BudgetAlert> checkBudgetAlerts(List<BudgetProgress> progresses) {
    return _alertEngine.generateAlerts(progresses);
  }

  /// Get predictive warning
  SpendingPrediction? getPredictiveWarning({
    required Budget budget,
    required List<TransactionSummary> recentTransactions,
  }) {
    return _predictionEngine.predictOverspending(budget, recentTransactions);
  }

  // ====== SS-063: Pocket Money Prediction ======

  /// Analyze spending patterns and suggest optimal pocket money
  PocketMoneyRecommendation analyzePocketMoney({
    required List<TransactionSummary> last90DaysTransactions,
    required int currentPocketMoney,
  }) {
    return _predictionEngine.recommendPocketMoney(
      last90DaysTransactions,
      currentPocketMoney,
    );
  }

  /// Analyze spending patterns for insights
  SpendingInsights analyzeSpending(List<TransactionSummary> transactions) {
    return _spendingAnalyzer.analyze(transactions);
  }
}

/// SS-062: Alert Engine
class AlertEngine {
  List<BudgetAlert> generateAlerts(List<BudgetProgress> progresses) {
    final alerts = <BudgetAlert>[];

    for (final progress in progresses) {
      // 80% threshold alert
      if (progress.percentUsed >= progress.budget.alertThreshold &&
          progress.percentUsed < 1.0) {
        alerts.add(BudgetAlert(
          type: BudgetAlertType.threshold,
          budget: progress.budget,
          message:
              '${progress.budget.name} is ${(progress.percentUsed * 100).round()}% used',
          severity: AlertSeverity.warning,
          percentUsed: progress.percentUsed,
        ));
      }

      // Exceeded alert
      if (progress.status == BudgetStatus.exceeded) {
        final overBy =
            progress.budget.spent.paisa - progress.budget.limit.paisa;
        alerts.add(BudgetAlert(
          type: BudgetAlertType.exceeded,
          budget: progress.budget,
          message: '${progress.budget.name} exceeded by ₹${overBy / 100}',
          severity: AlertSeverity.critical,
          percentUsed: progress.percentUsed,
        ));
      }
    }

    return alerts;
  }
}

/// SS-063: Prediction Engine
class PredictionEngine {
  /// Predict if budget will be exceeded
  SpendingPrediction? predictOverspending(
    Budget budget,
    List<TransactionSummary> recentTransactions,
  ) {
    if (recentTransactions.isEmpty) return null;

    // Calculate daily average spending
    final totalDays = recentTransactions.map((t) => t.date).toSet().length;
    if (totalDays == 0) return null;

    final totalSpent = recentTransactions.fold<int>(
      0,
      (sum, t) => sum + t.amountPaisa,
    );
    final dailyAverage = totalSpent / totalDays;

    // Project spending for remaining period
    final daysRemaining = budget.period.daysRemaining;
    final projectedSpending =
        budget.spent.paisa + (dailyAverage * daysRemaining);

    if (projectedSpending > budget.limit.paisa) {
      final predictedOverage = projectedSpending - budget.limit.paisa;
      final confidence =
          min(0.9, 0.5 + (totalDays / 30) * 0.4).toDouble();
      final suggestedDailyLimit = daysRemaining > 0
          ? ((budget.limit.paisa - budget.spent.paisa) / daysRemaining).round()
          : null;

      return SpendingPrediction(
        willExceed: true,
        predictedTotalPaisa: projectedSpending.round(),
        predictedOveragePaisa: predictedOverage.round(),
        confidence: confidence,
        suggestedDailyLimit: suggestedDailyLimit,
        message:
            'At current pace, you may exceed by ₹${(predictedOverage / 100).round()}',
      );
    }

    return SpendingPrediction(
      willExceed: false,
      predictedTotalPaisa: projectedSpending.round(),
      predictedOveragePaisa: 0,
      confidence: 0.8,
      suggestedDailyLimit: null,
      message: 'You\'re on track! Keep it up.',
    );
  }

  /// Recommend optimal pocket money based on 3-month analysis
  PocketMoneyRecommendation recommendPocketMoney(
    List<TransactionSummary> last90DaysTransactions,
    int currentPocketMoney,
  ) {
    if (last90DaysTransactions.isEmpty) {
      return PocketMoneyRecommendation(
        suggestedAmount: currentPocketMoney,
        confidence: 0.0,
        trend: SpendingTrend.stable,
        insights: ['Not enough data for analysis'],
      );
    }

    // Group by month
    final monthlySpending = <int, int>{};
    for (final tx in last90DaysTransactions) {
      final monthKey = tx.date.year * 12 + tx.date.month;
      monthlySpending[monthKey] =
          (monthlySpending[monthKey] ?? 0) + tx.amountPaisa;
    }

    if (monthlySpending.length < 2) {
      final avg = monthlySpending.values.first;
      return PocketMoneyRecommendation(
        suggestedAmount: (avg * 1.1).round(), // 10% buffer
        confidence: 0.5,
        trend: SpendingTrend.stable,
        insights: ['Based on limited data'],
      );
    }

    // Calculate trend
    final sortedMonths = monthlySpending.keys.toList()..sort();
    final values = sortedMonths.map((k) => monthlySpending[k]!).toList();

    final avgSpending = values.reduce((a, b) => a + b) / values.length;
    final recentSpending = values.last;

    SpendingTrend trend;
    if (recentSpending > avgSpending * 1.1) {
      trend = SpendingTrend.increasing;
    } else if (recentSpending < avgSpending * 0.9) {
      trend = SpendingTrend.decreasing;
    } else {
      trend = SpendingTrend.stable;
    }

    // Calculate standard deviation for buffer
    final variance =
        values.map((v) => pow(v - avgSpending, 2)).reduce((a, b) => a + b) /
            values.length;
    final stdDev = sqrt(variance);

    // Suggested amount = average + 1 std dev (buffer for variation)
    final suggestedAmount = (avgSpending + stdDev * 0.5).round();

    final insights = <String>[];
    if (trend == SpendingTrend.increasing) {
      insights.add('Spending has been increasing');
    } else if (trend == SpendingTrend.decreasing) {
      insights.add('Great job! Spending is decreasing');
    }

    if (suggestedAmount < currentPocketMoney) {
      insights.add(
          'You could manage with ₹${((currentPocketMoney - suggestedAmount) / 100).round()} less');
    } else if (suggestedAmount > currentPocketMoney * 1.2) {
      insights.add('Consider requesting more allowance');
    }

    return PocketMoneyRecommendation(
      suggestedAmount: suggestedAmount,
      confidence: min(0.9, 0.5 + monthlySpending.length * 0.15).toDouble(),
      trend: trend,
      insights: insights,
      monthlyAveragePaisa: avgSpending.round(),
    );
  }
}

/// Spending Analyzer for insights
class SpendingAnalyzer {
  SpendingInsights analyze(List<TransactionSummary> transactions) {
    if (transactions.isEmpty) {
      return const SpendingInsights(
        totalSpentPaisa: 0,
        averageTransactionPaisa: 0,
        categoryBreakdown: {},
        topMerchants: [],
        dailyPattern: {},
      );
    }

    final totalSpent =
        transactions.fold<int>(0, (sum, t) => sum + t.amountPaisa);
    final avgTransaction = totalSpent ~/ transactions.length;

    // Category breakdown
    final categoryTotals = <String, int>{};
    for (final tx in transactions) {
      categoryTotals[tx.category] =
          (categoryTotals[tx.category] ?? 0) + tx.amountPaisa;
    }

    // Top merchants
    final merchantTotals = <String, int>{};
    for (final tx in transactions) {
      if (tx.merchantName != null) {
        merchantTotals[tx.merchantName!] =
            (merchantTotals[tx.merchantName!] ?? 0) + tx.amountPaisa;
      }
    }
    final topMerchants = merchantTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Daily pattern
    final dailyTotals = <int, int>{};
    for (final tx in transactions) {
      final day = tx.date.weekday;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + tx.amountPaisa;
    }

    return SpendingInsights(
      totalSpentPaisa: totalSpent,
      averageTransactionPaisa: avgTransaction,
      categoryBreakdown: categoryTotals,
      topMerchants: topMerchants.take(5).map((e) => e.key).toList(),
      dailyPattern: dailyTotals,
    );
  }
}

// ====== Data Classes ======

class BudgetProgress {
  final Budget budget;
  final double percentUsed;
  final int remainingPaisa;
  final int dailyBudgetPaisa;
  final int daysRemaining;
  final BudgetStatus status;

  const BudgetProgress({
    required this.budget,
    required this.percentUsed,
    required this.remainingPaisa,
    required this.dailyBudgetPaisa,
    required this.daysRemaining,
    required this.status,
  });
}

// BudgetAlert, AlertType, SpendingPrediction removed - imported from domain/entities/budget.dart

enum SpendingTrend { increasing, decreasing, stable }

class PocketMoneyRecommendation {
  final int suggestedAmount;
  final double confidence;
  final SpendingTrend trend;
  final List<String> insights;
  final int? monthlyAveragePaisa;

  const PocketMoneyRecommendation({
    required this.suggestedAmount,
    required this.confidence,
    required this.trend,
    required this.insights,
    this.monthlyAveragePaisa,
  });
}

class TransactionSummary {
  final String id;
  final int amountPaisa;
  final DateTime date;
  final String category;
  final String? merchantName;

  const TransactionSummary({
    required this.id,
    required this.amountPaisa,
    required this.date,
    required this.category,
    this.merchantName,
  });
}

class SpendingInsights {
  final int totalSpentPaisa;
  final int averageTransactionPaisa;
  final Map<String, int> categoryBreakdown;
  final List<String> topMerchants;
  final Map<int, int> dailyPattern;

  const SpendingInsights({
    required this.totalSpentPaisa,
    required this.averageTransactionPaisa,
    required this.categoryBreakdown,
    required this.topMerchants,
    required this.dailyPattern,
  });
}
