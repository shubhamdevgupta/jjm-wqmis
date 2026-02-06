import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:jjm_wqmis/main.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_exception.dart';
import 'package:jjm_wqmis/utils/custom_screen/exception_screen.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';

class GlobalExceptionHandler {
  static Future<void> handleException(
      Exception e, {
        StackTrace? stackTrace,
      }) async {
    if (navigatorKey.currentContext == null) return;

    final context = navigatorKey.currentContext!;
    String errorMessage = '';
    String httpErrCode = '';

    final connectivity = await Connectivity().checkConnectivity();
    final bool isNetworkOff = connectivity == ConnectivityResult.none;

    FirebaseCrashlytics.instance.setCustomKey(
        'connectivity_type', connectivity.toString());

    if (isNetworkOff) {
      errorMessage =
      'No internet connection.\nPlease turn on Wi-Fi or Mobile Data.';
    } else if (e is AppException) {
      errorMessage = e.message;
      httpErrCode = e.httpErrCode;
    } else if (e is UnexpectedException) {
      FirebaseCrashlytics.instance.recordError(
        e.originalError,
        stackTrace,
        reason: 'Unexpected backend/parsing issue',
        fatal: false,
      );
      errorMessage =
      'Something went wrong while processing data.\nPlease try again later.';
    } else if (
        e is TimeoutException ||
        e is ClientException) {
      errorMessage =
      'Unable to connect to the server from your network.\n'
          'Please try switching Wi-Fi/Mobile data or try again later.';
    } else {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      errorMessage =
      'Unexpected error occurred.\nPlease try again later.';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: ExceptionScreen(
              errorMessage: errorMessage,
              errorCode: httpErrCode,
            ),
          ),
        );

    });
  }
}
