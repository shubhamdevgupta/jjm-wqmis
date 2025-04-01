import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../views/ExceptionScreen.dart';
import 'CustomException.dart';

class GlobalExceptionHandler {
  static void handleException(Exception e) {
    print("exception is $e");
    if (navigatorKey.currentContext == null) {
      debugPrint("Navigator key context is null, cannot show error.");
      return;
    }

    BuildContext context = navigatorKey.currentContext!;

    String errorMessage;

    if (e is AppException) {
      errorMessage = e.toString();  // Use AppException's toString() method
    } else {
      errorMessage = 'Unexpected Error Occurred \n$e';
    }

    debugPrint("Error Handled: $errorMessage");  // Log error

    // Ensure UI updates are done properly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState?.canPop() == true) {
        navigatorKey.currentState?.pop(); // Prevent stacking error screens
      }
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => ExceptionScreen(errorMessage: errorMessage),
        ),
      );
    });
  }
}
