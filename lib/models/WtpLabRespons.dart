class WtpLabResponse {
  final String labName;
  final String labId;

  WtpLabResponse({
    required this.labName,
    required this.labId,
  });

  // Factory constructor to parse JSON data
  factory WtpLabResponse.fromJson(Map<String, dynamic> json) {
    return WtpLabResponse(
      labName: json['lab_name'] ?? '',
      labId: json['lab_id'] ?? '',
    );
  }
}
