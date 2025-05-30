
import 'package:flutter/cupertino.dart';
import '../models/DashboardResponse/DashboardResponse.dart';
import '../repository/AuthenticaitonRepository.dart';
import '../services/LocalStorageService.dart';
import '../utils/AppConstants.dart';
import '../utils/LocationUtils.dart';

class DashboardProvider extends ChangeNotifier{
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Dashboardresponse? dashboardData;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();
    String roleId=_localStorage.getString(AppConstants.prefRoleId) ?? '';
    String userId=_localStorage.getString(AppConstants.prefUserId) ?? '';
    String stateId=_localStorage.getString(AppConstants.prefStateId) ?? '';
    try {
      dashboardData = await _authRepository.fetchDashboardData(int.parse(roleId), int.parse(userId), int.parse(stateId));
    } catch (e) {
      debugPrint("Dashboard Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void reset() {
    // TODO: implement reset
  }
}