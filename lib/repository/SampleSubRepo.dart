import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';

import '../models/SampleResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class Samplesubrepo {
  final BaseApiService _apiService = BaseApiService();

  Future<Sampleresponse> sampleSubmit(
      int Lab_id,
      int Reg_Id,
      int role_id,
      String sample_collection_time,
      int cat,
      int sample_source_location,
      int StateId,
      int source_district,
      int source_block,
      int source_gp,
      int source_village,
      int source_habitation,
      int source_filter,
      int SchemeId,
      String Other_Source_location,
      String SourceName,
      String latitude,
      String longitude,
      String sample_remark,
      String IpAddress,
      String sample_type_other,
      int wtp_id,
      String test_selected,
      String sample_submit_type,
      ) async {
    final requestData = jsonEncode({
      "Lab_id": Lab_id,
      "Reg_Id": Reg_Id,
      "role_id": role_id,
      "sample_collection_time": sample_collection_time,
      "cat": cat,
      "sample_source_location": sample_source_location,
      "StateId": StateId,
      "source_district": source_district,
      "source_block": source_block,
      "source_gp": source_gp,
      "source_village": source_village,
      "source_habitation": source_habitation,
      "source_filter": source_filter,
      "SchemeId": SchemeId,
      "Other_Source_location": Other_Source_location,
      "SourceName": SourceName,
      "latitude": latitude,
      "longitude": longitude,
      "sample_remark": sample_remark,
      "IpAddress": IpAddress,
      "sample_type_other": sample_type_other,
      "wtp_id": wtp_id,
      "test_selected": test_selected,
      "sample_submit_type": sample_submit_type,
    });

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
