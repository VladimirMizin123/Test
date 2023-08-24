import 'package:shared_preferences/shared_preferences.dart';


const String prefIsLogin = 'isLogin';
const String prefToken = 'token';


class PreferenceUtils {

  static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String getString(String key) {
    return _prefsInstance != null ? (_prefsInstance!.getString(key) ?? "") : "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return _prefsInstance != null ? prefs.setString(key, value) : Future.value(false);
  }

  static bool getBool(String key) {
    return _prefsInstance != null ? (_prefsInstance!.getBool(key) ?? false) :false;
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return _prefsInstance != null ? prefs.setBool(key, value) : Future.value(false);
  }

}