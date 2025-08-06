import 'package:jjm_wqmis/database/app_database.dart';

class LabInchargeDao {
  final AppDatabase db;
  LabInchargeDao(this.db);

  Future<void> insertIncharges(List<LabInchargesCompanion> incharges) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.labIncharges, incharges);
    });
  }

  Future<LabIncharge?> getByLabId(int labId) =>
      (db.select(db.labIncharges)..where((i) => i.labId.equals(labId))).getSingleOrNull();
}
