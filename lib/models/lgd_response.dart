class Lgdresponse {
  final String stateLgd;
  final String stateCode;
  final String stateName;
  final String districtLgd;
  final String districtCode;
  final String districtName;
  final String subDistrictLgd;
  final String subDistrictCode;
  final String subDistrictName;
  final String gpCode;
  final String? gpName;
  final String villageLgd;
  final String? villageCode;
  final String? villageName;
  final String uuid;

  Lgdresponse({
    required this.stateLgd,
    required this.stateCode,
    required this.stateName,
    required this.districtLgd,
    required this.districtCode,
    required this.districtName,
    required this.subDistrictLgd,
    required this.subDistrictCode,
    required this.subDistrictName,
    required this.gpCode,
    this.gpName,
    required this.villageLgd,
    this.villageCode,
    this.villageName,
    required this.uuid,
  });

  factory Lgdresponse.fromJson(Map<String, dynamic> json) {
    return Lgdresponse(
      stateLgd: json['state_lgd'] ?? '',
      stateCode: json['statecode'] ?? '',
      stateName: json['statename'] ?? '',
      districtLgd: json['district_lgd'] ?? '',
      districtCode: json['districtcode'] ?? '',
      districtName: json['districtname'] ?? '',
      subDistrictLgd: json['subdistrict_lgd'] ?? '',
      subDistrictCode: json['subdistrictcode'] ?? '',
      subDistrictName: json['subdistrictname'] ?? '',
      gpCode: json['gpcode'] ?? '',
      gpName: json['gpname'],
      villageLgd: json['village_lgd'] ?? '',
      villageCode: json['villagecode'],
      villageName: json['villagename'],
      uuid: json['uuid'] ?? '',
    );
  }

  static List<Lgdresponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Lgdresponse.fromJson(json)).toList();
  }
}
