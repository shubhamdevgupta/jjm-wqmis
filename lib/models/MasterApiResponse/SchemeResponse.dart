class SchemeResponse {
  final int schemeId;
  final String schemeName;

  SchemeResponse({required this.schemeId, required this.schemeName});

  factory SchemeResponse.fromJson(Map<String, dynamic> json) {
    return SchemeResponse(
      schemeId: json['SchemeId'],
      schemeName: json['SchemeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SchemeId': schemeId,
      'SchemeName': schemeName,
    };
  }
}
