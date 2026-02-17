import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class LocationUtils {
  static const MethodChannel _permissionChannel =
  MethodChannel('com.example/location_permission');

  /// Request Location Permission
  static Future<bool> requestLocationPermission() async {
    if (Platform.isAndroid) {
      try {
        final bool isGranted =
        await _permissionChannel.invokeMethod('requestPermission');
        debugPrint('Permission request result: $isGranted');
        return isGranted;
      } on PlatformException catch (e) {
        debugPrint('Error requesting location permission: $e');
        return false;
      }
    } else {
      return true;
    }
  }

  /// Check if Location Service (GPS) is Enabled
  static Future<bool> isLocationServiceEnabled() async {
    if (Platform.isAndroid) {
      try {
        final bool isEnabled =
        await _permissionChannel.invokeMethod('isLocationServiceEnabled');
        debugPrint('Location Service Enabled: $isEnabled');
        return isEnabled;
      } on PlatformException catch (e) {
        debugPrint('Error checking location service: $e');
        return false;
      }
    } else {
      return true;
    }
  }

  /// Open Location Settings
  static Future<void> openLocationSettings() async {
    if (Platform.isAndroid) {
      try {
        await _permissionChannel.invokeMethod('openLocationSettings');
      } on PlatformException catch (e) {
        debugPrint('Error opening location settings: $e');
      }
    }
  }

  /// Fetch Current Location
  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      final Map<dynamic, dynamic>? location =
      await _permissionChannel.invokeMethod('getLocation');

      if (location == null ||
          location['latitude'] == null ||
          location['longitude'] == null) {
        debugPrint('Location data is incomplete');
        return null;
      }

      debugPrint('Fetched Location Data: $location');

      return {
        "latitude": location['latitude'],
        "longitude": location['longitude'],
      };
    } on PlatformException catch (e) {
      debugPrint(
          'PlatformException while fetching location: ${e.message}');
      return null;
    }
  }
}
