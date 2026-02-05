import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'privacy_report_dao.g.dart';

/// Data Access Object for privacy reports
@DriftAccessor(tables: [PrivacyReports])
class PrivacyReportDao extends DatabaseAccessor<AppDatabase>
    with _$PrivacyReportDaoMixin {
  PrivacyReportDao(super.db);

  Future<void> insertReport(PrivacyReportsCompanion entry) async {
    await into(privacyReports).insert(entry);
  }

  Future<PrivacyReportRow?> getLatest() async {
    final query = select(privacyReports)
      ..orderBy([(r) => OrderingTerm.desc(r.generatedAt)])
      ..limit(1);
    return await query.getSingleOrNull();
  }

  Future<void> clearAll() async {
    await delete(privacyReports).go();
  }
}
