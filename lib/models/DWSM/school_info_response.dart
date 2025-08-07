// To parse this JSON data, do
//
//     final schoolinfoResponse = schoolinfoResponseFromJson(jsonString);

import 'dart:convert';

SchoolinfoResponse schoolinfoResponseFromJson(String str) => SchoolinfoResponse.fromJson(json.decode(str));

String schoolinfoResponseToJson(SchoolinfoResponse data) => json.encode(data.toJson());

class SchoolinfoResponse {
  int status;
  String message;
  List<SchoolResult> result;

  SchoolinfoResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory SchoolinfoResponse.fromJson(Map<String, dynamic> json) => SchoolinfoResponse(
    status: json["Status"],
    message: json["Message"],
    result: List<SchoolResult>.from(json["Result"].map((x) => SchoolResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "Result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class SchoolResult {
  String name;
  int id;
  int demonstrated;
  String demonstratedDate;

  SchoolResult({
    required this.name,
    required this.id,
    required this.demonstrated,
    required this.demonstratedDate,
  });

  factory SchoolResult.fromJson(Map<String, dynamic> json) => SchoolResult(
    name: json["Name"],
    id: json["Id"],
    demonstrated: json["demonstrated"],
    demonstratedDate: json["demonstrated_date"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Id": id,
    "demonstrated": demonstrated,
    "demonstrated_date":demonstratedDate
  };
}
