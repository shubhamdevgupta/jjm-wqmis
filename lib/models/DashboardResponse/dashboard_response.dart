class Dashboardresponse {
  final int totalSamplesSubmitted;
  final int samplesPhysicallySubmitted;
  final int totalSamplesTested;
  final int totalRetest;
  final int status;
  final String? message;

  Dashboardresponse({
    required this.totalSamplesSubmitted,
    required this.samplesPhysicallySubmitted,
    required this.totalSamplesTested,
    required this.totalRetest,
    required this.status,
    this.message,
  });

  // Factory constructor to create an instance from JSON
  factory Dashboardresponse.fromJson(Map<String, dynamic> json) {
    return Dashboardresponse(
      totalSamplesSubmitted: json['Total_Samples_Submitted'] ?? 0,
      samplesPhysicallySubmitted: json['Samples_Physically_Submitted'] ?? 0,
      totalSamplesTested: json['TotalSamplesTested'] ?? 0,
      totalRetest: json['TotalRetest'] ?? 0,
      status: json['Status'] ?? 0,
      message: json['Message'], // Can be null
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Total_Samples_Submitted': totalSamplesSubmitted,
      'Samples_Physically_Submitted': samplesPhysicallySubmitted,
      'TotalSamplesTested': totalSamplesTested,
      'TotalRetest': totalRetest,
      'Status': status,
      'Message': message,
    };
  }
}
