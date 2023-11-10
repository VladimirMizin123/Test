import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../app/functions.dart';

class HomeScreenController extends GetxController {
  final fNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();

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
      print("Error:- $e");
    }
  }

  Future<bool?> joinGymEatButton() async {
    if (fNameController.text.isEmpty) {
      showToast(message: StringUtils.pleaseEnterFirstName, isSuccess: false);
    } else if (lastNameController.text.isEmpty) {
      showToast(message: StringUtils.pleaseEnterLastName, isSuccess: false);
    } else if (emailController.text.isEmpty) {
      showToast(message: StringUtils.pleaseEnterEmail, isSuccess: false);
    } else if (phoneNumberController.text.isEmpty ||
        phoneNumberController.text.length != 10) {
      showToast(
          message: StringUtils.pleaseEnterValidPhoneNumber, isSuccess: false);
    } else if (!validateEmail(emailController.text)) {
      showToast(message: StringUtils.enterValidEmail, isSuccess: false);
    } else if (passwordController.text.isEmpty) {
      showToast(message: StringUtils.pleaseEnterPassword, isSuccess: false);
    } else if (!validatePassword(passwordController.text)) {
      showToast(
          message: StringUtils.pleaseEnterPasswordValidation, isSuccess: false);
    } else if (!validateStrongPassword(passwordController.text)) {
      showToast(
          message: StringUtils.pleaseEnterStrongPasswordValidation,
          isSuccess: false);
    } else if (confirmPasswordController.text.isEmpty) {
      showToast(
          message: StringUtils.pleaseEnterConfirmPassword, isSuccess: false);
    } else if (!validateConfirmPassword(
        passwordController.text, confirmPasswordController.text)) {
      showToast(message: StringUtils.passwordNotMatch, isSuccess: false);
    } else {
      return true;
    }
    return null;
  }
}
