import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

Widget profileDataWidget({String? text, TextStyle? style, Widget? widget}) {
  return Row(
    children: [
      Expanded(child: labelWidget(text: text, style: style)),
      // SizedBox(width: 100.w),
      widget!,
    ],
  ).paddingOnly(top: 6.h, bottom: 6.h);
}

Widget labelWidget({String? text, TextStyle? style}) {
  return Text(
    text!,
    style: style,
  );
}

Widget commonTextFormField(
    {String? hintText,
    double? vertical,
    double? horizontal,
    double? width,
    bool obscureText = false,
    Widget? suffixIcon,
    TextStyle? hintStyle}) {
  return SizedBox(
    // width: 140.w,
    width: width,
    child: TextFormField(
      obscureText: obscureText,
      cursorColor: AppColors.primaryBlueColor,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintStyle: hintStyle,
        contentPadding:
            EdgeInsets.symmetric(vertical: vertical!, horizontal: horizontal!),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryBlueColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryBlueColor),
        ),
      ),
    ),
  );
}
