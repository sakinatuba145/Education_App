import 'package:flutter/material.dart';

class AppAnimations {
  static const Duration microDuration = Duration(milliseconds: 150);
  static const Duration shortDuration = Duration(milliseconds: 250);
  static const Duration mediumDuration = Duration(milliseconds: 400);
  static const Duration longDuration = Duration(milliseconds: 600);
  static const Duration buttonFeedbackDuration = Duration(milliseconds: 120);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
//----------------
  static const Duration pageTransitionDuration =
  Duration(milliseconds: 400);

  static const Duration modalDuration =
  Duration(milliseconds: 300);

  static const Duration heroDuration =
  Duration(milliseconds: 600);
  //----------------

}
