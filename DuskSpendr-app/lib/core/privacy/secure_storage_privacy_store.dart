import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'privacy_engine.dart';
import 'privacy_store.dart';

class SecureStoragePrivacyStore implements PrivacyStore {
  static const _storage = FlutterSecureStorage();
  static const _auditLogKey = 'audit_log';
  static const _reportKey = 'privacy_report_latest';
  static const _maxAuditEntries = 1000;

  @override
  Future<void> appendAuditEntry(AuditEntry entry) async {
    final entriesJson = await _storage.read(key: _auditLogKey);
    List<Map<String, dynamic>> entries = [];

    if (entriesJson != null) {
      try {
        final decoded = jsonDecode(entriesJson);
        if (decoded is List) {
          entries = List<Map<String, dynamic>>.from(decoded);
        }
      } catch (e) {
        // Fallback to empty list on corruption
        entries = [];
      }
    }

    entries.add(entry.toJson());

    if (entries.length > _maxAuditEntries) {
      entries = entries.sublist(entries.length - _maxAuditEntries);
    }

    await _storage.write(key: _auditLogKey, value: jsonEncode(entries));
  }

  @override
  Future<List<AuditEntry>> getAuditEntries({
    DateTime? from,
    DateTime? to,
    DataAccessType? type,
  }) async {
    final entriesJson = await _storage.read(key: _auditLogKey);
    if (entriesJson == null) return [];

    List<AuditEntry> entries;
    try {
      final decoded = jsonDecode(entriesJson);
      if (decoded is! List) return [];

      entries = List<Map<String, dynamic>>.from(decoded)
          .map((e) => AuditEntry.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }

    return entries.where((entry) {
      if (from != null && entry.timestamp.isBefore(from)) return false;
      if (to != null && entry.timestamp.isAfter(to)) return false;
      if (type != null && entry.type != type) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> clearAudit() async {
    await _storage.delete(key: _auditLogKey);
  }

  @override
  Future<void> clearAll() async {
    await _storage.delete(key: _auditLogKey);
    await _storage.delete(key: _reportKey);
  }

  @override
  Future<void> savePrivacyReport(PrivacyReport report) async {
    await _storage.write(
      key: _reportKey,
      value: jsonEncode(_reportToJson(report)),
    );
  }

  @override
  Future<PrivacyReport?> getLatestPrivacyReport() async {
    final reportJson = await _storage.read(key: _reportKey);
    if (reportJson == null) return null;
    try {
      final decoded = jsonDecode(reportJson);
      if (decoded is Map<String, dynamic>) {
        return _reportFromJson(decoded);
      }
      return null;
    } catch (e) {
      return null;
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
