import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/utils/Appcolor.dart';

class AppStyles {
  static TextStyle appBarTitle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle setTextStyle(
      double fontSize, FontWeight fontWeight, Color color) {
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


  static TextStyle textStyleBoldBlack16 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
      fontFamily: 'OpenSans'
  );


  static const TextStyle textStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
      fontFamily: 'OpenSans'
  );

  static ButtonStyle buttonStylePrimary({
    Color backgroundColor = Appcolor.buttonBgColor,
    double horizontalPadding = 100.0,
    double verticalPadding = 10.0,
    double borderRadius = 8,
    double fontSize = 16,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      textStyle:  TextStyle(fontSize: fontSize),
    );
  }

  // Padding & Margin
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
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
