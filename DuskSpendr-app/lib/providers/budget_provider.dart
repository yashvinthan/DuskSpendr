import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/budget/balance_tracking_service.dart';
import '../core/budget/bill_reminder_service.dart';
import '../core/budget/budget_alert_service.dart';
import '../core/budget/financial_calculators.dart';

import '../core/budget/investment_tracker.dart';
import '../core/notifications/notification_service.dart';
import '../data/local/daos/budget_dao.dart';
import '../domain/entities/entities.dart';
import 'database_provider.dart';
import 'transaction_provider.dart';

/// Stream of active budgets
final activeBudgetsProvider = StreamProvider<List<Budget>>((ref) {
  final dao = ref.watch(budgetDaoProvider);
  return dao.watchActive();
});

/// Overall budget (no category)
final overallBudgetProvider = FutureProvider<Budget?>((ref) async {
  final dao = ref.watch(budgetDaoProvider);
  return await dao.getOverallBudget();
});

/// Budget by category
final budgetByCategoryProvider =
    FutureProvider.family<Budget?, TransactionCategory>((ref, category) async {
  final dao = ref.watch(budgetDaoProvider);
  return await dao.getByCategory(category);
});

/// Budgets that need alerts
final budgetAlertsProvider = FutureProvider<List<Budget>>((ref) async {
  final dao = ref.watch(budgetDaoProvider);
  return await dao.getBudgetsAtAlert();
});

/// Budget progress with spending data
final budgetProgressProvider = FutureProvider<List<BudgetProgress>>((
  ref,
) async {
  final budgets = await ref.watch(activeBudgetsProvider.future);
  final categorySpending = await ref.watch(categorySpendingProvider.future);
  final totalSpending = await ref.watch(thisMonthSpendingProvider.future);

  return budgets.map((budget) {
    Money spent;
    if (budget.category != null) {
      spent = categorySpending[budget.category!] ?? Money.zero;
    } else {
      spent = totalSpending;
    }

    return BudgetProgress(
      budget: budget.copyWith(spent: spent),
      categoryBreakdown: budget.category == null ? categorySpending : null,
    );
  }).toList();
});

/// Budget notifier for mutations
class BudgetNotifier extends StateNotifier<AsyncValue<void>> {
  final BudgetDao _dao;

  BudgetNotifier(this._dao) : super(const AsyncValue.data(null));

  /// Create new budget
  Future<void> createBudget(Budget budget) async {
    state = const AsyncValue.loading();
    try {
      await _dao.insertBudget(budget);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update budget
  Future<void> updateBudget(Budget budget) async {
    state = const AsyncValue.loading();
    try {
      await _dao.updateBudget(budget);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete budget
  Future<void> deleteBudget(String id) async {
    state = const AsyncValue.loading();
    try {
      await _dao.deleteBudget(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update limit
  Future<void> updateLimit(String id, Money newLimit) async {
    final budget = await _dao.getById(id);
    if (budget != null) {
      await updateBudget(budget.copyWith(limit: newLimit));
    }
  }

  /// Reset all budgets (for period change)
  Future<void> resetAllBudgets() async {
    state = const AsyncValue.loading();
    try {
      await _dao.resetAllSpent();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Budget mutation provider
final budgetNotifierProvider =
    StateNotifierProvider<BudgetNotifier, AsyncValue<void>>((ref) {
  final dao = ref.watch(budgetDaoProvider);
  return BudgetNotifier(dao);
});

/// Budget progress with optional category breakdown
class BudgetProgress {
  final Budget budget;
  final Map<TransactionCategory, Money>? categoryBreakdown;

  const BudgetProgress({required this.budget, this.categoryBreakdown});

  /// Top spending categories for overall budget
  List<MapEntry<TransactionCategory, Money>> get topCategories {
    if (categoryBreakdown == null) return [];
    final sorted = categoryBreakdown!.entries.toList()
      ..sort((a, b) => b.value.paisa.compareTo(a.value.paisa));
    return sorted.take(5).toList();
  }
}

// ====== Notification Service Provider ======

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

// ====== Budget Alert Service (SS-062) ======

final budgetAlertServiceProvider = Provider<BudgetAlertService>((ref) {
  final db = ref.watch(databaseProvider);
  return BudgetAlertService(
    database: db,
    // Removed undefined parameter: notificationService
  );
});

/// Stream of budget alerts
final budgetAlertStreamProvider = StreamProvider<BudgetAlert>((ref) {
  final service = ref.watch(budgetAlertServiceProvider);
  return service.alerts;
});

/// Start alert monitoring on app start
final budgetAlertMonitoringProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(budgetAlertServiceProvider);
  service.startAlertMonitoring();
  ref.onDispose(() => service.stopAlertMonitoring());
});

// ====== Balance Tracking Service (SS-064, 065, 066) ======

final balanceTrackingServiceProvider = Provider<BalanceTrackingService>((ref) {
  final db = ref.watch(databaseProvider);
  return BalanceTrackingService(
    database: db,
  );
});

/// Consolidated balance across all accounts
final consolidatedBalanceProvider =
    FutureProvider<ConsolidatedBalanceInfo>((ref) async {
  final service = ref.watch(balanceTrackingServiceProvider);
  return await service.getConsolidatedBalance();
});

/// Balance for specific account
final accountBalanceProvider =
    FutureProvider.family<AccountBalanceInfo?, String>((ref, accountId) async {
  final service = ref.watch(balanceTrackingServiceProvider);
  return await service.getAccountBalance(accountId);
});

/// Stream of low balance alerts
final lowBalanceAlertStreamProvider =
    StreamProvider<LowBalanceAlertEvent>((ref) {
  final service = ref.watch(balanceTrackingServiceProvider);
  return service.lowBalanceAlerts;
});

/// Start balance monitoring on app start
final balanceMonitoringProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(balanceTrackingServiceProvider);
  service.startBalanceMonitoring();
  ref.onDispose(() => service.stopBalanceMonitoring());
});

// ====== Bill Reminder Service (SS-067) ======

final billReminderServiceProvider = Provider<BillReminderService>((ref) {
  final db = ref.watch(databaseProvider);
  final notifications = ref.watch(notificationServiceProvider);
  return BillReminderService(
    database: db,
    notificationService: notifications,
  );
});

/// Stream of bill reminders
final billRemindersProvider = StreamProvider<List<BillReminder>>((ref) {
  final service = ref.watch(billReminderServiceProvider);
  return service.bills;
});

/// Upcoming bills (next 7 days)
final upcomingBillsProvider = FutureProvider<List<BillReminder>>((ref) async {
  final service = ref.watch(billReminderServiceProvider);
  return await service.getUpcomingBills(days: 7);
});

/// Stream of bill reminder alerts
final billAlertStreamProvider = StreamProvider<BillReminderAlert>((ref) {
  final service = ref.watch(billReminderServiceProvider);
  return service.alerts;
});

/// Start bill reminder monitoring on app start
final billReminderMonitoringProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(billReminderServiceProvider);
  service.startReminderMonitoring();
  ref.onDispose(() => service.stopReminderMonitoring());
});

// ====== Financial Calculators (SS-070) ======

final financialCalculatorsProvider = Provider<FinancialCalculators>((ref) {
  return FinancialCalculators();
});

/// EMI calculation
final emiCalculatorProvider =
    Provider.family<EmiResult, EmiInput>((ref, input) {
  final calc = ref.watch(financialCalculatorsProvider);
  return calc.calculateEmi(
    principalPaisa: input.principal,
    annualRatePercent: input.ratePercent,
    tenureMonths: input.tenureMonths,
  );
});

/// SIP returns calculation
final sipCalculatorProvider =
    Provider.family<SipResult, SipInput>((ref, input) {
  final calc = ref.watch(financialCalculatorsProvider);
  return calc.calculateSipReturns(
    monthlyInvestmentPaisa: input.monthlyAmountPaisa,
    expectedAnnualReturnPercent: input.ratePercent,
    years: input.years,
  );
});

/// Compound interest calculation
final compoundInterestProvider =
    Provider.family<CompoundInterestResult, CompoundInput>((ref, input) {
  final calc = ref.watch(financialCalculatorsProvider);
  return calc.calculateCompoundInterest(
    principalPaisa: input.principalPaisa,
    annualRatePercent: input.ratePercent,
    years: input.years,
    compoundingFrequency: input.compoundingFrequency,
  );
});

// Input classes for family providers
class EmiInput {
  final int principal;
  final double ratePercent;
  final int tenureMonths;
  const EmiInput(this.principal, this.ratePercent, this.tenureMonths);
}

class SipInput {
  final int monthlyAmountPaisa;
  final double ratePercent;
  final int years;
  const SipInput(this.monthlyAmountPaisa, this.ratePercent, this.years);
}

class CompoundInput {
  final int principalPaisa;
  final double ratePercent;
  final int years;
  final int compoundingFrequency;
  const CompoundInput(this.principalPaisa, this.ratePercent, this.years,
      [this.compoundingFrequency = 12]);
}

// ====== Investment Tracker (SS-069) ======

final investmentTrackerProvider = Provider<InvestmentTracker>((ref) {
  return InvestmentTracker();
});

/// Portfolio summary
final portfolioSummaryProvider = FutureProvider<PortfolioSummary>((ref) async {
  final tracker = ref.watch(investmentTrackerProvider);
  return tracker.getPortfolioSummary();
});

// ====== Loan Tracker (SS-068) ======

final loanTrackerProvider = Provider<LoanTracker>((ref) {
  return LoanTracker();
});

/// Loan insights
final loanInsightsProvider = FutureProvider<LoanInsights?>((ref) async {
  // Removed unused variable: tracker
  // Load active loan from database when loan DAO is wired
  return null;
});

// ====== All Financial Monitoring ======

/// Provider to start all financial monitoring services
final financialMonitoringProvider = FutureProvider<void>((ref) async {
  // Start all monitoring services
  await ref.watch(budgetAlertMonitoringProvider.future);
  await ref.watch(balanceMonitoringProvider.future);
  await ref.watch(billReminderMonitoringProvider.future);
});
