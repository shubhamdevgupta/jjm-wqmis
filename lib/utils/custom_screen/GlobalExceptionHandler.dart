import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/custom_screen/ExceptionScreen.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';

import 'package:jjm_wqmis/main.dart';
import 'package:jjm_wqmis/utils/custom_screen/CustomException.dart';

class GlobalExceptionHandler {
  static void handleException(Exception e) {
    if (navigatorKey.currentContext == null) {
      debugPrint("Navigator key context is null, cannot show error.");
      return;
    }

    BuildContext context = navigatorKey.currentContext!;
    String errorMessage;
    String httpErrCode;

    if (e is AppException) {
      // errorMessage = e.toString();
      errorMessage = e.message;
      httpErrCode = e.httpErrCode;
    } else {
      errorMessage = 'Unexpected Error Occurred \n$e';
      httpErrCode = "";
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
            barrierDismissible:false,
          builder: (context) => WillPopScope(
            onWillPop: ()async => false,
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              contentPadding: EdgeInsets.zero, // Remove default padding
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: ExceptionScreen(errorMessage: errorMessage,errorCode: httpErrCode,),
              ),
            ),
          ),
        );

      }
    });
  }
}
