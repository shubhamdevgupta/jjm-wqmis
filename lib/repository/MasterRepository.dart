import 'dart:developer';

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
      final response = await _apiService.get('/apimaster/GetState');
      return BaseResponseModel<Stateresponse>.fromJson(response,(json)=>Stateresponse.fromJson(json));
  }


  Future<BaseResponseModel<Districtresponse>> fetchDistricts(String stateId) async {
    try {
      final response = await _apiService.get('/apimaster/getdistrict?stateid=$stateId');
      return BaseResponseModel<Districtresponse>.fromJson(response, (json)=>Districtresponse.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<BlockResponse>> fetchBlocks(
      String stateId, String districtId) async {
    try {
      final response = await _apiService.get('/apimaster/getblock?stateid=$stateId&districtid=$districtId');

      return BaseResponseModel<BlockResponse>.fromJson(response,(json)=>BlockResponse.fromJson(json));

    } catch (e) {
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
enum ApiType {
  ejalShakti,
  reverseGeocoding,
}
