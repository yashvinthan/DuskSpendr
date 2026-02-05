import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'audit_log_dao.g.dart';

/// Data Access Object for audit logs
@DriftAccessor(tables: [AuditLogs])
class AuditLogDao extends DatabaseAccessor<AppDatabase> with _$AuditLogDaoMixin {
  AuditLogDao(super.db);

  Future<void> insertLog(AuditLogsCompanion entry) async {
    await into(auditLogs).insert(entry);
  }

  Future<List<AuditLogRow>> listLogs({
    DateTime? from,
    DateTime? to,
    AuditLogTypeDb? type,
    int limit = 500,
  }) async {
    var query = select(auditLogs);

    if (from != null) {
      query = query..where((l) => l.createdAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query = query..where((l) => l.createdAt.isSmallerOrEqualValue(to));
    }
    if (type != null) {
      query = query..where((l) => l.type.equalsValue(type));
    }

    query = query..orderBy([(l) => OrderingTerm.desc(l.createdAt)])..limit(limit);

    return await query.get();
  }

  Future<void> clearAll() async {
    await delete(auditLogs).go();
  }
}
