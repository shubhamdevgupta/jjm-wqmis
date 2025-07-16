import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/update_response.dart';
import 'package:jjm_wqmis/repository/app_update_repo.dart';

class UpdateViewModel extends ChangeNotifier {
  final Appupdaterepo _repo = Appupdaterepo();

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
}
