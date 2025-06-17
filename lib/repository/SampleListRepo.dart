
import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/SampleListResponse.dart';

import 'package:jjm_wqmis/services/BaseApiService.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';

class SampleListRepo {
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<Sample>> fetchSampleList(
      int regId,
      int page,
      String search,
      int cstatus,
      String sampleId,
      int stateid,
      int districtid,
      int blockid,
      int gpid,
      int villageid) async {
    try {
      final String endpoint = '/apimobile/sampleList?reg_id=$regId&page=$page&Search=$search&cstatus=$cstatus&SampleID=$sampleId&stateid=$stateid&districtid=$districtid&blockid=$blockid&gpid=$gpid&villageid=$villageid';

      final response = await _apiService.get(endpoint);

      return BaseResponseModel<Sample>.fromJson(
          response, (json) => Sample.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<BaseResponseModel<dynamic>> deleteSample(String encryptedSid, String? userId, String deviceId) async {
    try {
      final String urlEndpoint = '/APIMobile/remove_sample?s_id=$encryptedSid&userid=$userId&ip=$deviceId';

      final response = await _apiService.get(urlEndpoint);

      return BaseResponseModel<dynamic>.fromJson(response, (json) => Sample.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}
