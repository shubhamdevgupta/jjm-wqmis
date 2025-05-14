import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/DWSM/DashBoardSchoolModel.dart';
import 'package:jjm_wqmis/models/DWSM/DwsmDashboard.dart';
import 'package:jjm_wqmis/repository/DwsmRepository.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/BaseResponse.dart';
import '../models/DWSM/Ftk_response.dart';
import '../models/DWSM/SchoolinfoResponse.dart';
import '../models/DashboardResponse/DwsmDashboardResponse.dart';
import '../utils/DataState.dart';
import '../utils/DeviceUtils.dart';
import '../utils/GlobalExceptionHandler.dart';
import '../utils/LocationUtils.dart';
import '../views/DWSM/tabschoolaganwadi/TabSchoolAganwadi.dart';

class DwsmProvider extends ChangeNotifier {
  final DwsmRepository _dwsmRepository = DwsmRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;


  List<Village> villages = [];
  String errorMsg = '';
  int baseStatus = 101;

  List<DashboardSchoolModel> dashboardSchoolListModel = [];

  List<SchoolResult> schoolResultList = [];
  String? selectedSchoolResult;
  String? selectedSchoolName;

  DataState dataState = DataState.initial;

  List<SchoolResult> anganwadiList = [];
  String? selectedAnganwadi;
  String? selectedAnganwadiName;
  int? mDemonstrationId;

  Dwsmdashboardresponse? _dwsmdashboardresponse;

  Dwsmdashboardresponse? get dwsmdashboardresponse => _dwsmdashboardresponse;

  double? get currentLatitude => _currentLatitude;
  double? get currentLongitude => _currentLongitude;

  double? _currentLatitude;
  double? _currentLongitude;

  String? _deviceId;

  String? get deviceId => _deviceId;

  bool _showDemonstartion = false;
  bool get showDemonstartion => _showDemonstartion;

  String? ftkSubmitResponse;
  String? villagePhoto;

  String? errorMessage;
  BaseResponseModel<FTKResponse>? ftkResponse;

  Future<void> fetchDwsmDashboard(int userId) async {
    _isLoading = true;
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
      String fineYear, int schoolId, int demonstrationType,
      {Function(Village result)? onSuccess}) async {

    _isLoading = true;

    try {
      final rawLIst = await _dwsmRepository.fetchDemonstrationList(
        stateId: stateId,
        districtId: districtId,
        fineYear: fineYear,
        schoolId: schoolId,
        demonstrationType: demonstrationType,
      );
      if (rawLIst.status == 1) {
        if (schoolId != 0) {
          if (onSuccess != null) {
            onSuccess(rawLIst.result[0] /*.photo*/);
          }
        } else {
          villages = rawLIst.result;
        }
      } else {
        errorMessage = rawLIst.message;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error in fetchDemonstrationList: $e');
     // GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSchoolAwcInfo(int Stateid, int Districtid, int Blockid,
      int Gpid, int Villageid, int type) async {
    _isLoading = true;
    dataState=DataState.loading;
    try {
      final rawSchoolInfo = await _dwsmRepository.fetchSchoolAwcInfo(
          Stateid, Districtid, Blockid, Gpid, Villageid, type);

      if (rawSchoolInfo.status == 1) {
        if (type == 0) {
          schoolResultList = rawSchoolInfo.result;
        } else if (type == 1) {
          anganwadiList = rawSchoolInfo.result;
        }
        dataState = DataState.loaded;
      } else {
        errorMsg = rawSchoolInfo.message;
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
      int stateId, int districtId, int demonstrationType) async {
    _isLoading = true;

    notifyListeners();
    print('loading startt.............................');
    try {
      final rawSchoolInfo = await _dwsmRepository.fetchDashboardSchoolList(
          stateId, districtId, demonstrationType);

      if (rawSchoolInfo.status == 1) {
        dashboardSchoolListModel = rawSchoolInfo.result;
      } else {
        errorMsg = rawSchoolInfo.message;
      }
      baseStatus = rawSchoolInfo.status;
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      print('loading stoppeddd.............................');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitFtkData(
    int userId,
    int schoolId,
    int stateId,
    String photoBase64,
    String fineYear,
    String remark,
    String latitude,
    String longitude,
    String ipAddress,
    Function onSuccess,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final rawSchoolInfo = await _dwsmRepository.submitFtk(
          userId,
          schoolId,
          stateId,
          photoBase64,
          fineYear,
          remark,
          latitude,
          longitude,
          ipAddress);
      baseStatus = rawSchoolInfo.status;
      if (rawSchoolInfo.status == 1) {
        ftkSubmitResponse = rawSchoolInfo.message;
      } else {
        errorMsg = rawSchoolInfo.message;
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

  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();
    try {
      debugPrint('Requesting location permission...');
      bool permissionGranted = await LocationUtils.requestLocationPermission();

      if (permissionGranted) {
        debugPrint('Permission granted. Fetching location...');
        final locationData = await LocationUtils.getCurrentLocation();

        if (locationData != null) {
          _currentLatitude = locationData['latitude'];
          _currentLongitude = locationData['longitude'];

          debugPrint(
              'Location Fetched: Lat: $_currentLatitude, Lng: $_currentLongitude');
        } else {
          debugPrint("Location fetch failed (locationData is null)");
        }
      } else {
        debugPrint("Permission denied. Cannot fetch location.");
      }
    } catch (e) {
      debugPrint("Error during fetchLocation(): $e");
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


  void showDemonstartionButton( bool value) {
    _showDemonstartion = value;
    notifyListeners();

  }
  void setSelectedSchool(String id, String name, int demonstrationId) {
    selectedSchoolResult = id;
    selectedSchoolName = name;
    mDemonstrationId = demonstrationId;
    notifyListeners();
  }

  void setSelectedAnganwadi(String id, String name, int demonstrationId) {
    selectedAnganwadi = id;
    selectedAnganwadiName = name;
    mDemonstrationId = demonstrationId;
    schoolResultList=[];
    notifyListeners();
  }

  void clearSelectedSchool() {
    selectedSchoolResult = null;
    selectedSchoolName = 'N/A';
    schoolResultList=[];
    notifyListeners();
  }

  void clearSelectedAnganwadi() {
    selectedAnganwadi = null;
    selectedAnganwadiName = 'N/A';
    mDemonstrationId = 101;
    anganwadiList=[];
    notifyListeners();
  }
  void clearData(){
    selectedAnganwadi = null;
    selectedAnganwadiName = 'N/A';
    mDemonstrationId = 101;
    anganwadiList.clear();
    selectedSchoolResult = null;
    selectedSchoolName = 'N/A';
    schoolResultList=[];
    notifyListeners();
  }
}
