import 'api_client.dart';

class SyncApi {
  SyncApi(this._client);

  final ApiClient _client;

  Future<void> ingestTransactions({
    required String token,
    required List<Map<String, dynamic>> items,
  }) async {
    await _client.postJson(
      '/v1/sync/transactions/ingest',
      headers: {'Authorization': 'Bearer $token'},
      body: {'items': items},
    );
  }
}
