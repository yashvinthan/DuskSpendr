class TransactionModel {
  TransactionModel({
    required this.id,
    required this.amountPaisa,
    required this.type,
    required this.category,
    required this.timestamp,
    required this.source,
    this.merchantName,
    this.description,
  });

  final String id;
  final int amountPaisa;
  final String type;
  final String category;
  final DateTime timestamp;
  final String source;
  final String? merchantName;
  final String? description;

  late final String lowerCategory = category.toLowerCase();
  late final String? lowerMerchantName = merchantName?.toLowerCase();

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amountPaisa: (json['amount_paisa'] as num).toInt(),
      type: json['type'] as String,
      category: json['category'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: json['source'] as String,
      merchantName: json['merchant_name'] as String?,
      description: json['description'] as String?,
    );
  }

  String get amountLabel {
    final value = (amountPaisa / 100).toStringAsFixed(2);
    return (type == 'credit') ? '+₹$value' : '-₹$value';
  }
}
