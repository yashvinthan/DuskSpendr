import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';
import 'daos/transaction_dao.dart';
import 'daos/account_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/audit_log_dao.dart';
import 'daos/privacy_report_dao.dart';
import 'daos/backup_metadata_dao.dart';
import 'daos/sync_outbox_dao.dart';
import 'daos/financial_dao.dart';
import 'daos/loan_investment_dao.dart';
import 'daos/shared_expense_dao.dart';
import 'daos/education_dao.dart';

part 'database.g.dart';

/// Main application database with SQLCipher encryption
@DriftDatabase(
  tables: [
    Transactions,
    LinkedAccounts,
    Budgets,
    CustomCategories,
    MerchantMappings,
    RecurringPatterns,
    AuditLogs,
    PrivacyReports,
    BackupMetadata,
    SyncOutbox,
    // Spec 5: Financial tracking tables
    BalanceSnapshots,
    BillReminders,
    BillPayments,
    Loans,
    LoanPayments,
    CreditCards,
    Investments,
    InvestmentTransactions,
    // Spec 7 & 8: Shared expenses & Education
    Friends,
    ExpenseGroups,
    SharedExpenses,
    Settlements,
    CompletedLessons,
    ShownTips,
    CreditScores,
  ],
  daos: [
    TransactionDao,
    AccountDao,
    BudgetDao,
    AuditLogDao,
    PrivacyReportDao,
    BackupMetadataDao,
    SyncOutboxDao,
    // Spec 5: Financial DAOs
    BalanceSnapshotDao,
    BillReminderDao,
    LoanDao,
    InvestmentDao,
    // Spec 7 & 8: Shared expenses & Education DAOs
    FriendDao,
    SharedExpenseDao,
    SettlementDao,
    EducationDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing with in-memory database
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations
        if (from < 2) {
          await m.createTable(auditLogs);
          await m.createTable(privacyReports);
          await m.createTable(backupMetadata);
        }
        if (from < 3) {
          // Spec 5: Financial tracking tables
          await m.createTable(balanceSnapshots);
          await m.createTable(billReminders);
          await m.createTable(billPayments);
          await m.createTable(loans);
          await m.createTable(loanPayments);
          await m.createTable(creditCards);
          await m.createTable(investments);
          await m.createTable(investmentTransactions);
        }
        if (from < 4) {
          await m.createTable(syncOutbox);
        }
        if (from < 5) {
          // Spec 7 & 8: Shared expenses & Education tables
          await m.createTable(friends);
          await m.createTable(expenseGroups);
          await m.createTable(sharedExpenses);
          await m.createTable(settlements);
          await m.createTable(completedLessons);
          await m.createTable(shownTips);
          await m.createTable(creditScores);
        }
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Clear all data (for logout/reset)
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(transactions).go();
      await delete(linkedAccounts).go();
      await delete(budgets).go();
      await delete(customCategories).go();
      await delete(merchantMappings).go();
      await delete(recurringPatterns).go();
      await delete(auditLogs).go();
      await delete(privacyReports).go();
      await delete(backupMetadata).go();
      await delete(syncOutbox).go();
      // Spec 5: Financial tracking tables
      await delete(balanceSnapshots).go();
      await delete(billPayments).go();
      await delete(billReminders).go();
      await delete(loanPayments).go();
      await delete(loans).go();
      await delete(creditCards).go();
      await delete(investmentTransactions).go();
      await delete(investments).go();
    });
  }

  /// Export database stats
  Future<Map<String, int>> getDatabaseStats() async {
    final txCount =
        await (selectOnly(transactions)..addColumns([transactions.id.count()]))
            .map((row) => row.read(transactions.id.count()))
            .getSingle();
    final accountCount =
        await (selectOnly(linkedAccounts)
              ..addColumns([linkedAccounts.id.count()]))
            .map((row) => row.read(linkedAccounts.id.count()))
            .getSingle();
    final budgetCount =
        await (selectOnly(budgets)..addColumns([budgets.id.count()]))
            .map((row) => row.read(budgets.id.count()))
            .getSingle();
    final auditCount =
        await (selectOnly(auditLogs)..addColumns([auditLogs.id.count()]))
            .map((row) => row.read(auditLogs.id.count()))
            .getSingle();
    final backupCount =
        await (selectOnly(backupMetadata)
              ..addColumns([backupMetadata.id.count()]))
            .map((row) => row.read(backupMetadata.id.count()))
            .getSingle();
    final outboxCount =
        await (selectOnly(syncOutbox)
              ..addColumns([syncOutbox.transactionId.count()]))
            .map((row) => row.read(syncOutbox.transactionId.count()))
            .getSingle();

    return {
      'transactions': txCount ?? 0,
      'accounts': accountCount ?? 0,
      'budgets': budgetCount ?? 0,
      'auditLogs': auditCount ?? 0,
      'backups': backupCount ?? 0,
      'syncOutbox': outboxCount ?? 0,
    };
  }
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'duskspendr.db'));
    final keyHex = await _loadOrCreateDbKeyHex();

    return NativeDatabase.createInBackground(
      file,
      logStatements: kDebugMode,
      setup: (db) {
        db.execute("PRAGMA key = \"x'$keyHex'\"");
      },
    );
  });
}

Future<String> _loadOrCreateDbKeyHex() async {
  const storage = FlutterSecureStorage();
  const keyName = 'db_encryption_key_v1';

  var base64Key = await storage.read(key: keyName);
  if (base64Key == null) {
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    base64Key = base64UrlEncode(bytes);
    await storage.write(key: keyName, value: base64Key);
  }

  final keyBytes = base64Url.decode(base64Key);
  final buffer = StringBuffer();
  for (final b in keyBytes) {
    buffer.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}
