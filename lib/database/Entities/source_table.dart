import 'package:floor/floor.dart';

@Entity(tableName: 'Sources')
class SourcesEntity {
  @PrimaryKey()
  final String location_id;
  final int SourceType;
  final int SourceTypeCategoryId;
  final int SchemeId;
  final int VillageId;
  final int HabitationId;
  final int Is_fhtc;
  final String location_name;

  SourcesEntity({
    required this.location_id,
    required this.SourceType,
    required this.SourceTypeCategoryId,
    required this.SchemeId,
    required this.VillageId,
    required this.HabitationId,
    required this.Is_fhtc,
    required this.location_name,
  });
}
