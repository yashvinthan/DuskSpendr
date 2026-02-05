import 'package:serverpod/serverpod.dart';

import '../util/serverpod_helpers.dart';

/// User profile endpoint for managing user data
class UserEndpoint extends Endpoint {
  /// Get the current user's profile
  Future<Map<String, dynamic>> getProfile(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw AuthenticationException();
    }

    final result = await session.query(
      'SELECT id, phone, email, display_name, avatar_url, preferences, created_at, updated_at '
      'FROM users WHERE id = @userId',
      parameters: {'userId': userId},
    );

    if (result.isEmpty) {
      throw NotFoundException(message: 'User not found');
    }

    final row = result.first;
    return {
      'id': row[0],
      'phone': row[1],
      'email': row[2],
      'displayName': row[3],
      'avatarUrl': row[4],
      'preferences': row[5],
      'createdAt': row[6],
      'updatedAt': row[7],
    };
  }

  /// Update the current user's profile
  Future<Map<String, dynamic>> updateProfile(
    Session session, {
    String? displayName,
    String? email,
    String? avatarUrl,
    String? preferences,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw AuthenticationException();
    }

    final updates = <String>[];
    final params = <String, dynamic>{'userId': userId};

    if (displayName != null) {
      updates.add('display_name = @displayName');
      params['displayName'] = displayName;
    }
    if (email != null) {
      updates.add('email = @email');
      params['email'] = email;
    }
    if (avatarUrl != null) {
      updates.add('avatar_url = @avatarUrl');
      params['avatarUrl'] = avatarUrl;
    }
    if (preferences != null) {
      updates.add('preferences = @preferences');
      params['preferences'] = preferences;
    }

    if (updates.isEmpty) {
      return await getProfile(session);
    }

    updates.add('updated_at = NOW()');

    await session.query(
      'UPDATE users SET ${updates.join(', ')} WHERE id = @userId',
      parameters: params,
    );

    return await getProfile(session);
  }

  /// Delete the current user's account
  Future<bool> deleteAccount(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw AuthenticationException();
    }

    // Soft delete - mark as deleted
    await session.query(
      'UPDATE users SET deleted_at = NOW() WHERE id = @userId',
      parameters: {'userId': userId},
    );

    return true;
  }

  /// Get user preferences
  Future<Map<String, dynamic>?> getPreferences(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw AuthenticationException();
    }

    final result = await session.query(
      'SELECT preferences FROM users WHERE id = @userId',
      parameters: {'userId': userId},
    );

    if (result.isEmpty || result.first[0] == null) {
      return null;
    }

    // Parse JSON preferences
    return result.first[0] as Map<String, dynamic>?;
  }

  /// Update user preferences
  Future<bool> updatePreferences(
    Session session,
    Map<String, dynamic> preferences,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw AuthenticationException();
    }

    await session.query(
      'UPDATE users SET preferences = @preferences, updated_at = NOW() WHERE id = @userId',
      parameters: {
        'userId': userId,
        'preferences': preferences,
      },
    );

    return true;
  }
}

/// Custom exception for authentication errors
class AuthenticationException implements Exception {
  final String message;
  AuthenticationException({this.message = 'Not authenticated'});

  @override
  String toString() => message;
}

/// Custom exception for not found errors
class NotFoundException implements Exception {
  final String message;
  NotFoundException({required this.message});

  @override
  String toString() => message;
}
