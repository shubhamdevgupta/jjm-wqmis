import 'package:floor/floor.dart';

@Entity(tableName: 'habitation')
class HabitationTable {
  @PrimaryKey()
  final String habitationId;

  final String villageId;
  final String habitationName;

  HabitationTable(this.habitationId, this.villageId, this.habitationName);
}
