
import '../services/UpdateService.dart';

class UpdateViewModel {
  final UpdateService _updateService = UpdateService();

  Future<bool> checkForUpdate() async {
    return await _updateService.isUpdateAvailable();
  }

  Future<Map<String, dynamic>?> getUpdateInfo() async {
    return await _updateService.fetchUpdateInfo();
  }
}
