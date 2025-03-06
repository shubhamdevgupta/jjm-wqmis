import 'dart:developer';

import 'package:jjm_wqmis/models/MasterApiResponse/AllLabResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/ParameterResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/SchemeResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WTPListResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceFilterResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceResponse.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';

import '../models/MasterApiResponse/BlockResponse.dart';
import '../models/MasterApiResponse/HabitationResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class MasterRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<List<Stateresponse>> fetchStates() async {
    try {
      // Call the GET method from BaseApiService
      final response = await _apiService.get('/apimaster/GetState');
      log('API Response: $response');

      // Parse response and convert to List<StateModel>
      if (response is List) {
        print('response success $response');
        return response.map((item) => Stateresponse.fromJson(item)).toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Rethrow the original exception so the Provider can handle it if needed
    }
  }


  Future<List<Districtresponse>> fetchDistricts(String stateId) async {
    try {
      // Call the GET method from BaseApiService
      final response =
          await _apiService.get('/apimaster/getdistrict?stateid=$stateId');
      log('API Response for Districts: $response');

      // Parse response and convert to List<DistrictResponse>
      if (response is List) {
        return response.map((item) => Districtresponse.fromJson(item)).toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<BlockResponse>> fetchBlocks(
      String stateId, String districtId) async {
    try {
      final response = await _apiService
          .get('/apimaster/getblock?stateid=$stateId&districtid=$districtId');
      log('Block API Response: $response');

      if (response is List) {
        return response.map((item) => BlockResponse.fromJson(item)).toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<GramPanchayatresponse>> fetchGramPanchayats(String stateId, String districtId, String blockId) async {
    try {
      final response = await _apiService.get(
          '/apimaster/GetGramPanchayat?stateid=$stateId&districtid=$districtId&blockid=$blockId');
      log('Grampanchayat API Response: $response');

      if (response is List) {
        return response
            .map((item) => GramPanchayatresponse.fromJson(item))
            .toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<Villageresponse>> fetchVillages(String stateId, String districtId, String blockId, String gpId) async {
    try {
      final response = await _apiService.get(
          '/apimaster/Getvillage?stateid=$stateId&districtid=$districtId&blockid=$blockId&gpid=$gpId');

      log('Village API Response: $response');

      if (response is List) {
        return response.map((item) => Villageresponse.fromJson(item)).toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<HabitationResponse>> fetchHabitations(String stateId, String districtId, String blockId, String gpId, String villageId) async {
    try {
      final response = await _apiService.get(
          '/apimaster/GetHabitaion?stateid=$stateId&districtid=$districtId&blockid=$blockId&gpid=$gpId&villageid=$villageId');

      log('Habitation API Response: $response');

      if (response is List) {
        return response
            .map((item) => HabitationResponse.fromJson(item))
            .toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<SchemeResponse>> fetchSchemes(String villageId, String habitationId) async {
    try {
      final response = await _apiService.get(
          '/apimaster/getScheme?villageid=$villageId&habitationid=$habitationId');

      log('Scheme API Response: $response');

      if (response is List) {
        return response.map((item) => SchemeResponse.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      log('Error in fetchSchemes: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<Watersourcefilterresponse>> fetchWaterSourceFilterList() async {
    try {
      final response =
          await _apiService.get('/apimaster/Get_water_source_filter');

      log('water source type API Response: $response');

      if (response is List) {
        return response
            .map((item) => Watersourcefilterresponse.fromJson(item))
            .toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<WaterSourceResponse>> fetchSourceInformation(
      String villageId,
      String habitationId,
      int filter,
      String cat,
      String subcat,
      String wtpId,
      String stateId,
      String schemeId) async {
    try {
      final response = await _apiService.get(
          '/apimaster/Getsources_information?villageid=$villageId&habitaionid=$habitationId&filter=$filter&cat=$cat&subcat=$subcat&wtpid=$wtpId&stateid=$stateId&schemeid=$schemeId');

      log('Source Information API Response: $response');

      if (response is List) {
        return response
            .map((item) => WaterSourceResponse.fromJson(item))
            .toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<Wtplistresponse>> fetchWTPlist(String villageId,
      String habitationId, String stateId, String schemeId) async {
    try {
      final response = await _apiService.get(
          '/apimaster/GetWTP?villageid=$villageId&habitationid=$habitationId&stateid=$stateId&schemeid=$schemeId');

      log('WTP List  API Response: $response');

      if (response is List) {
        return response.map((item) => Wtplistresponse.fromJson(item)).toList();
      } else {
        throw ApiException('Api Error :$response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}
