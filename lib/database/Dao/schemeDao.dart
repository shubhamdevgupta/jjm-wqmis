import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/scheme_table.dart';

@dao
abstract class SchemeDao {


  @Query('SELECT * FROM Scheme')
  Future<List<SchemeEntity>> getAllSchemes();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<SchemeEntity> schemes);


  @Query('DELETE FROM Scheme')
  Future<void> clearTable();
}
