import '../models/transaction_model.dart';
import '../models/transaction_page.dart';
import 'api_client.dart';

class TransactionsApi {
  TransactionsApi(this._client);

  final ApiClient _client;

  Future<TransactionPage> list({
    required String token,
    String? query,
    String? category,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{};
    if (query != null && query.isNotEmpty) {
      queryParams['q'] = query;
    }
    if (category != null && category.isNotEmpty && category != 'all') {
      queryParams['category'] = category;
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }
    if (offset != null) {
      queryParams['offset'] = offset.toString();
    }
    final path = queryParams.isEmpty
        ? '/v1/transactions'
        : '/v1/transactions?${Uri(queryParameters: queryParams).query}';
    final res = await _client.getJson(
      path,
      headers: {'Authorization': 'Bearer $token'},
    );
    return TransactionPage.fromJson(res);
  }

  Future<String> create({
    required String token,
    required int amountPaisa,
    required String type,
    required String category,
    required String source,
    required DateTime timestamp,
    String? merchantName,
    String? description,
  }) async {
    final res = await _client.postJson(
      '/v1/transactions',
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'amount_paisa': amountPaisa,
        'type': type,
        'category': category,
        'merchant_name': merchantName,
        'description': description,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'source': source,
        'is_recurring': false,
        'is_shared': false,
        'tags': [],
      },
    );
    return res['id'] as String;
  }

  Future<void> update({
    required String token,
    required String id,
    required int amountPaisa,
    required String type,
    required String category,
    required String source,
    required DateTime timestamp,
    String? merchantName,
    String? description,
  }) async {
    await _client.putJson(
      '/v1/transactions/$id',
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'amount_paisa': amountPaisa,
        'type': type,
        'category': category,
        'merchant_name': merchantName,
        'description': description,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'source': source,
        'is_recurring': false,
        'is_shared': false,
        'tags': [],
      },
    );
  }

  Future<void> delete({required String token, required String id}) async {
    await _client.deleteJson(
      '/v1/transactions/$id',
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
