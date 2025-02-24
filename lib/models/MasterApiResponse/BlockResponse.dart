class BlockResponse {
  final int jjmStateId;
  final int jjmDistrictId;
  final String? districtName;
  final String? stateName;
  final String jjmBlockId;
  final String blockName;

  BlockResponse({
    required this.jjmStateId,
    required this.jjmDistrictId,
    this.districtName,
    this.stateName,
    required this.jjmBlockId,
    required this.blockName,
  });

  factory BlockResponse.fromJson(Map<String, dynamic> json) {
    return BlockResponse(
      jjmStateId: json['JJM_StateId'] ?? 0,
      jjmDistrictId: json['JJM_DistrictId'] ?? 0,
      districtName: json['DistrictName'],
      stateName: json['StateName'],
      jjmBlockId: json['JJM_BlockId'] ?? '',
      blockName: json['BlockName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JJM_StateId': jjmStateId,
      'JJM_DistrictId': jjmDistrictId,
      'DistrictName': districtName,
      'StateName': stateName,
      'JJM_BlockId': jjmBlockId,
      'BlockName': blockName,
    };
  }
}
