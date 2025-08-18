// lib/models/scheme_api_response.dart

import 'package:floor/floor.dart';

class SchemeApiResponse {
  final int status;
  final String message;
  final List<SchemeResponse> result;

  SchemeApiResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory SchemeApiResponse.fromJson(Map<String, dynamic> json) {
    return SchemeApiResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>)
          .map((e) => SchemeResponse.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Result': result.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'SchemeApiResponse(status: $status, message: $message, resultCount: ${result.length})';
}
// lib/models/scheme_response.dart
@Entity(tableName: 'Scheme')
class SchemeResponse {
  @PrimaryKey()
  final int? schemeId;
  final String? schemeName;

  final int? sourceType; // make nullable
  final int? villageId;  // make nullable

  SchemeResponse({
    this.schemeId,
     this.schemeName,
    this.sourceType,
    this.villageId
    ,
  });

  factory SchemeResponse.fromJson(Map<String, dynamic> json) {
    return SchemeResponse(
      schemeId: json['SchemeId'] ?? '',
      schemeName: json['SchemeName'] ?? '',

      villageId: json['VillageId'] ?? '',
      sourceType: json['SourceType']?? '',

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SchemeId': schemeId,
      'SchemeName': schemeName,

      'VillageId': sourceType,
      'SourceType': villageId,



    };
  }

  @override
  String toString() => 'SchemeResponse(id: $schemeId, name: $schemeName)';
}
