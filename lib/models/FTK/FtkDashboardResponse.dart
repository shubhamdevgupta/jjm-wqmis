class FtkDashboardResponse {
  final int totalSampleTested;
  final int status;
  final String message;

  FtkDashboardResponse({
    required this.totalSampleTested,
    required this.status,
    required this.message,
  });

  factory FtkDashboardResponse.fromJson(Map<String, dynamic> json) {
    return FtkDashboardResponse(
      totalSampleTested: json['TotalsampleTested'],
      status: json['Status'],
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TotalsampleTested': totalSampleTested,
      'Status': status,
      'Message': message,
    };
  }
}
