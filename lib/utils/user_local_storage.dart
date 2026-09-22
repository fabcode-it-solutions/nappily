import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorage {
  static Future<void> saveUserData({
    required String email,
    required String name,
    required String uid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setString('uid', uid);
  }

  static Future<void> screens({
    required String key,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == '') {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }

  static Future<String?> getLocalStorage({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    String? result = prefs.getString(key);
    return result;
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final name = prefs.getString('name');
    final uid = prefs.getString('uid');
    if (email != null && name != null) {
      return {'email': email, 'name': name, 'uid': uid};
    }
    return null;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('name');
    await prefs.remove('uid');
  }
}
