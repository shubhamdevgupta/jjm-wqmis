import 'package:floor/floor.dart';

@Entity(tableName: 'habitation')
class HabitationTable {
  @PrimaryKey()
  final int habitationId;

  final int villageId;
  final String habitationName;

  HabitationTable(this.habitationId, this.villageId, this.habitationName);
}
