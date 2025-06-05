import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Returns a unique device identifier as a String
  static Future<String> getUniqueDeviceId() async {
    try {
      if (kIsWeb) {

        final info = await _deviceInfoPlugin.webBrowserInfo;
        return '${info.userAgent} ${info.platform}';
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final androidInfo = await _deviceInfoPlugin.androidInfo;
          return '${androidInfo.brand} ${androidInfo.model} ${androidInfo.id}';

        case TargetPlatform.iOS:
          final iosInfo = await _deviceInfoPlugin.iosInfo;

          return '${iosInfo.name} ${iosInfo.systemVersion} ${iosInfo.identifierForVendor ?? 'Unknown_iOS_Device'}';

        case TargetPlatform.windows:
          final windowsInfo = await _deviceInfoPlugin.windowsInfo;

          return '${windowsInfo.computerName} ${windowsInfo.systemMemoryInMegabytes}';

        case TargetPlatform.macOS:
          final macInfo = await _deviceInfoPlugin.macOsInfo;

          return '${macInfo.model} ${macInfo.osRelease} ';

        case TargetPlatform.linux:
          final linuxInfo = await _deviceInfoPlugin.linuxInfo;
          return '${linuxInfo.name} ${linuxInfo.version} ${linuxInfo.machineId ?? 'Unknown_Linux_Device'}';

        case TargetPlatform.fuchsia:
          return 'Fuchsia_NotSupported';
      }
    } on PlatformException catch (e) {
      debugPrint('Error fetching device info: $e');
      return 'Unknown_Device';
    }
    return 'Unknown_Platform';
  }
}