import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/source_table.dart';


@dao
abstract class SourcesDao {


  @Query('SELECT * FROM Sources')
  Future<List<SourcesEntity>> getAllSources();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<SourcesEntity> sources);

  @Query('DELETE FROM Sources')
  Future<void> clearTable();




}
