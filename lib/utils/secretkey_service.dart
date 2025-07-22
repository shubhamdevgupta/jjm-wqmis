import 'package:flutter/services.dart';

class SecretKeyService {
  static const MethodChannel _permissionChannel = MethodChannel('com.example/location_permission');


  static Future<String> getSecretKey() async {
    final key = await _permissionChannel.invokeMethod<String>('getSecretKey');
    return key ?? '';
  }
}
