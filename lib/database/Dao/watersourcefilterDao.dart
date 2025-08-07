import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/watersourcefilter_table.dart';


@dao
abstract class WaterSourceFilterDao {
  @Query('SELECT * FROM WaterSourceFilter')
  Future<List<WaterSourceFilter>> getAll();

  @insert
  Future<void> insertWaterSource(WaterSourceFilter waterSourceFilter);

  @insert
  Future<void> insertAll(List<WaterSourceFilter> waterSources);

  @Query('DELETE FROM WaterSourceFilter')
  Future<void> clearTable();
}
