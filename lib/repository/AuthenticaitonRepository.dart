import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';

import '../models/LoginResponse.dart';
import '../utils/GlobalExceptionHandler.dart';

class AuthenticaitonRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<LoginResponse> loginUser(
      String phoneNumber, String password, String roleId, String txtSalt) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post(
        'APIMobile/Login',
        body: jsonEncode({
          'loginid': phoneNumber,
          'password': password,
          'role_id': roleId,
          'txtSaltedHash': txtSalt,
        }),
      );

      return LoginResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error in loginUser: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}
