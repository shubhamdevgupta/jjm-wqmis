class FtkDashboardResponse {
  final int totalSampleTested;
  final int totalSourceScheme;
  final int totalStorageStructure;
  final int totalHhScAwc;
  final int totalHandpumpsOtherPrivateSource;
  final int status;
  final String message;

  FtkDashboardResponse({
    required this.totalSampleTested,
    required this.totalSourceScheme,
    required this.totalStorageStructure,
    required this.totalHhScAwc,
    required this.totalHandpumpsOtherPrivateSource,
    required this.status,
    required this.message,
  });

  factory FtkDashboardResponse.fromJson(Map<String, dynamic> json) {
    return FtkDashboardResponse(
      totalSampleTested: json['TotalsampleTested'],
      totalSourceScheme: json['TotalSource_scheme'],
      totalStorageStructure: json['Total_Storage_structure'],
      totalHhScAwc: json['Total_HH_SC_AWC'],
      totalHandpumpsOtherPrivateSource: json['Total_Handpumps_Other_Private_source'],
      status: json['Status'],
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TotalsampleTested': totalSampleTested,
      'TotalSource_scheme': totalSourceScheme,
      'Total_Storage_structure': totalStorageStructure,
      'Total_HH_SC_AWC': totalHhScAwc,
      'Total_Handpumps_Other_Private_source': totalHandpumpsOtherPrivateSource,
      'Status': status,
      'Message': message,
    };
  }
}
