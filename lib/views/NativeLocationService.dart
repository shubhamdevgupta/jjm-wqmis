import 'package:flutter/services.dart';

class NativeLocationService {
  static const platform = MethodChannel('com.example.location/get');

  static Future<Map<String, double>?> getLocation() async {
    try {
      final result = await platform.invokeMethod<Map>('getLocation');
      if (result != null) {
        return {
          'latitude': result['latitude'],
          'longitude': result['longitude'],
        };
      }
    } on PlatformException catch (e) {
      print("Failed to get location: '${e.message}'.");
    }
    return null;
  }
}
