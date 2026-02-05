import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/session_store.dart';
import '../data/models/budget_model.dart';
import '../data/models/transaction_model.dart';
import '../data/remote/api_client.dart';
import '../data/remote/budgets_api.dart';
import '../data/remote/transactions_api.dart';
import 'auth_providers.dart';

final transactionsApiProvider = Provider<TransactionsApi>((ref) {
  return TransactionsApi(ref.watch(apiClientProvider));
});

final budgetsApiProvider = Provider<BudgetsApi>((ref) {
  return BudgetsApi(ref.watch(apiClientProvider));
});

final authTokenProvider = FutureProvider<String?>((ref) async {
  final store = ref.watch(sessionStoreProvider);
  return store.readToken();
});

final transactionQueryProvider = StateProvider<String>((ref) => '');
final transactionCategoryProvider = StateProvider<String>((ref) => 'all');

final transactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final token = await ref.watch(authTokenProvider.future);
  if (token == null) return [];
  final query = ref.watch(transactionQueryProvider);
  final category = ref.watch(transactionCategoryProvider);
  final page = await ref.watch(transactionsApiProvider).list(
        token: token,
        query: query,
        category: category,
        limit: 500,
        offset: 0,
      );
  return page.items;
});

final transactionPageProvider =
    StateNotifierProvider<TransactionPageNotifier, TransactionPageState>((ref) {
  final notifier = TransactionPageNotifier(ref);
  ref.listen(transactionQueryProvider, (_, __) => notifier.refresh());
  ref.listen(transactionCategoryProvider, (_, __) => notifier.refresh());
  return notifier;
});

class TransactionPageState {
  const TransactionPageState({
    required this.items,
    required this.nextOffset,
    required this.isLoading,
    this.error,
  });

  final List<TransactionModel> items;
  final int? nextOffset;
  final bool isLoading;
  final String? error;

  TransactionPageState copyWith({
    List<TransactionModel>? items,
    int? nextOffset,
    bool? isLoading,
    String? error,
  }) {
    return TransactionPageState(
      items: items ?? this.items,
      nextOffset: nextOffset,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TransactionPageNotifier extends StateNotifier<TransactionPageState> {
  TransactionPageNotifier(this._ref)
      : super(const TransactionPageState(
          items: [],
          nextOffset: 0,
          isLoading: false,
        )) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    state = state.copyWith(items: [], nextOffset: 0, isLoading: true, error: null);
    await _loadNext();
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.nextOffset == null) return;
    await _loadNext();
  }

  Future<void> _loadNext() async {
    final token = await _ref.read(authTokenProvider.future);
    if (token == null) {
      state = state.copyWith(isLoading: false);
      return;
    }
    try {
      state = state.copyWith(isLoading: true);
      final page = await _ref.read(transactionsApiProvider).list(
            token: token,
            query: _ref.read(transactionQueryProvider),
            category: _ref.read(transactionCategoryProvider),
            limit: 50,
            offset: state.nextOffset ?? 0,
          );
      final merged = [...state.items, ...page.items];
      state = state.copyWith(
        items: merged,
        nextOffset: page.nextOffset,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final budgetsProvider = FutureProvider<List<BudgetModel>>((ref) async {
  final token = await ref.watch(authTokenProvider.future);
  if (token == null) return [];
  return ref.watch(budgetsApiProvider).list(token: token);
});
