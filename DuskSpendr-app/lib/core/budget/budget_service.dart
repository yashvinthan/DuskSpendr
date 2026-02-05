import 'dart:async';
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
      try {
        category = TransactionCategory.values.byName(categoryId);
      } catch (_) {}
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

    final percentUsed =
        limitPaisa > 0 ? (spentPaisa / limitPaisa).clamp(0.0, 2.0) : 0.0;

    final remainingPaisa = limitPaisa - spentPaisa;
    final daysRemaining = budget.period.daysRemaining;
    final dailyBudgetPaisa = daysRemaining > 0
        ? (remainingPaisa / daysRemaining).round()
        : remainingPaisa;

    // Use domain logic for status if possible, but keeping calculation here for specific thresholds if needed
    // Domain entity has field 'status' which uses internal logic.
    // The existing code uses custom thresholds (e.g. 0.5 for onTrack).
    // Let's stick to the existing logic but use domain Enum.

    BudgetStatus status;
    if (percentUsed >= 1.0) {
      status = BudgetStatus.exceeded;
    } else if (percentUsed >= budget.alertThreshold) {
      status = BudgetStatus.warning;
    } else if (percentUsed >= 0.5) {
      status = BudgetStatus.onTrack; // Domain status 'onTrack'
    } else {
      status = BudgetStatus.onTrack; // Domain "healthy" doesn't exist?
      // Domain has: onTrack, warning, exceeded.
      // Original service had: healthy, onTrack, warning, exceeded.
      // We must map to available domain statuses.
      // 'healthy' in service seems to be < 0.5. 'onTrack' > 0.5.
      // Let's use 'onTrack' for both healthy and onTrack.
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
          type: AlertType.threshold,
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
          type: AlertType.exceeded,
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
      final confidence = min(0.9, 0.5 + (totalDays / 30) * 0.4);

      return SpendingPrediction(
        willExceed: true,
        predictedTotalPaisa: projectedSpending.round(),
        predictedOveragePaisa: predictedOverage.round(),
        confidence: confidence,
        suggestedDailyLimit:
            ((budget.limit.paisa - budget.spent.paisa) / daysRemaining).round(),
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
      confidence: min(0.9, 0.5 + monthlySpending.length * 0.15),
      trend: trend,
      insights: insights,
      monthlyAveragePaisa: avgSpending.round(),
    );
  }
}

/// SS-064-065: Balance Tracking
class BalanceTracker {
  /// Calculate consolidated balance across all accounts
  ConsolidatedBalance calculateConsolidated(List<AccountBalance> balances) {
    int totalPaisa = 0;
    final byType = <String, int>{};

    for (final balance in balances) {
      totalPaisa += balance.balancePaisa;
      final typeKey = balance.accountType;
      byType[typeKey] = (byType[typeKey] ?? 0) + balance.balancePaisa;
    }

    return ConsolidatedBalance(
      totalPaisa: totalPaisa,
      byAccountType: byType,
      accountCount: balances.length,
      lastUpdated: DateTime.now(),
    );
  }

  /// Generate balance history for charts
  List<BalancePoint> generateHistory(
    List<BalanceSnapshot> snapshots,
    Duration period,
  ) {
    final now = DateTime.now();
    final start = now.subtract(period);

    return snapshots
        .where((s) => s.timestamp.isAfter(start))
        .map((s) => BalancePoint(
              timestamp: s.timestamp,
              balancePaisa: s.balancePaisa,
            ))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}

/// SS-066: Low Balance Alert
class LowBalanceAlertService {
  List<LowBalanceAlert> checkLowBalances(
    List<AccountBalance> balances,
    Map<String, int> thresholds,
  ) {
    final alerts = <LowBalanceAlert>[];

    for (final balance in balances) {
      final threshold =
          thresholds[balance.accountId] ?? 100000; // Default ₹1000

      if (balance.balancePaisa < threshold) {
        alerts.add(LowBalanceAlert(
          accountId: balance.accountId,
          accountName: balance.accountName,
          currentBalancePaisa: balance.balancePaisa,
          thresholdPaisa: threshold,
        ));
      }
    }

    return alerts;
  }
}

/// SS-067: Bill Payment Reminders
class BillReminderService {
  List<BillReminder> detectRecurringBills(
      List<TransactionSummary> transactions) {
    // Group by merchant
    final byMerchant = <String, List<TransactionSummary>>{};
    for (final tx in transactions) {
      if (tx.merchantName != null) {
        byMerchant.putIfAbsent(tx.merchantName!, () => []).add(tx);
      }
    }

    final reminders = <BillReminder>[];

    for (final entry in byMerchant.entries) {
      if (entry.value.length < 2) continue;

      final txList = entry.value..sort((a, b) => a.date.compareTo(b.date));

      // Check if amounts are similar (within 10%)
      final amounts = txList.map((t) => t.amountPaisa).toList();
      final avgAmount = amounts.reduce((a, b) => a + b) / amounts.length;
      final isConsistentAmount = amounts.every(
        (a) => (a - avgAmount).abs() < avgAmount * 0.1,
      );

      if (!isConsistentAmount) continue;

      // Calculate interval
      final intervals = <int>[];
      for (int i = 1; i < txList.length; i++) {
        intervals.add(txList[i].date.difference(txList[i - 1].date).inDays);
      }

      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;

      // Determine frequency
      BillFrequency? frequency;
      if (avgInterval >= 25 && avgInterval <= 35) {
        frequency = BillFrequency.monthly;
      } else if (avgInterval >= 80 && avgInterval <= 100) {
        frequency = BillFrequency.quarterly;
      } else if (avgInterval >= 350 && avgInterval <= 380) {
        frequency = BillFrequency.yearly;
      }

      if (frequency != null) {
        final lastTx = txList.last;
        final nextDue = lastTx.date.add(Duration(days: avgInterval.round()));

        reminders.add(BillReminder(
          id: entry.key.hashCode.toString(),
          merchantName: entry.key,
          amountPaisa: avgAmount.round(),
          frequency: frequency,
          nextDueDate: nextDue,
          isAutoDetected: true,
        ));
      }
    }

    return reminders;
  }
}

/// SS-070: Financial Calculators
class FinancialCalculators {
  /// EMI Calculator
  EmiResult calculateEmi({
    required int principalPaisa,
    required double annualRatePercent,
    required int tenureMonths,
  }) {
    final monthlyRate = annualRatePercent / 12 / 100;
    final principal = principalPaisa / 100;

    if (monthlyRate == 0) {
      final emi = principal / tenureMonths;
      return EmiResult(
        emiPaisa: (emi * 100).round(),
        totalPaymentPaisa: principalPaisa,
        totalInterestPaisa: 0,
      );
    }

    final emi = principal *
        monthlyRate *
        pow(1 + monthlyRate, tenureMonths) /
        (pow(1 + monthlyRate, tenureMonths) - 1);

    final totalPayment = emi * tenureMonths;
    final totalInterest = totalPayment - principal;

    return EmiResult(
      emiPaisa: (emi * 100).round(),
      totalPaymentPaisa: (totalPayment * 100).round(),
      totalInterestPaisa: (totalInterest * 100).round(),
    );
  }

  /// Compound Interest Calculator
  CompoundInterestResult calculateCompoundInterest({
    required int principalPaisa,
    required double annualRatePercent,
    required int years,
    int compoundingFrequency = 12, // Monthly
  }) {
    final principal = principalPaisa / 100;
    final rate = annualRatePercent / 100;
    final n = compoundingFrequency;

    final amount = principal * pow(1 + rate / n, n * years);
    final interest = amount - principal;

    return CompoundInterestResult(
      finalAmountPaisa: (amount * 100).round(),
      interestEarnedPaisa: (interest * 100).round(),
    );
  }

  /// SIP Returns Calculator
  SipResult calculateSipReturns({
    required int monthlyInvestmentPaisa,
    required double expectedAnnualReturnPercent,
    required int years,
  }) {
    final monthly = monthlyInvestmentPaisa / 100;
    final monthlyRate = expectedAnnualReturnPercent / 12 / 100;
    final months = years * 12;

    final futureValue = monthly *
        ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
        (1 + monthlyRate);

    final totalInvestment = monthly * months;
    final returns = futureValue - totalInvestment;

    return SipResult(
      totalInvestmentPaisa: (totalInvestment * 100).round(),
      estimatedReturnsPaisa: (returns * 100).round(),
      totalValuePaisa: (futureValue * 100).round(),
    );
  }

  /// Savings Goal Calculator
  SavingsGoalResult calculateMonthlySavings({
    required int goalAmountPaisa,
    required int currentSavingsPaisa,
    required int monthsToGoal,
    double expectedReturnPercent = 6.0,
  }) {
    final goal = goalAmountPaisa / 100;
    final current = currentSavingsPaisa / 100;
    final remaining = goal - current;
    final monthlyRate = expectedReturnPercent / 12 / 100;

    // PMT formula
    double monthlySavings;
    if (monthlyRate > 0) {
      monthlySavings =
          remaining * monthlyRate / (pow(1 + monthlyRate, monthsToGoal) - 1);
    } else {
      monthlySavings = remaining / monthsToGoal;
    }

    return SavingsGoalResult(
      requiredMonthlySavingsPaisa: (monthlySavings * 100).round(),
      totalContributionPaisa: (monthlySavings * monthsToGoal * 100).round(),
      projectedGoalDateMonths: monthsToGoal,
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

enum AlertType { threshold, exceeded, predictive }

enum AlertSeverity { info, warning, critical }

class BudgetAlert {
  final AlertType type;
  final Budget budget;
  final String message;
  final AlertSeverity severity;
  final double percentUsed;

  const BudgetAlert({
    required this.type,
    required this.budget,
    required this.message,
    required this.severity,
    required this.percentUsed,
  });
}

class SpendingPrediction {
  final bool willExceed;
  final int predictedTotalPaisa;
  final int predictedOveragePaisa;
  final double confidence;
  final int? suggestedDailyLimit;
  final String message;

  const SpendingPrediction({
    required this.willExceed,
    required this.predictedTotalPaisa,
    required this.predictedOveragePaisa,
    required this.confidence,
    this.suggestedDailyLimit,
    required this.message,
  });
}

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

class AccountBalance {
  final String accountId;
  final String accountName;
  final String accountType;
  final int balancePaisa;
  final DateTime updatedAt;

  const AccountBalance({
    required this.accountId,
    required this.accountName,
    required this.accountType,
    required this.balancePaisa,
    required this.updatedAt,
  });
}

class ConsolidatedBalance {
  final int totalPaisa;
  final Map<String, int> byAccountType;
  final int accountCount;
  final DateTime lastUpdated;

  const ConsolidatedBalance({
    required this.totalPaisa,
    required this.byAccountType,
    required this.accountCount,
    required this.lastUpdated,
  });
}

class BalanceSnapshot {
  final DateTime timestamp;
  final int balancePaisa;

  const BalanceSnapshot({
    required this.timestamp,
    required this.balancePaisa,
  });
}

class BalancePoint {
  final DateTime timestamp;
  final int balancePaisa;

  const BalancePoint({
    required this.timestamp,
    required this.balancePaisa,
  });
}

class LowBalanceAlert {
  final String accountId;
  final String accountName;
  final int currentBalancePaisa;
  final int thresholdPaisa;

  const LowBalanceAlert({
    required this.accountId,
    required this.accountName,
    required this.currentBalancePaisa,
    required this.thresholdPaisa,
  });
}

enum BillFrequency { weekly, monthly, quarterly, yearly }

class BillReminder {
  final String id;
  final String merchantName;
  final int amountPaisa;
  final BillFrequency frequency;
  final DateTime nextDueDate;
  final bool isAutoDetected;

  const BillReminder({
    required this.id,
    required this.merchantName,
    required this.amountPaisa,
    required this.frequency,
    required this.nextDueDate,
    required this.isAutoDetected,
  });
}

class EmiResult {
  final int emiPaisa;
  final int totalPaymentPaisa;
  final int totalInterestPaisa;

  const EmiResult({
    required this.emiPaisa,
    required this.totalPaymentPaisa,
    required this.totalInterestPaisa,
  });
}

class CompoundInterestResult {
  final int finalAmountPaisa;
  final int interestEarnedPaisa;

  const CompoundInterestResult({
    required this.finalAmountPaisa,
    required this.interestEarnedPaisa,
  });
}

class SipResult {
  final int totalInvestmentPaisa;
  final int estimatedReturnsPaisa;
  final int totalValuePaisa;

  const SipResult({
    required this.totalInvestmentPaisa,
    required this.estimatedReturnsPaisa,
    required this.totalValuePaisa,
  });
}

class SavingsGoalResult {
  final int requiredMonthlySavingsPaisa;
  final int totalContributionPaisa;
  final int projectedGoalDateMonths;

  const SavingsGoalResult({
    required this.requiredMonthlySavingsPaisa,
    required this.totalContributionPaisa,
    required this.projectedGoalDateMonths,
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
