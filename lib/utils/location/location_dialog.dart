import 'package:flutter/material.dart';
import '../../main.dart';
import 'location_utils.dart';

class LocationDialog {

  static bool _isShowing = false;

  static Future<void> showMandatoryLocationDialog() async {
    if (_isShowing) return;

    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint("Navigator context is null");
      return;
    }

    _isShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Location Required"),
        content: const Text(
          "This application requires location services to function properly.\n\nPlease enable location to continue.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await LocationUtils.openLocationSettings();
            },
            child: const Text("Enable Location"),
          ),
        ],
      ),
    );

    _isShowing = false;
  }
}
