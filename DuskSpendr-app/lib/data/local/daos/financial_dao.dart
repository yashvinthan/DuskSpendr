import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';
import '../../../core/budget/balance_tracking_service.dart';
import '../../../core/budget/bill_reminder_service.dart';

part 'financial_dao.g.dart';

/// Data Access Object for balance snapshots (SS-064)
@DriftAccessor(tables: [BalanceSnapshots])
class BalanceSnapshotDao extends DatabaseAccessor<AppDatabase>
    with _$BalanceSnapshotDaoMixin {
  BalanceSnapshotDao(super.db);

  /// Get latest balance for account
  Future<BalanceSnapshot?> getLatest(String accountId) async {
    final query = select(balanceSnapshots)
      ..where((b) => b.accountId.equals(accountId))
      ..orderBy([(b) => OrderingTerm.desc(b.recordedAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row != null ? _rowToSnapshot(row) : null;
  }

  /// Get all latest balances (one per account)
  Future<List<BalanceSnapshot>> getAllLatest() async {
    // Get latest for each account using subquery
    final rows = await customSelect(
      '''
      SELECT bs.* FROM balance_snapshots bs
      INNER JOIN (
        SELECT account_id, MAX(recorded_at) as max_recorded
        FROM balance_snapshots
        GROUP BY account_id
      ) latest ON bs.account_id = latest.account_id 
        AND bs.recorded_at = latest.max_recorded
      ''',
      readsFrom: {balanceSnapshots},
    ).get();

    return rows.map((row) => BalanceSnapshot(
      id: row.read<String>('id'),
      accountId: row.read<String>('account_id'),
      balancePaisa: row.read<int>('balance_paisa'),
      source: _parseSource(row.read<int>('source')),
      recordedAt: DateTime.fromMillisecondsSinceEpoch(row.read<int>('recorded_at')),
    )).toList();
  }

  /// Get balance history for account
  Future<List<BalanceSnapshot>> getHistory(
    String accountId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    var query = select(balanceSnapshots)
      ..where((b) => b.accountId.equals(accountId))
      ..orderBy([(b) => OrderingTerm.desc(b.recordedAt)]);

    if (startDate != null) {
      query = query..where((b) => b.recordedAt.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((b) => b.recordedAt.isSmallerOrEqualValue(endDate));
    }
    if (limit != null) {
      query = query..limit(limit);
    }

    final rows = await query.get();
    return rows.map(_rowToSnapshot).toList();
  }

  /// Insert balance snapshot
  Future<void> insert(BalanceSnapshot snapshot) async {
    await into(balanceSnapshots).insert(BalanceSnapshotsCompanion.insert(
      id: snapshot.id,
      accountId: snapshot.accountId,
      balancePaisa: snapshot.balancePaisa,
      source: snapshot.source.index,
      recordedAt: snapshot.recordedAt,
    ));
  }

  /// Delete old snapshots (keep last 30 days)
  Future<int> pruneOld({int keepDays = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    return await (delete(balanceSnapshots)
          ..where((b) => b.recordedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  BalanceSnapshot _rowToSnapshot(BalanceSnapshotData row) {
    return BalanceSnapshot(
      id: row.id,
      accountId: row.accountId,
      balancePaisa: row.balancePaisa,
      source: _parseSource(row.source),
      recordedAt: row.recordedAt,
    );
  }

  BalanceSource _parseSource(int index) {
    return BalanceSource.values[index];
  }
}

/// Data Access Object for bill reminders (SS-067)
@DriftAccessor(tables: [BillReminders, BillPayments])
class BillReminderDao extends DatabaseAccessor<AppDatabase>
    with _$BillReminderDaoMixin {
  BillReminderDao(super.db);

  /// Watch all active bills
  Stream<List<BillReminder>> watchActive() {
    return (select(billReminders)
          ..where((b) => b.isActive.equals(true))
          ..orderBy([(b) => OrderingTerm.asc(b.nextDueDate)]))
        .watch()
        .asyncMap((rows) async {
      final bills = <BillReminder>[];
      for (final row in rows) {
        final payments = await _getPayments(row.id);
        bills.add(_rowToBill(row, payments));
      }
      return bills;
    });
  }

  /// Get all active bills
  Future<List<BillReminder>> getActive() async {
    final rows = await (select(billReminders)
          ..where((b) => b.isActive.equals(true))
          ..orderBy([(b) => OrderingTerm.asc(b.nextDueDate)]))
        .get();

    final bills = <BillReminder>[];
    for (final row in rows) {
      final payments = await _getPayments(row.id);
      bills.add(_rowToBill(row, payments));
    }
    return bills;
  }

  /// Get upcoming bills within days
  Future<List<BillReminder>> getUpcoming({int days = 7}) async {
    final cutoff = DateTime.now().add(Duration(days: days));
    final rows = await (select(billReminders)
          ..where((b) => b.isActive.equals(true))
          ..where((b) => b.nextDueDate.isSmallerOrEqualValue(cutoff))
          ..orderBy([(b) => OrderingTerm.asc(b.nextDueDate)]))
        .get();

    final bills = <BillReminder>[];
    for (final row in rows) {
      final payments = await _getPayments(row.id);
      bills.add(_rowToBill(row, payments));
    }
    return bills;
  }

  /// Get overdue bills
  Future<List<BillReminder>> getOverdue() async {
    final now = DateTime.now();
    final rows = await (select(billReminders)
          ..where((b) => b.isActive.equals(true))
          ..where((b) => b.nextDueDate.isSmallerThanValue(now))
          ..orderBy([(b) => OrderingTerm.asc(b.nextDueDate)]))
        .get();

    final bills = <BillReminder>[];
    for (final row in rows) {
      final payments = await _getPayments(row.id);
      bills.add(_rowToBill(row, payments));
    }
    return bills;
  }

  /// Insert bill
  Future<void> insertBill(BillReminder bill) async {
    await into(billReminders).insert(BillRemindersCompanion.insert(
      id: bill.id,
      name: bill.name,
      merchantName: Value(bill.merchantName),
      amountPaisa: bill.amountPaisa,
      frequency: _frequencyToDb(bill.frequency),
      billType: bill.billType.name,
      nextDueDate: bill.nextDueDate,
      reminderDaysBefore: bill.reminderDaysBefore,
      linkedAccountId: Value(bill.linkedAccountId),
      isAutoDetected: bill.isAutoDetected,
      isActive: bill.isActive,
      notes: Value(bill.notes),
      createdAt: bill.createdAt,
    ));
  }

  /// Update bill
  Future<void> updateBill(BillReminder bill) async {
    await (update(billReminders)..where((b) => b.id.equals(bill.id))).write(
      BillRemindersCompanion(
        name: Value(bill.name),
        amountPaisa: Value(bill.amountPaisa),
        frequency: Value(_frequencyToDb(bill.frequency)),
        nextDueDate: Value(bill.nextDueDate),
        reminderDaysBefore: Value(bill.reminderDaysBefore),
        isActive: Value(bill.isActive),
        notes: Value(bill.notes),
      ),
    );
  }

  /// Update next due date
  Future<void> updateNextDue(String id, DateTime nextDue) async {
    await (update(billReminders)..where((b) => b.id.equals(id))).write(
      BillRemindersCompanion(nextDueDate: Value(nextDue)),
    );
  }

  /// Delete bill
  Future<void> deleteBill(String id) async {
    await (delete(billReminders)..where((b) => b.id.equals(id))).go();
    await (delete(billPayments)..where((p) => p.billId.equals(id))).go();
  }

  /// Record payment
  Future<void> recordPayment(BillPayment payment) async {
    await into(billPayments).insert(BillPaymentsCompanion.insert(
      id: payment.id,
      billId: payment.billId,
      amountPaisa: payment.amountPaisa,
      paidAt: payment.paidAt,
      transactionId: Value(payment.transactionId),
      isAutoLinked: payment.isAutoLinked,
    ));
  }

  Future<List<BillPayment>> _getPayments(String billId) async {
    final rows = await (select(billPayments)
          ..where((p) => p.billId.equals(billId))
          ..orderBy([(p) => OrderingTerm.desc(p.paidAt)])
          ..limit(10))
        .get();
    return rows.map(_rowToPayment).toList();
  }

  BillReminder _rowToBill(BillReminderData row, List<BillPayment> payments) {
    return BillReminder(
      id: row.id,
      name: row.name,
      merchantName: row.merchantName,
      amountPaisa: row.amountPaisa,
      frequency: _dbToFrequency(row.frequency),
      billType: BillType.values.firstWhere(
        (t) => t.name == row.billType,
        orElse: () => BillType.other,
      ),
      nextDueDate: row.nextDueDate,
      reminderDaysBefore: row.reminderDaysBefore,
      isAutoDetected: row.isAutoDetected,
      isActive: row.isActive,
      linkedAccountId: row.linkedAccountId,
      notes: row.notes,
      paymentHistory: payments,
      createdAt: row.createdAt,
    );
  }

  BillPayment _rowToPayment(BillPaymentData row) {
    return BillPayment(
      id: row.id,
      billId: row.billId,
      amountPaisa: row.amountPaisa,
      paidAt: row.paidAt,
      transactionId: row.transactionId,
      isAutoLinked: row.isAutoLinked,
    );
  }

  BillFrequencyDb _frequencyToDb(BillFrequency freq) {
    switch (freq) {
      case BillFrequency.weekly: return BillFrequencyDb.weekly;
      case BillFrequency.biweekly: return BillFrequencyDb.biweekly;
      case BillFrequency.monthly: return BillFrequencyDb.monthly;
      case BillFrequency.quarterly: return BillFrequencyDb.quarterly;
      case BillFrequency.yearly: return BillFrequencyDb.yearly;
    }
  }

  BillFrequency _dbToFrequency(BillFrequencyDb db) {
    switch (db) {
      case BillFrequencyDb.weekly: return BillFrequency.weekly;
      case BillFrequencyDb.biweekly: return BillFrequency.biweekly;
      case BillFrequencyDb.monthly: return BillFrequency.monthly;
      case BillFrequencyDb.quarterly: return BillFrequency.quarterly;
      case BillFrequencyDb.yearly: return BillFrequency.yearly;
    }
  }
}

/// Data class for balance snapshot
class BalanceSnapshot {
  final String id;
  final String accountId;
  final int balancePaisa;
  final BalanceSource source;
  final DateTime recordedAt;

  const BalanceSnapshot({
    required this.id,
    required this.accountId,
    required this.balancePaisa,
    required this.source,
    required this.recordedAt,
  });
}
