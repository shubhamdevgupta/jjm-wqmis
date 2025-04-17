class Dwsmdashboardresponse {
  final int totalSchools;
  final int totalSchoolsDemonstration;
  final int totalAWCs;
  final int totalAWCsDemonstration;
  final int status;
  final String? message;

  Dwsmdashboardresponse({
    required this.totalSchools,
    required this.totalSchoolsDemonstration,
    required this.totalAWCs,
    required this.totalAWCsDemonstration,
    required this.status,
    this.message,
  });

  factory Dwsmdashboardresponse.fromJson(Map<String, dynamic> json) {
    return Dwsmdashboardresponse(
      totalSchools: json['TotalSchools'] ?? 0,
      totalSchoolsDemonstration: json['TotalSchools_Demonstration'] ?? 0,
      totalAWCs: json['TotalAWCs'] ?? 0,
      totalAWCsDemonstration: json['TotalAWCs_Demonstration'] ?? 0,
      status: json['Status'] ?? 0,
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TotalSchools': totalSchools,
      'TotalSchools_Demonstration': totalSchoolsDemonstration,
      'TotalAWCs': totalAWCs,
      'TotalAWCs_Demonstration': totalAWCsDemonstration,
      'Status': status,
      'Message': message,
    };
  }
}
