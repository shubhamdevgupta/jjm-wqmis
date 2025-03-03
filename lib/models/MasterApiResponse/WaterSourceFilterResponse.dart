class Watersourcefilterresponse {
  final int id;
  final String sourceType;

  Watersourcefilterresponse({
    required this.id,
    required this.sourceType,
  });

  factory Watersourcefilterresponse.fromJson(Map<String, dynamic> json) {
    return Watersourcefilterresponse(
      id: json['Id'],
      sourceType: json['SourceType'].trim(), // Removing unwanted spaces or newline characters
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'SourceType': sourceType,
    };
  }

  @override
  String toString() {
    return 'WaterSourceType(id: $id, sourceType: "$sourceType")';
  }
}

List<Watersourcefilterresponse> parseWaterSourceTypes(List<dynamic> jsonList) {
  return jsonList.map((json) => Watersourcefilterresponse.fromJson(json)).toList();
}
