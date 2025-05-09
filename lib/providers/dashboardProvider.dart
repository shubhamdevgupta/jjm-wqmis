
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

  double? _currentLatitude;
  double? _currentLongitude;

  double? get currentLatitude => _currentLatitude;

  double? get currentLongitude => _currentLongitude;

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

  Future<void> fetchLocation() async {
    _isLoading = true;
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

          debugPrint(
              'Location Fetched: Lat: $_currentLatitude, Lng: $_currentLongitude');
        } else {
          debugPrint("Location fetch failed (locationData is null)");
        }
      } else {
        debugPrint("Permission denied. Cannot fetch location.");
      }
    } catch (e) {
      debugPrint("Error during fetchLocation(): $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}