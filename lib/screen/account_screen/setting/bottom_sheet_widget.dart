import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';

Widget bottomSheetWidget({Widget? buttonWidget}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 4.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: AppColors.disabledColor,
                  borderRadius: BorderRadius.circular(20.w),
                ),
              ),
              SizedBox(
                height: 13.h,
              ),
              SvgImage(image: AssetsUtils.questionRounded),
              SizedBox(
                height: 10.h,
              ),
              Text(
                StringUtils.deleteAccount,
                style: TextStyle(
                    fontSize: 24.sp,
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ).paddingOnly(top: 5.h),
      SizedBox(
        height: 20.h,
      ),
      Text(
        StringUtils.deleteAccountInfo,
        style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.darkGray,
            fontWeight: FontWeight.w300),
      ),
      SizedBox(
        height: 20.h,
      ),
      buttonWidget!,
    ],
  ).paddingOnly(right: 26.w, left: 26.w);
}
