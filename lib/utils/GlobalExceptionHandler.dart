import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';

import 'package:jjm_wqmis/main.dart';
import 'package:jjm_wqmis/views/ExceptionScreen.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';

class GlobalExceptionHandler {
  static void handleException(Exception e) {
    if (navigatorKey.currentContext == null) {
      debugPrint("Navigator key context is null, cannot show error.");
      return;
    }

    BuildContext context = navigatorKey.currentContext!;
    String errorMessage;

    if (e is AppException) {
      errorMessage = e.toString();
    } else {
      errorMessage = 'Unexpected Error Occurred \n$e';
    }

    debugPrint("Error Handled: $errorMessage");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (e is NetworkException) {
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pop();
        }
      ToastHelper.showSnackBar(context,errorMessage);
      } else {
        // Full-screen error for API or unexpected errors
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pop();
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            contentPadding: EdgeInsets.zero, // Remove default padding
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: ExceptionScreen(errorMessage: errorMessage),
            ),
          ),
        );

      }
    });
  }
}
