class BudgetModel {
  BudgetModel({
    required this.id,
    required this.name,
    required this.limitPaisa,
    required this.spentPaisa,
    required this.period,
    required this.alertThreshold,
    required this.isActive,
    this.category,
  });

  final String id;
  final String name;
  final int limitPaisa;
  final int spentPaisa;
  final String period;
  final double alertThreshold;
  final bool isActive;
  final String? category;

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      limitPaisa: (json['limit_paisa'] as num).toInt(),
      spentPaisa: (json['spent_paisa'] as num).toInt(),
      period: json['period'] as String,
      alertThreshold: (json['alert_threshold'] as num?)?.toDouble() ?? 0.8,
      isActive: json['is_active'] as bool? ?? true,
      category: json['category'] as String?,
    );
  }

  double get progress {
    if (limitPaisa == 0) return 0;
    return spentPaisa / limitPaisa;
  }

  bool get isExceeded => progress >= 1;

  bool get isWarning => progress >= alertThreshold && progress < 1;
}
