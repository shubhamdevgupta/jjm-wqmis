import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/DashboardResponse/DashboardResponse.dart';
import 'package:jjm_wqmis/models/DashboardResponse/DwsmDashboardResponse.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';

import '../models/LoginResponse.dart';
import '../utils/CustomException.dart';
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

  Future<Dashboardresponse> fetchDashboardData(int roleId, int userId, int stateId) async {
    try {
      String endpoint = '/apiMobile/dashbord?role_id=$roleId&userid=$userId&stateid=$stateId';
      final response = await _apiService.get(endpoint);

      if (response is Map<String, dynamic>) {
        return Dashboardresponse.fromJson(response);
      } else {
        throw ApiException('Invalid response format');
      }
    } catch (e) {
      debugPrint('Error in fetchDataresponse: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Dwsmdashboardresponse> fetchDwsmDashboardData(int stateId, int districtId) async {
    try {
      String endpoint = '/apiMobile/Dashboarddwsm?stateid=$stateId&districtid=$districtId';
      final response = await _apiService.get(endpoint);

      if (response is Map<String, dynamic>) {
        return Dwsmdashboardresponse.fromJson(response);
      } else {
        throw ApiException('Invalid response format');
      }
    } catch (e) {
      debugPrint('Error in fetchDataresponse: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }



}
