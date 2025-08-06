class ParameterModel {
  final int stateId;
  final int parameterId;
  final String labName;
  final int labId;
  final int isWtp;
  final int deptRate;
  final String parameterName;

  ParameterModel({
    required this.stateId,
    required this.parameterId,
    required this.labName,
    required this.labId,
    required this.isWtp,
    required this.deptRate,
    required this.parameterName,
  });

  factory ParameterModel.fromJson(Map<String, dynamic> json) {
    return ParameterModel(
      stateId: json['stateid'],
      parameterId: json['ParameterId'],
      labName: json['lab_name'],
      labId: json['lab_id'],
      isWtp: json['is_wtp'],
      deptRate: json['dept_rate'],
      parameterName: json['ParameterName'],
    );
  }
}
