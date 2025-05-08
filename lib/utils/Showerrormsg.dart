import 'package:flutter/material.dart';

class AppTextWidgets {
  /// Generic red error text
  static Widget errorText(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Container(
        width: double.infinity, // <-- Increased width
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          border: Border.all(
            color: Colors.redAccent,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14, fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Info or neutral message (e.g., "No data available")
  static Widget infoText(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14, fontFamily: 'OpenSans',
        ),
      ),
    );
  }

  /// Styled headline for sections
  static Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
