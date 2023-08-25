import 'package:shared_preferences/shared_preferences.dart';

import '../models/sign_up_model.dart';


UserData userData = UserData();

const String prefIsLogin = 'isLogin';
const String prefUserData = 'userData';
const String prefToken = 'token';
const String passwordResetToken = 'passwordResetToken';
const String userMealPlanCountState = 'userMealPlanCountState';


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

    static int getInt(String key) {
    return _prefsInstance != null ? (_prefsInstance!.getInt(key) ?? 0) : 0;
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;
    return _prefsInstance != null ? prefs.setInt(key, value) : Future.value(false);
  }

  static bool getBool(String key) {
    return _prefsInstance != null ? (_prefsInstance!.getBool(key) ?? false) :false;
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return _prefsInstance != null ? prefs.setBool(key, value) : Future.value(false);
  }

}