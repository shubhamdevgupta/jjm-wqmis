import 'dart:developer';

import 'package:jjm_wqmis/models/SampleListResponse.dart';
import 'package:jjm_wqmis/models/SampleResponse.dart';
import 'package:jjm_wqmis/providers/SampleListProvider.dart';

import '../services/BaseApiService.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class SampleListRepo{
  final BaseApiService _apiService = BaseApiService();

  Future<Samplelistresponse> fetchSampleList(int regId, int page, String search, int cstatus, String sampleId, int stateid, int districtid, int blockid, int gpid, int villageid) async {
    try {
      final String endpoint = '/apimobile/sampleList?reg_id=$regId&page=$page&Search=$search&cstatus=$cstatus&SampleID=$sampleId&stateid=$stateid&districtid=$districtid&blockid=$blockid&gpid=$gpid&villageid=$villageid';

      final response = await _apiService.get(endpoint);

      log('API Response: $response');

      if (response is Map<String, dynamic> && response.containsKey('Result')) {
        print('Response success: ${response['Result']}');

        // ✅ Ensure we return only one `Samplelistresponse`
        return Samplelistresponse.fromJson(response);
      } else {
        throw ApiException('API Error: $response');
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


}