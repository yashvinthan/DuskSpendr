# SS-030: Privacy-First SMS Transaction Parsing

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-030 |
| **Epic** | Data Sync & SMS Parsing |
| **Type** | Feature |
| **Priority** | P0 - Critical |
| **Story Points** | 13 |
| **Sprint** | Sprint 3 |
| **Assignee** | TBD |
| **Labels** | `sms`, `privacy`, `on-device`, `parsing`, `android` |

---

## User Story

**As a** DuskSpendr user  
**I want** my transaction SMS automatically parsed on-device  
**So that** I can track expenses without manual entry, with 100% privacy

---

## Description

Implement an on-device SMS parser that detects financial transaction messages, extracts transaction data (amount, merchant, account), and creates transaction records. All processing happens locally - no SMS content is ever sent to servers, ensuring complete privacy compliance.

---

## Acceptance Criteria

### AC1: Permission Request
```gherkin
Given a user opens DuskSpendr for the first time
When they reach the SMS permission step
Then show clear explanation:
  - "100% on-device processing"
  - "No SMS content leaves your phone"
  - "We only extract transaction details"
And provide "Skip for now" option
And respect user's choice permanently until changed in settings
```

### AC2: Transaction Detection
```gherkin
Given SMS permission is granted
When a transaction SMS arrives from known senders:
  | Sender Pattern | Institution |
  | XX-SBIBNK, XX-SBIATM | SBI |
  | XX-HDFCBK | HDFC |
  | XX-ICICIB | ICICI |
  | XX-AXISBK | Axis |
  | XX-PYTM | Paytm |
  | XX-GPAY | Google Pay |
Then extract:
  - Amount (with currency symbol handling)
  - Type (debit/credit)
  - Merchant/Payee name
  - Account (last 4 digits only)
  - Transaction date/time
  - Reference number (if available)
And create transaction record within 100ms
```

### AC3: Privacy Guarantee
```gherkin
Given SMS parsing is enabled
Then the following MUST be true:
  - Network monitor shows ZERO SMS content sent to any server
  - Original SMS text is NEVER persisted
  - Only structured transaction data is stored
  - Regex patterns run entirely on-device
  - No third-party analytics on SMS content
And this is verified via automated tests
```

### AC4: Supported SMS Formats

| Source | Sample SMS | Expected Extraction |
|--------|------------|---------------------|
| SBI | "Rs.500.00 debited from A/c XX1234 on 04-02-26 to VPA merchant@ybl" | ₹500, Debit, merchant, 1234 |
| HDFC | "INR 1,200.50 spent on HDFC CC ending 5678 at AMAZON on 04-02-26" | ₹1200.50, Debit, Amazon, 5678 |
| GPay | "Sent ₹500 to Rahul via UPI (ref: 402615234567)" | ₹500, Debit, Rahul, ref |
| Paytm | "Paid Rs.150 to Zomato from Paytm Wallet" | ₹150, Debit, Zomato, Wallet |
| Credit | "Rs.5000 credited to your A/c XX9876" | ₹5000, Credit, -, 9876 |

### AC5: Duplicate Detection
```gherkin
Given a transaction SMS is parsed
When checking for duplicates
Then compare:
  - Amount (exact match)
  - Date (within 5 minutes)
  - Account (last 4 digits)
  - Source (same sender)
And skip if duplicate found
And log duplicate detection for debugging
```

### AC6: Background Processing (Android)
```gherkin
Given the app is in background or closed
When a transaction SMS arrives
Then the SMS parser should:
  - Process via SMS broadcast receiver
  - Create transaction record
  - Update local database
  - Trigger optional notification
And battery impact should be minimal (<1%)
```

---

## Technical Requirements

### Flutter/Dart Implementation

```dart
// lib/features/sms/domain/parsers/transaction_sms_parser.dart
class TransactionSmsParser {
  static final _amountPatterns = [
    RegExp(r'(?:Rs\.?|INR|₹)\s*([\d,]+(?:\.\d{2})?)'),
    RegExp(r'([\d,]+(?:\.\d{2})?)\s*(?:Rs\.?|INR|₹)'),
  ];
  
  static final _accountPattern = RegExp(r'(?:A/c|AC|account|XX)[\s:]*(\d{4})', caseSensitive: false);
  static final _debitKeywords = ['debited', 'spent', 'paid', 'sent', 'withdrawn', 'debit'];
  static final _creditKeywords = ['credited', 'received', 'deposited', 'credit', 'refund'];
  
  static final _financialSenders = {
    'SBIBNK', 'SBIATM', 'SBIUPI',
    'HDFCBK', 'HDFCCC',
    'ICICIB', 'ICICIT',
    'AXISBK', 'AXISCC',
    'KOTAKB',
    'PYTM', 'PAYTMB',
    'GPAY', 'GOOGLEPAY',
    'PHONEPE', 'PHPE',
  };

  ParsedTransaction? parse(SmsMessage sms) {
    // 1. Validate sender
    if (!_isFinancialSender(sms.sender)) return null;
    
    final body = sms.body.toLowerCase();
    
    // 2. Extract amount
    final amount = _extractAmount(sms.body);
    if (amount == null || amount <= 0) return null;
    
    // 3. Determine transaction type
    final isDebit = _debitKeywords.any((k) => body.contains(k));
    final isCredit = _creditKeywords.any((k) => body.contains(k));
    if (!isDebit && !isCredit) return null;
    
    // 4. Extract account (last 4 digits)
    final account = _extractAccount(sms.body);
    
    // 5. Extract merchant/payee
    final merchant = _extractMerchant(sms.body);
    
    return ParsedTransaction(
      amount: isDebit ? -amount : amount,
      merchantName: merchant ?? 'Unknown',
      accountLastFour: account,
      date: sms.date,
      source: TransactionSource.sms,
      rawSenderCode: sms.sender,
    );
  }
  
  bool _isFinancialSender(String sender) {
    final normalized = sender.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    return _financialSenders.any((s) => normalized.contains(s));
  }
  
  double? _extractAmount(String text) {
    for (final pattern in _amountPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final amountStr = match.group(1)!.replaceAll(',', '');
        return double.tryParse(amountStr);
      }
    }
    return null;
  }
  
  String? _extractAccount(String text) {
    final match = _accountPattern.firstMatch(text);
    return match?.group(1);
  }
  
  String? _extractMerchant(String text) {
    // Extract merchant using common patterns
    final patterns = [
      RegExp(r'(?:to|at|from|@)\s+([A-Za-z0-9\s]+?)(?:\s+on|\s+via|$)', caseSensitive: false),
      RegExp(r'VPA\s+([a-z0-9]+)@', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return _cleanMerchantName(match.group(1)!);
      }
    }
    return null;
  }
  
  String _cleanMerchantName(String raw) {
    return raw.trim()
      .replaceAll(RegExp(r'\s+'), ' ')
      .split(' ')
      .take(3)
      .join(' ');
  }
}
```

### Android SMS Receiver

```kotlin
// android/app/src/main/kotlin/.../SmsReceiver.kt
class TransactionSmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        for (sms in messages) {
            // Send to Flutter via method channel
            FlutterSmsHandler.processIncoming(
                sender = sms.originatingAddress ?: "",
                body = sms.messageBody,
                timestamp = sms.timestampMillis
            )
        }
    }
}
```

### Local Storage (Drift)

```dart
// Store parsed transaction, NEVER raw SMS
class ParsedTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get merchantName => text()();
  TextColumn get accountLastFour => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get source => text()(); // Always 'sms'
  TextColumn get senderCode => text()(); // XX-SBIBNK, for debugging
  // NOTE: NO raw SMS body column!
}
```

---

## Definition of Done

- [ ] SMS permission request with privacy explanation
- [ ] Parser supports 15+ banks/UPI/wallet senders
- [ ] >95% extraction accuracy on 100+ sample SMS
- [ ] Background processing via Android BroadcastReceiver
- [ ] Duplicate detection logic
- [ ] Zero network calls verified (automated test)
- [ ] Unit tests with 100+ SMS samples
- [ ] Integration tests
- [ ] Performance: <100ms per SMS
- [ ] Battery impact: <1% daily
- [ ] Code reviewed and security audited
- [ ] Documentation updated

---

## Test Cases

### Unit Tests

```dart
void main() {
  final parser = TransactionSmsParser();
  
  group('Amount Extraction', () {
    test('extracts Rs. format', () {
      final result = parser.parse(SmsMessage(
        sender: 'XX-SBIBNK',
        body: 'Rs.500.00 debited from A/c XX1234',
        date: DateTime.now(),
      ));
      expect(result?.amount, -500.0);
    });
    
    test('extracts INR with comma', () {
      final result = parser.parse(SmsMessage(
        sender: 'XX-HDFCBK',
        body: 'INR 1,234.56 spent on HDFC CC',
        date: DateTime.now(),
      ));
      expect(result?.amount, -1234.56);
    });
  });
  
  group('Privacy Verification', () {
    test('parsed transaction has no raw SMS content', () {
      final result = parser.parse(testSms);
      // Ensure no raw body field exists
      expect(result, isNot(hasProperty('rawBody')));
    });
  });
}
```

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-001 | Blocks | Project setup required |
| SS-002 | Blocks | Database for storing transactions |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-040 | AI categorization (uses parsed data) |
| SS-050 | Budget tracking (uses transaction data) |

---

## Security Considerations

1. **No SMS Storage**: Raw SMS content never persisted
2. **On-Device Only**: All regex processing is local
3. **No Third-Party SDKs**: No analytics on SMS content
4. **Minimal Data**: Only transaction-relevant fields extracted
5. **Audit Trail**: Log parser invocations, not content
6. **Permission Transparency**: Clear disclosure to users

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| SMS parser implementation | 6 |
| Amount/merchant extraction | 4 |
| Android broadcast receiver | 4 |
| Duplicate detection | 2 |
| Privacy verification tests | 3 |
| Unit tests (100+ samples) | 4 |
| Integration tests | 2 |
| Documentation | 1 |
| **Total** | **26 hours** |

---

## Related Links

- [Android SMS Permissions](https://developer.android.com/guide/topics/permissions)
- [Flutter Method Channels](https://docs.flutter.dev/platform-integration/platform-channels)

---

*Created: 2026-02-04 | Last Updated: 2026-02-05*
