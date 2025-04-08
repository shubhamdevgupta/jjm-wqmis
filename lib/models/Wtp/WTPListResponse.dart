// Model for the entire response
class WtpResponse {
  final int status;
  final String message;
  final List<Wtp> result;

  WtpResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  // Factory method to parse JSON into the WtpResponse object
  factory WtpResponse.fromJson(Map<String, dynamic> json) {
    return WtpResponse(
      status: json['Status'],
      message: json['Message'],
      result: (json['Result'] as List).map((item) => Wtp.fromJson(item)).toList(),
    );
  }

  // Convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Result': result.map((item) => item.toJson()).toList(),
    };
  }
}

// Model for individual WTP objects
class Wtp {
  final String wtpName;
  final String wtpId;

  Wtp({
    required this.wtpName,
    required this.wtpId,
  });

  // Factory method to parse JSON into the Wtp object
  factory Wtp.fromJson(Map<String, dynamic> json) {
    return Wtp(
      wtpName: json['wtp_name'] ?? '',
      wtpId: json['wtp_id'] ?? '',
    );
  }

  // Convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'wtp_name': wtpName,
      'wtp_id': wtpId,
    };
  }
}