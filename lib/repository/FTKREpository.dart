import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jjm_wqmis/models/BaseResponse.dart';

import '../models/DWSM/Ftk_response.dart';
import '../models/DWSM/SchoolinfoResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class FTKRepository {
  final String _baseUrl =
      "https://ejalshakti.gov.in/wqmis/API/APIMobile/FTK_Demonstrated";
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<FTKResponse>> submitFTKData({
     int? userId,
     int? schoolId,
     int? stateId,
     String? photoBase64,
     String? fineYear,
     String? remark,
     String? latitude,
     String? longitude,
     String? ipAddress,
  })  async {
    try{
      final response = await _apiService.post('APIMobile/FTK_Demonstrated',
        body: jsonEncode({
          "UserId": userId,
          "SchoolId": schoolId,
          "StateId":stateId,
          "Photo":photoBase64,
          "FineYear":"2025-2026",
          "Remark":remark,
          "Latitude":latitude,
          "Longitude":longitude,
          "IPAddress":ipAddress
        }),
      );
      return BaseResponseModel<FTKResponse>.fromJson(response,(json)=> FTKResponse.fromJson(json));
    }catch (e) {
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
}
