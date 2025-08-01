import 'dart:developer';

import 'package:jjm_wqmis/models/base_response.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/lab_incharge_response.dart';
import 'package:jjm_wqmis/models/param_lab_response.dart';

import 'package:jjm_wqmis/models/LabInchargeResponse/allLab_response.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/parameter_response.dart';
import 'package:jjm_wqmis/models/Wtp/wtp_lab_response.dart';
import 'package:jjm_wqmis/services/base_api_service.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';

class Lapparameterrepository {
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<AllLabResponse>> fetchAllLab(String stateId, String districtId,
      String blockid, String gpid, String villageid, String isall, int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'StateId': stateId,
        'districtId': districtId,
        'blockid': blockid,
        'gpid': gpid,
        'villageid': villageid,
        'isall': isall,
        'reg_Id' :regId
      });

      final response = await _apiService.get('/apimasterA/Getalllab?$query');

      return BaseResponseModel<AllLabResponse>.fromJson(response,(json)=> AllLabResponse.fromJson(json));

    } catch (e) {
      log('Error in fetchAllLab: $e');
      GlobalExceptionHandler.handleException(e as Exception); // Removed the 'as Exception' cast
      rethrow;
    }
  }

  Future<BaseResponseModel<Parameterresponse>> fetchAllParameter(String labid,
      String stateid, String sid, String regId, String parameteetype) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'labid': labid,
        'stateid': stateid,
        'sid': sid,
        'reg_id': regId,
        'parameteetype': parameteetype,
      });

      final response = await _apiService.get('/apimasterA/GetTestList?$query');

      return BaseResponseModel<Parameterresponse>.fromJson(response,(json)=> Parameterresponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<Labinchargeresponse?> fetchLabIncharge(int labId, int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'labid': labId,
        'reg_Id' :regId
      });

      final response = await _apiService.get('APIMasterA/getLabIncharge?$query');

        return Labinchargeresponse.fromJson(response); // Directly pass response

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }



  Future<BaseResponseModel<Lab>> fetchParamLabs(String stateId, String parameterIds, int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'StateId': stateId,
        'parameter_ids': parameterIds,
        'reg_Id' :regId

      });

      final response = await _apiService.get("APIMasterA/getLaboratoriesby_parameter_ids?$query");

      return BaseResponseModel<Lab>.fromJson(response,(json)=> Lab.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Return null in case of an error
    }
  }
  Future<BaseResponseModel<WtpLab>> fetchWtpLabs(String stateId, String wtpId, int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'wtpid': wtpId,
        'reg_Id' :regId

      });

      final response = await _apiService.get('/apimasterA/GetwtpLab?$query');


      return BaseResponseModel<WtpLab>.fromJson(response,(json)=> WtpLab.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Return null if any error occurs
    }
  }
 }

