
import 'package:hive/hive.dart';

part 'HabitationResponse.g.dart'; // 👈 Required for build_runner

@HiveType(typeId: 10)
class HabitationApiResponse {
  @HiveField(0)
  final int status;
  @HiveField(1)
  final String message;
  @HiveField(2)
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

@HiveType(typeId: 11)
class HabitationResponse {
  @HiveField(0)
  final String villageId;
  @HiveField(1)
  final String habitationId;
  @HiveField(2)
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
