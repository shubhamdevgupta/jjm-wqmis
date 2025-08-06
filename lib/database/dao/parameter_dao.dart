import 'package:jjm_wqmis/database/app_database.dart';

class ParameterDao {
  final AppDatabase db;
  ParameterDao(this.db);

  Future<void> insertParameters(List<ParametersCompanion> parameters) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.parameters, parameters);
    });
  }

  Future<List<Parameter>> getByLab(int labId) =>
      (db.select(db.parameters)..where((p) => p.labId.equals(labId))).get();
}
