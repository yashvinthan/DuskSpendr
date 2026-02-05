import 'transaction_model.dart';

class TransactionPage {
  TransactionPage({required this.items, required this.nextOffset});

  final List<TransactionModel> items;
  final int? nextOffset;

  factory TransactionPage.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(TransactionModel.fromJson)
        .toList();
    final nextOffset = json['next_offset'] as int?;
    return TransactionPage(items: items, nextOffset: nextOffset);
  }
}
