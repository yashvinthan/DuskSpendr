import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/daos/transaction_dao.dart';
import '../domain/entities/entities.dart';
import 'database_provider.dart';

/// Stream of all transactions (with optional filters applied)
final transactionsStreamProvider =
    StreamProvider.family<List<Transaction>, TransactionFilter?>((ref, filter) {
      final dao = ref.watch(transactionDaoProvider);
      return dao.watchTransactions(
        category: filter?.category,
        accountId: filter?.accountId,
        startDate: filter?.startDate,
        endDate: filter?.endDate,
        limit: filter?.limit,
      );
    });

/// All transactions (no filter)
final allTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return dao.watchTransactions();
});

/// Recent transactions (last 10)
final recentTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return dao.watchTransactions(limit: 10);
});

/// Today's transactions
final todayTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  return dao.watchTransactions(startDate: startOfDay, endDate: endOfDay);
});

/// This month's transactions
final thisMonthTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  return dao.watchTransactions(startDate: startOfMonth, endDate: endOfMonth);
});

/// This week's transactions (Monday - Sunday)
final thisWeekTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  final now = DateTime.now();
  final startOfWeek = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 7));
  return dao.watchTransactions(startDate: startOfWeek, endDate: endOfWeek);
});

/// This week's total spending
final weeklySpendingProvider = FutureProvider<Money>((ref) async {
  final transactions = await ref.watch(thisWeekTransactionsProvider.future);
  final debits = transactions.where((t) => t.type == TransactionType.debit);
  final total = debits.fold<int>(0, (sum, t) => sum + t.amount.paisa);
  return Money.fromPaisa(total);
});

/// This month's total spending
final thisMonthSpendingProvider = FutureProvider<Money>((ref) async {
  final transactions = await ref.watch(thisMonthTransactionsProvider.future);
  final debits = transactions.where((t) => t.type == TransactionType.debit);
  final total = debits.fold<int>(0, (sum, t) => sum + t.amount.paisa);
  return Money.fromPaisa(total);
});

/// Spending by category this month
final categorySpendingProvider =
    FutureProvider<Map<TransactionCategory, Money>>((ref) async {
      final transactions = await ref.watch(
        thisMonthTransactionsProvider.future,
      );
      final map = <TransactionCategory, int>{};

      for (final tx in transactions) {
        if (tx.type == TransactionType.debit) {
          map[tx.category] = (map[tx.category] ?? 0) + tx.amount.paisa;
        }
      }

      return map.map((k, v) => MapEntry(k, Money.fromPaisa(v)));
    });

/// Transaction notifier for mutations
class TransactionNotifier extends StateNotifier<AsyncValue<void>> {
  final TransactionDao _dao;

  TransactionNotifier(this._dao) : super(const AsyncValue.data(null));

  /// Add new transaction
  Future<void> addTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    try {
      await _dao.insertTransaction(transaction);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update transaction
  Future<void> updateTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    try {
      await _dao.updateTransaction(transaction);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    state = const AsyncValue.loading();
    try {
      await _dao.deleteTransaction(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update category (with learning)
  Future<void> updateCategory(
    Transaction transaction,
    TransactionCategory newCategory,
  ) async {
    final updated = transaction.copyWith(
      category: newCategory,
      categoryConfidence: 1.0, // User corrected = 100% confidence
    );
    await updateTransaction(updated);

    // Save merchant mapping for learning
    if (transaction.merchantName != null) {
      await _dao.saveMerchantMapping(transaction.merchantName!, newCategory);
    }
  }

  /// Search transactions
  Future<List<Transaction>> search(String query) async {
    return await _dao.search(query);
  }
}

/// Transaction mutation provider
final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<void>>((ref) {
      final dao = ref.watch(transactionDaoProvider);
      return TransactionNotifier(dao);
    });

/// Filter class for transactions
class TransactionFilter {
  final TransactionCategory? category;
  final String? accountId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;

  const TransactionFilter({
    this.category,
    this.accountId,
    this.startDate,
    this.endDate,
    this.limit,
  });

  TransactionFilter copyWith({
    TransactionCategory? category,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    return TransactionFilter(
      category: category ?? this.category,
      accountId: accountId ?? this.accountId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      limit: limit ?? this.limit,
    );
  }
}

/// Active filter state
final transactionFilterProvider = StateProvider<TransactionFilter?>(
  (ref) => null,
);
