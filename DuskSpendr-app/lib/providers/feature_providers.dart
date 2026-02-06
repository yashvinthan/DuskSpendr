import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/privacy/privacy_engine.dart';
import '../core/backup/backup_service.dart';
import '../providers/database_provider.dart';
import '../data/local/privacy_store_drift.dart';
import '../data/local/backup_metadata_store_drift.dart';
import '../core/security/encryption_service.dart';
import '../core/linking/oauth_service.dart';
import '../core/linking/account_linking_manager.dart';
import '../core/sms/sms_parser.dart';
import '../core/sync/data_synchronizer.dart';
import '../core/categorization/transaction_categorizer.dart';
import '../core/budget/budget_service.dart';
import '../core/budget/investment_tracker.dart';
import '../core/dashboard/dashboard_service.dart';
import '../core/education/education_service.dart';
import '../core/split/expense_splitting_service.dart';
import '../domain/entities/budget.dart';
import '../domain/entities/money.dart';
import '../core/budget/financial_calculators.dart';
import '../domain/entities/linked_account.dart';

// ====== Core Infrastructure Providers ======

/// Privacy Engine Provider
final privacyEngineProvider = Provider<PrivacyEngine>((ref) {
  final auditDao = ref.watch(auditLogDaoProvider);
  final reportDao = ref.watch(privacyReportDaoProvider);
  final store = DriftPrivacyStore(
    auditLogDao: auditDao,
    privacyReportDao: reportDao,
  );
  return PrivacyEngine(store: store);
});

/// Backup Service Provider
final backupServiceProvider = Provider<BackupService>((ref) {
  final metadataDao = ref.watch(backupMetadataDaoProvider);
  final metadataStore = DriftBackupMetadataStore(dao: metadataDao);
  return BackupService(
    metadataStore: metadataStore,
    privacyEngine: ref.read(privacyEngineProvider),
  );
});

// ====== Account Linking Providers ======

/// OAuth Service Provider
final oauthServiceProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});

/// Account Linking Manager Provider
final accountLinkingManagerProvider = Provider<AccountLinkingManager>((ref) {
  return AccountLinkingManager(
    privacyEngine: ref.read(privacyEngineProvider),
    accountDao: ref.read(accountDaoProvider),
    encryptionService: EncryptionService(),
  );
});

/// Linked Accounts State
final linkedAccountsProvider =
    StateNotifierProvider<LinkedAccountsNotifier, List<LinkedAccount>>((ref) {
  return LinkedAccountsNotifier();
});

class LinkedAccountsNotifier extends StateNotifier<List<LinkedAccount>> {
  LinkedAccountsNotifier() : super([]);

  void addAccount(LinkedAccount account) {
    state = [...state, account];
  }

  void removeAccount(String accountId) {
    state = state.where((a) => a.id != accountId).toList();
  }

  void updateAccount(LinkedAccount updated) {
    state = state.map((a) => a.id == updated.id ? updated : a).toList();
  }
}

// ====== SMS & Sync Providers ======

/// SMS Parser Provider
final smsParserProvider = Provider<SmsParser>((ref) {
  return SmsParser();
});

/// Data Synchronizer Provider
final dataSynchronizerProvider = Provider<DataSynchronizer>((ref) {
  return DataSynchronizer(
    linkingManager: ref.read(accountLinkingManagerProvider),
    smsParser: ref.read(smsParserProvider),
    privacyEngine: ref.read(privacyEngineProvider),
    transactionDao: ref.read(transactionDaoProvider),
    accountDao: ref.read(accountDaoProvider),
    categorizer: ref.read(transactionCategorizerProvider),
  );
});

/// Sync Status Provider
final syncStatusProvider =
    StateNotifierProvider<SyncStatusNotifier, SyncStatus>((ref) {
  return SyncStatusNotifier();
});

class SyncStatusNotifier extends StateNotifier<SyncStatus> {
  SyncStatusNotifier()
      : super(const SyncStatus(
          isActive: false,
          lastSyncAt: null,
          pendingChanges: 0,
        ));

  void startSync() {
    state = state.copyWith(isActive: true);
  }

  void completeSync() {
    state = state.copyWith(
      isActive: false,
      lastSyncAt: DateTime.now(),
      pendingChanges: 0,
    );
  }

  void addPendingChanges(int count) {
    state = state.copyWith(pendingChanges: state.pendingChanges + count);
  }
}

class SyncStatus {
  final bool isActive;
  final DateTime? lastSyncAt;
  final int pendingChanges;

  const SyncStatus({
    required this.isActive,
    this.lastSyncAt,
    required this.pendingChanges,
  });

  SyncStatus copyWith({
    bool? isActive,
    DateTime? lastSyncAt,
    int? pendingChanges,
  }) =>
      SyncStatus(
        isActive: isActive ?? this.isActive,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        pendingChanges: pendingChanges ?? this.pendingChanges,
      );
}

// ====== Categorization Providers ======

/// Transaction Categorizer Provider
final transactionCategorizerProvider = Provider<TransactionCategorizer>((ref) {
  return TransactionCategorizer();
});

/// Merchant Recognizer Provider
final merchantRecognizerProvider = Provider<MerchantRecognizer>((ref) {
  return MerchantRecognizer();
});

// ====== Budget Providers ======

/// Budget Service Provider
final budgetServiceProvider = Provider<BudgetService>((ref) {
  return BudgetService();
});

/// Budgets State Provider
final budgetsProvider =
    StateNotifierProvider<BudgetsNotifier, List<Budget>>((ref) {
  return BudgetsNotifier(ref.read(budgetServiceProvider));
});

class BudgetsNotifier extends StateNotifier<List<Budget>> {
  final BudgetService _service;

  BudgetsNotifier(this._service) : super([]);

  void createBudget({
    required String name,
    required int limitPaisa,
    required BudgetPeriod period,
    String? categoryId,
  }) {
    final budget = _service.createBudget(
      name: name,
      limitPaisa: limitPaisa,
      period: period,
      categoryId: categoryId,
    );
    state = [...state, budget];
  }

  void updateSpent(String budgetId, int spentPaisa) {
    state = state.map((b) {
      if (b.id == budgetId) {
        return b.copyWith(spent: Money.fromPaisa(spentPaisa));
      }
      return b;
    }).toList();
  }

  void deleteBudget(String budgetId) {
    state = state.where((b) => b.id != budgetId).toList();
  }
}

/// Budget Progress Provider
final budgetProgressProvider =
    Provider.family<BudgetProgress?, String>((ref, budgetId) {
  final budgets = ref.watch(budgetsProvider);
  final service = ref.read(budgetServiceProvider);

  final budget = budgets.where((b) => b.id == budgetId).firstOrNull;
  if (budget == null) return null;

  return service.calculateProgress(budget);
});

/// Budget Alerts Provider
final budgetAlertsProvider = Provider<List<BudgetAlert>>((ref) {
  final budgets = ref.watch(budgetsProvider);
  final service = ref.read(budgetServiceProvider);

  final progresses = budgets.map((b) => service.calculateProgress(b)).toList();
  return service.checkBudgetAlerts(progresses);
});

/// Financial Calculators Provider
final calculatorsProvider = Provider<FinancialCalculators>((ref) {
  return FinancialCalculators();
});

// ====== Investment & Loan Providers ======

/// Investment Tracker Provider
final investmentTrackerProvider =
    StateNotifierProvider<InvestmentTrackerNotifier, PortfolioSummary?>((ref) {
  return InvestmentTrackerNotifier();
});

class InvestmentTrackerNotifier extends StateNotifier<PortfolioSummary?> {
  final InvestmentTracker _tracker = InvestmentTracker();

  InvestmentTrackerNotifier() : super(null);

  void addInvestment(Investment investment) {
    _tracker.addInvestment(investment);
    state = _tracker.getPortfolioSummary();
  }

  void recordTransaction(InvestmentTransaction transaction) {
    _tracker.recordTransaction(transaction);
    state = _tracker.getPortfolioSummary();
  }

  List<Investment> getTopGainers(int limit) => _tracker.getTopGainers(limit);
  List<Investment> getTopLosers(int limit) => _tracker.getTopLosers(limit);
}

/// Loan Tracker Provider
final loanTrackerProvider =
    StateNotifierProvider<LoanTrackerNotifier, LoanSummary?>((ref) {
  return LoanTrackerNotifier();
});

class LoanTrackerNotifier extends StateNotifier<LoanSummary?> {
  final LoanTracker _tracker = LoanTracker();

  LoanTrackerNotifier() : super(null);

  void addLoan(Loan loan) {
    _tracker.addLoan(loan);
    state = _tracker.getLoanSummary();
  }

  LoanPaymentResult recordPayment(LoanPayment payment) {
    final result = _tracker.recordPayment(payment);
    state = _tracker.getLoanSummary();
    return result;
  }

  List<AmortizationEntry> getAmortization(String loanId) =>
      _tracker.getAmortizationSchedule(loanId);
}

// ====== Dashboard Providers ======

/// Gamification Service Provider
final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier();
});

class GamificationNotifier extends StateNotifier<GamificationState> {
  final GamificationService _service = GamificationService();

  GamificationNotifier()
      : super(const GamificationState(
          level: UserLevel(
              level: 1,
              currentXp: 0,
              xpForNext: 100,
              xpInCurrentLevel: 0,
              title: 'Beginner'),
          streak: 0,
          achievements: [],
        ));

  void checkAchievement(String achievementId) {
    final unlock = _service.checkAchievement(achievementId);
    if (unlock != null) {
      _updateState();
    }
  }

  void recordCheckIn() {
    _service.recordCheckIn();
    _updateState();
  }

  void _updateState() {
    state = GamificationState(
      level: _service.getCurrentLevel(),
      streak: _service.currentStreak,
      achievements: _service.getAllAchievements(),
    );
  }
}

class GamificationState {
  final UserLevel level;
  final int streak;
  final List<AchievementStatus> achievements;

  const GamificationState({
    required this.level,
    required this.streak,
    required this.achievements,
  });
}

/// Dashboard Chart Service Provider
final dashboardChartProvider = Provider<DashboardChartService>((ref) {
  return DashboardChartService();
});

/// Quick Actions Provider
final quickActionsProvider = Provider<List<QuickAction>>((ref) {
  return QuickActionsService().getQuickActions();
});

/// Onboarding Provider
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingService _service = OnboardingService();

  OnboardingNotifier()
      : super(const OnboardingState(
          currentStep: 0,
          isComplete: false,
        ));

  void nextStep() {
    if (_service.isLastStep(state.currentStep)) {
      state = state.copyWith(isComplete: true);
    } else {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  OnboardingStep getCurrentStepData() => _service.getStep(state.currentStep);
}

class OnboardingState {
  final int currentStep;
  final bool isComplete;

  const OnboardingState({
    required this.currentStep,
    required this.isComplete,
  });

  OnboardingState copyWith({
    int? currentStep,
    bool? isComplete,
  }) =>
      OnboardingState(
        currentStep: currentStep ?? this.currentStep,
        isComplete: isComplete ?? this.isComplete,
      );
}

// ====== Education Providers ======

/// Insights Engine Provider
final insightsEngineProvider = Provider<InsightsEngine>((ref) {
  return InsightsEngine();
});

/// Tips Service Provider
final tipsServiceProvider = Provider<TipsService>((ref) {
  return TipsService();
});

/// Tip of the Day Provider
final tipOfDayProvider = Provider<FinancialTip>((ref) {
  return ref.read(tipsServiceProvider).getTipOfTheDay();
});

/// Lessons Service Provider
final lessonsServiceProvider = Provider<LessonsService>((ref) {
  return LessonsService();
});

/// Learning Progress Provider
final learningProgressProvider = StateNotifierProvider<LearningProgressNotifier,
    Map<String, LessonProgress>>((ref) {
  return LearningProgressNotifier();
});

class LearningProgressNotifier
    extends StateNotifier<Map<String, LessonProgress>> {
  final LearningProgressTracker _tracker = LearningProgressTracker();

  LearningProgressNotifier() : super({});

  void startLesson(String lessonId) {
    _tracker.startLesson(lessonId);
    _updateState();
  }

  void completeChapter(String lessonId, int chapterIndex) {
    _tracker.completeChapter(lessonId, chapterIndex);
    _updateState();
  }

  void recordQuizScore(String lessonId, double score) {
    _tracker.recordQuizScore(lessonId, score);
    _updateState();
  }

  void _updateState() {
    final completedIds = _tracker.getCompletedLessonIds();
    state = {for (final id in completedIds) id: _tracker.getProgress(id)!};
  }

  List<String> getCompletedLessonIds() => _tracker.getCompletedLessonIds();
}

// ====== Shared Expenses Providers ======

/// Expense Splitting Service Provider
final expenseSplittingProvider =
    StateNotifierProvider<ExpenseSplittingNotifier, ExpenseSplittingState>(
        (ref) {
  return ExpenseSplittingNotifier();
});

class ExpenseSplittingNotifier extends StateNotifier<ExpenseSplittingState> {
  final ExpenseSplittingService _service = ExpenseSplittingService();

  ExpenseSplittingNotifier()
      : super(const ExpenseSplittingState(
          friends: [],
          groups: [],
          myBalance: 0,
          owedToMe: 0,
          iOwe: 0,
        ));

  void addFriend({required String name, String? phone, String? upiId}) {
    _service.addFriend(name: name, phone: phone, upiId: upiId);
    _updateState();
  }

  void createGroup({
    required String name,
    required List<String> memberIds,
    String? description,
    GroupType type = GroupType.general,
  }) {
    _service.createGroup(
      name: name,
      memberIds: memberIds,
      description: description,
      type: type,
    );
    _updateState();
  }

  void createEqualSplit({
    required String description,
    required int totalAmountPaisa,
    required String paidByMemberId,
    required List<String> memberIds,
    String? groupId,
    String? category,
  }) {
    _service.createEqualSplit(
      description: description,
      totalAmountPaisa: totalAmountPaisa,
      paidByMemberId: paidByMemberId,
      memberIds: memberIds,
      groupId: groupId,
      category: category,
    );
    _updateState();
  }

  void recordSettlement({
    required String fromMemberId,
    required String toMemberId,
    required int amountPaisa,
    SettlementMethod method = SettlementMethod.cash,
    String? groupId,
  }) {
    _service.recordSettlement(
      fromMemberId: fromMemberId,
      toMemberId: toMemberId,
      amountPaisa: amountPaisa,
      method: method,
      groupId: groupId,
    );
    _updateState();
  }

  List<SimplifiedDebt> getSimplifiedDebts({String? groupId}) {
    return _service.getSimplifiedDebts(groupId: groupId);
  }

  String generateUpiLink({
    required String upiId,
    required int amountPaisa,
    required String description,
  }) {
    return _service.generateUpiLink(
      upiId: upiId,
      amountPaisa: amountPaisa,
      description: description,
    );
  }

  void _updateState() {
    final summary = _service.getMemberSummary('self');
    state = ExpenseSplittingState(
      friends: _service.getAllFriends(),
      groups: _service.getAllGroups(),
      myBalance: summary.netBalancePaisa,
      owedToMe: summary.totalOwedToYouPaisa,
      iOwe: summary.totalYouOwePaisa,
    );
  }
}

class ExpenseSplittingState {
  final List<Friend> friends;
  final List<ExpenseGroup> groups;
  final int myBalance;
  final int owedToMe;
  final int iOwe;

  const ExpenseSplittingState({
    required this.friends,
    required this.groups,
    required this.myBalance,
    required this.owedToMe,
    required this.iOwe,
  });
}

/// Receipt Scanner Provider
final receiptScannerProvider = Provider<ReceiptScanner>((ref) {
  return ReceiptScanner();
});

/// Settlement Reminder Provider
final settlementRemindersProvider = Provider<List<SettlementReminder>>((ref) {
  ref.watch(expenseSplittingProvider);
  // This would normally use the SettlementReminderService and debts
  // For now, return empty list as debts require service method access
  return [];
});
