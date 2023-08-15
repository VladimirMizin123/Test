import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_string.dart';

class HomeScreenController extends GetxController {
  final fNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  List<String> chooseEatsList = [
    AppStrings.loseWeight,
    AppStrings.toneUp,
    AppStrings.gainLeanMuscle,
    AppStrings.healthyDiet,
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
}
