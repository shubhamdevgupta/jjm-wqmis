import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/main.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/repository/AuthenticaitonRepository.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';

import 'package:jjm_wqmis/models/LoginResponse.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/utils/CurrentLocation.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';
import 'package:jjm_wqmis/utils/LocationUtils.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:provider/provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();
  final LocalStorageService _localStorage = LocalStorageService();
  final session = UserSessionManager();
  AuthenticationProvider() {
    generateCaptcha();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  var randomOne, randomTwo, captchResult;

  LoginResponse? _loginResponse;
  bool _isLoading = false;

  // Getters
  LoginResponse? get loginResponse => _loginResponse;

  bool get isLoading => _isLoading;

  bool _isShownPassword = false;

  bool get isShownPassword => _isShownPassword;

  String errorMsg = '';

  double? _currentLatitude;
  double? _currentLongitude;

  double? get currentLatitude => _currentLatitude;

  double? get currentLongitude => _currentLongitude;

  Future<void> checkLoginStatus() async {
    _isLoggedIn = _localStorage.getBool(AppConstants.prefIsLoggedIn) ?? false;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _isLoggedIn = false;

    // Clear SharedPreferences
    await _localStorage.clearAll();
    await session.clearPref();
    notifyListeners();
  }

  // Method to login user
  Future<void> loginUser(phoneNumber, password, appId, Function() onSuccess,
      Function onFailure) async {

    _isLoading = true;
    notifyListeners();
    String txtSalt = generateSalt();
    String encryPass = encryptPassword(password, txtSalt);

    try {
      _loginResponse = await _authRepository.loginUser(phoneNumber, encryPass, txtSalt, appId);
      if (_loginResponse?.status == 1) {
        _isLoggedIn = true;
        _localStorage.saveBool(AppConstants.prefIsLoggedIn, true);
        _localStorage.saveString(AppConstants.prefToken, _loginResponse!.token.toString());
        _localStorage.saveString(AppConstants.prefName, _loginResponse!.name.toString());
        _localStorage.saveString(AppConstants.prefMobile, _loginResponse!.mobileNumber.toString());
        _localStorage.saveString(AppConstants.prefLoginID, _loginResponse!.loginId!);

        _localStorage.saveInt(AppConstants.prefRegId, _loginResponse!.regId!);
        _localStorage.saveInt(AppConstants.prefRoleId, _loginResponse!.roleId!);

        _localStorage.saveInt(AppConstants.prefStateId, _loginResponse!.stateId!);
        _localStorage.saveInt(AppConstants.prefDistrictId, _loginResponse!.districtId!);
        _localStorage.saveInt(AppConstants.prefBlockId, _loginResponse!.blockId!);
        _localStorage.saveInt(AppConstants.prefPanchayatId, _loginResponse!.gramPanchayatId!);
        _localStorage.saveInt(AppConstants.prefVillageId, _loginResponse!.villageId!);

        _localStorage.saveString(AppConstants.prefStateName, _loginResponse!.stateName.toString());
        _localStorage.saveString(AppConstants.prefDistName, _loginResponse!.districtName.toString());
        _localStorage.saveString(AppConstants.prefBlockName, _loginResponse!.blockName.toString());
        _localStorage.saveString(AppConstants.prefGramPanchayatName, _loginResponse!.panchayatName.toString());
        _localStorage.saveString(AppConstants.prefVillageName, _loginResponse!.villageName.toString());

        notifyListeners();
        onSuccess();
        generateCaptcha();
      } else {
        errorMsg = _loginResponse!.msg!;
        onFailure(errorMsg);
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _loginResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

          // 🔥 Set global current location
          CurrentLocation.setLocation(
            lat: _currentLatitude!,
            lng: _currentLongitude!,
          );

          debugPrint('Location Fetched: Lat: $_currentLatitude, Lng: $_currentLongitude');
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


  String trim(String value) => value.trim();

  String sha512Base64(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest sha512Hash = sha512.convert(bytes);
    return base64Encode(sha512Hash.bytes);
  }

  String encryptPassword(String password, String salt) {
    String hash1 = sha512Base64(trim(password));
    String hash2 = sha512Base64(salt + hash1);
    return hash2;
  }

  /// Generates a random salt of the given length
  String generateSalt({int length = 16}) {
    final Random random = Random.secure();
    final List<int> saltBytes =
        List<int>.generate(length, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  int generateCaptcha() {
    int max = 15;
    randomOne = Random().nextInt(max);
    randomTwo = Random().nextInt(max);
    captchResult = randomOne + randomTwo;
    notifyListeners();
    return captchResult;
  }

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    _isShownPassword = !_isShownPassword;
    notifyListeners();
  }

  @override
  void reset() {
    // TODO: implement reset
  }
}
