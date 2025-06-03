class FtkParameterResponse {
  final int status;
  final String message;
  final List<FtkParameter> result;

  FtkParameterResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory FtkParameterResponse.fromJson(Map<String, dynamic> json) {
    return FtkParameterResponse(
      status: json['Status'],
      message: json['Message'],
      result: (json['Result'] as List<dynamic>)
          .map((item) => FtkParameter.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'Status': status,
    'Message': message,
    'Result': result.map((e) => e.toJson()).toList(),
  };
}

class FtkParameter {
  final int parameterId;
  final String parameterName;
  final String measurementUnit;
  final String acceptableLimit;
  final String permissibleLimit;
  final String valueTypeValue;

  FtkParameter({
    required this.parameterId,
    required this.parameterName,
    required this.measurementUnit,
    required this.acceptableLimit,
    required this.permissibleLimit,
    required this.valueTypeValue,
  });

  factory FtkParameter.fromJson(Map<String, dynamic> json) {
    return FtkParameter(
      parameterId: json['parameter_id'],
      parameterName: json['parameter_name'],
      measurementUnit: json['MeasurementUnit'],
      acceptableLimit: json['Acceptablelimit'],
      permissibleLimit: json['Permissiblelimit']?.trim() ?? '',
      valueTypeValue: json['value_type_value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'parameter_id': parameterId,
    'parameter_name': parameterName,
    'MeasurementUnit': measurementUnit,
    'Acceptablelimit': acceptableLimit,
    'Permissiblelimit': permissibleLimit,
    'value_type_value': valueTypeValue,
  };
}
