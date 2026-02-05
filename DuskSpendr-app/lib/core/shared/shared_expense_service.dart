import 'package:uuid/uuid.dart';

import '../../data/local/daos/shared_expense_dao.dart';
import '../../domain/entities/entities.dart';
import 'expense_splitting_service.dart';

/// SS-102, SS-103, SS-104: Shared expense management service
/// Handles friends, groups, balances, and settlements

class SharedExpenseService {
  final FriendDao _friendDao;
  final SharedExpenseDao _sharedExpenseDao;
  final SettlementDao _settlementDao;
  final ExpenseSplittingService _splittingService;

  static const uuid = Uuid();
  static const selfId = 'self';

  SharedExpenseService({
    required FriendDao friendDao,
    required SharedExpenseDao sharedExpenseDao,
    required SettlementDao settlementDao,
    ExpenseSplittingService? splittingService,
  })  : _friendDao = friendDao,
        _sharedExpenseDao = sharedExpenseDao,
        _settlementDao = settlementDao,
        _splittingService = splittingService ?? ExpenseSplittingService();

  // ====== SS-102: Friend Management ======

  /// Add a new friend
  Future<Friend> addFriend({
    required String name,
    String? phone,
    String? email,
    String? avatarUrl,
  }) async {
    final friend = Friend(
      id: uuid.v4(),
      name: name,
      phone: phone,
      email: email,
      avatarUrl: avatarUrl,
      totalOwed: Money.zero,
      totalOwing: Money.zero,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _friendDao.insertFriend(friend);
    return friend;
  }

  /// Update friend details
  Future<void> updateFriend(Friend friend) async {
    await _friendDao.updateFriend(friend.copyWith(updatedAt: DateTime.now()));
  }

  /// Delete a friend (checks for unsettled expenses)
  Future<DeleteFriendResult> deleteFriend(String friendId) async {
    final friend = await _friendDao.getById(friendId);
    if (friend == null) {
      return DeleteFriendResult.notFound;
    }

    if (!friend.isSettled) {
      return DeleteFriendResult.hasUnsettledBalance;
    }

    await _friendDao.deleteFriend(friendId);
    return DeleteFriendResult.success;
  }

  /// Get all friends
  Stream<List<Friend>> watchFriends() => _friendDao.watchAll();

  /// Get friends with balances
  Stream<List<Friend>> watchFriendsWithBalance() => _friendDao.watchWithBalance();

  /// Search friends by name
  Future<List<Friend>> searchFriends(String query) => _friendDao.search(query);

  // ====== Group Management ======

  /// Create expense group
  Future<ExpenseGroup> createGroup({
    required String name,
    String? description,
    int? iconCodePoint,
    int? colorValue,
    List<String>? memberIds,
  }) async {
    final group = ExpenseGroup(
      id: uuid.v4(),
      name: name,
      description: description,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      memberIds: memberIds ?? [],
      totalExpenses: Money.zero,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _sharedExpenseDao.insertGroup(group);
    return group;
  }

  /// Update group
  Future<void> updateGroup(ExpenseGroup group) async {
    await _sharedExpenseDao.updateGroup(group.copyWith(updatedAt: DateTime.now()));
  }

  /// Delete group
  Future<void> deleteGroup(String groupId) async {
    await _sharedExpenseDao.deleteGroup(groupId);
  }

  /// Watch all groups
  Stream<List<ExpenseGroup>> watchGroups() => _sharedExpenseDao.watchGroups();

  // ====== SS-103: Balance Tracking ======

  /// Add a shared expense
  Future<SharedExpense> addSharedExpense({
    required String description,
    required Money totalAmount,
    required String paidById,
    required SplitType splitType,
    required List<Participant> participants,
    String? groupId,
    String? transactionId,
    String? notes,
    DateTime? expenseDate,
  }) async {
    // Calculate shares if equal split
    List<Participant> finalParticipants;
    if (splitType == SplitType.equal) {
      finalParticipants = _splittingService.calculateEqualSplit(
        totalAmount: totalAmount,
        participants: participants,
      );
    } else {
      finalParticipants = _splittingService.calculateSplit(
        totalAmount: totalAmount,
        splitType: splitType,
        participants: participants,
      );
    }

    // Mark payer as paid
    finalParticipants = finalParticipants.map((p) {
      if (p.id == paidById) {
        return p.copyWith(hasPaid: true, paidAmount: p.share);
      }
      return p;
    }).toList();

    final expense = SharedExpense(
      id: uuid.v4(),
      transactionId: transactionId,
      groupId: groupId,
      description: description,
      totalAmount: totalAmount,
      paidById: paidById,
      splitType: splitType,
      participants: finalParticipants,
      status: SettlementStatus.pending,
      notes: notes,
      expenseDate: expenseDate ?? DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _sharedExpenseDao.insertSharedExpense(expense);

    // Update friend balances
    await _updateBalancesAfterExpense(expense);

    return expense;
  }

  /// Update friend balances after adding an expense
  Future<void> _updateBalancesAfterExpense(SharedExpense expense) async {
    for (final participant in expense.participants) {
      if (participant.id == selfId || participant.id == expense.paidById) continue;
      if (participant.hasPaid) continue;

      // If we paid, they owe us
      if (expense.paidById == selfId) {
        await _friendDao.updateBalance(
          participant.id,
          owedDelta: participant.share.paisa,
        );
      }
      // If they paid, we owe them
      else if (expense.participants.any((p) => p.id == selfId)) {
        final ourShare = expense.participants
            .firstWhere((p) => p.id == selfId)
            .share
            .paisa;
        await _friendDao.updateBalance(
          expense.paidById,
          owingDelta: ourShare,
        );
      }
    }
  }

  /// Get net balance summary
  Future<BalanceSummary> getBalanceSummary() async {
    final friends = await _friendDao.getAll();
    
    int totalOwed = 0;
    int totalOwing = 0;
    
    for (final friend in friends) {
      totalOwed += friend.totalOwed.paisa;
      totalOwing += friend.totalOwing.paisa;
    }

    return BalanceSummary(
      totalOwed: Money.fromPaisa(totalOwed),
      totalOwing: Money.fromPaisa(totalOwing),
      netBalance: Money.fromPaisa(totalOwed - totalOwing),
      friendCount: friends.where((f) => !f.isSettled).length,
    );
  }

  /// Get balance with a specific friend
  Future<FriendBalance> getFriendBalance(String friendId) async {
    final friend = await _friendDao.getById(friendId);
    if (friend == null) {
      throw ArgumentError('Friend not found: $friendId');
    }

    // Watch expenses returns a stream, so get current value
    final expenses = await _sharedExpenseDao.watchForFriend(friendId).first;
    final pendingExpenses = expenses.where((e) => !e.isFullySettled).toList();

    final settlements = await _settlementDao.watchForFriend(friendId).first;

    return FriendBalance(
      friend: friend,
      pendingExpenses: pendingExpenses,
      recentSettlements: settlements.take(10).toList(),
    );
  }

  // Watch all shared expenses
  Stream<List<SharedExpense>> watchAllExpenses() => _sharedExpenseDao.watchAll();

  /// Watch pending expenses
  Stream<List<SharedExpense>> watchPendingExpenses() =>
      _sharedExpenseDao.watchPending();

  // ====== SS-104: Settlement Tracking ======

  /// Record a settlement
  Future<Settlement> recordSettlement({
    required String friendId,
    required Money amount,
    required bool isIncoming, // True if friend paid us
    String? sharedExpenseId,
    String? notes,
  }) async {
    final settlement = Settlement(
      id: uuid.v4(),
      friendId: friendId,
      sharedExpenseId: sharedExpenseId,
      amount: amount,
      isIncoming: isIncoming,
      notes: notes,
      settledAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    await _settlementDao.insertSettlement(settlement);

    // Update friend balance
    if (isIncoming) {
      // They paid us, reduce what they owe
      await _friendDao.updateBalance(friendId, owedDelta: -amount.paisa);
    } else {
      // We paid them, reduce what we owe
      await _friendDao.updateBalance(friendId, owingDelta: -amount.paisa);
    }

    // Update expense status if linked to specific expense
    if (sharedExpenseId != null) {
      await _checkAndUpdateExpenseStatus(sharedExpenseId);
    }

    return settlement;
  }

  /// Check and update expense settlement status
  Future<void> _checkAndUpdateExpenseStatus(String expenseId) async {
    final expense = await _sharedExpenseDao.getById(expenseId);
    if (expense == null) return;

    final settlements = await _settlementDao.watchForFriend(expense.paidById).first;
    final expenseSettlements = settlements.where((s) => s.sharedExpenseId == expenseId);
    
    final totalSettled = expenseSettlements.fold<int>(
      0,
      (sum, s) => sum + s.amount.paisa,
    );

    final unpaid = expense.unpaidAmount.paisa;
    
    if (totalSettled >= unpaid) {
      await _sharedExpenseDao.updateStatus(expenseId, SettlementStatus.settled);
    } else if (totalSettled > 0) {
      await _sharedExpenseDao.updateStatus(expenseId, SettlementStatus.partial);
    }
  }

  /// Undo a settlement
  Future<void> undoSettlement(String settlementId) async {
    final settlements = await _settlementDao.getAll();
    final settlement = settlements.firstWhere(
      (s) => s.id == settlementId,
      orElse: () => throw ArgumentError('Settlement not found'),
    );

    // Reverse the balance update
    if (settlement.isIncoming) {
      await _friendDao.updateBalance(
        settlement.friendId,
        owedDelta: settlement.amount.paisa,
      );
    } else {
      await _friendDao.updateBalance(
        settlement.friendId,
        owingDelta: settlement.amount.paisa,
      );
    }

    await _settlementDao.deleteSettlement(settlementId);

    // Recheck expense status if linked
    if (settlement.sharedExpenseId != null) {
      await _checkAndUpdateExpenseStatus(settlement.sharedExpenseId!);
    }
  }

  /// Watch settlements for a friend
  Stream<List<Settlement>> watchSettlementsForFriend(String friendId) =>
      _settlementDao.watchForFriend(friendId);

  /// Get simplified debts for a group
  List<SimplifiedDebt> getSimplifiedDebts(List<SharedExpense> expenses) {
    return _splittingService.simplifyDebts(expenses, selfId);
  }
}

/// Result of delete friend operation
enum DeleteFriendResult { success, notFound, hasUnsettledBalance }

/// Balance summary
class BalanceSummary {
  final Money totalOwed;   // Others owe you
  final Money totalOwing;  // You owe others
  final Money netBalance;  // Net (positive = you're owed)
  final int friendCount;   // Friends with non-zero balance

  const BalanceSummary({
    required this.totalOwed,
    required this.totalOwing,
    required this.netBalance,
    required this.friendCount,
  });
}
