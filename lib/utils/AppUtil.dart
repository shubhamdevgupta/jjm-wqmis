import 'package:package_info_plus/package_info_plus.dart';

class AppUtil {
  static String _appVersion = "";
  static bool _isLoaded = false;

  /// Call this ONCE during app startup (like in main())
  static Future<void> init() async {
    if (_isLoaded) return;

    final info = await PackageInfo.fromPlatform();
    _appVersion = info.version;
    _isLoaded = true;
  }

  /// Getter to access version anywhere
  static String get appVersion => _appVersion;

  /// If someone wants future-based version (optional)
  static Future<String> getAppVersion() async {
    if (_isLoaded) return _appVersion;

    await init();
    return _appVersion;
  }
}
