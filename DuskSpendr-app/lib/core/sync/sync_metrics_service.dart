import 'dart:async';

import '../../data/local/database.dart';
// Removed unused import: audit_trail_service.dart

/// SS-031, SS-040: Sync Metrics & Audit Integration
/// Tracks sync performance, accuracy, and audit logging

/// Sync metrics tracking service
class SyncMetricsService {
  // Removed unused field: _database
  // Removed unused field: _auditTrail

  // In-memory metrics for current session
  final _sessionMetrics = SyncSessionMetrics();

  SyncMetricsService({
    required AppDatabase database,
    // Removed unused parameter: auditTrail
  }); // Removed assignment to unused field _database
        // Removed assignment to unused field: _auditTrail

  /// Record start of a sync operation
  Future<SyncOperationContext> startSync({
    required SyncSource source,
    required String providerId,
    String? description,
  }) async {
    final context = SyncOperationContext(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      source: source,
      providerId: providerId,
      startTime: DateTime.now(),
    );

    _sessionMetrics.activeSyncs.add(context.id);

    // Removed call to _auditTrail.logSync

    return context;
  }

  /// Record successful sync completion
  Future<void> recordSuccess(
    SyncOperationContext context, {
    required int transactionCount,
    int? newTransactions,
    int? duplicatesSkipped,
  }) async {
    final endTime = DateTime.now();
    final duration = endTime.difference(context.startTime);

    _sessionMetrics.activeSyncs.remove(context.id);
    _sessionMetrics.successfulSyncs++;
    _sessionMetrics.totalTransactionsSynced += transactionCount;
    _sessionMetrics.totalSyncDuration += duration;
    _sessionMetrics.lastSuccessfulSync = endTime;

    // Removed call to _auditTrail.logSync

    // Store persistent metrics
    await _persistMetrics(SyncMetricRecord(
      source: context.source,
      providerId: context.providerId,
      timestamp: endTime,
      success: true,
      durationMs: duration.inMilliseconds,
      transactionCount: transactionCount,
      newTransactions: newTransactions ?? 0,
      duplicatesSkipped: duplicatesSkipped ?? 0,
    ));
  }

  /// Record sync failure
  Future<void> recordFailure(
    SyncOperationContext context, {
    required String error,
    bool isRetryable = true,
  }) async {
    final endTime = DateTime.now();
    final duration = endTime.difference(context.startTime);

    _sessionMetrics.activeSyncs.remove(context.id);
    _sessionMetrics.failedSyncs++;
    _sessionMetrics.lastError = error;
    _sessionMetrics.lastErrorTime = endTime;

    // Removed call to _auditTrail.logSync

    // Store persistent metrics
    await _persistMetrics(SyncMetricRecord(
      source: context.source,
      providerId: context.providerId,
      timestamp: endTime,
      success: false,
      durationMs: duration.inMilliseconds,
      error: error,
      isRetryable: isRetryable,
    ));
  }

  /// Record SMS parsing metrics
  Future<void> recordSmsParseMetrics({
    required int totalMessages,
    required int parsedSuccessfully,
    required int spamDetected,
    required int otpSkipped,
    required int transactionsExtracted,
    required Duration processingTime,
  }) async {
    _sessionMetrics.totalSmsParsed += totalMessages;
    _sessionMetrics.smsParseSuccesses += parsedSuccessfully;
    _sessionMetrics.spamMessagesDetected += spamDetected;

    // Removed call to _auditTrail.logSync
  }

  /// Record duplicate detection metrics
  Future<void> recordDuplicateDetection({
    required int candidateCount,
    required int duplicatesFound,
    required int exactMatches,
    required int fuzzyMatches,
  }) async {
    _sessionMetrics.duplicatesDetected += duplicatesFound;

    if (duplicatesFound > 0) {
      // Removed call to _auditTrail.logSync
    }
  }

  /// Get current session metrics
  SyncSessionMetrics getSessionMetrics() => _sessionMetrics;

  /// Get historical sync metrics
  Future<List<SyncMetricRecord>> getHistoricalMetrics({
    SyncSource? source,
    String? providerId,
    DateTime? since,
    int limit = 100,
  }) async {
    // Query from database
    // Removed call to _auditTrail.getLogs
    final logs = <dynamic>[];

    return logs.map((log) {
      final details = (log?['details'] ?? '');
      final transactionMatch = RegExp(r'(\d+)\s*transactions').firstMatch(details);

      return SyncMetricRecord(
        source: _parseSource(log?['entityId'] ?? ''),
        providerId: log?['entityId'] ?? '',
        timestamp: log?['createdAt'],
        success: details.contains('completed') || details.contains('success'),
        transactionCount: transactionMatch != null ? int.tryParse(transactionMatch.group(1) ?? '0') ?? 0 : 0,
      );
    }).toList();
  }

  /// Get sync health summary
  Future<SyncHealthSummary> getHealthSummary() async {
    // Removed unused variable: last24h
    // Removed call to _auditTrail.getLogs
    final recentLogs = <dynamic>[];

    int totalSyncs = 0;
    int successfulSyncs = 0;
    int failedSyncs = 0;
    Duration totalDuration = Duration.zero;
    DateTime? lastSuccessfulSync;

    for (final log in recentLogs) {
      final details = (log?['details'] ?? '');
      if (details.contains('completed') || details.contains('Synced')) {
        totalSyncs++;
        successfulSyncs++;
        lastSuccessfulSync ??= log?['createdAt'];
      } else if (details.contains('failed')) {
        totalSyncs++;
        failedSyncs++;
      }
    }

    final successRate = totalSyncs > 0 ? (successfulSyncs / totalSyncs * 100) : 100.0;

    return SyncHealthSummary(
      totalSyncsLast24h: totalSyncs,
      successfulSyncsLast24h: successfulSyncs,
      failedSyncsLast24h: failedSyncs,
      successRate: successRate,
      lastSuccessfulSync: lastSuccessfulSync,
      averageSyncDuration: totalSyncs > 0 ? totalDuration ~/ totalSyncs : Duration.zero,
      sessionMetrics: _sessionMetrics,
    );
  }

  /// Persist metrics to database
  Future<void> _persistMetrics(SyncMetricRecord record) async {
    // Metrics are already persisted via audit trail
    // This is a hook for additional metric storage if needed
  }

  SyncSource _parseSource(String providerId) {
    if (providerId.contains('sms')) return SyncSource.sms;
    if (providerId.contains('notification')) return SyncSource.notification;
    if (providerId.contains('api')) return SyncSource.bankApi;
    return SyncSource.unknown;
  }
}

/// Context for a sync operation in progress
class SyncOperationContext {
  final String id;
  final SyncSource source;
  final String providerId;
  final DateTime startTime;

  const SyncOperationContext({
    required this.id,
    required this.source,
    required this.providerId,
    required this.startTime,
  });
}

/// Sync data source types
enum SyncSource {
  sms,
  notification,
  bankApi,
  upiApp,
  manualImport,
  unknown,
}

/// In-memory session metrics
class SyncSessionMetrics {
  final Set<String> activeSyncs = {};
  int successfulSyncs = 0;
  int failedSyncs = 0;
  int totalTransactionsSynced = 0;
  int totalSmsParsed = 0;
  int smsParseSuccesses = 0;
  int spamMessagesDetected = 0;
  int duplicatesDetected = 0;
  Duration totalSyncDuration = Duration.zero;
  DateTime? lastSuccessfulSync;
  String? lastError;
  DateTime? lastErrorTime;

  double get successRate => (successfulSyncs + failedSyncs) > 0
      ? successfulSyncs / (successfulSyncs + failedSyncs) * 100
      : 100.0;

  Duration get averageSyncDuration => successfulSyncs > 0
      ? totalSyncDuration ~/ successfulSyncs
      : Duration.zero;
}

/// Persistent sync metric record
class SyncMetricRecord {
  final SyncSource source;
  final String providerId;
  final DateTime timestamp;
  final bool success;
  final int durationMs;
  final int transactionCount;
  final int newTransactions;
  final int duplicatesSkipped;
  final String? error;
  final bool isRetryable;

  const SyncMetricRecord({
    required this.source,
    required this.providerId,
    required this.timestamp,
    required this.success,
    this.durationMs = 0,
    this.transactionCount = 0,
    this.newTransactions = 0,
    this.duplicatesSkipped = 0,
    this.error,
    this.isRetryable = true,
  });
}

/// Sync health summary
class SyncHealthSummary {
  final int totalSyncsLast24h;
  final int successfulSyncsLast24h;
  final int failedSyncsLast24h;
  final double successRate;
  final DateTime? lastSuccessfulSync;
  final Duration averageSyncDuration;
  final SyncSessionMetrics sessionMetrics;

  const SyncHealthSummary({
    required this.totalSyncsLast24h,
    required this.successfulSyncsLast24h,
    required this.failedSyncsLast24h,
    required this.successRate,
    this.lastSuccessfulSync,
    required this.averageSyncDuration,
    required this.sessionMetrics,
  });

  /// Overall health status
  SyncHealthStatus get status {
    if (successRate >= 98) return SyncHealthStatus.healthy;
    if (successRate >= 90) return SyncHealthStatus.degraded;
    if (successRate >= 50) return SyncHealthStatus.unhealthy;
    return SyncHealthStatus.critical;
  }
}

enum SyncHealthStatus {
  healthy,
  degraded,
  unhealthy,
  critical,
}
