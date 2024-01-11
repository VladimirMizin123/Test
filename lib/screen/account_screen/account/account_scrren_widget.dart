import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/asset_utils.dart';
import '../../../constant/color_utils.dart';
import '../../../widget/back_button_widget.dart';

Widget AccountTitleWidget({Widget? widget, String? title}) {
  return Container(
    // color: Colors.grey,
    // height: 328.h,
    // height: height,
    child: Stack(
      children: [
        Container(
          height: 220.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsUtils.lightBlueBackGroundImage),
                fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 40.w,
                    child: const BackButtonWidget(),
                  ),
                  Text(
                    title!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                ],
              ),
              SizedBox(
                height: 23.h,
              ),
              Container(
                height: 35.h,
                width: 95.h,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AssetsUtils.gymEatsSpoon),
                        fit: BoxFit.fill)),
              ),
            ],
          ).paddingOnly(top: 25.h, left: 20.w, right: 20.w, bottom: 10.h),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Positioned(top: 20, child: widget!),
            widget!,
          ],
        )
      ],
    ),
  );
}

Widget accountScreenListWidget({List<Widget>? children}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.grey.shade200, spreadRadius: 1),
      ],
    ),
    child: Column(
      children: children!,
    ).paddingOnly(top: 5.h),
  );
}

Widget accountScreenDataWidget(
    {Widget? leading,
    Widget? title,
    Widget? trailing,
    Color? color,
    Function()? onTap}) {
  return GestureDetector(
    onTap: onTap!,
    child: Column(
      children: [
        ListTile(leading: leading, title: title, trailing: trailing),
        Divider(
          color: color,
          thickness: 1.2,
          height: 4,
        ).paddingOnly(left: 18.w, right: 18.w),
      ],
    ),
  );
}
