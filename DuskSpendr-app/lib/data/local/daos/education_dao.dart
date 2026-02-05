import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/entities.dart';
import '../database.dart';
import '../tables.dart';

part 'education_dao.g.dart';

/// SS-090-097: DAOs for financial education tracking

@DriftAccessor(tables: [CompletedLessons, ShownTips, CreditScores])
class EducationDao extends DatabaseAccessor<AppDatabase> with _$EducationDaoMixin {
  EducationDao(super.db);

  // ====== Completed Lessons ======

  /// Watch all completed lessons
  Stream<List<CompletedLesson>> watchCompletedLessons() {
    return (select(completedLessons)..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .watch()
        .map((rows) => rows.map(_toCompletedLesson).toList());
  }

  /// Get completed lesson IDs
  Future<Set<String>> getCompletedLessonIds() async {
    final rows = await select(completedLessons).get();
    return rows.map((r) => r.lessonId).toSet();
  }

  /// Get completed count by topic
  Future<Map<String, int>> getCompletedCountByTopic() async {
    final rows = await select(completedLessons).get();
    final map = <String, int>{};
    for (final row in rows) {
      map[row.topicId] = (map[row.topicId] ?? 0) + 1;
    }
    return map;
  }

  /// Get total quiz score
  Future<int> getTotalQuizScore() async {
    final rows = await select(completedLessons).get();
    var total = 0;
    for (final row in rows) {
      total += row.quizScore ?? 0;
    }
    return total;
  }

  /// Get quizzes taken count
  Future<int> getQuizzesTakenCount() async {
    final rows = await (select(completedLessons)..where((t) => t.quizScore.isNotNull())).get();
    return rows.length;
  }

  /// Mark lesson as completed
  Future<void> completeLesson(CompletedLesson lesson) async {
    await into(completedLessons).insert(
      CompletedLessonsCompanion(
        id: Value(lesson.id),
        lessonId: Value(lesson.lessonId),
        topicId: Value(lesson.topicId),
        quizScore: Value(lesson.quizScore),
        timeSpentSeconds: Value(lesson.timeSpentSeconds),
        completedAt: Value(lesson.completedAt),
      ),
    );
  }

  /// Check if lesson is completed
  Future<bool> isLessonCompleted(String lessonId) async {
    final count = await (select(completedLessons)
          ..where((t) => t.lessonId.equals(lessonId)))
        .get();
    return count.isNotEmpty;
  }

  CompletedLesson _toCompletedLesson(CompletedLessonRow row) {
    return CompletedLesson(
      id: row.id,
      lessonId: row.lessonId,
      topicId: row.topicId,
      quizScore: row.quizScore,
      timeSpentSeconds: row.timeSpentSeconds,
      completedAt: row.completedAt,
    );
  }

  // ====== Shown Tips ======

  /// Get tip IDs shown in last N days
  Future<Set<String>> getRecentlyShownTipIds({int days = 7}) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final rows = await (select(shownTips)
          ..where((t) => t.shownAt.isBiggerOrEqualValue(since)))
        .get();
    return rows.map((r) => r.tipId).toSet();
  }

  /// Record shown tip
  Future<void> recordShownTip(ShownTip tip) async {
    await into(shownTips).insert(
      ShownTipsCompanion(
        id: Value(tip.id),
        tipId: Value(tip.tipId),
        wasDismissed: Value(tip.wasDismissed),
        wasSaved: Value(tip.wasSaved),
        wasActedOn: Value(tip.wasActedOn),
        shownAt: Value(tip.shownAt),
      ),
    );
  }

  /// Update tip interaction
  Future<void> updateTipInteraction(String id, {bool? dismissed, bool? saved, bool? actedOn}) async {
    await (update(shownTips)..where((t) => t.id.equals(id))).write(
      ShownTipsCompanion(
        wasDismissed: dismissed != null ? Value(dismissed) : const Value.absent(),
        wasSaved: saved != null ? Value(saved) : const Value.absent(),
        wasActedOn: actedOn != null ? Value(actedOn) : const Value.absent(),
      ),
    );
  }

  /// Get saved tips
  Future<List<ShownTip>> getSavedTips() async {
    final rows = await (select(shownTips)
          ..where((t) => t.wasSaved.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.shownAt)]))
        .get();
    return rows.map(_toShownTip).toList();
  }

  ShownTip _toShownTip(ShownTipRow row) {
    return ShownTip(
      id: row.id,
      tipId: row.tipId,
      wasDismissed: row.wasDismissed,
      wasSaved: row.wasSaved,
      wasActedOn: row.wasActedOn,
      shownAt: row.shownAt,
    );
  }

  // ====== Credit Scores ======

  /// Watch credit score history
  Stream<List<CreditScoreData>> watchCreditScoreHistory() {
    return (select(creditScores)..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)]))
        .watch()
        .asyncMap((rows) async {
          final result = <CreditScoreData>[];
          for (int i = 0; i < rows.length; i++) {
            final row = rows[i];
            final previous = i + 1 < rows.length ? rows[i + 1] : null;
            result.add(_toCreditScoreData(row, previous));
          }
          return result;
        });
  }

  /// Get latest credit score
  Future<CreditScoreData?> getLatestCreditScore() async {
    final rows = await (select(creditScores)
          ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
          ..limit(2))
        .get();
    if (rows.isEmpty) return null;
    final previous = rows.length > 1 ? rows[1] : null;
    return _toCreditScoreData(rows.first, previous);
  }

  /// Get credit score history
  Future<List<CreditScoreData>> getCreditScoreHistory({int limit = 12}) async {
    final rows = await (select(creditScores)
          ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
          ..limit(limit))
        .get();

    final result = <CreditScoreData>[];
    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];
      final previous = i + 1 < rows.length ? rows[i + 1] : null;
      result.add(_toCreditScoreData(row, previous));
    }
    return result;
  }

  /// Insert credit score
  Future<void> insertCreditScore({
    required String id,
    required int score,
    required String source,
    List<CreditFactor>? factors,
  }) async {
    await into(creditScores).insert(
      CreditScoresCompanion(
        id: Value(id),
        score: Value(score),
        source: Value(source),
        factors: Value(factors != null
            ? jsonEncode(factors.map((f) => {
                'name': f.name,
                'impact': f.impact,
                'description': f.description,
              }).toList())
            : null),
        fetchedAt: Value(DateTime.now()),
      ),
    );
  }

  CreditScoreData _toCreditScoreData(CreditScoreRow row, CreditScoreRow? previous) {
    List<CreditFactor> factors = [];
    if (row.factors != null) {
      final list = jsonDecode(row.factors!) as List;
      factors = list.map((e) => CreditFactor(
        name: e['name'] as String,
        impact: e['impact'] as String,
        description: e['description'] as String,
      )).toList();
    }

    return CreditScoreData(
      score: row.score,
      source: row.source,
      rating: CreditRatingExt.fromScore(row.score),
      factors: factors,
      fetchedAt: row.fetchedAt,
      previousScore: previous?.score,
      previousFetchedAt: previous?.fetchedAt,
    );
  }
}
