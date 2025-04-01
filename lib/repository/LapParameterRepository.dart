import 'dart:developer';

import 'package:jjm_wqmis/models/LabInchargeResponse/LabInchargeResponse.dart';
import 'package:jjm_wqmis/models/WtpLabRespons.dart';

import '../models/LabInchargeResponse/AllLabResponse.dart';
import '../models/LabInchargeResponse/ParameterResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class Lapparameterrepository {
  final BaseApiService _apiService = BaseApiService();

  Future<List<Alllabresponse>> fetchAllLab(String StateId, String districtId,
      String blockid, String gpid, String villageid, String isall) async {
    try {
      final response = await _apiService.get(
          '/apimaster/Getalllab?StateId=$StateId&districtId=$districtId&blockid=$blockid&gpid=$gpid&villageid=$villageid&isall=$isall');

      log('Fetch All Lab API Response: $response');
      log('API Response Type: ${response.runtimeType}');

      if (response is List<dynamic>) {
        return response.map((item) => Alllabresponse.fromJson(item)).toList();
      } else {
        throw ApiException('Unexpected API response format: $response');
      }
    } catch (e, stackTrace) {
      log('Error in fetchAllLab: $e');
      log('StackTrace: $stackTrace');
      GlobalExceptionHandler.handleException(e as Exception); // Removed the 'as Exception' cast
      rethrow;
    }
  }
  Future<List<WtpLabResponse>> fetchWtpLabs(String stateId, String wtpId) async {
    try {
      // API call
      final response = await _apiService.get(
          '/apimaster/GetwtpLab?stateid=$stateId&wtpid=$wtpId');

      log('WTP Lab API Response: $response');

      // Check for valid response structure
      if (response is Map<String, dynamic> && response['Status'] == 1) {
        final results = response['Result'] as List;
        return results.map((item) => WtpLabResponse.fromJson(item)).toList();
      } else {
        throw ApiException('API Error: ${response['Message']}');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Rethrow to propagate error
    }
  }


  Future<List<Parameterresponse>> fetchAllParameter(String labid,
      String stateid, String sid, String reg_id, String parameteetype) async {
    try {
      final response = await _apiService.get(
          '/apimaster/GetTestList?labid=$labid&stateid=$stateid&sid=$sid&reg_id=$reg_id&parameteetype=$parameteetype');

      log('fetch all parameter Response: $response');

      if (response is List) {
        return response
            .map((item) => Parameterresponse.fromJson(item))
            .toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Labinchargeresponse?> fetchLabIncharge(int labId) async {
    try {
      final response =
          await _apiService.get('APIMaster/getLabIncharge?labid=$labId');

      log('Response: $response'); // No need to use response.body

      if (response != null) {
        return Labinchargeresponse.fromJson(response); // Directly pass response
      } else {
        throw ApiException("Lab Incharge data is null");
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}
