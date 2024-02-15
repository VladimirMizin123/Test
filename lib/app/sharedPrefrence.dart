import 'package:shared_preferences/shared_preferences.dart';

String userId = '';

const String prefIsLogin = 'isLogin';
const String prefIsConfirmEmail = 'isConfirmEmail';
const String prefUserData = 'userData';
const String prefUserEmail = 'userEmail';
const String prefUserMobile = 'userPhone';
const String prefToken = 'token';
const String latitude = 'latitude';
const String longitude = 'longitude';
const String prefPasswordResetToken = 'passwordResetToken';
const String userMealPlanCountState = 'userMealPlanCountState';
const String prefWaterML = 'waterML';
const String prefExerciseCAl = 'exerciseCAl';
const String forgetPassToken = 'forget_pass_token';
const String totalCalorie = 'totalCalorie';
const String totalProtein = 'totalProtein';
const String totalFat = 'totalFat';
const String totalCarbs = 'totalCarbs';
const String showOrderHint = 'showOrderHint';
const String paymentCard = 'paymentCard';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
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
    return _prefsInstance != null
        ? prefs.setString(key, value)
        : Future.value(false);
  }

  static int getInt(String key) {
    return _prefsInstance != null ? (_prefsInstance!.getInt(key) ?? 0) : 0;
  }

  static double getDouble(String key) {
    return _prefsInstance != null
        ? (_prefsInstance!.getDouble(key) ?? 0.0)
        : 0.0;
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;
    return _prefsInstance != null
        ? prefs.setInt(key, value)
        : Future.value(false);
  }

  static Future<bool> setDouble(String key, double value) async {
    var prefs = await _instance;
    return _prefsInstance != null
        ? prefs.setDouble(key, value)
        : Future.value(false);
  }

  static bool getBool(String key) {
    return _prefsInstance != null
        ? (_prefsInstance!.getBool(key) ?? false)
        : false;
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return _prefsInstance != null
        ? prefs.setBool(key, value)
        : Future.value(false);
  }

  static removePref(String key) async {
    var prefs = await _instance;
    await prefs.remove(key);
  }

  static Future<bool> clearPrefs() async {
    var prefs = await _instance;
    String calorie = PreferenceUtils.getString(totalCalorie);
    String protein = PreferenceUtils.getString(totalProtein);
    String fat = PreferenceUtils.getString(totalFat);
    String carbs = PreferenceUtils.getString(totalCarbs);

    Future<bool> value =
        _prefsInstance != null ? prefs.clear() : Future.value(false);

    PreferenceUtils.setString(totalCalorie, calorie);
    PreferenceUtils.setString(totalProtein, protein);
    PreferenceUtils.setString(totalFat, fat);
    PreferenceUtils.setString(totalCarbs, carbs);

    return value;
  }
}
