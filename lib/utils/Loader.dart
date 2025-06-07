import 'package:flutter/material.dart';

class Loader {
  static circularLoader({Color? color, double? height}) {
    return Container(
      height: height,
      color: color,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: Color.fromRGBO(3, 60, 207, 0.9),),
    );
  }
}
