class Parameterresponse {
  final int stateId;
  final int userId;
  final int testSelectedCheck;
  final int parameterId;
  final int? parameterIdAlt;
  final String parameterName;
  final double publicRate;
  final double deptRate;
  final double comercialRate;
  final double mobileRate;
  final String? ip;
  final String? createdBy;
  final String? updatedBy;
  final String? createdOn;
  final String? updatedOn;
  final String? result;
  final String? parameterListData;
  final int pageNo;
  final String? sortBy;
  final int? pageSize;
  final bool? isAsc;
  final String? search;
  final int rowNo;
  final int total;
  final int labId;
  final double testAmount;
  final bool? isUpdatedRate;

  Parameterresponse({
    required this.stateId,
    required this.userId,
    required this.testSelectedCheck,
    required this.parameterId,
     this.parameterIdAlt,
    required this.parameterName,
    required this.publicRate,
    required this.deptRate,
    required this.comercialRate,
    required this.mobileRate,
    this.ip,
    this.createdBy,
    this.updatedBy,
    this.createdOn,
    this.updatedOn,
    this.result,
    this.parameterListData,
    required this.pageNo,
    this.sortBy,
    this.pageSize,
    this.isAsc,
    this.search,
    required this.rowNo,
    required this.total,
    required this.labId,
    required this.testAmount,
    this.isUpdatedRate,
  });

  factory Parameterresponse.fromJson(Map<String, dynamic> json) {
    return Parameterresponse(
      stateId: json['state_id'],
      userId: json['User_id'],
      testSelectedCheck: json['test_selectedcheck'],
      parameterId: json['parameter_id'],
      parameterIdAlt: json['ParameterId'],
      parameterName: json['ParameterName'],
      publicRate: (json['public_rate'] as num).toDouble(),
      deptRate: (json['dept_rate'] as num).toDouble(),
      comercialRate: (json['comercial_rate'] as num).toDouble(),
      mobileRate: (json['mobile_rate'] as num).toDouble(),
      ip: json['ip'],
      createdBy: json['createdby'],
      updatedBy: json['updatedby'],
      createdOn: json['createdon'],
      updatedOn: json['updatedon'],
      result: json['Result'],
      parameterListData: json['ParameterListData'],
      pageNo: json['PageNo'],
      sortBy: json['sortBy'],
      pageSize: json['PageSize'],
      isAsc: json['isAsc'],
      search: json['Search'],
      rowNo: json['RowNo'],
      total: json['Total'],
      labId: json['lab_id'],
      testAmount: (json['test_amount'] as num).toDouble(),
      isUpdatedRate: json['is_updated_rate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state_id': stateId,
      'User_id': userId,
      'test_selectedcheck': testSelectedCheck,
      'parameter_id': parameterId,
      'ParameterId': parameterIdAlt,
      'ParameterName': parameterName,
      'public_rate': publicRate,
      'dept_rate': deptRate,
      'comercial_rate': comercialRate,
      'mobile_rate': mobileRate,
      'ip': ip,
      'createdby': createdBy,
      'updatedby': updatedBy,
      'createdon': createdOn,
      'updatedon': updatedOn,
      'Result': result,
      'ParameterListData': parameterListData,
      'PageNo': pageNo,
      'sortBy': sortBy,
      'PageSize': pageSize,
      'isAsc': isAsc,
      'Search': search,
      'RowNo': rowNo,
      'Total': total,
      'lab_id': labId,
      'test_amount': testAmount,
      'is_updated_rate': isUpdatedRate,
    };
  }

  @override
  String toString() {
    return '$parameterIdAlt';
  }
}

List<Parameterresponse> parseWaterTestParameters(List<dynamic> jsonList) {
  return jsonList.map((json) => Parameterresponse.fromJson(json)).toList();
}
