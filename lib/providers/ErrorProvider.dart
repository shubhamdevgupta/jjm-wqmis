import 'package:flutter/material.dart';

class ErrorProvider with ChangeNotifier {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
