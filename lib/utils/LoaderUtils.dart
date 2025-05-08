import 'package:flutter/material.dart';

class LoaderUtils {
  /// Shows or hides a default loader dialog with optional message
  static void toggleLoadingDialog(BuildContext context, bool isLoading, {String? message}) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  if (message != null)
                    Text(
                      message,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'OpenSans',),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  /// Returns a conditional overlay loader
  static Widget conditionalLoader({required bool isLoading, Widget? child}) {
    return isLoading
        ? Container(
      color: Colors.black.withOpacity(0.2),
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    )
        : (child ?? const SizedBox.shrink());
  }

  /// Returns a reusable styled progress loader widget (for embedding in dialogs)
  static Widget showProgress() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  static void showCustomLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => showProgress(),
    );
  }

  static void hideLoaderDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
