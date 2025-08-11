import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage() {
    _init();
  }

  late SharedPreferences prefs;

  Future<void> _init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return prefs.getString(key);
  }

  Future<bool> remove(String key) async {
    return prefs.remove(key);
  }

  Future<bool> clear() async {
    return prefs.clear();
  }

  bool containsKey(String key) => prefs.containsKey(key);
}
