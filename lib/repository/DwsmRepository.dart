import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/DWSM/DwsmDashboard.dart';
import 'package:jjm_wqmis/models/DWSM/DemonstrationResponse.dart';

import 'package:jjm_wqmis/models/DWSM/DashBoardSchoolModel.dart';
import 'package:jjm_wqmis/models/DWSM/SchoolinfoResponse.dart';
import 'package:jjm_wqmis/models/DashboardResponse/DwsmDashboardResponse.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';
import 'package:jjm_wqmis/utils/GlobalExceptionHandler.dart';

class DwsmRepository{
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<Village>> fetchDemonstrationList({
    required int stateId,
    required int districtId,
    required String fineYear,
    required int schoolId,
    required int demonstrationType,
  }
      ) async {
    try {
      final response = await _apiService.post('APIMobile/FTK_DemonstratedList',
        body: jsonEncode({
          'StateId': stateId,
          'DistrictId': districtId,
          'FineYear': fineYear,
          'SchoolId': schoolId,
          'DemonstrationType': demonstrationType,
        }),
      );
      return BaseResponseModel<Village>.fromJson(response,(json)=> Village.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<SchoolResult>> fetchSchoolAwcInfo(int Stateid, int Districtid,
      int Blockid, int Gpid, int Villageid, int type) async {
    try {
      final response = await _apiService.get(
          'ApiMaster/GetSchoolAwcs?stateid=$Stateid&districtid=$Districtid&blockid=$Blockid&gpid=$Gpid&villageid=$Villageid&type=$type');
      return BaseResponseModel<SchoolResult>.fromJson(response,(json)=> SchoolResult.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<DashboardSchoolModel>> fetchDashboardSchoolList(int stateId, int districtId,
      int demonstrationType) async {
    try {
      final response = await _apiService.post('APIMobile/GetSchoolAWCsListDetails',
        body: jsonEncode({
          "StateId": stateId,
          "DistrictId": districtId,
          "DemonstrationType": demonstrationType,
        }));

      return BaseResponseModel<DashboardSchoolModel>.fromJson(response,(json)=> DashboardSchoolModel.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  //https://ejalshakti.gov.in/WQMIS/API/APIMobile/GetSchoolAWCsListDetails


  Future<DemonstrationResponse> submitDemonstration( int userId,
       int schoolId,
       int stateId,
       String photoBase64,
       String fineYear,
       String remark,
       String latitude,
       String longitude,
       String ipAddress,) async {
    try {
      final response = await _apiService.post('APIMobile/FTK_Demonstrated',
        body: jsonEncode({
          "UserId": userId,
          "SchoolId": schoolId,
          "StateId": stateId,
          "Photo": photoBase64,
          "FineYear": fineYear,
          "Remark": remark,
          "Latitude": latitude,
          "Longitude": longitude,
          "IPAddress": ipAddress,
        }),
      );
      return DemonstrationResponse.fromJson(response);

    } catch (e) {
      debugPrint('Error in fetchDemonstartionList: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Dwsmdashboardresponse> fetchDwsmDashboard(int userId) async {
    try {
      String endpoint = '/apiMobile/dashDistrictUser?userid=$userId';
      final response = await _apiService.get(endpoint);

      return Dwsmdashboardresponse.fromJson(response);

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}