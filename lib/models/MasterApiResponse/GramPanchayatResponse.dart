import 'package:hive/hive.dart';

part 'GramPanchayatResponse.g.dart'; // 👈 Required for build_runner

@HiveType(typeId: 6)
class GramPanchayatApiResponse {
  @HiveField(0)
  final int status;
  @HiveField(1)
  final String message;
  @HiveField(2)
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

@HiveType(typeId: 7)
class GramPanchayatresponse {
  @HiveField(0)
  final String jjmPanchayatId;
  @HiveField(1)
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
