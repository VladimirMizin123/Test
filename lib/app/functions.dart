import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:gymeats_mobile/models/get_survey_model.dart';

import '../constant/app_colors.dart';
import '../constant/app_string.dart';

Color setColor({required String gender}) {
  if (gender == AppStrings.male) {
    return AppColors.primaryBlue;
  } else if (gender == AppStrings.female) {
    return AppColors.terracotta;
  } else {
    return AppColors.green;
  }
}

int countOptions(SurveyDataQuestion surveyData) {
  int count = surveyData.options!.length;

  for (var nestedOption in surveyData.options!) {
    count += countOptions(nestedOption as SurveyDataQuestion);
  }

  return count;
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

bool validateConfirmPassword(password,confirmPassword) {
  if (password != confirmPassword) {
    return false;
  }
  return true;
}

bool validatePassword(String password) {
  if (password.length <= 8) {
    return false;
  }
  return true;
}








