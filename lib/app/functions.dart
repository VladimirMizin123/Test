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

int countOptions(SurveyData surveyData) {
  int count = surveyData.options!.length;

  for (var nestedOption in surveyData.options!) {
    count += countOptions(nestedOption as SurveyData);
  }

  return count;
}







