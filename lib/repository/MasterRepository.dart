import 'dart:developer';

import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/SchemeResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceResponse.dart';

import '../models/LoginResponse.dart';
import '../models/MasterApiResponse/BlockResponse.dart';
import '../models/MasterApiResponse/HabitationResponse.dart';
import '../services/BaseApiService.dart';

class MasterRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<LoginResponse> loginUser(String phoneNumber, String password,String roldId,String txtSalt) async {
    final response = await _apiService.post(
      '/JJM_Mobile/Login',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: {
        'loginid': phoneNumber,
        'password': password,
        'role_id':roldId,
        'txtSaltedHash': txtSalt
      },
    );
    return LoginResponse.fromJson(response);
  }

  Future<List<Stateresponse>> fetchStates() async {
    try {
      // Call the GET method from BaseApiService
      final response = await _apiService.get('/GetState');
      log('API Response: $response');

      // Parse response and convert to List<StateModel>
      if (response is List) {
        print('response success $response');
        return response.map((item) => Stateresponse.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      log('Error in fetchStates: $e');
      rethrow;
    }
  }

  Future<List<Districtresponse>> fetchDistricts(String stateId) async {
    try {
      // Call the GET method from BaseApiService
      final response = await _apiService.get('/getdistrict?stateid=$stateId');
      log('API Response for Districts: $response');

      // Parse response and convert to List<DistrictResponse>
      if (response is List) {
        return response.map((item) => Districtresponse.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response format for districts');
      }
    } catch (e) {
      log('Error in fetchDistricts: $e');
      rethrow;
    }
  }

  Future<List<BlockResponse>> fetchBlocks(
      String stateId, String districtId) async {
    try {
      final response = await _apiService
          .get('/getblock?stateid=$stateId&districtid=$districtId');
      log('Block API Response: $response');

      if (response is List) {
        return response.map((item) => BlockResponse.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      log('Error in fetchBlocks: $e');
      rethrow;
    }
  }

  Future<List<GramPanchayatresponse>> fetchGramPanchayats(
      String stateId, String districtId, String blockId) async {
    try {
      final response = await _apiService.get(
          '/GetGramPanchayat?stateid=$stateId&districtid=$districtId&blockid=$blockId');
      log('Grampanchayat API Response: $response');

      if (response is List) {
        return response
            .map((item) => GramPanchayatresponse.fromJson(item))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      log('Error in fetchGramPanchayats: $e');
      rethrow;
    }
  }

  Future<List<Villageresponse>> fetchVillages(
      String stateId, String districtId, String blockId, String gpId) async {
    try {
      final response = await _apiService.get(
          '/Getvillage?stateid=$stateId&districtid=$districtId&blockid=$blockId&gpid=$gpId');

      log('Village API Response: $response');

      if (response is List) {
        return response.map((item) => Villageresponse.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      log('Error in fetchVillages: $e');
      rethrow;
    }
  }

  Future<List<HabitationResponse>> fetchHabitations(String stateId,
      String districtId, String blockId, String gpId, String villageId) async {
    try {
      final response = await _apiService.get(
          '/GetHabitaion?stateid=$stateId&districtid=$districtId&blockid=$blockId&gpid=$gpId&villageid=$villageId');

      log('Habitation API Response: $response');

      if (response is List) {
        return response
            .map((item) => HabitationResponse.fromJson(item))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      log('Error in fetchHabitations: $e');
      rethrow;
    }
  }

  Future<List<SchemeResponse>> fetchSchemes(
      String villageId, String habitationId) async {
    try {
      final response = await _apiService
          .get('/getScheme?villageid=$villageId&habitationid=$habitationId');

      log('Scheme API Response: $response');

      if (response is List) {
        return response.map((item) => SchemeResponse.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      log('Error in fetchSchemes: $e');
      rethrow;
    }
  }

  Future<List<WaterSourceResponse>> fetchSourceInformation(
      String villageId,
      String habitationId,
      String filter,
      String cat,
      String subcat,
      String wtpId,
      String stateId,
      String schemeId) async {
    try {
      final response = await _apiService.get(
          '/Getsources_information?villageid=$villageId&habitaionid=$habitationId&filter=$filter&cat=$cat&subcat=$subcat&wtpid=$wtpId&stateid=$stateId&schemeid=$schemeId');

      log('Water Source API Response: $response');

      if (response is List) {
        return response
            .map((item) => WaterSourceResponse.fromJson(item))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      log('Error in fetchSchemes: $e');
      rethrow;
    }
  }
}
