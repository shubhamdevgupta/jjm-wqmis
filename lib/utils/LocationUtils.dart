import 'package:flutter/services.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';

class LocationUtils {
  static const MethodChannel _permissionChannel = MethodChannel('com.example/location_permission');

  /// Request Location Permission
  static Future<bool> requestLocationPermission() async {
    if (Platform.isAndroid) {
      try {
        final bool isGranted = await _permissionChannel.invokeMethod('requestPermission');
        debugPrint('Permission request result: $isGranted');
        return isGranted;
      } on PlatformException catch (e) {
        debugPrint('Error requesting location permission: $e');
        return false;
      }
    } else {
      // For iOS we assume permission is handled differently
      return true;
    }
  }

  /// Fetch Current Location
  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      final Map<dynamic, dynamic> location = await _permissionChannel.invokeMethod('getLocation');
      debugPrint('Fetched Location Data: $location');

      return {
        "latitude": location['latitude'],
        "longitude": location['longitude'],
      };
    } on PlatformException catch (e) {
      debugPrint('PlatformException while fetching location: ${e.message}');
      return null;
    }
  }
}
