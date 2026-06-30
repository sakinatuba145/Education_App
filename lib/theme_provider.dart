
import 'package:flutter/material.dart';
import 'core/helpers/shared_preferences_helper.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;
ThemeMode get themeMode => _isDark? ThemeMode.dark:ThemeMode.light;
  Future<void> loadTheme() async {
    _isDark = SharedPreferencesHelper.getBool("isDark") ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;

    await SharedPreferencesHelper.setBool(
      "isDark",
      _isDark,
    );

    notifyListeners();
  }
}