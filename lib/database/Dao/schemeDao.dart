import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/scheme_table.dart';

@dao
abstract class SchemeDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllSchemes(List<SchemeEntity> schemes);

  @Query('SELECT * FROM Scheme')
  Future<List<SchemeEntity>> getAllSchemes();
}
