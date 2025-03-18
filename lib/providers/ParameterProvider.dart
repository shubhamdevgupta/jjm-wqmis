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

  List<Parameterresponse> parameterList = [];
  int? selectedParameter;

  int selectionType = 0;
  int parameterType = 0;

  List<String> allParameters = [];

  List<Parameterresponse>? cart = [];

  List<Alllabresponse> labList = [];
  String? selectedLab;
  Labinchargeresponse? labIncharge;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;


  Future<void> fetchAllLabs(String StateId, String districtId, String blockid, String gpid, String villageid, String isall) async {
    isLoading = true;
    try {
      labList = await _lapparameterrepository.fetchAllLab(
          StateId, districtId, blockid, gpid, villageid, isall);
      if (labList.isNotEmpty) {
        selectedLab = labList.first.value;
      }
    } catch (e) {
      debugPrint('Error in fetching lab list: $e');
    } finally {
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
      debugPrint('Error in fetching lab list: $e');
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
    try {
      _currentPosition = await LocationService.getCurrentLocation();
      notifyListeners(); // Notify UI to update
    } catch (e) {
      debugPrint(" Error fetching  Location: $e");
      notifyListeners(); // Notify UI about error
    }
  }

  void setSelectedParameter(int? value) {
    selectedParameter = value;
    notifyListeners();
  }

  void setSelectedLab(String? value) {
    selectedLab = value;
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
    cart!.remove(param);
    notifyListeners(); // Notify UI to update
  }

  double calculateTotal() {
    return cart!.fold(0.0, (sum, item) => sum + item.deptRate);
  }

  void toggleCart(Parameterresponse? parameter) {
    if (parameter == null || parameter.parameterId == null)
      return; // Null safety check

    if (cart!.any((item) => item.parameterId == parameter.parameterId)) {
      cart!.removeWhere(
          (item) => item.parameterId == parameter.parameterId);
    } else {
      cart!.add(parameter);
      fetchLabIncharge(int.parse(selectedLab!));
    }
    notifyListeners(); // Notify UI of changes
  }
}
