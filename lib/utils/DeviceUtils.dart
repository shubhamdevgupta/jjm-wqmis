
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await _deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
              _readAndroidBuildData(await _deviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
              _readIosDeviceInfo(await _deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
              _readLinuxDeviceInfo(await _deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
              _readWindowsDeviceInfo(await _deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
              _readMacOsDeviceInfo(await _deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, dynamic>{
            'Error:': 'Fuchsia platform isn\'t supported'
          },
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    return deviceData;
  }
  static Map<String, dynamic>  _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'name': build.name,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  }


  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return {
      'model': data.model,
      'systemVersion': data.systemVersion,
      'name': data.name,
      'identifierForVendor': data.identifierForVendor,
    };
  }

  static Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return {
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'prettyName': data.prettyName,
    };
  }

  static Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return {
      'computerName': data.computerName,
      'numberOfCores': data.numberOfCores,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }

  static Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return {
      'model': data.model,
      'osRelease': data.osRelease,
      'cpuFrequency': data.cpuFrequency,
    };
  }

  static Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return {
      'browserName': describeEnum(data.browserName),
      'userAgent': data.userAgent,
      'platform': data.platform,
    };
  }
}
