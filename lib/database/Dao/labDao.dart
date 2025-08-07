import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/lab_table.dart';


@dao
abstract class LabDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllLabs(List<LabEntity> labs);

  @Query('SELECT * FROM Lab')
  Future<List<LabEntity>> getAllLabs();
}
