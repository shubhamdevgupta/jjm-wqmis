import 'package:jjm_wqmis/database/Entities/source_table.dart';

class SourceModel {
  final int sourceType;
  final int sourceTypeCategoryId;
  final int schemeId;
  final int villageId;
  final int habitationId;
  final int locationId;
  final String locationName;
  final int isFhtc;

  SourceModel({
    required this.sourceType,
    required this.sourceTypeCategoryId,
    required this.schemeId,
    required this.villageId,
    required this.habitationId,
    required this.locationId,
    required this.locationName,
    required this.isFhtc,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      sourceType: json['SourceType'],
      sourceTypeCategoryId: json['SourceTypeCategoryId'],
      schemeId: json['SchemeId'],
      villageId: json['VillageId'],
      habitationId: json['HabitationId'],
      locationId: json['location_id'],
      locationName: json['location_name'],
      isFhtc: json['Is_fhtc'],
    );
  }

  SourcesEntity toEntity(){
    return SourcesEntity(location_id: locationId, SourceType: sourceType, SourceTypeCategoryId: sourceTypeCategoryId, SchemeId: schemeId, VillageId: villageId, HabitationId: habitationId, Is_fhtc: isFhtc, location_name: locationName);
  }

}
