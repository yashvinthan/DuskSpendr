import 'dart:async';

import '../../data/local/database.dart';
import '../../domain/entities/entities.dart';
import '../notifications/notification_service.dart';

/// SS-062: Budget Alert Service
/// Intelligent overspending alerts with predictions

class BudgetAlertService {
  final AppDatabase _database;
  final NotificationService _notificationService;

  Timer? _alertCheckTimer;
  final _alertController = StreamController<BudgetAlertEvent>.broadcast();

  Stream<BudgetAlertEvent> get alerts => _alertController.stream;

  // Snooze tracking
  final Map<String, DateTime> _snoozedAlerts = {};
  static const _defaultSnoozeHours = 6;

  BudgetAlertService({
    required AppDatabase database,
    required NotificationService notificationService,
  })  : _database = database,
        _notificationService = notificationService;

  /// Start periodic alert checking
  void startAlertMonitoring({Duration checkInterval = const Duration(minutes: 30)}) {
    stopAlertMonitoring();
    
    // Initial check
    _checkAlerts();
    
    // Periodic checks
    _alertCheckTimer = Timer.periodic(checkInterval, (_) => _checkAlerts());
  }

  void stopAlertMonitoring() {
    _alertCheckTimer?.cancel();
    _alertCheckTimer = null;
  }

  /// Check all budgets and generate alerts
  Future<List<BudgetAlertEvent>> _checkAlerts() async {
    final budgets = await _getActiveBudgets();
    final alerts = <BudgetAlertEvent>[];

    for (final budget in budgets) {
      // Check if snoozed
      if (_isAlertSnoozed(budget.id)) continue;

      // Check thresholds
      if (budget.isOverBudget) {
        final alert = BudgetAlertEvent(
          type: BudgetAlertType.exceeded,
          budget: budget,
          severity: AlertSeverity.critical,
          message: '${budget.name} budget exceeded by ${_formatMoney(budget.spent - budget.limit)}',
          timestamp: DateTime.now(),
        );
        alerts.add(alert);
        await _sendNotification(alert);
      } else if (budget.isAtAlertThreshold) {
        final alert = BudgetAlertEvent(
          type: BudgetAlertType.threshold,
          budget: budget,
          severity: AlertSeverity.warning,
          message: '${budget.name} is ${budget.percentSpent}% used. ${_formatMoney(budget.remaining)} remaining.',
          timestamp: DateTime.now(),
        );
        alerts.add(alert);
        await _sendNotification(alert);
      }

      // Predictive alert
      final prediction = _predictEndOfPeriodSpending(budget);
      if (prediction != null && prediction.willExceed && !budget.isOverBudget) {
        final alert = BudgetAlertEvent(
          type: BudgetAlertType.predictive,
          budget: budget,
          severity: AlertSeverity.info,
          message: 'At current pace, you\'ll exceed ${budget.name} by ${_formatMoney(Money.fromPaisa(prediction.predictedOveragePaisa))}',
          timestamp: DateTime.now(),
          prediction: prediction,
        );
        alerts.add(alert);
        // Only notify once per day for predictions
        if (!_hasRecentPredictiveAlert(budget.id)) {
          await _sendNotification(alert);
        }
      }
    }

    for (final alert in alerts) {
      _alertController.add(alert);
    }

    return alerts;
  }

  /// Predict spending based on current pace
  SpendingPrediction? _predictEndOfPeriodSpending(Budget budget) {
    final daysRemaining = budget.period.daysRemaining;
    final daysPassed = _getDaysPassed(budget.period);
    
    if (daysPassed == 0) return null;

    final dailyAverage = budget.spent.paisa / daysPassed;
    final projectedTotal = budget.spent.paisa + (dailyAverage * daysRemaining);
    final projectedOverage = projectedTotal - budget.limit.paisa;

    if (projectedOverage > 0) {
      final suggestedDailyLimit = daysRemaining > 0
          ? ((budget.limit.paisa - budget.spent.paisa) / daysRemaining).round()
          : 0;

      return SpendingPrediction(
        willExceed: true,
        predictedTotalPaisa: projectedTotal.round(),
        predictedOveragePaisa: projectedOverage.round(),
        confidence: _calculateConfidence(daysPassed, daysRemaining),
        suggestedDailyLimit: suggestedDailyLimit,
        daysToExceed: _calculateDaysToExceed(budget, dailyAverage),
      );
    }

    return SpendingPrediction(
      willExceed: false,
      predictedTotalPaisa: projectedTotal.round(),
      predictedOveragePaisa: 0,
      confidence: _calculateConfidence(daysPassed, daysRemaining),
    );
  }

  int _getDaysPassed(BudgetPeriod period) {
    final now = DateTime.now();
    final start = period.periodStart;
    return now.difference(start).inDays + 1;
  }

  double _calculateConfidence(int daysPassed, int daysRemaining) {
    // Higher confidence if more days have passed
    final totalDays = daysPassed + daysRemaining;
    if (totalDays == 0) return 0.5;
    return (daysPassed / totalDays * 0.4 + 0.5).clamp(0.5, 0.9);
  }

  int _calculateDaysToExceed(Budget budget, double dailyAverage) {
    if (dailyAverage <= 0) return 999;
    final remaining = budget.limit.paisa - budget.spent.paisa;
    if (remaining <= 0) return 0;
    return (remaining / dailyAverage).floor();
  }

  /// Snooze an alert
  void snoozeAlert(String budgetId, {int hours = _defaultSnoozeHours}) {
    _snoozedAlerts[budgetId] = DateTime.now().add(Duration(hours: hours));
  }

  bool _isAlertSnoozed(String budgetId) {
    final snoozeUntil = _snoozedAlerts[budgetId];
    if (snoozeUntil == null) return false;
    if (DateTime.now().isAfter(snoozeUntil)) {
      _snoozedAlerts.remove(budgetId);
      return false;
    }
    return true;
  }

  final Map<String, DateTime> _lastPredictiveAlerts = {};

  bool _hasRecentPredictiveAlert(String budgetId) {
    final lastAlert = _lastPredictiveAlerts[budgetId];
    if (lastAlert == null) return false;
    return DateTime.now().difference(lastAlert).inHours < 24;
  }

  Future<void> _sendNotification(BudgetAlertEvent alert) async {
    await _notificationService.showBudgetAlert(
      title: _getNotificationTitle(alert),
      body: alert.message,
      severity: alert.severity,
      payload: {'budgetId': alert.budget.id},
    );

    if (alert.type == BudgetAlertType.predictive) {
      _lastPredictiveAlerts[alert.budget.id] = DateTime.now();
    }
  }

  String _getNotificationTitle(BudgetAlertEvent alert) {
    switch (alert.type) {
      case BudgetAlertType.exceeded:
        return '⚠️ Budget Exceeded';
      case BudgetAlertType.threshold:
        return '📊 Budget Warning';
      case BudgetAlertType.predictive:
        return '📈 Spending Prediction';
      case BudgetAlertType.dailySummary:
        return '📋 Daily Summary';
    }
  }

  Future<List<Budget>> _getActiveBudgets() async {
    // Implementation would use BudgetDao
    return [];
  }

  String _formatMoney(Money money) {
    return '₹${(money.paisa / 100).toStringAsFixed(2)}';
  }

  /// Generate daily spending summary
  Future<DailySpendingSummary> generateDailySummary() async {
    final budgets = await _getActiveBudgets();
    final summaries = <BudgetDaySummary>[];

    for (final budget in budgets) {
      final dailyLimit = budget.period == BudgetPeriod.daily
          ? budget.limit
          : budget.remaining / budget.period.daysRemaining;

      summaries.add(BudgetDaySummary(
        budgetName: budget.name,
        spentToday: Money.zero, // Would need transaction data
        dailyLimit: dailyLimit,
        remainingInPeriod: budget.remaining,
        daysRemaining: budget.period.daysRemaining,
      ));
    }

    return DailySpendingSummary(
      date: DateTime.now(),
      budgets: summaries,
      totalSpentToday: Money.zero,
    );
  }

  void dispose() {
    stopAlertMonitoring();
    _alertController.close();
  }
}

// ====== Data Classes ======

enum BudgetAlertType {
  threshold,
  exceeded,
  predictive,
  dailySummary,
}

enum AlertSeverity { info, warning, critical }

class BudgetAlertEvent {
  final BudgetAlertType type;
  final Budget budget;
  final AlertSeverity severity;
  final String message;
  final DateTime timestamp;
  final SpendingPrediction? prediction;

  const BudgetAlertEvent({
    required this.type,
    required this.budget,
    required this.severity,
    required this.message,
    required this.timestamp,
    this.prediction,
  });
}

class SpendingPrediction {
  final bool willExceed;
  final int predictedTotalPaisa;
  final int predictedOveragePaisa;
  final double confidence;
  final int? suggestedDailyLimit;
  final int? daysToExceed;

  const SpendingPrediction({
    required this.willExceed,
    required this.predictedTotalPaisa,
    required this.predictedOveragePaisa,
    required this.confidence,
    this.suggestedDailyLimit,
    this.daysToExceed,
  });
}

class DailySpendingSummary {
  final DateTime date;
  final List<BudgetDaySummary> budgets;
  final Money totalSpentToday;

  const DailySpendingSummary({
    required this.date,
    required this.budgets,
    required this.totalSpentToday,
  });
}

class BudgetDaySummary {
  final String budgetName;
  final Money spentToday;
  final Money dailyLimit;
  final Money remainingInPeriod;
  final int daysRemaining;

  const BudgetDaySummary({
    required this.budgetName,
    required this.spentToday,
    required this.dailyLimit,
    required this.remainingInPeriod,
    required this.daysRemaining,
  });
}
