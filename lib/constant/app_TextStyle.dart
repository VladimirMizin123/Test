import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';

class AppTextStyle {
  static TextStyle butttonTextStyle = TextStyle(
    color: AppColors.appColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle gymEatsStyle = TextStyle(
      color: Colors.green,
      fontSize: 24.sp,
      fontWeight: FontWeight.w400,
      height: 0);
}
