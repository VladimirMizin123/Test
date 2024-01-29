import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:gymeats_mobile/models/get_survey_model.dart';
import 'package:intl/intl.dart';
import '../constant/string_utils.dart';
import '../constant/color_utils.dart';

Color setColor({required String gender}) {
  if (gender == StringUtils.male) {
    return AppColors.primaryBlue;
  } else if (gender == StringUtils.female) {
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

bool validateConfirmPassword(password, confirmPassword) {
  if (password != confirmPassword) {
    return false;
  }
  return true;
}

bool validatePassword(String password) {
  if (password.length < 8) {
    return false;
  }
  return true;
}

bool validateStrongPassword(String strongPassword) {
  RegExp regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (!regExp.hasMatch(strongPassword)) {
    return false;
  }
  return true;
}

String dateTimeNow() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  return formattedDate;
}

String dateTimeYYYYMMDD({required String dateTimeVal}) {
  DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(dateTimeVal);
  String formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);
  return formattedDate;
}

String dateTimeDDMMMYYYY({required String dateTimeVal}) {
  DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(dateTimeVal);
  String formattedDate = DateFormat("dd MMM yyyy").format(dateTime);
  return formattedDate;
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}
