import 'dart:ui';

import 'package:flutter/material.dart';

class AppStyles {

  static TextStyle appBarTitle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );


  static TextStyle setTextStyle(  double fontSize , FontWeight fontWeight, Color color) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle style16NormalBlack = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static const TextStyle buttonStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Padding & Margin
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);

  // Border Radius
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(12));

  // Shadows
  static final List<BoxShadow> cardShadow = [
    const BoxShadow(
      color: Colors.black12,
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

}