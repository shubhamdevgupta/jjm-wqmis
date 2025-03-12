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

// Example usage
void main() {
  String jsonResponse = '''
  {
      "Status": 1,
      "Message": "Sample test has been submitted successfully. (Sample Id - U1151455S5)",
      "sampleId": "U1151455S5"
  }
  ''';

  Map<String, dynamic> jsonMap = json.decode(jsonResponse);
  Sampleresponse response = Sampleresponse.fromJson(jsonMap);

  print(response.message);  // Output: Sample test has been submitted successfully. (Sample Id - U1151455S5)
  print(response.sampleId); // Output: U1151455S5
}
