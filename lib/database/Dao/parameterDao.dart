import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/parameter_table.dart';


@dao
abstract class ParameterDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllParameters(List<ParameterEntity> params);

  @Query('SELECT * FROM Parameter')
  Future<List<ParameterEntity>> getAllParameters();


  @insert
  Future<void> insertAll(List<ParameterEntity> waterSources);

  @Query('DELETE FROM ParameterEntity')
  Future<void> clearTable();
}
