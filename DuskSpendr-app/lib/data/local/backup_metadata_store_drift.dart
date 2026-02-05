import 'package:drift/drift.dart';

import '../../core/backup/backup_metadata_store.dart';
import 'daos/backup_metadata_dao.dart';
import 'tables.dart';

class DriftBackupMetadataStore implements BackupMetadataStore {
  DriftBackupMetadataStore({required BackupMetadataDao dao}) : _dao = dao;

  final BackupMetadataDao _dao;

  @override
  Future<void> recordBackup(BackupMetadataEntry entry) async {
    await _dao.insertMetadata(
      BackupMetadataCompanion.insert(
        id: entry.id,
        filePath: entry.filePath,
        createdAt: entry.createdAt,
        sizeBytes: entry.sizeBytes,
        checksum: entry.checksum,
        version: entry.version,
        isEncrypted: entry.isEncrypted,
        status: BackupStatusDb.success,
      ),
    );
  }

  @override
  Future<void> recordRestore({required String filePath, required DateTime restoredAt}) async {
    await _dao.recordRestore(filePath, restoredAt);
  }
}
