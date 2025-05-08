class Dwsmdashboard {
  final int status;
  final String message;
  final List<Village> result;

  Dwsmdashboard({
    required this.status,
    required this.message,
    required this.result,
  });

  factory Dwsmdashboard.fromJson(Map<String, dynamic> json) {
    return Dwsmdashboard(
      status: json['Status'],
      message: json['Message'],
      result: List<Village>.from(json['Result'].map((x) => Village.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Result': result.map((x) => x.toJson()).toList(),
    };
  }
}

class Village {
  final String stateName;
  final String districtName;
  final String blockName;
  final String panchayatName;
  final String villageName;
  final int userId;
  final int stateId;
  final int districtId;
  final int blockId;
  final int panchayatId;
  final int villageId;
  final int schoolId;
  final String photo;
  final String InstitutionCategory;
  final String InstitutionSubCategory;

  Village({
    required this.stateName,
    required this.districtName,
    required this.blockName,
    required this.panchayatName,
    required this.villageName,
    required this.userId,
    required this.stateId,
    required this.districtId,
    required this.blockId,
    required this.panchayatId,
    required this.villageId,
    required this.schoolId,
    required this.photo,
    required this.InstitutionCategory,
    required this.InstitutionSubCategory
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      stateName: json['StateName'],
      districtName: json['DistrictName'],
      blockName: json['BlockName'],
      panchayatName: json['PanchayatName'],
      villageName: json['VillageName'],
      userId: json['UserId'],
      stateId: json['StateId'],
      districtId: json['DistrictId'],
      blockId: json['BlockId'],
      panchayatId: json['PanchayatId'],
      villageId: json['VillageId'],
      schoolId: json['SchoolId'],
      photo: json['Photo'],
      InstitutionCategory: json['InstitutionCategory'],
      InstitutionSubCategory: json['InstitutionSubCategory'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StateName': stateName,
      'DistrictName': districtName,
      'BlockName': blockName,
      'PanchayatName': panchayatName,
      'VillageName': villageName,
      'UserId': userId,
      'StateId': stateId,
      'DistrictId': districtId,
      'BlockId': blockId,
      'PanchayatId': panchayatId,
      'VillageId': villageId,
      'SchoolId': schoolId,
      'Photo': photo,
      'InstitutionCategory': InstitutionCategory,
      'InstitutionSubCategory': InstitutionSubCategory,
    };
  }
}
