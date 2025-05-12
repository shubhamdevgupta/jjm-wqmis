import 'package:hive/hive.dart';
part 'DistrictResponse.g.dart'; // 👈 Required for build_runner

@HiveType(typeId: 2)
class DistrictApiResponse {
  @HiveField(0)
  final int status;
  @HiveField(1)
  final String message;
  @HiveField(2)
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
@HiveType(typeId: 3)
class Districtresponse {
  @HiveField(0)
  final String jjmDistrictId;
  @HiveField(1)
  final String districtName;
  @HiveField(2)
  final String jjmStateId;
  @HiveField(3)
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
