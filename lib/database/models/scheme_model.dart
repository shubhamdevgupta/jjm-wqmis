
import 'package:jjm_wqmis/database/Entities/scheme_table.dart';

class SchemeModel {
  final int sourceType;
  final int schemeId;
  final int villageId;
  final String schemeName;

  SchemeModel({
    required this.sourceType,
    required this.schemeId,
    required this.villageId,
    required this.schemeName,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      sourceType: json['SourceType'],
      schemeId: json['SchemeId'],
      villageId: json['VillageId'],
      schemeName: json['SchemeName'],
    );
  }

  SchemeEntity toEntity(){
    return SchemeEntity(SchemeId: schemeId, SourceType: sourceType, VillageId: villageId, SchemeName: schemeName);
  }

}
