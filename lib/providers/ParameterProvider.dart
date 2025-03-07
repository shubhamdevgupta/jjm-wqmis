import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/repository/LapParameterRepository.dart';

import '../models/MasterApiResponse/AllLabResponse.dart';
import '../models/MasterApiResponse/ParameterResponse.dart';

class ParameterProvider with ChangeNotifier {
  final Lapparameterrepository _lapparameterrepository =
      Lapparameterrepository();

  bool isLoading = false;

  List<Parameterresponse> parameterList = [];
  int? selectedParameter;

  int selectionType = 0;
  int parameterType = 0;

  List<String> allParameters = [];
  List<String> chemicalParameters = ['Chloride', 'Fluoride'];
  List<String> bacteriologicalParameters = ['E. coli'];
  List<Parameterresponse> cart = [];

  List<Alllabresponse> labList = [];
  String? selectedLab;

  Future<void> fetchAllLabs(String StateId, String districtId, String blockid,
      String gpid, String villageid, String isall) async {
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

  Future<void> fetchAllParameter(String labid, String stateid, String sid,
      String reg_id, String parameteetype) async {
    isLoading = true;
    try {
      parameterList = await _lapparameterrepository.fetchAllParameter(
          labid, stateid, sid, reg_id, parameteetype);
      if (parameterList.isNotEmpty) {
        selectedParameter = parameterList.first.parameterIdAlt;
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

  List<String> getParameters() {
    switch (parameterType) {
      case 1:
        return chemicalParameters;
      case 2:
        return bacteriologicalParameters;
      default:
        return allParameters;
    }
  }

  void toggleCart(Parameterresponse? parameter) {
    if (parameter == null || parameter.parameterIdAlt == null)
      return; // Null safety check

    if (cart.any((item) => item.parameterIdAlt == parameter.parameterIdAlt)) {
      cart.removeWhere(
          (item) => item.parameterIdAlt == parameter.parameterIdAlt);
    } else {
      cart.add(parameter);
    }
    notifyListeners(); // Notify UI of changes
  }
}
