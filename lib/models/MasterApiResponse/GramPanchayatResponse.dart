class GramPanchayatApiResponse {
  final int status;
  final String message;
  final List<GramPanchayatresponse> result;

  GramPanchayatApiResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory GramPanchayatApiResponse.fromJson(Map<String, dynamic> json) {
    return GramPanchayatApiResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>)
          .map((item) => GramPanchayatresponse.fromJson(item))
          .toList(),
    );
  }
}

class GramPanchayatresponse {
  final String jjmPanchayatId;
  final String panchayatName;

  GramPanchayatresponse({
    required this.jjmPanchayatId,
    required this.panchayatName,
  });

  factory GramPanchayatresponse.fromJson(Map<String, dynamic> json) {
    return GramPanchayatresponse(
      jjmPanchayatId: json['JJM_PanchayatId'] ?? '',
      panchayatName: json['PanchayatName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JJM_PanchayatId': jjmPanchayatId,
      'PanchayatName': panchayatName,
    };
  }

  @override
  String toString() =>
      'GramPanchayatModel(id: $jjmPanchayatId, name: $panchayatName)';
}
