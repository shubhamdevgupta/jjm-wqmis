class Labinchargeresponse {
  final String name;
  final String labName;
  final String address;

  Labinchargeresponse({
    required this.name,
    required this.labName,
    required this.address,
  });

  factory Labinchargeresponse.fromJson(Map<String, dynamic> json) {
    return Labinchargeresponse(
      name: json['Name'] ?? 'Unknown',
      labName: json['LabName'] ?? 'Unknown',
      address: json['Address'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'LabName': labName,
      'Address': address,
    };
  }
}
