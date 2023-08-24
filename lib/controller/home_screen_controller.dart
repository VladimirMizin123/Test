import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class HomeScreenController extends GetxController {
  final fNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  List<String> chooseEatsList = [
    StringUtils.loseWeight,
    StringUtils.toneUp,
    StringUtils.gainLeanMuscle,
    StringUtils.healthyDiet,
  ];

  List<bool> selectedItems = [];

  void selectEats(int index) {
    selectedItems[index] = !selectedItems[index];
    update();
  }

  @override
  void onInit() {
    super.onInit();
    selectedItems = List.generate(chooseEatsList.length, (index) => false);
  }

  //Apple Sign In
  Future<void> appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print(credential.email);
    } catch (e) {
      print("Error:- " + e.toString());
    }
  }
}
