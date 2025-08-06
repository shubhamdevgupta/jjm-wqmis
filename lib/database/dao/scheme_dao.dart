import 'package:jjm_wqmis/database/app_database.dart';

class SchemeDao {
  final AppDatabase db;
  SchemeDao(this.db);

  Future<void> insertSchemes(List<SchemesCompanion> schemes) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.schemes, schemes);
    });
  }

  Future<List<Scheme>> getAll() => db.select(db.schemes).get();

  // Optional: filter by village
  Future<List<Scheme>> getByVillage(int villageId) =>
      (db.select(db.schemes)..where((s) => s.villageId.equals(villageId))).get();
}
