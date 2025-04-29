import 'dart:developer';

import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/LabInchargeResponse.dart';
import 'package:jjm_wqmis/models/ParamLabResponse.dart';

import '../models/DWSM/SchoolinfoResponse.dart';
import '../models/LabInchargeResponse/AllLabResponse.dart';
import '../models/LabInchargeResponse/ParameterResponse.dart';
import '../models/Wtp/WtpLabResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class Lapparameterrepository {
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<Alllabresponse>> fetchAllLab(String StateId, String districtId,
      String blockid, String gpid, String villageid, String isall) async {
    try {
      final response = await _apiService.get('/apimaster/Getalllab?StateId=$StateId&districtId=$districtId&blockid=$blockid&gpid=$gpid&villageid=$villageid&isall=$isall');

      log('Fetch All Lab API Response: $response');
      log('API Response Type: ${response.runtimeType}');

      return BaseResponseModel<Alllabresponse>.fromJson(response,(json)=> Alllabresponse.fromJson(json));

    } catch (e, stackTrace) {
      log('Error in fetchAllLab: $e');
      log('StackTrace: $stackTrace');
      GlobalExceptionHandler.handleException(e as Exception); // Removed the 'as Exception' cast
      rethrow;
    }
  }

  Future<BaseResponseModel<Parameterresponse>> fetchAllParameter(String labid,
      String stateid, String sid, String reg_id, String parameteetype) async {
    try {
      final response = await _apiService.get(
          '/apimaster/GetTestList?labid=$labid&stateid=$stateid&sid=$sid&reg_id=$reg_id&parameteetype=$parameteetype');

      log('fetch all parameter Response: $response');

      return BaseResponseModel<Parameterresponse>.fromJson(response,(json)=> Parameterresponse.fromJson(json));

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

  Future<SchoolinfoResponse> fetchSchoolInfo(int Stateid, int Districtid, int Blockid, int Gpid, int Villageid, int type) async {
    try {
      final response =
          await _apiService.get('ApiMaster/GetSchoolAwcs?stateid=$Stateid&districtid=$Districtid&blockid=$Blockid&gpid=$Gpid&villageid=$Villageid&type=$type');

      log('Response: $response'); // No need to use response.body

      if (response != null) {
        return SchoolinfoResponse.fromJson(response); // Directly pass response
      } else {
        throw ApiException("School Infor data is null");
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<BaseResponseModel<Lab>> fetchParamLabs(String stateId, String parameterIds) async {
    try {
      final response = await _apiService.get(
          "APIMaster/getLaboratoriesby_parameter_ids?StateId=$stateId&parameter_ids=$parameterIds");

      return BaseResponseModel<Lab>.fromJson(response,(json)=> Lab.fromJson(json));

 /*     log('fetch param labs Response: $response');

      if (response is Map<String, dynamic>) {
        Paramlabresponse labResponse = Paramlabresponse.fromJson(response);

        if (response.isNotEmpty) {
          return labResponse; // Return the full response if status is true
        }*/

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Return null in case of an error
    }
  }
  Future<BaseResponseModel<WtpLab>> fetchWtpLabs(String stateId, String wtpId) async {
    try {
      final response = await _apiService.get('/apimaster/GetwtpLab?stateid=$stateId&wtpid=$wtpId');

      log('WTP Lab API Response: $response');

      return BaseResponseModel<WtpLab>.fromJson(response,(json)=> WtpLab.fromJson(json));
    /*  if (response is Map<String, dynamic>) {
        WtpLabResponse labResponse = WtpLabResponse.fromJson(response);

        if (response.isNotEmpty) {
          return labResponse; // Return full response if data exists
        }
      } else {
        throw ApiException('Unexpected API response format: $response');
      }*/
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Return null if any error occurs
    }
  }
 }

