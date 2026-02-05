import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for managing transactions
class TransactionUseCases {
  final TransactionRepository _repository;

  TransactionUseCases(this._repository);

  /// Watch transactions with filters
  Stream<List<Transaction>> watchTransactions({
    TransactionCategory? category,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    return _repository.watchTransactions(
      category: category,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  /// Get today's transactions
  Stream<List<Transaction>> watchTodayTransactions() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return _repository.watchTransactions(
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }

  /// Get this month's transactions
  Stream<List<Transaction>> watchMonthTransactions() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    return _repository.watchTransactions(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );
  }

  /// Add a new transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _repository.add(transaction);
  }

  /// Update a transaction
  Future<void> updateTransaction(Transaction transaction) async {
    await _repository.update(transaction);
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String id) async {
    await _repository.delete(id);
  }

  /// Search transactions
  Future<List<Transaction>> searchTransactions(String query) async {
    return _repository.search(query);
  }

  /// Get spending by category for date range
  Future<Map<TransactionCategory, Money>> getSpendingByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = <TransactionCategory, Money>{};
    for (final category in TransactionCategory.values) {
      final total = await _repository.getTotalSpentByCategory(
        category,
        startDate: startDate,
        endDate: endDate,
      );
      if (total.paisa > 0) {
        result[category] = total;
      }
    }
    return result;
  }

  /// Check for duplicate transaction
  Future<bool> isDuplicate(String referenceId) async {
    return _repository.existsByReferenceId(referenceId);
  }

  /// Learn category for merchant
  Future<void> learnMerchantCategory(
    String merchant,
    TransactionCategory category,
  ) async {
    await _repository.saveMerchantMapping(merchant, category);
  }

  /// Suggest category for merchant
  Future<TransactionCategory?> suggestCategory(String merchant) async {
    return _repository.getLearnedCategory(merchant);
  }
}
