import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'category.dart';
import 'money.dart';

/// Transaction entity representing a financial transaction
class Transaction extends Equatable {
  final String id;
  final Money amount;
  final TransactionType type;
  final TransactionCategory category;
  final String? merchantName;
  final String? description;
  final DateTime timestamp;
  final TransactionSource source;
  final PaymentMethod? paymentMethod;
  final String? linkedAccountId;
  final String? referenceId; // UPI ref, bank ref, etc.
  final double? categoryConfidence; // 0.0 - 1.0
  final bool isRecurring;
  final String? recurringPatternId;
  final bool isShared;
  final String? sharedExpenseId;
  final List<String> tags;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    String? id,
    required this.amount,
    required this.type,
    required this.category,
    this.merchantName,
    this.description,
    required this.timestamp,
    required this.source,
    this.paymentMethod,
    this.linkedAccountId,
    this.referenceId,
    this.categoryConfidence,
    this.isRecurring = false,
    this.recurringPatternId,
    this.isShared = false,
    this.sharedExpenseId,
    this.tags = const [],
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Create a copy with updated fields
  Transaction copyWith({
    String? id,
    Money? amount,
    TransactionType? type,
    TransactionCategory? category,
    String? merchantName,
    String? description,
    DateTime? timestamp,
    TransactionSource? source,
    PaymentMethod? paymentMethod,
    String? linkedAccountId,
    String? referenceId,
    double? categoryConfidence,
    bool? isRecurring,
    String? recurringPatternId,
    bool? isShared,
    String? sharedExpenseId,
    List<String>? tags,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      merchantName: merchantName ?? this.merchantName,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      referenceId: referenceId ?? this.referenceId,
      categoryConfidence: categoryConfidence ?? this.categoryConfidence,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPatternId: recurringPatternId ?? this.recurringPatternId,
      isShared: isShared ?? this.isShared,
      sharedExpenseId: sharedExpenseId ?? this.sharedExpenseId,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Display title (merchant name or description or category)
  String get displayTitle => merchantName ?? description ?? category.label;

  /// Check if category was auto-assigned with high confidence
  bool get isHighConfidenceCategory =>
      categoryConfidence != null && categoryConfidence! >= 0.85;

  /// Check if this needs user review for category
  bool get needsCategoryReview =>
      categoryConfidence != null && categoryConfidence! < 0.6;

  @override
  List<Object?> get props => [
    id,
    amount.paisa,
    type,
    category,
    merchantName,
    description,
    timestamp,
    source,
    paymentMethod,
    linkedAccountId,
    referenceId,
    categoryConfidence,
    isRecurring,
    isShared,
    tags,
    notes,
  ];

  @override
  String toString() =>
      'Transaction($id, ${type.name}: ${amount.formatted}, $category)';
}
