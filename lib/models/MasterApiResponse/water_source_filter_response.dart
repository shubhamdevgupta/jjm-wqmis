import 'package:jjm_wqmis/database/Entities/watersourcefilter_table.dart';

/// Core model used in app
class Watersourcefilterresponse {
  final String id;
  final String sourceType;

  Watersourcefilterresponse({
    required this.id,
    required this.sourceType,
  });

  /// From API JSON (was Watersourcefilterresponse)
  factory Watersourcefilterresponse.fromJson(Map<String, dynamic> json) {
    return Watersourcefilterresponse(
      id: json['Id'].toString(),
      sourceType: json['SourceType']?.trim() ?? '',
    );
  }

  /// Convert to DB entity (WaterSourceFilter table)
  WaterSourceFilter toEntity() {
    return WaterSourceFilter(id, sourceType);
  }

  /// Convert to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'SourceType': sourceType,
    };
  }

  @override
  String toString() => 'WaterSource(id: $id, type: $sourceType)';
}

/// API response wrapper
class WaterSourceFilterResponse {
  final int status;
  final String message;
  final List<Watersourcefilterresponse> result;

  WaterSourceFilterResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory WaterSourceFilterResponse.fromJson(Map<String, dynamic> json) {
    return WaterSourceFilterResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List)
          .map((e) => Watersourcefilterresponse.fromJson(e))
          .toList(),
    );
  }
}
