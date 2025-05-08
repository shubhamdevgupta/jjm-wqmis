import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  // Default Styles
  static const Color _defaultToastBackgroundColor = Colors.blue;
  static const Color _defaultToastTextColor = Colors.white;
  static const double _defaultToastFontSize = 16.0;

  static const Color _snackBarErrorColor = Colors.redAccent;
  static const Color _snackBarSuccessColor = Colors.green;
  static const Color _snackBarInfoColor = Colors.blueAccent;
  static const Color _snackBarTextColor = Colors.white;

  /// Shows a toast message in the center with optional customization
  static void showToastMessageCenter(String message,
      {Color backgroundColor = _defaultToastBackgroundColor,
        Color textColor = _defaultToastTextColor,
        double fontSize = _defaultToastFontSize}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  /// Shows a toast message at the bottom with optional customization
  static void showToastMessage(String message,
      {Color backgroundColor = Colors.red,
        Color textColor = _defaultToastTextColor,
        double fontSize = _defaultToastFontSize}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  /// Generalized method to show snack bar
  static void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          message,
          style: const TextStyle(
            color: _snackBarTextColor,
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        action: SnackBarAction(
          textColor: Colors.blue[900]!,
          label: 'Dismiss',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  /// Shows a default snack bar with a pink accent background
  static void showSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.red);
  }

  /// Shows an error snack bar
  static void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, _snackBarErrorColor);
  }

  /// Shows a success snack bar
  static void showSuccessSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, _snackBarSuccessColor);
  }

  /// Shows an info snack bar
  static void showInfoSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, _snackBarInfoColor);
  }
}
