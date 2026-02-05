class BackupMetadataEntry {
  final String id;
  final String filePath;
  final DateTime createdAt;
  final int sizeBytes;
  final String checksum;
  final int version;
  final bool isEncrypted;

  const BackupMetadataEntry({
    required this.id,
    required this.filePath,
    required this.createdAt,
    required this.sizeBytes,
    required this.checksum,
    required this.version,
    required this.isEncrypted,
  });
}

abstract class BackupMetadataStore {
  Future<void> recordBackup(BackupMetadataEntry entry);
  Future<void> recordRestore({required String filePath, required DateTime restoredAt});
}
