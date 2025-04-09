import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/BaseResettableProvider.dart';
import 'package:jjm_wqmis/repository/AuthenticaitonRepository.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';

import '../models/LoginResponse.dart';
import '../services/LocalStorageService.dart';
import '../utils/GlobalExceptionHandler.dart';

class AuthenticationProvider extends Resettable {
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();
  final LocalStorageService _localStorage = LocalStorageService();

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

  Future<void> checkLoginStatus() async {
    _isLoggedIn = _localStorage.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _isLoggedIn = false;
    await _localStorage.remove('isLoggedIn');
    notifyListeners();
  }

  // Method to login user
  Future<void> loginUser(phoneNumber, password, roldId, Function onSuccess,
      Function onFailure) async {
    generateCaptcha();
    _isLoading = true;
    notifyListeners();
    String txtSalt = generateSalt();
    String encryPass = encryptPassword(password, txtSalt);

    try {
      _loginResponse = await _authRepository.loginUser(phoneNumber, encryPass, roldId, txtSalt);
      if (_loginResponse?.status == 1) {
        _isLoggedIn = true;
        _localStorage.saveBool('isLoggedIn', true);
        _localStorage.saveString('token', _loginResponse!.token.toString());
        _localStorage.saveString('userId', _loginResponse!.regId.toString());
        _localStorage.saveString('roleId', _loginResponse!.roleId.toString());
        _localStorage.saveString('name', _loginResponse!.name.toString());
        _localStorage.saveString('mobile', _loginResponse!.mobileNumber.toString());
        _localStorage.saveString('stateId', _loginResponse!.stateId.toString());
        _localStorage.saveString('stateName', _loginResponse!.stateName.toString());
        notifyListeners();
        onSuccess();
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

  String trim(String value) => value.trim();

  String sha512Base64(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest sha512Hash = sha512.convert(bytes);
    return base64Encode(sha512Hash.bytes);
  }

  String encryptPassword(String password, String salt) {
    String hash1 = sha512Base64(trim(password));
    print(hash1);
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
    print("calling the captch $randomOne  $randomTwo");
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
