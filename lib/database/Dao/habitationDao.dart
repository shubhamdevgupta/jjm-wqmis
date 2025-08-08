import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/habitation_table.dart';

@dao
abstract class HabitationDao {
  @Query('SELECT * FROM habitation')
  Future<List<HabitationTable>> getAll();

  @insert
  Future<void> insertHabitation(HabitationTable habitation);

  @insert
  Future<void> insertAll(List<HabitationTable> habitations);

  @Query('DELETE FROM habitation')
  Future<void> clearTable();
}
