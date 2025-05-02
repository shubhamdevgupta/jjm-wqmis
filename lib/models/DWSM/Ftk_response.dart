class FTKResponse {
  final int status;
  final String message;
  final dynamic result; // Use specific type if you know the structure of 'Result'

  FTKResponse({
    required this.status,
    required this.message,
    this.result,
  });

  factory FTKResponse.fromJson(Map<String, dynamic> json) {
    return FTKResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
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
