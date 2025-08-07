import 'package:floor/floor.dart';

@entity
class WaterSourceFilter {
  @primaryKey
  final int id;

  final String sourceType;

  WaterSourceFilter(this.id, this.sourceType);
}
