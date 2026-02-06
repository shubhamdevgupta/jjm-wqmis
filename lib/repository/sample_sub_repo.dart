import 'dart:convert';


import 'package:jjm_wqmis/models/FTK/sample_response.dart';
import 'package:jjm_wqmis/services/base_api_service.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';

class Samplesubrepo {
  final BaseApiService _apiService = BaseApiService();

  Future<Sampleresponse> sampleSubmit(
      int labId,
      int regId,
      int roleId,
      String sampleCollectionTime,
      int cat,
      int sampleSourceLocation,
      int stateId,
      int sourceDistrict,
      int sourceBlock,
      int sourceGp,
      int sourceVillage,
      int sourceHabitation,
      int sourceFilter,
      int schemeId,
      String otherSourceLocation,
      String sourceName,
      String latitude,
      String longitude,
      String sampleRemark,
      String ipAddress,
      String sampleTypeOther,
      int wtpId,
      int istreated,
      String testSelected,
      String sampleSubmitType,
      ) async {
    final requestData = jsonEncode(encryptDataClassBody({
      "Lab_id": labId,
      "Reg_Id": regId,
      "role_id": roleId,
      "sample_collection_time": sampleCollectionTime,
      "cat": cat,
      "sample_source_location": sampleSourceLocation,
      "StateId": stateId,
      "source_district": sourceDistrict,
      "source_block": sourceBlock,
      "source_gp": sourceGp,
      "source_village": sourceVillage,
      "source_habitation": sourceHabitation,
      "source_filter": sourceFilter,
      "SchemeId": schemeId,
      "Other_Source_location": otherSourceLocation,
      "SourceName": sourceName,
      "latitude": latitude,
      "longitude": longitude,
      "sample_remark": sampleRemark,
      "IpAddress": ipAddress,
      "sample_type_other": sampleTypeOther,
      "wtp_id": wtpId,
      "istreated":istreated,
      "test_selected": testSelected,
      "sample_submit_type": sampleSubmitType,
    }));

    try {
      final response = await _apiService.post('APIMobileA/add_sample', body: requestData);

      return Sampleresponse.fromJson(response);
    } catch (e,stackTrace) {
      GlobalExceptionHandler.handleException(e as Exception,stackTrace: stackTrace);
      rethrow;
    }
  }

}
