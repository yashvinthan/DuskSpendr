import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'backup_metadata_dao.g.dart';

/// Data Access Object for backup metadata
@DriftAccessor(tables: [BackupMetadata])
class BackupMetadataDao extends DatabaseAccessor<AppDatabase>
    with _$BackupMetadataDaoMixin {
  BackupMetadataDao(super.db);

  Future<void> insertMetadata(BackupMetadataCompanion entry) async {
    await into(backupMetadata).insertOnConflictUpdate(entry);
  }

  Future<List<BackupMetadataRow>> listAll() async {
    final query = select(backupMetadata)
      ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]);
    return await query.get();
  }

  Future<BackupMetadataRow?> getByPath(String path) async {
    final query = select(backupMetadata)..where((b) => b.filePath.equals(path));
    return await query.getSingleOrNull();
  }

  Future<void> recordRestore(String path, DateTime restoredAt) async {
    final existing = await getByPath(path);
    if (existing == null) return;

    await (update(backupMetadata)..where((b) => b.id.equals(existing.id))).write(
      BackupMetadataCompanion(
        restoreCount: Value(existing.restoreCount + 1),
        lastRestoredAt: Value(restoredAt),
      ),
    );
  }
}
