class WtpLabResponse {
  final int status;
  final String message;
  final List<WtpLab> result;

  WtpLabResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory WtpLabResponse.fromJson(Map<String, dynamic> json) {
    return WtpLabResponse(
      status: json['Status'],
      message: json['Message'],
      result: (json['Result'] as List)
          .map((lab) => WtpLab.fromJson(lab))
          .toList(),
    );
  }
}

class WtpLab {
  final String labName;
  final String labId;

  WtpLab({
    required this.labName,
    required this.labId,
  });

  factory WtpLab.fromJson(Map<String, dynamic> json) {
    return WtpLab(
      labName: json['lab_name'],
      labId: json['lab_id'],
    );
  }
}
