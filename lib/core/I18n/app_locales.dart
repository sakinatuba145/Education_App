import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLocales {
  static const en = Locale('en', 'US');
  static const fa = Locale('fa', 'AF');
  static const ar = Locale('ar', 'SA');
  static const hi = Locale('hi', 'IN');
  static const ur = Locale('ur', 'PK');
  static const ps = Locale('ps', 'AF');
  static const tr = Locale('tr', 'TR');

  static Locale get deviceLocale {
    final locale = Get.deviceLocale;

    if (locale == null) return en;

    switch (locale.languageCode) {
      case 'fa':
        return fa;
      case 'ar':
        return ar;
      case 'hi':
        return hi;
      case 'ur':
        return ur;
      case 'ps':
        return ps;
      case 'tr':
        return tr;
      default:
        return en;
    }
  }
}