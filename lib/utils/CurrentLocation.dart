class CurrentLocation {
  static double? latitude;
  static double? longitude;

  static bool get hasLocation => latitude != null && longitude != null;

  static void setLocation({required double lat, required double lng}) {
    latitude = lat;
    longitude = lng;
  }

  static Map<String, double>? getLocation() {
    if (hasLocation) {
      return {
        'latitude': latitude!,
        'longitude': longitude!,
      };
    }
    return null;
  }
}
