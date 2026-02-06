import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/local/daos/account_dao.dart';
import '../../data/local/daos/transaction_dao.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/linked_account.dart';
import '../../domain/entities/money.dart';
import '../../domain/entities/transaction.dart';
import '../categorization/transaction_categorizer.dart';
import '../linking/account_linking_manager.dart';
import '../linking/account_linker.dart';
import '../privacy/privacy_engine.dart';
import '../sms/financial_institution_database.dart';
import '../sms/sms_parser.dart';
import 'sync_upload_service.dart';

/// SS-030 to SS-032, SS-040, SS-041: Data Synchronization System
/// Interface design, sync scheduling, error handling, real-time sync,
/// UPI notification handling, batch transaction sync

/// Data Synchronizer main class
class DataSynchronizer {
  final AccountLinkingManager _linkingManager;
  // ignore: unused_field
  final SmsParser _smsParser;
  final PrivacyEngine _privacyEngine;
  final TransactionDao? _transactionDao;
  final AccountDao? _accountDao;
  final TransactionCategorizer _categorizer;
  final SyncUploadService? _syncUpload;
  static const _storage = FlutterSecureStorage();

  // Sync state
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  Timer? _backgroundSyncTimer;
  bool _isSyncing = false;

  // Circuit breaker for failed syncs
  final Map<AccountProviderType, CircuitBreaker> _circuitBreakers = {};

  DataSynchronizer({
    AccountLinkingManager? linkingManager,
    SmsParser? smsParser,
    PrivacyEngine? privacyEngine,
    TransactionDao? transactionDao,
    AccountDao? accountDao,
    TransactionCategorizer? categorizer,
    SyncUploadService? syncUpload,
  })  : _linkingManager = linkingManager ?? AccountLinkingManager(),
        _smsParser = smsParser ?? SmsParser(),
        _privacyEngine = privacyEngine ?? PrivacyEngine(),
        _transactionDao = transactionDao,
        _accountDao = accountDao,
        _categorizer = categorizer ?? TransactionCategorizer(),
        _syncUpload = syncUpload;

  // ====== SS-031: Real-time Transaction Sync ======

  /// Start background sync with configurable interval
  void startBackgroundSync({Duration interval = const Duration(minutes: 5)}) {
    stopBackgroundSync();

    // Initial sync
    syncAll();

    // Schedule periodic syncs
    _backgroundSyncTimer = Timer.periodic(interval, (_) => syncAll());
  }

  void stopBackgroundSync() {
    _backgroundSyncTimer?.cancel();
    _backgroundSyncTimer = null;
  }

  /// Sync all linked accounts
  Future<SyncResult> syncAll() async {
    if (_isSyncing) {
      return const SyncResult(
        success: false,
        error: 'Sync already in progress',
      );
    }

    _isSyncing = true;
    _emitStatus(SyncState.syncing, 'Syncing all accounts...');

    try {
      await _privacyEngine.logDataAccess(
        type: DataAccessType.sync,
        entity: 'all_accounts',
        details: 'Full sync started',
      );

      final linkedProviders = await _linkingManager.getLinkedProviders();
      final results = <AccountProviderType, AccountSyncResult>{};

      for (final provider in linkedProviders) {
        // Check circuit breaker
        final breaker = _getCircuitBreaker(provider);
        if (!breaker.canAttempt()) {
          results[provider] = const AccountSyncResult(
            success: false,
            error: 'Too many failures, waiting before retry',
          );
          continue;
        }

        _emitStatus(SyncState.syncing, 'Syncing ${provider.name}...');

        final result = await _syncAccount(provider);
        results[provider] = result;

        if (result.success) {
          breaker.recordSuccess();
        } else {
          breaker.recordFailure();
        }
      }

      final allSuccess = results.values.every((r) => r.success);

      await _updateLastSyncTime();

      _emitStatus(
        allSuccess ? SyncState.idle : SyncState.error,
        allSuccess ? 'Sync complete' : 'Some accounts failed to sync',
      );

      return SyncResult(
        success: allSuccess,
        accountResults: results,
      );
    } catch (e) {
      _emitStatus(SyncState.error, 'Sync failed: $e');
      return SyncResult(
        success: false,
        error: e.toString(),
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync a single account
  Future<AccountSyncResult> syncAccount(AccountProviderType provider) async {
    if (_isSyncing) {
      return const AccountSyncResult(
        success: false,
        error: 'Sync already in progress',
      );
    }

    _isSyncing = true;
    _emitStatus(SyncState.syncing, 'Syncing ${provider.name}...');

    try {
      final result = await _syncAccount(provider);
      _emitStatus(
        result.success ? SyncState.idle : SyncState.error,
        result.success ? 'Sync complete' : result.error ?? 'Sync failed',
      );
      return result;
    } finally {
      _isSyncing = false;
    }
  }

  Future<AccountSyncResult> _syncAccount(AccountProviderType provider) async {
    try {
      await _privacyEngine.logDataAccess(
        type: DataAccessType.sync,
        entity: 'account',
        details: 'Syncing ${provider.name}',
      );

      // Fetch from last sync time
      final lastSync = await _getLastSyncTime(provider);

      final result = await _linkingManager.fetchTransactions(
        type: provider,
        from: lastSync,
      );

      if (!result.success) {
        return AccountSyncResult(
          success: false,
          error: result.error,
        );
      }

      final ingestion = await _ingestProviderTransactions(
        provider: provider,
        transactions: result.transactions,
      );

      // Fetch balance
      final balanceResult = await _linkingManager.fetchBalance(provider);

      if (_accountDao != null) {
        final account = await _getAccountForProvider(provider);
        if (account != null) {
          if (balanceResult.success && balanceResult.balancePaisa != null) {
            await _accountDao!.updateBalance(
              account.id,
              Money.fromPaisa(balanceResult.balancePaisa!),
            );
          }
          await _accountDao!.updateSyncStatus(account.id, AccountStatus.active);
        }
      }

      await _setLastSyncTime(provider, DateTime.now());

      return AccountSyncResult(
        success: true,
        transactionCount: result.transactions.length,
        ingestedCount: ingestion.inserted,
        skippedCount: ingestion.skipped,
        transactions: result.transactions,
        balance: balanceResult.success ? balanceResult.balancePaisa : null,
      );
    } catch (e) {
      return AccountSyncResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  // ====== SS-032: UPI Notification Handler ======

  /// Process a UPI payment notification
  Future<UpiNotificationResult> processUpiNotification(
      UpiNotification notification) async {
    try {
      await _privacyEngine.logDataAccess(
        type: DataAccessType.write,
        entity: 'upi_notification',
        details: 'Processing ${notification.app} notification',
      );

      // Parse the notification content
      final parsed = _parseUpiNotification(notification);

      if (parsed == null) {
        return const UpiNotificationResult(
          success: false,
          error: 'Could not parse notification',
        );
      }

      await ingestParsedTransaction(parsed);

      return UpiNotificationResult(
        success: true,
        transaction: parsed,
      );
    } catch (e) {
      return UpiNotificationResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  ParsedTransaction? _parseUpiNotification(UpiNotification notification) {
    // Parse based on app type
    switch (notification.app) {
      case UpiApp.gpay:
        return _parseGpayNotification(notification);
      case UpiApp.phonepe:
        return _parsePhonepeNotification(notification);
      case UpiApp.paytm:
        return _parsePaytmNotification(notification);
    }
  }

  Future<IngestionSummary> ingestParsedTransaction(
      ParsedTransaction parsed) async {
    if (_transactionDao == null) {
      return const IngestionSummary(inserted: 0, skipped: 0);
    }

    final reference = _normalizedReferenceId(parsed.referenceId, null);
    if (reference != null && reference.isNotEmpty) {
      final exists = await _transactionDao!.existsByReferenceId(reference);
      if (exists) {
        return const IngestionSummary(inserted: 0, skipped: 1);
      }
    } else {
      final exists = await _transactionDao!.existsBySignature(
        amountPaisa: parsed.amountPaisa,
        timestamp: parsed.timestamp,
        merchantName: parsed.merchantName,
      );
      if (exists) {
        return const IngestionSummary(inserted: 0, skipped: 1);
      }
    }

    final categoryResult = await _categorizer.categorize(
      merchantName: parsed.merchantName,
      description: parsed.rawSmsBody,
      amountPaisa: parsed.amountPaisa,
      upiId: parsed.upiId,
    );

    final linkedAccountId = await _resolveAccountIdForInstitution(
      parsed.institution,
      parsed.accountNumber,
    );

    final tx = Transaction(
      amount: Money.fromPaisa(parsed.amountPaisa),
      type: parsed.isDebit ? TransactionType.debit : TransactionType.credit,
      category: categoryResult.category,
      merchantName: parsed.merchantName,
      description: parsed.rawSmsBody,
      timestamp: parsed.timestamp,
      source: TransactionSource.sms,
      paymentMethod: _paymentMethodForInstitution(parsed.institution),
      linkedAccountId: linkedAccountId,
      referenceId: reference,
      categoryConfidence: categoryResult.confidence,
      isRecurring: false,
      tags: const [],
    );

    await _transactionDao!.insertTransaction(tx);
    await _syncUpload?.enqueueTransactionId(tx.id);
    return const IngestionSummary(inserted: 1, skipped: 0);
  }

  ParsedTransaction? _parseGpayNotification(UpiNotification notification) {
    // GPay format: "Received ₹100 from John" or "Paid ₹100 to Swiggy"
    final text = notification.text.toLowerCase();

    final amountMatch =
        RegExp(r'₹\s*([\d,]+(?:\.\d{2})?)').firstMatch(notification.text);
    if (amountMatch == null) return null;

    final amount =
        double.tryParse(amountMatch.group(1)?.replaceAll(',', '') ?? '');
    if (amount == null) return null;

    final isDebit = text.contains('paid') || text.contains('sent');

    // Extract recipient/sender name
    String? name;
    final toMatch =
        RegExp(r'(?:to|from)\s+([A-Za-z\s]+)').firstMatch(notification.text);
    name = toMatch?.group(1)?.trim();

    return ParsedTransaction(
      amountPaisa: (amount * 100).round(),
      isDebit: isDebit,
      timestamp: notification.timestamp,
      merchantName: name,
      institution: FinancialInstitution.gpay,
      confidence: 0.9,
      rawSmsBody: notification.text,
    );
  }

  ParsedTransaction? _parsePhonepeNotification(UpiNotification notification) {
    // PhonePe format: "Payment of ₹100 to Merchant successful"
    final text = notification.text.toLowerCase();

    final amountMatch =
        RegExp(r'₹\s*([\d,]+(?:\.\d{2})?)').firstMatch(notification.text);
    if (amountMatch == null) return null;

    final amount =
        double.tryParse(amountMatch.group(1)?.replaceAll(',', '') ?? '');
    if (amount == null) return null;

    final isDebit = text.contains('payment') ||
        text.contains('paid') ||
        text.contains('sent');

    String? name;
    final toMatch = RegExp(r'to\s+([A-Za-z\s]+?)(?:\s+successful|$)')
        .firstMatch(notification.text);
    name = toMatch?.group(1)?.trim();

    return ParsedTransaction(
      amountPaisa: (amount * 100).round(),
      isDebit: isDebit,
      timestamp: notification.timestamp,
      merchantName: name,
      institution: FinancialInstitution.phonepe,
      confidence: 0.9,
      rawSmsBody: notification.text,
    );
  }

  ParsedTransaction? _parsePaytmNotification(UpiNotification notification) {
    // Similar parsing logic
    final text = notification.text.toLowerCase();

    final amountMatch =
        RegExp(r'₹\s*([\d,]+(?:\.\d{2})?)').firstMatch(notification.text);
    if (amountMatch == null) return null;

    final amount =
        double.tryParse(amountMatch.group(1)?.replaceAll(',', '') ?? '');
    if (amount == null) return null;

    final isDebit = text.contains('paid') ||
        text.contains('sent') ||
        text.contains('transferred');

    return ParsedTransaction(
      amountPaisa: (amount * 100).round(),
      isDebit: isDebit,
      timestamp: notification.timestamp,
      institution: FinancialInstitution.paytm,
      confidence: 0.85,
      rawSmsBody: notification.text,
    );
  }

  // ====== SS-041: Batch Transaction Sync (Historical) ======

  /// Fetch historical transactions (up to 90 days)
  Future<BatchSyncResult> fetchHistoricalTransactions({
    required AccountProviderType provider,
    int daysBack = 90,
    void Function(int fetched, int total)? onProgress,
  }) async {
    await _privacyEngine.logDataAccess(
      type: DataAccessType.sync,
      entity: 'historical_transactions',
      details: 'Fetching $daysBack days of history from ${provider.name}',
    );

    final fromDate = DateTime.now().subtract(Duration(days: daysBack));
    final allTransactions = <ProviderTransaction>[];
    String? cursor;
    int page = 0;

    try {
      do {
        // Rate limiting: wait between requests
        if (page > 0) {
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final result = await _linkingManager.fetchTransactions(
          type: provider,
          from: fromDate,
          cursor: cursor,
        );

        if (!result.success) {
          return BatchSyncResult(
            success: false,
            error: result.error,
            transactionsFetched: allTransactions.length,
          );
        }

        allTransactions.addAll(result.transactions);
        cursor = result.nextCursor;
        page++;

        onProgress?.call(allTransactions.length, -1);
      } while (cursor != null && page < 100); // Safety limit

      return BatchSyncResult(
        success: true,
        transactionsFetched: allTransactions.length,
        transactions: allTransactions,
      );
    } catch (e) {
      return BatchSyncResult(
        success: false,
        error: e.toString(),
        transactionsFetched: allTransactions.length,
      );
    }
  }

  // ====== SS-040: Sync Status ======

  /// Get current sync status
  Future<SyncStatusInfo> getSyncStatus() async {
    final lastSync = await _getLastSyncTimeGlobal();
    final linkedProviders = await _linkingManager.getLinkedProviders();

    final providerStatuses = <AccountProviderType, ProviderSyncStatus>{};
    for (final provider in linkedProviders) {
      final providerLastSync = await _getLastSyncTime(provider);
      final breaker = _getCircuitBreaker(provider);

      providerStatuses[provider] = ProviderSyncStatus(
        lastSyncTime: providerLastSync,
        isHealthy: breaker.canAttempt(),
        failureCount: breaker.failureCount,
      );
    }

    return SyncStatusInfo(
      isSyncing: _isSyncing,
      lastSyncTime: lastSync,
      providerStatuses: providerStatuses,
    );
  }

  void _emitStatus(SyncState state, String message) {
    _syncStatusController.add(SyncStatus(state: state, message: message));
  }

  // ====== Helper Methods ======

  CircuitBreaker _getCircuitBreaker(AccountProviderType provider) {
    return _circuitBreakers.putIfAbsent(
      provider,
      () => CircuitBreaker(),
    );
  }

  Future<void> _updateLastSyncTime() async {
    await _storage.write(
      key: 'last_sync_time',
      value: DateTime.now().toIso8601String(),
    );
  }

  Future<DateTime?> _getLastSyncTimeGlobal() async {
    final str = await _storage.read(key: 'last_sync_time');
    if (str == null) return null;
    return DateTime.parse(str);
  }

  Future<DateTime?> _getLastSyncTime(AccountProviderType provider) async {
    final str = await _storage.read(key: 'last_sync_${provider.name}');
    if (str == null) return null;
    return DateTime.parse(str);
  }

  Future<void> _setLastSyncTime(
      AccountProviderType provider, DateTime time) async {
    await _storage.write(
      key: 'last_sync_${provider.name}',
      value: time.toIso8601String(),
    );
  }

  void dispose() {
    stopBackgroundSync();
    _syncStatusController.close();
  }

  Future<IngestionSummary> _ingestProviderTransactions({
    required AccountProviderType provider,
    required List<ProviderTransaction> transactions,
  }) async {
    if (_transactionDao == null) {
      return const IngestionSummary(inserted: 0, skipped: 0);
    }

    int inserted = 0;
    int skipped = 0;

    final linkedAccountId = await _resolveAccountIdForProvider(provider);
    final source = _sourceForProvider(provider);
    final paymentMethod = _paymentMethodForProvider(provider);

    for (final item in transactions) {
      final referenceId = _normalizedReferenceId(
        item.referenceId,
        item.providerId.isNotEmpty
            ? '${provider.name}:${item.providerId}'
            : null,
      );
      if (referenceId != null && referenceId.isNotEmpty) {
        final exists = await _transactionDao!.existsByReferenceId(referenceId);
        if (exists) {
          skipped++;
          continue;
        }
      } else {
        final exists = await _transactionDao!.existsBySignature(
          amountPaisa: item.amountPaisa,
          timestamp: item.timestamp,
          merchantName: item.merchantName,
        );
        if (exists) {
          skipped++;
          continue;
        }
      }

      final categoryResult = await _categorizer.categorize(
        merchantName: item.merchantName,
        description: item.description,
        amountPaisa: item.amountPaisa,
        upiId: item.upiId,
      );

      final tx = Transaction(
        amount: Money.fromPaisa(item.amountPaisa),
        type: item.isDebit ? TransactionType.debit : TransactionType.credit,
        category: categoryResult.category,
        merchantName: item.merchantName,
        description: item.description,
        timestamp: item.timestamp,
        source: source,
        paymentMethod: paymentMethod,
        linkedAccountId: linkedAccountId,
        referenceId: referenceId,
        categoryConfidence: categoryResult.confidence,
        isRecurring: false,
        tags: const [],
      );

      await _transactionDao!.insertTransaction(tx);
      await _syncUpload?.enqueueTransactionId(tx.id);
      inserted++;
    }

    return IngestionSummary(inserted: inserted, skipped: skipped);
  }

  TransactionSource _sourceForProvider(AccountProviderType provider) {
    switch (provider.category) {
      case ProviderCategory.bank:
      case ProviderCategory.wallet:
        return TransactionSource.bankApi;
      case ProviderCategory.upi:
        return TransactionSource.upiNotification;
      case ProviderCategory.bnpl:
      case ProviderCategory.investment:
        return TransactionSource.imported;
    }
  }

  PaymentMethod? _paymentMethodForProvider(AccountProviderType provider) {
    switch (provider.category) {
      case ProviderCategory.upi:
        return PaymentMethod.upi;
      case ProviderCategory.wallet:
        return PaymentMethod.wallet;
      case ProviderCategory.bnpl:
        return PaymentMethod.bnpl;
      case ProviderCategory.bank:
      case ProviderCategory.investment:
        return null;
    }
  }

  PaymentMethod? _paymentMethodForInstitution(
      FinancialInstitution institution) {
    if (_isUpiInstitution(institution)) {
      return PaymentMethod.upi;
    }
    if (_isBnplInstitution(institution)) {
      return PaymentMethod.bnpl;
    }
    return null;
  }

  Future<String?> _resolveAccountIdForProvider(
      AccountProviderType provider) async {
    if (_accountDao == null) return null;
    final account = await _getAccountForProvider(provider);
    return account?.id;
  }

  Future<LinkedAccount?> _getAccountForProvider(
      AccountProviderType provider) async {
    if (_accountDao == null) return null;
    try {
      final mapped = AccountProvider.values.byName(provider.name);
      return _accountDao!.getByProvider(mapped);
    } catch (_) {
      return null;
    }
  }

  Future<List<LinkedAccount>> _getAccountsForProvider(
    AccountProviderType provider,
  ) async {
    if (_accountDao == null) return [];
    try {
      final mapped = AccountProvider.values.byName(provider.name);
      return _accountDao!.getAllByProvider(mapped);
    } catch (_) {
      return [];
    }
  }

  Future<String?> _resolveAccountIdForInstitution(
    FinancialInstitution institution,
    String? accountNumber,
  ) async {
    if (_accountDao == null) return null;

    AccountProviderType? providerType;
    switch (institution) {
      case FinancialInstitution.sbi:
        providerType = AccountProviderType.sbi;
        break;
      case FinancialInstitution.hdfc:
        providerType = AccountProviderType.hdfc;
        break;
      case FinancialInstitution.icici:
        providerType = AccountProviderType.icici;
        break;
      case FinancialInstitution.axis:
        providerType = AccountProviderType.axis;
        break;
      case FinancialInstitution.gpay:
        providerType = AccountProviderType.gpay;
        break;
      case FinancialInstitution.phonepe:
        providerType = AccountProviderType.phonepe;
        break;
      case FinancialInstitution.paytm:
        providerType = AccountProviderType.paytmUpi;
        break;
      case FinancialInstitution.amazonPay:
        providerType = AccountProviderType.amazonPay;
        break;
      case FinancialInstitution.lazypay:
        providerType = AccountProviderType.lazypay;
        break;
      case FinancialInstitution.simpl:
        providerType = AccountProviderType.simpl;
        break;
      default:
        providerType = null;
        break;
    }

    if (providerType == null) return null;

    final candidates = await _getAccountsForProvider(providerType);
    if (candidates.isEmpty) return null;

    final targetLast4 = _last4Digits(accountNumber);
    AccountMatchResult? best;

    for (final account in candidates) {
      final confidence = _computeAccountMatchConfidence(account, targetLast4);
      if (best == null || confidence > best.confidence) {
        best =
            AccountMatchResult(accountId: account.id, confidence: confidence);
      }
    }

    if (best == null || best.confidence < 0.6) {
      return null;
    }

    return best.accountId;
  }

  String? _normalizedReferenceId(String? referenceId, String? fallback) {
    if (referenceId != null && referenceId.trim().isNotEmpty) {
      return referenceId.trim();
    }
    if (fallback != null && fallback.trim().isNotEmpty) {
      return fallback.trim();
    }
    return null;
  }

  bool _isUpiInstitution(FinancialInstitution institution) {
    switch (institution) {
      case FinancialInstitution.gpay:
      case FinancialInstitution.phonepe:
      case FinancialInstitution.paytm:
      case FinancialInstitution.amazonPay:
        return true;
      default:
        return false;
    }
  }

  bool _isBnplInstitution(FinancialInstitution institution) {
    switch (institution) {
      case FinancialInstitution.lazypay:
      case FinancialInstitution.simpl:
        return true;
      default:
        return false;
    }
  }

  double _computeAccountMatchConfidence(
    LinkedAccount account,
    String? targetLast4,
  ) {
    double score = 0.6;
    if (account.isPrimary) {
      score += 0.1;
    }

    final accountLast4 = _last4Digits(account.accountNumber);
    if (targetLast4 != null && accountLast4 != null) {
      score += targetLast4 == accountLast4 ? 0.3 : -0.3;
    }

    return score.clamp(0.0, 1.0);
  }

  String? _last4Digits(String? value) {
    if (value == null || value.isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    if (digits.length <= 4) return digits;
    return digits.substring(digits.length - 4);
  }
}

/// Circuit breaker for handling repeated failures
class CircuitBreaker {
  int _failureCount = 0;
  DateTime? _lastFailure;

  static const _maxFailures = 5;
  static const _cooldownDuration = Duration(minutes: 15);

  int get failureCount => _failureCount;

  bool canAttempt() {
    if (_failureCount < _maxFailures) return true;
    if (_lastFailure == null) return true;

    // Check if cooldown has passed
    if (DateTime.now().difference(_lastFailure!) > _cooldownDuration) {
      _reset();
      return true;
    }

    return false;
  }

  void recordSuccess() {
    _reset();
  }

  void recordFailure() {
    _failureCount++;
    _lastFailure = DateTime.now();
  }

  void _reset() {
    _failureCount = 0;
    _lastFailure = null;
  }
}

// ====== Data Classes ======

enum SyncState { idle, syncing, error }

class SyncStatus {
  final SyncState state;
  final String message;

  const SyncStatus({
    required this.state,
    required this.message,
  });
}

class SyncResult {
  final bool success;
  final String? error;
  final Map<AccountProviderType, AccountSyncResult>? accountResults;

  const SyncResult({
    required this.success,
    this.error,
    this.accountResults,
  });
}

class AccountSyncResult {
  final bool success;
  final String? error;
  final int transactionCount;
  final int ingestedCount;
  final int skippedCount;
  final List<ProviderTransaction>? transactions;
  final int? balance;

  const AccountSyncResult({
    required this.success,
    this.error,
    this.transactionCount = 0,
    this.ingestedCount = 0,
    this.skippedCount = 0,
    this.transactions,
    this.balance,
  });
}

class IngestionSummary {
  final int inserted;
  final int skipped;

  const IngestionSummary({required this.inserted, required this.skipped});
}

class AccountMatchResult {
  final String accountId;
  final double confidence;

  const AccountMatchResult({
    required this.accountId,
    required this.confidence,
  });
}

class BatchSyncResult {
  final bool success;
  final String? error;
  final int transactionsFetched;
  final List<ProviderTransaction>? transactions;

  const BatchSyncResult({
    required this.success,
    this.error,
    required this.transactionsFetched,
    this.transactions,
  });
}

enum UpiApp { gpay, phonepe, paytm }

class UpiNotification {
  final UpiApp app;
  final String title;
  final String text;
  final DateTime timestamp;

  const UpiNotification({
    required this.app,
    required this.title,
    required this.text,
    required this.timestamp,
  });
}

class UpiNotificationResult {
  final bool success;
  final ParsedTransaction? transaction;
  final String? error;

  const UpiNotificationResult({
    required this.success,
    this.transaction,
    this.error,
  });
}

class SyncStatusInfo {
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final Map<AccountProviderType, ProviderSyncStatus> providerStatuses;

  const SyncStatusInfo({
    required this.isSyncing,
    this.lastSyncTime,
    required this.providerStatuses,
  });
}

class ProviderSyncStatus {
  final DateTime? lastSyncTime;
  final bool isHealthy;
  final int failureCount;

  const ProviderSyncStatus({
    this.lastSyncTime,
    required this.isHealthy,
    required this.failureCount,
  });
}
