import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _userLoggedInKey = 'user_logged_in';

  /// Simulate login status check from SharedPreferences
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userLoggedInKey) ?? false;
  }

  /// Call this after successful login/registration
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userLoggedInKey, value);
  }

  /// Clear session
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userLoggedInKey);
  }
}
