import 'package:serverpod/serverpod.dart';

/// Split endpoint for shared expense management
class SplitEndpoint extends Endpoint {
  /// Get all splits created by or involving the current user
  Future<List<Map<String, dynamic>>> getSplits(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      '''
      SELECT DISTINCT s.id, s.transaction_id, s.creator_id, s.total_amount,
             s.description, s.status, s.created_at, s.settled_at
      FROM splits s
      LEFT JOIN split_participants sp ON s.id = sp.split_id
      WHERE s.creator_id = @userId OR sp.user_id = @userId
      ORDER BY s.created_at DESC
      ''',
      parameters: {'userId': userId},
    );

    final splits = <Map<String, dynamic>>[];
    for (final row in result) {
      final split = _mapSplit(row);
      // Get participants for each split
      split['participants'] = await _getParticipants(session, split['id'] as int);
      splits.add(split);
    }

    return splits;
  }

  /// Get a single split with participants
  Future<Map<String, dynamic>?> getSplit(Session session, int splitId) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final result = await session.db.query(
      '''
      SELECT s.id, s.transaction_id, s.creator_id, s.total_amount,
             s.description, s.status, s.created_at, s.settled_at
      FROM splits s
      LEFT JOIN split_participants sp ON s.id = sp.split_id
      WHERE s.id = @splitId AND (s.creator_id = @userId OR sp.user_id = @userId)
      LIMIT 1
      ''',
      parameters: {'splitId': splitId, 'userId': userId},
    );

    if (result.isEmpty) {
      return null;
    }

    final split = _mapSplit(result.first);
    split['participants'] = await _getParticipants(session, splitId);
    return split;
  }

  /// Create a new split expense
  Future<Map<String, dynamic>> createSplit(
    Session session, {
    required double totalAmount,
    required List<Map<String, dynamic>> participants,
    int? transactionId,
    String? description,
  }) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    if (participants.isEmpty) {
      throw Exception('At least one participant is required');
    }

    // Validate total matches participant amounts
    final participantTotal = participants.fold<double>(
      0,
      (sum, p) => sum + (p['amount'] as double),
    );
    if ((participantTotal - totalAmount).abs() > 0.01) {
      throw Exception('Participant amounts must equal total amount');
    }

    // Create the split
    final result = await session.db.query(
      '''
      INSERT INTO splits (transaction_id, creator_id, total_amount, description, status, created_at)
      VALUES (@transactionId, @creatorId, @totalAmount, @description, 'pending', NOW())
      RETURNING id, transaction_id, creator_id, total_amount, description, status, created_at, settled_at
      ''',
      parameters: {
        'transactionId': transactionId,
        'creatorId': userId,
        'totalAmount': totalAmount,
        'description': description,
      },
    );

    final split = _mapSplit(result.first);
    final splitId = split['id'] as int;

    // Add participants
    for (final participant in participants) {
      await session.db.query(
        '''
        INSERT INTO split_participants (split_id, user_id, name, phone, email, amount, is_paid, created_at)
        VALUES (@splitId, @userId, @name, @phone, @email, @amount, @isPaid, NOW())
        ''',
        parameters: {
          'splitId': splitId,
          'userId': participant['userId'],
          'name': participant['name'] as String,
          'phone': participant['phone'] as String?,
          'email': participant['email'] as String?,
          'amount': participant['amount'] as double,
          'isPaid': participant['isPaid'] ?? false,
        },
      );

      // Send notification to participant
      if (participant['userId'] != null) {
        await session.messages.postMessage(
          'split-notification',
          {
            'type': 'split_created',
            'recipientId': participant['userId'],
            'splitId': splitId,
            'creatorId': userId,
            'amount': participant['amount'],
            'description': description,
          },
        );
      }
    }

    split['participants'] = await _getParticipants(session, splitId);
    return split;
  }

  /// Mark a participant's share as paid
  Future<Map<String, dynamic>?> markPaid(
    Session session,
    int splitId,
    int participantId,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Verify user is creator or the participant
    final split = await getSplit(session, splitId);
    if (split == null) {
      throw Exception('Split not found');
    }

    final isCreator = split['creatorId'] == userId;
    final participants = split['participants'] as List;
    final participant = participants.firstWhere(
      (p) => p['id'] == participantId,
      orElse: () => null,
    );

    if (participant == null) {
      throw Exception('Participant not found');
    }

    final isParticipant = participant['userId'] == userId;
    if (!isCreator && !isParticipant) {
      throw Exception('Not authorized to mark as paid');
    }

    await session.db.query(
      '''
      UPDATE split_participants
      SET is_paid = true, paid_at = NOW()
      WHERE id = @participantId AND split_id = @splitId
      ''',
      parameters: {
        'participantId': participantId,
        'splitId': splitId,
      },
    );

    // Check if all participants have paid
    final unpaidResult = await session.db.query(
      '''
      SELECT COUNT(*) FROM split_participants
      WHERE split_id = @splitId AND is_paid = false
      ''',
      parameters: {'splitId': splitId},
    );

    final unpaidCount = unpaidResult.first[0] as int;
    if (unpaidCount == 0) {
      // Mark split as settled
      await session.db.query(
        '''
        UPDATE splits
        SET status = 'settled', settled_at = NOW()
        WHERE id = @splitId
        ''',
        parameters: {'splitId': splitId},
      );
    }

    // Send notification
    await session.messages.postMessage(
      'split-notification',
      {
        'type': 'payment_received',
        'recipientId': split['creatorId'],
        'splitId': splitId,
        'participantId': participantId,
        'amount': participant['amount'],
      },
    );

    return await getSplit(session, splitId);
  }

  /// Send a payment reminder to a participant
  Future<bool> sendReminder(
    Session session,
    int splitId,
    int participantId,
  ) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final split = await getSplit(session, splitId);
    if (split == null || split['creatorId'] != userId) {
      throw Exception('Not authorized');
    }

    final participants = split['participants'] as List;
    final participant = participants.firstWhere(
      (p) => p['id'] == participantId,
      orElse: () => null,
    );

    if (participant == null) {
      throw Exception('Participant not found');
    }

    if (participant['isPaid'] == true) {
      throw Exception('Participant has already paid');
    }

    // Send reminder notification
    await session.messages.postMessage(
      'split-notification',
      {
        'type': 'payment_reminder',
        'recipientId': participant['userId'],
        'recipientPhone': participant['phone'],
        'recipientEmail': participant['email'],
        'splitId': splitId,
        'amount': participant['amount'],
        'description': split['description'],
        'senderId': userId,
      },
    );

    return true;
  }

  /// Delete a split (creator only)
  Future<bool> deleteSplit(Session session, int splitId) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Delete participants first
    await session.db.query(
      'DELETE FROM split_participants WHERE split_id = @splitId',
      parameters: {'splitId': splitId},
    );

    // Delete split
    final result = await session.db.query(
      'DELETE FROM splits WHERE id = @splitId AND creator_id = @userId RETURNING id',
      parameters: {'splitId': splitId, 'userId': userId},
    );

    return result.isNotEmpty;
  }

  /// Get splits summary (total owed to/by user)
  Future<Map<String, dynamic>> getSplitsSummary(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Amount owed to user (as creator, unpaid participants)
    final owedToResult = await session.db.query(
      '''
      SELECT COALESCE(SUM(sp.amount), 0)
      FROM splits s
      JOIN split_participants sp ON s.id = sp.split_id
      WHERE s.creator_id = @userId
        AND sp.is_paid = false
        AND sp.user_id != @userId
      ''',
      parameters: {'userId': userId},
    );

    // Amount user owes (as participant, not paid)
    final owesResult = await session.db.query(
      '''
      SELECT COALESCE(SUM(sp.amount), 0)
      FROM split_participants sp
      JOIN splits s ON sp.split_id = s.id
      WHERE sp.user_id = @userId
        AND sp.is_paid = false
        AND s.creator_id != @userId
      ''',
      parameters: {'userId': userId},
    );

    return {
      'owedToYou': (owedToResult.first[0] as num?)?.toDouble() ?? 0.0,
      'youOwe': (owesResult.first[0] as num?)?.toDouble() ?? 0.0,
    };
  }

  Future<List<Map<String, dynamic>>> _getParticipants(
    Session session,
    int splitId,
  ) async {
    final result = await session.db.query(
      '''
      SELECT id, split_id, user_id, name, phone, email, amount, is_paid, paid_at, created_at
      FROM split_participants
      WHERE split_id = @splitId
      ORDER BY created_at
      ''',
      parameters: {'splitId': splitId},
    );

    return result.map((row) => {
      'id': row[0],
      'splitId': row[1],
      'userId': row[2],
      'name': row[3],
      'phone': row[4],
      'email': row[5],
      'amount': row[6],
      'isPaid': row[7],
      'paidAt': row[8],
      'createdAt': row[9],
    }).toList();
  }

  Map<String, dynamic> _mapSplit(List<dynamic> row) {
    return {
      'id': row[0],
      'transactionId': row[1],
      'creatorId': row[2],
      'totalAmount': row[3],
      'description': row[4],
      'status': row[5],
      'createdAt': row[6],
      'settledAt': row[7],
    };
  }
}
