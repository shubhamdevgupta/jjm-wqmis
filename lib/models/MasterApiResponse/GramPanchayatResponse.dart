class GramPanchayatresponse {
  final String jjmPanchayatId;
  final String panchayatName;

  GramPanchayatresponse({
    required this.jjmPanchayatId,
    required this.panchayatName,
  });

  factory GramPanchayatresponse.fromJson(Map<String, dynamic> json) {
    return GramPanchayatresponse(
      jjmPanchayatId: json['JJM_PanchayatId'] ?? '',
      panchayatName: json['PanchayatName'] ?? '--Select--',
    );
  }
}
