import 'privacy_store.dart';
import 'secure_storage_privacy_store.dart';

/// SS-004: Privacy Engine
/// Core privacy infrastructure with data validation, encryption utilities,
/// audit trails, and privacy reports
class PrivacyEngine {
  PrivacyStore _store;

  /// Singleton instance
  static final PrivacyEngine _instance = PrivacyEngine._internal();
  factory PrivacyEngine({PrivacyStore? store}) {
    if (store != null) {
      _instance._store = store;
    }
    return _instance;
  }
  PrivacyEngine._internal() : _store = SecureStoragePrivacyStore();

  // ====== Data Validation ======

  /// Validate transaction data before storage
  ValidationResult validateTransaction({
    required int amountPaisa,
    required DateTime timestamp,
    required String? merchantName,
  }) {
    final errors = <String>[];

    if (amountPaisa <= 0) {
      errors.add('Amount must be positive');
    }
    if (amountPaisa > 100000000) {
      // 10 lakh limit for students
      errors.add('Amount exceeds maximum limit');
    }
    if (timestamp.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      errors.add('Transaction date cannot be in the future');
    }
    if (merchantName != null && merchantName.length > 100) {
      errors.add('Merchant name too long');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate SMS content for privacy compliance
  ValidationResult validateSmsContent(String smsBody) {
    final errors = <String>[];

    // Check for potential phishing URLs
    if (_containsPhishingPatterns(smsBody)) {
      errors.add('Potential phishing content detected');
    }

    // Check for excessive personal data
    if (_containsExcessivePersonalData(smsBody)) {
      errors.add('Excessive personal data detected');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  bool _containsPhishingPatterns(String text) {
    final phishingPatterns = [
      RegExp(r'(?:bit\.ly|tinyurl|goo\.gl|t\.co)/\w+', caseSensitive: false),
      RegExp(r'click\s+here\s+to\s+(?:verify|update|confirm)', caseSensitive: false),
      RegExp(r'account.*(?:suspend|block|freeze)', caseSensitive: false),
      RegExp(r'(?:urgent|immediate)\s+action\s+required', caseSensitive: false),
    ];

    return phishingPatterns.any((pattern) => pattern.hasMatch(text));
  }

  bool _containsExcessivePersonalData(String text) {
    // Check for multiple PAN, Aadhaar patterns (should not be in bank SMS)
    final panPattern = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]');
    final aadhaarPattern = RegExp(r'[0-9]{4}\s?[0-9]{4}\s?[0-9]{4}');

    final panMatches = panPattern.allMatches(text).length;
    final aadhaarMatches = aadhaarPattern.allMatches(text).length;

    return panMatches > 1 || aadhaarMatches > 1;
  }

  // ====== Audit Trail ======

  /// Log a data access event
  Future<void> logDataAccess({
    required DataAccessType type,
    required String entity,
    String? entityId,
    String? details,
  }) async {
    final entry = AuditEntry(
      timestamp: DateTime.now(),
      type: type,
      entity: entity,
      entityId: entityId,
      details: details,
    );

    await _store.appendAuditEntry(entry);
  }

  /// Get audit trail entries
  Future<List<AuditEntry>> getAuditTrail({
    DateTime? from,
    DateTime? to,
    DataAccessType? type,
  }) async {
    return _store.getAuditEntries(from: from, to: to, type: type);
  }

  // ====== Privacy Reports ======

  /// Generate privacy report showing what data is stored
  Future<PrivacyReport> generatePrivacyReport({
    required int transactionCount,
    required int linkedAccountCount,
    required int budgetCount,
  }) async {
    final auditEntries = await getAuditTrail();
    final report = PrivacyReport(
      generatedAt: DateTime.now(),
      dataStats: DataStats(
        transactionCount: transactionCount,
        linkedAccountCount: linkedAccountCount,
        budgetCount: budgetCount,
      ),
      recentAccessCount: auditEntries
          .where((e) => e.timestamp.isAfter(
              DateTime.now().subtract(const Duration(days: 7))))
          .length,
      dataStorageInfo: const DataStorageInfo(
        encryptionEnabled: true,
        encryptionAlgorithm: 'AES-256 (SQLCipher)',
        localStorageOnly: true,
        smsProcessedOnDevice: true,
      ),
      privacyFeatures: const [
        'All data encrypted with AES-256',
        'SMS processed on-device only',
        'Biometric/PIN authentication required',
        'No data shared with third parties',
        'Complete data deletion on request',
        'Audit trail of all data access',
      ],
    );

    await _store.savePrivacyReport(report);
    return report;
  }

  Future<PrivacyReport?> getLatestPrivacyReport() async {
    return _store.getLatestPrivacyReport();
  }

  // ====== Data Sanitization ======

  /// Sanitize sensitive data for display (mask account numbers, etc.)
  String maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    final visiblePart = accountNumber.substring(accountNumber.length - 4);
    return 'XXXX-XXXX-$visiblePart';
  }

  /// Mask UPI ID for privacy
  String maskUpiId(String upiId) {
    final parts = upiId.split('@');
    if (parts.length != 2) return upiId;
    final username = parts[0];
    if (username.length <= 3) return upiId;
    final masked = '${username.substring(0, 2)}${'*' * (username.length - 2)}';
    return '$masked@${parts[1]}';
  }

  /// Mask phone number
  String maskPhoneNumber(String phone) {
    if (phone.length < 10) return phone;
    return '${phone.substring(0, 2)}XXXXXX${phone.substring(phone.length - 2)}';
  }

  // ====== Complete Data Deletion ======

  /// Delete all user data securely
  Future<void> deleteAllUserData() async {
    // Log the deletion request
    await logDataAccess(
      type: DataAccessType.delete,
      entity: 'all_user_data',
      details: 'Complete data deletion requested',
    );

    await _store.clearAll();

    // Note: Database cleanup should be handled by the database service
  }
}

// ====== Data Classes ======

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  const ValidationResult({
    required this.isValid,
    this.errors = const [],
  });
}

enum DataAccessType {
  read,
  write,
  update,
  delete,
  export,
  sync,
}

class AuditEntry {
  final DateTime timestamp;
  final DataAccessType type;
  final String entity;
  final String? entityId;
  final String? details;

  const AuditEntry({
    required this.timestamp,
    required this.type,
    required this.entity,
    this.entityId,
    this.details,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'type': type.name,
        'entity': entity,
        'entityId': entityId,
        'details': details,
      };

  factory AuditEntry.fromJson(Map<String, dynamic> json) => AuditEntry(
        timestamp: DateTime.parse(json['timestamp']),
        type: DataAccessType.values.byName(json['type']),
        entity: json['entity'],
        entityId: json['entityId'],
        details: json['details'],
      );
}

class PrivacyReport {
  final DateTime generatedAt;
  final DataStats dataStats;
  final int recentAccessCount;
  final DataStorageInfo dataStorageInfo;
  final List<String> privacyFeatures;

  const PrivacyReport({
    required this.generatedAt,
    required this.dataStats,
    required this.recentAccessCount,
    required this.dataStorageInfo,
    required this.privacyFeatures,
  });
}

class DataStats {
  final int transactionCount;
  final int linkedAccountCount;
  final int budgetCount;

  const DataStats({
    required this.transactionCount,
    required this.linkedAccountCount,
    required this.budgetCount,
  });
}

class DataStorageInfo {
  final bool encryptionEnabled;
  final String encryptionAlgorithm;
  final bool localStorageOnly;
  final bool smsProcessedOnDevice;

  const DataStorageInfo({
    required this.encryptionEnabled,
    required this.encryptionAlgorithm,
    required this.localStorageOnly,
    required this.smsProcessedOnDevice,
  });
}
