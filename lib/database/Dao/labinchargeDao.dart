import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/labincharge_table.dart';


@dao
abstract class LabInchargeDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<LabInchargeEntity> incharges);

  @Query('SELECT * FROM LabIncharge')
  Future<List<LabInchargeEntity>> getAllLabIncharges();



  @Query('DELETE FROM LabIncharge')
  Future<void> clearTable();
}
