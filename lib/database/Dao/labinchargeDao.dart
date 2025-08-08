import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/labincharge_table.dart';


@dao
abstract class LabInchargeDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllLabIncharges(List<LabInchargeEntity> incharges);

  @Query('SELECT * FROM LabIncharge')
  Future<List<LabInchargeEntity>> getAllLabIncharges();


  @insert
  Future<void> insertAll(List<LabInchargeEntity> waterSources);

  @Query('DELETE FROM LabInchargeEntity')
  Future<void> clearTable();
}
