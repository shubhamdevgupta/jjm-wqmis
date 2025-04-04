import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/LabInchargeResponse.dart';
import 'package:jjm_wqmis/repository/LapParameterRepository.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';
import '../utils/LocationUtils.dart';


import '../models/LabInchargeResponse/AllLabResponse.dart';
import '../models/LabInchargeResponse/ParameterResponse.dart';

class ParameterProvider with ChangeNotifier {
  final Lapparameterrepository _lapparameterrepository =
      Lapparameterrepository();

  bool isLoading = false;
  bool AsperLabisLoading = false;

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

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;


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
  Future<void> UpdateLoader(bool updatedValue) async {
    AsperLabisLoading = updatedValue;
    notifyListeners(); // ✅ Notify UI to update
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
    notifyListeners(); // Notify UI to show loader

    try {
      _currentPosition = await LocationService.getCurrentLocation();

      if (_currentPosition != null) {
        debugPrint('Fetched Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      } else {
        debugPrint("Location is null");
      }
    } catch (e) {
      debugPrint("Error fetching location: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI to hide loader
    }
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

  void toggleCart(Parameterresponse? parameter, bool isLab ) {

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
    }
    notifyListeners(); // Notify UI of changes
  }

}
