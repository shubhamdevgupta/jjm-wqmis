class DashboardSchoolModel {
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
  final String? photo;
  final String? photoData;
  final String? fineYear;
  final String? remark;
  final double latitude;
  final double longitude;
  final int updatedBy;
  final int? createdBy;
  final String? ipAddress;
  final String institutionCategory;
  final String institutionSubCategory;
  final String category;
  final String schoolName;
  final int demonstrationType;

  DashboardSchoolModel({
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
    this.photo,
    this.photoData,
    this.fineYear,
    this.remark,
    required this.latitude,
    required this.longitude,
    required this.updatedBy,
    this.createdBy,
    this.ipAddress,
    required this.institutionCategory,
    required this.institutionSubCategory,
    required this.category,
    required this.schoolName,
    required this.demonstrationType,
  });

  factory DashboardSchoolModel.fromJson(Map<String, dynamic> json) {
    return DashboardSchoolModel(
      stateName: json['StateName'] ?? '',
      districtName: json['DistrictName'] ?? '',
      blockName: json['BlockName'] ?? '',
      panchayatName: json['PanchayatName'] ?? '',
      villageName: json['VillageName'] ?? '',
      userId: json['UserId'] ?? 0,
      stateId: json['StateId'] ?? 0,
      districtId: json['DistrictId'] ?? 0,
      blockId: json['BlockId'] ?? 0,
      panchayatId: json['PanchayatId'] ?? 0,
      villageId: json['VillageId'] ?? 0,
      schoolId: json['SchoolId'] ?? 0,
      photo: json['Photo'],
      photoData: json['Photo_data'],
      fineYear: json['FineYear'],
      remark: json['Remark'],
      latitude: (json['Latitude'] ?? 0).toDouble(),
      longitude: (json['Longitude'] ?? 0).toDouble(),
      updatedBy: json['Updated_by'] ?? 0,
      createdBy: json['Created_by'],
      ipAddress: json['IPAddress'],
      institutionCategory: json['InstitutionCategory'] ?? '',
      institutionSubCategory: json['InstitutionSubCategory'] ?? '',
      category: json['Category'] ?? '',
      schoolName: json['SchoolName'] ?? '',
      demonstrationType: json['DemonstrationType'] ?? 0,
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
      'Photo_data': photoData,
      'FineYear': fineYear,
      'Remark': remark,
      'Latitude': latitude,
      'Longitude': longitude,
      'Updated_by': updatedBy,
      'Created_by': createdBy,
      'IPAddress': ipAddress,
      'InstitutionCategory': institutionCategory,
      'InstitutionSubCategory': institutionSubCategory,
      'Category': category,
      'SchoolName': schoolName,
      'DemonstrationType': demonstrationType,
    };
  }
}
