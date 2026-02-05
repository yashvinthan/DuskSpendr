import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/search_history_store.dart';

final searchHistoryStoreProvider = Provider<SearchHistoryStore>((ref) {
  return SearchHistoryStore();
});

final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier(ref.watch(searchHistoryStoreProvider));
});

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier(this._store) : super(const []) {
    _load();
  }

  final SearchHistoryStore _store;

  Future<void> _load() async {
    state = await _store.read();
  }

  Future<void> add(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    final next = [trimmed, ...state.where((t) => t != trimmed)];
    state = next.take(8).toList();
    await _store.write(state);
  }
}
