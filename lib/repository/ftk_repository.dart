import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/base_response.dart';
import 'package:jjm_wqmis/models/FTK/ftk_dashboard_response.dart';
import 'package:jjm_wqmis/models/FTK/ftk_data_response.dart';
import 'package:jjm_wqmis/models/FTK/ftk_parameter_response.dart';
import 'package:jjm_wqmis/models/FTK/sample_response.dart';
import 'package:jjm_wqmis/services/base_api_service.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';

class FtkRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<FtkParameter>> fetchParameterList(
      int stateId, int districtId,int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery(
        {
          'StateId': stateId.toString(),
          'DistrictId': districtId.toString(),
          'reg_Id' :regId
        },
      );

      final response = await _apiService.get(
          'APIMasterA/GetParameterList?$query');
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
      String ipAddress,
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
      "IpAddress": ipAddress,
      "sample_type_other": sampleTypeOther,
      "test_selected": parameteId,
      "saferangeid": paramSaferange
    }));

    debugPrint("Sample Submit Request: $requestData");

    try {
      final response =
          await _apiService.post('APIMobileA/add_ftk_data', body: requestData);

      return Sampleresponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<FtkSample>> fetchFtkSample(
      int regId,
      int villageid,
      int sampleId,
      ) async {
    try {

      final query = _apiService.buildEncryptedQuery(
        {
          'reg_id': regId,
          'villageid': villageid.toString(),
          'SampleId': sampleId.toString(),
        },
      );

      final String endpoint = '/apimobileA/ftksampleList?$query';

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

      final String endpoint = '/apimobileA/FTKDashboard?$query';

      final response = await _apiService.get(endpoint);

      return FtkDashboardResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}
