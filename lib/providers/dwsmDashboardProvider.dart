import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:jjm_wqmis/models/DWSM/DwsmDashboard.dart';
import 'package:jjm_wqmis/repository/DwsmRepository.dart';

import '../models/DWSM/SchoolinfoResponse.dart';
import '../repository/FTKREpository.dart';
import '../utils/GlobalExceptionHandler.dart';
import '../utils/LocationUtils.dart';

class DwsmDashboardProvider extends ChangeNotifier {
  final DwsmRepository _dwsmRepository = DwsmRepository();

  bool isLoading = false;

  List<Village> villages = [];
  String? selectedVillage;
  String errorMsg = '';
  int baseStatus=101;

  final FTKRepository _repository = FTKRepository();

  SchoolinfoResponse? _schoolinfoResponse;

  SchoolinfoResponse? get schoolInfo => _schoolinfoResponse;

  List<SchoolResult> schoolResultList = [];
  int? selectedSchoolResult;

/*  List<Alllabresponse> labList = [];
  String? selectedLab = "";*/

  bool _isLoading = false;
  String? _responseMessage;

  String? get responseMessage => _responseMessage;

  Future<void> loadDwsmDashboardData(
      int stateId, int DistrictId, String fineYear) async {
    print('Calling the state function...');
    isLoading = true;
    notifyListeners();
    try {
      final rawLIst = await _dwsmRepository.fetchDemonstartionList(
          stateId, DistrictId, fineYear);
      if (rawLIst.status == 1) {
        villages = rawLIst.result;
        print('villagesvillages ${villages}');
      } else {
        errorMsg = rawLIst.message;
      }
    } catch (e) {
      debugPrint('Error in StateProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void reset() {
    // TODO: implement reset
  }

  /////////////////////////////////////////////////////////////////////////////

  Future<void> submitFTK({
    required int userId,
    required int schoolId,
    required int stateId,
    required String photoBase64,
    required String fineYear,
    required String remark,
    required String latitude,
    required String longitude,
    required String ipAddress,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      Response response = await _repository.submitFTKData(
        userId: userId,
        schoolId: schoolId,
        stateId: stateId,
        photoBase64: photoBase64,
        fineYear: fineYear,
        remark: remark,
        latitude: latitude,
        longitude: longitude,
        ipAddress: ipAddress,
      );

      if (response.statusCode == 200) {
        _responseMessage = "FTK data submitted successfully!";
      } else {
        _responseMessage = "Failed to submit: ${response.body}";
      }
    } catch (e) {
      _responseMessage = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSchoolInfo(int Stateid, int Districtid, int Blockid,
      int Gpid, int Villageid, int type) async {
    isLoading = true;
    notifyListeners();

    try {
      final rawSchoolInfo = await _repository.fetchSchoolInfo(
          Stateid, Districtid, Blockid, Gpid, Villageid, type);

      if (rawSchoolInfo.status == 1) {
        schoolResultList = rawSchoolInfo.result;
      } else {
        debugPrint("API Message: ${_schoolinfoResponse!.message}");
        errorMsg = rawSchoolInfo.message;
      }
      baseStatus=rawSchoolInfo.status;
    } catch (e) {
      _schoolinfoResponse = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  double? get currentLatitude => _currentLatitude;

  double? get currentLongitude => _currentLongitude;

  double? _currentLatitude;
  double? _currentLongitude;

  Future<void> fetchLocation() async {
    isLoading = true;
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
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedSchool(value) {
    selectedSchoolResult=value;
    notifyListeners();
  }


/////////////////////////////////////////////////////////////////////////////
}
