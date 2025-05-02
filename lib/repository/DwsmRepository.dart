import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/DWSM/DwsmDashboard.dart';
import 'package:jjm_wqmis/models/DWSM/FtkResponse.dart';

import '../models/DWSM/SchoolinfoResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class DwsmRepository{
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<Village>> fetchDemonstartionList(
      int StateId, int DistrictId, String FineYear) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('APIMobile/FTK_DemonstratedList',
        body: jsonEncode({
          'StateId': StateId,
          'DistrictId': DistrictId,
          'FineYear': FineYear,
        }),
      );
      return BaseResponseModel<Village>.fromJson(response,(json)=> Village.fromJson(json));

    } catch (e) {
      debugPrint('Error in fetchDemonstartionList: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<SchoolResult>> fetchSchoolInfo(int Stateid, int Districtid,
      int Blockid, int Gpid, int Villageid, int type) async {
    try {
      final response = await _apiService.get(
          'ApiMaster/GetSchoolAwcs?stateid=$Stateid&districtid=$Districtid&blockid=$Blockid&gpid=$Gpid&villageid=$Villageid&type=$type');
      print("RRRRR_----${response}");
      return BaseResponseModel<SchoolResult>.fromJson(response,(json)=> SchoolResult.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<FtkUpdateResponse> submitFtk( int userId,
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
      return FtkUpdateResponse.fromJson(response);

    } catch (e) {
      debugPrint('Error in fetchDemonstartionList: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


}