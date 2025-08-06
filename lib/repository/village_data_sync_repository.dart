import 'package:jjm_wqmis/database/app_database.dart';
import 'package:jjm_wqmis/models/MasterVillageData.dart';


class VillageDataSyncRepository {
  final AppDatabase db;

  VillageDataSyncRepository(this.db);

  Future<void> syncMasterData(MasterVillageData data) async {
    await db.transaction(() async {
      // 1. Clear previous data (optional based on use case)
      await db.habitationDao.clear();
      await db.schemeDao.clear();
      await db.sourceDao.clear();
      await db.waterSourceFilterDao.clear();
      await db.labDao.clear();
      await db.parameterDao.clear();
      await db.labInchargeDao.clear();

      // 2. Insert new data
      await db.habitationDao.insertAll(data.habitations);
      await db.schemeDao.insertAll(data.schemes);
      await db.sourceDao.insertAll(data.sources);
      await db.waterSourceFilterDao.insertAll(data.waterSourceFilters);
      await db.labDao.insertAll(data.labs);
      await db.parameterDao.insertAll(data.parameters);
      await db.labInchargeDao.insertAll(data.labIncharges);
    });
  }
}
