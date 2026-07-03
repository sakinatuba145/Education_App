import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  // STRING

  static Future<bool> setString(String key, String value) {
    return _sharedPreferences!.setString(key, value);
  }

  static String? getString(String key) {
    return _sharedPreferences!.getString(key);
  }

  // BOOL
  static Future<bool> setBool(String key, bool value) {
    return _sharedPreferences!.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _sharedPreferences!.getBool(key);
  }
}
