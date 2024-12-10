import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  late final SharedPreferences _preferences;
  Future<SharedService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  String getString(String key) => _preferences.getString(key) ?? '';

  void setString(String key, String value) => _preferences.setString(key, value);
}
