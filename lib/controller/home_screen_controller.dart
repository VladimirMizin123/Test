import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../app/functions.dart';
import '../models/sign_up_data_navigate_model.dart';

class HomeScreenController extends GetxController {
  final fNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

  joinGymEatButton() async {
    if (fNameController.text.isEmpty) {
      showToast(message: StringUtils.pleaseEnterFirstName, isSuccess: false);
    } else if (lastNameController.text.isEmpty) {
      showToast(message: StringUtils.pleaseEnterLastName, isSuccess: false);
    } else if (emailController.text.isEmpty) {
      showToast(message: StringUtils.pleaseEnterEmail, isSuccess: false);
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
      UserSignUpDataModel userData = UserSignUpDataModel(
          firstName: fNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          password: passwordController.text,
          userName: emailController.text,
          confirmPassword: confirmPasswordController.text);
      final value =
          await Get.toNamed('/GoogleMapScreen', arguments: 'isFromRegister');

      print('==value===>${value}');

      userData.addAddressModel = value;
      Get.toNamed('/PremiumScreen', arguments: userData);
      /*fNameController.clear();
      lastNameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();*/
    }
  }
}
