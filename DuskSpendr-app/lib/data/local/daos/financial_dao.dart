import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';
// Removed unused import: balance_tracking_service.dart
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
      ..orderBy([(b) => OrderingTerm.desc(b.timestamp)])
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
        SELECT account_id, MAX(timestamp) as max_timestamp
        FROM balance_snapshots
        GROUP BY account_id
      ) latest ON bs.account_id = latest.account_id 
        AND bs.timestamp = latest.max_timestamp
      ''',
      readsFrom: {balanceSnapshots},
    ).get();

    return rows.map((row) => BalanceSnapshot(
      id: row.read<String>('id'),
      accountId: row.read<String>('account_id'),
      balancePaisa: row.read<int>('balance_paisa'),
      timestamp: row.read<DateTime>('timestamp'),
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
      ..orderBy([(b) => OrderingTerm.desc(b.timestamp)]);

    if (startDate != null) {
      query = query..where((b) => b.timestamp.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((b) => b.timestamp.isSmallerOrEqualValue(endDate));
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
      timestamp: snapshot.timestamp,
    ));
  }

  /// Delete old snapshots (keep last 30 days)
  Future<int> pruneOld({int keepDays = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    return await (delete(balanceSnapshots)
          ..where((b) => b.timestamp.isSmallerThanValue(cutoff)))
        .go();
  }

  BalanceSnapshot _rowToSnapshot(BalanceSnapshotRow row) {
    return BalanceSnapshot(
      id: row.id,
      accountId: row.accountId,
      balancePaisa: row.balancePaisa,
      timestamp: row.timestamp,
    );
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
      nextDueDate: bill.nextDueDate,
      reminderDaysBefore: Value(bill.reminderDaysBefore),
      linkedAccountId: Value(bill.linkedAccountId),
      isAutoDetected: Value(bill.isAutoDetected),
      isActive: Value(bill.isActive),
      notes: Value(bill.notes),
      createdAt: bill.createdAt,
      updatedAt: bill.createdAt,
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
        updatedAt: Value(DateTime.now()),
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
      isAutoLinked: Value(payment.isAutoLinked),
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

  BillReminder _rowToBill(BillReminderRow row, List<BillPayment> payments) {
    return BillReminder(
      id: row.id,
      name: row.name,
      merchantName: row.merchantName,
      amountPaisa: row.amountPaisa,
      frequency: _dbToFrequency(row.frequency),
      billType: _inferBillType(row.merchantName, row.name),
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

  BillPayment _rowToPayment(BillPaymentRow row) {
    return BillPayment(
      id: row.id,
      billId: row.billId,
      amountPaisa: row.amountPaisa,
      paidAt: row.paidAt,
      transactionId: row.transactionId,
      isAutoLinked: row.isAutoLinked,
    );
  }

  BillType _inferBillType(String? merchantName, String billName) {
    final nameLower = (merchantName ?? billName).toLowerCase();

    if (_matchesAny(nameLower, ['airtel', 'jio', 'vodafone', 'vi', 'bsnl', 'mtnl'])) {
      return BillType.phoneRecharge;
    }
    if (_matchesAny(nameLower, ['bescom', 'mseb', 'tneb', 'pgvcl', 'electricity', 'power', 'vidyut'])) {
      return BillType.electricity;
    }
    if (_matchesAny(nameLower, ['actfibernet', 'act ', 'hathway', 'tikona', 'broadband', 'fiber'])) {
      return BillType.internet;
    }
    if (_matchesAny(nameLower, ['netflix', 'hotstar', 'prime', 'spotify', 'youtube', 'apple', 'google play', 'disney'])) {
      return BillType.subscription;
    }
    if (_matchesAny(nameLower, ['hdfc card', 'icici card', 'axis card', 'sbi card', 'amex', 'credit card'])) {
      return BillType.creditCard;
    }
    if (_matchesAny(nameLower, ['emi', 'loan', 'bajaj finserv', 'home credit', 'tata capital'])) {
      return BillType.loanEmi;
    }
    if (_matchesAny(nameLower, ['rent', 'landlord', 'housing', 'pg ', 'hostel'])) {
      return BillType.rent;
    }
    if (_matchesAny(nameLower, ['lic', 'insurance', 'hdfc life', 'max life', 'icici pru'])) {
      return BillType.insurance;
    }

    return BillType.other;
  }

  bool _matchesAny(String text, List<String> patterns) {
    return patterns.any((p) => text.contains(p));
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
  final DateTime timestamp;

  const BalanceSnapshot({
    required this.id,
    required this.accountId,
    required this.balancePaisa,
    required this.timestamp,
  });
}
