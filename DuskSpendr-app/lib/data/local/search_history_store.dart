import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchHistoryStore {
  static const _key = 'transaction_search_history_v1';

  final FlutterSecureStorage _storage;

  SearchHistoryStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<List<String>> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<String>();
    return list;
  }

  Future<void> write(List<String> items) async {
    await _storage.write(key: _key, value: jsonEncode(items));
  }
}
