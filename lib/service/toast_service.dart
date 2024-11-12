import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/main.dart';

class ToastService {
  static FToast fToast = FToast();

  static init() {
    fToast.init(navigatorKey.currentContext!);
  }

  static Widget toast(String text,
      {bool isSuccess = false, Color? defaultColor}) {
    Color color = defaultColor ?? (isSuccess ? Colors.green : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: color),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 16,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static showToast(String text, {bool isSuccess = false, Color? defaultColor}) {
    cancel();
    fToast.showToast(
      child: toast(text, isSuccess: isSuccess, defaultColor: defaultColor),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  static cancel() {
    fToast.removeCustomToast();
  }
}
