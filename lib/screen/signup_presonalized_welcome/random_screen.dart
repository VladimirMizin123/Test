import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_1.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_2.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_3.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_4.dart';

class RandomLoadingScreen extends StatelessWidget {
  RandomLoadingScreen({super.key});
  final int randomNumber = Random().nextInt(3);

  @override
  Widget build(BuildContext context) {
    final String? gender = Get.arguments;
    return randomNumber == 0
        ? FirstPersonalizedWelcomeScreen(
            gender: gender ?? 'Male',
          )
        : randomNumber == 1
            ? SecondPersonalizedWelcomeScreen(
                gender: gender ?? 'Male',
              )
            : randomNumber == 2
                ? ThirdPersonalizedWelcomeScreen(
                    gender: gender ?? 'Male',
                  )
                : FourthPersonalizedWelcomeScreen(
                    gender: gender ?? 'Male',
                  );
  }
}
