import 'package:floor/floor.dart';

@entity
class Habitation {
  @primaryKey
  final int habitationId;

  final int villageId;
  final String habitationName;

  Habitation(this.habitationId, this.villageId, this.habitationName);
}
