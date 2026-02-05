import 'dart:convert';
import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';
import '../../../domain/entities/entities.dart';

part 'transaction_dao.g.dart';

/// Data Access Object for transactions
@DriftAccessor(tables: [Transactions, MerchantMappings])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// Watch all transactions (stream) with optional filters
  Stream<List<Transaction>> watchTransactions({
    TransactionCategory? category,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    var query = select(transactions);

    if (category != null) {
      query = query..where((t) => t.category.equals(category.index));
    }
    if (accountId != null) {
      query = query..where((t) => t.linkedAccountId.equals(accountId));
    }
    if (startDate != null) {
      query = query..where((t) => t.timestamp.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.timestamp.isSmallerOrEqualValue(endDate));
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);

    if (limit != null) {
      query = query..limit(limit);
    }

    return query.watch().map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Get transaction by ID
  Future<Transaction?> getById(String id) async {
    final query = select(transactions)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToEntity(row) : null;
  }

  /// Insert new transaction
  Future<void> insertTransaction(Transaction tx) async {
    await into(transactions).insert(_entityToRow(tx));
  }

  /// Update transaction
  Future<void> updateTransaction(Transaction tx) async {
    await (update(
      transactions,
    )..where((t) => t.id.equals(tx.id)))
        .write(_entityToRow(tx));
  }

  /// Delete transaction
  Future<void> deleteTransaction(String id) async {
    await (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  /// Get transactions by date range
  Future<List<Transaction>> getByDateRange(DateTime start, DateTime end) async {
    final query = select(transactions)
      ..where((t) => t.timestamp.isBiggerOrEqualValue(start))
      ..where((t) => t.timestamp.isSmallerOrEqualValue(end))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);

    final rows = await query.get();
    return rows.map(_rowToEntity).toList();
  }

  /// Get total spent for a category in date range
  Future<Money> getTotalSpentByCategory(
    TransactionCategory category, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = select(transactions)
      ..where((t) => t.category.equals(category.index))
      ..where((t) => t.type.equals(TransactionTypeDb.debit.index));

    if (startDate != null) {
      query = query..where((t) => t.timestamp.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.timestamp.isSmallerOrEqualValue(endDate));
    }

    final rows = await query.get();
    final total = rows.fold<int>(0, (sum, row) => sum + row.amountPaisa);
    return Money.fromPaisa(total);
  }

  /// Check for duplicate by reference ID
  Future<bool> existsByReferenceId(String refId) async {
    final query = select(transactions)
      ..where((t) => t.referenceId.equals(refId));
    final row = await query.getSingleOrNull();
    return row != null;
  }

  /// Check for duplicates by signature (amount + timestamp + merchant)
  Future<bool> existsBySignature({
    required int amountPaisa,
    required DateTime timestamp,
    String? merchantName,
  }) async {
    var query = select(transactions)
      ..where((t) => t.amountPaisa.equals(amountPaisa))
      ..where((t) => t.timestamp.equals(timestamp));

    if (merchantName != null && merchantName.isNotEmpty) {
      query = query..where((t) => t.merchantName.equals(merchantName));
    }

    final row = await query.getSingleOrNull();
    return row != null;
  }

  /// Search transactions by text
  Future<List<Transaction>> search(String query) async {
    final lowerQuery = '%${query.toLowerCase()}%';
    final result = await (select(transactions)
          ..where(
            (t) =>
                t.merchantName.lower().like(lowerQuery) |
                t.description.lower().like(lowerQuery) |
                t.notes.lower().like(lowerQuery),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(50))
        .get();
    return result.map(_rowToEntity).toList();
  }

  /// Save merchant category mapping (for learning)
  Future<void> saveMerchantMapping(
    String merchant,
    TransactionCategory cat,
  ) async {
    await into(merchantMappings).insertOnConflictUpdate(
      MerchantMappingsCompanion(
        merchantPattern: Value(merchant.toLowerCase()),
        category: Value(TransactionCategoryDb.values[cat.index]),
        correctionCount: const Value(1),
        lastUsed: Value(DateTime.now()),
      ),
    );
  }

  /// Get learned category for merchant
  Future<TransactionCategory?> getLearnedCategory(String merchant) async {
    final lowerMerchant = merchant.toLowerCase();
    final query = select(merchantMappings)
      ..where((m) => m.merchantPattern.equals(lowerMerchant));
    final row = await query.getSingleOrNull();
    if (row != null) {
      return TransactionCategory.values[row.category.index];
    }
    return null;
  }

  // Conversion helpers
  Transaction _rowToEntity(TransactionRow row) {
    return Transaction(
      id: row.id,
      amount: Money.fromPaisa(row.amountPaisa),
      type: TransactionType.values[row.type.index],
      category: TransactionCategory.values[row.category.index],
      merchantName: row.merchantName,
      description: row.description,
      timestamp: row.timestamp,
      source: TransactionSource.values[row.source.index],
      paymentMethod: row.paymentMethod != null
          ? PaymentMethod.values[row.paymentMethod!.index]
          : null,
      linkedAccountId: row.linkedAccountId,
      referenceId: row.referenceId,
      categoryConfidence: row.categoryConfidence,
      isRecurring: row.isRecurring,
      recurringPatternId: row.recurringPatternId,
      isShared: row.isShared,
      sharedExpenseId: row.sharedExpenseId,
      tags: (jsonDecode(row.tags) as List).cast<String>(),
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  TransactionsCompanion _entityToRow(Transaction tx) {
    return TransactionsCompanion(
      id: Value(tx.id),
      amountPaisa: Value(tx.amount.paisa),
      type: Value(TransactionTypeDb.values[tx.type.index]),
      category: Value(TransactionCategoryDb.values[tx.category.index]),
      merchantName: Value(tx.merchantName),
      description: Value(tx.description),
      timestamp: Value(tx.timestamp),
      source: Value(TransactionSourceDb.values[tx.source.index]),
      paymentMethod: tx.paymentMethod != null
          ? Value(PaymentMethodDb.values[tx.paymentMethod!.index])
          : const Value.absent(),
      linkedAccountId: Value(tx.linkedAccountId),
      referenceId: Value(tx.referenceId),
      categoryConfidence: Value(tx.categoryConfidence),
      isRecurring: Value(tx.isRecurring),
      recurringPatternId: Value(tx.recurringPatternId),
      isShared: Value(tx.isShared),
      sharedExpenseId: Value(tx.sharedExpenseId),
      tags: Value(jsonEncode(tx.tags)),
      notes: Value(tx.notes),
      createdAt: Value(tx.createdAt),
      updatedAt: Value(tx.updatedAt),
    );
  }
}
