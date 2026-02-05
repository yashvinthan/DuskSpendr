import 'package:serverpod/serverpod.dart';

import '../util/serverpod_helpers.dart';
/// Export endpoint for data portability
class ExportEndpoint extends Endpoint {
  /// Export all user data as JSON
  Future<Map<String, dynamic>> exportAllData(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final profile = await _exportProfile(session, userId);
    final transactions = await _exportTransactions(session, userId);
    final budgets = await _exportBudgets(session, userId);
    final accounts = await _exportAccounts(session, userId);
    final splits = await _exportSplits(session, userId);

    return {
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
      'user': profile,
      'transactions': transactions,
      'budgets': budgets,
      'accounts': accounts,
      'splits': splits,
      'metadata': {
        'transactionCount': transactions.length,
        'budgetCount': budgets.length,
        'accountCount': accounts.length,
        'splitCount': splits.length,
      },
    };
  }

  /// Export transactions only
  Future<List<Map<String, dynamic>>> exportTransactions(
    Session session, {
    DateTime? startDate,
    DateTime? endDate,
    String? format,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    return await _exportTransactions(
      session,
      userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Export as CSV string
  Future<String> exportTransactionsCsv(
    Session session, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final transactions = await _exportTransactions(
      session,
      userId,
      startDate: startDate,
      endDate: endDate,
    );

    // Build CSV
    final buffer = StringBuffer();
    buffer.writeln('Date,Amount,Merchant,Category,Description,Account,Source');

    for (final tx in transactions) {
      final date = tx['date'] as DateTime;
      final amount = tx['amount'] as double;
      final merchant = _escapeCsv(tx['merchantName'] as String? ?? '');
      final category = _escapeCsv(tx['categoryName'] as String? ?? '');
      final description = _escapeCsv(tx['description'] as String? ?? '');
      final account = _escapeCsv(tx['accountName'] as String? ?? '');
      final source = tx['source'] as String? ?? '';

      buffer.writeln('${date.toIso8601String()},$amount,$merchant,$category,$description,$account,$source');
    }

    return buffer.toString();
  }

  /// Export budgets
  Future<List<Map<String, dynamic>>> exportBudgets(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    return await _exportBudgets(session, userId);
  }

  /// Request data deletion (GDPR right to erasure)
  Future<Map<String, dynamic>> requestDataDeletion(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Create deletion request (processed async)
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    await session.query(
      '''
      INSERT INTO deletion_requests (id, user_id, status, requested_at)
      VALUES (@requestId, @userId, 'pending', NOW())
      ON CONFLICT (user_id) DO UPDATE SET status = 'pending', requested_at = NOW()
      ''',
      parameters: {
        'requestId': requestId,
        'userId': userId,
      },
    );

    // Send notification to admin
    session.messages.postMessage(
      'admin-notification',
      JsonMessage({
        'type': 'deletion_request',
        'userId': userId,
        'requestId': requestId,
      }),
    );

    return {
      'requestId': requestId,
      'status': 'pending',
      'message': 'Your data deletion request has been submitted. You will receive confirmation within 30 days.',
    };
  }

  /// Get data deletion request status
  Future<Map<String, dynamic>?> getDeletionStatus(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.query(
      '''
      SELECT id, status, requested_at, completed_at
      FROM deletion_requests
      WHERE user_id = @userId
      ORDER BY requested_at DESC
      LIMIT 1
      ''',
      parameters: {'userId': userId},
    );

    if (result.isEmpty) {
      return null;
    }

    final row = result.first;
    return {
      'requestId': row[0],
      'status': row[1],
      'requestedAt': row[2],
      'completedAt': row[3],
    };
  }

  // Private helper methods

  Future<Map<String, dynamic>> _exportProfile(
    Session session,
    int userId,
  ) async {
    final result = await session.query(
      '''
      SELECT id, phone, email, display_name, avatar_url, preferences, created_at
      FROM users
      WHERE id = @userId
      ''',
      parameters: {'userId': userId},
    );

    if (result.isEmpty) {
      return {};
    }

    final row = result.first;
    return {
      'id': row[0],
      'phone': row[1],
      'email': row[2],
      'displayName': row[3],
      'avatarUrl': row[4],
      'preferences': row[5],
      'createdAt': (row[6] as DateTime).toIso8601String(),
    };
  }

  Future<List<Map<String, dynamic>>> _exportTransactions(
    Session session,
    int userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final conditions = <String>['t.user_id = @userId'];
    final params = <String, dynamic>{'userId': userId};

    if (startDate != null) {
      conditions.add('t.date >= @startDate');
      params['startDate'] = startDate;
    }
    if (endDate != null) {
      conditions.add('t.date <= @endDate');
      params['endDate'] = endDate;
    }

    final result = await session.query(
      '''
      SELECT t.id, t.amount, t.merchant_name, t.description, t.date, t.source,
             t.is_recurring, t.tags, t.location, t.created_at,
             c.name as category_name, a.name as account_name
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      LEFT JOIN accounts a ON t.account_id = a.id
      WHERE ${conditions.join(' AND ')}
      ORDER BY t.date DESC
      ''',
      parameters: params,
    );

    return result.map((row) => {
      'id': row[0],
      'amount': row[1],
      'merchantName': row[2],
      'description': row[3],
      'date': (row[4] as DateTime).toIso8601String(),
      'source': row[5],
      'isRecurring': row[6],
      'tags': row[7],
      'location': row[8],
      'createdAt': (row[9] as DateTime).toIso8601String(),
      'categoryName': row[10],
      'accountName': row[11],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _exportBudgets(
    Session session,
    int userId,
  ) async {
    final result = await session.query(
      '''
      SELECT b.id, b.name, b.amount, b.spent, b.period, b.start_date, b.end_date,
             b.alert_threshold, b.is_active, b.rollover, b.created_at,
             c.name as category_name
      FROM budgets b
      LEFT JOIN categories c ON b.category_id = c.id
      WHERE b.user_id = @userId
      ORDER BY b.created_at DESC
      ''',
      parameters: {'userId': userId},
    );

    return result.map((row) => {
      'id': row[0],
      'name': row[1],
      'amount': row[2],
      'spent': row[3],
      'period': row[4],
      'startDate': (row[5] as DateTime).toIso8601String(),
      'endDate': row[6] != null ? (row[6] as DateTime).toIso8601String() : null,
      'alertThreshold': row[7],
      'isActive': row[8],
      'rollover': row[9],
      'createdAt': (row[10] as DateTime).toIso8601String(),
      'categoryName': row[11],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _exportAccounts(
    Session session,
    int userId,
  ) async {
    final result = await session.query(
      '''
      SELECT id, name, type, balance, currency, institution, is_default, created_at
      FROM accounts
      WHERE user_id = @userId
      ORDER BY created_at DESC
      ''',
      parameters: {'userId': userId},
    );

    return result.map((row) => {
      'id': row[0],
      'name': row[1],
      'type': row[2],
      'balance': row[3],
      'currency': row[4],
      'institution': row[5],
      'isDefault': row[6],
      'createdAt': (row[7] as DateTime).toIso8601String(),
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _exportSplits(
    Session session,
    int userId,
  ) async {
    final result = await session.query(
      '''
      SELECT s.id, s.total_amount, s.description, s.status, s.created_at, s.settled_at
      FROM splits s
      WHERE s.creator_id = @userId
      ORDER BY s.created_at DESC
      ''',
      parameters: {'userId': userId},
    );

    final splits = <Map<String, dynamic>>[];
    for (final row in result) {
      final splitId = row[0] as int;
      final participants = await session.query(
        '''
        SELECT name, phone, email, amount, is_paid
        FROM split_participants
        WHERE split_id = @splitId
        ''',
        parameters: {'splitId': splitId},
      );

      splits.add({
        'id': splitId,
        'totalAmount': row[1],
        'description': row[2],
        'status': row[3],
        'createdAt': (row[4] as DateTime).toIso8601String(),
        'settledAt': row[5] != null ? (row[5] as DateTime).toIso8601String() : null,
        'participants': participants.map((p) => {
          'name': p[0],
          'phone': p[1],
          'email': p[2],
          'amount': p[3],
          'isPaid': p[4],
        }).toList(),
      });
    }

    return splits;
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
