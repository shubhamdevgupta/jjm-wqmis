import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/parameter_table.dart';


@dao
abstract class ParameterDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<ParameterEntity> params);

  @Query('SELECT * FROM Parameter')
  Future<List<ParameterEntity>> getAllParameters();




  @Query('DELETE FROM Parameter')
  Future<void> clearTable();
}
