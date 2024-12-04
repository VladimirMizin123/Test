import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_1.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_2.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_3.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_4.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class RandomLoadingScreen extends StatefulWidget {
  const RandomLoadingScreen({super.key});

  @override
  State<RandomLoadingScreen> createState() => _RandomLoadingScreenState();
}

class _RandomLoadingScreenState extends State<RandomLoadingScreen> {
  final int randomNumber = Random().nextInt(3);
  final ApiServices api = ApiServices();
  RxBool isLoading = false.obs;

  @override
  void initState() {
    setupIngredients();
    super.initState();
  }

  Future<void> setupIngredients() async {
    try {
      isLoading.value = true;
      String id = PreferenceUtils.getString(prefUserData);
      await api.get(
          ApiUrls.addIngredientsToUserGroceryList.replaceAll("{userId}", id));
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? gender = 'Male';
    if (Get.arguments.runtimeType == String) {
      gender = Get.arguments;
    }

    return Obx(
      () => switch (randomNumber) {
        0 => FirstPersonalizedWelcomeScreen(
            gender: gender.toString().capitalizeFirst ?? 'Male',
            isReady: !isLoading.value,
          ),
        1 => SecondPersonalizedWelcomeScreen(
            gender: gender.toString().capitalizeFirst ?? 'Male',
            isReady: !isLoading.value,
          ),
        2 => ThirdPersonalizedWelcomeScreen(
            gender: gender.toString().capitalizeFirst ?? 'Male',
            isReady: !isLoading.value,
          ),
        _ => FourthPersonalizedWelcomeScreen(
            gender: gender.toString().capitalizeFirst ?? 'Male',
            isReady: !isLoading.value,
          ),
      },
    );
  }
}
