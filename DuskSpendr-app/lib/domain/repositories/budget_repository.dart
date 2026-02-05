import '../entities/entities.dart';

/// Repository interface for budget operations
abstract class BudgetRepository {
  /// Watch all budgets
  Stream<List<Budget>> watchBudgets();

  /// Watch active budgets only
  Stream<List<Budget>> watchActiveBudgets();

  /// Get a single budget by ID
  Future<Budget?> getById(String id);

  /// Get all budgets
  Future<List<Budget>> getAll();

  /// Get budget for a specific category
  Future<Budget?> getByCategory(TransactionCategory category);

  /// Add a new budget
  Future<void> add(Budget budget);

  /// Update an existing budget
  Future<void> update(Budget budget);

  /// Delete a budget
  Future<void> delete(String id);

  /// Update spent amount for a budget
  Future<void> updateSpent(String id, Money spent);

  /// Reset spent amount for all budgets (new period)
  Future<void> resetSpentAmounts();

  /// Get budgets approaching their limits (> threshold)
  Future<List<Budget>> getBudgetsNearLimit();
}
