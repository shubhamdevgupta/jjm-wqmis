
import 'dart:convert';

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

import 'package:jjm_wqmis/models/LgdResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/BlockResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/HabitationResponse.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';
import 'package:jjm_wqmis/utils/Aesen.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';

class MasterRepository {
  final BaseApiService _apiService = BaseApiService();
  final encryption= AesEncryption();
  Future<BaseResponseModel<Stateresponse>> fetchStates() async {
      final response = await _apiService.get('/apimaster/GetState');
      return BaseResponseModel<Stateresponse>.fromJson(response,(json)=>Stateresponse.fromJson(json));
  }


  Future<BaseResponseModel<Districtresponse>> fetchDistricts(String stateId) async {
    try {
      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
      });

      final response = await _apiService.get('/apimasterA/getdistrict?$query');
      return BaseResponseModel<Districtresponse>.fromJson(response, (json)=>Districtresponse.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<BlockResponse>> fetchBlocks(
      String stateId, String districtId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
      });

      final response = await _apiService.get('/apimasterA/getblock?$query');

      return BaseResponseModel<BlockResponse>.fromJson(response,(json)=>BlockResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<BaseResponseModel<GramPanchayatresponse>> fetchGramPanchayats(
      String stateId, String districtId, String blockId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'blockid': blockId,
      });

      final response = await _apiService.get('/apimasterA/GetGramPanchayat?$query',);

      return BaseResponseModel<GramPanchayatresponse>.fromJson(response,(json)=>GramPanchayatresponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<Villageresponse>> fetchVillages(
      String stateId, String districtId, String blockId, String gpId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'blockid': blockId,
        'gpid': gpId,
      });

      final response = await _apiService.get('/apimasterA/Getvillage?$query',);

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

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'blockid': blockId,
        'gpid': gpId,
        'villageid': villageId,
      });

      final response = await _apiService.get(
        '/apimasterA/GetHabitaion?$query',
      );

      return BaseResponseModel<HabitationResponse>.fromJson(response,(json)=>HabitationResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<SchemeResponse>> fetchSchemes(
      String stateId,
      String districtId,
      String villageId,
      String habitationId,
      String filter,
      ) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'villageid': villageId,
        'habitationid': habitationId,
        'filter': filter
      });

      final response = await _apiService.get('/apimasterA/getScheme?$query');

      return BaseResponseModel<SchemeResponse>.fromJson(response,(json)=> SchemeResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<BaseResponseModel<Watersourcefilterresponse>> fetchWaterSourceFilterList() async {
    try {

      final response = await _apiService.get('/apimasterA/Get_water_source_filter');
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
      final query = _apiService.buildEncryptedQuery({
        'villageid': villageId,
        'habitaionid': habitationId,
        'filter': filter,
        'cat': cat,
        'subcat': subcat,
        'wtpid': wtpId,
        'stateid': stateId,
        'schemeid': schemeId,
      });


      final response = await _apiService.get(
        '/apimasterA/Getsources_information?$query');

      return BaseResponseModel<WaterSourceResponse>.fromJson(response,(json)=> WaterSourceResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }



  Future<BaseResponseModel<Wtp>> fetchWTPlist(String stateId, String schemeId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'schemeid': schemeId,
      });

      final response = await _apiService.get(
        '/apimasterA/GetWTP?$query',
      );

      return BaseResponseModel<Wtp>.fromJson(response,(json)=> Wtp.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<List<Lgdresponse>> fetchVillageLgd(double lon, double lat) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'lat': lat.toStringAsFixed(8),
        'lon': lon.toStringAsFixed(8),
      });

      final response = await _apiService.get('GetVillageDetails/api/GeoData/getVillageDetails?$query',
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

      final query = _apiService.buildEncryptedQuery({
        'villageid': villageId,
        'lgdcode': lgdCode,
      });

      final response = await _apiService.get(
        '/apimasterA/validateVillage?$query',
      );

       return ValidateVillageResponse.fromJson(response);

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Propagate the exception for further handling
    }
  }
  Future<Map<String, dynamic>> decryptResponse(Map<String, dynamic> response) async {
    final encrypted = response['EncryptedData'];
    final decryptedString = encryption.decryptText(encrypted);
    return jsonDecode(decryptedString);
  }

}
