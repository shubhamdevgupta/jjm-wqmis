class DemonstrationResponse {
  final int status;
  final String message;
  final dynamic result; // Can be `null` or another type depending on future responses

  DemonstrationResponse({
    required this.status,
    required this.message,
    this.result,
  });

  factory DemonstrationResponse.fromJson(Map<String, dynamic> json) {
    return DemonstrationResponse(
      status: json['Status'] as int,
      message: json['Message'] as String,
      result: json['Result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Result': result,
    };
  }
}
