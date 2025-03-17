import 'package:flutter/material.dart';

class LoaderUtils {
  /// Shows or hides a full-screen circular loader dialog based on `isLoading`
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

  /// Returns a loader widget based on `isLoading`
  static Widget conditionalLoader({required bool isLoading, Widget? child}) {
    return isLoading
        ? Container(
          color: Colors.black.withOpacity(0.2), // Background opacity
          child: const Center(
                child: CircularProgressIndicator(
          color: Colors.white,
                ),
              ),
        )
        : (child ?? const SizedBox.shrink());
  }

}
