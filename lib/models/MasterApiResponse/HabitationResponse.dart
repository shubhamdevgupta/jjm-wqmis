class HabitationResponse {
  final int villageId;
  final int habitationId;
  final String habitationName;

  HabitationResponse({
    required this.villageId,
    required this.habitationId,
    required this.habitationName,
  });

  factory HabitationResponse.fromJson(Map<String, dynamic> json) {
    return HabitationResponse(
      villageId: json['VillageId'] ?? 0,
      habitationId: json['HabitationId'] ?? 0,
      habitationName: json['HabitationName'] ?? '--All--',
    );
  }
}
