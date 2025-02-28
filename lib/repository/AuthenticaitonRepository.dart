import 'dart:convert';

import 'package:jjm_wqmis/services/BaseApiService.dart';

import '../models/LoginResponse.dart';

class AuthenticaitonRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<LoginResponse> loginUser(String phoneNumber, String password,
      String roldId, String txtSalt) async {
    final response = await _apiService.post('APIMobile/Login',

      body: jsonEncode({
        'loginid': phoneNumber,
        'password': password,
        'role_id': roldId,
        'txtSaltedHash': txtSalt
      }),
    );
    return LoginResponse.fromJson(response);
  }
}
