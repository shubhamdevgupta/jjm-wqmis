class VillageResponse {
  final int jjmVillageId;
  final String villageName;

  VillageResponse({
    required this.jjmVillageId,
    required this.villageName,
  });

  factory VillageResponse.fromJson(Map<String, dynamic> json) {
    return VillageResponse(
      jjmVillageId: json['JJM_VillageId'] ?? 0,
      villageName: json['VillageName'] ?? '--Select--',
    );
  }
}
