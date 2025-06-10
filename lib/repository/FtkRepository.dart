import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/FTK/FtkParameterResponse.dart';
import 'package:jjm_wqmis/models/SampleResponse.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';
import 'package:jjm_wqmis/utils/GlobalExceptionHandler.dart';

class FtkRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<FtkParameter>> fetchParameterList(
      int stateId, int districtId) async {
    try {
      final response = await _apiService.get(
          'APIMaster/GetParameterList?StateId=$stateId&DistrictId=$districtId');
      print("RRRRR_----$response");
      return BaseResponseModel<FtkParameter>.fromJson(
          response, (json) => FtkParameter.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Sampleresponse> saveFtkData(String mobileNumber,int regId,int roleId,
      String sampleCollectionTime,String sampleTestingTime,int sourceId, int sourceLocation,
      int state,int district,int block, int gramPanchayat,int village, int habitation,
      String address, String sampleRemark, int waterSourceFilter,int schemeId,String otherSouceLocation,
      String sourceName, String latitude,String longitude, String IpAddress, String sampleTypeOther,
      int isTreadted, String parameteId,String paramSaferange
      ) async {
    final requestData = jsonEncode({
      "loginid": mobileNumber,
      "Reg_Id": regId,
      "role_id": roleId,
      "sample_collection_time": sampleCollectionTime,
      "sample_testing_time": sampleTestingTime,
      "source_id": sourceId,
      "sample_source_location": sourceLocation,
      "source_state": state,
      "source_district": district,
      "source_block": block,
      "source_gp": gramPanchayat,
      "source_village": village,
      "source_habitation": habitation,
      "address":address,
      "sample_remark": sampleRemark,
      "source_filter": waterSourceFilter,
      "SchemeId": schemeId,
      "Other_Source_location": otherSouceLocation,
      "SourceName": sourceName,
      "source_latitude": latitude,
      "source_longitude": longitude,
      "IpAddress": IpAddress,
      "sample_type_other": sampleTypeOther,
      "istreated":isTreadted,
      "test_selected": parameteId,
      "saferangeid": paramSaferange
    });

    debugPrint("Sample Submit Request: $requestData");

    try {
      final response = await _apiService.post('APIMobile/add_ftk_data', body: requestData);

      return Sampleresponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}
