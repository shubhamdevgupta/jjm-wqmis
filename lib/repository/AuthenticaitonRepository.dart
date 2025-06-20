import 'dart:convert';

import 'package:jjm_wqmis/models/DashboardResponse/DashboardResponse.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';

import 'package:jjm_wqmis/models/LoginResponse.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';

class AuthenticaitonRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<LoginResponse> loginUser(
      String phoneNumber, String password, String txtSalt, int appId) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('APIMobile/Login',
        body: jsonEncode({
          'loginid': phoneNumber,
          'password': password,
          'txtSaltedHash': txtSalt,
           'App_id':appId
        }),
      );

      return LoginResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Dashboardresponse> fetchDashboardData(int roleId, int userId, int stateId) async {
    try {
      String endpoint = '/apiMobile/dashbord?role_id=$roleId&userid=$userId&stateid=$stateId';
      final response = await _apiService.get(endpoint);

        return Dashboardresponse.fromJson(response);
    } catch ( e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }





}
