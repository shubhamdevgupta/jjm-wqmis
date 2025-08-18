
import 'package:jjm_wqmis/database/Entities/scheme_table.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/scheme_response.dart';

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

  SchemeResponse toEntity(){
    return SchemeResponse(schemeId: schemeId, sourceType: sourceType, villageId: villageId, schemeName: schemeName);
  }

}
