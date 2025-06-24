class FtkDataResponse {
  final int status;
  final String message;
  final List<FtkSample> result;

  FtkDataResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory FtkDataResponse.fromJson(Map<String, dynamic> json) {
    return FtkDataResponse(
      status: json['Status'],
      message: json['Message'],
      result: (json['Result'] as List)
          .map((e) => FtkSample.fromJson(e))
          .toList(),
    );
  }
}

class FtkSample {
  final String sampleId;
  final int schemeId;
  final String schemeName;
  final int roleId;
  final int sId;
  final int currentStatus;
  final int regId;
  final int cat;
  final String? sampleTypeOther;
  final String? otherSourceLocation;
  final int sampleSourceLocation;
  final DateTime? sampleCollectionTime;
  final DateTime? sampleTestingTime;
  final String sourceLatitude;
  final String sourceLongitude;
  final int sourceState;
  final int sourceDistrict;
  final int sourceBlock;
  final int sourceGp;
  final int sourceVillage;
  final int sourceHabitation;
  final String stateName;
  final String districtName;
  final String blockName;
  final String grampanchayat;
  final String villageName;
  final String habitation;
  final String? address;
  final String? remarks;
  final String enterBy;
  final String contaminatedStatus;

  FtkSample({
    required this.sampleId,
    required this.schemeId,
    required this.schemeName,
    required this.roleId,
    required this.sId,
    required this.currentStatus,
    required this.regId,
    required this.cat,
    this.sampleTypeOther,
    this.otherSourceLocation,
    required this.sampleSourceLocation,
    this.sampleCollectionTime,
    this.sampleTestingTime,
    required this.sourceLatitude,
    required this.sourceLongitude,
    required this.sourceState,
    required this.sourceDistrict,
    required this.sourceBlock,
    required this.sourceGp,
    required this.sourceVillage,
    required this.sourceHabitation,
    required this.stateName,
    required this.districtName,
    required this.blockName,
    required this.grampanchayat,
    required this.villageName,
    required this.habitation,
    this.address,
    this.remarks,
    required this.enterBy,
    required this.contaminatedStatus,
  });

  factory FtkSample.fromJson(Map<String, dynamic> json) {
    return FtkSample(
      sampleId: json['sample_id'],
      schemeId: json['SchemeId'],
      schemeName: json['SchemeName'],
      roleId: json['role_id'],
      sId: json['s_id'],
      currentStatus: json['current_status'],
      regId: json['Reg_Id'],
      cat: json['cat'],
      sampleTypeOther: json['sample_type_other'],
      otherSourceLocation: json['Other_Source_location'],
      sampleSourceLocation: json['sample_source_location'],
      sampleCollectionTime: DateTime.tryParse(json['sample_collection_time']),
      sampleTestingTime: DateTime.tryParse(json['sample_testing_time']),
      sourceLatitude: json['source_latitude'].toString(),
      sourceLongitude: json['source_longitude'].toString(),
      sourceState: json['source_state'],
      sourceDistrict: json['source_district'],
      sourceBlock: json['source_block'],
      sourceGp: json['source_gp'],
      sourceVillage: json['source_village'],
      sourceHabitation: json['source_habitation'],
      stateName: json['StateName'],
      districtName: json['DistrictName'],
      blockName: json['BlockName'],
      grampanchayat: json['Grampanchayat'],
      villageName: json['VillageName'],
      habitation: json['Habitation'],
      address: json['address'],
      remarks: json['remarks'],
      enterBy: json['enter_by'],
      contaminatedStatus: json['Contaminated_status'],
    );
  }
}

