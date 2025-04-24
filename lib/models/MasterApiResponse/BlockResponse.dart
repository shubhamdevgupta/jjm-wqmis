class BlockApiResponse {
  final int status;
  final String message;
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

class BlockResponse {
  final String jjmBlockId;
  final String blockName;
  final String jjmDistrictId;
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
