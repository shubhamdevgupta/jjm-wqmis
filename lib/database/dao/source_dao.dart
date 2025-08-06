import 'package:jjm_wqmis/database/app_database.dart';

class SourceDao {
  final AppDatabase db;
  SourceDao(this.db);

  Future<void> insertSources(List<SourcesCompanion> sources) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.sources, sources);
    });
  }

  Future<List<Source>> getByScheme(int schemeId) =>
      (db.select(db.sources)..where((s) => s.schemeId.equals(schemeId))).get();
}
