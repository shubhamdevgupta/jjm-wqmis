class DistrictApiResponse {
  final int status;
  final String message;
  final List<Districtresponse> result;

  DistrictApiResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory DistrictApiResponse.fromJson(Map<String, dynamic> json) {
    return DistrictApiResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>)
          .map((item) => Districtresponse.fromJson(item))
          .toList(),
    );
  }
}

class Districtresponse {
  final String jjmDistrictId;
  final String districtName;
  final String jjmStateId;
  final String? stateName;

  Districtresponse({
    required this.jjmDistrictId,
    required this.districtName,
    required this.jjmStateId,
    this.stateName,
  });

  factory Districtresponse.fromJson(Map<String, dynamic> json) {
    return Districtresponse(
      jjmDistrictId: json['JJM_DistrictId'] ?? '',
      districtName: json['DistrictName'] ?? '',
      jjmStateId: json['JJM_StateId'].toString(),
      stateName: json['StateName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JJM_DistrictId': jjmDistrictId,
      'DistrictName': districtName,
      'JJM_StateId': jjmStateId,
      'StateName': stateName,
    };
  }

  @override
  String toString() =>
      'DistrictModel(id: $jjmDistrictId, name: $districtName, stateId: $jjmStateId)';
}
