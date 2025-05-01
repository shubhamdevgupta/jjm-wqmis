import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/DWSM/DwsmDashboard.dart';

import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class DwsmRepository{
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<Village>> fetchDemonstartionList(
      int StateId, int DistrictId, String FineYear) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('APIMobile/FTK_DemonstratedList',
        body: jsonEncode({
          'StateId': StateId,
          'DistrictId': DistrictId,
          'FineYear': FineYear,
        }),
      );
      return BaseResponseModel<Village>.fromJson(response,(json)=> Village.fromJson(json));

    } catch (e) {
      debugPrint('Error in fetchDemonstartionList: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}