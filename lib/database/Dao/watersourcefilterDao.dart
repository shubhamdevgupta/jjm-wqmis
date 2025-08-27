import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/watersourcefilter_table.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/water_source_filter_response.dart';


@dao
abstract class WaterSourceFilterDao {
  @Query('SELECT * FROM WaterSourceFilter')
  Future<List<Watersourcefilterresponse>> getAll();

  @insert
  Future<void> insertWaterSource(Watersourcefilterresponse waterSourceFilter);


  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<Watersourcefilterresponse> waterSources);

  @Query('DELETE FROM WaterSourceFilter')
  Future<void> clearTable();
}
