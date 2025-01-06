import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/find_address_model.dart';
import 'package:gymeats_mobile/repository/google_map_searching.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userId = '';

const String prefIsLogin = 'isLogin';
const String prefIsConfirmEmail = 'isConfirmEmail';
const String prefUserData = 'userData';
const String prefUserEmail = 'userEmail';
const String prefUserName = 'prefUserName';
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
const String subscriptionStatus = 'subscriptionStatus';
const String manualLocation = 'manualLocation';

const String trackerListStore = 'trackerDataList';
const String dashboardModelPref = 'dashboardModelPref';
const String mealDataByDatePref = 'mealDataByDatePref';

const String groceryBring = 'groceryBring';
const String groceryPickup = 'groceryPickup';

const String restaurantsBring = 'restaurantsBring';
const String restaurantsPickup = 'restaurantsPickup';

const String currentLat = 'currentLat';
const String currentLng = 'currentLng';

const String groceryRadius = 'groceryRadius';
const String restaurantsRadius = 'restaurantsRadius';

const String restaurantCart = 'restaurantCart';

const String understandDisclaimer = 'understandDisclaimer';
const String foodMenuAddress = 'foodMenuAddress';

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

  static num getNum(String key) {
    return _prefsInstance != null
        ? (num.tryParse(_prefsInstance?.get(key).toString() ?? "") ?? 0)
        : 0;
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

  static List<String> getStringList(String key) {
    return _prefsInstance != null
        ? (_prefsInstance!.getStringList(key) ?? [])
        : [];
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    var prefs = await _instance;
    return _prefsInstance != null
        ? prefs.setStringList(key, value)
        : Future.value(false);
  }

  static Future<void> removePref(String key) async {
    var prefs = await _instance;
    await prefs.remove(key);
  }

  static Future<bool> clearPrefs() async {
    var prefs = await _instance;
    GetStorage box = GetStorage();
    String calorie = PreferenceUtils.getString(totalCalorie);
    String protein = PreferenceUtils.getString(totalProtein);
    String fat = PreferenceUtils.getString(totalFat);
    String carbs = PreferenceUtils.getString(totalCarbs);

    Future<bool> value =
        _prefsInstance != null ? prefs.clear() : Future.value(false);
    box.erase();

    PreferenceUtils.setString(totalCalorie, calorie);
    PreferenceUtils.setString(totalProtein, protein);
    PreferenceUtils.setString(totalFat, fat);
    PreferenceUtils.setString(totalCarbs, carbs);

    return value;
  }

  static double getRestaurantsRadius() {
    return _prefsInstance != null
        ? _prefsInstance!.getDouble(restaurantsRadius) ?? 3.0
        : 3.0;
  }

  static void setRestaurantsRadius(double? value) {
    _prefsInstance?.setDouble(restaurantsRadius, value ?? 3.0);
  }

  static double getGroceryRadius() {
    return _prefsInstance != null
        ? _prefsInstance!.getDouble(groceryRadius) ?? 3.0
        : 3.0;
  }

  static void setGroceryRadius(double? value) {
    _prefsInstance?.setDouble(groceryRadius, value ?? 3.0);
  }

  static Future<void> setManualLoation(bool value) async {
    await _prefsInstance!.setBool(manualLocation, value);
  }

  static bool get isManualLocation => _prefsInstance != null
      ? (_prefsInstance!.getBool(manualLocation) ?? false)
      : false;

  static Future<void> updateResCart(List<ShoppingListData> cart) async {
    await _prefsInstance?.setString(
        restaurantCart, jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  static List<ShoppingListData> getRestaurantCart() {
    try {
      String? res = _prefsInstance?.getString(restaurantCart);
      if (res != null) {
        return List<ShoppingListData>.from(
            jsonDecode(res)?.map((x) => ShoppingListData.fromJson(x ?? {})) ??
                []);
      }
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static final GoogleMapSearchRepository _repo = GoogleMapSearchRepository();

  static void setFoodMenuAddress({Map<String, dynamic>? req}) async {
    try {
      if (!isManualLocation) {
        if (getString(foodMenuAddress).trim().isEmpty) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) return;
          (double?, double?) pos = await Constant.i.position;
          Either<ErrorModel, FindAddressResponseModel> address = await _repo
              .findAddressURL(lat: pos.$1?.toString(), lng: pos.$2?.toString());
          if (address.isRight) {
            Map<String, dynamic> req = setFromCurrentLocation(address.right);
            await setString(foodMenuAddress, jsonEncode(req));
          }
        }
      } else {
        if (req != null) {
          await setString(foodMenuAddress, jsonEncode(req));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Map<String, dynamic> setFromCurrentLocation(
      FindAddressResponseModel right) {
    try {
      Map<String, dynamic> req = {};
      if (right.results?.isNotEmpty ?? false) {
        right.results!.first.addressComponents?.forEach((element) {
          List<String> streetNumList = element.types
                  ?.where((element1) => element1 == 'premise')
                  .toList() ??
              [];

          if (streetNumList.isNotEmpty) {
            req["user_street_num"] = element.longName ?? "";
          }

          List<String> streetNameList = element.types
                  ?.where((element1) => element1 == 'route')
                  .toList() ??
              [];

          if (streetNameList.isNotEmpty) {
            req["user_street_name"] = element.longName ?? "";
          }

          List<String> cityList = element.types
                  ?.where((element1) => element1 == 'locality')
                  .toList() ??
              [];

          if (cityList.isNotEmpty) {
            req["user_city"] = element.longName ?? "";
          }

          List<String> stateList = element.types
                  ?.where(
                      (element1) => element1 == 'administrative_area_level_1')
                  .toList() ??
              [];

          if (stateList.isNotEmpty) {
            req["user_state"] = element.shortName ?? "";
          }

          List<String> countryList = element.types
                  ?.where((element1) => element1 == 'country')
                  .toList() ??
              [];

          if (countryList.isNotEmpty) {
            req["user_country"] = element.shortName ?? "";
          }

          List<String> pinCodeList = element.types
                  ?.where((element1) => element1 == 'postal_code')
                  .toList() ??
              [];

          if (pinCodeList.isNotEmpty) {
            req["user_zipcode"] = element.longName;
          }
        });

        req["extended_address"] = "";
      }
      return req;
    } catch (e) {
      return {};
    }
  }

  static Map<String, dynamic> getMenuAddress() {
    try {
      String value = getString(foodMenuAddress);
      if (value.isNotEmpty) {
        return jsonDecode(value);
      }
      return {};
    } catch (e) {
      log("Find Menu Address Error:-> ${e.toString()}");
      return {};
    }
  }
}
