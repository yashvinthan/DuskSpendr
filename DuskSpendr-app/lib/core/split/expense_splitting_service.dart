import 'dart:async';
import 'dart:math';

/// SS-089 to SS-097: Shared Expenses Module
/// Bill splitting, friend management, group expenses, settlements

/// Expense Splitting Service
class ExpenseSplittingService {
  final Map<String, ExpenseGroup> _groups = {};
  final Map<String, Friend> _friends = {};
  final List<SharedExpense> _expenses = [];
  final List<Settlement> _settlements = [];

  // ====== Friend Management ======

  /// Add a friend
  Friend addFriend({
    required String name,
    String? phone,
    String? upiId,
  }) {
    final friend = Friend(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      upiId: upiId,
      createdAt: DateTime.now(),
    );
    _friends[friend.id] = friend;
    return friend;
  }

  /// Get all friends
  List<Friend> getAllFriends() => _friends.values.toList();

  /// Get friend by ID
  Friend? getFriend(String id) => _friends[id];

  // ====== Group Management ======

  /// Create expense group
  ExpenseGroup createGroup({
    required String name,
    required List<String> memberIds,
    String? description,
    GroupType type = GroupType.general,
  }) {
    // Add self as member
    final allMembers = ['self', ...memberIds];

    final group = ExpenseGroup(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      memberIds: allMembers,
      type: type,
      createdAt: DateTime.now(),
      isActive: true,
    );
    _groups[group.id] = group;
    return group;
  }

  /// Get all groups
  List<ExpenseGroup> getAllGroups() => _groups.values.toList();

  /// Get group by ID
  ExpenseGroup? getGroup(String id) => _groups[id];

  // ====== Expense Splitting ======

  /// Create shared expense with equal split
  SharedExpense createEqualSplit({
    required String description,
    required int totalAmountPaisa,
    required String paidByMemberId,
    required List<String> memberIds,
    String? groupId,
    String? category,
  }) {
    final splitAmount = totalAmountPaisa ~/ memberIds.length;
    final splits = memberIds.map((id) => ExpenseSplit(
          memberId: id,
          amountPaisa: splitAmount,
          isPaid: id == paidByMemberId,
        )).toList();

    final expense = SharedExpense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      totalAmountPaisa: totalAmountPaisa,
      paidByMemberId: paidByMemberId,
      splits: splits,
      splitType: SplitType.equal,
      groupId: groupId,
      category: category,
      createdAt: DateTime.now(),
      isSettled: false,
    );

    _expenses.add(expense);
    return expense;
  }

  /// Create shared expense with unequal split
  SharedExpense createUnequalSplit({
    required String description,
    required int totalAmountPaisa,
    required String paidByMemberId,
    required Map<String, int> memberAmounts,
    String? groupId,
    String? category,
  }) {
    final splits = memberAmounts.entries.map((e) => ExpenseSplit(
          memberId: e.key,
          amountPaisa: e.value,
          isPaid: e.key == paidByMemberId,
        )).toList();

    final expense = SharedExpense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      totalAmountPaisa: totalAmountPaisa,
      paidByMemberId: paidByMemberId,
      splits: splits,
      splitType: SplitType.unequal,
      groupId: groupId,
      category: category,
      createdAt: DateTime.now(),
      isSettled: false,
    );

    _expenses.add(expense);
    return expense;
  }

  /// Create shared expense with percentage split
  SharedExpense createPercentageSplit({
    required String description,
    required int totalAmountPaisa,
    required String paidByMemberId,
    required Map<String, double> memberPercentages,
    String? groupId,
    String? category,
  }) {
    final splits = memberPercentages.entries.map((e) {
      final amount = (totalAmountPaisa * e.value / 100).round();
      return ExpenseSplit(
        memberId: e.key,
        amountPaisa: amount,
        isPaid: e.key == paidByMemberId,
      );
    }).toList();

    final expense = SharedExpense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      totalAmountPaisa: totalAmountPaisa,
      paidByMemberId: paidByMemberId,
      splits: splits,
      splitType: SplitType.percentage,
      groupId: groupId,
      category: category,
      createdAt: DateTime.now(),
      isSettled: false,
    );

    _expenses.add(expense);
    return expense;
  }

  /// Create itemized split (each member selects items)
  SharedExpense createItemizedSplit({
    required String description,
    required List<ExpenseItem> items,
    required String paidByMemberId,
    String? groupId,
    String? category,
  }) {
    // Calculate total and per-member amounts
    final totalAmount = items.fold<int>(0, (sum, item) => sum + item.pricePaisa);
    final memberTotals = <String, int>{};

    for (final item in items) {
      for (final memberId in item.sharedByMemberIds) {
        final perPerson = item.pricePaisa ~/ item.sharedByMemberIds.length;
        memberTotals[memberId] = (memberTotals[memberId] ?? 0) + perPerson;
      }
    }

    final splits = memberTotals.entries.map((e) => ExpenseSplit(
          memberId: e.key,
          amountPaisa: e.value,
          isPaid: e.key == paidByMemberId,
        )).toList();

    final expense = SharedExpense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      totalAmountPaisa: totalAmount,
      paidByMemberId: paidByMemberId,
      splits: splits,
      splitType: SplitType.itemized,
      items: items,
      groupId: groupId,
      category: category,
      createdAt: DateTime.now(),
      isSettled: false,
    );

    _expenses.add(expense);
    return expense;
  }

  // ====== Balance Calculation ======

  /// Calculate who owes whom
  Map<String, int> calculateBalances({String? groupId}) {
    final balances = <String, int>{};

    final relevantExpenses = groupId != null
        ? _expenses.where((e) => e.groupId == groupId && !e.isSettled)
        : _expenses.where((e) => !e.isSettled);

    for (final expense in relevantExpenses) {
      for (final split in expense.splits) {
        if (split.memberId == expense.paidByMemberId) continue;
        if (split.isPaid) continue;

        // Member owes the payer
        balances[split.memberId] = (balances[split.memberId] ?? 0) - split.amountPaisa;
        balances[expense.paidByMemberId] = 
            (balances[expense.paidByMemberId] ?? 0) + split.amountPaisa;
      }
    }

    // Apply settlements
    final relevantSettlements = groupId != null
        ? _settlements.where((s) => s.groupId == groupId)
        : _settlements;

    for (final settlement in relevantSettlements) {
      balances[settlement.fromMemberId] = 
          (balances[settlement.fromMemberId] ?? 0) + settlement.amountPaisa;
      balances[settlement.toMemberId] = 
          (balances[settlement.toMemberId] ?? 0) - settlement.amountPaisa;
    }

    return balances;
  }

  /// Get simplified debts (minimize transactions)
  List<SimplifiedDebt> getSimplifiedDebts({String? groupId}) {
    final balances = calculateBalances(groupId: groupId);
    final debts = <SimplifiedDebt>[];

    // Separate into creditors and debtors
    final creditors = <String, int>{};
    final debtors = <String, int>{};

    for (final entry in balances.entries) {
      if (entry.value > 0) {
        creditors[entry.key] = entry.value;
      } else if (entry.value < 0) {
        debtors[entry.key] = -entry.value;
      }
    }

    // Greedy algorithm to minimize transactions
    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      final creditor = creditors.entries.reduce((a, b) => a.value > b.value ? a : b);
      final debtor = debtors.entries.reduce((a, b) => a.value > b.value ? a : b);

      final amount = min(creditor.value, debtor.value);

      debts.add(SimplifiedDebt(
        fromMemberId: debtor.key,
        toMemberId: creditor.key,
        amountPaisa: amount,
      ));

      // Update balances
      if (creditor.value == amount) {
        creditors.remove(creditor.key);
      } else {
        creditors[creditor.key] = creditor.value - amount;
      }

      if (debtor.value == amount) {
        debtors.remove(debtor.key);
      } else {
        debtors[debtor.key] = debtor.value - amount;
      }
    }

    return debts;
  }

  /// Get summary for a member
  MemberSummary getMemberSummary(String memberId, {String? groupId}) {
    final balances = calculateBalances(groupId: groupId);
    final balance = balances[memberId] ?? 0;

    return MemberSummary(
      memberId: memberId,
      netBalancePaisa: balance,
      totalOwedToYouPaisa: balance > 0 ? balance : 0,
      totalYouOwePaisa: balance < 0 ? -balance : 0,
    );
  }

  // ====== Settlements ======

  /// Record a settlement
  Settlement recordSettlement({
    required String fromMemberId,
    required String toMemberId,
    required int amountPaisa,
    SettlementMethod method = SettlementMethod.cash,
    String? groupId,
    String? note,
  }) {
    final settlement = Settlement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromMemberId: fromMemberId,
      toMemberId: toMemberId,
      amountPaisa: amountPaisa,
      method: method,
      groupId: groupId,
      note: note,
      createdAt: DateTime.now(),
    );

    _settlements.add(settlement);
    return settlement;
  }

  /// Generate UPI payment link
  String generateUpiLink({
    required String upiId,
    required int amountPaisa,
    required String description,
  }) {
    final amount = (amountPaisa / 100).toStringAsFixed(2);
    final encodedDesc = Uri.encodeComponent(description);
    return 'upi://pay?pa=$upiId&pn=DuskSpendr&am=$amount&tn=$encodedDesc';
  }

  // ====== Group Activity ======

  /// Get group activity/history
  List<GroupActivity> getGroupActivity(String groupId) {
    final activities = <GroupActivity>[];

    // Add expenses
    for (final expense in _expenses.where((e) => e.groupId == groupId)) {
      activities.add(GroupActivity(
        id: expense.id,
        type: ActivityType.expense,
        description: expense.description,
        amountPaisa: expense.totalAmountPaisa,
        memberId: expense.paidByMemberId,
        timestamp: expense.createdAt,
      ));
    }

    // Add settlements
    for (final settlement in _settlements.where((s) => s.groupId == groupId)) {
      activities.add(GroupActivity(
        id: settlement.id,
        type: ActivityType.settlement,
        description: 'Settlement',
        amountPaisa: settlement.amountPaisa,
        memberId: settlement.fromMemberId,
        timestamp: settlement.createdAt,
      ));
    }

    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities;
  }

  /// Get expenses for a group
  List<SharedExpense> getGroupExpenses(String groupId) {
    return _expenses.where((e) => e.groupId == groupId).toList();
  }
}

/// Receipt Scanner for expense splitting
class ReceiptScanner {
  /// Parse receipt items (mock implementation)
  Future<List<ExpenseItem>> scanReceipt(String imagePath) async {
    // In production, use ML model or OCR service
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data
    return [
      const ExpenseItem(
        name: 'Pizza',
        pricePaisa: 35000,
        quantity: 1,
        sharedByMemberIds: [],
      ),
      const ExpenseItem(
        name: 'Pasta',
        pricePaisa: 28000,
        quantity: 1,
        sharedByMemberIds: [],
      ),
      const ExpenseItem(
        name: 'Drinks',
        pricePaisa: 15000,
        quantity: 3,
        sharedByMemberIds: [],
      ),
    ];
  }
}

/// Reminder Service for pending settlements
class SettlementReminderService {
  List<SettlementReminder> generateReminders(
    List<SimplifiedDebt> debts,
    Map<String, Friend> friends,
  ) {
    return debts.where((d) => d.fromMemberId == 'self').map((debt) {
      final friend = friends[debt.toMemberId];
      return SettlementReminder(
        debtId: '${debt.fromMemberId}_${debt.toMemberId}',
        friendId: debt.toMemberId,
        friendName: friend?.name ?? 'Unknown',
        amountPaisa: debt.amountPaisa,
        daysOutstanding: 7, // Would calculate from first expense date
      );
    }).toList();
  }

  List<SettlementReminder> getPendingFromOthers(
    List<SimplifiedDebt> debts,
    Map<String, Friend> friends,
  ) {
    return debts.where((d) => d.toMemberId == 'self').map((debt) {
      final friend = friends[debt.fromMemberId];
      return SettlementReminder(
        debtId: '${debt.fromMemberId}_${debt.toMemberId}',
        friendId: debt.fromMemberId,
        friendName: friend?.name ?? 'Unknown',
        amountPaisa: debt.amountPaisa,
        daysOutstanding: 7,
      );
    }).toList();
  }
}

// ====== Data Classes ======

class Friend {
  final String id;
  final String name;
  final String? phone;
  final String? upiId;
  final DateTime createdAt;

  const Friend({
    required this.id,
    required this.name,
    this.phone,
    this.upiId,
    required this.createdAt,
  });
}

enum GroupType {
  general,
  trip,
  roommates,
  event,
  dining,
}

class ExpenseGroup {
  final String id;
  final String name;
  final String? description;
  final List<String> memberIds;
  final GroupType type;
  final DateTime createdAt;
  final bool isActive;

  const ExpenseGroup({
    required this.id,
    required this.name,
    this.description,
    required this.memberIds,
    required this.type,
    required this.createdAt,
    required this.isActive,
  });
}

enum SplitType {
  equal,
  unequal,
  percentage,
  itemized,
}

class ExpenseSplit {
  final String memberId;
  final int amountPaisa;
  final bool isPaid;

  const ExpenseSplit({
    required this.memberId,
    required this.amountPaisa,
    required this.isPaid,
  });
}

class ExpenseItem {
  final String name;
  final int pricePaisa;
  final int quantity;
  final List<String> sharedByMemberIds;

  const ExpenseItem({
    required this.name,
    required this.pricePaisa,
    required this.quantity,
    required this.sharedByMemberIds,
  });
}

class SharedExpense {
  final String id;
  final String description;
  final int totalAmountPaisa;
  final String paidByMemberId;
  final List<ExpenseSplit> splits;
  final SplitType splitType;
  final List<ExpenseItem>? items;
  final String? groupId;
  final String? category;
  final DateTime createdAt;
  final bool isSettled;

  const SharedExpense({
    required this.id,
    required this.description,
    required this.totalAmountPaisa,
    required this.paidByMemberId,
    required this.splits,
    required this.splitType,
    this.items,
    this.groupId,
    this.category,
    required this.createdAt,
    required this.isSettled,
  });
}

class SimplifiedDebt {
  final String fromMemberId;
  final String toMemberId;
  final int amountPaisa;

  const SimplifiedDebt({
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountPaisa,
  });
}

class MemberSummary {
  final String memberId;
  final int netBalancePaisa;
  final int totalOwedToYouPaisa;
  final int totalYouOwePaisa;

  const MemberSummary({
    required this.memberId,
    required this.netBalancePaisa,
    required this.totalOwedToYouPaisa,
    required this.totalYouOwePaisa,
  });
}

enum SettlementMethod {
  cash,
  upi,
  bankTransfer,
  other,
}

class Settlement {
  final String id;
  final String fromMemberId;
  final String toMemberId;
  final int amountPaisa;
  final SettlementMethod method;
  final String? groupId;
  final String? note;
  final DateTime createdAt;

  const Settlement({
    required this.id,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountPaisa,
    required this.method,
    this.groupId,
    this.note,
    required this.createdAt,
  });
}

enum ActivityType {
  expense,
  settlement,
  memberAdded,
  memberRemoved,
}

class GroupActivity {
  final String id;
  final ActivityType type;
  final String description;
  final int amountPaisa;
  final String memberId;
  final DateTime timestamp;

  const GroupActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.amountPaisa,
    required this.memberId,
    required this.timestamp,
  });
}

class SettlementReminder {
  final String debtId;
  final String friendId;
  final String friendName;
  final int amountPaisa;
  final int daysOutstanding;

  const SettlementReminder({
    required this.debtId,
    required this.friendId,
    required this.friendName,
    required this.amountPaisa,
    required this.daysOutstanding,
  });
}
