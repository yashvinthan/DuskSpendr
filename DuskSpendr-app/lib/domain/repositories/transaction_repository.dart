import '../entities/entities.dart';

/// Repository interface for transaction operations
abstract class TransactionRepository {
  /// Watch all transactions with optional filters
  Stream<List<Transaction>> watchTransactions({
    TransactionCategory? category,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  /// Get a single transaction by ID
  Future<Transaction?> getById(String id);

  /// Get transactions by date range
  Future<List<Transaction>> getByDateRange(DateTime start, DateTime end);

  /// Add a new transaction
  Future<void> add(Transaction transaction);

  /// Update an existing transaction
  Future<void> update(Transaction transaction);

  /// Delete a transaction
  Future<void> delete(String id);

  /// Search transactions by text
  Future<List<Transaction>> search(String query);

  /// Check if transaction exists by reference ID
  Future<bool> existsByReferenceId(String refId);

  /// Get total spent for a category in date range
  Future<Money> getTotalSpentByCategory(
    TransactionCategory category, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Save learned merchant category mapping
  Future<void> saveMerchantMapping(String merchant, TransactionCategory category);

  /// Get learned category for merchant
  Future<TransactionCategory?> getLearnedCategory(String merchant);
}
