import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/LabInchargeResponse.dart';
import 'package:jjm_wqmis/models/ParamLabResponse.dart';
import 'package:jjm_wqmis/repository/LapParameterRepository.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';

import '../models/DWSM/SchoolinfoResponse.dart';

import '../models/Wtp/WtpLabResponse.dart';

import '../utils/LocationUtils.dart';


import '../models/LabInchargeResponse/AllLabResponse.dart';
import '../models/LabInchargeResponse/ParameterResponse.dart';

class ParameterProvider with ChangeNotifier {
  final Lapparameterrepository _lapparameterrepository =
      Lapparameterrepository();

  bool isLoading = false;

  List<Parameterresponse> parameterList = [];
  int? selectedParameter;

  int selectionType = 0;
  int parameterType = 1;

  List<String> allParameters = [];

  List<Parameterresponse>? cart = [];

  List<Alllabresponse> labList = [];
  String? selectedLab="";
  String errorMsg = '';

  bool isLabSelected=false;
  Labinchargeresponse? labIncharge;

  List<SchoolResult> Schoolinfo= [] ;
  int? selectedSchoolId;
  String? selectedSchoolName;

  bool isLab=true;
  bool isParam=true;
  double? _currentLatitude;
  double? _currentLongitude;

  double? get currentLatitude => _currentLatitude;
  double? get currentLongitude => _currentLongitude;


  Paramlabresponse? _labResponse;
  Paramlabresponse? get labResponse => _labResponse;

  int? _selectedParamLabId;
  String? _selectedParamLabName;

  int? get selectedParamLabId => _selectedParamLabId;
  String? get selectedParamLabName => _selectedParamLabName;

  WtpLabResponse? _wtpLabModel;
  WtpLabResponse? get wtpLabModel => _wtpLabModel;

  List<WtpLab>  wtpLab =[];
  String? selectedWtpLab;

  SchoolinfoResponse? _schoolinfoResponse;
  SchoolinfoResponse? get schoolInfo => _schoolinfoResponse;

  List<SchoolResult>  schoolResult =[];
  String? selectedSchoolResult;

  Future<void> fetchAllLabs(String StateId, String districtId, String blockid, String gpid, String villageid, String isall) async {
    print("lab call in parameter provider");
    isLoading = true;
    try {
     final  rawLabList = await _lapparameterrepository.fetchAllLab(
          StateId, districtId, blockid, gpid, villageid, isall);
      if(rawLabList.status==1){
        labList=rawLabList.result;
      }else{
        errorMsg=rawLabList.message;
      }
    } catch (e, stackTrace) {
      log('Error in fetching lab list provider: $e');
      log('StackTrace: $stackTrace');
    }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllParameter(String labid, String stateid, String sid, String reg_id, String parameteetype) async {
    isLoading = true;
    try {
      final rawParameterList = await _lapparameterrepository.fetchAllParameter(
          labid, stateid, sid, reg_id, parameteetype);
      if(rawParameterList.status==1){
        parameterList=rawParameterList.result;
      }else{
        errorMsg=rawParameterList.message;
      }
    } catch (e) {
      debugPrint('Error in fetching All Parameter list: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLabIncharge(int labId) async {
    isLoading = true;
    notifyListeners();

    try {
      labIncharge = await _lapparameterrepository.fetchLabIncharge(labId);
      if (labIncharge == null) {
        throw ApiException("Lab Incharge data is null");
      }

    } catch (e) {
      debugPrint(" Error fetching Lab Incharge: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchSchoolInfo(int Stateid, int Districtid, int Blockid, int Gpid, int Villageid, int type) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _lapparameterrepository.fetchSchoolInfo(Stateid, Districtid, Blockid, Gpid, Villageid, type);

      if (response != null) {
        _schoolinfoResponse = response;

        if (_schoolinfoResponse!.status == 1) {
          schoolResult = _schoolinfoResponse!.result;

          if (schoolResult.any((schoolInfo) => schoolInfo.id == selectedSchoolResult)) {
            selectedSchoolResult = selectedSchoolResult; // Keep current selected if still valid
          } else if (schoolResult.isNotEmpty) {
            selectedSchoolResult = schoolResult.first.name; // Reset if invalid or select first
          } else {
            selectedSchoolResult = ''; // Handle if list is empty
          }
        } else {
          debugPrint("API Message: ${_schoolinfoResponse!.message}");
          _schoolinfoResponse = SchoolinfoResponse(
            status: 0,
            message: _schoolinfoResponse!.message,
            result: [], // Ensure empty labs list
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching WTP Labs: $e");
      _schoolinfoResponse = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedSchool(String? value){
    selectedSchoolResult=value;
    notifyListeners();
  }

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

          debugPrint('Location Fetched: Lat: $_currentLatitude, Lng: $_currentLongitude');
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



  /// Fetch Labs from API
  Future<void> fetchParamLabs(String stateId, String parameterIds) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _lapparameterrepository.fetchParamLabs(stateId, parameterIds);

      if (response != null) {
        _labResponse = response;
      }
      if (_labResponse!.status == false) {
        debugPrint("API Message: ${_labResponse!.message}");
        _labResponse = Paramlabresponse(
          status: _labResponse!.status,
          message: _labResponse!.message,
          labs: [], // Ensure labs list is empty
        );
      }
    } catch (e) {
      debugPrint("Error fetching Lab Incharge: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWTPLab(String stateId, String wtpId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _lapparameterrepository.fetchWtpLabs(stateId, wtpId);

      if (response != null) {
        _wtpLabModel = response;

        if (_wtpLabModel!.status == 1) {
          wtpLab = _wtpLabModel!.result;

          if (wtpLab.any((wtp) => wtp.labId == selectedWtpLab)) {
            selectedWtpLab = selectedWtpLab; // Keep current selected if still valid
          } else if (wtpLab.isNotEmpty) {
            selectedWtpLab = wtpLab.first.labId; // Reset if invalid or select first
          } else {
            selectedWtpLab = ''; // Handle if list is empty
          }
        } else {
          debugPrint("API Message: ${_wtpLabModel!.message}");
          _wtpLabModel = WtpLabResponse(
            status: 0,
            message: _wtpLabModel!.message,
            result: [], // Ensure empty labs list
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching WTP Labs: $e");
      _wtpLabModel = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedWtpLab(String? value){
    selectedLab=value;
    selectedWtpLab=value;
    isLabSelected = value != null && value.isNotEmpty;
    notifyListeners();
  }

  /// Set Selected Lab ID and Name
  void setSelectedParamLabs(int labId, String labName) {
    _selectedParamLabId = labId;
    _selectedParamLabName = labName;
    notifyListeners();
  }

  void setSelectedParameter(int? value) {
    selectedParameter = value;
    notifyListeners();
  }

  void setSelectedLab(String? value) {
    selectedLab = value;
    isLabSelected = value != null && value.isNotEmpty;
    notifyListeners();
  }

  void setSelectionType(int value) {
    selectionType = value;
    notifyListeners();
  }

  void setParameterType(int value) {
    parameterType = value;
    notifyListeners();
  }
  void removeFromCart(Parameterresponse param) {
    print("delted value---$param");
    cart!.remove(param);
    notifyListeners(); // Notify UI to update
  }

  double calculateTotal() {
    return cart!.fold(0.0, (sum, item) => sum + item.deptRate);
  }

  void toggleCart(Parameterresponse? parameter ) {
    if (parameter == null)
      return; // Null safety check

    if (cart!.any((item) => item.parameterId == parameter.parameterId)) {
      cart!.removeWhere(
          (item) => item.parameterId == parameter.parameterId);
    } else{
      cart!.add(parameter);
    }/* if(isLab) {
      cart!.add(parameter);
      final labId = selectedLab?.isNotEmpty == true
          ? selectedLab
          : selectedWtpLab;
      print("---------- $selectedLab");
      if (labId != null && labId.isNotEmpty) {
      //  fetchLabIncharge(int.parse(labId));
      }
    }else{
      cart!.add(parameter);
    *//*  var paramterId=cart!.sublist(0,cart!.length).join(",");
      print('card selected param-------- ${cart!.sublist(0,cart!.length).join(",")}');
      fetchParamLabs("31",paramterId);*//*
    }*/
    notifyListeners(); // Notify UI of changes
  }
  void clearData() {
    isLoading = false;

    parameterList.clear();
    selectedParameter = null;

    selectionType = 0;
    parameterType = 1;

    allParameters.clear();
    cart?.clear();

    labList.clear();
    selectedLab = "";
    isLabSelected = false;
    labIncharge = null;

    isLab = true;
    isParam=false;
    _currentLatitude = null;
    _currentLongitude = null;

    _labResponse = null;

    _selectedParamLabId = null;
    _selectedParamLabName = null;

    _wtpLabModel = null;

    wtpLab.clear();
    notifyListeners();
  }

}
