import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/DWSM/DwsmDashboard.dart';
import 'package:jjm_wqmis/repository/DwsmRepository.dart';

import '../utils/GlobalExceptionHandler.dart';

class DwsmDashboardProvider extends ChangeNotifier {
  final DwsmRepository _dwsmRepository = DwsmRepository();

  bool isLoading = false;

  List<Village> villages = [];
  String? selectedVillage;
  String errorMsg = '';

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
}
