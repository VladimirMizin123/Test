import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    style: style?.copyWith(color: Colors.black),
  );
}

Widget commonTextFormField({
  String? hintText,
  double? vertical,
  double? horizontal,
  double? width,
  bool obscureText = false,
  Widget? suffixIcon,
  TextStyle? style,
  String? initialValue,
  Color? enableBorderColor,
  TextStyle? hintStyle,
  TextEditingController? textEditingController,
  bool readOnly = false,
  String? Function(String?)? validator,
  VoidCallback? onTap,
  TextInputType? textInputType,
  List<TextInputFormatter>? inputFormatters,
}) {
  return SizedBox(
    // width: 140.w,
    width: width,
    child: TextFormField(
      validator: validator,
      readOnly: readOnly,
      initialValue: initialValue,
      controller: textEditingController,
      style: style,
      obscureText: obscureText,
      cursorColor: AppColors.primaryBlueColor,
      keyboardType: textInputType,
      onTap: onTap,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintStyle: hintStyle,
        contentPadding:
            EdgeInsets.symmetric(vertical: vertical!, horizontal: horizontal!),
        hintText: hintText,
        errorMaxLines: 2,
        errorStyle: TextStyle(
          color: AppColors.errorRedColor,
          fontFamily: 'Avenir',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: enableBorderColor!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.w,
          ),
        ),
      ),
    ),
  );
}
