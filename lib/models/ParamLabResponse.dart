class Lab {
  final int labId;
  final String labName;

  Lab({required this.labId, required this.labName});

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      labId: json['lab_id'],
      labName: json['lab_name'],
    );
  }
}

class Paramlabresponse {
  final bool status;
  final String message;
  final List<Lab> labs;

  Paramlabresponse({required this.status, required this.message, required this.labs});

  factory Paramlabresponse.fromJson(Map<String, dynamic> json) {
    return Paramlabresponse(
      status: json['Status'],
      message: json['Message'],
      labs: (json['Result'] as List).map((lab) => Lab.fromJson(lab)).toList(),
    );
  }
}
