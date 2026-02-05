import 'dart:math';

import '../../data/local/daos/sync_outbox_dao.dart';
import '../../data/local/daos/transaction_dao.dart';
import '../../data/local/session_store.dart';
import '../../data/remote/sync_api.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';

class SyncUploadService {
  SyncUploadService({
    required SyncOutboxDao outboxDao,
    required TransactionDao transactionDao,
    required SyncApi syncApi,
    required SessionStore sessionStore,
  })  : _outboxDao = outboxDao,
        _transactionDao = transactionDao,
        _syncApi = syncApi,
        _sessionStore = sessionStore;

  final SyncOutboxDao _outboxDao;
  final TransactionDao _transactionDao;
  final SyncApi _syncApi;
  final SessionStore _sessionStore;

  Future<void> enqueueTransactionId(String transactionId) async {
    await _outboxDao.enqueue(transactionId);
  }

  Future<SyncUploadResult> processQueue({int batchSize = 50}) async {
    final token = await _sessionStore.readToken();
    if (token == null || token.isEmpty) {
      return const SyncUploadResult(success: false, error: 'Missing auth token');
    }

    final now = DateTime.now();
    final pending = await _outboxDao.listReady(now: now, limit: batchSize);
    if (pending.isEmpty) {
      return const SyncUploadResult(success: true, uploaded: 0, skipped: 0);
    }

    final ids = pending.map((entry) => entry.transactionId).toList();
    await _outboxDao.markSyncing(ids);

    final payload = <Map<String, dynamic>>[];
    int skipped = 0;

    for (final entry in pending) {
      final tx = await _transactionDao.getById(entry.transactionId);
      if (tx == null) {
        skipped++;
        await _outboxDao.markFailed(
          transactionId: entry.transactionId,
          attempts: entry.attempts + 1,
          nextAttemptAt: _nextAttempt(entry.attempts + 1),
          error: 'Transaction missing',
        );
        continue;
      }
      payload.add(_toPayload(tx));
    }

    if (payload.isEmpty) {
      return SyncUploadResult(success: true, uploaded: 0, skipped: skipped);
    }

    try {
      await _syncApi.ingestTransactions(token: token, items: payload);
      final uploadedIds = payload.map((e) => e['id'] as String).toList();
      await _outboxDao.markSuccess(uploadedIds);
      return SyncUploadResult(
        success: true,
        uploaded: uploadedIds.length,
        skipped: skipped,
      );
    } catch (e) {
      for (final entry in pending) {
        await _outboxDao.markFailed(
          transactionId: entry.transactionId,
          attempts: entry.attempts + 1,
          nextAttemptAt: _nextAttempt(entry.attempts + 1),
          error: e.toString(),
        );
      }
      return SyncUploadResult(success: false, error: e.toString());
    }
  }

  Map<String, dynamic> _toPayload(Transaction tx) => {
        'id': tx.id,
        'amount_paisa': tx.amount.paisa,
        'type': _mapType(tx.type),
        'category': tx.category.name,
        'merchant_name': tx.merchantName,
        'description': tx.description,
        'timestamp': tx.timestamp.toUtc().toIso8601String(),
        'source': tx.source.name,
        'payment_method': tx.paymentMethod?.name,
        'linked_account_id': tx.linkedAccountId,
        'reference_id': tx.referenceId,
        'category_confidence': tx.categoryConfidence,
        'is_recurring': tx.isRecurring,
        'is_shared': tx.isShared,
        'tags': tx.tags,
        'notes': tx.notes,
      };

  String _mapType(TransactionType type) => switch (type) {
        TransactionType.debit => 'debit',
        TransactionType.credit => 'credit',
      };

  DateTime _nextAttempt(int attempts) {
    const baseSeconds = 30;
    const maxSeconds = 3600;
    final backoff = min(maxSeconds, baseSeconds * pow(2, attempts - 1).toInt());
    return DateTime.now().add(Duration(seconds: backoff));
  }
}

class SyncUploadResult {
  final bool success;
  final int uploaded;
  final int skipped;
  final String? error;

  const SyncUploadResult({
    required this.success,
    this.uploaded = 0,
    this.skipped = 0,
    this.error,
  });
}
