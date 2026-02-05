import 'privacy_engine.dart';

abstract class PrivacyStore {
  Future<void> appendAuditEntry(AuditEntry entry);
  Future<List<AuditEntry>> getAuditEntries({
    DateTime? from,
    DateTime? to,
    DataAccessType? type,
  });
  Future<void> clearAudit();
  Future<void> clearAll();
  Future<void> savePrivacyReport(PrivacyReport report);
  Future<PrivacyReport?> getLatestPrivacyReport();
}
