import 'package:jjm_wqmis/database/app_database.dart';

class LabDao {
  final AppDatabase db;
  LabDao(this.db);

  Future<void> insertLabs(List<LabsCompanion> labs) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.labs, labs);
    });
  }

  Future<List<Lab>> getAllLabs() => db.select(db.labs).get();
}
