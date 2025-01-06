import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart'
    as res_event;

List<String> get dialGoalList => [
      StringUtils.loseWeight,
      StringUtils.gainLeanMuscle,
      StringUtils.toneUp,
      StringUtils.healthyDiet,
    ];

class Debouncer {
  Timer? timer;

  run(VoidCallback action, {int? milliseconds}) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds ?? 500), action);
  }
}

class Constant {
  static final i = Constant._();

  Constant._();

  String get chatId => "17386518";

  Future<(double?, double?)> get position async {
    try {
      if (PreferenceUtils.isManualLocation) {
        return (null, null);
      }
      double lat = PreferenceUtils.getDouble(currentLat);
      double lng = PreferenceUtils.getDouble(currentLng);
      if (lat != 0 && lng != 0) {
        return (lat, lng);
      }

      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      return PreferenceUtils.isManualLocation
          ? (null, null)
          : (pos.latitude, pos.longitude);
    } catch (e) {
      return (null, null);
    }
  }

  List<String> get requiredAddressField => [
        "user_zipcode",
        "user_country",
        "user_state",
        "user_street_name",
        "user_street_num",
        "user_city",
        "extended_address",
      ];

  Future<dynamic> showAlertDialog({
    required BuildContext context,
    required String title,
    required String desc,
    String? cancelTask,
    String? confirmTask,
    Function()? onConfirm,
  }) async {
    try {
      return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: "Avenir",
            ),
          ),
          content: Text(
            desc,
            style: const TextStyle(
              color: AppColors.black,
              fontFamily: "Avenir",
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
          actions: [
            ElevatedButton(
              child: Text(
                cancelTask ?? StringUtils.noTxt,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Avenir",
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Get.back(result: false);
              },
            ),
            ElevatedButton(
              child: Text(
                confirmTask ?? StringUtils.yesTxt,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Avenir",
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Get.back(result: true);
              },
            ),
            5.width,
          ],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removeStore() async {
    await PreferenceUtils.removePref(groceryBring);
    await PreferenceUtils.removePref(groceryPickup);
    await PreferenceUtils.removePref(restaurantsBring);
    await PreferenceUtils.removePref(restaurantsPickup);
  }

  void handleStoreCache() async {
    GroceryBloc gBloc = GroceryBloc();
    RestaurantBloc bloc = RestaurantBloc();
    await Future.delayed(const Duration(milliseconds: 10));
    gBloc.add(
      StoreNearByEvent(
          getUserAddress: null, askReceiveOrder: AskReceiveOrder.bringTheOrder),
    );
    await Future.delayed(const Duration(milliseconds: 10));
    gBloc.add(
      StoreNearByEvent(
          getUserAddress: null, askReceiveOrder: AskReceiveOrder.pickMySelf),
    );
    await Future.delayed(const Duration(milliseconds: 20));
    bloc.add(res_event.GetRestaurantListEvent(null, null, false, []));
    await Future.delayed(const Duration(milliseconds: 30));
    bloc.add(res_event.GetRestaurantListEvent(null, null, true, []));
  }

  void storeCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      Position pos = await Geolocator.getCurrentPosition();
      PreferenceUtils.setDouble(currentLat, pos.latitude);
      PreferenceUtils.setDouble(currentLat, pos.longitude);
    }
  }

  deleteAlertDialog({
    required String title,
    required String desc,
    String? desc2,
    required Function onTap,
    required bool buttonLoader,
  }) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontFamily: 'Avenir',
        ),
      ),
      contentPadding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 10,
        bottom: 0,
      ),
      content: Column(
        children: [
          Text(
            desc,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          if (desc2 != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                desc2,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            )
        ],
      ),
      actionsPadding: const EdgeInsets.all(0.0),
      buttonPadding: const EdgeInsets.all(0.0),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                StringUtils.cancel.toUpperCase(),
              ),
            ),
            TextButton(
              onPressed: () => onTap.call(),
              child: buttonLoader
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Text(
                      "ok".toUpperCase(),
                    ),
            ),
          ],
        )
      ],
    );
  }
}
