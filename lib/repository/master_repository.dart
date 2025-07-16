
import 'package:jjm_wqmis/models/base_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/grampanchayat_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/scheme_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/village_response.dart';
import 'package:jjm_wqmis/models/Wtp/wtp_list_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/water_source_filter_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/water_source_response.dart';
import 'package:jjm_wqmis/models/validate_village.dart';

import 'package:jjm_wqmis/models/lgd_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/block_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/habitation_response.dart';
import 'package:jjm_wqmis/services/base_api_service.dart';
import 'package:jjm_wqmis/utils/encyp_decyp.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';

class MasterRepository {
  final BaseApiService _apiService = BaseApiService();

  final encryption = AesEncryption();

  Future<BaseResponseModel<BlockResponse>> fetchBlocks(
      String stateId, String districtId , int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'reg_Id' :regId
      });

      final response = await _apiService.get('/apimasterA/getblock?$query');

      return BaseResponseModel<BlockResponse>.fromJson(response,(json)=>BlockResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<BaseResponseModel<GramPanchayatresponse>> fetchGramPanchayats(
      String stateId, String districtId, String blockId,int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'blockid': blockId,
        'reg_Id' :regId

      });

      final response = await _apiService.get('/apimasterA/GetGramPanchayat?$query',);

      return BaseResponseModel<GramPanchayatresponse>.fromJson(response,(json)=>GramPanchayatresponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<Villageresponse>> fetchVillages(
      String stateId, String districtId, String blockId, String gpId,int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'blockid': blockId,
        'gpid': gpId,
        'reg_Id' :regId

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
      String villageId,
      int regId
      ) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'blockid': blockId,
        'gpid': gpId,
        'villageid': villageId,
        'reg_Id' :regId

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
      int regId
      ) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'villageid': villageId,
        'habitationid': habitationId,
        'filter': filter,
        'reg_Id' :regId

      });

      final response = await _apiService.get('/apimasterA/getScheme?$query');

      return BaseResponseModel<SchemeResponse>.fromJson(response,(json)=> SchemeResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


  Future<BaseResponseModel<Watersourcefilterresponse>> fetchWaterSourceFilterList(int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'reg_Id' :regId
      });

      final response = await _apiService.get('/apimasterA/Get_water_source_filter?$query');
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
      int regId
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
        'reg_Id' :regId

      });


      final response = await _apiService.get(
        '/apimasterA/Getsources_information?$query');

      return BaseResponseModel<WaterSourceResponse>.fromJson(response,(json)=> WaterSourceResponse.fromJson(json));

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }



  Future<BaseResponseModel<Wtp>> fetchWTPlist(String stateId, String schemeId,int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'schemeid': schemeId,
        'reg_Id' :regId

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
      String villageId, String lgdCode,int regId) async {
    try {

      final query = _apiService.buildEncryptedQuery({
        'villageid': villageId,
        'lgdcode': lgdCode,
        'reg_Id' :regId
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

}
