// lib/models/water_source_response.dart

class WaterSourceApiResponse {
  final int status;
  final String message;
  final List<WaterSourceResponse> result;

  WaterSourceApiResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory WaterSourceApiResponse.fromJson(Map<String, dynamic> json) {
    return WaterSourceApiResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>)
          .map((e) => WaterSourceResponse.fromJson(e))
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
      'WaterSourceApiResponse(status: $status, message: $message, resultCount: ${result.length})';
}

class WaterSourceResponse {
  final String locationId;
  final String locationName;

  WaterSourceResponse({
    required this.locationId,
    required this.locationName,
  });

  factory WaterSourceResponse.fromJson(Map<String, dynamic> json) {
    return WaterSourceResponse(
      locationId: json['location_id'] ?? '',
      locationName: json['location_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'location_name': locationName,
    };
  }

  @override
  String toString() =>
      'WaterSourceResponse(locationId: $locationId, locationName: $locationName)';
}
