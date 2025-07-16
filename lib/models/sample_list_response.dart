class Samplelistresponse {
  final int status;
  final String message;
  final List<Sample> result;

  Samplelistresponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory Samplelistresponse.fromJson(Map<String, dynamic> json) {
    return Samplelistresponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>?)
          ?.map((item) => Sample.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class Sample {
  final int schemeId;
  final String? schemeName;
  final String? sourceName;
  final int ftkSId;
  final int sId;
  final int roleId;
  final int stateId;
  final int districtId;
  final int blockId;
  final int gramPanchayatId;
  final int villageId;
  final int habitationId;
  final String? labId;
  final String? labName;
  final String? stateName;
  final String? districtName;
  final String? blockName;
  final String? gramPanchayatName;
  final String? villageName;
  final String? habitationName;
  final int rowNo;
  final int total;
  final int pageNo;
  final String? sortBy;
  final int? pageSize;
  final bool? isAsc;
  final String? search;
  final int regId;
  final String? sampleCollectionTime;
  final int currentStatus;
  final String? sampleReceivedTime;
  final String? dateOfResultAvailability;
  final String? testResult;
  final String? sampleId;
  final String? sampleSourceName;
  final String? reportRefuseRemark;

  Sample({
    required this.schemeId,
    required this.schemeName,
    required this.sourceName,
    required this.ftkSId,
    required this.sId,
    required this.roleId,
    required this.stateId,
    required this.districtId,
    required this.blockId,
    required this.gramPanchayatId,
    required this.villageId,
    required this.habitationId,
    required this.labId,
    required this.labName,
    required this.stateName,
    required this.districtName,
    required this.blockName,
    required this.gramPanchayatName,
    required this.villageName,
    required this.habitationName,
    required this.rowNo,
    required this.total,
    required this.pageNo,
    required this.sortBy,
    required this.pageSize,
    required this.isAsc,
    required this.search,
    required this.regId,
    required this.sampleCollectionTime,
    required this.currentStatus,
    required this.sampleReceivedTime,
    required this.dateOfResultAvailability,
    required this.testResult,
    required this.sampleId,
    required this.sampleSourceName,
    required this.reportRefuseRemark,
  });

  factory Sample.fromJson(Map<String, dynamic> json) {
    return Sample(
      schemeId: json['SchemeId'] ?? 0,
      schemeName: json['SchemeName'],
      sourceName: json['SourceName'],
      ftkSId: json['ftk_s_id'] ?? 0,
      sId: json['s_id'] ?? 0,
      roleId: json['role_id'] ?? 0,
      stateId: json['StateId'] ?? 0,
      districtId: json['DistrictId'] ?? 0,
      blockId: json['BlockId'] ?? 0,
      gramPanchayatId: json['GramPanchayatId'] ?? 0,
      villageId: json['VillageId'] ?? 0,
      habitationId: json['habitaionId'] ?? 0,
      labId: json['lab_id'],
      labName: json['lab_name'],
      stateName: json['StateName'],
      districtName: json['DistrictName'],
      blockName: json['BlockName'],
      gramPanchayatName: json['GramPanchayatName'],
      villageName: json['VillageName'],
      habitationName: json['HabitationName'],
      rowNo: json['RowNo'] ?? 0,
      total: json['Total'] ?? 0,
      pageNo: json['PageNo'] ?? 0,
      sortBy: json['sortBy'],
      pageSize: json['PageSize'],
      isAsc: json['isAsc'],
      search: json['Search'],
      regId: json['Reg_Id'] ?? 0,
      sampleCollectionTime: json['sample_collection_time'],
      currentStatus: json['current_status'] ?? 0,
      sampleReceivedTime: json['sample_received_time'],
      dateOfResultAvailability: json['date_of_result_availability'],
      testResult: json['test_result'],
      sampleId: json['sample_id'],
      sampleSourceName: json['sample_sourceName'],
      reportRefuseRemark: json['s_report_refuse_remark'],
    );
  }
}
