import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/model/programs_info_model.dart';
import '../../../../constant/color_utils.dart';

Widget expandTileWidget({Widget? title, List<Widget>? children}) {
  return Container(
    margin: EdgeInsets.only(right: 14.w, left: 14.w),
    // height: 100,
    decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: AppColors.lightGreyColor, spreadRadius: 1, blurRadius: 2)
        ]),
    child: ExpansionTile(
      title: title!,
      children: children!,
    ),
  ).paddingOnly(top: 12.h);
}

Widget eatTabWidget({Crease? creaseData}) {
  return Container(
    padding: EdgeInsets.only(bottom: 10.h),
    width: double.infinity,
    child: Column(
      children: [
        const Divider(color: AppColors.darkGray),
        Text(creaseData?.description ?? StringUtils.eatMoreEagg,
            style: TextStyle(
                color: AppColors.middleGray,
                fontWeight: FontWeight.w300,
                fontSize: 14.sp)),
        // SizedBox(
        //   height: 8.h,
        // ),
        // const Row(
        //   children: [
        //     SvgImage(image: AssetsUtils.done, color: AppColors.middleGray),
        //     Text("Boiled eggs"),
        //   ],
        // ),
        // SizedBox(
        //   height: 2.h,
        // ),
        // const Row(
        //   children: [
        //     SvgImage(image: AssetsUtils.done, color: AppColors.middleGray),
        //     Text("Yolk"),
        //   ],
        // ),
        // SizedBox(
        //   height: 2.h,
        // ),
        // const Row(
        //   children: [
        //     SvgImage(image: AssetsUtils.done, color: AppColors.middleGray),
        //     Text("Quail egg"),
        //   ],
        // ),
        // SizedBox(
        //   height: 2.h,
        // ),
        // const Row(
        //   children: [
        //     SvgImage(image: AssetsUtils.done),
        //     Text("Egg whites"),
        //   ],
        // ),
      ],
    ).paddingOnly(left: 14.w, right: 14.w),
  );
}
