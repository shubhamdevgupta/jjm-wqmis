class HabitationApiResponse {
  final int status;
  final String message;
  final List<HabitationResponse> result;

  HabitationApiResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory HabitationApiResponse.fromJson(Map<String, dynamic> json) {
    return HabitationApiResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>)
          .map((item) => HabitationResponse.fromJson(item))
          .toList(),
    );
  }
}

class HabitationResponse {
  final String villageId;
  final String habitationId;
  final String habitationName;

  HabitationResponse({
    required this.villageId,
    required this.habitationId,
    required this.habitationName,
  });

  factory HabitationResponse.fromJson(Map<String, dynamic> json) {
    return HabitationResponse(
      villageId: json['VillageId'].toString(),
      habitationId: json['HabitationId'].toString(),
      habitationName: json['HabitationName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VillageId': villageId,
      'HabitationId': habitationId,
      'HabitationName': habitationName,
    };
  }

  @override
  String toString() =>
      'HabitationModel(id: $habitationId, name: $habitationName, villageId: $villageId)';
}
