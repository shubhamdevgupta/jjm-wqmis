class WaterSourceResponse {
  final String locationId;
  final String locationName;

  WaterSourceResponse({required this.locationId, required this.locationName});

  // Factory method to create Location from JSON
  factory WaterSourceResponse.fromJson(Map<String, dynamic> json) {
    return WaterSourceResponse(
      locationId: json['location_id'] ?? '',
      locationName: json['location_name'] ?? '',
    );
  }

  // Method to convert Location to JSON
  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'location_name': locationName,
    };
  }

  @override
  String toString() {
    return 'Location(locationId: $locationId, locationName: $locationName)';
  }
}
