import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/repository/AuthenticaitonRepository.dart';

import '../models/LoginResponse.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();

/*  Future<void> fetchVillage(String stateId, String districtId, String blockId, String gpID) async {
    isLoading = true;
    notifyListeners(); // Start loading
    try {
      village = await _masterRepository.fetchVillages(
          stateId, districtId, blockId, gpID);
      if (village.isNotEmpty) {
        selectedVillage = village.first.jjmVillageId.toString();
      }
    } catch (e) {
      debugPrint('Error in fetching village: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }*/

  LoginResponse? _loginResponse;
  bool _isLoading = false;

  // Getters
  LoginResponse? get loginResponse => _loginResponse;

  bool get isLoading => _isLoading;

  // Method to login user
  Future<void> loginUser(phoneNumber, password) async {
    _isLoading = true;
    notifyListeners();
    String txtSalt =generateSalt();
    String encryPass= encryptPassword(password, txtSalt);

    try {
      _loginResponse = await _authRepository.loginUser(
        phoneNumber,
        encryPass,
        "4",
        txtSalt,
      );
    } catch (e) {
      print('Error during login: $e');
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
}
