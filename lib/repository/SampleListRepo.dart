import 'dart:developer';

import 'package:jjm_wqmis/models/SampleListResponse.dart';
import 'package:jjm_wqmis/models/SampleResponse.dart';
import 'package:jjm_wqmis/providers/SampleListProvider.dart';

import '../services/BaseApiService.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class SampleListRepo{
  final BaseApiService _apiService = BaseApiService();

  Future<List<Samplelistresponse>> fetchSampleList(int regId, int page,String search, int cstatus, int sampleId) async {
    try {
      final String endpoint =
          '/api/apimobile/sampleList?reg_id=$regId&page=$page&Search=$search&cstatus=$cstatus&SampleID=$sampleId';

      final response = await _apiService.get(endpoint);

      log('API Response: $response');

      if (response is Map<String, dynamic> && response.containsKey('Result')) {
        print('Response success: ${response['Result']}');
        return (response['Result'] as List<dynamic>)
            .map((item) => Samplelistresponse.fromJson(item))
            .toList();
      } else {
        throw ApiException('API Error: $response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow; // Allows provider to handle the exception
    }
  }
}