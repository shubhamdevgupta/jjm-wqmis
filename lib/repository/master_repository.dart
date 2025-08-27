
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/database/Dao/watersourcefilterDao.dart';
import 'package:jjm_wqmis/database/database.dart';
import 'package:jjm_wqmis/models/MasterVillageData.dart';
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
import 'package:jjm_wqmis/utils/custom_screen/custom_exception.dart';
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
      int regId,
      ) async {
    try {
      final query = _apiService.buildEncryptedQuery({
        'stateid': stateId,
        'districtid': districtId,
        'villageid': villageId,
        'habitationid': habitationId,
        'filter': filter,
        'reg_Id': regId,
      });

      try {
        await _apiService.checkConnectivity();

        // ✅ Online → API
        final json = await _apiService.get('/apimasterA/getScheme?$query');

        log("📡 FetchSchemes: Got data from API");

        if (json['status'] == 1 && json['result'] != null) {
          final list = (json['result'] as List).map((e) => SchemeResponse.fromJson(e)).toList();

          final db = await AppDatabase.getDatabase();
          await db.schemeDao.insertAll(list);

          log("💾 Schemes saved to local DB: ${list.length} items");
        }

        return BaseResponseModel<SchemeResponse>.fromJson(json, (j) => SchemeResponse.fromJson(j),);

      } on NetworkException {
        // ❌ Offline → DB
        final db = await AppDatabase.getDatabase();
        final local = await db.schemeDao.getSchemesByVillageAndSource(
          int.parse(villageId),
          int.parse(filter),
        );

        log("📴 FetchSchemes: No internet → fetched ${local.length} schemes from DB");

        return BaseResponseModel<SchemeResponse>(
          status: 1,
          message: "Fetched from local database",
          result: local,
        );
      }
    } catch (e, stack) {
      if (e is Exception) {
        GlobalExceptionHandler.handleException(e);
      } else {
        debugPrint("Non-Exception error: $e");
        debugPrintStack(stackTrace: stack);
      }
      rethrow;
    }
  }





 /* Future<BaseResponseModel<Watersourcefilterresponse>> fetchWaterSourceFilterList(int regId) async {
    try {
      final query = _apiService.buildEncryptedQuery({
        'reg_Id': regId,
      });

      try {
        // ✅ Check connectivity
        await _apiService.checkConnectivity();

        // ✅ Online → API
        final response = await _apiService.get('/apimasterA/Get_water_source_filter?$query');
        log("📡 FetchWaterSourceFilterList: Got data from API");

        if (response['Status'] == 1 && response['Result'] != null) {
          // Convert API response → model
          final apiList = (response['Result'] as List)
              .map((e) => Watersourcefilterresponse.fromJson(e))
              .toList();

          // Convert to DB entity
          final dbList = apiList.map((e) => e.toEntity()).toList();

          // Save in DB
          final db = await AppDatabase.getDatabase();
          await db.waterSourceFilterDao.insertAll(dbList);

          log("💾 WaterSourceFilter saved to local DB: ${dbList.length} items");
        }

        // Return response model
        return BaseResponseModel<Watersourcefilterresponse>.fromJson(
          response,
              (json) => Watersourcefilterresponse.fromJson(json),
        );

      } on NetworkException {
        // ❌ Offline → DB
        final db = await AppDatabase.getDatabase();
        final local = await db.waterSourceFilterDao.getAll();

        log("📴 FetchWaterSourceFilterList: No internet → fetched ${local.length} items from DB");

        // Convert DB entities back to API model
        final offlineList = local.map((e) => Watersourcefilterresponse(
          id: e.id,
          sourceType: e.sourceType,
        )).toList();

        return BaseResponseModel<Watersourcefilterresponse>(
          status: 1,
          message: "Fetched from local database",
          result: offlineList,
        );
      }

    } catch (e, stack) {
      if (e is Exception) {
        GlobalExceptionHandler.handleException(e);
      } else {
        debugPrint("Non-Exception error: $e");
        debugPrintStack(stackTrace: stack);
      }
      rethrow;
    }
  }*/

  Future<BaseResponseModel<Watersourcefilterresponse>> fetchWaterSourceFilterList(int regId) async {
    try {
      // 📦 Always fetch from DB
      final db = await AppDatabase.getDatabase();
      final local = await db.waterSourceFilterDao.getAll();

      log("📴 FetchWaterSourceFilterList: fetched ${local.length} items from DB");

      // Convert DB entities back to API model
      final offlineList = local.map((e) => Watersourcefilterresponse(
        id: e.id,
        sourceType: e.sourceType,
      )).toList();

      return BaseResponseModel<Watersourcefilterresponse>(
        status: 1,
        message: "Fetched from local database",
        result: offlineList,
      );

    } catch (e, stack) {
      if (e is Exception) {
        GlobalExceptionHandler.handleException(e);
      } else {
        debugPrint("Non-Exception error: $e");
        debugPrintStack(stackTrace: stack);
      }
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

  Future<MasterVillageData> masterVillageData(
      String stateId, String districtId,String villageId) async {
    try {

      final response = await _apiService.get(
        'APIMobile/GetOffLineData?stateid=$stateId&districtid=$districtId&villageid=$villageId',
      );

      return MasterVillageData.fromJson(response);

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Propagate the exception for further handling
    }
  }
}
