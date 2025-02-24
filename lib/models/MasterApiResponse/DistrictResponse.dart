class Districtresponse {
  int jJMStateId;
  String jJMDistrictId;
  String districtName;
  String stateName;

  Districtresponse(
      {required this.jJMStateId, required this.jJMDistrictId, required this.districtName, required this.stateName});

  factory Districtresponse.fromJson(Map<String, dynamic> json) {
    return Districtresponse(
        jJMStateId :  json['JJM_StateId'] ?? '',
        jJMDistrictId : json['JJM_DistrictId'] ?? '',
        districtName : json['DistrictName'] ?? '',
        stateName : json['StateName']?? ''
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JJM_StateId'] = this.jJMStateId;
    data['JJM_DistrictId'] = this.jJMDistrictId;
    data['DistrictName'] = this.districtName;
    data['StateName'] = this.stateName;
    return data;
  }
}
