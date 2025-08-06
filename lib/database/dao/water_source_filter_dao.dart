import 'package:jjm_wqmis/database/app_database.dart';

class WaterSourceFilterDao {
  final AppDatabase db;
  WaterSourceFilterDao(this.db);

  Future<void> insertAll(List<WaterSourceFiltersCompanion> filters) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.waterSourceFilters, filters);
    });
  }

  Future<List<WaterSourceFilter>> getAll() => db.select(db.waterSourceFilters).get();
}
