import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/update_response.dart';
import 'package:jjm_wqmis/repository/app_update_repo.dart';
import 'package:jjm_wqmis/services/local_storage_service.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';

class UpdateViewModel extends ChangeNotifier {
  final Appupdaterepo _repo = Appupdaterepo();
  final LocalStorageService _localStorage = LocalStorageService();
  bool _isChecking = false;
  bool _isDialogShown = false;

  // Throttle duration: 15 minutes
  static const int _throttleMinutes = 15;

  /// Checks if enough time has passed since last update check
  bool shouldCheckForUpdate() {
    final lastCheckTime = _localStorage.getInt(AppConstants.prefLastUpdateCheckTime);
    if (lastCheckTime == null) {
      return true; // Never checked before
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final timeDiff = now - lastCheckTime;
    final minutesPassed = timeDiff / (1000 * 60);

    return minutesPassed >= _throttleMinutes;
  }

  /// Saves the current timestamp as last update check time
  Future<void> _saveLastCheckTime() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _localStorage.saveInt(AppConstants.prefLastUpdateCheckTime, now);
  }

  /// Checks for update with throttling logic
  /// Returns true if update is available, false otherwise
  Future<bool> checkForUpdateWithThrottle({bool forceCheck = false}) async {
    // Prevent multiple simultaneous checks
    if (_isChecking) {
      return false;
    }

    // Check throttling unless forced
    if (!forceCheck && !shouldCheckForUpdate()) {
      return false;
    }

    _isChecking = true;
    try {
      final isAvailable = await checkForUpdate();
      await _saveLastCheckTime();
      return isAvailable;
    } finally {
      _isChecking = false;
    }
  }

  /// Original checkForUpdate method (kept for backward compatibility)
  Future<bool> checkForUpdate() async {
    return await _repo.isUpdateAvailable();
  }

  Future<Updateresponse?> getUpdateInfo() async {
    try {
      return await _repo.fetchUpdateInfo();
    } catch (_) {
      return null;
    }
  }

  /// Getter to check if dialog is currently shown
  bool get isDialogShown => _isDialogShown;

  /// Set dialog shown state
  void setDialogShown(bool value) {
    _isDialogShown = value;
  }
}
