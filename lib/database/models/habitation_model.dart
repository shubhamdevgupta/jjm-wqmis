class HabitationModel {
  final int villageId;
  final int habitationId;
  final String habitationName;

  HabitationModel({
    required this.villageId,
    required this.habitationId,
    required this.habitationName,
  });

  factory HabitationModel.fromJson(Map<String, dynamic> json) {
    return HabitationModel(
      villageId: json['VillageId'],
      habitationId: json['HabitationId'],
      habitationName: json['HabitationName'],
    );
  }
}
