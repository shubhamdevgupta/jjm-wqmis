import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/DWSM/SchoolinfoResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class FTKRepository {
  final String _baseUrl =
      "https://ejalshakti.gov.in/wqmis/API/APIMobile/FTK_Demonstrated";
  final BaseApiService _apiService = BaseApiService();

  Future<http.Response> submitFTKData({
    required int userId,
    required int schoolId,
    required int stateId,
    required String photoBase64,
    required String fineYear,
    required String remark,
    required String latitude,
    required String longitude,
    required String ipAddress,
  }) async {
    final Map<String, dynamic> requestBody = {
      "UserId": userId,
      "SchoolId": schoolId,
      "StateId": stateId,
      "Photo": photoBase64,
      "FineYear": fineYear,
      "Remark": remark,
      "Latitude": latitude,
      "Longitude": longitude,
      "IPAddress": ipAddress,
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    // 🖨️ Debug Print
    print("Status ----Code: ${response.statusCode}");
    print("Response Body111: ${response.body}");

    return response;
  }


  Future<SchoolinfoResponse> fetchSchoolInfo(int Stateid, int Districtid,
      int Blockid, int Gpid, int Villageid, int type) async {
    try {
      final response = await _apiService.get(
          'ApiMaster/GetSchoolAwcs?stateid=$Stateid&districtid=$Districtid&blockid=$Blockid&gpid=$Gpid&villageid=$Villageid&type=$type');
      print("RRRRR_----${response}");
      return SchoolinfoResponse.fromJson(response); // Directly pass response

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}
