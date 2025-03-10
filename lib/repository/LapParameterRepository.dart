import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/LabInchargeResponse/LabInchargeResponse.dart';

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

      if (response is List) {
        return response.map((item) => Alllabresponse.fromJson(item)).toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;    }
  }

  Future<List<Parameterresponse>> fetchAllParameter(String labid,
      String stateid,
      String sid, String reg_id, String parameteetype) async {
    try {
      final response = await _apiService.get(
          '/apimaster/GetTestList?labid=$labid&stateid=$stateid&sid=$sid&reg_id=$reg_id&parameteetype=$parameteetype');

      log('fetch all parameter Response: $response');

      if (response is List) {
        return response.map((item) => Parameterresponse.fromJson(item))
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
      final response = await _apiService.get('APIMaster/getLabIncharge?labid=$labId');

      log('Response: $response'); // No need to use response.body

      if (response != null) {
        return Labinchargeresponse.fromJson(response);  // Directly pass response
      } else {
        throw ApiException("Lab Incharge data is null");
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }



}