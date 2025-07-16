class AppException implements Exception {
  final String message;
  final String httpErrCode;

  AppException(this.message, this.httpErrCode);

  @override
  String toString() {
    return message;
  }

}

class NetworkException extends AppException {
  NetworkException([String message = "No Internet Connection"])
      : super(message, "");
}

class ApiException extends AppException {
  ApiException(super.message,super.httpErrCode);
}
