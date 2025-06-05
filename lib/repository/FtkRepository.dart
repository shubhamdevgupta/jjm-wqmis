import 'package:jjm_wqmis/models/BaseResponse.dart';
import 'package:jjm_wqmis/models/FTK/FtkParameterResponse.dart';
import 'package:jjm_wqmis/services/BaseApiService.dart';
import 'package:jjm_wqmis/utils/GlobalExceptionHandler.dart';

class FtkRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<BaseResponseModel<FtkParameter>> fetchParameterList(
      int stateId, int districtId) async {
    try {
      final response = await _apiService.get(
          'APIMaster/GetParameterList?StateId=$stateId&DistrictId=$districtId');
      print("RRRRR_----$response");
      return BaseResponseModel<FtkParameter>.fromJson(
          response, (json) => FtkParameter.fromJson(json));
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}
