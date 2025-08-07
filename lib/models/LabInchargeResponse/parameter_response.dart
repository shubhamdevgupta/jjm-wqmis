class Parameterresponse {
  final int parameterId;
  final String parameterName;
  final double publicRate;
  final double deptRate;
  final double comercialRate;
  final int labId;
  final String? token;

  Parameterresponse({
    required this.parameterId,
    required this.parameterName,
    required this.publicRate,
    required this.deptRate,
    required this.comercialRate,
    required this.labId,
    this.token,
  });

  /// Factory method to create an instance from a JSON object
  factory Parameterresponse.fromJson(Map<String, dynamic> json) {
    return Parameterresponse(
      parameterId: json['ParameterId'],
      parameterName: json['ParameterName'],
      publicRate: (json['public_rate'] as num).toDouble(),
      deptRate: (json['dept_rate'] as num).toDouble(),
      comercialRate: (json['comercial_rate'] as num).toDouble(),
      labId: json['lab_id'],
      token: json['Token'],
    );
  }

  /// Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ParameterId': parameterId,
      'ParameterName': parameterName,
      'public_rate': publicRate,
      'dept_rate': deptRate,
      'comercial_rate': comercialRate,
      'lab_id': labId,
      'Token': token,
    };
  }

  @override
  String toString() {
    return '$parameterId';
  }
}
