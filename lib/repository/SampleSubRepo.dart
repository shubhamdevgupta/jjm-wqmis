import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:jjm_wqmis/models/FTK/SampleResponse.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';

class Samplesubrepo {
  final BaseApiService _apiService = BaseApiService();

  Future<Sampleresponse> sampleSubmit(
      int labId,
      int regId,
      int roleId,
      String sampleCollectionTime,
      int cat,
      int sampleSourceLocation,
      int StateId,
      int sourceDistrict,
      int sourceBlock,
      int sourceGp,
      int sourceVillage,
      int sourceHabitation,
      int sourceFilter,
      int SchemeId,
      String otherSourceLocation,
      String SourceName,
      String latitude,
      String longitude,
      String sampleRemark,
      String IpAddress,
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
      "StateId": StateId,
      "source_district": sourceDistrict,
      "source_block": sourceBlock,
      "source_gp": sourceGp,
      "source_village": sourceVillage,
      "source_habitation": sourceHabitation,
      "source_filter": sourceFilter,
      "SchemeId": SchemeId,
      "Other_Source_location": otherSourceLocation,
      "SourceName": SourceName,
      "latitude": latitude,
      "longitude": longitude,
      "sample_remark": sampleRemark,
      "IpAddress": IpAddress,
      "sample_type_other": sampleTypeOther,
      "wtp_id": wtpId,
      "istreated":istreated,
      "test_selected": testSelected,
      "sample_submit_type": sampleSubmitType,
    }));

    debugPrint("Sample Submit Request: $requestData");

    try {
      final response = await _apiService.post('APIMobile/add_sample', body: requestData);


      return Sampleresponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}
