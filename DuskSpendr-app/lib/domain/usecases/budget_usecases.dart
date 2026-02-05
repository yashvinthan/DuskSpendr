import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for managing budgets
class BudgetUseCases {
  final BudgetRepository _repository;

  BudgetUseCases(this._repository);

  /// Watch all budgets
  Stream<List<Budget>> watchBudgets() {
    return _repository.watchBudgets();
  }

  /// Watch active budgets
  Stream<List<Budget>> watchActiveBudgets() {
    return _repository.watchActiveBudgets();
  }

  /// Get all budgets
  Future<List<Budget>> getBudgets() async {
    return _repository.getAll();
  }

  /// Get budget by ID
  Future<Budget?> getBudget(String id) async {
    return _repository.getById(id);
  }

  /// Get budget for a category
  Future<Budget?> getBudgetForCategory(TransactionCategory category) async {
    return _repository.getByCategory(category);
  }

  /// Create a new budget
  Future<void> createBudget(Budget budget) async {
    await _repository.add(budget);
  }

  /// Update a budget
  Future<void> updateBudget(Budget budget) async {
    await _repository.update(budget);
  }

  /// Delete a budget
  Future<void> deleteBudget(String id) async {
    await _repository.delete(id);
  }

  /// Record spending against budget
  Future<void> recordSpending(TransactionCategory category, Money amount) async {
    final budget = await _repository.getByCategory(category);
    if (budget != null) {
      final newSpent = budget.spent + amount;
      await _repository.updateSpent(budget.id, newSpent);
    }
  }

  /// Get budgets that are near their limit
  Future<List<Budget>> getBudgetsNearLimit() async {
    return _repository.getBudgetsNearLimit();
  }

  /// Check if spending would exceed budget
  Future<BudgetCheckResult> checkBudget(
    TransactionCategory category,
    Money additionalAmount,
  ) async {
    final budget = await _repository.getByCategory(category);
    if (budget == null) {
      return BudgetCheckResult(
        hasBudget: false,
        wouldExceed: false,
        remainingAfter: Money.zero,
      );
    }

    final newSpent = budget.spent + additionalAmount;
    final wouldExceed = newSpent.paisa > budget.limit.paisa;
    final remaining = budget.limit - newSpent;
    final percentageAfter = newSpent.paisa / budget.limit.paisa;

    return BudgetCheckResult(
      hasBudget: true,
      wouldExceed: wouldExceed,
      remainingAfter: remaining,
      percentageAfter: percentageAfter,
      isNearLimit: percentageAfter >= budget.alertThreshold,
    );
  }

  /// Reset budgets for new period
  Future<void> resetBudgets() async {
    await _repository.resetSpentAmounts();
  }
}

/// Result of budget check before adding transaction
class BudgetCheckResult {
  final bool hasBudget;
  final bool wouldExceed;
  final Money remainingAfter;
  final double? percentageAfter;
  final bool isNearLimit;

  BudgetCheckResult({
    required this.hasBudget,
    required this.wouldExceed,
    required this.remainingAfter,
    this.percentageAfter,
    this.isNearLimit = false,
  });
}
