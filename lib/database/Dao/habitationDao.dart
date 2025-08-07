import 'package:floor/floor.dart';
import 'package:jjm_wqmis/database/Entities/habitation_table.dart';


@dao
abstract class HabitationDao {
  @Query('SELECT * FROM Habitation')
  Future<List<Habitation>> getAll();

  @insert
  Future<void> insertHabitation(Habitation habitation);

  @insert
  Future<void> insertAll(List<Habitation> habitations);

  @Query('DELETE FROM Habitation')
  Future<void> clearTable();
}
