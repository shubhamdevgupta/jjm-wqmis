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
    if (navigatorKey.currentContext == null) {
      debugPrint("Navigator key context is null, cannot show error.");
      return;
    }

    final BuildContext context = navigatorKey.currentContext!;
    String errorMessage = '';
    String httpErrCode = '';

    debugPrint("Error caught: $e");

    /// ---------- COMMON DIAGNOSTICS ----------
    final connectivity =
    await Connectivity().checkConnectivity();

    FirebaseCrashlytics.instance.setCustomKey(
      'connectivity_type',
      connectivity.toString(),
    );

    FirebaseCrashlytics.instance.setCustomKey(
      'timestamp',
      DateTime.now().toIso8601String(),
    );

    FirebaseCrashlytics.instance.setCustomKey(
      'screen',
      ModalRoute.of(context)?.settings.name ?? 'unknown',
    );

    /// ---------- EXPECTED APP / API ERRORS ----------
    if (e is AppException) {
      errorMessage = e.message;
      httpErrCode = e.httpErrCode;
    }

    /// ---------- UNEXPECTED BACKEND / PARSING ISSUES ----------
    else if (e is UnexpectedException) {
      FirebaseCrashlytics.instance.recordError(
        e.originalError,
        stackTrace,
        reason: 'Unexpected backend / parsing issue',
        fatal: false,
      );

      FirebaseCrashlytics.instance.setCustomKey(
        'error_category',
        'unexpected_backend_error',
      );

      errorMessage =
      'Something went wrong while processing data.\nPlease try again later.';
    }

    /// ---------- NETWORK / TRANSPORT LEVEL ERRORS ----------
    else if (e is SocketException) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'SocketException – connection reset or unreachable',
        fatal: false,
      );

      FirebaseCrashlytics.instance.setCustomKey(
        'error_category',
        'socket_exception',
      );

      FirebaseCrashlytics.instance.setCustomKey(
        'socket_message',
        e.message,
      );

      errorMessage =
      'Unable to connect to the server from your network.\n'
          'Please try switching Wi-Fi/Mobile data or try again later.';
    }

    else if (e is TimeoutException) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'TimeoutException – server not responding',
        fatal: false,
      );

      FirebaseCrashlytics.instance.setCustomKey(
        'error_category',
        'timeout_exception',
      );

      errorMessage =
      'The server is taking too long to respond.\nPlease try again.';
    }

    else if (e is ClientException) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'ClientException – HTTP client failed',
        fatal: false,
      );

      FirebaseCrashlytics.instance.setCustomKey(
        'error_category',
        'client_exception',
      );

      errorMessage =
      'Network error occurred while connecting to server.\n'
          'Please try again or change your network.';
    }

    /// ---------- ABSOLUTE FALLBACK ----------
    else {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Unknown uncaught exception',
        fatal: false,
      );

      FirebaseCrashlytics.instance.setCustomKey(
        'error_category',
        'unknown_exception',
      );

      errorMessage =
      'Unexpected error occurred.\nPlease try again later.';
    }

    /// ---------- UI HANDLING ----------
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (e is NetworkException ||
          e is SocketException ||
          e is TimeoutException ||
          e is ClientException) {
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pop();
        }
        ToastHelper.showSnackBar(context, errorMessage);
      } else {
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pop();
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              contentPadding: EdgeInsets.zero,
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: ExceptionScreen(
                  errorMessage: errorMessage,
                  errorCode: httpErrCode,
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}
