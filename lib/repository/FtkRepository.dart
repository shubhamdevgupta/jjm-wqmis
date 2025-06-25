import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/FTK/FtkDashboardResponse.dart';
import 'package:jjm_wqmis/models/FTK/FtkDataResponse.dart';
import 'package:jjm_wqmis/models/FTK/FtkParameterResponse.dart';
import 'package:jjm_wqmis/models/FTK/SampleResponse.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';

class FtkRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<FtkParameter>> fetchParameterList(
      int stateId, int districtId) async {
    try {

      final query = _apiService.buildEncryptedQuery(
        {
          'StateId': stateId.toString(),
          'DistrictId': districtId.toString(),
        },
      );

      final response = await _apiService.get(
          'APIMaster/GetParameterList?$query');
      print("RRRRR_----$response");
      return BaseResponseModel<FtkParameter>.fromJson(
          response, (json) => FtkParameter.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Sampleresponse> saveFtkData(
      String mobileNumber,
      int regId,
      int roleId,
      String sampleCollectionTime,
      String sampleTestingTime,
      int sourceId,
      int sourceLocation,
      int state,
      int district,
      int block,
      int gramPanchayat,
      int village,
      int habitation,
      String address,
      String sampleRemark,
      int waterSourceFilter,
      int schemeId,
      String otherSouceLocation,
      String sourceName,
      String latitude,
      String longitude,
      String IpAddress,
      String sampleTypeOther,
      String parameteId,
      String paramSaferange) async {
    final requestData = jsonEncode(encryptDataClassBody({
      "loginid": mobileNumber,
      "Reg_Id": regId,
      "role_id": roleId,
      "sample_collection_time": sampleCollectionTime,
      "sample_testing_time": sampleTestingTime,
      "cat": sourceId,
      "sample_source_location": sourceLocation,
      "source_state": state,
      "source_district": district,
      "source_block": block,
      "source_gp": gramPanchayat,
      "source_village": village,
      "source_habitation": habitation,
      "address": address,
      "remarks": sampleRemark,
      "source_filter": waterSourceFilter,
      "SchemeId": schemeId,
      "Other_Source_location": otherSouceLocation,
      "SourceName": sourceName,
      "source_latitude": latitude,
      "source_longitude": longitude,
      "IpAddress": IpAddress,
      "sample_type_other": sampleTypeOther,
      "test_selected": parameteId,
      "saferangeid": paramSaferange
    }));

    debugPrint("Sample Submit Request: $requestData");

    try {
      final response =
          await _apiService.post('APIMobile/add_ftk_data', body: requestData);

      return Sampleresponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<FtkSample>> fetchFtkSample(
      int regId,
      int villageid,
      int SampleId,
      ) async {
    try {

      final query = _apiService.buildEncryptedQuery(
        {
          'reg_id': regId.toString(),
          'villageid': villageid.toString(),
          'SampleId': SampleId.toString(),
        },
      );

      final String endpoint = '/apimobile/ftksampleList?$query';

      final response = await _apiService.get(endpoint);

      return BaseResponseModel<FtkSample>.fromJson(
          response, (json) => FtkSample.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<FtkDashboardResponse> fetchFtkDashboardData(
      int regId,
      int villageid,
      ) async {
    try {

      final query = _apiService.buildEncryptedQuery(
        {
          'reg_id': regId.toString(),
          'villageid': villageid.toString(),
        },
      );

      final String endpoint = '/apimobile/FTKDashboard?$query';

      final response = await _apiService.get(endpoint);

      return FtkDashboardResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}
