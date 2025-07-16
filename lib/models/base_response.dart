// lib/models/base_response.dart

class BaseResponseModel<T> {
  final int status;
  final String message;
  final List<T> result;

  BaseResponseModel({
    required this.status,
    required this.message,
    required this.result,
  });

  factory BaseResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return BaseResponseModel<T>(
      status: json['Status'] ?? 0,
      message: json['Message'] ?? '',
      result: json['Result'] != null
          ? List<T>.from((json['Result'] as List<dynamic>).map((e) => fromJsonT(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson(
      Map<String, dynamic> Function(T) toJsonT,
      ) {
    return {
      'Status': status,
      'Message': message,
      'Result': result.map((e) => toJsonT(e)).toList(),
    };
  }

  @override
  String toString() =>
      'BaseResponse(status: $status, message: $message, resultCount: ${result.length})';
}
