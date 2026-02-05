import 'package:serverpod/serverpod.dart';

/// Transaction endpoint for CRUD operations
class TransactionEndpoint extends Endpoint {
  /// Get transactions with optional filters
  Future<List<Map<String, dynamic>>> getTransactions(
    Session session, {
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    String? source,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final conditions = <String>['user_id = @userId'];
    final params = <String, dynamic>{
      'userId': userId,
      'limit': limit ?? 50,
      'offset': offset ?? 0,
    };

    if (startDate != null) {
      conditions.add('date >= @startDate');
      params['startDate'] = startDate;
    }
    if (endDate != null) {
      conditions.add('date <= @endDate');
      params['endDate'] = endDate;
    }
    if (categoryId != null) {
      conditions.add('category_id = @categoryId');
      params['categoryId'] = categoryId;
    }
    if (source != null) {
      conditions.add('source = @source');
      params['source'] = source;
    }

    final result = await session.db.query(
      '''
      SELECT id, user_id, amount, merchant_name, category_id, subcategory_id,
             description, date, source, account_id, is_recurring, recurring_id,
             tags, location, latitude, longitude, created_at, updated_at
      FROM transactions
      WHERE ${conditions.join(' AND ')}
      ORDER BY date DESC
      LIMIT @limit OFFSET @offset
      ''',
      parameters: params,
    );

    return result.map((row) => _mapTransaction(row)).toList();
  }

  /// Get a single transaction by ID
  Future<Map<String, dynamic>?> getTransaction(
    Session session,
    int transactionId,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      '''
      SELECT id, user_id, amount, merchant_name, category_id, subcategory_id,
             description, date, source, account_id, is_recurring, recurring_id,
             tags, location, latitude, longitude, created_at, updated_at
      FROM transactions
      WHERE id = @id AND user_id = @userId
      ''',
      parameters: {'id': transactionId, 'userId': userId},
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapTransaction(result.first);
  }

  /// Create a new transaction
  Future<Map<String, dynamic>> createTransaction(
    Session session, {
    required double amount,
    required DateTime date,
    required String source,
    String? merchantName,
    int? categoryId,
    int? subcategoryId,
    String? description,
    int? accountId,
    bool isRecurring = false,
    int? recurringId,
    List<String>? tags,
    String? location,
    double? latitude,
    double? longitude,
    String? smsHash,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      '''
      INSERT INTO transactions (
        user_id, amount, merchant_name, category_id, subcategory_id,
        description, date, source, account_id, is_recurring, recurring_id,
        tags, location, latitude, longitude, sms_hash, created_at
      ) VALUES (
        @userId, @amount, @merchantName, @categoryId, @subcategoryId,
        @description, @date, @source, @accountId, @isRecurring, @recurringId,
        @tags, @location, @latitude, @longitude, @smsHash, NOW()
      )
      RETURNING id, user_id, amount, merchant_name, category_id, subcategory_id,
                description, date, source, account_id, is_recurring, recurring_id,
                tags, location, latitude, longitude, created_at, updated_at
      ''',
      parameters: {
        'userId': userId,
        'amount': amount,
        'merchantName': merchantName,
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'description': description,
        'date': date,
        'source': source,
        'accountId': accountId,
        'isRecurring': isRecurring,
        'recurringId': recurringId,
        'tags': tags,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'smsHash': smsHash,
      },
    );

    // Trigger AI categorization if no category provided
    if (categoryId == null && result.isNotEmpty) {
      final transactionId = result.first[0] as int;
      await session.messages.postMessage(
        'ai-categorization',
        {
          'transactionId': transactionId,
          'merchantName': merchantName,
          'amount': amount,
        },
      );
    }

    return _mapTransaction(result.first);
  }

  /// Update an existing transaction
  Future<Map<String, dynamic>?> updateTransaction(
    Session session,
    int transactionId, {
    double? amount,
    String? merchantName,
    int? categoryId,
    int? subcategoryId,
    String? description,
    DateTime? date,
    int? accountId,
    bool? isRecurring,
    List<String>? tags,
    String? location,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final updates = <String>[];
    final params = <String, dynamic>{
      'id': transactionId,
      'userId': userId,
    };

    if (amount != null) {
      updates.add('amount = @amount');
      params['amount'] = amount;
    }
    if (merchantName != null) {
      updates.add('merchant_name = @merchantName');
      params['merchantName'] = merchantName;
    }
    if (categoryId != null) {
      updates.add('category_id = @categoryId');
      params['categoryId'] = categoryId;
    }
    if (subcategoryId != null) {
      updates.add('subcategory_id = @subcategoryId');
      params['subcategoryId'] = subcategoryId;
    }
    if (description != null) {
      updates.add('description = @description');
      params['description'] = description;
    }
    if (date != null) {
      updates.add('date = @date');
      params['date'] = date;
    }
    if (accountId != null) {
      updates.add('account_id = @accountId');
      params['accountId'] = accountId;
    }
    if (isRecurring != null) {
      updates.add('is_recurring = @isRecurring');
      params['isRecurring'] = isRecurring;
    }
    if (tags != null) {
      updates.add('tags = @tags');
      params['tags'] = tags;
    }
    if (location != null) {
      updates.add('location = @location');
      params['location'] = location;
    }

    if (updates.isEmpty) {
      return await getTransaction(session, transactionId);
    }

    updates.add('updated_at = NOW()');

    final result = await session.db.query(
      '''
      UPDATE transactions
      SET ${updates.join(', ')}
      WHERE id = @id AND user_id = @userId
      RETURNING id, user_id, amount, merchant_name, category_id, subcategory_id,
                description, date, source, account_id, is_recurring, recurring_id,
                tags, location, latitude, longitude, created_at, updated_at
      ''',
      parameters: params,
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapTransaction(result.first);
  }

  /// Delete a transaction
  Future<bool> deleteTransaction(Session session, int transactionId) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      'DELETE FROM transactions WHERE id = @id AND user_id = @userId RETURNING id',
      parameters: {'id': transactionId, 'userId': userId},
    );

    return result.isNotEmpty;
  }

  /// Bulk create transactions (for sync)
  Future<List<Map<String, dynamic>>> bulkCreateTransactions(
    Session session,
    List<Map<String, dynamic>> transactions,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final results = <Map<String, dynamic>>[];

    for (final tx in transactions) {
      try {
        final result = await createTransaction(
          session,
          amount: tx['amount'] as double,
          date: DateTime.parse(tx['date'] as String),
          source: tx['source'] as String? ?? 'sync',
          merchantName: tx['merchantName'] as String?,
          categoryId: tx['categoryId'] as int?,
          description: tx['description'] as String?,
          smsHash: tx['smsHash'] as String?,
        );
        results.add(result);
      } catch (e) {
        // Skip duplicates (sms_hash conflict)
        continue;
      }
    }

    return results;
  }

  /// Get transaction statistics
  Future<Map<String, dynamic>> getTransactionStats(
    Session session, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    startDate ??= DateTime.now().subtract(const Duration(days: 30));
    endDate ??= DateTime.now();

    final result = await session.db.query(
      '''
      SELECT 
        COUNT(*) as total_count,
        SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) as total_spent,
        SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) as total_income,
        AVG(CASE WHEN amount < 0 THEN ABS(amount) ELSE NULL END) as avg_expense
      FROM transactions
      WHERE user_id = @userId
        AND date >= @startDate
        AND date <= @endDate
      ''',
      parameters: {
        'userId': userId,
        'startDate': startDate,
        'endDate': endDate,
      },
    );

    if (result.isEmpty) {
      return {
        'totalCount': 0,
        'totalSpent': 0.0,
        'totalIncome': 0.0,
        'averageExpense': 0.0,
      };
    }

    final row = result.first;
    return {
      'totalCount': row[0] ?? 0,
      'totalSpent': row[1] ?? 0.0,
      'totalIncome': row[2] ?? 0.0,
      'averageExpense': row[3] ?? 0.0,
    };
  }

  Map<String, dynamic> _mapTransaction(List<dynamic> row) {
    return {
      'id': row[0],
      'userId': row[1],
      'amount': row[2],
      'merchantName': row[3],
      'categoryId': row[4],
      'subcategoryId': row[5],
      'description': row[6],
      'date': row[7],
      'source': row[8],
      'accountId': row[9],
      'isRecurring': row[10],
      'recurringId': row[11],
      'tags': row[12],
      'location': row[13],
      'latitude': row[14],
      'longitude': row[15],
      'createdAt': row[16],
      'updatedAt': row[17],
    };
  }
}
