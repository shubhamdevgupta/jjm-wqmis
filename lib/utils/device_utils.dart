import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static String? _deviceId;
  static bool _initialized = false;

  /// Call this once at app startup
  static Future<void> init() async {
    if (_initialized) return;

    try {
      if (kIsWeb) {
        final info = await _deviceInfoPlugin.webBrowserInfo;
        _deviceId = '${info.userAgent} ${info.platform}';
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            final androidInfo = await _deviceInfoPlugin.androidInfo;
            _deviceId =
            '${androidInfo.brand} ${androidInfo.model} ${androidInfo.id}';
            break;

          case TargetPlatform.iOS:
            final iosInfo = await _deviceInfoPlugin.iosInfo;
            _deviceId =
            '${iosInfo.name} ${iosInfo.systemVersion} ${iosInfo.identifierForVendor ?? 'Unknown_iOS_Device'}';
            break;

          case TargetPlatform.windows:
            final windowsInfo = await _deviceInfoPlugin.windowsInfo;
            _deviceId =
            '${windowsInfo.computerName} ${windowsInfo.systemMemoryInMegabytes}';
            break;

          case TargetPlatform.macOS:
            final macInfo = await _deviceInfoPlugin.macOsInfo;
            _deviceId = '${macInfo.model} ${macInfo.osRelease}';
            break;

          case TargetPlatform.linux:
            final linuxInfo = await _deviceInfoPlugin.linuxInfo;
            _deviceId =
            '${linuxInfo.name} ${linuxInfo.version} ${linuxInfo.machineId ?? 'Unknown_Linux_Device'}';
            break;

          case TargetPlatform.fuchsia:
            _deviceId = 'Fuchsia_NotSupported';
            break;
        }
      }

      _initialized = true;
    } on PlatformException catch (e) {
      debugPrint('Error fetching device info: $e');
      _deviceId = 'Unknown_Device';
    }
  }

  /// Access anywhere
  static String get deviceId => _deviceId ?? 'Unknown_Device';
}