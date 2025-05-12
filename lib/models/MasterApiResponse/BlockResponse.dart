import 'package:hive/hive.dart';
part 'BlockResponse.g.dart'; // 👈 Required for build_runner

@HiveType(typeId: 4)
class BlockApiResponse {
  @HiveField(0)
  final int status;
  @HiveField(1)
  final String message;
  @HiveField(2)
  final List<BlockResponse> result;

  BlockApiResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory BlockApiResponse.fromJson(Map<String, dynamic> json) {
    return BlockApiResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>)
          .map((item) => BlockResponse.fromJson(item))
          .toList(),
    );
  }
}
@HiveType(typeId: 5)
class BlockResponse {
  @HiveField(0)
  final String jjmBlockId;
  @HiveField(1)
  final String blockName;
  @HiveField(2)
  final String jjmDistrictId;
  @HiveField(3)
  final String? districtName;

  BlockResponse({
    required this.jjmBlockId,
    required this.blockName,
    required this.jjmDistrictId,
    this.districtName,
  });

  factory BlockResponse.fromJson(Map<String, dynamic> json) {
    return BlockResponse(
      jjmBlockId: json['JJM_BlockId'] ?? '',
      blockName: json['BlockName'] ?? '',
      jjmDistrictId: json['JJM_DistrictId'].toString(),
      districtName: json['DistrictName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JJM_BlockId': jjmBlockId,
      'BlockName': blockName,
      'JJM_DistrictId': jjmDistrictId,
      'DistrictName': districtName,
    };
  }

  @override
  String toString() =>
      'BlockModel(id: $jjmBlockId, name: $blockName, districtId: $jjmDistrictId)';
}
