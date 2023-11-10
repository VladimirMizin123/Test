import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';

import '../../../constant/color_utils.dart';

Widget mapDetailWidget({
  String? title,
  String? initialValue,
  TextEditingController? textEditingController,
  String? Function(String?)? validator,
  bool readOnly = false,
  VoidCallback? onTap,
  Widget? suffixIcon,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      labelWidget(
        text: title,
        style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.darkGray,
            fontWeight: FontWeight.w300),
      ),
      SizedBox(
        height: 8.h,
      ),
      commonTextFormField(
        enableBorderColor: AppColors.disable,
        initialValue: initialValue,
        hintText: title ?? "",
        vertical: 10,
        obscureText: false,
        hintStyle: const TextStyle(),
        horizontal: 10,
        width: double.infinity,
        suffixIcon: suffixIcon,
        textEditingController: textEditingController,
        readOnly: readOnly,
        validator: validator,
        onTap: onTap,
      ),
    ],
  ).paddingOnly(top: 10.h);
}
