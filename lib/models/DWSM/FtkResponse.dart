class FtkUpdateResponse {
  final int status;
  final String message;
  final dynamic result; // Can be `null` or another type depending on future responses

  FtkUpdateResponse({
    required this.status,
    required this.message,
    this.result,
  });

  factory FtkUpdateResponse.fromJson(Map<String, dynamic> json) {
    return FtkUpdateResponse(
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
