import 'package:flutter/services.dart';

class VersionUtils {
  static const MethodChannel _channel = MethodChannel('com.example/location_permission');

  static Future<String?> getNativeAppVersion() async {
    try {
      final String version = await _channel.invokeMethod('getVersionName');
      return version;
    } on PlatformException catch (e) {
      return null;
    }
  }
}
