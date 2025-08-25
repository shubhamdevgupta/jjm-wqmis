import 'package:floor/floor.dart';

@Entity(tableName: 'Scheme')
class SchemeResponse {
  @PrimaryKey()
  final String? schemeId;
  final String? schemeName;
  final int? sourceType;
  final int? villageId;

  SchemeResponse({
    this.schemeId,
    this.schemeName,
    this.sourceType,
    this.villageId,
  });

  factory SchemeResponse.fromJson(Map<String, dynamic> json) {
    return SchemeResponse(
      schemeId: json['SchemeId']?.toString() ?? '',
      schemeName: json['SchemeName'] ?? '',
      villageId: int.tryParse(json['VillageId']?.toString() ?? ''),
      sourceType: int.tryParse(json['SourceType']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SchemeId': schemeId,
      'SchemeName': schemeName,
      'VillageId': villageId,
      'SourceType': sourceType,
    };
  }

  @override
  String toString() => 'SchemeResponse(id: $schemeId, name: $schemeName)';
}
