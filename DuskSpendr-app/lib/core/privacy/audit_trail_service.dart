import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../data/local/database.dart';
import '../../data/local/tables.dart';

/// Database-backed audit trail service for privacy compliance
/// Provides persistent, queryable audit log storage
class AuditTrailService {
  final AppDatabase _database;
  static const _maxEntriesPerQuery = 1000;
  static const _retentionDays = 90; // Keep logs for 90 days

  AuditTrailService(this._database);

  // ====== Logging Operations ======

  /// Log a data access event
  Future<void> logAccess({
    required AuditLogType type,
    required String entity,
    String? entityId,
    String? details,
    Map<String, dynamic>? metadata,
  }) async {
    await _database.auditLogDao.insertLog(
      AuditLogsCompanion(
        id: Value(const Uuid().v4()),
        type: Value(_typeToDb(type)),
        entity: Value(entity),
        entityId: Value(entityId),
        details: Value(details),
        metadata: metadata != null ? Value(_encodeMetadata(metadata)) : const Value.absent(),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  /// Log transaction read
  Future<void> logTransactionRead(String transactionId) async {
    await logAccess(
      type: AuditLogType.read,
      entity: 'transaction',
      entityId: transactionId,
    );
  }

  /// Log transaction write
  Future<void> logTransactionWrite(String transactionId, {bool isNew = true}) async {
    await logAccess(
      type: isNew ? AuditLogType.write : AuditLogType.update,
      entity: 'transaction',
      entityId: transactionId,
    );
  }

  /// Log sync operation
  Future<void> logSync({
    required String accountId,
    required int transactionCount,
    required bool success,
    String? error,
  }) async {
    await logAccess(
      type: AuditLogType.sync,
      entity: 'account_sync',
      entityId: accountId,
      details: success ? 'Synced $transactionCount transactions' : 'Sync failed: $error',
      metadata: {
        'transactionCount': transactionCount,
        'success': success,
        if (error != null) 'error': error,
      },
    );
  }

  /// Log data export
  Future<void> logExport({
    required String format,
    required int recordCount,
    required String destination,
  }) async {
    await logAccess(
      type: AuditLogType.export,
      entity: 'data_export',
      details: 'Exported $recordCount records as $format',
      metadata: {
        'format': format,
        'recordCount': recordCount,
        'destination': destination,
      },
    );
  }

  /// Log backup operation
  Future<void> logBackup({
    required String backupId,
    required bool success,
    int? sizeBytes,
    String? error,
  }) async {
    await logAccess(
      type: AuditLogType.backup,
      entity: 'backup',
      entityId: backupId,
      details: success ? 'Backup created (${_formatBytes(sizeBytes ?? 0)})' : 'Backup failed: $error',
      metadata: {
        'success': success,
        if (sizeBytes != null) 'sizeBytes': sizeBytes,
        if (error != null) 'error': error,
      },
    );
  }

  /// Log restore operation
  Future<void> logRestore({
    required String backupId,
    required bool success,
    String? error,
  }) async {
    await logAccess(
      type: AuditLogType.restore,
      entity: 'restore',
      entityId: backupId,
      details: success ? 'Backup restored' : 'Restore failed: $error',
      metadata: {
        'success': success,
        if (error != null) 'error': error,
      },
    );
  }

  // ====== Query Operations ======

  /// Get audit logs with filters
  Future<List<AuditLogEntry>> getLogs({
    DateTime? from,
    DateTime? to,
    AuditLogType? type,
    String? entity,
    int limit = 100,
  }) async {
    final logs = await _database.auditLogDao.listLogs(
      from: from,
      to: to,
      type: type != null ? _typeToDb(type) : null,
      limit: limit.clamp(1, _maxEntriesPerQuery),
    );

    return logs.map(_dbToEntry).toList();
  }

  /// Get recent activity summary
  Future<AuditSummary> getRecentSummary({int days = 7}) async {
    final from = DateTime.now().subtract(Duration(days: days));
    final logs = await getLogs(from: from, limit: _maxEntriesPerQuery);

    final readCount = logs.where((l) => l.type == AuditLogType.read).length;
    final writeCount = logs.where((l) => l.type == AuditLogType.write).length;
    final updateCount = logs.where((l) => l.type == AuditLogType.update).length;
    final deleteCount = logs.where((l) => l.type == AuditLogType.delete).length;
    final syncCount = logs.where((l) => l.type == AuditLogType.sync).length;
    final exportCount = logs.where((l) => l.type == AuditLogType.export).length;
    final backupCount = logs.where((l) => l.type == AuditLogType.backup).length;

    return AuditSummary(
      periodStart: from,
      periodEnd: DateTime.now(),
      totalEvents: logs.length,
      readEvents: readCount,
      writeEvents: writeCount,
      updateEvents: updateCount,
      deleteEvents: deleteCount,
      syncEvents: syncCount,
      exportEvents: exportCount,
      backupEvents: backupCount,
    );
  }

  /// Check if there are recent access events (for privacy indicator)
  Future<bool> hasRecentActivity({Duration window = const Duration(hours: 1)}) async {
    final from = DateTime.now().subtract(window);
    final logs = await getLogs(from: from, limit: 1);
    return logs.isNotEmpty;
  }

  // ====== Maintenance ======

  /// Clean up old logs beyond retention period
  Future<int> cleanupOldLogs() async {
    final cutoff = DateTime.now().subtract(Duration(days: _retentionDays));
    // Note: Would need to add a delete method to the DAO
    final logs = await getLogs(to: cutoff, limit: _maxEntriesPerQuery);
    // In production, delete logs older than cutoff
    return logs.length;
  }

  /// Clear all audit logs
  Future<void> clearAll() async {
    await _database.auditLogDao.clearAll();
  }

  // ====== Helpers ======

  AuditLogTypeDb _typeToDb(AuditLogType type) {
    return switch (type) {
      AuditLogType.read => AuditLogTypeDb.read,
      AuditLogType.write => AuditLogTypeDb.write,
      AuditLogType.update => AuditLogTypeDb.update,
      AuditLogType.delete => AuditLogTypeDb.delete,
      AuditLogType.export => AuditLogTypeDb.export,
      AuditLogType.sync => AuditLogTypeDb.sync,
      AuditLogType.backup => AuditLogTypeDb.backup,
      AuditLogType.restore => AuditLogTypeDb.restore,
    };
  }

  AuditLogEntry _dbToEntry(AuditLog log) {
    return AuditLogEntry(
      id: log.id,
      type: _dbToType(log.type),
      entity: log.entity,
      entityId: log.entityId,
      details: log.details,
      metadata: log.metadata != null ? _decodeMetadata(log.metadata!) : null,
      createdAt: log.createdAt,
    );
  }

  AuditLogType _dbToType(AuditLogTypeDb db) {
    return switch (db) {
      AuditLogTypeDb.read => AuditLogType.read,
      AuditLogTypeDb.write => AuditLogType.write,
      AuditLogTypeDb.update => AuditLogType.update,
      AuditLogTypeDb.delete => AuditLogType.delete,
      AuditLogTypeDb.export => AuditLogType.export,
      AuditLogTypeDb.sync => AuditLogType.sync,
      AuditLogTypeDb.backup => AuditLogType.backup,
      AuditLogTypeDb.restore => AuditLogType.restore,
    };
  }

  String _encodeMetadata(Map<String, dynamic> metadata) {
    return Uri.encodeFull(metadata.toString());
  }

  Map<String, dynamic>? _decodeMetadata(String encoded) {
    try {
      return Uri.decodeComponent(encoded) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// ====== Domain Models ======

enum AuditLogType {
  read,
  write,
  update,
  delete,
  export,
  sync,
  backup,
  restore,
}

class AuditLogEntry {
  final String id;
  final AuditLogType type;
  final String entity;
  final String? entityId;
  final String? details;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const AuditLogEntry({
    required this.id,
    required this.type,
    required this.entity,
    this.entityId,
    this.details,
    this.metadata,
    required this.createdAt,
  });
}

class AuditSummary {
  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalEvents;
  final int readEvents;
  final int writeEvents;
  final int updateEvents;
  final int deleteEvents;
  final int syncEvents;
  final int exportEvents;
  final int backupEvents;

  const AuditSummary({
    required this.periodStart,
    required this.periodEnd,
    required this.totalEvents,
    required this.readEvents,
    required this.writeEvents,
    required this.updateEvents,
    required this.deleteEvents,
    required this.syncEvents,
    required this.exportEvents,
    required this.backupEvents,
  });

  double get readPercentage => totalEvents > 0 ? readEvents / totalEvents : 0;
  double get writePercentage => totalEvents > 0 ? (writeEvents + updateEvents) / totalEvents : 0;
}
