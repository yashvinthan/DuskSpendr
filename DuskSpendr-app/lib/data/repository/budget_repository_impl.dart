import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../local/daos/budget_dao.dart';

/// Implementation of BudgetRepository using Drift database
class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetDao _dao;

  BudgetRepositoryImpl(this._dao);

  @override
  Stream<List<Budget>> watchBudgets() => _dao.watchActive();

  @override
  Stream<List<Budget>> watchActiveBudgets() => _dao.watchActive();

  @override
  Future<Budget?> getById(String id) => _dao.getById(id);

  @override
  Future<List<Budget>> getAll() => _dao.getAll();

  @override
  Future<Budget?> getByCategory(TransactionCategory category) {
    return _dao.getByCategory(category);
  }

  @override
  Future<void> add(Budget budget) => _dao.insertBudget(budget);

  @override
  Future<void> update(Budget budget) => _dao.updateBudget(budget);

  @override
  Future<void> delete(String id) => _dao.deleteBudget(id);

  @override
  Future<void> updateSpent(String id, Money spent) {
    return _dao.updateSpent(id, spent);
  }

  @override
  Future<void> resetSpentAmounts() => _dao.resetAllSpent();

  @override
  Future<List<Budget>> getBudgetsNearLimit() => _dao.getBudgetsAtAlert();
}
