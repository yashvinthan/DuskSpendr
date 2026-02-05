import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';
import '../../../domain/entities/entities.dart';

part 'budget_dao.g.dart';

/// Data Access Object for budgets
@DriftAccessor(tables: [Budgets])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  /// Watch all active budgets
  Stream<List<Budget>> watchActive() {
    return (select(budgets)
          ..where((b) => b.isActive.equals(true))
          ..orderBy([(b) => OrderingTerm.asc(b.name)]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Get all budgets
  Future<List<Budget>> getAll() async {
    final rows = await (select(
      budgets,
    )..orderBy([(b) => OrderingTerm.asc(b.name)]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Get budget by ID
  Future<Budget?> getById(String id) async {
    final query = select(budgets)..where((b) => b.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToEntity(row) : null;
  }

  /// Get budget by category (for category-specific budgets)
  Future<Budget?> getByCategory(TransactionCategory category) async {
    final query = select(budgets)
      ..where((b) => b.category.equals(category.index))
      ..where((b) => b.isActive.equals(true));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToEntity(row) : null;
  }

  /// Get overall budget (no category)
  Future<Budget?> getOverallBudget() async {
    final query = select(budgets)
      ..where((b) => b.category.isNull())
      ..where((b) => b.isActive.equals(true));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToEntity(row) : null;
  }

  /// Insert budget
  Future<void> insertBudget(Budget budget) async {
    await into(budgets).insert(_entityToRow(budget));
  }

  /// Update budget
  Future<void> updateBudget(Budget budget) async {
    await (update(
      budgets,
    )..where((b) => b.id.equals(budget.id)))
        .write(_entityToRow(budget));
  }

  /// Update spent amount
  Future<void> updateSpent(String id, Money spent) async {
    await (update(budgets)..where((b) => b.id.equals(id))).write(
      BudgetsCompanion(
        spentPaisa: Value(spent.paisa),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Add to spent amount
  Future<void> addToSpent(String id, Money amount) async {
    final budget = await getById(id);
    if (budget != null) {
      final newSpent = budget.spent + amount;
      await updateSpent(id, newSpent);
    }
  }

  /// Reset spent for period rollover
  Future<void> resetSpent(String id) async {
    await updateSpent(id, Money.zero);
  }

  /// Reset all budgets (for period rollover)
  Future<void> resetAllSpent() async {
    await (update(budgets)..where((b) => b.isActive.equals(true))).write(
      BudgetsCompanion(
        spentPaisa: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete budget
  Future<void> deleteBudget(String id) async {
    await (delete(budgets)..where((b) => b.id.equals(id))).go();
  }

  /// Deactivate budget
  Future<void> deactivateBudget(String id) async {
    await (update(budgets)..where((b) => b.id.equals(id))).write(
      BudgetsCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Get budgets over alert threshold
  Future<List<Budget>> getBudgetsAtAlert() async {
    final all = await getAll();
    return all.where((b) => b.isActive && b.isAtAlertThreshold).toList();
  }

  // Conversion helpers
  Budget _rowToEntity(BudgetData row) {
    return Budget(
      id: row.id,
      name: row.name,
      limit: Money.fromPaisa(row.limitPaisa),
      spent: Money.fromPaisa(row.spentPaisa),
      period: BudgetPeriod.values[row.period.index],
      category: row.category != null
          ? TransactionCategory.values[row.category!.index]
          : null,
      alertThreshold: row.alertThreshold,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  BudgetsCompanion _entityToRow(Budget budget) {
    return BudgetsCompanion(
      id: Value(budget.id),
      name: Value(budget.name),
      limitPaisa: Value(budget.limit.paisa),
      spentPaisa: Value(budget.spent.paisa),
      period: Value(BudgetPeriodDb.values[budget.period.index]),
      category: budget.category != null
          ? Value(TransactionCategoryDb.values[budget.category!.index])
          : const Value.absent(),
      alertThreshold: Value(budget.alertThreshold),
      isActive: Value(budget.isActive),
      createdAt: Value(budget.createdAt),
      updatedAt: Value(budget.updatedAt),
    );
  }
}
