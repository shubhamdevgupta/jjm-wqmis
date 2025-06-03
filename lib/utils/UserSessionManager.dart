import 'package:shared_preferences/shared_preferences.dart';

import 'AppConstants.dart';

class UserSessionManager {
  static final UserSessionManager _instance = UserSessionManager._internal();

  factory UserSessionManager() {
    return _instance;
  }

  UserSessionManager._internal();

  late SharedPreferences _prefs;

  String token = '';
  String stateName = '';
  String districtId = '';
  String userName = '';
  String mobile = '';
  String stateId = '';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString(AppConstants.prefToken) ?? '';
    stateName = _prefs.getString(AppConstants.prefStateName) ?? '';
    userName = _prefs.getString(AppConstants.prefName) ?? '';
    mobile = _prefs.getString(AppConstants.prefMobile) ?? '';
    stateId = _prefs.getString(AppConstants.prefStateId) ?? '';
    districtId = _prefs.getString(AppConstants.prefDistrictId) ?? '';
  }

  // If needed, you can still access values directly
  String getToken() => token;
}
