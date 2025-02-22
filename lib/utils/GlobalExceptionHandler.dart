import 'package:flutter/material.dart';

import '../main.dart';
import '../views/ExceptionScreen.dart';
import 'CustomException.dart'; // Import the file where you declared navigatorKey

class GlobalExceptionHandler {
  static void handleException(Exception e) {
    String errorMessage = 'Unexpected Error Occurred';

    if (e is NetworkException) {
      errorMessage = 'No Internet Connection';
    } else if (e is ApiException) {
      errorMessage = e.message;
    }

    // Use navigatorKey to navigate
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => ExceptionScreen(errorMessage: errorMessage),
      ),
    );
  }
}
