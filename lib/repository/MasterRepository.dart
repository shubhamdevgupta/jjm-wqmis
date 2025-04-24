import 'dart:convert';
import 'dart:developer';

import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/SchemeResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
import 'package:jjm_wqmis/models/Wtp/WTPListResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceFilterResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceResponse.dart';
import 'package:jjm_wqmis/models/ValidateVillage.dart';
import 'package:jjm_wqmis/models/Wtp/WtpLabResponse.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';

import '../models/LgdResponse.dart';
import '../models/MasterApiResponse/BlockResponse.dart';
import '../models/MasterApiResponse/HabitationResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class MasterRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<List<Stateresponse>> fetchStates() async {
    try {
      final response = await _apiService.get('/apimaster/GetState');
      log('API Response: $response');

      // Parse entire response and extract the Result
      if (response is Map<String, dynamic>) {
        final stateApiResponse = StateApiResponse.fromJson(response);
        return stateApiResponse.result;
      } else {
        throw ApiException('Invalid API Response Format');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<List<Districtresponse>> fetchDistricts(String stateId) async {
    try {
      final response =
      await _apiService.get('/apimaster/getdistrict?stateid=$stateId');
      log('API Response for Districts: $response');

      if (response is Map<String, dynamic>) {
        final districtApiResponse = DistrictApiResponse.fromJson(response);
        return districtApiResponse.result;
      } else {
        throw ApiException('Invalid API Response Format');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      print("catch in master repo fetch district $e");
      rethrow;
    }
  }

  Future<List<BlockResponse>> fetchBlocks(
      String stateId, String districtId) async {
    try {
      final response = await _apiService
          .get('/apimaster/getblock?stateid=$stateId&districtid=$districtId');
      log('Block API Response: $response');

      if (response is Map<String, dynamic>) {
        final blockApiResponse = BlockApiResponse.fromJson(response);
        return blockApiResponse.result;
      } else {
        throw ApiException('Invalid API Response Format');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<List<GramPanchayatresponse>> fetchGramPanchayats(
      String stateId, String districtId, String blockId) async {
    try {
      final response = await _apiService.get(
        '/apimaster/GetGramPanchayat?stateid=$stateId&districtid=$districtId&blockid=$blockId',
      );
      log('Grampanchayat API Response: $response');

      if (response is Map<String, dynamic>) {
        final apiResponse = GramPanchayatApiResponse.fromJson(response);
        return apiResponse.result;
      } else {
        throw ApiException('Invalid API Response Format');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<Villageresponse>> fetchVillages(
      String stateId, String districtId, String blockId, String gpId) async {
    try {
      final response = await _apiService.get(
        '/apimaster/Getvillage?stateid=$stateId&districtid=$districtId&blockid=$blockId&gpid=$gpId',
      );

      log('Village API Response: $response');

      if (response is Map<String, dynamic>) {
        final apiResponse = VillageApiResponse.fromJson(response);
        return apiResponse.result;
      } else {
        throw ApiException('Invalid API Response Format');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<List<HabitationResponse>> fetchHabitations(
      String stateId,
      String districtId,
      String blockId,
      String gpId,
      String villageId) async {
    try {
      final response = await _apiService.get(
        '/apimaster/GetHabitaion?stateid=$stateId&districtid=$districtId&blockid=$blockId&gpid=$gpId&villageid=$villageId',
      );

      log('Habitation API Response: $response');
      if (response is Map<String, dynamic>) {
        final apiResponse =HabitationApiResponse.fromJson(response);
        return apiResponse.result;
      } else {
        throw ApiException('Api Error: Unexpected response format');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<List<SchemeResponse>> fetchSchemes(
      String villageId,
      String habitationId,
      String districtId,
      String filter,
      ) async {
    try {
      final response = await _apiService.get(
        '/apimaster/getScheme?villageid=$villageId&habitationid=$habitationId&districtid=$districtId&filter=$filter',
      );

      log('Scheme API Response: $response');

      final fullResponse = SchemeApiResponse.fromJson(response);

      if (fullResponse.status == 1) {
        return fullResponse.result;
      } else {
        throw Exception('API Error: ${fullResponse.message}');
      }
    } catch (e) {
      log('Error in fetchSchemes: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<List<Watersourcefilterresponse>> fetchWaterSourceFilterList() async {
    try {
      final response = await _apiService.get('/apimaster/Get_water_source_filter');

      log('Water source type API Response: $response');

      if (response is Map<String, dynamic> && response.containsKey('Result')) {
        final result = response['Result'] as List;
        return result
            .map((item) => Watersourcefilterresponse.fromJson(item))
            .toList();
      } else {
        throw ApiException('Api Error: Unexpected response format');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
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
      String schemeId,
      ) async {
    try {
      final response = await _apiService.get(
        '/apimaster/Getsources_information?villageid=$villageId&habitationid=$habitationId&filter=$filter&cat=$cat&subcat=$subcat&wtpid=$wtpId&stateid=$stateId&schemeid=$schemeId');

      log('Source Information API Response: $response');
      log('Response type: ${response.runtimeType}');

      final fullResponse = WaterSourceApiResponse.fromJson(response);

      if (fullResponse.status == 1) {
        return fullResponse.result;
      } else {
        throw ApiException('API Error: ${fullResponse.message}');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }



  Future<List<Wtp>> fetchWTPlist(String stateId, String schemeId) async {
    try {
      final response = await _apiService.get(
        '/apimaster/GetWTP?stateid=$stateId&schemeid=$schemeId',
      );

      log('WTP List API Response: $response');

      if (response is Map<String, dynamic>) {
        if (response['Status'] == 1 && response['Result'] is List && response['Result'].isNotEmpty) {
          return (response['Result'] as List)
              .map((item) => Wtp.fromJson(item))
              .toList();
        }
        return [
          Wtp(wtpName: 'No record available', wtpId: 'not_available'),
        ];
      }
      throw ApiException('API Error: Invalid response format');
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<List<Lgdresponse>> fetchVillageLgd(double lon, double lat) async {
    try {
      String formattedLon = lon.toStringAsFixed(8);
      String formattedLat = lat.toStringAsFixed(8);

      final response = await _apiService.get(
        'GetVillageDetails/api/GeoData/getVillageDetails?lon=$formattedLon&lat=$formattedLat',
        apiType: ApiType.reverseGeocoding,
      );

      log('API Response: from reverse geo tagging $response');

      // Check if response is a List<dynamic>
      if (response is List) {
        return response.map((json) => Lgdresponse.fromJson(json)).toList();
      } else {
        throw ApiException('Unexpected API Response Format: $response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<ValidateVillageResponse> validateVillage(
      String villageId, String lgdCode) async {
    try {
      final response = await _apiService.get(
        '/apimaster/validateVillage?villageid=$villageId&lgdcode=$lgdCode',
      );

      // Log the API response
      print('Validate Village API Response: $response');

      // Validate the response and return the model
      if (response is Map<String, dynamic> && response['Status'] == 1) {
        return ValidateVillageResponse.fromJson(response);
      } else {
        throw ApiException('API Error: ${response['Message']}');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Propagate the exception for further handling
    }
  }






}
enum ApiType {
  ejalShakti,
  reverseGeocoding,
}
