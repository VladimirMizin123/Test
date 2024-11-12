import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/asset_utils.dart';

Widget privacyTitleWidget({Widget? widget}) {
  return Stack(
    children: [
      Container(
        height: 220.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetsUtils.lightBlueBackGroundImage),
              fit: BoxFit.fill),
        ),
      ),
      Positioned(
        // top: 20.h,
        child: widget!,
      ),
    ],
  );
}

Widget bulletPointWidget({String? text}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('\u2022',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
          )),
      SizedBox(width: 10.w),
      Expanded(
        child: Text(
          text!,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          softWrap: true,
        ),
      ),
    ],
  ).paddingOnly(left: 7.w, bottom: 10.h);
}

Widget contactFooter() {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: "GYM EATS\n",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: "Email: sales@gymeats.net\n",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: "Address: 15610 South 70th Court Orland Park, Il 60462",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
