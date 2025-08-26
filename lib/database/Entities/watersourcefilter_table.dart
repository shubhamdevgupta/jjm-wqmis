import 'package:floor/floor.dart';

@entity
class WaterSourceFilter {
  @primaryKey
  final String id;

  final String SourceType;

  WaterSourceFilter(this.id, this.SourceType);
}
