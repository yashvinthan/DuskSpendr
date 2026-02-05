import 'package:flutter_riverpod/flutter_riverpod.dart';

// Removed unused import: privacy_engine.dart
import '../core/sms/financial_institution_database.dart';
import '../core/sms/notification_listener_service.dart';
import '../core/sms/sms_parser.dart';
import '../core/sms/sms_permission_service.dart';
import '../core/sync/data_synchronizer.dart';
import '../core/sync/sync_metrics_service.dart';
import '../core/sync/sync_upload_service.dart';
import '../core/sync/sync_outbox_stats.dart';
import '../data/remote/sync_api.dart';
import 'core_providers.dart';
import 'database_provider.dart';
import 'feature_providers.dart' as feature;
import 'auth_providers.dart';

// ====== SMS Permission Providers ======

/// SMS Permission Service provider
final smsPermissionProvider = Provider<SmsPermissionService>((ref) {
  return SmsPermissionService();
});

/// SMS permission status provider
final smsPermissionStatusProvider = FutureProvider<SmsPermissionStatus>((ref) async {
  final service = ref.watch(smsPermissionProvider);
  return service.checkPermission();
});

/// SMS Inbox Reader provider
final smsInboxReaderProvider = Provider<SmsInboxReader>((ref) {
  final permissionService = ref.watch(smsPermissionProvider);
  return SmsInboxReader(permissionService: permissionService);
});

// ====== Notification Listener Providers ======

/// Notification Permission Service provider
final notificationPermissionProvider = Provider<NotificationPermissionService>((ref) {
  return NotificationPermissionService();
});

/// Notification permission status provider
final notificationPermissionStatusProvider = FutureProvider<NotificationPermissionStatus>((ref) async {
  final service = ref.watch(notificationPermissionProvider);
  return service.checkPermission();
});

/// UPI Notification Listener provider
final upiNotificationListenerProvider = Provider<UpiNotificationListener>((ref) {
  final permissionService = ref.watch(notificationPermissionProvider);
  final privacyEngine = ref.watch(privacyEngineProvider);
  return UpiNotificationListener(
    permissionService: permissionService,
    privacyEngine: privacyEngine,
  );
});

/// UPI notification stream
final upiNotificationStreamProvider = StreamProvider<UpiPaymentNotification>((ref) {
  final listener = ref.watch(upiNotificationListenerProvider);
  return listener.notifications;
});

// ====== SMS Parser Providers ======

/// Financial Institution Verifier provider
final institutionVerifierProvider = Provider<FinancialInstitutionVerifier>((ref) {
  return FinancialInstitutionVerifier();
});

/// Spam Detector provider
final spamDetectorProvider = Provider<SpamDetector>((ref) {
  return SpamDetector();
});

/// Transaction Extractor provider
final transactionExtractorProvider = Provider<TransactionExtractor>((ref) {
  return TransactionExtractor();
});

/// Balance Extractor provider
final balanceExtractorProvider = Provider<BalanceExtractor>((ref) {
  return BalanceExtractor();
});

/// Duplicate Detector provider
final duplicateDetectorProvider = Provider<DuplicateDetector>((ref) {
  return DuplicateDetector();
});

/// Recurring Detector provider
final recurringDetectorProvider = Provider<RecurringDetector>((ref) {
  return RecurringDetector();
});

/// SMS Parser provider with all components
final smsParserProvider = Provider<SmsParser>((ref) {
  return SmsParser(
    institutionVerifier: ref.watch(institutionVerifierProvider),
    spamDetector: ref.watch(spamDetectorProvider),
    transactionExtractor: ref.watch(transactionExtractorProvider),
    balanceExtractor: ref.watch(balanceExtractorProvider),
    duplicateDetector: ref.watch(duplicateDetectorProvider),
    recurringDetector: ref.watch(recurringDetectorProvider),
  );
});

// ====== Sync Providers ======

/// Sync API provider
final syncApiProvider = Provider<SyncApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return SyncApi(client);
});

/// Sync Upload Service provider
final syncUploadServiceProvider = Provider<SyncUploadService>((ref) {
  return SyncUploadService(
    outboxDao: ref.watch(syncOutboxDaoProvider),
    transactionDao: ref.watch(transactionDaoProvider),
    syncApi: ref.watch(syncApiProvider),
    sessionStore: ref.watch(sessionStoreProvider),
  );
});

/// Sync Metrics Service provider
final syncMetricsProvider = Provider<SyncMetricsService>((ref) {
  final database = ref.watch(databaseProvider);
  return SyncMetricsService(
    database: database,
    // Removed undefined parameter: auditTrail
  );
});

/// Sync Health Summary provider
final syncHealthProvider = FutureProvider<SyncHealthSummary>((ref) async {
  final metricsService = ref.watch(syncMetricsProvider);
  return metricsService.getHealthSummary();
});

/// Data Synchronizer provider (full version with all dependencies)
final fullDataSynchronizerProvider = Provider<DataSynchronizer>((ref) {
  final privacyEngine = ref.watch(privacyEngineProvider);
  final smsParser = ref.watch(smsParserProvider);
  final linkingManager = ref.watch(feature.accountLinkingManagerProvider);
  final transactionDao = ref.watch(transactionDaoProvider);
  final accountDao = ref.watch(accountDaoProvider);
  final categorizer = ref.watch(feature.transactionCategorizerProvider);
  final syncUpload = ref.watch(syncUploadServiceProvider);
  return DataSynchronizer(
    linkingManager: linkingManager,
    smsParser: smsParser,
    privacyEngine: privacyEngine,
    transactionDao: transactionDao,
    accountDao: accountDao,
    categorizer: categorizer,
    syncUpload: syncUpload,
  );
});

/// Sync outbox stats provider
final syncOutboxStatsProvider = FutureProvider<SyncOutboxStats>((ref) async {
  final dao = ref.watch(syncOutboxDaoProvider);
  return dao.getStats();
});

/// Sync Status Stream provider
final fullSyncStatusStreamProvider = StreamProvider<SyncStatus>((ref) {
  final synchronizer = ref.watch(fullDataSynchronizerProvider);
  return synchronizer.syncStatusStream;
});

// ====== Sync Orchestration Providers ======

/// Combined sync state notifier
final syncOrchestratorProvider = StateNotifierProvider<SyncOrchestrator, SyncOrchestratorState>((ref) {
  return SyncOrchestrator(
    synchronizer: ref.watch(fullDataSynchronizerProvider),
    smsReader: ref.watch(smsInboxReaderProvider),
    smsParser: ref.watch(smsParserProvider),
    notificationListener: ref.watch(upiNotificationListenerProvider),
    metricsService: ref.watch(syncMetricsProvider),
    uploadService: ref.watch(syncUploadServiceProvider),
  );
});

/// Sync Orchestrator State
class SyncOrchestratorState {
  final bool isSyncing;
  final bool isListeningNotifications;
  final DateTime? lastSmsSync;
  final DateTime? lastApiSync;
  final int transactionsPendingReview;
  final String? lastError;

  const SyncOrchestratorState({
    this.isSyncing = false,
    this.isListeningNotifications = false,
    this.lastSmsSync,
    this.lastApiSync,
    this.transactionsPendingReview = 0,
    this.lastError,
  });

  SyncOrchestratorState copyWith({
    bool? isSyncing,
    bool? isListeningNotifications,
    DateTime? lastSmsSync,
    DateTime? lastApiSync,
    int? transactionsPendingReview,
    String? lastError,
  }) {
    return SyncOrchestratorState(
      isSyncing: isSyncing ?? this.isSyncing,
      isListeningNotifications: isListeningNotifications ?? this.isListeningNotifications,
      lastSmsSync: lastSmsSync ?? this.lastSmsSync,
      lastApiSync: lastApiSync ?? this.lastApiSync,
      transactionsPendingReview: transactionsPendingReview ?? this.transactionsPendingReview,
      lastError: lastError,
    );
  }
}

/// Sync Orchestrator - coordinates all sync sources
class SyncOrchestrator extends StateNotifier<SyncOrchestratorState> {
  final DataSynchronizer _synchronizer;
  final SmsInboxReader _smsReader;
  final SmsParser _smsParser;
  final UpiNotificationListener _notificationListener;
  final SyncMetricsService _metricsService;
  final SyncUploadService _uploadService;

  SyncOrchestrator({
    required DataSynchronizer synchronizer,
    required SmsInboxReader smsReader,
    required SmsParser smsParser,
    required UpiNotificationListener notificationListener,
    required SyncMetricsService metricsService,
    required SyncUploadService uploadService,
  })  : _synchronizer = synchronizer,
        _smsReader = smsReader,
        _smsParser = smsParser,
        _notificationListener = notificationListener,
        _metricsService = metricsService,
        _uploadService = uploadService,
        super(const SyncOrchestratorState());

  /// Start all sync sources
  Future<void> startSync() async {
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true);

    try {
      // Start background sync
      _synchronizer.startBackgroundSync();

      // Start notification listener
      final notifStarted = await _notificationListener.startListening();
      state = state.copyWith(isListeningNotifications: notifStarted);

      // Sync from SMS
      await _syncFromSms();

      await _uploadService.processQueue();

      state = state.copyWith(isSyncing: false);
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        lastError: e.toString(),
      );
    }
  }

  /// Sync from SMS inbox
  Future<void> _syncFromSms() async {
    final context = await _metricsService.startSync(
      source: SyncSource.sms,
      providerId: 'sms_inbox',
      description: 'Reading financial SMS',
    );

    try {
      final smsResult = await _smsReader.readFinancialMessages(
        since: state.lastSmsSync,
      );

      if (!smsResult.success) {
        await _metricsService.recordFailure(
          context,
          error: smsResult.error ?? 'Unknown error',
          isRetryable: smsResult.permissionRequired,
        );
        return;
      }

      int parsedCount = 0;
      int transactionsFound = 0;
      int newTransactions = 0;
      int spamCount = 0;
      int otpCount = 0;

      final stopwatch = Stopwatch()..start();

      for (final sms in smsResult.messages) {
        // Check for OTP first
        if (OtpMessageFilter.isOtp(sms.body)) {
          otpCount++;
          continue;
        }

        // Check for non-transactional
        if (OtpMessageFilter.isNonTransactional(sms.body)) {
          continue;
        }

        // Parse the SMS
        final result = await _smsParser.parseSms(sms.toRawSms());
        parsedCount++;

        if (result.status == SmsParseStatus.success && result.transaction != null) {
          transactionsFound++;
          final ingestion = await _synchronizer.ingestParsedTransaction(
            result.transaction!,
          );
          newTransactions += ingestion.inserted;
        } else if (result.status == SmsParseStatus.spam) {
          spamCount++;
        }
      }

      stopwatch.stop();

      await _metricsService.recordSmsParseMetrics(
        totalMessages: smsResult.messages.length,
        parsedSuccessfully: parsedCount,
        spamDetected: spamCount,
        otpSkipped: otpCount,
        transactionsExtracted: transactionsFound,
        processingTime: stopwatch.elapsed,
      );

      await _metricsService.recordSuccess(
        context,
        transactionCount: transactionsFound,
        newTransactions: newTransactions,
      );

      state = state.copyWith(lastSmsSync: DateTime.now());
    } catch (e) {
      await _metricsService.recordFailure(context, error: e.toString());
    }
  }

  /// Manual sync trigger
  Future<void> syncNow() async {
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true);

    try {
      final result = await _synchronizer.syncAll();
      if (!result.success) {
        state = state.copyWith(lastError: result.error);
      }
      await _uploadService.processQueue();
      state = state.copyWith(lastApiSync: DateTime.now());
    } finally {
      state = state.copyWith(isSyncing: false);
    }
  }

  /// Stop all sync
  void stopSync() {
    _synchronizer.stopBackgroundSync();
    _notificationListener.stopListening();
    state = state.copyWith(
      isSyncing: false,
      isListeningNotifications: false,
    );
  }

  @override
  void dispose() {
    stopSync();
    super.dispose();
  }
}
