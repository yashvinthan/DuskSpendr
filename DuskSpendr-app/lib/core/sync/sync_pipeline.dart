import '../linking/account_linker.dart';
import '../privacy/privacy_engine.dart';

/// Sync Pipeline Core Contracts
/// Defines secure data ingestion interfaces and validation

/// Contract for raw data ingestion from external sources
abstract class DataIngestionContract {
  /// Validate incoming data before processing
  IngestionValidation validate(RawIngestionData data);

  /// Transform raw data to domain format
  List<IngestionRecord> transform(RawIngestionData data);

  /// Apply privacy filters and redactions
  List<IngestionRecord> applyPrivacyFilters(List<IngestionRecord> records);
}

/// Raw data received from external sources
class RawIngestionData {
  final IngestionSource source;
  final String providerId;
  final DateTime receivedAt;
  final Map<String, dynamic> payload;
  final Map<String, String>? headers;
  final String? signature;

  const RawIngestionData({
    required this.source,
    required this.providerId,
    required this.receivedAt,
    required this.payload,
    this.headers,
    this.signature,
  });
}

enum IngestionSource {
  bankApi,
  upiNotification,
  smsParser,
  manualEntry,
  csvImport,
  accountAggregator,
}

/// Validation result for ingestion
class IngestionValidation {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final SecurityCheck securityCheck;

  const IngestionValidation({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
    required this.securityCheck,
  });

  factory IngestionValidation.valid() => const IngestionValidation(
        isValid: true,
        securityCheck: SecurityCheck(passed: true),
      );

  factory IngestionValidation.invalid(List<String> errors) => IngestionValidation(
        isValid: false,
        errors: errors,
        securityCheck: const SecurityCheck(passed: false, reason: 'Validation failed'),
      );
}

class SecurityCheck {
  final bool passed;
  final String? reason;
  final bool isSignatureValid;
  final bool isTimestampValid;
  final bool isSourceTrusted;

  const SecurityCheck({
    required this.passed,
    this.reason,
    this.isSignatureValid = true,
    this.isTimestampValid = true,
    this.isSourceTrusted = true,
  });
}

/// Normalized record after ingestion
class IngestionRecord {
  final String id;
  final IngestionRecordType type;
  final DateTime timestamp;
  final int amountPaisa;
  final String? merchantName;
  final String? description;
  final String? category;
  final String? referenceId;
  final String sourceAccountId;
  final IngestionSource source;
  final double confidence;
  final Map<String, dynamic>? rawData;

  const IngestionRecord({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.amountPaisa,
    this.merchantName,
    this.description,
    this.category,
    this.referenceId,
    required this.sourceAccountId,
    required this.source,
    this.confidence = 1.0,
    this.rawData,
  });
}

enum IngestionRecordType {
  debit,
  credit,
  transfer,
}

/// Sync pipeline implementation
class SyncPipeline {
  final PrivacyEngine _privacyEngine;
  final List<IngestionValidator> _validators;
  final List<IngestionTransformer> _transformers;
  final List<IngestionFilter> _filters;

  SyncPipeline({
    PrivacyEngine? privacyEngine,
    List<IngestionValidator>? validators,
    List<IngestionTransformer>? transformers,
    List<IngestionFilter>? filters,
  })  : _privacyEngine = privacyEngine ?? PrivacyEngine(),
        _validators = validators ?? _defaultValidators(),
        _transformers = transformers ?? _defaultTransformers(),
        _filters = filters ?? _defaultFilters();

  /// Process incoming data through the pipeline
  Future<PipelineResult> process(RawIngestionData data) async {
    final context = PipelineContext(
      startTime: DateTime.now(),
      source: data.source,
      providerId: data.providerId,
    );

    try {
      // Step 1: Validate
      final validation = _validate(data);
      if (!validation.isValid) {
        return PipelineResult.failed(
          context: context,
          stage: PipelineStage.validation,
          errors: validation.errors,
        );
      }

      // Step 2: Transform
      var records = _transform(data);
      if (records.isEmpty) {
        return PipelineResult.empty(context: context);
      }

      // Step 3: Apply filters (privacy, dedup, etc.)
      records = await _filter(records);

      // Step 4: Final privacy validation
      for (final record in records) {
        final privacyCheck = _privacyEngine.validateTransaction(
          amountPaisa: record.amountPaisa,
          timestamp: record.timestamp,
          merchantName: record.merchantName,
        );
        if (!privacyCheck.isValid) {
          context.addWarning('Privacy check warning for ${record.id}');
        }
      }

      await _privacyEngine.logDataAccess(
        type: DataAccessType.sync,
        entity: 'ingestion_pipeline',
        details: 'Processed ${records.length} records from ${data.source.name}',
      );

      return PipelineResult.success(
        context: context,
        records: records,
      );
    } catch (e, st) {
      return PipelineResult.failed(
        context: context,
        stage: PipelineStage.processing,
        errors: [e.toString()],
        stackTrace: st,
      );
    }
  }

  IngestionValidation _validate(RawIngestionData data) {
    final errors = <String>[];
    final warnings = <String>[];

    for (final validator in _validators) {
      final result = validator.validate(data);
      errors.addAll(result.errors);
      warnings.addAll(result.warnings);
    }

    return IngestionValidation(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      securityCheck: _performSecurityCheck(data),
    );
  }

  SecurityCheck _performSecurityCheck(RawIngestionData data) {
    // Timestamp validation (not too old, not in future)
    final now = DateTime.now();
    final maxAge = const Duration(days: 365);
    final isTimestampValid = data.receivedAt.isAfter(now.subtract(maxAge)) &&
        data.receivedAt.isBefore(now.add(const Duration(hours: 1)));

    // Signature validation (if provided)
    final isSignatureValid = data.signature == null || _verifySignature(data);

    // Source trust check
    final isSourceTrusted = _isTrustedSource(data.source);

    return SecurityCheck(
      passed: isTimestampValid && isSignatureValid && isSourceTrusted,
      isTimestampValid: isTimestampValid,
      isSignatureValid: isSignatureValid,
      isSourceTrusted: isSourceTrusted,
    );
  }

  bool _verifySignature(RawIngestionData data) {
    // TODO: Implement signature verification based on provider
    return true;
  }

  bool _isTrustedSource(IngestionSource source) {
    return source != IngestionSource.csvImport; // CSV requires extra validation
  }

  List<IngestionRecord> _transform(RawIngestionData data) {
    var records = <IngestionRecord>[];
    for (final transformer in _transformers) {
      if (transformer.canHandle(data.source)) {
        records = transformer.transform(data);
        break;
      }
    }
    return records;
  }

  Future<List<IngestionRecord>> _filter(List<IngestionRecord> records) async {
    var filtered = records;
    for (final filter in _filters) {
      filtered = await filter.apply(filtered);
    }
    return filtered;
  }

  static List<IngestionValidator> _defaultValidators() => [
        TimestampValidator(),
        AmountValidator(),
        RequiredFieldsValidator(),
      ];

  static List<IngestionTransformer> _defaultTransformers() => [
        BankApiTransformer(),
        SmsTransformer(),
        UpiNotificationTransformer(),
      ];

  static List<IngestionFilter> _defaultFilters() => [
        DuplicateFilter(),
        PrivacyRedactionFilter(),
        AmountSanitizationFilter(),
      ];
}

// ====== Pipeline Context ======

class PipelineContext {
  final DateTime startTime;
  final IngestionSource source;
  final String providerId;
  final List<String> warnings = [];
  DateTime? endTime;

  PipelineContext({
    required this.startTime,
    required this.source,
    required this.providerId,
  });

  void addWarning(String warning) => warnings.add(warning);

  Duration get duration => (endTime ?? DateTime.now()).difference(startTime);
}

enum PipelineStage {
  validation,
  transformation,
  filtering,
  processing,
}

class PipelineResult {
  final bool success;
  final PipelineContext context;
  final List<IngestionRecord> records;
  final PipelineStage? failedStage;
  final List<String> errors;
  final StackTrace? stackTrace;

  const PipelineResult._({
    required this.success,
    required this.context,
    this.records = const [],
    this.failedStage,
    this.errors = const [],
    this.stackTrace,
  });

  factory PipelineResult.success({
    required PipelineContext context,
    required List<IngestionRecord> records,
  }) {
    context.endTime = DateTime.now();
    return PipelineResult._(
      success: true,
      context: context,
      records: records,
    );
  }

  factory PipelineResult.empty({required PipelineContext context}) {
    context.endTime = DateTime.now();
    return PipelineResult._(
      success: true,
      context: context,
      records: [],
    );
  }

  factory PipelineResult.failed({
    required PipelineContext context,
    required PipelineStage stage,
    required List<String> errors,
    StackTrace? stackTrace,
  }) {
    context.endTime = DateTime.now();
    return PipelineResult._(
      success: false,
      context: context,
      failedStage: stage,
      errors: errors,
      stackTrace: stackTrace,
    );
  }

  int get recordCount => records.length;
  bool get isEmpty => records.isEmpty;
}

// ====== Validators ======

abstract class IngestionValidator {
  IngestionValidation validate(RawIngestionData data);
}

class TimestampValidator implements IngestionValidator {
  @override
  IngestionValidation validate(RawIngestionData data) {
    final errors = <String>[];
    final now = DateTime.now();

    // Check if timestamp is reasonable
    final timestamp = data.payload['timestamp'];
    if (timestamp != null) {
      try {
        final dt = timestamp is DateTime 
            ? timestamp 
            : DateTime.parse(timestamp.toString());
        
        if (dt.isAfter(now.add(const Duration(days: 1)))) {
          errors.add('Transaction timestamp is in the future');
        }
        if (dt.isBefore(now.subtract(const Duration(days: 365 * 5)))) {
          errors.add('Transaction timestamp is too old (>5 years)');
        }
      } catch (e) {
        errors.add('Invalid timestamp format');
      }
    }

    return IngestionValidation(
      isValid: errors.isEmpty,
      errors: errors,
      securityCheck: const SecurityCheck(passed: true),
    );
  }
}

class AmountValidator implements IngestionValidator {
  static const _maxAmountPaisa = 10000000000; // 10 crore

  @override
  IngestionValidation validate(RawIngestionData data) {
    final errors = <String>[];
    final amount = data.payload['amount'] ?? data.payload['amountPaisa'];

    if (amount != null) {
      final amountValue = amount is int ? amount : int.tryParse(amount.toString());
      if (amountValue == null) {
        errors.add('Invalid amount format');
      } else if (amountValue < 0) {
        errors.add('Amount cannot be negative');
      } else if (amountValue > _maxAmountPaisa) {
        errors.add('Amount exceeds maximum limit');
      }
    }

    return IngestionValidation(
      isValid: errors.isEmpty,
      errors: errors,
      securityCheck: const SecurityCheck(passed: true),
    );
  }
}

class RequiredFieldsValidator implements IngestionValidator {
  @override
  IngestionValidation validate(RawIngestionData data) {
    final errors = <String>[];
    final payload = data.payload;

    // Check for required fields based on source
    switch (data.source) {
      case IngestionSource.bankApi:
        if (!payload.containsKey('transactionId')) {
          errors.add('Missing transaction ID');
        }
        if (!payload.containsKey('amount')) {
          errors.add('Missing amount');
        }
        break;
      case IngestionSource.smsParser:
        if (!payload.containsKey('smsBody')) {
          errors.add('Missing SMS body');
        }
        break;
      case IngestionSource.upiNotification:
        if (!payload.containsKey('upiId')) {
          errors.add('Missing UPI ID');
        }
        break;
      default:
        break;
    }

    return IngestionValidation(
      isValid: errors.isEmpty,
      errors: errors,
      securityCheck: const SecurityCheck(passed: true),
    );
  }
}

// ====== Transformers ======

abstract class IngestionTransformer {
  bool canHandle(IngestionSource source);
  List<IngestionRecord> transform(RawIngestionData data);
}

class BankApiTransformer implements IngestionTransformer {
  @override
  bool canHandle(IngestionSource source) => 
      source == IngestionSource.bankApi || source == IngestionSource.accountAggregator;

  @override
  List<IngestionRecord> transform(RawIngestionData data) {
    final transactions = data.payload['transactions'] as List? ?? [];
    return transactions.map((tx) {
      return IngestionRecord(
        id: tx['transactionId']?.toString() ?? '',
        type: (tx['type']?.toString().toLowerCase() == 'credit')
            ? IngestionRecordType.credit
            : IngestionRecordType.debit,
        timestamp: DateTime.tryParse(tx['timestamp']?.toString() ?? '') ?? DateTime.now(),
        amountPaisa: (tx['amount'] as num?)?.toInt() ?? 0,
        merchantName: tx['merchantName']?.toString(),
        description: tx['description']?.toString(),
        referenceId: tx['referenceId']?.toString(),
        sourceAccountId: data.providerId,
        source: data.source,
        confidence: 1.0,
        rawData: tx as Map<String, dynamic>?,
      );
    }).toList();
  }
}

class SmsTransformer implements IngestionTransformer {
  @override
  bool canHandle(IngestionSource source) => source == IngestionSource.smsParser;

  @override
  List<IngestionRecord> transform(RawIngestionData data) {
    final parsed = data.payload['parsed'] as Map<String, dynamic>?;
    if (parsed == null) return [];

    return [
      IngestionRecord(
        id: parsed['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: (parsed['type']?.toString().toLowerCase() == 'credit')
            ? IngestionRecordType.credit
            : IngestionRecordType.debit,
        timestamp: DateTime.tryParse(parsed['timestamp']?.toString() ?? '') ?? DateTime.now(),
        amountPaisa: (parsed['amountPaisa'] as num?)?.toInt() ?? 0,
        merchantName: parsed['merchantName']?.toString(),
        description: parsed['smsBody']?.toString(),
        referenceId: parsed['referenceId']?.toString(),
        sourceAccountId: data.providerId,
        source: data.source,
        confidence: (parsed['confidence'] as num?)?.toDouble() ?? 0.8,
        rawData: parsed,
      ),
    ];
  }
}

class UpiNotificationTransformer implements IngestionTransformer {
  @override
  bool canHandle(IngestionSource source) => source == IngestionSource.upiNotification;

  @override
  List<IngestionRecord> transform(RawIngestionData data) {
    final payload = data.payload;
    return [
      IngestionRecord(
        id: payload['txnId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: (payload['type']?.toString().toLowerCase() == 'credit')
            ? IngestionRecordType.credit
            : IngestionRecordType.debit,
        timestamp: DateTime.tryParse(payload['timestamp']?.toString() ?? '') ?? DateTime.now(),
        amountPaisa: (payload['amountPaisa'] as num?)?.toInt() ?? 0,
        merchantName: payload['payeeName']?.toString() ?? payload['payerName']?.toString(),
        description: payload['remarks']?.toString(),
        referenceId: payload['upiTxnId']?.toString(),
        sourceAccountId: data.providerId,
        source: data.source,
        confidence: 0.95,
        rawData: payload,
      ),
    ];
  }
}

// ====== Filters ======

abstract class IngestionFilter {
  Future<List<IngestionRecord>> apply(List<IngestionRecord> records);
}

class DuplicateFilter implements IngestionFilter {
  final Set<String> _seenIds = {};

  @override
  Future<List<IngestionRecord>> apply(List<IngestionRecord> records) async {
    final unique = <IngestionRecord>[];
    for (final record in records) {
      final key = '${record.sourceAccountId}_${record.referenceId ?? record.id}';
      if (!_seenIds.contains(key)) {
        _seenIds.add(key);
        unique.add(record);
      }
    }
    return unique;
  }
}

class PrivacyRedactionFilter implements IngestionFilter {
  @override
  Future<List<IngestionRecord>> apply(List<IngestionRecord> records) async {
    // Redact sensitive patterns from descriptions
    return records.map((record) {
      var description = record.description;
      if (description != null) {
        // Redact card numbers
        description = description.replaceAll(
          RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b'),
          'XXXX-XXXX-XXXX-XXXX',
        );
        // Redact Aadhaar
        description = description.replaceAll(
          RegExp(r'\b\d{4}\s?\d{4}\s?\d{4}\b'),
          'XXXX-XXXX-XXXX',
        );
      }
      return IngestionRecord(
        id: record.id,
        type: record.type,
        timestamp: record.timestamp,
        amountPaisa: record.amountPaisa,
        merchantName: record.merchantName,
        description: description,
        category: record.category,
        referenceId: record.referenceId,
        sourceAccountId: record.sourceAccountId,
        source: record.source,
        confidence: record.confidence,
        rawData: null, // Remove raw data after processing
      );
    }).toList();
  }
}

class AmountSanitizationFilter implements IngestionFilter {
  @override
  Future<List<IngestionRecord>> apply(List<IngestionRecord> records) async {
    // Filter out zero or invalid amounts
    return records.where((r) => r.amountPaisa > 0).toList();
  }
}
