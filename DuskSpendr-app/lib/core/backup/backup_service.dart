import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';

import '../security/encryption_service.dart';
import '../privacy/privacy_engine.dart';
import 'backup_metadata_store.dart';

/// SS-006: Secure Backup/Restore System
/// Encrypted backup files, local storage backup, CSV/JSON export, automatic scheduling
class BackupService {
  final EncryptionService _encryptionService;
  final PrivacyEngine _privacyEngine;
  final BackupMetadataStore? _metadataStore;
  static const _storage = FlutterSecureStorage();
  static const _lastBackupKey = 'last_backup_timestamp';
  static const _backupScheduleKey = 'backup_schedule';
  static const _backupVersion = 1;
  final Uuid _uuid = const Uuid();

  BackupService({
    EncryptionService? encryptionService,
    PrivacyEngine? privacyEngine,
    BackupMetadataStore? metadataStore,
  })  : _encryptionService = encryptionService ?? EncryptionService(),
        _privacyEngine = privacyEngine ?? PrivacyEngine(),
        _metadataStore = metadataStore;

  // ====== Backup Creation ======

  /// Create encrypted backup of all data
  Future<BackupResult> createBackup({
    required List<Map<String, dynamic>> transactions,
    required List<Map<String, dynamic>> accounts,
    required List<Map<String, dynamic>> budgets,
    required List<Map<String, dynamic>> customCategories,
    String? customPath,
  }) async {
    try {
      // Log backup action
      await _privacyEngine.logDataAccess(
        type: DataAccessType.export,
        entity: 'backup',
        details: 'Creating encrypted backup',
      );

      // Prepare backup data
      final backupData = BackupData(
        version: _backupVersion,
        createdAt: DateTime.now(),
        appVersion: '1.0.0',
        transactions: transactions,
        accounts: accounts,
        budgets: budgets,
        customCategories: customCategories,
      );

      // Serialize to JSON
      final jsonString = jsonEncode(backupData.toJson());

      // Encrypt the data
      final encryptedData = await _encryptionService.encryptData(jsonString);

      // Get backup directory
      final backupDir = await _getBackupDirectory();
      final filename = _generateBackupFilename();
      final filePath = customPath ?? p.join(backupDir.path, filename);

      // Write encrypted backup
      final backupFile = File(filePath);
      await backupFile.writeAsString(encryptedData);

      // Update last backup timestamp
      await _storage.write(
        key: _lastBackupKey,
        value: DateTime.now().toIso8601String(),
      );

      final checksum = await _calculateChecksum(encryptedData);

      await _metadataStore?.recordBackup(
        BackupMetadataEntry(
          id: _uuid.v4(),
          filePath: filePath,
          createdAt: DateTime.now(),
          sizeBytes: backupFile.lengthSync(),
          checksum: checksum,
          version: _backupVersion,
          isEncrypted: true,
        ),
      );

      return BackupResult(
        success: true,
        filePath: filePath,
        timestamp: DateTime.now(),
        size: backupFile.lengthSync(),
      );
    } catch (e) {
      return BackupResult(
        success: false,
        error: e.toString(),
        timestamp: DateTime.now(),
      );
    }
  }

  /// Create CSV export (non-encrypted, for external use)
  Future<ExportResult> exportToCsv({
    required List<Map<String, dynamic>> transactions,
    required ExportDateRange dateRange,
  }) async {
    try {
      await _privacyEngine.logDataAccess(
        type: DataAccessType.export,
        entity: 'transactions',
        details: 'CSV export',
      );

      // Filter transactions by date range
      final filtered = _filterByDateRange(transactions, dateRange);

      // Build CSV content
      final buffer = StringBuffer();

      // Header
      buffer.writeln(
          'Date,Time,Type,Amount,Category,Merchant,Description,Payment Method,Source');

      // Data rows
      for (final tx in filtered) {
        final date = DateTime.parse(tx['timestamp'] ?? DateTime.now().toIso8601String());
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        final timeStr = DateFormat('HH:mm:ss').format(date);
        final amount = (tx['amountPaisa'] ?? 0) / 100;
        final type = tx['type'] == 0 ? 'Debit' : 'Credit';

        buffer.writeln([
          dateStr,
          timeStr,
          type,
          amount.toStringAsFixed(2),
          _escapeCsv(tx['category']?.toString() ?? ''),
          _escapeCsv(tx['merchantName'] ?? ''),
          _escapeCsv(tx['description'] ?? ''),
          _escapeCsv(tx['paymentMethod']?.toString() ?? ''),
          _escapeCsv(tx['source']?.toString() ?? ''),
        ].join(','));
      }

      // Write to file
      final exportDir = await _getExportDirectory();
      final filename = 'duskspendr_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      final filePath = p.join(exportDir.path, filename);

      final exportFile = File(filePath);
      await exportFile.writeAsString(buffer.toString());

      return ExportResult(
        success: true,
        filePath: filePath,
        format: ExportFormat.csv,
        recordCount: filtered.length,
      );
    } catch (e) {
      return ExportResult(
        success: false,
        format: ExportFormat.csv,
        error: e.toString(),
      );
    }
  }

  /// Create JSON export
  Future<ExportResult> exportToJson({
    required List<Map<String, dynamic>> transactions,
    required ExportDateRange dateRange,
    bool prettyPrint = true,
  }) async {
    try {
      await _privacyEngine.logDataAccess(
        type: DataAccessType.export,
        entity: 'transactions',
        details: 'JSON export',
      );

      final filtered = _filterByDateRange(transactions, dateRange);

      final exportData = {
        'exportedAt': DateTime.now().toIso8601String(),
        'appVersion': '1.0.0',
        'transactionCount': filtered.length,
        'dateRange': {
          'from': dateRange.from?.toIso8601String(),
          'to': dateRange.to?.toIso8601String(),
        },
        'transactions': filtered,
      };

      final jsonString = prettyPrint
          ? const JsonEncoder.withIndent('  ').convert(exportData)
          : jsonEncode(exportData);

      final exportDir = await _getExportDirectory();
      final filename = 'duskspendr_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
      final filePath = p.join(exportDir.path, filename);

      final exportFile = File(filePath);
      await exportFile.writeAsString(jsonString);

      return ExportResult(
        success: true,
        filePath: filePath,
        format: ExportFormat.json,
        recordCount: filtered.length,
      );
    } catch (e) {
      return ExportResult(
        success: false,
        format: ExportFormat.json,
        error: e.toString(),
      );
    }
  }

  // ====== Backup Restoration ======

  /// Restore from encrypted backup
  Future<RestoreResult> restoreFromBackup(String filePath) async {
    try {
      await _privacyEngine.logDataAccess(
        type: DataAccessType.write,
        entity: 'backup',
        details: 'Restoring from backup',
      );

      final backupFile = File(filePath);
      if (!await backupFile.exists()) {
        return RestoreResult(
          success: false,
          error: 'Backup file not found',
        );
      }

      // Read encrypted data
      final encryptedData = await backupFile.readAsString();

      // Decrypt
      final jsonString = await _encryptionService.decryptData(encryptedData);

      // Parse backup data
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final backupData = BackupData.fromJson(json);

      // Validate backup version
      if (backupData.version > 1) {
        return RestoreResult(
          success: false,
          error: 'Backup version not supported. Please update the app.',
        );
      }

      final result = RestoreResult(
        success: true,
        backupData: backupData,
        restoredAt: DateTime.now(),
      );

      await _metadataStore?.recordRestore(
        filePath: filePath,
        restoredAt: DateTime.now(),
      );

      return result;
    } catch (e) {
      return RestoreResult(
        success: false,
        error: 'Failed to restore backup: ${e.toString()}',
      );
    }
  }

  // ====== Automatic Scheduling ======

  /// Set backup schedule
  Future<void> setBackupSchedule(BackupSchedule schedule) async {
    await _storage.write(
      key: _backupScheduleKey,
      value: jsonEncode(schedule.toJson()),
    );
  }

  /// Get backup schedule
  Future<BackupSchedule?> getBackupSchedule() async {
    final scheduleJson = await _storage.read(key: _backupScheduleKey);
    if (scheduleJson == null) return null;
    return BackupSchedule.fromJson(jsonDecode(scheduleJson));
  }

  /// Check if backup is due
  Future<bool> isBackupDue() async {
    final schedule = await getBackupSchedule();
    if (schedule == null || !schedule.isEnabled) return false;

    final lastBackupStr = await _storage.read(key: _lastBackupKey);
    if (lastBackupStr == null) return true;

    final lastBackup = DateTime.parse(lastBackupStr);
    final now = DateTime.now();

    switch (schedule.frequency) {
      case BackupFrequency.daily:
        return now.difference(lastBackup).inDays >= 1;
      case BackupFrequency.weekly:
        return now.difference(lastBackup).inDays >= 7;
      case BackupFrequency.monthly:
        return now.difference(lastBackup).inDays >= 30;
    }
  }

  /// Get last backup timestamp
  Future<DateTime?> getLastBackupTime() async {
    final lastBackupStr = await _storage.read(key: _lastBackupKey);
    if (lastBackupStr == null) return null;
    return DateTime.parse(lastBackupStr);
  }

  /// List available backups
  Future<List<BackupFile>> listBackups() async {
    final backupDir = await _getBackupDirectory();
    if (!await backupDir.exists()) return [];

    final files = await backupDir.list().toList();
    final backups = <BackupFile>[];

    for (final file in files) {
      if (file is File && file.path.endsWith('.duskbackup')) {
        final stat = await file.stat();
        backups.add(BackupFile(
          path: file.path,
          filename: p.basename(file.path),
          createdAt: stat.modified,
          size: stat.size,
        ));
      }
    }

    backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return backups;
  }

  /// Delete a backup file
  Future<bool> deleteBackup(String filePath) async {
    try {
      await _privacyEngine.logDataAccess(
        type: DataAccessType.delete,
        entity: 'backup',
        details: 'Deleting backup file',
      );

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ====== Helper Methods ======

  Future<Directory> _getBackupDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(appDir.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  Future<Directory> _getExportDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(appDir.path, 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    return exportDir;
  }

  String _generateBackupFilename() {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'duskspendr_backup_$timestamp.duskbackup';
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  Future<String> _calculateChecksum(String encryptedData) async {
    final bytes = base64Url.decode(encryptedData);
    final digest = await Sha256().hash(bytes);
    return base64UrlEncode(digest.bytes);
  }

  List<Map<String, dynamic>> _filterByDateRange(
    List<Map<String, dynamic>> transactions,
    ExportDateRange dateRange,
  ) {
    if (dateRange.from == null && dateRange.to == null) {
      return transactions;
    }

    return transactions.where((tx) {
      final timestamp = DateTime.parse(tx['timestamp'] ?? DateTime.now().toIso8601String());
      if (dateRange.from != null && timestamp.isBefore(dateRange.from!)) {
        return false;
      }
      if (dateRange.to != null && timestamp.isAfter(dateRange.to!)) {
        return false;
      }
      return true;
    }).toList();
  }
}

// ====== Data Classes ======

class BackupData {
  final int version;
  final DateTime createdAt;
  final String appVersion;
  final List<Map<String, dynamic>> transactions;
  final List<Map<String, dynamic>> accounts;
  final List<Map<String, dynamic>> budgets;
  final List<Map<String, dynamic>> customCategories;

  const BackupData({
    required this.version,
    required this.createdAt,
    required this.appVersion,
    required this.transactions,
    required this.accounts,
    required this.budgets,
    required this.customCategories,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'createdAt': createdAt.toIso8601String(),
        'appVersion': appVersion,
        'transactions': transactions,
        'accounts': accounts,
        'budgets': budgets,
        'customCategories': customCategories,
      };

  factory BackupData.fromJson(Map<String, dynamic> json) => BackupData(
        version: json['version'] ?? 1,
        createdAt: DateTime.parse(json['createdAt']),
        appVersion: json['appVersion'] ?? '1.0.0',
        transactions: List<Map<String, dynamic>>.from(json['transactions'] ?? []),
        accounts: List<Map<String, dynamic>>.from(json['accounts'] ?? []),
        budgets: List<Map<String, dynamic>>.from(json['budgets'] ?? []),
        customCategories: List<Map<String, dynamic>>.from(json['customCategories'] ?? []),
      );
}

class BackupResult {
  final bool success;
  final String? filePath;
  final DateTime timestamp;
  final int? size;
  final String? error;

  const BackupResult({
    required this.success,
    this.filePath,
    required this.timestamp,
    this.size,
    this.error,
  });
}

class RestoreResult {
  final bool success;
  final BackupData? backupData;
  final DateTime? restoredAt;
  final String? error;

  const RestoreResult({
    required this.success,
    this.backupData,
    this.restoredAt,
    this.error,
  });
}

enum ExportFormat { csv, json }

class ExportResult {
  final bool success;
  final String? filePath;
  final ExportFormat format;
  final int? recordCount;
  final String? error;

  const ExportResult({
    required this.success,
    this.filePath,
    required this.format,
    this.recordCount,
    this.error,
  });
}

class ExportDateRange {
  final DateTime? from;
  final DateTime? to;

  const ExportDateRange({this.from, this.to});

  factory ExportDateRange.last30Days() => ExportDateRange(
        from: DateTime.now().subtract(const Duration(days: 30)),
        to: DateTime.now(),
      );

  factory ExportDateRange.last90Days() => ExportDateRange(
        from: DateTime.now().subtract(const Duration(days: 90)),
        to: DateTime.now(),
      );

  factory ExportDateRange.all() => const ExportDateRange();
}

enum BackupFrequency { daily, weekly, monthly }

class BackupSchedule {
  final bool isEnabled;
  final BackupFrequency frequency;
  final int preferredHour; // 0-23

  const BackupSchedule({
    required this.isEnabled,
    required this.frequency,
    this.preferredHour = 2, // Default 2 AM
  });

  Map<String, dynamic> toJson() => {
        'isEnabled': isEnabled,
        'frequency': frequency.name,
        'preferredHour': preferredHour,
      };

  factory BackupSchedule.fromJson(Map<String, dynamic> json) => BackupSchedule(
        isEnabled: json['isEnabled'] ?? false,
        frequency: BackupFrequency.values.byName(json['frequency'] ?? 'weekly'),
        preferredHour: json['preferredHour'] ?? 2,
      );
}

class BackupFile {
  final String path;
  final String filename;
  final DateTime createdAt;
  final int size;

  const BackupFile({
    required this.path,
    required this.filename,
    required this.createdAt,
    required this.size,
  });

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
