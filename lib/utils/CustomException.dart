class AppException implements Exception {
  final String message;
  final String prefix;

  AppException(this.message, this.prefix);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class NetworkException extends AppException {
  NetworkException([String message = "No Internet Connection"])
      : super(message, "");
}

class ApiException extends AppException {
  ApiException([String message = "Something went wrong with the API"])
      : super(message, "");
}
