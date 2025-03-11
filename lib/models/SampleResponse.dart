class Sampleresponse {
  int status;
  String message;
  String sampleId;

  Sampleresponse({
    required this.status,
    required this.message,
    required this.sampleId,
  });

  factory Sampleresponse.fromJson(Map<String, dynamic> json) => Sampleresponse(
        status: json["Status"],
        message: json["Message"],
        sampleId: json["sampleId"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "sampleId": sampleId,
      };
}
