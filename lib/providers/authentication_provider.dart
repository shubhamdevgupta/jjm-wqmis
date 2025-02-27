import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/LoginResponse.dart';
import '../repository/MasterRepository.dart';
import '../utils/CustomException.dart';
import '../utils/Loader.dart';
import '../views/ExceptionScreen.dart';

class AuthenticationProvider extends ChangeNotifier {
  final MasterRepository _userRepository = MasterRepository();
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

    String salt=generateSalt();
    String encPass=encryptPassword(password, salt);

    Loader.circularLoader();
    try {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
      notifyListeners();
      final loginResponse = await _userRepository.loginUser(
          phoneNumber, encPass, "4", salt);

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
          builder: (context) =>
              ExceptionScreen(errorMessage: _errorMessage ?? "Unknown Error"),
        ),
      );
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
    final List<int> saltBytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }
}
