import 'package:hive/hive.dart';

part 'VillageResponse.g.dart'; // 👈 Required for build_runner

@HiveType(typeId: 8)
class VillageApiResponse {
  @HiveField(0)
  final int status;
  @HiveField(1)
  final String message;
  @HiveField(2)
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

@HiveType(typeId: 9)
class Villageresponse {
  @HiveField(0)
  final String jjmVillageId;
  @HiveField(1)
  final String villageName;
  @HiveField(2)
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
