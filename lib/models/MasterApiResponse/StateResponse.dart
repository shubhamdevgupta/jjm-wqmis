import 'package:hive/hive.dart';
part 'StateResponse.g.dart'; // 👈 Required for build_runner
@HiveType(typeId: 0)
class StateApiResponse extends HiveObject {
  @HiveField(0)
  final int status;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final List<Stateresponse> result;

  StateApiResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory StateApiResponse.fromJson(Map<String, dynamic> json) {
    return StateApiResponse(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: (json['Result'] as List<dynamic>)
          .map((item) => Stateresponse.fromJson(item))
          .toList(),
    );
  }
}

@HiveType(typeId: 1)
class Stateresponse {
  @HiveField(0)
  final String jjmStateId;

  @HiveField(1)
  final String stateName;

  Stateresponse({
    required this.jjmStateId,
    required this.stateName,
  });

  factory Stateresponse.fromJson(Map<String, dynamic> json) {
    return Stateresponse(
      jjmStateId: json['JJM_StateId'] ?? '',
      stateName: json['StateName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'JJM_StateId': jjmStateId,
    'StateName': stateName,
  };

  @override
  String toString() => 'StateModel(id: $jjmStateId, name: $stateName)';
}
