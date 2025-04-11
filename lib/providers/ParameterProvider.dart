import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/LabInchargeResponse.dart';
import 'package:jjm_wqmis/models/ParamLabResponse.dart';
import 'package:jjm_wqmis/repository/LapParameterRepository.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';
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
  bool isLabSelected=false;
  Labinchargeresponse? labIncharge;

  bool isLab=true;
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


  Future<void> fetchAllLabs(String StateId, String districtId, String blockid, String gpid, String villageid, String isall) async {
    print("lab call in parameter provider");
    isLoading = true;
    try {
      labList = await _lapparameterrepository.fetchAllLab(
          StateId, districtId, blockid, gpid, villageid, isall);
      log('Fetched Lab List: $labList');
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
      parameterList = await _lapparameterrepository.fetchAllParameter(
          labid, stateid, sid, reg_id, parameteetype);
      if (parameterList.isNotEmpty) {
        selectedParameter = parameterList.first.parameterId;
        allParameters =
            parameterList.map((param) => param.parameterName).toList();
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
    } else if(isLab) {
      cart!.add(parameter);
      fetchLabIncharge(int.parse(selectedLab!));
    }else{
      cart!.add(parameter);
      var paramterId=cart!.sublist(0,cart!.length).join(",");
      print('card selected param-------- ${cart!.sublist(0,cart!.length).join(",")}');
      fetchParamLabs("31",paramterId);
    }
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

    _currentLatitude = null;
    _currentLongitude = null;

    _labResponse = null;

    _selectedParamLabId = null;
    _selectedParamLabName = null;

    notifyListeners();
  }

}
