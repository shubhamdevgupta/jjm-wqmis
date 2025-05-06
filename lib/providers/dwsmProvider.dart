import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:jjm_wqmis/models/DWSM/DwsmDashboard.dart';
import 'package:jjm_wqmis/repository/DwsmRepository.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/BaseResponse.dart';
import '../models/DWSM/Ftk_response.dart';
import '../models/DWSM/SchoolinfoResponse.dart';
import '../utils/DeviceUtils.dart';
import '../utils/GlobalExceptionHandler.dart';
import '../utils/LocationUtils.dart';

class DwsmDashboardProvider extends ChangeNotifier {
  final DwsmRepository _dwsmRepository = DwsmRepository();

  bool isLoading = false;

  List<Village> villages = [];
  String errorMsg = '';
  int baseStatus = 101;

  List<SchoolResult> schoolResultList = [];
  String? selectedSchoolResult;
  String? selectedSchoolName;

  List<SchoolResult> anganwadiList = [];
  String? selectedAnganwadi;
  String? selectedAnganwadiName;

  double? get currentLatitude => _currentLatitude;

  double? get currentLongitude => _currentLongitude;

  double? _currentLatitude;
  double? _currentLongitude;

  String? _deviceId;

  String? get deviceId => _deviceId;

  String? ftkSubmitResponse;
  String? villagePhoto;

  String? errorMessage;
  BaseResponseModel<FTKResponse>? ftkResponse;

  Future<void> fetchDemonstrationList(int stateId, int DistrictId, String fineYear, int schoolId,{ Function(String result)? onSuccess}) async {
    isLoading = true;
  ///  notifyListeners();
    try {
      final rawLIst = await _dwsmRepository.fetchDemonstrationList(
          stateId, DistrictId, fineYear, schoolId);
        if (rawLIst.status==1) {
          final List<Village> newData = rawLIst.result;

          if (schoolId != 0) {

            if (onSuccess != null) {
              onSuccess(rawLIst.result[0].photo);
            }

            final index = villages.indexWhere((v) => v.schoolId == schoolId);
            if (index != -1) {
              villages[index] = newData.first;
            } else {
              villages.add(newData.first);
            }
          } else {
            villages = newData;
          }
          notifyListeners();
        } else {
          errorMessage=rawLIst.message;
        }
    } catch (e) {
      debugPrint('Error in StateProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSchoolInfo(int Stateid, int Districtid, int Blockid,
      int Gpid, int Villageid, int type) async {
    isLoading = true;

    try {
      final rawSchoolInfo = await _dwsmRepository.fetchSchoolInfo(
          Stateid, Districtid, Blockid, Gpid, Villageid, type);

      if (rawSchoolInfo.status == 1) {
        if (type == 0) {
          schoolResultList = rawSchoolInfo.result;
        } else if (type == 1) {
          anganwadiList = rawSchoolInfo.result;
        }
      } else {
        errorMsg = rawSchoolInfo.message;
      }
      baseStatus = rawSchoolInfo.status;
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
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
    isLoading = true;
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
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted) {
      return false;
    }
    return true;
  }

  Future<void> fetchDeviceId() async {
    _deviceId = await DeviceInfoUtil.getUniqueDeviceId();
    debugPrint('Device ID: $_deviceId');
    notifyListeners();
  }

  Future<void> fetchLocation(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    bool hasPermission = await checkLocationPermission();

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enable location permission in settings"),
          action: SnackBarAction(
            label: 'SETTINGS',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
      return;
    }

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
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedSchool(String id, String name) {
    selectedSchoolResult = id;
    selectedSchoolName = name;
    notifyListeners();
  }

  void setSelectedAnganwadi(String id, String name) {
    selectedAnganwadi = id;
    selectedAnganwadiName = name;
    notifyListeners();
  }

  void clearSelectedSchool() {
    selectedSchoolResult = null;
    selectedSchoolName = 'N/A';
    notifyListeners();
  }

  void clearSelectedAnganwadi() {
    selectedAnganwadi = null;
    selectedAnganwadiName = 'N/A';
    notifyListeners();
  }

}