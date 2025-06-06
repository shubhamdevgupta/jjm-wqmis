import 'package:shared_preferences/shared_preferences.dart';

import 'package:jjm_wqmis/utils/AppConstants.dart';

class UserSessionManager {
  static final UserSessionManager _instance = UserSessionManager._internal();

  factory UserSessionManager() {
    return _instance;
  }

  UserSessionManager._internal();

  late SharedPreferences _prefs;

  String token = '';
  String userName = '';
  String mobile = '';
  String regId = '';

  String stateName = '';
  String districtName='';
  String blockName='';
  String panchayatName='';
  String villageName='';

  int stateId = 0;
  int districtId = 0;
  int blockId = 0;
  int panchayatId = 0;
  int villageId = 0;


  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString(AppConstants.prefToken) ?? '';
    userName = _prefs.getString(AppConstants.prefName) ?? '';
    mobile = _prefs.getString(AppConstants.prefMobile) ?? '';
    regId = _prefs.getString(AppConstants.prefRegId) ?? '';


    stateId = _prefs.getInt(AppConstants.prefStateId)!;
    districtId = _prefs.getInt(AppConstants.prefDistrictId)??0;
    blockId = _prefs.getInt(AppConstants.prefBlockId)??0;
    panchayatId = _prefs.getInt(AppConstants.prefPanchayatId)??0;
    villageId = _prefs.getInt(AppConstants.prefVillageId)??0;

    stateName = _prefs.getString(AppConstants.prefStateName) ?? '';
    districtName = _prefs.getString(AppConstants.prefDistName) ?? '';
    blockName = _prefs.getString(AppConstants.prefBlockName) ?? '';
    panchayatName= _prefs.getString(AppConstants.prefGramPanchayatName) ?? '';
    villageName = _prefs.getString(AppConstants.prefVillageName) ?? '';
  }

  // If needed, you can still access values directly
  String getToken() => token;
}
