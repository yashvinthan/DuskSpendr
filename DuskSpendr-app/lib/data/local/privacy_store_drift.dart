import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/privacy/privacy_engine.dart';
import '../../core/privacy/privacy_store.dart';
import 'daos/audit_log_dao.dart';
import 'daos/privacy_report_dao.dart';
import 'database.dart';
import 'tables.dart';

class DriftPrivacyStore implements PrivacyStore {
  DriftPrivacyStore({required AuditLogDao auditLogDao, required PrivacyReportDao privacyReportDao})
      : _auditLogDao = auditLogDao,
        _privacyReportDao = privacyReportDao;

  final AuditLogDao _auditLogDao;
  final PrivacyReportDao _privacyReportDao;
  final Uuid _uuid = const Uuid();

  @override
  Future<void> appendAuditEntry(AuditEntry entry) async {
    await _auditLogDao.insertLog(
      AuditLogsCompanion.insert(
        id: _uuid.v4(),
        type: _mapType(entry.type),
        entity: entry.entity,
        entityId: Value(entry.entityId),
        details: Value(entry.details),
        metadata: Value(jsonEncode(entry.toJson())),
        createdAt: entry.timestamp,
      ),
    );
  }

  @override
  Future<List<AuditEntry>> getAuditEntries({
    DateTime? from,
    DateTime? to,
    DataAccessType? type,
  }) async {
    final logs = await _auditLogDao.listLogs(
      from: from,
      to: to,
      type: type != null ? _mapType(type) : null,
    );
    return logs.map(_mapAuditLog).toList();
  }

  @override
  Future<void> clearAudit() async {
    await _auditLogDao.clearAll();
  }

  @override
  Future<void> clearAll() async {
    await _auditLogDao.clearAll();
    await _privacyReportDao.clearAll();
  }

  @override
  Future<void> savePrivacyReport(PrivacyReport report) async {
    await _privacyReportDao.insertReport(
      PrivacyReportsCompanion.insert(
        id: _uuid.v4(),
        generatedAt: report.generatedAt,
        reportJson: jsonEncode(_reportToJson(report)),
      ),
    );
  }

  @override
  Future<PrivacyReport?> getLatestPrivacyReport() async {
    final latest = await _privacyReportDao.getLatest();
    if (latest == null) return null;
    return _reportFromJson(jsonDecode(latest.reportJson) as Map<String, dynamic>);
  }

  AuditEntry _mapAuditLog(AuditLogRow log) {
    if (log.metadata != null && log.metadata!.isNotEmpty) {
      final json = jsonDecode(log.metadata!);
      if (json is Map<String, dynamic>) {
        return AuditEntry.fromJson(json);
      }
    }

    return AuditEntry(
      timestamp: log.createdAt,
      type: _mapTypeDb(log.type),
      entity: log.entity,
      entityId: log.entityId,
      details: log.details,
    );
  }

  AuditLogTypeDb _mapType(DataAccessType type) {
    switch (type) {
      case DataAccessType.read:
        return AuditLogTypeDb.read;
      case DataAccessType.write:
        return AuditLogTypeDb.write;
      case DataAccessType.update:
        return AuditLogTypeDb.update;
      case DataAccessType.delete:
        return AuditLogTypeDb.delete;
      case DataAccessType.export:
        return AuditLogTypeDb.export;
      case DataAccessType.sync:
        return AuditLogTypeDb.sync;
    }
  }

  DataAccessType _mapTypeDb(AuditLogTypeDb type) {
    switch (type) {
      case AuditLogTypeDb.read:
        return DataAccessType.read;
      case AuditLogTypeDb.write:
        return DataAccessType.write;
      case AuditLogTypeDb.update:
        return DataAccessType.update;
      case AuditLogTypeDb.delete:
        return DataAccessType.delete;
      case AuditLogTypeDb.export:
        return DataAccessType.export;
      case AuditLogTypeDb.sync:
        return DataAccessType.sync;
      case AuditLogTypeDb.backup:
        return DataAccessType.export;
      case AuditLogTypeDb.restore:
        return DataAccessType.write;
    }
  }

  Map<String, dynamic> _reportToJson(PrivacyReport report) => {
        'generatedAt': report.generatedAt.toIso8601String(),
        'dataStats': {
          'transactionCount': report.dataStats.transactionCount,
          'linkedAccountCount': report.dataStats.linkedAccountCount,
          'budgetCount': report.dataStats.budgetCount,
        },
        'recentAccessCount': report.recentAccessCount,
        'dataStorageInfo': {
          'encryptionEnabled': report.dataStorageInfo.encryptionEnabled,
          'encryptionAlgorithm': report.dataStorageInfo.encryptionAlgorithm,
          'localStorageOnly': report.dataStorageInfo.localStorageOnly,
          'smsProcessedOnDevice': report.dataStorageInfo.smsProcessedOnDevice,
        },
        'privacyFeatures': report.privacyFeatures,
      };

  PrivacyReport _reportFromJson(Map<String, dynamic> json) => PrivacyReport(
        generatedAt: DateTime.parse(json['generatedAt'] as String),
        dataStats: DataStats(
          transactionCount: json['dataStats']['transactionCount'] as int,
          linkedAccountCount: json['dataStats']['linkedAccountCount'] as int,
          budgetCount: json['dataStats']['budgetCount'] as int,
        ),
        recentAccessCount: json['recentAccessCount'] as int,
        dataStorageInfo: DataStorageInfo(
          encryptionEnabled: json['dataStorageInfo']['encryptionEnabled'] as bool,
          encryptionAlgorithm:
              json['dataStorageInfo']['encryptionAlgorithm'] as String,
          localStorageOnly: json['dataStorageInfo']['localStorageOnly'] as bool,
          smsProcessedOnDevice: json['dataStorageInfo']['smsProcessedOnDevice'] as bool,
        ),
        privacyFeatures: (json['privacyFeatures'] as List).cast<String>(),
      );
}
