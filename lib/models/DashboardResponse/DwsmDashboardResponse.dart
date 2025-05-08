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
      totalSchools: json['Total_School'] ?? 0,
      totalSchoolsDemonstration: json['Total_School_Demonstrated'] ?? 0,
      totalAWCs: json['Total_AWCs'] ?? 0,
      totalAWCsDemonstration: json['Total_AWCs_Demonstrated'] ?? 0,
      status: json['Status'] ?? 0,
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Total_School': totalSchools,
      'Total_School_Demonstrated': totalSchoolsDemonstration,
      'Total_AWCs': totalAWCs,
      'Total_AWCs_Demonstrated': totalAWCsDemonstration,
      'Status': status,
      'Message': message,
    };
  }
}
