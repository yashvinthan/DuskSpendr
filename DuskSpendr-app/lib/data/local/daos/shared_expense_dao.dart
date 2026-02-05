import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/entities.dart';
import '../database.dart';
import '../tables.dart';

part 'shared_expense_dao.g.dart';

/// SS-100-104: DAOs for shared expenses, friends, and settlements

@DriftAccessor(tables: [Friends])
class FriendDao extends DatabaseAccessor<AppDatabase> with _$FriendDaoMixin {
  FriendDao(super.db);

  /// Watch all friends
  Stream<List<Friend>> watchAll() {
    return (select(friends)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((rows) => rows.map(_toFriend).toList());
  }

  /// Get all friends
  Future<List<Friend>> getAll() async {
    final rows = await (select(friends)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
    return rows.map(_toFriend).toList();
  }

  /// Get friend by ID
  Future<Friend?> getById(String id) async {
    final row = await (select(friends)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _toFriend(row) : null;
  }

  /// Get friends with non-zero balance
  Stream<List<Friend>> watchWithBalance() {
    return (select(friends)
          ..where((t) => t.totalOwedPaisa.isBiggerThanValue(0) | t.totalOwingPaisa.isBiggerThanValue(0))
          ..orderBy([(t) => OrderingTerm.desc(t.lastActivityAt)]))
        .watch()
        .map((rows) => rows.map(_toFriend).toList());
  }

  /// Insert friend
  Future<void> insertFriend(Friend friend) async {
    await into(friends).insert(_toRow(friend));
  }

  /// Update friend
  Future<void> updateFriend(Friend friend) async {
    await (update(friends)..where((t) => t.id.equals(friend.id))).write(_toRow(friend));
  }

  /// Update friend balance
  Future<void> updateBalance(String id, {int? owedDelta, int? owingDelta}) async {
    final current = await getById(id);
    if (current == null) return;

    await (update(friends)..where((t) => t.id.equals(id))).write(
      FriendsCompanion(
        totalOwedPaisa: Value(current.totalOwed.paisa + (owedDelta ?? 0)),
        totalOwingPaisa: Value(current.totalOwing.paisa + (owingDelta ?? 0)),
        lastActivityAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete friend
  Future<void> deleteFriend(String id) async {
    await (delete(friends)..where((t) => t.id.equals(id))).go();
  }

  /// Search friends by name
  Future<List<Friend>> search(String query) async {
    final rows = await (select(friends)
          ..where((t) => t.name.lower().contains(query.toLowerCase())))
        .get();
    return rows.map(_toFriend).toList();
  }

  Friend _toFriend(FriendRow row) {
    return Friend(
      id: row.id,
      name: row.name,
      phone: row.phone,
      email: row.email,
      avatarUrl: row.avatarUrl,
      totalOwed: Money.fromPaisa(row.totalOwedPaisa),
      totalOwing: Money.fromPaisa(row.totalOwingPaisa),
      lastActivityAt: row.lastActivityAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  FriendsCompanion _toRow(Friend friend) {
    return FriendsCompanion(
      id: Value(friend.id),
      name: Value(friend.name),
      phone: Value(friend.phone),
      email: Value(friend.email),
      avatarUrl: Value(friend.avatarUrl),
      totalOwedPaisa: Value(friend.totalOwed.paisa),
      totalOwingPaisa: Value(friend.totalOwing.paisa),
      lastActivityAt: Value(friend.lastActivityAt),
      createdAt: Value(friend.createdAt),
      updatedAt: Value(friend.updatedAt),
    );
  }
}

@DriftAccessor(tables: [SharedExpenses, ExpenseGroups])
class SharedExpenseDao extends DatabaseAccessor<AppDatabase> with _$SharedExpenseDaoMixin {
  SharedExpenseDao(super.db);

  /// Watch all shared expenses
  Stream<List<SharedExpense>> watchAll() {
    return (select(sharedExpenses)..orderBy([(t) => OrderingTerm.desc(t.expenseDate)]))
        .watch()
        .map((rows) => rows.map(_toSharedExpense).toList());
  }

  /// Watch pending shared expenses
  Stream<List<SharedExpense>> watchPending() {
    return (select(sharedExpenses)
          ..where((t) => t.status.equalsValue(SettlementStatusDb.pending) | 
                         t.status.equalsValue(SettlementStatusDb.partial))
          ..orderBy([(t) => OrderingTerm.desc(t.expenseDate)]))
        .watch()
        .map((rows) => rows.map(_toSharedExpense).toList());
  }

  /// Get shared expense by ID
  Future<SharedExpense?> getById(String id) async {
    final row = await (select(sharedExpenses)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _toSharedExpense(row) : null;
  }

  /// Get expenses for a friend
  Stream<List<SharedExpense>> watchForFriend(String friendId) {
    return select(sharedExpenses).watch().map((rows) {
      return rows.where((row) {
        final participants = _parseParticipants(row.participantsJson);
        return participants.any((p) => p.id == friendId) || row.paidById == friendId;
      }).map(_toSharedExpense).toList();
    });
  }

  /// Get expenses for a group
  Stream<List<SharedExpense>> watchForGroup(String groupId) {
    return (select(sharedExpenses)
          ..where((t) => t.groupId.equals(groupId))
          ..orderBy([(t) => OrderingTerm.desc(t.expenseDate)]))
        .watch()
        .map((rows) => rows.map(_toSharedExpense).toList());
  }

  /// Insert shared expense
  Future<void> insertSharedExpense(SharedExpense expense) async {
    await into(sharedExpenses).insert(_toRow(expense));
  }

  /// Update shared expense
  Future<void> updateSharedExpense(SharedExpense expense) async {
    await (update(sharedExpenses)..where((t) => t.id.equals(expense.id))).write(_toRow(expense));
  }

  /// Update expense status
  Future<void> updateStatus(String id, SettlementStatus status) async {
    await (update(sharedExpenses)..where((t) => t.id.equals(id))).write(
      SharedExpensesCompanion(
        status: Value(_toStatusDb(status)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete shared expense
  Future<void> deleteSharedExpense(String id) async {
    await (delete(sharedExpenses)..where((t) => t.id.equals(id))).go();
  }

  // ====== Groups ======

  /// Watch all groups
  Stream<List<ExpenseGroup>> watchGroups() {
    return (select(expenseGroups)..orderBy([(t) => OrderingTerm.desc(t.lastActivityAt)]))
        .watch()
        .map((rows) => rows.map(_toGroup).toList());
  }

  /// Get group by ID
  Future<ExpenseGroup?> getGroupById(String id) async {
    final row = await (select(expenseGroups)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _toGroup(row) : null;
  }

  /// Insert group
  Future<void> insertGroup(ExpenseGroup group) async {
    await into(expenseGroups).insert(_toGroupRow(group));
  }

  /// Update group
  Future<void> updateGroup(ExpenseGroup group) async {
    await (update(expenseGroups)..where((t) => t.id.equals(group.id))).write(_toGroupRow(group));
  }

  /// Delete group
  Future<void> deleteGroup(String id) async {
    await (delete(expenseGroups)..where((t) => t.id.equals(id))).go();
  }

  SharedExpense _toSharedExpense(SharedExpenseRow row) {
    return SharedExpense(
      id: row.id,
      transactionId: row.transactionId,
      groupId: row.groupId,
      description: row.description,
      totalAmount: Money.fromPaisa(row.totalAmountPaisa),
      paidById: row.paidById,
      splitType: _fromSplitTypeDb(row.splitType),
      participants: _parseParticipants(row.participantsJson),
      status: _fromStatusDb(row.status),
      notes: row.notes,
      expenseDate: row.expenseDate,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  SharedExpensesCompanion _toRow(SharedExpense expense) {
    return SharedExpensesCompanion(
      id: Value(expense.id),
      transactionId: Value(expense.transactionId),
      groupId: Value(expense.groupId),
      description: Value(expense.description),
      totalAmountPaisa: Value(expense.totalAmount.paisa),
      paidById: Value(expense.paidById),
      splitType: Value(_toSplitTypeDb(expense.splitType)),
      participantsJson: Value(jsonEncode(expense.participants.map((p) => p.toJson()).toList())),
      status: Value(_toStatusDb(expense.status)),
      notes: Value(expense.notes),
      expenseDate: Value(expense.expenseDate),
      createdAt: Value(expense.createdAt),
      updatedAt: Value(expense.updatedAt),
    );
  }

  ExpenseGroup _toGroup(ExpenseGroupRow row) {
    final memberIds = (jsonDecode(row.memberIds) as List).cast<String>();
    return ExpenseGroup(
      id: row.id,
      name: row.name,
      description: row.description,
      iconCodePoint: row.iconCodePoint != null ? int.tryParse(row.iconCodePoint!) : null,
      colorValue: row.colorValue,
      memberIds: memberIds,
      totalExpenses: Money.fromPaisa(row.totalExpensesPaisa),
      lastActivityAt: row.lastActivityAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ExpenseGroupsCompanion _toGroupRow(ExpenseGroup group) {
    return ExpenseGroupsCompanion(
      id: Value(group.id),
      name: Value(group.name),
      description: Value(group.description),
      iconCodePoint: Value(group.iconCodePoint?.toString()),
      colorValue: Value(group.colorValue),
      memberIds: Value(jsonEncode(group.memberIds)),
      totalExpensesPaisa: Value(group.totalExpenses.paisa),
      lastActivityAt: Value(group.lastActivityAt),
      createdAt: Value(group.createdAt),
      updatedAt: Value(group.updatedAt),
    );
  }

  List<Participant> _parseParticipants(String json) {
    final list = jsonDecode(json) as List;
    return list.map((e) => Participant.fromJson(e as Map<String, dynamic>)).toList();
  }

  SplitType _fromSplitTypeDb(SplitTypeDb db) {
    switch (db) {
      case SplitTypeDb.equal: return SplitType.equal;
      case SplitTypeDb.percentage: return SplitType.percentage;
      case SplitTypeDb.exact: return SplitType.exact;
      case SplitTypeDb.shares: return SplitType.shares;
      case SplitTypeDb.adjustment: return SplitType.adjustment;
    }
  }

  SplitTypeDb _toSplitTypeDb(SplitType type) {
    switch (type) {
      case SplitType.equal: return SplitTypeDb.equal;
      case SplitType.percentage: return SplitTypeDb.percentage;
      case SplitType.exact: return SplitTypeDb.exact;
      case SplitType.shares: return SplitTypeDb.shares;
      case SplitType.adjustment: return SplitTypeDb.adjustment;
    }
  }

  SettlementStatus _fromStatusDb(SettlementStatusDb db) {
    switch (db) {
      case SettlementStatusDb.pending: return SettlementStatus.pending;
      case SettlementStatusDb.partial: return SettlementStatus.partial;
      case SettlementStatusDb.settled: return SettlementStatus.settled;
    }
  }

  SettlementStatusDb _toStatusDb(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.pending: return SettlementStatusDb.pending;
      case SettlementStatus.partial: return SettlementStatusDb.partial;
      case SettlementStatus.settled: return SettlementStatusDb.settled;
    }
  }
}

@DriftAccessor(tables: [Settlements])
class SettlementDao extends DatabaseAccessor<AppDatabase> with _$SettlementDaoMixin {
  SettlementDao(super.db);

  /// Watch settlements for a friend
  Stream<List<Settlement>> watchForFriend(String friendId) {
    return (select(settlements)
          ..where((t) => t.friendId.equals(friendId))
          ..orderBy([(t) => OrderingTerm.desc(t.settledAt)]))
        .watch()
        .map((rows) => rows.map(_toSettlement).toList());
  }

  /// Get all settlements
  Future<List<Settlement>> getAll() async {
    final rows = await (select(settlements)..orderBy([(t) => OrderingTerm.desc(t.settledAt)])).get();
    return rows.map(_toSettlement).toList();
  }

  /// Insert settlement
  Future<void> insertSettlement(Settlement settlement) async {
    await into(settlements).insert(_toRow(settlement));
  }

  /// Delete settlement (for undo)
  Future<void> deleteSettlement(String id) async {
    await (delete(settlements)..where((t) => t.id.equals(id))).go();
  }

  Settlement _toSettlement(SettlementRow row) {
    return Settlement(
      id: row.id,
      friendId: row.friendId,
      sharedExpenseId: row.sharedExpenseId,
      amount: Money.fromPaisa(row.amountPaisa),
      isIncoming: row.isIncoming,
      notes: row.notes,
      settledAt: row.settledAt,
      createdAt: row.createdAt,
    );
  }

  SettlementsCompanion _toRow(Settlement settlement) {
    return SettlementsCompanion(
      id: Value(settlement.id),
      friendId: Value(settlement.friendId),
      sharedExpenseId: Value(settlement.sharedExpenseId),
      amountPaisa: Value(settlement.amount.paisa),
      isIncoming: Value(settlement.isIncoming),
      notes: Value(settlement.notes),
      settledAt: Value(settlement.settledAt),
      createdAt: Value(settlement.createdAt),
    );
  }
}
