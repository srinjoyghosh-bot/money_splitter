import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late LocalStorageService _instance;
  static late SharedPreferences _preferences;

  static const String isLoggedInKey = 'is_logged_in_key';
  static const String userIdKey = 'user_id_key';

  static Future<LocalStorageService> getInstance() async {
    _instance = LocalStorageService();
    _preferences = await SharedPreferences.getInstance();
    return _instance;
  }

  dynamic _getFromDisk(String key) {
    final value = _preferences.get(key);
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  bool get isLoggedIn => _getFromDisk(isLoggedInKey) ?? false;

  String get currentUserId => _getFromDisk(userIdKey);

  set isLoggedIn(bool isLoggedIn) {
    _saveToDisk(isLoggedInKey, isLoggedIn);
  }

  set currentUserId(String userId) {
    _saveToDisk(userIdKey, userId);
  }
}
