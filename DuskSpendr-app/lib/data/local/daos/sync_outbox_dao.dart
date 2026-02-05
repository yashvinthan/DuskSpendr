import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';
import '../../../core/sync/sync_outbox_stats.dart';

part 'sync_outbox_dao.g.dart';

@DriftAccessor(tables: [SyncOutbox])
class SyncOutboxDao extends DatabaseAccessor<AppDatabase>
    with _$SyncOutboxDaoMixin {
  SyncOutboxDao(super.db);

  Future<void> enqueue(String transactionId) async {
    final existing = await (select(syncOutbox)
          ..where((o) => o.transactionId.equals(transactionId)))
        .getSingleOrNull();
    if (existing != null && existing.status == SyncOutboxStatusDb.succeeded) {
      return;
    }

    await into(syncOutbox).insertOnConflictUpdate(
      SyncOutboxCompanion.insert(
        transactionId: transactionId,
        status: SyncOutboxStatusDb.pending,
        attempts: const Value(0),
        nextAttemptAt: const Value.absent(),
        lastError: const Value.absent(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<List<SyncOutboxRow>> listReady({
    required DateTime now,
    int limit = 50,
  }) async {
    final query = select(syncOutbox)
      ..where((o) => o.status.isIn([
            SyncOutboxStatusDb.pending.index,
            SyncOutboxStatusDb.failed.index,
          ]))
      ..where((o) => o.nextAttemptAt.isNull() | o.nextAttemptAt.isSmallerOrEqualValue(now))
      ..orderBy([(o) => OrderingTerm.asc(o.createdAt)])
      ..limit(limit);

    return await query.get();
  }

  Future<void> markSyncing(List<String> transactionIds) async {
    if (transactionIds.isEmpty) return;
    await (update(syncOutbox)
          ..where((o) => o.transactionId.isIn(transactionIds)))
        .write(
      SyncOutboxCompanion(
        status: const Value(SyncOutboxStatusDb.syncing),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markSuccess(List<String> transactionIds) async {
    if (transactionIds.isEmpty) return;
    await (update(syncOutbox)
          ..where((o) => o.transactionId.isIn(transactionIds)))
        .write(
      SyncOutboxCompanion(
        status: const Value(SyncOutboxStatusDb.succeeded),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markFailed({
    required String transactionId,
    required int attempts,
    required DateTime nextAttemptAt,
    String? error,
  }) async {
    await (update(syncOutbox)
          ..where((o) => o.transactionId.equals(transactionId)))
        .write(
      SyncOutboxCompanion(
        status: const Value(SyncOutboxStatusDb.failed),
        attempts: Value(attempts),
        nextAttemptAt: Value(nextAttemptAt),
        lastError: Value(error),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<SyncOutboxStats> getStats() async {
    final rows = await customSelect(
      'SELECT status, COUNT(*) AS count FROM sync_outbox GROUP BY status',
      readsFrom: {syncOutbox},
    ).get();

    int pending = 0;
    int syncing = 0;
    int failed = 0;
    int succeeded = 0;

    for (final row in rows) {
      final status = row.read<int>('status');
      final count = row.read<int>('count');
      switch (SyncOutboxStatusDb.values[status]) {
        case SyncOutboxStatusDb.pending:
          pending = count;
          break;
        case SyncOutboxStatusDb.syncing:
          syncing = count;
          break;
        case SyncOutboxStatusDb.failed:
          failed = count;
          break;
        case SyncOutboxStatusDb.succeeded:
          succeeded = count;
          break;
      }
    }

    return SyncOutboxStats(
      pending: pending,
      syncing: syncing,
      failed: failed,
      succeeded: succeeded,
    );
  }
}
