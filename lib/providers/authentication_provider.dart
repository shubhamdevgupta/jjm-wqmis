import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/LoginResponse.dart';
import '../repository/UserRepository.dart';
import '../utils/CustomException.dart';
import '../utils/Loader.dart';
import '../views/ExceptionScreen.dart';

class AuthenticationProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  String? _loginStatus;
  String? _accessToken;
  User? _loggedInUser;
  bool? _isLoading;
  String? _errorMessage; // Store error message

  String? get loginStatus => _loginStatus;
  String? get accessToken => _accessToken;
  User? get loggedInUser => _loggedInUser;
  bool? get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loginUser(String phoneNumber, String password) async {
    var bytes = utf8.encode(password);
    var digest = sha512.convert(bytes);
    var pass = digest.toString().toUpperCase();
    print('encrypted pass--->>> $pass');

    Loader.circularLoader();
    try {
      _isLoading = true;
      _errorMessage = null;  // Clear previous errors
      notifyListeners();
      final loginResponse = await _userRepository.loginUser(phoneNumber, pass);

      if (loginResponse.statusCode == 200) {
        print('login success ${loginResponse.statusCode}');
        _accessToken = loginResponse.accessToken;
        _loggedInUser = loginResponse.user;
        _loginStatus = 'Login Successful';
      } else {
        _loginStatus = 'Login Failed';
      }
    } on NetworkException catch (e) {
      _loginStatus = e.message;
      // Show a SnackBar or dialog for no internet connection
      print('No internet connection: ${e.message}');
    } catch (e) {
      _errorMessage = e.toString();
      _loginStatus = 'Error occurred';
      notifyListeners();

      // Navigate to Exception Screen
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ExceptionScreen(errorMessage: _errorMessage ?? "Unknown Error"),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
