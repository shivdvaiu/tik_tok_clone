import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  dynamic getFromDisk(String key) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final value = _preferences.get(key);

    return value;
  }

  saveToDisk<T>(String key, T content) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

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

  clearStorage() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.clear();
  }
}
