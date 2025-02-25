class Villageresponse {
  final int jjmVillageId;
  final String villageName;

  Villageresponse({
    required this.jjmVillageId,
    required this.villageName,
  });

  factory Villageresponse.fromJson(Map<String, dynamic> json) {
    return Villageresponse(
      jjmVillageId: json['JJM_VillageId'],
      villageName: json['VillageName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JJM_VillageId': jjmVillageId,
      'VillageName': villageName,
    };
  }
}
