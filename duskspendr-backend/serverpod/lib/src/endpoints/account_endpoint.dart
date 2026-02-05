import 'package:serverpod/serverpod.dart';

import '../util/serverpod_helpers.dart';

/// Account endpoint for managing financial accounts
class AccountEndpoint extends Endpoint {
  /// Get all accounts for the current user
  Future<List<Map<String, dynamic>>> getAccounts(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.query(
      '''
      SELECT id, user_id, name, type, balance, currency, institution,
             account_number, is_default, icon, color, created_at, updated_at
      FROM accounts
      WHERE user_id = @userId
      ORDER BY is_default DESC, created_at DESC
      ''',
      parameters: {'userId': userId},
    );

    return result.map((row) => _mapAccount(row)).toList();
  }

  /// Get a single account by ID
  Future<Map<String, dynamic>?> getAccount(
    Session session,
    int accountId,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.query(
      '''
      SELECT id, user_id, name, type, balance, currency, institution,
             account_number, is_default, icon, color, created_at, updated_at
      FROM accounts
      WHERE id = @id AND user_id = @userId
      ''',
      parameters: {'id': accountId, 'userId': userId},
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapAccount(result.first);
  }

  /// Create a new account
  Future<Map<String, dynamic>> createAccount(
    Session session, {
    required String name,
    required String type,
    required String currency,
    double balance = 0,
    String? institution,
    String? accountNumber,
    bool isDefault = false,
    String? icon,
    String? color,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // If this is default, unset any existing default
    if (isDefault) {
      await session.query(
        'UPDATE accounts SET is_default = false WHERE user_id = @userId',
        parameters: {'userId': userId},
      );
    }

    final result = await session.query(
      '''
      INSERT INTO accounts (
        user_id, name, type, balance, currency, institution,
        account_number, is_default, icon, color, created_at
      ) VALUES (
        @userId, @name, @type, @balance, @currency, @institution,
        @accountNumber, @isDefault, @icon, @color, NOW()
      )
      RETURNING id, user_id, name, type, balance, currency, institution,
                account_number, is_default, icon, color, created_at, updated_at
      ''',
      parameters: {
        'userId': userId,
        'name': name,
        'type': type,
        'balance': balance,
        'currency': currency,
        'institution': institution,
        'accountNumber': accountNumber,
        'isDefault': isDefault,
        'icon': icon,
        'color': color,
      },
    );

    return _mapAccount(result.first);
  }

  /// Update an existing account
  Future<Map<String, dynamic>?> updateAccount(
    Session session,
    int accountId, {
    String? name,
    String? type,
    double? balance,
    String? currency,
    String? institution,
    String? accountNumber,
    bool? isDefault,
    String? icon,
    String? color,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final updates = <String>[];
    final params = <String, dynamic>{
      'id': accountId,
      'userId': userId,
    };

    if (name != null) {
      updates.add('name = @name');
      params['name'] = name;
    }
    if (type != null) {
      updates.add('type = @type');
      params['type'] = type;
    }
    if (balance != null) {
      updates.add('balance = @balance');
      params['balance'] = balance;
    }
    if (currency != null) {
      updates.add('currency = @currency');
      params['currency'] = currency;
    }
    if (institution != null) {
      updates.add('institution = @institution');
      params['institution'] = institution;
    }
    if (accountNumber != null) {
      updates.add('account_number = @accountNumber');
      params['accountNumber'] = accountNumber;
    }
    if (isDefault != null) {
      // If setting as default, unset others first
      if (isDefault) {
        await session.query(
          'UPDATE accounts SET is_default = false WHERE user_id = @userId',
          parameters: {'userId': userId},
        );
      }
      updates.add('is_default = @isDefault');
      params['isDefault'] = isDefault;
    }
    if (icon != null) {
      updates.add('icon = @icon');
      params['icon'] = icon;
    }
    if (color != null) {
      updates.add('color = @color');
      params['color'] = color;
    }

    if (updates.isEmpty) {
      return await getAccount(session, accountId);
    }

    updates.add('updated_at = NOW()');

    final result = await session.query(
      '''
      UPDATE accounts
      SET ${updates.join(', ')}
      WHERE id = @id AND user_id = @userId
      RETURNING id, user_id, name, type, balance, currency, institution,
                account_number, is_default, icon, color, created_at, updated_at
      ''',
      parameters: params,
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapAccount(result.first);
  }

  /// Update account balance
  Future<Map<String, dynamic>?> updateBalance(
    Session session,
    int accountId,
    double balance,
  ) async {
    return await updateAccount(session, accountId, balance: balance);
  }

  /// Delete an account
  Future<bool> deleteAccount(Session session, int accountId) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Check if account has transactions
    final txResult = await session.query(
      'SELECT COUNT(*) FROM transactions WHERE account_id = @accountId',
      parameters: {'accountId': accountId},
    );

    final txCount = txResult.first[0] as int;
    if (txCount > 0) {
      throw Exception('Cannot delete account with transactions. Transfer transactions first.');
    }

    final result = await session.query(
      'DELETE FROM accounts WHERE id = @id AND user_id = @userId RETURNING id',
      parameters: {'id': accountId, 'userId': userId},
    );

    return result.isNotEmpty;
  }

  /// Get account balance summary
  Future<Map<String, dynamic>> getBalanceSummary(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.query(
      '''
      SELECT 
        COALESCE(SUM(balance), 0) as total_balance,
        COALESCE(SUM(CASE WHEN balance > 0 THEN balance ELSE 0 END), 0) as positive_balance,
        COALESCE(SUM(CASE WHEN balance < 0 THEN balance ELSE 0 END), 0) as negative_balance,
        COUNT(*) as account_count
      FROM accounts
      WHERE user_id = @userId
      ''',
      parameters: {'userId': userId},
    );

    final row = result.first;
    return {
      'totalBalance': row[0],
      'positiveBalance': row[1],
      'negativeBalance': row[2],
      'accountCount': row[3],
    };
  }

  /// Recalculate account balance from transactions
  Future<Map<String, dynamic>?> recalculateBalance(
    Session session,
    int accountId,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Get current account to verify ownership
    final account = await getAccount(session, accountId);
    if (account == null) {
      return null;
    }

    // Calculate balance from transactions
    final result = await session.query(
      '''
      SELECT COALESCE(SUM(amount), 0)
      FROM transactions
      WHERE account_id = @accountId AND user_id = @userId
      ''',
      parameters: {'accountId': accountId, 'userId': userId},
    );

    final calculatedBalance = (result.first[0] as num?)?.toDouble() ?? 0.0;

    return await updateBalance(session, accountId, calculatedBalance);
  }

  Map<String, dynamic> _mapAccount(List<dynamic> row) {
    return {
      'id': row[0],
      'userId': row[1],
      'name': row[2],
      'type': row[3],
      'balance': row[4],
      'currency': row[5],
      'institution': row[6],
      'accountNumber': row[7],
      'isDefault': row[8],
      'icon': row[9],
      'color': row[10],
      'createdAt': row[11],
      'updatedAt': row[12],
    };
  }
}
