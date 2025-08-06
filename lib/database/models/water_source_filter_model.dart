class WaterSourceFilterModel {
  final int id;
  final String sourceType;

  WaterSourceFilterModel({
    required this.id,
    required this.sourceType,
  });

  factory WaterSourceFilterModel.fromJson(Map<String, dynamic> json) {
    return WaterSourceFilterModel(
      id: json['Id'],
      sourceType: json['SourceType'],
    );
  }
}
