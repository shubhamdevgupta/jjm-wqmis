class Wtplistresponse {
  String wtpName;
  String wtpId;

  Wtplistresponse({
    required this.wtpName,
    required this.wtpId,
  });

  // Factory method to create an instance from JSON
  factory Wtplistresponse.fromJson(Map<String, dynamic> json) {
    return Wtplistresponse(
      wtpName: json['wtp_name'] ?? '',
      wtpId: json['wtp_id'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'wtp_name': wtpName,
      'wtp_id': wtpId,
    };
  }

  @override
  String toString() {
    return 'WTPModel(wtpName: $wtpName, wtpId: $wtpId)';
  }
}
