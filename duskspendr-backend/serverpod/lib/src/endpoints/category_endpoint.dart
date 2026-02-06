import 'package:serverpod/serverpod.dart';

import '../util/serverpod_helpers.dart';

/// Category endpoint for managing transaction categories
class CategoryEndpoint extends Endpoint {
  /// Default categories that are created for new users
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'color': '#FF5722',
      'type': 'expense'
    },
    {
      'name': 'Transportation',
      'icon': 'directions_car',
      'color': '#2196F3',
      'type': 'expense'
    },
    {
      'name': 'Shopping',
      'icon': 'shopping_bag',
      'color': '#9C27B0',
      'type': 'expense'
    },
    {
      'name': 'Entertainment',
      'icon': 'movie',
      'color': '#E91E63',
      'type': 'expense'
    },
    {
      'name': 'Bills & Utilities',
      'icon': 'receipt',
      'color': '#607D8B',
      'type': 'expense'
    },
    {
      'name': 'Healthcare',
      'icon': 'local_hospital',
      'color': '#4CAF50',
      'type': 'expense'
    },
    {
      'name': 'Education',
      'icon': 'school',
      'color': '#3F51B5',
      'type': 'expense'
    },
    {'name': 'Travel', 'icon': 'flight', 'color': '#00BCD4', 'type': 'expense'},
    {
      'name': 'Personal Care',
      'icon': 'spa',
      'color': '#FF9800',
      'type': 'expense'
    },
    {
      'name': 'Groceries',
      'icon': 'shopping_cart',
      'color': '#8BC34A',
      'type': 'expense'
    },
    {
      'name': 'Salary',
      'icon': 'payments',
      'color': '#4CAF50',
      'type': 'income'
    },
    {'name': 'Freelance', 'icon': 'work', 'color': '#2196F3', 'type': 'income'},
    {
      'name': 'Investments',
      'icon': 'trending_up',
      'color': '#673AB7',
      'type': 'income'
    },
    {
      'name': 'Gift',
      'icon': 'card_giftcard',
      'color': '#E91E63',
      'type': 'both'
    },
    {'name': 'Other', 'icon': 'more_horiz', 'color': '#9E9E9E', 'type': 'both'},
  ];

  /// Get all categories for the current user
  Future<List<Map<String, dynamic>>> getCategories(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.query(
      '''
      SELECT id, user_id, name, icon, color, type, parent_id, is_system, created_at
      FROM categories
      WHERE user_id = @userId OR is_system = true
      ORDER BY is_system DESC, name ASC
      ''',
      parameters: {'userId': userId},
    );

    return result.map((row) => _mapCategory(row)).toList();
  }

  /// Get a single category by ID
  Future<Map<String, dynamic>?> getCategory(
    Session session,
    int categoryId,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.query(
      '''
      SELECT id, user_id, name, icon, color, type, parent_id, is_system, created_at
      FROM categories
      WHERE id = @id AND (user_id = @userId OR is_system = true)
      ''',
      parameters: {'id': categoryId, 'userId': userId},
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapCategory(result.first);
  }

  /// Create a new category
  Future<Map<String, dynamic>> createCategory(
    Session session, {
    required String name,
    String type = 'expense',
    String? icon,
    String? color,
    int? parentId,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Validate parent category if provided
    if (parentId != null) {
      final parent = await getCategory(session, parentId);
      if (parent == null) {
        throw Exception('Parent category not found');
      }
    }

    final result = await session.query(
      '''
      INSERT INTO categories (
        user_id, name, icon, color, type, parent_id, is_system, created_at
      ) VALUES (
        @userId, @name, @icon, @color, @type, @parentId, false, NOW()
      )
      RETURNING id, user_id, name, icon, color, type, parent_id, is_system, created_at
      ''',
      parameters: {
        'userId': userId,
        'name': name,
        'icon': icon ?? 'category',
        'color': color ?? '#9E9E9E',
        'type': type,
        'parentId': parentId,
      },
    );

    return _mapCategory(result.first);
  }

  /// Update an existing category
  Future<Map<String, dynamic>?> updateCategory(
    Session session,
    int categoryId, {
    String? name,
    String? icon,
    String? color,
    String? type,
    int? parentId,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Check if category is a system category
    final existing = await getCategory(session, categoryId);
    if (existing == null) {
      return null;
    }
    if (existing['isSystem'] == true) {
      throw Exception('Cannot modify system categories');
    }

    final updates = <String>[];
    final params = <String, dynamic>{
      'id': categoryId,
      'userId': userId,
    };

    if (name != null) {
      updates.add('name = @name');
      params['name'] = name;
    }
    if (icon != null) {
      updates.add('icon = @icon');
      params['icon'] = icon;
    }
    if (color != null) {
      updates.add('color = @color');
      params['color'] = color;
    }
    if (type != null) {
      updates.add('type = @type');
      params['type'] = type;
    }
    if (parentId != null) {
      // Prevent circular reference
      if (parentId == categoryId) {
        throw Exception('Category cannot be its own parent');
      }
      updates.add('parent_id = @parentId');
      params['parentId'] = parentId;
    }

    if (updates.isEmpty) {
      return existing;
    }

    final result = await session.query(
      '''
      UPDATE categories
      SET ${updates.join(', ')}
      WHERE id = @id AND user_id = @userId AND is_system = false
      RETURNING id, user_id, name, icon, color, type, parent_id, is_system, created_at
      ''',
      parameters: params,
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapCategory(result.first);
  }

  /// Delete a category
  Future<bool> deleteCategory(Session session, int categoryId) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Check if category is a system category
    final existing = await getCategory(session, categoryId);
    if (existing == null) {
      return false;
    }
    if (existing['isSystem'] == true) {
      throw Exception('Cannot delete system categories');
    }

    // Check for child categories
    final children = await session.query(
      'SELECT COUNT(*) FROM categories WHERE parent_id = @id',
      parameters: {'id': categoryId},
    );
    if ((children.first[0] as int) > 0) {
      throw Exception('Cannot delete category with subcategories');
    }

    // Update transactions to remove this category
    await session.query(
      'UPDATE transactions SET category_id = NULL WHERE category_id = @categoryId AND user_id = @userId',
      parameters: {'categoryId': categoryId, 'userId': userId},
    );

    final result = await session.query(
      'DELETE FROM categories WHERE id = @id AND user_id = @userId AND is_system = false RETURNING id',
      parameters: {'id': categoryId, 'userId': userId},
    );

    return result.isNotEmpty;
  }

  /// Initialize default categories for a new user
  Future<List<Map<String, dynamic>>> initializeDefaultCategories(
    Session session,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Check if user already has categories
    final existing = await session.query(
      'SELECT COUNT(*) FROM categories WHERE user_id = @userId',
      parameters: {'userId': userId},
    );
    if ((existing.first[0] as int) > 0) {
      return await getCategories(session);
    }

    // Create default categories
    for (final cat in defaultCategories) {
      await session.query(
        '''
        INSERT INTO categories (user_id, name, icon, color, type, is_system, created_at)
        VALUES (@userId, @name, @icon, @color, @type, false, NOW())
        ''',
        parameters: {
          'userId': userId,
          'name': cat['name'],
          'icon': cat['icon'],
          'color': cat['color'],
          'type': cat['type'],
        },
      );
    }

    return await getCategories(session);
  }

  /// Get spending by category for analytics
  Future<List<Map<String, dynamic>>> getSpendingByCategory(
    Session session, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final now = DateTime.now();
    final start = startDate ?? DateTime(now.year, now.month, 1);
    final end = endDate ?? now;

    final result = await session.query(
      '''
      SELECT 
        c.id,
        c.name,
        c.icon,
        c.color,
        c.type,
        COALESCE(SUM(ABS(t.amount)), 0) as total_amount,
        COUNT(t.id) as transaction_count
      FROM categories c
      LEFT JOIN transactions t ON t.category_id = c.id 
        AND t.user_id = @userId
        AND t.date >= @startDate
        AND t.date <= @endDate
        AND t.amount < 0
      WHERE c.user_id = @userId OR c.is_system = true
      GROUP BY c.id, c.name, c.icon, c.color, c.type
      HAVING COALESCE(SUM(ABS(t.amount)), 0) > 0
      ORDER BY total_amount DESC
      ''',
      parameters: {
        'userId': userId,
        'startDate': start,
        'endDate': end,
      },
    );

    return result
        .map((row) => {
              'id': row[0],
              'name': row[1],
              'icon': row[2],
              'color': row[3],
              'type': row[4],
              'totalAmount': row[5],
              'transactionCount': row[6],
            })
        .toList();
  }

  Map<String, dynamic> _mapCategory(List<dynamic> row) {
    return {
      'id': row[0],
      'userId': row[1],
      'name': row[2],
      'icon': row[3],
      'color': row[4],
      'type': row[5],
      'parentId': row[6],
      'isSystem': row[7],
      'createdAt': row[8],
    };
  }
}
