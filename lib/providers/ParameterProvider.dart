import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/repository/LapParameterRepository.dart';

import '../models/MasterApiResponse/AllLabResponse.dart';
import '../models/MasterApiResponse/ParameterResponse.dart';

class ParameterProvider with ChangeNotifier {

  final Lapparameterrepository _lapparameterrepository = Lapparameterrepository();

  bool isLoading = false;

  int selectionType = 0;
  int parameterType = 0;

  List<String> labs = ['Lab 1', 'Lab 2', 'Lab 3'];
  List<String> allParameters = ['Chloride', 'Color', 'E. coli', 'Fluoride'];
  List<String> chemicalParameters = ['Chloride', 'Fluoride'];
  List<String> bacteriologicalParameters = ['E. coli'];
  List<String> cart = [];

  List<Alllabresponse> labList=[];
  String? selectedLab;

  List<Parameterresponse> parameterList =[];
  int? selectedParameter;

  Future<void> fetchAllLabs(String StateId, String districtId, String blockid, String gpid, String villageid, String isall) async {
    isLoading = true;
    try {
      labList = await _lapparameterrepository.fetchAllLab(StateId,districtId,blockid,gpid,villageid,isall);
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
      parameterList = await _lapparameterrepository.fetchAllParameter(labid,stateid,sid,reg_id,parameteetype);
      if (parameterList.isNotEmpty) {
        selectedParameter = parameterList.first.parameterId;
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

  void toggleCart(String parameter) {
    if (cart.contains(parameter)) {
      cart.remove(parameter);
    } else {
      cart.add(parameter);
    }
    notifyListeners();
  }
}
