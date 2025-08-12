import 'package:floor/floor.dart';

@entity
class WaterSourceFilter {
  @primaryKey
  final int id;

  final String SourceType;

  WaterSourceFilter(this.id, this.SourceType);
}
