import 'dart:async';

import '../../data/local/database.dart';
import '../../domain/entities/entities.dart';

/// SS-064, SS-065, SS-066: Account Balance Tracking
/// Track balances, consolidated dashboard, low balance alerts

class BalanceTrackingService {
  final AppDatabase _database;

  // In-memory cache for quick access
  final Map<String, AccountBalanceInfo> _balanceCache = {};
  final _balanceController = StreamController<ConsolidatedBalanceInfo>.broadcast();

  Stream<ConsolidatedBalanceInfo> get balanceStream => _balanceController.stream;

  // Low balance thresholds per account
  final Map<String, int> _lowBalanceThresholds = {};
  static const _defaultLowBalanceThreshold = 100000; // ₹1000

  BalanceTrackingService({required AppDatabase database}) : _database = database;

  // ====== SS-064: Account Balance Tracking ======

  /// Update balance from SMS parsing
  Future<void> updateBalanceFromSms({
    required String accountId,
    required int balancePaisa,
    required DateTime timestamp,
  }) async {
    await _updateBalance(
      accountId: accountId,
      balancePaisa: balancePaisa,
      source: BalanceUpdateSource.sms,
      timestamp: timestamp,
    );
  }

  /// Update balance from API sync
  Future<void> updateBalanceFromApi({
    required String accountId,
    required int balancePaisa,
    required DateTime timestamp,
  }) async {
    await _updateBalance(
      accountId: accountId,
      balancePaisa: balancePaisa,
      source: BalanceUpdateSource.api,
      timestamp: timestamp,
    );
  }

  /// Update balance from transaction calculation
  Future<void> updateBalanceFromTransaction({
    required String accountId,
    required int transactionAmountPaisa,
    required bool isDebit,
  }) async {
    final current = _balanceCache[accountId];
    if (current == null) return;

    final newBalance = isDebit
        ? current.balancePaisa - transactionAmountPaisa
        : current.balancePaisa + transactionAmountPaisa;

    await _updateBalance(
      accountId: accountId,
      balancePaisa: newBalance,
      source: BalanceUpdateSource.calculated,
      timestamp: DateTime.now(),
    );
  }

  Future<void> _updateBalance({
    required String accountId,
    required int balancePaisa,
    required BalanceUpdateSource source,
    required DateTime timestamp,
  }) async {
    // Update cache
    final existing = _balanceCache[accountId];
    _balanceCache[accountId] = AccountBalanceInfo(
      accountId: accountId,
      accountName: existing?.accountName ?? 'Unknown',
      accountType: existing?.accountType ?? AccountType.bank,
      balancePaisa: balancePaisa,
      lastUpdated: timestamp,
      updateSource: source,
    );

    // Store snapshot for history
    await _storeBalanceSnapshot(accountId, balancePaisa, timestamp);

    // Check low balance
    _checkLowBalance(accountId, balancePaisa);

    // Emit consolidated update
    final consolidated = calculateConsolidated();
    _balanceController.add(consolidated);
  }

  Future<void> _storeBalanceSnapshot(
    String accountId,
    int balancePaisa,
    DateTime timestamp,
  ) async {
    // Store in database for history charts
    // Implementation would use BalanceSnapshotsDao
  }

  // ====== SS-065: Consolidated Balance Dashboard ======

  /// Calculate total balance across all accounts
  ConsolidatedBalanceInfo calculateConsolidated() {
    int totalPaisa = 0;
    int bankTotal = 0;
    int walletTotal = 0;
    int creditAvailable = 0;

    for (final balance in _balanceCache.values) {
      totalPaisa += balance.balancePaisa;

      switch (balance.accountType) {
        case AccountType.bank:
          bankTotal += balance.balancePaisa;
          break;
        case AccountType.wallet:
          walletTotal += balance.balancePaisa;
          break;
        case AccountType.creditCard:
          creditAvailable += balance.balancePaisa;
          break;
        case AccountType.investment:
          // Investments tracked separately
          break;
      }
    }

    return ConsolidatedBalanceInfo(
      totalBalancePaisa: totalPaisa,
      bankBalancePaisa: bankTotal,
      walletBalancePaisa: walletTotal,
      creditAvailablePaisa: creditAvailable,
      accountCount: _balanceCache.length,
      accounts: _balanceCache.values.toList(),
      lastUpdated: DateTime.now(),
    );
  }

  /// Get balance history for trend charts
  Future<List<BalanceHistoryPoint>> getBalanceHistory({
    String? accountId,
    required Duration period,
    int? maxPoints,
  }) async {
    final since = DateTime.now().subtract(period);
    // Implementation would query BalanceSnapshots table
    return [];
  }

  /// Get balance distribution for pie chart
  BalanceDistribution getBalanceDistribution() {
    final byType = <AccountType, int>{};
    final byAccount = <String, int>{};

    for (final balance in _balanceCache.values) {
      byType[balance.accountType] = 
          (byType[balance.accountType] ?? 0) + balance.balancePaisa;
      byAccount[balance.accountName] = balance.balancePaisa;
    }

    return BalanceDistribution(
      byAccountType: byType,
      byAccount: byAccount,
      totalPaisa: calculateConsolidated().totalBalancePaisa,
    );
  }

  // ====== SS-066: Low Balance Alerts ======

  /// Set low balance threshold for an account
  void setLowBalanceThreshold(String accountId, int thresholdPaisa) {
    _lowBalanceThresholds[accountId] = thresholdPaisa;
  }

  /// Set global low balance threshold
  void setGlobalLowBalanceThreshold(int thresholdPaisa) {
    _lowBalanceThresholds['__global__'] = thresholdPaisa;
  }

  int _getThreshold(String accountId) {
    return _lowBalanceThresholds[accountId] ??
        _lowBalanceThresholds['__global__'] ??
        _defaultLowBalanceThreshold;
  }

  final _lowBalanceController = StreamController<LowBalanceAlertEvent>.broadcast();
  Stream<LowBalanceAlertEvent> get lowBalanceAlerts => _lowBalanceController.stream;

  void _checkLowBalance(String accountId, int balancePaisa) {
    final threshold = _getThreshold(accountId);
    
    if (balancePaisa < threshold) {
      final account = _balanceCache[accountId];
      _lowBalanceController.add(LowBalanceAlertEvent(
        accountId: accountId,
        accountName: account?.accountName ?? 'Unknown',
        currentBalancePaisa: balancePaisa,
        thresholdPaisa: threshold,
        timestamp: DateTime.now(),
      ));
    }
  }

  /// Get accounts below their threshold
  List<LowBalanceAlertEvent> getAccountsBelowThreshold() {
    final alerts = <LowBalanceAlertEvent>[];

    for (final balance in _balanceCache.values) {
      final threshold = _getThreshold(balance.accountId);
      if (balance.balancePaisa < threshold) {
        alerts.add(LowBalanceAlertEvent(
          accountId: balance.accountId,
          accountName: balance.accountName,
          currentBalancePaisa: balance.balancePaisa,
          thresholdPaisa: threshold,
          timestamp: DateTime.now(),
        ));
      }
    }

    return alerts;
  }

  /// Load balances from database
  Future<void> loadBalances() async {
    // Implementation would query LinkedAccounts table
  }

  void dispose() {
    _balanceController.close();
    _lowBalanceController.close();
  }
}

// ====== Data Classes ======

enum BalanceUpdateSource { sms, api, calculated, manual }

enum AccountType { bank, wallet, creditCard, investment }

class AccountBalanceInfo {
  final String accountId;
  final String accountName;
  final AccountType accountType;
  final int balancePaisa;
  final DateTime lastUpdated;
  final BalanceUpdateSource updateSource;

  const AccountBalanceInfo({
    required this.accountId,
    required this.accountName,
    required this.accountType,
    required this.balancePaisa,
    required this.lastUpdated,
    required this.updateSource,
  });

  /// Format balance for display
  String get formattedBalance {
    final amount = balancePaisa / 100;
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '₹${amount.toStringAsFixed(2)}';
  }
}

class ConsolidatedBalanceInfo {
  final int totalBalancePaisa;
  final int bankBalancePaisa;
  final int walletBalancePaisa;
  final int creditAvailablePaisa;
  final int accountCount;
  final List<AccountBalanceInfo> accounts;
  final DateTime lastUpdated;

  const ConsolidatedBalanceInfo({
    required this.totalBalancePaisa,
    required this.bankBalancePaisa,
    required this.walletBalancePaisa,
    required this.creditAvailablePaisa,
    required this.accountCount,
    required this.accounts,
    required this.lastUpdated,
  });

  /// Format total balance for big number display
  String get formattedTotal {
    final amount = totalBalancePaisa / 100;
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)} K';
    }
    return '₹${amount.toStringAsFixed(2)}';
  }
}

class BalanceHistoryPoint {
  final DateTime timestamp;
  final int balancePaisa;
  final String? accountId;

  const BalanceHistoryPoint({
    required this.timestamp,
    required this.balancePaisa,
    this.accountId,
  });
}

class BalanceDistribution {
  final Map<AccountType, int> byAccountType;
  final Map<String, int> byAccount;
  final int totalPaisa;

  const BalanceDistribution({
    required this.byAccountType,
    required this.byAccount,
    required this.totalPaisa,
  });

  /// Get percentage for an account type
  double getPercentage(AccountType type) {
    if (totalPaisa == 0) return 0;
    return (byAccountType[type] ?? 0) / totalPaisa * 100;
  }
}

class LowBalanceAlertEvent {
  final String accountId;
  final String accountName;
  final int currentBalancePaisa;
  final int thresholdPaisa;
  final DateTime timestamp;

  const LowBalanceAlertEvent({
    required this.accountId,
    required this.accountName,
    required this.currentBalancePaisa,
    required this.thresholdPaisa,
    required this.timestamp,
  });

  /// How much below threshold
  int get shortfallPaisa => thresholdPaisa - currentBalancePaisa;
}
