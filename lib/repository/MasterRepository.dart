import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/SchemeResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
import 'package:jjm_wqmis/models/Wtp/WTPListResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceFilterResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceResponse.dart';
import 'package:jjm_wqmis/models/ValidateVillage.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';

import '../models/LgdResponse.dart';
import '../models/MasterApiResponse/BlockResponse.dart';
import '../models/MasterApiResponse/HabitationResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class MasterRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<Stateresponse>> fetchStates() async {
    final box = await Hive.box<List<Stateresponse>>('statesBox');

    try {
      final response = await _apiService.get('/apimaster/GetState');
      final apiResponse = BaseResponseModel<Stateresponse>.fromJson(
        response,
            (json) => Stateresponse.fromJson(json),
      );

      if (apiResponse.status == 1) {
        await box.put('states', apiResponse.result); // Cache it
      }

      return apiResponse;
    } catch (e) {
      // Offline fallback
      final cachedData = box.get('states');
      if (cachedData != null) {
        return BaseResponseModel<Stateresponse>(
          status: 1,
          message: 'Loaded from cache',
          result: cachedData,
        );
      }

      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }



    Future<BaseResponseModel<Districtresponse>> fetchDistricts(String stateId) async {
      await Hive.box<List<Districtresponse>>('districtsBox');
      final box = Hive.box<List<Districtresponse>>('districtsBox');

      try {
        final response = await _apiService.get('/apimaster/getdistrict?stateid=$stateId');
        final apiResponse = BaseResponseModel<Districtresponse>.fromJson(
          response,
              (json) => Districtresponse.fromJson(json),
        );

        if (apiResponse.status == 1) {
          await box.put(stateId, apiResponse.result); // Cache by stateId
        }

        return apiResponse;
      } catch (e) {
        final cachedData = box.get(stateId);
        if (cachedData != null) {
          return BaseResponseModel<Districtresponse>(
            status: 1,
            message: 'Loaded from cache',
            result: cachedData,
          );
        }
        //  debugPrint('Error in fetching districts: $e');
          if (e is Exception) {
            GlobalExceptionHandler.handleException(e);
          } else {
          //  debugPrintStack(stackTrace: stackTrace);
          }
          //errorMsg = "Failed to load districts.";

        GlobalExceptionHandler.handleException(e as Exception);
        rethrow;
      }
    }


  Future<BaseResponseModel<BlockResponse>> fetchBlocks(
      String stateId, String districtId) async {
    final box = await Hive.box<List<BlockResponse>>('blocksBox');
    final cacheKey = '$stateId|$districtId';

    try {
      final response = await _apiService.get(
        '/apimaster/getblock?stateid=$stateId&districtid=$districtId',
      );
      final apiResponse = BaseResponseModel<BlockResponse>.fromJson(
        response,
            (json) => BlockResponse.fromJson(json),
      );

      if (apiResponse.status == 1) {
        await box.put(cacheKey, apiResponse.result); // Cache per state+district
      }

      return apiResponse;
    } catch (e) {
      final cachedData = box.get(cacheKey);
      if (cachedData != null) {
        return BaseResponseModel<BlockResponse>(
          status: 1,
          message: 'Loaded from cache',
          result: cachedData,
        );
      }

      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<BaseResponseModel<GramPanchayatresponse>> fetchGramPanchayats(
      String stateId, String districtId, String blockId) async {
    try {
      final response = await _apiService.get('/apimaster/GetGramPanchayat?stateid=$stateId&districtid=$districtId&blockid=$blockId',);

      return BaseResponseModel<GramPanchayatresponse>.fromJson(response,(json)=>GramPanchayatresponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<Villageresponse>> fetchVillages(
      String stateId, String districtId, String blockId, String gpId) async {
    try {
      final response = await _apiService.get('/apimaster/Getvillage?stateid=$stateId&districtid=$districtId&blockid=$blockId&gpid=$gpId',);

      return BaseResponseModel<Villageresponse>.fromJson(response,(json)=>Villageresponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<BaseResponseModel<HabitationResponse>> fetchHabitations(
      String stateId,
      String districtId,
      String blockId,
      String gpId,
      String villageId) async {
    try {
      final response = await _apiService.get(
        '/apimaster/GetHabitaion?stateid=$stateId&districtid=$districtId&blockid=$blockId&gpid=$gpId&villageid=$villageId',
      );

      return BaseResponseModel<HabitationResponse>.fromJson(response,(json)=>HabitationResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<SchemeResponse>> fetchSchemes(
      String villageId,
      String habitationId,
      String districtId,
      String filter,
      ) async {
    try {
      final response = await _apiService.get('/apimaster/getScheme?villageid=$villageId&habitationid=$habitationId&districtid=$districtId&filter=$filter',);

      return BaseResponseModel<SchemeResponse>.fromJson(response,(json)=> SchemeResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<BaseResponseModel<Watersourcefilterresponse>> fetchWaterSourceFilterList() async {
    try {
      final response = await _apiService.get('/apimaster/Get_water_source_filter');
      return BaseResponseModel<Watersourcefilterresponse>.fromJson(response,(json)=> Watersourcefilterresponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<WaterSourceResponse>> fetchSourceInformation(
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
        '/apimaster/Getsources_information?villageid=$villageId&habitaionid=$habitationId&filter=$filter&cat=$cat&subcat=$subcat&wtpid=$wtpId&stateid=$stateId&schemeid=$schemeId');

      return BaseResponseModel<WaterSourceResponse>.fromJson(response,(json)=> WaterSourceResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }



  Future<BaseResponseModel<Wtp>> fetchWTPlist(String stateId, String schemeId) async {
    try {
      final response = await _apiService.get(
        '/apimaster/GetWTP?stateid=$stateId&schemeid=$schemeId',
      );

      return BaseResponseModel<Wtp>.fromJson(response,(json)=> Wtp.fromJson(json));

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

       return response.map((json) => Lgdresponse.fromJson(json)).toList();

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

       return ValidateVillageResponse.fromJson(response);

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Propagate the exception for further handling
    }
  }
}
