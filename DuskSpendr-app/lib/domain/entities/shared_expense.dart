import 'money.dart';

/// SS-100: Shared expense domain entities

/// Split type for shared expenses
enum SplitType {
  equal,      // Divide equally
  percentage, // Each pays X%
  exact,      // Each pays specific amount
  shares,     // Based on share units (1x, 2x)
  adjustment, // Equal with adjustments
}

/// Settlement status
enum SettlementStatus { pending, partial, settled }

/// Participant in a shared expense
class Participant {
  final String id;
  final String name;
  final String? phone;
  final Money share;
  final bool hasPaid;
  final Money? paidAmount;
  final double? percentage; // For percentage splits
  final int? shareUnits;    // For shares splits

  const Participant({
    required this.id,
    required this.name,
    this.phone,
    required this.share,
    this.hasPaid = false,
    this.paidAmount,
    this.percentage,
    this.shareUnits,
  });

  Participant copyWith({
    String? id,
    String? name,
    String? phone,
    Money? share,
    bool? hasPaid,
    Money? paidAmount,
    double? percentage,
    int? shareUnits,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      share: share ?? this.share,
      hasPaid: hasPaid ?? this.hasPaid,
      paidAmount: paidAmount ?? this.paidAmount,
      percentage: percentage ?? this.percentage,
      shareUnits: shareUnits ?? this.shareUnits,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'sharePaisa': share.paisa,
    'hasPaid': hasPaid,
    'paidAmountPaisa': paidAmount?.paisa,
    'percentage': percentage,
    'shareUnits': shareUnits,
  };

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    share: Money.fromPaisa(json['sharePaisa'] as int),
    hasPaid: json['hasPaid'] as bool? ?? false,
    paidAmount: json['paidAmountPaisa'] != null
        ? Money.fromPaisa(json['paidAmountPaisa'] as int)
        : null,
    percentage: json['percentage'] as double?,
    shareUnits: json['shareUnits'] as int?,
  );
}

/// Friend for expense splitting
class Friend {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? avatarUrl;
  final Money totalOwed;   // They owe you
  final Money totalOwing;  // You owe them
  final DateTime? lastActivityAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Friend({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.avatarUrl,
    required this.totalOwed,
    required this.totalOwing,
    this.lastActivityAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Net balance (positive = they owe you, negative = you owe them)
  Money get netBalance => Money.fromPaisa(totalOwed.paisa - totalOwing.paisa);

  /// Check if settled (net balance is 0)
  bool get isSettled => netBalance.paisa == 0;

  Friend copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
    Money? totalOwed,
    Money? totalOwing,
    DateTime? lastActivityAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalOwed: totalOwed ?? this.totalOwed,
      totalOwing: totalOwing ?? this.totalOwing,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Expense group for repeated splits
class ExpenseGroup {
  final String id;
  final String name;
  final String? description;
  final int? iconCodePoint;
  final int? colorValue;
  final List<String> memberIds;
  final Money totalExpenses;
  final DateTime? lastActivityAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseGroup({
    required this.id,
    required this.name,
    this.description,
    this.iconCodePoint,
    this.colorValue,
    required this.memberIds,
    required this.totalExpenses,
    this.lastActivityAt,
    required this.createdAt,
    required this.updatedAt,
  });

  ExpenseGroup copyWith({
    String? id,
    String? name,
    String? description,
    int? iconCodePoint,
    int? colorValue,
    List<String>? memberIds,
    Money? totalExpenses,
    DateTime? lastActivityAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      memberIds: memberIds ?? this.memberIds,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Shared expense
class SharedExpense {
  final String id;
  final String? transactionId;
  final String? groupId;
  final String description;
  final Money totalAmount;
  final String paidById; // Friend ID or 'self'
  final SplitType splitType;
  final List<Participant> participants;
  final SettlementStatus status;
  final String? notes;
  final DateTime expenseDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SharedExpense({
    required this.id,
    this.transactionId,
    this.groupId,
    required this.description,
    required this.totalAmount,
    required this.paidById,
    required this.splitType,
    required this.participants,
    required this.status,
    this.notes,
    required this.expenseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get total paid so far
  Money get totalPaid {
    return Money.fromPaisa(
      participants.where((p) => p.hasPaid).fold(0, (sum, p) => sum + (p.paidAmount?.paisa ?? p.share.paisa)),
    );
  }

  /// Get unpaid amount
  Money get unpaidAmount => Money.fromPaisa(totalAmount.paisa - totalPaid.paisa);

  /// Check if fully settled
  bool get isFullySettled => status == SettlementStatus.settled;

  SharedExpense copyWith({
    String? id,
    String? transactionId,
    String? groupId,
    String? description,
    Money? totalAmount,
    String? paidById,
    SplitType? splitType,
    List<Participant>? participants,
    SettlementStatus? status,
    String? notes,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SharedExpense(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      groupId: groupId ?? this.groupId,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      paidById: paidById ?? this.paidById,
      splitType: splitType ?? this.splitType,
      participants: participants ?? this.participants,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Settlement record
class Settlement {
  final String id;
  final String friendId;
  final String? sharedExpenseId;
  final Money amount;
  final bool isIncoming; // True if friend paid us
  final String? notes;
  final DateTime settledAt;
  final DateTime createdAt;

  const Settlement({
    required this.id,
    required this.friendId,
    this.sharedExpenseId,
    required this.amount,
    required this.isIncoming,
    this.notes,
    required this.settledAt,
    required this.createdAt,
  });

  Settlement copyWith({
    String? id,
    String? friendId,
    String? sharedExpenseId,
    Money? amount,
    bool? isIncoming,
    String? notes,
    DateTime? settledAt,
    DateTime? createdAt,
  }) {
    return Settlement(
      id: id ?? this.id,
      friendId: friendId ?? this.friendId,
      sharedExpenseId: sharedExpenseId ?? this.sharedExpenseId,
      amount: amount ?? this.amount,
      isIncoming: isIncoming ?? this.isIncoming,
      notes: notes ?? this.notes,
      settledAt: settledAt ?? this.settledAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Balance summary with a friend
class FriendBalance {
  final Friend friend;
  final List<SharedExpense> pendingExpenses;
  final List<Settlement> recentSettlements;

  const FriendBalance({
    required this.friend,
    required this.pendingExpenses,
    required this.recentSettlements,
  });
}
