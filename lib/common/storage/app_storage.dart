import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  final String _tokenKey = "token";
  final String _userId = "userId";
  final String _userName = "userName";
  final String _theme = 'theme';

  final SharedPreferences _preferences = GetIt.I.get<SharedPreferences>();

  Future<void> saveToken(String token) async {
    await _preferences.setString(_tokenKey, token);
  }

  String getToken() {
    return _preferences.getString(_tokenKey) ?? '';
  }

  Future<void> saveUserId(String id) async {
    await _preferences.setString(_userId, id);
  }

  String getUserId() {
    return _preferences.getString(_userId) ?? '';
  }

  Future<void> saveUserName(String name) async {
    await _preferences.setString(_userName, name);
  }

  String getUserName() {
    return _preferences.getString(_userName) ?? '';
  }

  Future<void> saveTheme(bool isDark) async {
    await _preferences.setBool(_theme, isDark);
  }

  bool getTheme() {
    return _preferences.getBool(_theme) ?? false;
  }

  Future<void> logout() async {
    await _preferences.clear();
  }
}
