import '../models/budget_model.dart';
import 'api_client.dart';

class BudgetsApi {
  BudgetsApi(this._client);

  final ApiClient _client;

  Future<List<BudgetModel>> list({required String token}) async {
    final res = await _client.getJson(
      '/v1/budgets',
      headers: {'Authorization': 'Bearer $token'},
    );
    final items = (res['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return items.map(BudgetModel.fromJson).toList();
  }

  Future<String> create({
    required String token,
    required String name,
    required int limitPaisa,
    required String period,
    String? category,
  }) async {
    final res = await _client.postJson(
      '/v1/budgets',
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'name': name,
        'limit_paisa': limitPaisa,
        'period': period,
        'category': category,
      },
    );
    return res['id'] as String;
  }

  Future<void> update({
    required String token,
    required String id,
    required String name,
    required int limitPaisa,
    required String period,
    String? category,
  }) async {
    await _client.putJson(
      '/v1/budgets/$id',
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'name': name,
        'limit_paisa': limitPaisa,
        'period': period,
        'category': category,
      },
    );
  }
}
