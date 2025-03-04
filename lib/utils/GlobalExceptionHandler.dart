import 'package:flutter/material.dart';
import '../main.dart'; // Ensure this contains navigatorKey
import '../views/ExceptionScreen.dart';
import 'CustomException.dart';

class GlobalExceptionHandler {
  static void handleException(Exception e) {
    if (navigatorKey.currentContext == null) {
      debugPrint("Navigator key context is null, cannot show error.");
      return;
    }

    BuildContext context = navigatorKey.currentContext!;

    String errorMessage;

    if (e is NetworkException) {
      errorMessage = 'No Internet Connection';

      // ✅ Show Snackbar Instead of Navigating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

      return; // ✅ Don't navigate for network errors
    } else if (e is ApiException) {
      errorMessage = e.message;
    } else {
      errorMessage = 'Unexpected Error Occurred \n$e';
    }

    // ✅ Ensure navigation happens only if context is available
    Future.microtask(() {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => ExceptionScreen(),
        ),
      );
    });
  }
}
