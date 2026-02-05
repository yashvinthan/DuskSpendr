import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/shared/expense_splitting_service.dart';
import '../core/shared/shared_expense_service.dart';
import '../domain/entities/entities.dart';
import 'database_provider.dart';

// ====== SS-100-106: Shared Expense Providers ======

/// Expense splitting service provider
final expenseSplittingServiceProvider = Provider<ExpenseSplittingService>((ref) {
  return ExpenseSplittingService();
});

/// Shared expense service provider
final sharedExpenseServiceProvider = Provider<SharedExpenseService>((ref) {
  return SharedExpenseService(
    friendDao: ref.watch(friendDaoProvider),
    sharedExpenseDao: ref.watch(sharedExpenseDaoProvider),
    settlementDao: ref.watch(settlementDaoProvider),
  );
});

// ====== State Providers ======

/// Currently selected friend for expense
final selectedFriendProvider = StateProvider<Friend?>((ref) => null);

/// Currently selected group for expense
final selectedGroupProvider = StateProvider<ExpenseGroup?>((ref) => null);

/// Selected split type for new expense
final selectedSplitTypeProvider = StateProvider<SplitType>((ref) => SplitType.equal);

// ====== Friends Providers ======

/// All friends provider (stream)
final friendsProvider = StreamProvider<List<Friend>>((ref) {
  return ref.watch(friendDaoProvider).watchAll();
});

/// Friends with balances (sorted by who owes most)
final friendsWithBalancesProvider = FutureProvider<List<FriendBalance>>((ref) async {
  final service = ref.watch(sharedExpenseServiceProvider);
  final friends = await ref.watch(friendsProvider.future);
  
  final balances = <FriendBalance>[];
  for (final friend in friends) {
    try {
      final balance = await service.getFriendBalance(friend.id);
      balances.add(balance);
    } catch (_) {
      // Skip if can't get balance
    }
  }
  
  // Sort by absolute netBalance (highest first)
  balances.sort((a, b) => 
    b.friend.netBalance.paisa.abs().compareTo(a.friend.netBalance.paisa.abs()));
  return balances;
});

/// Single friend by ID
final friendByIdProvider = FutureProvider.family<Friend?, String>((ref, id) async {
  return ref.watch(friendDaoProvider).getById(id);
});

/// Friend search results
final friendSearchQueryProvider = StateProvider<String>((ref) => '');

final friendSearchResultsProvider = FutureProvider<List<Friend>>((ref) async {
  final query = ref.watch(friendSearchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(friendDaoProvider).search(query);
});

// ====== Groups Providers ======

/// All expense groups (stream)
final expenseGroupsProvider = StreamProvider<List<ExpenseGroup>>((ref) {
  return ref.watch(sharedExpenseDaoProvider).watchGroups();
});

/// Group by ID
final groupByIdProvider = FutureProvider.family<ExpenseGroup?, String>((ref, id) async {
  return ref.watch(sharedExpenseDaoProvider).getGroupById(id);
});

// ====== Shared Expenses Providers ======

/// All shared expenses (stream)
final sharedExpensesProvider = StreamProvider<List<SharedExpense>>((ref) {
  return ref.watch(sharedExpenseDaoProvider).watchAll();
});

/// Shared expenses for a specific friend (stream)
final friendExpensesProvider = StreamProvider.family<List<SharedExpense>, String>((ref, friendId) {
  return ref.watch(sharedExpenseDaoProvider).watchForFriend(friendId);
});

/// Shared expenses for a specific group (stream)
final groupExpensesProvider = StreamProvider.family<List<SharedExpense>, String>((ref, groupId) {
  return ref.watch(sharedExpenseDaoProvider).watchForGroup(groupId);
});

/// Pending (unsettled) expenses (stream)
final pendingExpensesProvider = StreamProvider<List<SharedExpense>>((ref) {
  return ref.watch(sharedExpenseDaoProvider).watchPending();
});

/// Single expense by ID
final expenseByIdProvider = FutureProvider.family<SharedExpense?, String>((ref, id) async {
  return ref.watch(sharedExpenseDaoProvider).getById(id);
});

// ====== Settlements Providers ======

/// All settlements
final settlementsProvider = FutureProvider<List<Settlement>>((ref) async {
  return ref.watch(settlementDaoProvider).getAll();
});

/// Settlements for a specific friend (stream)
final friendSettlementsProvider = StreamProvider.family<List<Settlement>, String>((ref, friendId) {
  return ref.watch(settlementDaoProvider).watchForFriend(friendId);
});

// ====== Balance Summary Provider ======

/// Overall balance summary
final balanceSummaryProvider = FutureProvider<BalanceSummary>((ref) async {
  final service = ref.watch(sharedExpenseServiceProvider);
  return service.getBalanceSummary();
});

/// Balance summary for friend
final friendBalanceSummaryProvider = FutureProvider.family<FriendBalance, String>((ref, friendId) async {
  final service = ref.watch(sharedExpenseServiceProvider);
  return service.getFriendBalance(friendId);
});

// ====== Split Calculation Providers ======

/// Split preview for current expense setup
final splitPreviewProvider = FutureProvider.family<List<Participant>, SplitSetup>((ref, setup) async {
  final service = ref.watch(expenseSplittingServiceProvider);
  
  // Create participants from setup
  final participants = setup.participants.map((p) {
    return Participant(
      id: p.id,
      name: p.name,
      share: Money.zero,
      percentage: setup.percentages?[p.id],
      shareUnits: setup.shares?[p.id],
    );
  }).toList();
  
  switch (setup.splitType) {
    case SplitType.equal:
      return service.calculateEqualSplit(
        totalAmount: setup.totalAmount,
        participants: participants,
      );
    case SplitType.percentage:
      // Ensure percentages are set on participants
      final withPercentages = participants.map((p) => 
        p.copyWith(percentage: setup.percentages?[p.id] ?? 0)).toList();
      return service.calculatePercentageSplit(
        totalAmount: setup.totalAmount,
        participants: withPercentages,
      );
    case SplitType.exact:
      // For exact, set the share directly
      final withExact = participants.map((p) {
        final amount = setup.exactAmounts?[p.id] ?? 0;
        return p.copyWith(share: Money.fromPaisa(amount));
      }).toList();
      return service.calculateExactSplit(
        totalAmount: setup.totalAmount,
        participants: withExact,
      );
    case SplitType.shares:
      final withShares = participants.map((p) => 
        p.copyWith(shareUnits: setup.shares?[p.id] ?? 1)).toList();
      return service.calculateSharesSplit(
        totalAmount: setup.totalAmount,
        participants: withShares,
      );
    case SplitType.adjustment:
      return service.calculateAdjustmentSplit(
        totalAmount: setup.totalAmount,
        participants: participants,
        adjustments: setup.adjustments ?? {},
      );
  }
});

// ====== Notifier for Managing State ======

class SharedExpenseNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  SharedExpenseNotifier(this._ref) : super(const AsyncValue.data(null));

  /// Add a new friend
  Future<Friend?> addFriend({
    required String name,
    String? phone,
    String? email,
  }) async {
    state = const AsyncValue.loading();
    try {
      final friend = await _ref.read(sharedExpenseServiceProvider).addFriend(
            name: name,
            phone: phone,
            email: email,
          );
      _ref.invalidate(friendsProvider);
      state = const AsyncValue.data(null);
      return friend;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Create a new expense group
  Future<ExpenseGroup?> createGroup({
    required String name,
    required List<String> memberIds,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    try {
      final group = await _ref.read(sharedExpenseServiceProvider).createGroup(
            name: name,
            memberIds: memberIds,
            description: description,
          );
      _ref.invalidate(expenseGroupsProvider);
      state = const AsyncValue.data(null);
      return group;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Add a shared expense
  Future<SharedExpense?> addExpense({
    required String description,
    required Money totalAmount,
    required String paidById,
    required SplitType splitType,
    required List<Participant> participants,
    String? groupId,
    String? notes,
    DateTime? expenseDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final expense = await _ref.read(sharedExpenseServiceProvider).addSharedExpense(
            description: description,
            totalAmount: totalAmount,
            paidById: paidById,
            splitType: splitType,
            participants: participants,
            groupId: groupId,
            notes: notes,
            expenseDate: expenseDate,
          );
      _ref.invalidate(sharedExpensesProvider);
      _ref.invalidate(friendsWithBalancesProvider);
      _ref.invalidate(balanceSummaryProvider);
      state = const AsyncValue.data(null);
      return expense;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Record a settlement
  Future<Settlement?> recordSettlement({
    required String friendId,
    required Money amount,
    required bool isIncoming,
    String? sharedExpenseId,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final settlement = await _ref.read(sharedExpenseServiceProvider).recordSettlement(
            friendId: friendId,
            amount: amount,
            isIncoming: isIncoming,
            sharedExpenseId: sharedExpenseId,
            notes: notes,
          );
      _ref.invalidate(settlementsProvider);
      _ref.invalidate(friendsWithBalancesProvider);
      _ref.invalidate(balanceSummaryProvider);
      _ref.invalidate(sharedExpensesProvider);
      state = const AsyncValue.data(null);
      return settlement;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Delete a friend
  Future<DeleteFriendResult> deleteFriend(String id) async {
    state = const AsyncValue.loading();
    try {
      final result = await _ref.read(sharedExpenseServiceProvider).deleteFriend(id);
      if (result == DeleteFriendResult.success) {
        _ref.invalidate(friendsProvider);
        _ref.invalidate(friendsWithBalancesProvider);
      }
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return DeleteFriendResult.notFound;
    }
  }

  /// Delete a group
  Future<void> deleteGroup(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(sharedExpenseServiceProvider).deleteGroup(id);
      _ref.invalidate(expenseGroupsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final sharedExpenseNotifierProvider =
    StateNotifierProvider<SharedExpenseNotifier, AsyncValue<void>>((ref) {
  return SharedExpenseNotifier(ref);
});

/// Setup for calculating splits
class SplitSetup {
  final Money totalAmount;
  final String payerId;
  final SplitType splitType;
  final List<ParticipantRef> participants;
  final Map<String, double>? percentages;
  final Map<String, int>? exactAmounts;
  final Map<String, int>? shares;
  final Map<String, int>? adjustments;

  const SplitSetup({
    required this.totalAmount,
    required this.payerId,
    required this.splitType,
    required this.participants,
    this.percentages,
    this.exactAmounts,
    this.shares,
    this.adjustments,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplitSetup &&
          runtimeType == other.runtimeType &&
          totalAmount == other.totalAmount &&
          payerId == other.payerId &&
          splitType == other.splitType;

  @override
  int get hashCode => totalAmount.hashCode ^ payerId.hashCode ^ splitType.hashCode;
}

/// Simple participant reference for split setup
class ParticipantRef {
  final String id;
  final String name;

  const ParticipantRef({required this.id, required this.name});
}
