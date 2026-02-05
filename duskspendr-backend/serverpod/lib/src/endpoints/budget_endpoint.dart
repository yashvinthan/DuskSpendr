import 'package:serverpod/serverpod.dart';

/// Budget endpoint for budget tracking and alerts
class BudgetEndpoint extends Endpoint {
  /// Get all budgets for the current user
  Future<List<Map<String, dynamic>>> getBudgets(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      '''
      SELECT id, user_id, name, category_id, amount, spent, period,
             start_date, end_date, alert_threshold, is_active, rollover,
             created_at, updated_at
      FROM budgets
      WHERE user_id = @userId AND is_active = true
      ORDER BY created_at DESC
      ''',
      parameters: {'userId': userId},
    );

    return result.map((row) => _mapBudget(row)).toList();
  }

  /// Get a single budget by ID
  Future<Map<String, dynamic>?> getBudget(
    Session session,
    int budgetId,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      '''
      SELECT id, user_id, name, category_id, amount, spent, period,
             start_date, end_date, alert_threshold, is_active, rollover,
             created_at, updated_at
      FROM budgets
      WHERE id = @id AND user_id = @userId
      ''',
      parameters: {'id': budgetId, 'userId': userId},
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapBudget(result.first);
  }

  /// Create a new budget
  Future<Map<String, dynamic>> createBudget(
    Session session, {
    required String name,
    required double amount,
    required String period,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    double alertThreshold = 0.8,
    bool rollover = false,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final now = DateTime.now();
    startDate ??= _getPeriodStart(now, period);
    endDate ??= _getPeriodEnd(now, period);

    final result = await session.db.query(
      '''
      INSERT INTO budgets (
        user_id, name, category_id, amount, spent, period,
        start_date, end_date, alert_threshold, is_active, rollover, created_at
      ) VALUES (
        @userId, @name, @categoryId, @amount, 0, @period,
        @startDate, @endDate, @alertThreshold, true, @rollover, NOW()
      )
      RETURNING id, user_id, name, category_id, amount, spent, period,
                start_date, end_date, alert_threshold, is_active, rollover,
                created_at, updated_at
      ''',
      parameters: {
        'userId': userId,
        'name': name,
        'categoryId': categoryId,
        'amount': amount,
        'period': period,
        'startDate': startDate,
        'endDate': endDate,
        'alertThreshold': alertThreshold,
        'rollover': rollover,
      },
    );

    return _mapBudget(result.first);
  }

  /// Update an existing budget
  Future<Map<String, dynamic>?> updateBudget(
    Session session,
    int budgetId, {
    String? name,
    double? amount,
    int? categoryId,
    double? alertThreshold,
    bool? isActive,
    bool? rollover,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final updates = <String>[];
    final params = <String, dynamic>{
      'id': budgetId,
      'userId': userId,
    };

    if (name != null) {
      updates.add('name = @name');
      params['name'] = name;
    }
    if (amount != null) {
      updates.add('amount = @amount');
      params['amount'] = amount;
    }
    if (categoryId != null) {
      updates.add('category_id = @categoryId');
      params['categoryId'] = categoryId;
    }
    if (alertThreshold != null) {
      updates.add('alert_threshold = @alertThreshold');
      params['alertThreshold'] = alertThreshold;
    }
    if (isActive != null) {
      updates.add('is_active = @isActive');
      params['isActive'] = isActive;
    }
    if (rollover != null) {
      updates.add('rollover = @rollover');
      params['rollover'] = rollover;
    }

    if (updates.isEmpty) {
      return await getBudget(session, budgetId);
    }

    updates.add('updated_at = NOW()');

    final result = await session.db.query(
      '''
      UPDATE budgets
      SET ${updates.join(', ')}
      WHERE id = @id AND user_id = @userId
      RETURNING id, user_id, name, category_id, amount, spent, period,
                start_date, end_date, alert_threshold, is_active, rollover,
                created_at, updated_at
      ''',
      parameters: params,
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapBudget(result.first);
  }

  /// Delete a budget
  Future<bool> deleteBudget(Session session, int budgetId) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      'DELETE FROM budgets WHERE id = @id AND user_id = @userId RETURNING id',
      parameters: {'id': budgetId, 'userId': userId},
    );

    return result.isNotEmpty;
  }

  /// Update budget spent amount
  Future<Map<String, dynamic>?> updateBudgetSpent(
    Session session,
    int budgetId,
    double spent,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      '''
      UPDATE budgets
      SET spent = @spent, updated_at = NOW()
      WHERE id = @id AND user_id = @userId
      RETURNING id, user_id, name, category_id, amount, spent, period,
                start_date, end_date, alert_threshold, is_active, rollover,
                created_at, updated_at
      ''',
      parameters: {
        'id': budgetId,
        'userId': userId,
        'spent': spent,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    final budget = _mapBudget(result.first);

    // Check if alert threshold is reached
    final percentUsed = spent / (budget['amount'] as double);
    if (percentUsed >= (budget['alertThreshold'] as double)) {
      // Send alert notification
      await session.messages.postMessage(
        'budget-alert',
        {
          'userId': userId,
          'budgetId': budgetId,
          'budgetName': budget['name'],
          'percentUsed': percentUsed,
          'spent': spent,
          'amount': budget['amount'],
        },
      );
    }

    return budget;
  }

  /// Sync budget spent amounts from transactions
  Future<List<Map<String, dynamic>>> syncBudgets(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Get all active budgets
    final budgets = await getBudgets(session);
    final updatedBudgets = <Map<String, dynamic>>[];

    for (final budget in budgets) {
      final budgetId = budget['id'] as int;
      final categoryId = budget['categoryId'] as int?;
      final startDate = budget['startDate'] as DateTime;
      final endDate = budget['endDate'] as DateTime;

      // Calculate spent amount from transactions
      final spent = await _calculateSpent(
        session,
        userId,
        categoryId,
        startDate,
        endDate,
      );

      // Update the budget
      final updated = await updateBudgetSpent(session, budgetId, spent);
      if (updated != null) {
        updatedBudgets.add(updated);
      }
    }

    return updatedBudgets;
  }

  Future<double> _calculateSpent(
    Session session,
    int userId,
    int? categoryId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    String query;
    Map<String, dynamic> params;

    if (categoryId != null) {
      query = '''
        SELECT COALESCE(SUM(ABS(amount)), 0)
        FROM transactions
        WHERE user_id = @userId
          AND category_id = @categoryId
          AND amount < 0
          AND date >= @startDate
          AND date <= @endDate
      ''';
      params = {
        'userId': userId,
        'categoryId': categoryId,
        'startDate': startDate,
        'endDate': endDate,
      };
    } else {
      query = '''
        SELECT COALESCE(SUM(ABS(amount)), 0)
        FROM transactions
        WHERE user_id = @userId
          AND amount < 0
          AND date >= @startDate
          AND date <= @endDate
      ''';
      params = {
        'userId': userId,
        'startDate': startDate,
        'endDate': endDate,
      };
    }

    final result = await session.db.query(query, parameters: params);
    return (result.first[0] as num?)?.toDouble() ?? 0.0;
  }

  DateTime _getPeriodStart(DateTime now, String period) {
    switch (period) {
      case 'daily':
        return DateTime(now.year, now.month, now.day);
      case 'weekly':
        final weekday = now.weekday;
        return DateTime(now.year, now.month, now.day - weekday + 1);
      case 'monthly':
        return DateTime(now.year, now.month, 1);
      case 'yearly':
        return DateTime(now.year, 1, 1);
      default:
        return DateTime(now.year, now.month, 1);
    }
  }

  DateTime _getPeriodEnd(DateTime now, String period) {
    switch (period) {
      case 'daily':
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case 'weekly':
        final weekday = now.weekday;
        return DateTime(now.year, now.month, now.day + (7 - weekday), 23, 59, 59);
      case 'monthly':
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case 'yearly':
        return DateTime(now.year, 12, 31, 23, 59, 59);
      default:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }
  }

  Map<String, dynamic> _mapBudget(List<dynamic> row) {
    return {
      'id': row[0],
      'userId': row[1],
      'name': row[2],
      'categoryId': row[3],
      'amount': row[4],
      'spent': row[5],
      'period': row[6],
      'startDate': row[7],
      'endDate': row[8],
      'alertThreshold': row[9],
      'isActive': row[10],
      'rollover': row[11],
      'createdAt': row[12],
      'updatedAt': row[13],
    };
  }
}
