class Labinchargeresponse {
  final String name;
  final String labName;
  final String address;
  final int status;
  final String message;

  Labinchargeresponse({
    required this.name,
    required this.labName,
    required this.address,
    required this.status,
    required this.message,
  });

  factory Labinchargeresponse.fromJson(Map<String, dynamic> json) {
    return Labinchargeresponse(
      name: json['Name'] ?? 'Unknown',
      labName: json['LabName'] ?? 'Unknown',
      address: json['Address'] ?? 'Unknown',
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'LabName': labName,
      'Address': address,
      'Status': status,
      'Message': message,
    };
  }


}
