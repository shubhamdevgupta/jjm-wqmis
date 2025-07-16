
import 'package:jjm_wqmis/models/base_response.dart';
import 'package:jjm_wqmis/models/sample_list_response.dart';

import 'package:jjm_wqmis/services/base_api_service.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';

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
      final query = _apiService.buildEncryptedQuery({
        'reg_id': regId,
        'page': page,
        'Search': search,
        'cstatus': cstatus,
        'SampleID': sampleId,
        'stateid': stateid,
        'districtid': districtid,
        'blockid': blockid,
        'gpid': gpid,
        'villageid': villageid,
      });


      final String endpoint = '/apimobileA/sampleList?$query';

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

      final query = _apiService.buildEncryptedQuery({
        's_id': encryptedSid,
        'userid': userId,
        'ip': deviceId,
      });

      final String urlEndpoint = '/APIMobileA/remove_sample?$query';

      final response = await _apiService.get(urlEndpoint);

      return BaseResponseModel<dynamic>.fromJson(response, (json) => Sample.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}
