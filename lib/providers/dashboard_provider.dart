
import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/DashboardResponse/dashboard_response.dart';
import 'package:jjm_wqmis/repository/authentication_repository.dart';

class DashboardProvider extends ChangeNotifier{
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Dashboardresponse? dashboardData;

  Future<void> loadDashboardData(int roleId,int regId,int stateId) async {
    _isLoading = true;
    notifyListeners();

    try {
      dashboardData = await _authRepository.fetchDashboardData(roleId,regId,stateId);
    } catch (e) {
      debugPrint("Dashboard Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}