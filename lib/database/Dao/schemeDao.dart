import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/scheme_table.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/scheme_response.dart';

@dao
abstract class SchemeDao {


  @Query('SELECT * FROM Scheme')
  Future<List<SchemeResponse>> getAllSchemes();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<SchemeResponse> schemes);


  @Query('SELECT SchemeId, SchemeName FROM scheme WHERE VillageId = :villageId AND SourceType = :sourceType')
  Future<List<SchemeResponse>> getSchemesByVillageAndSource(int villageId, int sourceType);


  @Query('DELETE FROM Scheme')
  Future<void> clearTable();
}
