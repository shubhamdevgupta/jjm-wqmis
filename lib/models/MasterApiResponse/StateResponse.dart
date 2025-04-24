class StateApiResponse {
  final int status;
  final String message;
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

class Stateresponse {
  final String jjmStateId;
  final String stateName;

  Stateresponse({required this.jjmStateId, required this.stateName});

  factory Stateresponse.fromJson(Map<String, dynamic> json) {
    return Stateresponse(
      jjmStateId: json['JJM_StateId'] ?? '',
      stateName: json['StateName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JJM_StateId': jjmStateId,
      'StateName': stateName,
    };
  }

  @override
  String toString() => 'StateModel(id: $jjmStateId, name: $stateName)';
}
