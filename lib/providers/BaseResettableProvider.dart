import 'package:flutter/cupertino.dart';

abstract class Resettable extends ChangeNotifier {
  void reset();
}