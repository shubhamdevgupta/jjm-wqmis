import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/LabInchargeResponse.dart';
import 'package:jjm_wqmis/models/ParamLabResponse.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/repository/LapParameterRepository.dart';

import 'package:jjm_wqmis/models/DWSM/SchoolinfoResponse.dart';

import 'package:jjm_wqmis/models/Wtp/WtpLabResponse.dart';


import 'package:jjm_wqmis/models/LabInchargeResponse/AllLabResponse.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/ParameterResponse.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';

class ParameterProvider with ChangeNotifier {
  final Lapparameterrepository _lapparameterrepository = Lapparameterrepository();

  final session = UserSessionManager();
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<Parameterresponse> parameterList = [];
  int? selectedParameter;

  int selectionType = 0;
  int parameterType = 1;

  List<String> allParameters = [];

  List<Parameterresponse>? cart = [];

  List<Alllabresponse> labList = [];
  String? selectedLab = "";
  String errorMsg = '';

  bool isLabSelected = false;
  Labinchargeresponse? labIncharge;

  List<SchoolResult> Schoolinfo = [];

  int? selectedSchoolId;
  String? selectedSchoolName;

  bool isLab = true;
  bool isParam = true;

  List<Lab>? _labResponse;

  List<Lab>? get labResponse => _labResponse;

  int? _selectedParamLabId;
  String? _selectedParamLabName;

  int? get selectedParamLabId => _selectedParamLabId;

  String? get selectedParamLabName => _selectedParamLabName;

  WtpLabResponse? _wtpLabModel;

  WtpLabResponse? get wtpLabModel => _wtpLabModel;

  List<WtpLab> wtpLab = [];
  String? selectedWtpLab;

  SchoolinfoResponse? _schoolinfoResponse;

  SchoolinfoResponse? get schoolInfo => _schoolinfoResponse;

  List<SchoolResult> schoolResult = [];
  String? selectedSchoolResult;

  int baseStatus = 0;

  Future<void> fetchAllLabs(String stateId, String districtId, String blockId,
      String gpId, String villageId, String isAll) async {
    _isLoading = true;
    try {
      final rawLabList = await _lapparameterrepository.fetchAllLab(
          stateId, districtId, blockId, gpId, villageId, isAll);
      if (rawLabList.status == 1) {
        labList = rawLabList.result;
      } else {
        errorMsg = rawLabList.message;
      }
    } catch (e) {
      log('Error in fetching lab list provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllParameter(String labid, String stateid, String sid,
      String regId, String parameteetype) async {
    _isLoading = true;
    try {
      final rawParameterList = await _lapparameterrepository.fetchAllParameter(
          labid, stateid, sid, regId, parameteetype);
      if (rawParameterList.status == 1) {
        parameterList = rawParameterList.result;
      } else {
        errorMsg = rawParameterList.message;
      }
    } catch (e) {
      debugPrint('Error in fetching All Parameter list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLabIncharge(int labId) async {
    _isLoading = true;
    notifyListeners();

    try {
      labIncharge = await _lapparameterrepository.fetchLabIncharge(labId);
      if (labIncharge != null) {
        baseStatus = labIncharge!.status;
        errorMsg = labIncharge!.message;
      }
    } catch (e) {
      debugPrint(" Error fetching Lab Incharge: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  void setSelectedSchool(String? value) {
    selectedSchoolResult = value;
    notifyListeners();
  }
  /// Fetch Labs from API
  Future<void> fetchParamLabs(String stateId, String parameterIds) async {
    _isLoading = true;
    notifyListeners(); // Notify before starting the fetch

    try {
      var response = await _lapparameterrepository.fetchParamLabs(stateId, parameterIds);

      if (response.status == 1) {
        _labResponse = response.result;
        _selectedParamLabId = response.result.first.labId;
        fetchLabIncharge(_selectedParamLabId!);
      } else {
        errorMsg = response.message;
      }

      baseStatus = response.status;
    } catch (e) {
      debugPrint("Error fetching Lab Incharge: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify at the end of the fetch process
    }
  }

  Future<void> fetchWTPLab(Masterprovider masterProvider) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _lapparameterrepository.fetchWtpLabs(
          masterProvider.selectedStateId!, masterProvider.selectedWtp!);

      if (response.status == 1) {
        wtpLab = response.result;
        if (wtpLab.length == 1) {
          selectedWtpLab = response.result.first.labId;
          isLabSelected = true;
          proccessOnChanged(selectedWtpLab!, masterProvider);
        }
      } else {
        errorMsg = response.message;
      }
      baseStatus = response.status;
    } catch (e) {
      debugPrint("Error fetching WTP Labs: $e");
      _wtpLabModel = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedWtpLab(String? value) {
    selectedLab = value;
    selectedWtpLab = value;
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
    cart!.remove(param);
    notifyListeners(); // Notify UI to update
  }

  double calculateTotal() {
    return cart!.fold(0.0, (sum, item) => sum + item.deptRate);
  }

  void toggleCart(Parameterresponse? parameter) {
    if (parameter == null) return; // Null safety check

    if (cart!.any((item) => item.parameterId == parameter.parameterId)) {
      cart!.removeWhere((item) => item.parameterId == parameter.parameterId);
    } else {
      cart!.add(parameter);
    }
    notifyListeners(); // Notify UI of changes
  }

  void clearData() {
    _isLoading = false;

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
    isParam = false;
    _labResponse = null;

    _selectedParamLabId = null;
    _selectedParamLabName = null;

    _wtpLabModel = null;

    wtpLab.clear();
    notifyListeners();
  }

  void proccessOnChanged(String value, Masterprovider masterPr) {
    cart!.clear();
    setSelectedWtpLab(value);

    fetchAllParameter(
      value,
      masterPr.selectedStateId ?? "0",
      "0",
      session.regId.toString(),
      "0",
    );
  }
}
