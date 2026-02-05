# SS-002: Encrypted Local Database with Drift

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-002 |
| **Epic** | Core Infrastructure |
| **Type** | Feature |
| **Priority** | P0 - Critical |
| **Story Points** | 8 |
| **Sprint** | Sprint 1 |
| **Assignee** | TBD |
| **Labels** | `database`, `security`, `encryption`, `drift` |

---

## User Story

**As a** DuskSpendr user  
**I want** my financial data stored securely on my device  
**So that** my sensitive transaction and account information is protected even if my device is compromised

---

## Description

Implement an encrypted SQLite database using Drift (formerly Moor) with SQLCipher encryption (Drift). The database will store all local user data including transactions, accounts, budgets, and settings. Encryption keys will be securely stored using Flutter Secure Storage backed by Flutter Secure Storage / iOS Keychain.

---

## Acceptance Criteria

### AC1: Database Encryption
```gherkin
Given the app is installed on a device
When the database is created
Then it should be encrypted with AES-256 via SQLCipher
And the database file should not be readable without the encryption key
```

### AC2: Secure Key Storage
```gherkin
Given the database encryption key
When the key is stored
Then it should use Flutter Secure Storage
And be backed by Flutter Secure Storage (Android) or Keychain (iOS)
And the key should not be accessible to other apps
```

### AC3: Database Initialization
```gherkin
Given a user opens the app for the first time
When the app initializes
Then the database should be created with all required tables
And migrations should be applied if upgrading from older versions
```

### AC4: Database Operations
```gherkin
Given the encrypted database is initialized
When I perform CRUD operations
Then all operations should complete within 50ms for single records
And batch operations should complete within 500ms for 1000 records
```

### AC5: Data Integrity
```gherkin
Given transactions are stored in the database
When the app crashes or is force-closed
Then no data should be corrupted
And all committed transactions should be preserved
```

---

## Technical Requirements

### Database Schema (Drift)

```dart
// lib/data/datasources/local/database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

part 'database.g.dart';

// Tables
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get externalId => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get merchantName => text()();
  TextColumn get description => text().nullable()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  IntColumn get accountId => integer().references(Accounts, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get source => text()(); // 'bank', 'upi', 'sms', 'manual'
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'bank', 'upi', 'wallet', 'cash', 'bnpl'
  TextColumn get institution => text().nullable()();
  TextColumn get accountNumber => text().nullable()(); // Last 4 digits only
  RealColumn get balance => real().withDefault(const Constant(0))();
  BoolColumn get isLinked => boolean().withDefault(const Constant(false))();
  TextColumn get iconName => text().nullable()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iconName => text()();
  IntColumn get color => integer()();
  IntColumn get parentId => integer().nullable().references(Categories, #id)();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
}

class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get period => text()(); // 'weekly', 'monthly', 'custom'
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [Transactions, Accounts, Categories, Budgets])
class DuskSpendrDatabase extends _$DuskSpendrDatabase {
  DuskSpendrDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedCategories();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle migrations
    },
  );

  Future<void> _seedCategories() async {
    // Insert default categories
    await batch((batch) {
      batch.insertAll(categories, [
        CategoriesCompanion.insert(
          name: 'Food & Dining',
          iconName: 'restaurant',
          color: 0xFFFF6B6B,
          isSystem: const Value(true),
        ),
        CategoriesCompanion.insert(
          name: 'Transport',
          iconName: 'directions_car',
          color: 0xFF4ECDC4,
          isSystem: const Value(true),
        ),
        // ... more categories
      ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'DuskSpendr.db'));
    
    // Get encryption key from secure storage
    final key = await _getOrCreateEncryptionKey();
    
    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        // Enable SQLCipher encryption (Drift)
        db.execute("PRAGMA key = '$key'");
        db.execute('PRAGMA cipher_compatibility = 4');
      },
    );
  });
}

Future<String> _getOrCreateEncryptionKey() async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  
  var key = await storage.read(key: 'db_encryption_key');
  if (key == null) {
    key = _generateSecureKey();
    await storage.write(key: 'db_encryption_key', value: key);
  }
  return key;
}
```

### Dependencies to Add

```yaml
dependencies:
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.18
  sqlcipher_flutter_libs: ^0.6.0
  flutter_secure_storage: ^9.0.0
  path_provider: ^2.1.0
  path: ^1.8.0

dev_dependencies:
  drift_dev: ^2.14.0
```

---

## Definition of Done

- [ ] Drift database configured with SQLCipher encryption (Drift)
- [ ] All tables created (Transactions, Accounts, Categories, Budgets)
- [ ] Encryption key securely stored in Keystore/Keychain
- [ ] Default categories seeded on first launch
- [ ] Database migrations framework in place
- [ ] Unit tests for all CRUD operations
- [ ] Performance benchmarks pass (<50ms single, <500ms batch)
- [ ] Database file verified encrypted (not readable with sqlite3 CLI)
- [ ] Code reviewed and approved
- [ ] Documentation updated

---

## Test Cases

### Unit Tests

```dart
void main() {
  late DuskSpendrDatabase database;

  setUp(() async {
    database = DuskSpendrDatabase.forTesting();
  });

  tearDown(() async {
    await database.close();
  });

  group('Transactions', () {
    test('insert and retrieve transaction', () async {
      final transaction = TransactionsCompanion.insert(
        amount: -250.0,
        merchantName: 'Swiggy',
        accountId: 1,
        date: DateTime.now(),
        source: 'upi',
      );
      
      final id = await database.into(database.transactions).insert(transaction);
      final retrieved = await (database.select(database.transactions)
        ..where((t) => t.id.equals(id))).getSingle();
      
      expect(retrieved.merchantName, 'Swiggy');
      expect(retrieved.amount, -250.0);
    });

    test('batch insert 1000 transactions under 500ms', () async {
      final stopwatch = Stopwatch()..start();
      
      await database.batch((batch) {
        for (var i = 0; i < 1000; i++) {
          batch.insert(database.transactions, TransactionsCompanion.insert(
            amount: -100.0,
            merchantName: 'Test $i',
            accountId: 1,
            date: DateTime.now(),
            source: 'manual',
          ));
        }
      });
      
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}
```

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-001 | Blocks | Project setup required first |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-003 | Core Data Models |
| SS-030 | Transaction Sync |
| SS-050 | Budget Tracking |

---

## Security Considerations

1. **Key Derivation**: Use strong random key generation
2. **Key Storage**: Flutter Secure Storage / iOS Keychain only
3. **No Plaintext**: Never log or expose encryption key
4. **Audit**: Log database access attempts (without sensitive data)

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Drift setup and configuration | 2 |
| SQLCipher integration | 3 |
| Secure key storage | 2 |
| Table definitions | 2 |
| Seed data and migrations | 1 |
| Unit tests | 2 |
| Performance testing | 1 |
| Documentation | 1 |
| **Total** | **14 hours** |

---

*Created: 2026-02-04 | Last Updated: 2026-02-04*
