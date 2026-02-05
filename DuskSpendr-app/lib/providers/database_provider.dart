import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/database.dart';

/// Global database provider
/// Lazily initializes database on first access
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  // Dispose database when provider is disposed
  ref.onDispose(() {
    database.close();
  });

  return database;
});

/// Transaction DAO provider
final transactionDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).transactionDao;
});

/// Account DAO provider
final accountDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).accountDao;
});

/// Budget DAO provider
final budgetDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).budgetDao;
});

/// Audit log DAO provider
final auditLogDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).auditLogDao;
});

/// Privacy report DAO provider
final privacyReportDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).privacyReportDao;
});

/// Backup metadata DAO provider
final backupMetadataDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).backupMetadataDao;
});

/// Sync outbox DAO provider
final syncOutboxDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).syncOutboxDao;
});

// ====== Spec 5: Financial DAOs ======

/// Balance snapshot DAO provider
final balanceSnapshotDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).balanceSnapshotDao;
});

/// Bill reminder DAO provider
final billReminderDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).billReminderDao;
});

/// Loan DAO provider
final loanDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).loanDao;
});

/// Investment DAO provider
final investmentDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).investmentDao;
});

// ====== Spec 7 & 8: Education & Shared Expense DAOs ======

/// Friend DAO provider
final friendDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).friendDao;
});

/// Shared expense DAO provider
final sharedExpenseDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).sharedExpenseDao;
});

/// Settlement DAO provider
final settlementDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).settlementDao;
});

/// Education DAO provider
final educationDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).educationDao;
});

/// Database stats provider (for debugging/settings)
final databaseStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.getDatabaseStats();
});
