class VillageApiResponse {
  final int status;
  final String message;
  final List<Villageresponse> result;

  VillageApiResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory VillageApiResponse.fromJson(Map<String, dynamic> json) {
    return VillageApiResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>)
          .map((item) => Villageresponse.fromJson(item))
          .toList(),
    );
  }
}

class Villageresponse {
  final String jjmVillageId;
  final String villageName;
  final int flag;

  Villageresponse({
    required this.jjmVillageId,
    required this.villageName,
    required this.flag,
  });

  factory Villageresponse.fromJson(Map<String, dynamic> json) {
    return Villageresponse(
      jjmVillageId: json['JJM_VillageId'].toString(),
      villageName: json['VillageName'] ?? '',
      flag: json['Flag'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JJM_VillageId': jjmVillageId,
      'VillageName': villageName,
      'Flag': flag,
    };
  }

  @override
  String toString() =>
      'VillageModel(id: $jjmVillageId, name: $villageName, flag: $flag)';
}
