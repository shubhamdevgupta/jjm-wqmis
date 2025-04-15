import 'dart:convert';

class Sampleresponse {
  final int status;
  final String message;
  final String sampleId;

  Sampleresponse({
    required this.status,
    required this.message,
    required this.sampleId,
  });

  // Factory method to create an instance from JSON
  factory Sampleresponse.fromJson(Map<String, dynamic> json) {
    return Sampleresponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      sampleId: json['sampleId'] ?? '',
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'sampleId': sampleId,
    };
  }
}


