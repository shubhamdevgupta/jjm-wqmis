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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (navigatorKey.currentState?.canPop() == true) {
        navigatorKey.currentState?.pop(); // Prevent stacking error screens
      }
      navigatorKey.currentState?.pushReplacement(

          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(10),
              content: Container(
                color: Colors.white10,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.6,
                child: ExceptionScreen(errorMessage: errorMessage),
              ),
            ),
          )
      );
    });
  }
}
