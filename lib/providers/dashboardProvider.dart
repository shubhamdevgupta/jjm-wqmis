
import 'package:flutter/cupertino.dart';

import '../models/DashboardResponse/DashboardResponse.dart';
import '../repository/AuthenticaitonRepository.dart';
import '../services/LocalStorageService.dart';
import '../utils/DeviceUtils.dart';

class DashboardProvider extends ChangeNotifier{
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Dashboardresponse? dashboardData;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();
    String roleId=_localStorage.getString('roleId') ?? '';
    String userId=_localStorage.getString('userId') ?? '';
    String stateId=_localStorage.getString('stateId') ?? '';
    try {
      dashboardData = await _authRepository.fetchDashboardData(int.parse(roleId), int.parse(userId), int.parse(stateId));
    } catch (e) {
      debugPrint("Dashboard Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}