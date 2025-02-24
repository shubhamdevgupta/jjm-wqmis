// lib/models/state_model.dart

class Stateresponse {
  final String jjmStateId;
  final String stateName;

  Stateresponse({required this.jjmStateId, required this.stateName});

  // Factory method to create an instance from JSON
  factory Stateresponse.fromJson(Map<String, dynamic> json) {
    return Stateresponse(
      jjmStateId: json['JJM_StateId'] ?? '',
      stateName: json['StateName'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'JJM_StateId': jjmStateId,
      'StateName': stateName,
    };
  }

  @override
  String toString() => 'StateModel(id: $jjmStateId, name: $stateName)';
}
