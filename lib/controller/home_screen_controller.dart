import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/sign_up_data_navigate_model.dart';
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
  final referralCode = TextEditingController();

  List<bool> selectedItems = [];

  void selectEats(int index) {
    selectedItems = selectedItems.map((e) => false).toList();
    selectedItems[index] = !selectedItems[index];
    update();
  }

  Map<String, dynamic>? argumentData;

  void initRegister(dynamic data) {
    if (data is Map) {
      argumentData = data as Map<String, dynamic>;
      Map<String, dynamic> requestData = data;
      emailController.text = requestData["email"] ?? "";
    }
  }

  @override
  void onInit() {
    super.onInit();
    selectedItems = List.generate(dialGoalList.length, (index) => false);
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

  Future<bool?> joinGymEatButton(bool alreadyCreated) async {
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
    } else if (passwordController.text.isEmpty && !alreadyCreated) {
      showToast(message: StringUtils.pleaseEnterPassword, isSuccess: false);
    } else if (!validatePassword(passwordController.text) && !alreadyCreated) {
      showToast(
          message: StringUtils.pleaseEnterPasswordValidation, isSuccess: false);
    } else if (!validateStrongPassword(passwordController.text) &&
        !alreadyCreated) {
      showToast(
          message: StringUtils.pleaseEnterStrongPasswordValidation,
          isSuccess: false);
    } else if (confirmPasswordController.text.isEmpty && !alreadyCreated) {
      showToast(
          message: StringUtils.pleaseEnterConfirmPassword, isSuccess: false);
    } else if (!validateConfirmPassword(
            passwordController.text, confirmPasswordController.text) &&
        !alreadyCreated) {
      showToast(message: StringUtils.passwordNotMatch, isSuccess: false);
    } else {
      return true;
    }
    return null;
  }

  Future<void> continueRegister() async {
    UserSignUpDataModel userData = UserSignUpDataModel(
      firstName: fNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: Get.arguments?["password"],
      userName: emailController.text,
      confirmPassword: Get.arguments?["password"],
      phoneNumber: phoneNumberController.text,
      userId: Get.arguments?["userId"],
      referralCode: referralCode.text,
    );
    print('here');

    await Get.toNamed('/GoogleMapScreen', arguments: {
      "string": 'isFromRegister',
      "alreadyPurchase": Get.arguments?['hasPurchase'],
      "userData": userData
    });
  }
}
