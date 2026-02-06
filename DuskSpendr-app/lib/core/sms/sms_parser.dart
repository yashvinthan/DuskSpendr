import 'dart:async';

import 'financial_institution_database.dart';

/// SS-033 to SS-039: SMS Parsing System
/// On-device processing, financial institution verification, spam detection,
/// transaction extraction, balance extraction, duplicate detection, recurring detection

/// SMS Parser Design (SS-033)
/// All SMS processing happens on-device - raw SMS never leaves the device
class SmsParser {
  final FinancialInstitutionVerifier _institutionVerifier;
  final SpamDetector _spamDetector;
  final TransactionExtractor _transactionExtractor;
  final BalanceExtractor _balanceExtractor;
  final DuplicateDetector _duplicateDetector;
  final RecurringDetector _recurringDetector;

  SmsParser({
    FinancialInstitutionVerifier? institutionVerifier,
    SpamDetector? spamDetector,
    TransactionExtractor? transactionExtractor,
    BalanceExtractor? balanceExtractor,
    DuplicateDetector? duplicateDetector,
    RecurringDetector? recurringDetector,
  })  : _institutionVerifier =
            institutionVerifier ?? FinancialInstitutionVerifier(),
        _spamDetector = spamDetector ?? SpamDetector(),
        _transactionExtractor = transactionExtractor ?? TransactionExtractor(),
        _balanceExtractor = balanceExtractor ?? BalanceExtractor(),
        _duplicateDetector = duplicateDetector ?? DuplicateDetector(),
        _recurringDetector = recurringDetector ?? RecurringDetector();

  /// Parse a single SMS and extract financial information
  Future<SmsParseResult> parseSms(RawSms sms) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Step 1: Verify sender is a known financial institution
      final institutionResult = _institutionVerifier.verify(sms.sender);
      if (!institutionResult.isValidInstitution) {
        stopwatch.stop();
        return SmsParseResult.ignored(
          reason: 'Not from known financial institution',
          processingTimeMs: stopwatch.elapsedMilliseconds,
        );
      }

      // Step 2: Check for spam/phishing
      final spamResult = _spamDetector.check(sms.body);
      if (spamResult.isSpam) {
        stopwatch.stop();
        return SmsParseResult.spam(
          reason: spamResult.reason ?? 'Suspected spam',
          confidence: spamResult.confidence,
          processingTimeMs: stopwatch.elapsedMilliseconds,
        );
      }

      // Step 3: Extract transaction if present
      final transactionResult = _transactionExtractor.extract(
        sms.body,
        institutionResult.institution!,
        sms.timestamp,
      );

      // Step 4: Extract balance if present
      final balanceResult = _balanceExtractor.extract(sms.body);

      stopwatch.stop();

      if (transactionResult != null || balanceResult != null) {
        return SmsParseResult.success(
          institution: institutionResult.institution!,
          transaction: transactionResult,
          balance: balanceResult,
          processingTimeMs: stopwatch.elapsedMilliseconds,
        );
      }

      return SmsParseResult.ignored(
        reason: 'No financial data found',
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      stopwatch.stop();
      return SmsParseResult.error(
        error: e.toString(),
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    }
  }

  /// Parse multiple SMS messages in batch
  Future<List<SmsParseResult>> parseBatch(List<RawSms> messages) async {
    final results = <SmsParseResult>[];
    for (final sms in messages) {
      results.add(await parseSms(sms));
    }
    return results;
  }

  /// Check for duplicates in parsed transactions
  List<ParsedTransaction> removeDuplicates(
    List<ParsedTransaction> newTransactions,
    List<ParsedTransaction> existingTransactions,
  ) {
    return _duplicateDetector.filterDuplicates(
      newTransactions,
      existingTransactions,
    );
  }

  /// Detect recurring patterns in transactions
  List<RecurringPattern> detectRecurringPatterns(
    List<ParsedTransaction> transactions,
  ) {
    return _recurringDetector.detect(transactions);
  }
}

/// SS-034: Financial Institution Verification
/// Sender ID whitelist for banks and UPI apps
class FinancialInstitutionVerifier {
  InstitutionVerifyResult verify(String sender) {
    final normalizedSender =
        sender.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

    // Check exact match first using the comprehensive database
    if (FinancialInstitutionDatabase.senderPatterns
        .containsKey(normalizedSender)) {
      return InstitutionVerifyResult(
        isValidInstitution: true,
        institution:
            FinancialInstitutionDatabase.senderPatterns[normalizedSender],
      );
    }

    // Check if sender contains any known pattern
    for (final entry in FinancialInstitutionDatabase.senderPatterns.entries) {
      if (normalizedSender.contains(entry.key)) {
        return InstitutionVerifyResult(
          isValidInstitution: true,
          institution: entry.value,
        );
      }
    }

    // Check regex patterns
    for (final entry in FinancialInstitutionDatabase.regexPatterns.entries) {
      if (entry.key.hasMatch(sender)) {
        return InstitutionVerifyResult(
          isValidInstitution: true,
          institution: entry.value,
        );
      }
    }

    return const InstitutionVerifyResult(isValidInstitution: false);
  }
}

/// SS-035: Spam/Fake SMS Detection
class SpamDetector {
  SpamCheckResult check(String smsBody) {
    final normalizedBody = smsBody.toLowerCase();

    // Check for phishing URL patterns
    if (_containsPhishingUrl(normalizedBody)) {
      return const SpamCheckResult(
        isSpam: true,
        reason: 'Contains suspicious URL',
        confidence: 0.95,
      );
    }

    // Check for scam patterns
    if (_containsScamPattern(normalizedBody)) {
      return const SpamCheckResult(
        isSpam: true,
        reason: 'Contains scam patterns',
        confidence: 0.9,
      );
    }

    // Check for suspicious urgency
    if (_containsSuspiciousUrgency(normalizedBody)) {
      return const SpamCheckResult(
        isSpam: true,
        reason: 'Suspicious urgency language',
        confidence: 0.8,
      );
    }

    return const SpamCheckResult(isSpam: false);
  }

  bool _containsPhishingUrl(String text) {
    final phishingPatterns = [
      RegExp(r'bit\.ly/\w+'),
      RegExp(r'tinyurl\.com/\w+'),
      RegExp(r'goo\.gl/\w+'),
      RegExp(r't\.co/\w+'),
      RegExp(r'is\.gd/\w+'),
      RegExp(r'ow\.ly/\w+'),
      RegExp(r'cli\.ck/\w+'),
      RegExp(r'rb\.gy/\w+'),
      // IP-based URLs
      RegExp(r'http[s]?://\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(?::\d+)?'),
      // Bank impersonation / suspicious domains (SS-035 hardening)
      RegExp(r'https?://[^\s]*(?:sbi|hdfc|icici|axis|bank)[^\s]*\.(?:com|in|net)', caseSensitive: false),
      RegExp(r'https?://[^\s]*secure[^\s]*login[^\s]*', caseSensitive: false),
      RegExp(r'https?://[^\s]*kyc[^\s]*verify[^\s]*', caseSensitive: false),
      RegExp(r'https?://[^\s]*upi[^\s]*(?:link|update|claim)[^\s]*', caseSensitive: false),
    ];

    return phishingPatterns.any((pattern) => pattern.hasMatch(text));
  }

  bool _containsScamPattern(String text) {
    final scamPatterns = [
      'kyc update',
      'kyc expire',
      'account block',
      'account suspend',
      'pan link',
      'link pan urgent',
      'claim prize',
      'won lottery',
      'won prize',
      'lucky draw winner',
      'claim reward',
      'act now or',
      'verify immediately',
    ];

    return scamPatterns.any((pattern) => text.contains(pattern));
  }

  bool _containsSuspiciousUrgency(String text) {
    final urgencyPatterns = [
      RegExp(
          r'(?:account|card|kyc).*(?:block|suspend|expire).*(?:within|before)\s+\d+\s*(?:hour|hr|min)'),
      RegExp(r'urgent.*(?:action|response).*required'),
      RegExp(r'immediately.*(?:call|click|verify)'),
    ];

    return urgencyPatterns.any((pattern) => pattern.hasMatch(text));
  }
}

/// SS-036: Transaction Extraction from SMS
class TransactionExtractor {
  // Common amount patterns in Indian SMS
  static final _amountPatterns = [
    // Rs. 1,234.56 or Rs.1234.56
    RegExp(r'(?:rs\.?|inr|₹)\s*([\d,]+(?:\.\d{1,2})?)', caseSensitive: false),
    // 1,234.56 INR
    RegExp(r'([\d,]+(?:\.\d{1,2})?)\s*(?:inr|rupees)', caseSensitive: false),
  ];

  // Transaction type patterns
  static final _debitPatterns = [
    RegExp(r'(?:debited|withdrawn|spent|paid|sent|transferred out|purchase)',
        caseSensitive: false),
  ];

  static final _creditPatterns = [
    RegExp(r'(?:credited|received|deposited|added|transferred in|refund)',
        caseSensitive: false),
  ];

  // Reference ID patterns
  static final _refPatterns = [
    RegExp(r'(?:ref(?:erence)?(?:\s*(?:no|id|#)?)?[:\s]*)([\w\d]+)',
        caseSensitive: false),
    RegExp(r'(?:upi\s*(?:ref|id)?[:\s]*)([\d]{12})', caseSensitive: false),
    RegExp(r'(?:txn\s*(?:id|no)?[:\s]*)([\w\d]+)', caseSensitive: false),
  ];

  // Account number patterns (last 4 digits)
  static final _accountPatterns = [
    RegExp(r'(?:a/c|acc(?:ount)?|xx+)[\s*x]*(\d{4})', caseSensitive: false),
    RegExp(r'(?:ending|linked)\s*(?:with)?\s*(\d{4})', caseSensitive: false),
  ];

  // UPI ID patterns
  static final _upiPatterns = [
    RegExp(r'(?:to|from|vpa[:\s]*)([a-z0-9._-]+@[a-z]+)', caseSensitive: false),
  ];

  // Merchant/Beneficiary patterns
  static final _merchantPatterns = [
    RegExp(
        r'(?:to|at|for|beneficiary[:\s]*)([A-Z][A-Za-z\s]+?)(?:\s+(?:on|ref|upi|$))',
        caseSensitive: false),
  ];

  ParsedTransaction? extract(
    String smsBody,
    FinancialInstitution institution,
    DateTime smsTimestamp,
  ) {
    // Extract amount
    int? amountPaisa;
    for (final pattern in _amountPatterns) {
      final match = pattern.firstMatch(smsBody);
      if (match != null) {
        final amountStr = match.group(1)?.replaceAll(',', '');
        if (amountStr != null) {
          final amount = double.tryParse(amountStr);
          if (amount != null) {
            amountPaisa = (amount * 100).round();
            break;
          }
        }
      }
    }

    if (amountPaisa == null) return null;

    // Determine transaction type
    bool isDebit = _debitPatterns.any((p) => p.hasMatch(smsBody));
    bool isCredit = _creditPatterns.any((p) => p.hasMatch(smsBody));

    // Default to debit if unclear
    if (!isDebit && !isCredit) {
      isDebit = true;
    }

    // Extract reference ID
    String? referenceId;
    for (final pattern in _refPatterns) {
      final match = pattern.firstMatch(smsBody);
      if (match != null) {
        referenceId = match.group(1);
        break;
      }
    }

    // Extract account number
    String? accountNumber;
    for (final pattern in _accountPatterns) {
      final match = pattern.firstMatch(smsBody);
      if (match != null) {
        accountNumber = 'XXXX${match.group(1)}';
        break;
      }
    }

    // Extract UPI ID
    String? upiId;
    for (final pattern in _upiPatterns) {
      final match = pattern.firstMatch(smsBody);
      if (match != null) {
        upiId = match.group(1);
        break;
      }
    }

    // Extract merchant name
    String? merchantName;
    for (final pattern in _merchantPatterns) {
      final match = pattern.firstMatch(smsBody);
      if (match != null) {
        merchantName = match.group(1)?.trim();
        break;
      }
    }

    // Calculate confidence
    double confidence = _calculateConfidence(
      hasAmount: true,
      hasTypeIndicator: isDebit || isCredit,
      hasReference: referenceId != null,
      hasAccount: accountNumber != null,
    );

    return ParsedTransaction(
      amountPaisa: amountPaisa,
      isDebit: isDebit,
      timestamp: smsTimestamp,
      referenceId: referenceId,
      accountNumber: accountNumber,
      upiId: upiId,
      merchantName: merchantName,
      institution: institution,
      confidence: confidence,
      rawSmsBody: smsBody,
    );
  }

  double _calculateConfidence({
    required bool hasAmount,
    required bool hasTypeIndicator,
    required bool hasReference,
    required bool hasAccount,
  }) {
    double score = 0.5; // Base score for having amount
    if (hasTypeIndicator) score += 0.2;
    if (hasReference) score += 0.15;
    if (hasAccount) score += 0.15;
    return score.clamp(0.0, 1.0);
  }
}

/// SS-037: Balance Extraction from SMS
class BalanceExtractor {
  static final _balancePatterns = [
    // Available balance is Rs.1234.56
    RegExp(
        r'(?:available|avl|a/c|account)\s*(?:balance|bal)[:\s]*(?:rs\.?|inr|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
        caseSensitive: false),
    // Bal: Rs.1234.56
    RegExp(r'(?:bal|balance)[:\s]*(?:rs\.?|inr|₹)\s*([\d,]+(?:\.\d{1,2})?)',
        caseSensitive: false),
    // After this txn, balance: Rs.1234.56
    RegExp(
        r'(?:after|new|updated?)\s*(?:this)?\s*(?:txn|transaction)?\s*(?:,)?\s*(?:balance|bal)[:\s]*(?:rs\.?|inr|₹)?\s*([\d,]+(?:\.\d{1,2})?)',
        caseSensitive: false),
  ];

  static final _accountBalancePatterns = [
    RegExp(r'(?:a/c|acc(?:ount)?|xx+)[\s*x]*(\d{4})', caseSensitive: false),
  ];

  ParsedBalance? extract(String smsBody) {
    for (final pattern in _balancePatterns) {
      final match = pattern.firstMatch(smsBody);
      if (match != null) {
        final balanceStr = match.group(1)?.replaceAll(',', '');
        if (balanceStr != null) {
          final balance = double.tryParse(balanceStr);
          if (balance != null) {
            // Extract account number
            String? accountNumber;
            for (final accPattern in _accountBalancePatterns) {
              final accMatch = accPattern.firstMatch(smsBody);
              if (accMatch != null) {
                accountNumber = 'XXXX${accMatch.group(1)}';
                break;
              }
            }

            return ParsedBalance(
              balancePaisa: (balance * 100).round(),
              timestamp: DateTime.now(),
              accountNumber: accountNumber,
            );
          }
        }
      }
    }
    return null;
  }
}

/// SS-038: Duplicate Transaction Detection
class DuplicateDetector {
  List<ParsedTransaction> filterDuplicates(
    List<ParsedTransaction> newTransactions,
    List<ParsedTransaction> existingTransactions,
  ) {
    final unique = <ParsedTransaction>[];

    for (final newTx in newTransactions) {
      bool isDuplicate = false;

      for (final existingTx in existingTransactions) {
        if (_isDuplicate(newTx, existingTx)) {
          isDuplicate = true;
          break;
        }
      }

      // Also check within new transactions
      if (!isDuplicate) {
        for (final addedTx in unique) {
          if (_isDuplicate(newTx, addedTx)) {
            isDuplicate = true;
            break;
          }
        }
      }

      if (!isDuplicate) {
        unique.add(newTx);
      }
    }

    return unique;
  }

  bool _isDuplicate(ParsedTransaction a, ParsedTransaction b) {
    // Exact reference match is definitely duplicate
    if (a.referenceId != null && a.referenceId == b.referenceId) {
      return true;
    }

    // Same amount, type, and within 5 minutes is likely duplicate
    if (a.amountPaisa == b.amountPaisa &&
        a.isDebit == b.isDebit &&
        a.timestamp.difference(b.timestamp).abs() <
            const Duration(minutes: 5)) {
      // If same merchant or UPI ID, definitely duplicate
      if (a.merchantName != null && a.merchantName == b.merchantName) {
        return true;
      }
      if (a.upiId != null && a.upiId == b.upiId) {
        return true;
      }

      // Fuzzy match on merchant
      if (a.merchantName != null && b.merchantName != null) {
        if (_fuzzyMatch(a.merchantName!, b.merchantName!) > 0.8) {
          return true;
        }
      }
    }

    return false;
  }

  double _fuzzyMatch(String a, String b) {
    final aLower = a.toLowerCase().trim();
    final bLower = b.toLowerCase().trim();

    if (aLower == bLower) return 1.0;
    if (aLower.contains(bLower) || bLower.contains(aLower)) return 0.9;

    // Simple character overlap ratio
    final aChars = aLower.split('').toSet();
    final bChars = bLower.split('').toSet();
    final intersection = aChars.intersection(bChars).length;
    final union = aChars.union(bChars).length;

    return union > 0 ? intersection / union : 0;
  }
}

/// SS-039: Subscription/Recurring Detection
class RecurringDetector {
  List<RecurringPattern> detect(List<ParsedTransaction> transactions) {
    final patterns = <RecurringPattern>[];

    // Group by merchant
    final byMerchant = <String, List<ParsedTransaction>>{};
    for (final tx in transactions) {
      final key = tx.merchantName?.toLowerCase() ?? tx.upiId ?? 'unknown';
      byMerchant.putIfAbsent(key, () => []).add(tx);
    }

    for (final entry in byMerchant.entries) {
      final merchant = entry.key;
      final txList = entry.value;

      if (txList.length < 2) continue;

      // Sort by date
      txList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Calculate intervals
      final intervals = <int>[];
      for (int i = 1; i < txList.length; i++) {
        intervals.add(
            txList[i].timestamp.difference(txList[i - 1].timestamp).inDays);
      }

      if (intervals.isEmpty) continue;

      // Check for consistent intervals
      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final variance = intervals
              .map((i) => (i - avgInterval).abs())
              .reduce((a, b) => a + b) /
          intervals.length;

      // If variance is low, it's likely recurring
      if (variance <= 3) {
        RecurringFrequency? frequency;
        if (avgInterval >= 25 && avgInterval <= 35) {
          frequency = RecurringFrequency.monthly;
        } else if (avgInterval >= 6 && avgInterval <= 8) {
          frequency = RecurringFrequency.weekly;
        } else if (avgInterval >= 13 && avgInterval <= 16) {
          frequency = RecurringFrequency.biweekly;
        } else if (avgInterval == 1) {
          frequency = RecurringFrequency.daily;
        }

        if (frequency != null) {
          // Calculate next expected date
          final lastTx = txList.last;
          final nextExpected =
              lastTx.timestamp.add(Duration(days: avgInterval.round()));

          patterns.add(RecurringPattern(
            merchantName: merchant,
            amountPaisa: txList.last.amountPaisa,
            frequency: frequency,
            nextExpected: nextExpected,
            occurrenceCount: txList.length,
            confidence: 1 - (variance / 10).clamp(0, 0.5),
          ));
        }
      }
    }

    return patterns;
  }
}

// ====== Data Classes ======

class RawSms {
  final String sender;
  final String body;
  final DateTime timestamp;

  const RawSms({
    required this.sender,
    required this.body,
    required this.timestamp,
  });
}

class InstitutionVerifyResult {
  final bool isValidInstitution;
  final FinancialInstitution? institution;

  const InstitutionVerifyResult({
    required this.isValidInstitution,
    this.institution,
  });
}

class SpamCheckResult {
  final bool isSpam;
  final String? reason;
  final double confidence;

  const SpamCheckResult({
    required this.isSpam,
    this.reason,
    this.confidence = 0,
  });
}

class ParsedTransaction {
  final int amountPaisa;
  final bool isDebit;
  final DateTime timestamp;
  final String? referenceId;
  final String? accountNumber;
  final String? upiId;
  final String? merchantName;
  final FinancialInstitution institution;
  final double confidence;
  final String rawSmsBody;

  const ParsedTransaction({
    required this.amountPaisa,
    required this.isDebit,
    required this.timestamp,
    this.referenceId,
    this.accountNumber,
    this.upiId,
    this.merchantName,
    required this.institution,
    required this.confidence,
    required this.rawSmsBody,
  });
}

class ParsedBalance {
  final int balancePaisa;
  final DateTime timestamp;
  final String? accountNumber;

  const ParsedBalance({
    required this.balancePaisa,
    required this.timestamp,
    this.accountNumber,
  });
}

enum RecurringFrequency { daily, weekly, biweekly, monthly, yearly }

class RecurringPattern {
  final String merchantName;
  final int amountPaisa;
  final RecurringFrequency frequency;
  final DateTime nextExpected;
  final int occurrenceCount;
  final double confidence;

  const RecurringPattern({
    required this.merchantName,
    required this.amountPaisa,
    required this.frequency,
    required this.nextExpected,
    required this.occurrenceCount,
    required this.confidence,
  });
}

enum SmsParseStatus { success, ignored, spam, error }

class SmsParseResult {
  final SmsParseStatus status;
  final FinancialInstitution? institution;
  final ParsedTransaction? transaction;
  final ParsedBalance? balance;
  final String? reason;
  final double? spamConfidence;
  final String? error;
  final int processingTimeMs;

  const SmsParseResult({
    required this.status,
    this.institution,
    this.transaction,
    this.balance,
    this.reason,
    this.spamConfidence,
    this.error,
    required this.processingTimeMs,
  });

  factory SmsParseResult.success({
    required FinancialInstitution institution,
    ParsedTransaction? transaction,
    ParsedBalance? balance,
    required int processingTimeMs,
  }) =>
      SmsParseResult(
        status: SmsParseStatus.success,
        institution: institution,
        transaction: transaction,
        balance: balance,
        processingTimeMs: processingTimeMs,
      );

  factory SmsParseResult.ignored({
    required String reason,
    required int processingTimeMs,
  }) =>
      SmsParseResult(
        status: SmsParseStatus.ignored,
        reason: reason,
        processingTimeMs: processingTimeMs,
      );

  factory SmsParseResult.spam({
    required String reason,
    required double confidence,
    required int processingTimeMs,
  }) =>
      SmsParseResult(
        status: SmsParseStatus.spam,
        reason: reason,
        spamConfidence: confidence,
        processingTimeMs: processingTimeMs,
      );

  factory SmsParseResult.error({
    required String error,
    required int processingTimeMs,
  }) =>
      SmsParseResult(
        status: SmsParseStatus.error,
        error: error,
        processingTimeMs: processingTimeMs,
      );
}
