import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';
import '../../../../constant/color_utils.dart';
import '../../../../widget/divider_widget.dart';

Widget unitScreenWidget({String? text, Widget? widget}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      labelWidget(
          text: text,
          style: TextStyle(
              color: AppColors.darkGray,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500)),
      SizedBox(
        height: 10.h,
      ),
      widget!,
    ],
  ).paddingOnly(left: 20.w, right: 20.w, bottom: 15.h);
}

Widget radioButtonWidget(
    {int? value1,
    int? value2,
    String? title1,
    String? title2,
    int? groupValue,
    // String? groupValue2,
    Function(int)? onChanged1,
    Function(int)? onChanged2}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.lightGreyColor, spreadRadius: 2, blurRadius: 1),
        ]),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title1!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            SizedBox(
              width: 17.w,
            ),
            Radio(
              activeColor: AppColors.primaryBlueColor,
              value: value1,
              groupValue: groupValue,
              onChanged: (value) => onChanged1!(value!),
            ),
          ],
        ),
        const DividerWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title2!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            SizedBox(
              width: 17.w,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.w),
              child: Radio(
                activeColor: AppColors.primaryBlueColor,
                value: value2,
                groupValue: groupValue,
                onChanged: (value) => onChanged2!(value!),
              ),
            ),
          ],
        ),
      ],
    ).paddingOnly(right: 20.w, left: 20.w),
  );
}
