class ValidateVillageResponse {
  final int status;
  final String message;

  ValidateVillageResponse({
    required this.status,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory ValidateVillageResponse.fromJson(Map<String, dynamic> json) {
    return ValidateVillageResponse(
      status: json['Status'] as int,
      message: json['Message'] as String,
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
    };
  }
}
