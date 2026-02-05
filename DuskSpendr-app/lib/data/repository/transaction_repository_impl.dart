import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../local/daos/transaction_dao.dart';

/// Implementation of TransactionRepository using Drift database
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDao _dao;

  TransactionRepositoryImpl(this._dao);

  @override
  Stream<List<Transaction>> watchTransactions({
    TransactionCategory? category,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    return _dao.watchTransactions(
      category: category,
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  @override
  Future<Transaction?> getById(String id) => _dao.getById(id);

  @override
  Future<List<Transaction>> getByDateRange(DateTime start, DateTime end) {
    return _dao.getByDateRange(start, end);
  }

  @override
  Future<void> add(Transaction transaction) {
    return _dao.insertTransaction(transaction);
  }

  @override
  Future<void> update(Transaction transaction) {
    return _dao.updateTransaction(transaction);
  }

  @override
  Future<void> delete(String id) => _dao.deleteTransaction(id);

  @override
  Future<List<Transaction>> search(String query) => _dao.search(query);

  @override
  Future<bool> existsByReferenceId(String refId) {
    return _dao.existsByReferenceId(refId);
  }

  @override
  Future<Money> getTotalSpentByCategory(
    TransactionCategory category, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _dao.getTotalSpentByCategory(
      category,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<void> saveMerchantMapping(String merchant, TransactionCategory category) {
    return _dao.saveMerchantMapping(merchant, category);
  }

  @override
  Future<TransactionCategory?> getLearnedCategory(String merchant) {
    return _dao.getLearnedCategory(merchant);
  }
}
