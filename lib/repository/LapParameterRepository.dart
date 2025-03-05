import 'dart:developer';

import '../models/MasterApiResponse/AllLabResponse.dart';
import '../models/MasterApiResponse/ParameterResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/CustomException.dart';


class Lapparameterrepository{
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
      throw NetworkException();
    }
  }

  Future<List<Parameterresponse>> fetchAllParameter(String labid, String stateid,
      String sid, String reg_id, String parameteetype) async {
    try {
      final response = await _apiService.get(
          '/apimaster/GetTestList?labid=$labid&stateid=$stateid&sid=$sid&reg_id=$reg_id&parameteetype=$parameteetype');

      log('Water Source API Response: $response');

      if (response is List) {
        return response.map((item) => Parameterresponse.fromJson(item)).toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      throw NetworkException();
    }
  }
}

