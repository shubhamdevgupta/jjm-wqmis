import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/DWSM/dashboard_school_response.dart';
import 'package:jjm_wqmis/models/DWSM/ftk_demonstration_list_response.dart';
import 'package:jjm_wqmis/repository/dwsm_repository.dart';

import 'package:jjm_wqmis/models/DWSM/school_info_response.dart';
import 'package:jjm_wqmis/models/DashboardResponse/dwsm_dashboard_response.dart';
import 'package:jjm_wqmis/utils/device_utils.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/school_aganwadi_screen.dart';

class DwsmProvider extends ChangeNotifier {
  final DwsmRepository _dwsmRepository = DwsmRepository();

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<VillageInfo> villages = [];
  int baseStatus = 101;


  List<DashboardSchoolModel> dashboardSchoolListModel = [];

  List<SchoolResult> schoolResultList = [];
  String? selectedSchoolResult;
  String? selectedSchoolName;
  String? selectedSchoolDate;

  DataState dataState = DataState.initial;

  List<SchoolResult> anganwadiList = [];
  String? selectedAnganwadi;
  String? selectedAnganwadiName;
  String? selectedAnganwadiDate;
  int? mDemonstrationId;

  Dwsmdashboardresponse? _dwsmdashboardresponse;

  Dwsmdashboardresponse? get dwsmdashboardresponse => _dwsmdashboardresponse;

  String? _deviceId;

  String? get deviceId => _deviceId;

  bool _showDemonstartion = false;

  bool get showDemonstartion => _showDemonstartion;

  String? ftkSubmitResponse;
  String? villagePhoto;

  String errorMessage='';

  Future<void> fetchDwsmDashboard(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _dwsmRepository.fetchDwsmDashboard(userId);
      _dwsmdashboardresponse = response;
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDemonstrationList(int stateId, int districtId,
      String fineYear, String schoolId, int demonstrationType,int regId,
      {Function(VillageInfo result)? onSuccess}) async {
    _isLoading = true;
    villages = [];
    notifyListeners();
    try {
      final rawLIst = await _dwsmRepository.fetchDemonstrationList(
        stateId: stateId,
        districtId: districtId,
        fineYear: fineYear,
        schoolId: schoolId,
        demonstrationType: demonstrationType,
        regId: regId
      );
      baseStatus = rawLIst.status;
      if (rawLIst.status == 1) {
        if (schoolId != "0" && onSuccess != null) {
            onSuccess(rawLIst.result.first);
        } else {
          villages = rawLIst.result;
        }
      } else {
        errorMessage = rawLIst.message;
      }
    } catch (e) {
      debugPrint('Error in fetchDemonstrationList: $e');
      // GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSchoolAwcInfo(int stateId, int districtId, int blockId,
      int gpId, int villageId, int type,int regId) async {
    _isLoading = true;
    dataState = DataState.loading;
    try {
      final rawSchoolInfo = await _dwsmRepository.fetchSchoolAwcInfo(
          stateId, districtId, blockId, gpId, villageId, type, regId);

      if (rawSchoolInfo.status == 1) {
        if (type == 0) {
          schoolResultList = rawSchoolInfo.result;
        } else if (type == 1) {
          anganwadiList = rawSchoolInfo.result;
        }
        dataState = DataState.loaded;
      } else {
        errorMessage = rawSchoolInfo.message;
        dataState = DataState.error;
      }
      baseStatus = rawSchoolInfo.status;
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDashboardSchoolList(
      int stateId, int districtId, int demonstrationType, int regId) async {
    _isLoading = true;

    notifyListeners();
    try {
      final rawSchoolInfo = await _dwsmRepository.fetchDashboardSchoolList(
          stateId, districtId, demonstrationType,regId);

      if (rawSchoolInfo.status == 1) {
        dashboardSchoolListModel = rawSchoolInfo.result;
      } else {
        errorMessage = rawSchoolInfo.message;
      }
      baseStatus = rawSchoolInfo.status;
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(Exception(e.toString())); // ✅ Safe wrap
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitDemonstration(
    int userId,
    int schoolId,
    int stateId,
    String photoBase64,
    String fineYear,
    String remark,
    String latitude,
    String longitude,
    String ipAddress,
    int regId,
    Function onSuccess,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final rawSchoolInfo = await _dwsmRepository.submitDemonstration(
          userId,
          schoolId,
          stateId,
          photoBase64,
          fineYear,
          remark,
          latitude,
          longitude,
          ipAddress,regId);
      baseStatus = rawSchoolInfo.status;
      if (rawSchoolInfo.status == 1) {
        ftkSubmitResponse = rawSchoolInfo.message;
      } else {
        errorMessage = rawSchoolInfo.message;
      }
      onSuccess();
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDeviceId() async {
    _deviceId = await DeviceInfoUtil.getUniqueDeviceId();
    debugPrint('Device ID: $_deviceId');
    notifyListeners();
  }

  void showDemonstartionButton(bool value) {
    _showDemonstartion = value;
    notifyListeners();
  }

  void setSelectedSchool(
      String id, String name, int demonstrationId, String demoDate) {
    selectedSchoolResult = id;
    selectedSchoolName = name;
    selectedSchoolDate = demoDate;
    mDemonstrationId = demonstrationId;
    notifyListeners();
  }

  void setSelectedAnganwadi(
      String id, String name, int demonstrationId, String demoDate) {
    selectedAnganwadi = id;
    selectedAnganwadiName = name;
    mDemonstrationId = demonstrationId;
    selectedAnganwadiDate = demoDate;
    schoolResultList = [];
    notifyListeners();
  }

  void clearSelectedSchool() {
    selectedSchoolResult = null;
    selectedSchoolName = 'N/A';
    selectedSchoolDate = 'N/A';
    schoolResultList = [];
    notifyListeners();
  }

  void clearSelectedAnganwadi() {
    selectedAnganwadi = null;
    selectedAnganwadiName = 'N/A';
    selectedAnganwadiDate = 'N/A';
    mDemonstrationId = 101;
    anganwadiList = [];
    notifyListeners();
  }

  void clearData() {
    selectedAnganwadi = null;
    selectedAnganwadiName = 'N/A';
    selectedAnganwadiDate = 'N/A';
    mDemonstrationId = 101;
    anganwadiList.clear();
    selectedSchoolResult = null;
    selectedSchoolName = 'N/A';
    selectedSchoolDate = 'N/A';
    schoolResultList = [];
    notifyListeners();
  }
}
