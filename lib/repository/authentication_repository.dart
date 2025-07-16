import 'dart:convert';

import 'package:jjm_wqmis/models/DashboardResponse/dashboard_response.dart';
import 'package:jjm_wqmis/services/base_api_service.dart';

import 'package:jjm_wqmis/models/login_response.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';

class AuthenticaitonRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<LoginResponse> loginUser(
      String phoneNumber, String password, String txtSalt, int appId) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('APIMobileA/Login',
        body: jsonEncode(encryptDataClassBody({
          'loginid': phoneNumber,
          'password': password,
          'txtSaltedHash': txtSalt,
           'App_id':appId
        })));

      return LoginResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Dashboardresponse> fetchDashboardData(int roleId, int regId, int stateId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'role_id': roleId,
        'stateid': stateId,
        'reg_id': regId,
      });


      final response = await _apiService.get('/apiMobileA/dashbord?$query');

        return Dashboardresponse.fromJson(response);
    } catch ( e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }





}
