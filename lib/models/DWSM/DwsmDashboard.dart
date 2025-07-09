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
  final String? stateName;
  final String? districtName;
  final String? blockName;
  final String? panchayatName;
  final String? villageName;
  final String? regId;
  final String? stateId;
  final String? districtId;
  final String? blockId;
  final String? panchayatId;
  final String? villageId;
  final String? schoolId;
  final String? photo;
  final String? photoData;
  final String? fineYear;
  final String? remark;
  final String? latitude;
  final String? longitude;
  final String? updatedBy;
  final String? createdBy;
  final String? ipAddress;
  final String? institutionCategory;
  final String? institutionSubCategory;
  final String? category;
  final String? schoolName;
  final String? demonstrationType;
  final String? createdOn;
  final String? page;
  final String? sort;
  final String? sortdir;
  final String? pageIndex;
  final String? pageSize;
  final String? total;

  Village({
    this.stateName,
    this.districtName,
    this.blockName,
    this.panchayatName,
    this.villageName,
    this.regId,
    this.stateId,
    this.districtId,
    this.blockId,
    this.panchayatId,
    this.villageId,
    this.schoolId,
    this.photo,
    this.photoData,
    this.fineYear,
    this.remark,
    this.latitude,
    this.longitude,
    this.updatedBy,
    this.createdBy,
    this.ipAddress,
    this.institutionCategory,
    this.institutionSubCategory,
    this.category,
    this.schoolName,
    this.demonstrationType,
    this.createdOn,
    this.page,
    this.sort,
    this.sortdir,
    this.pageIndex,
    this.pageSize,
    this.total,
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      stateName: json['StateName'],
      districtName: json['DistrictName'],
      blockName: json['BlockName'],
      panchayatName: json['PanchayatName'],
      villageName: json['VillageName'],
      regId: json['Reg_id'],
      stateId: json['StateId'],
      districtId: json['DistrictId'],
      blockId: json['BlockId'],
      panchayatId: json['PanchayatId'],
      villageId: json['VillageId'],
      schoolId: json['SchoolId'],
      photo: json['Photo'],
      photoData: json['Photo_data'],
      fineYear: json['FineYear'],
      remark: json['Remark'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      updatedBy: json['Updated_by'],
      createdBy: json['Created_by'],
      ipAddress: json['IPAddress'],
      institutionCategory: json['InstitutionCategory'],
      institutionSubCategory: json['InstitutionSubCategory'],
      category: json['Category'],
      schoolName: json['SchoolName'],
      demonstrationType: json['DemonstrationType'],
      createdOn: json['createdon'],
      page: json['page'],
      sort: json['sort'],
      sortdir: json['sortdir'],
      pageIndex: json['pageIndex'],
      pageSize: json['pageSize'],
      total: json['Total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StateName': stateName,
      'DistrictName': districtName,
      'BlockName': blockName,
      'PanchayatName': panchayatName,
      'VillageName': villageName,
      'Reg_id': regId,
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
      'createdon': createdOn,
      'page': page,
      'sort': sort,
      'sortdir': sortdir,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'Total': total,
    };
  }
}

