import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/base_response.dart';
import 'package:jjm_wqmis/models/DWSM/demonstration_response.dart';

import 'package:jjm_wqmis/models/DWSM/dashboard_school_response.dart';
import 'package:jjm_wqmis/models/DWSM/ftk_demonstration_list_response.dart';
import 'package:jjm_wqmis/models/DWSM/school_info_response.dart';
import 'package:jjm_wqmis/models/DashboardResponse/dwsm_dashboard_response.dart';
import 'package:jjm_wqmis/services/base_api_service.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';

class DwsmRepository{
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<VillageInfo>> fetchDemonstrationList({
    required int stateId,
    required int districtId,
    required String fineYear,
    required String schoolId,
    required int demonstrationType,
    required int regId,

  }) async {
    try {
      final response = await _apiService.post('APIMobileA/FTK_DemonstratedList',
        body: jsonEncode(encryptDataClassBody({
          'StateId': stateId,
          'DistrictId': districtId,
          'FineYear': fineYear,
          'SchoolId': schoolId,
          'DemonstrationType': demonstrationType,
          'Reg_id': regId,
        })));
      return BaseResponseModel<VillageInfo>.fromJson(response,(json)=> VillageInfo.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<SchoolResult>> fetchSchoolAwcInfo(int stateId, int districtId,
      int blockId, int gpId, int villageId, int type, int regId) async {
    try {
      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'blockid': blockId,
        'gpid': gpId,
        'villageid': villageId,
        'type': type,
        'reg_id': regId,
      });

      final response = await _apiService.get(
          'ApiMasterA/GetSchoolAwcs?$query');
      return BaseResponseModel<SchoolResult>.fromJson(response,(json)=> SchoolResult.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<DashboardSchoolModel>> fetchDashboardSchoolList(int stateId, int districtId,
      int demonstrationType, int regId) async {
    try {
      final response = await _apiService.post('APIMobileA/GetSchoolAWCsListDetails',
        body: jsonEncode(encryptDataClassBody({
          "StateId": stateId,
          "DistrictId": districtId,
          "DemonstrationType": demonstrationType,
          "Reg_id": regId,
        })));

      return BaseResponseModel<DashboardSchoolModel>.fromJson(response,(json)=> DashboardSchoolModel.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(Exception(e.toString())); // ✅ Safe wrap
      rethrow;
    }
  }


  Future<DemonstrationResponse> submitDemonstration( int userId,
       int schoolId,
       int stateId,
       String photoBase64,
       String fineYear,
       String remark,
       String latitude,
       String longitude,
       String ipAddress,
        int regId
      ) async {
    try {
      final response = await _apiService.post('APIMobileA/FTK_Demonstrated',
        body: jsonEncode(encryptDataClassBody({
          "UserId": userId,
          "SchoolId": schoolId,
          "StateId": stateId,
          "Photo": photoBase64,
          "FineYear": fineYear,
          "Remark": remark,
          "Latitude": latitude,
          "Longitude": longitude,
          "IPAddress": ipAddress,
          "Reg_Id": regId,
        })));
      return DemonstrationResponse.fromJson(response);

    } catch (e) {
      debugPrint('Error in fetchDemonstartionList: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Dwsmdashboardresponse> fetchDwsmDashboard(int userId) async {

    final query = _apiService.buildEncryptedQuery({
      'reg_id': userId,
    });

    try {
      String endpoint = '/apiMobileA/dashDistrictUser?$query';
      final response = await _apiService.get(endpoint);

      return Dwsmdashboardresponse.fromJson(response);

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}