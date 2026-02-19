import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/location/location_dialog.dart';
import 'location_utils.dart';

class CurrentLocation {
  static double? _latitude;
  static double? _longitude;

  static bool _isFetching = false;

  /// Public getters
  static double? get latitude => _latitude;
  static double? get longitude => _longitude;

  static bool get hasLocation =>
      _latitude != null && _longitude != null;

  /// Initialize & Fetch location (call once at app start or login)
  static Future<bool> init() async {
    if (_isFetching) return false;
    _isFetching = true;

    try {
      // 1️⃣ Permission
      bool permissionGranted =
      await LocationUtils.requestLocationPermission();

      if (!permissionGranted) {
        debugPrint("Permission denied");
        return false;
      }

      // 2️⃣ Service check
      bool serviceEnabled =
      await LocationUtils.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await LocationUtils.openLocationSettings();
        return false;
      }

      // 3️⃣ Fetch location
      final location =
      await LocationUtils.getCurrentLocation();

      if (location != null) {
        _latitude = location["latitude"];
        _longitude = location["longitude"];
        debugPrint("Location stored successfully");
        return true;
      }

      debugPrint("Location returned null");
      return false;

    } finally {
      _isFetching = false;
    }
  }

  /// Force refresh location manually
  static Future<void> refresh() async {
    final location =
    await LocationUtils.getCurrentLocation();

    if (location != null) {
      _latitude = location["latitude"];
      _longitude = location["longitude"];
    }
  }

  /// Get cached location map
  static Map<String, double>? getLocation() {
    if (hasLocation) {
      return {
        'latitude': _latitude!,
        'longitude': _longitude!,
      };
    }
    return null;
  }

  /// Clear location (logout case)
  static void clear() {
    _latitude = null;
    _longitude = null;
  }
}
