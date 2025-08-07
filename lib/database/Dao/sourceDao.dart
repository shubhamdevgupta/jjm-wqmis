import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/source_table.dart';


@dao
abstract class SourcesDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllSources(List<SourcesEntity> sources);

  @Query('SELECT * FROM Sources')
  Future<List<SourcesEntity>> getAllSources();
}
