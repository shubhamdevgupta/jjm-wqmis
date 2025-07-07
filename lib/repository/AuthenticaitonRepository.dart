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

  Future<Dashboardresponse> fetchDashboardData(int roleId, int userId, int stateId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'role_id': roleId,
        'reg_id': userId,
        'stateid': stateId,
      });  //


      final response = await _apiService.get('/apiMobileA/dashbord?$query');

        return Dashboardresponse.fromJson(response);
    } catch ( e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }





}
