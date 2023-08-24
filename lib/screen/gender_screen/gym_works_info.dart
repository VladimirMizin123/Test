import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_string.dart';

import '../../widget/app_widget.dart';

class GymWorkInfoScreen extends StatefulWidget {
  const GymWorkInfoScreen({super.key,});


  @override
  State<GymWorkInfoScreen> createState() => _GymWorkInfoScreenState();
}

class _GymWorkInfoScreenState extends State<GymWorkInfoScreen> {
  final routeName = '/GymWorkInfo';
  String gender = Get.arguments as String;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: gender == AppStrings.male
                ? const AssetImage(AppStrings.maleBG2)
                : gender == AppStrings.female
                    ? const AssetImage(AppStrings.femaleBG2)
                    : const AssetImage(AppStrings.nonGenderBG2),
            fit: BoxFit.cover,
          ),
        ),
        child: gender == AppStrings.male
            ? ListView(
                shrinkWrap: true,
                children: [
                  Image.asset(
                    AppStrings.gymEatsLogo,
                    color: Colors.white,
                    height: 55.h,
                    width: 175.w,
                  ).paddingOnly(bottom: 25.h, top: 10.h),
                  Container(
                    width: 335.w,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.header1,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF004C63)),
                          ).paddingOnly(bottom: 15.h),
                          Text(
                            AppStrings.header2,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF004C63)),
                          ).paddingOnly(bottom: 15.h),
                          Text(
                            AppStrings.header3,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF004C63)),
                          ).paddingOnly(),
                        ],
                      ).paddingOnly(
                          left: 12.w, right: 12.w, top: 15.h, bottom: 15.h),
                    ),
                  ).paddingOnly(bottom: 36.h, top: 180.h),
                  buildButton(
                    context: context,
                    bgColor: const Color(0xFF004C63),
                    onPressed: () {
                      Get.toNamed('/GymInstructionScreen',arguments: gender );
                    },
                    textColor: const Color(0xFFD9E9EE),
                    title: AppStrings.gymWorkText,
                    hasImage: false,
                  ).paddingOnly(bottom: 10.h, right: 20.w, left: 20.w),
                ],
              )
            : gender == AppStrings.female
                ? ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SvgPicture.asset(
                        AppStrings.roundBlueLogo,
                        color: Colors.white,
                        height: 100.h,
                        width: 100.w,
                      ).paddingOnly(bottom: 25.h),
                      Container(
                        width: 335.w,
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.header1,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFC58575)),
                              ).paddingOnly(bottom: 15.h),
                              Text(
                                AppStrings.header2,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFC58575)),
                              ).paddingOnly(bottom: 15.h),
                              Text(
                                AppStrings.header3,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFC58575)),
                              ).paddingOnly(),
                            ],
                          ).paddingOnly(
                              left: 12.w, right: 12.w, top: 15.h, bottom: 15.h),
                        ),
                      ).paddingOnly(bottom: 36.h, top: 135.h),
                      buildButton(
                        context: context,
                        bgColor: const Color(0xFFCE6B53),
                        onPressed: () {
                          Get.toNamed('/GymInstructionScreen',arguments: gender );
                        },
                        textColor: const Color(0xFFF9D5C5),
                        title: AppStrings.gymWorkText,
                        hasImage: false,
                      ).paddingOnly(bottom: 50.h, right: 20.w, left: 20.w),
                    ],
                  )
                :  ListView(
                        children: [
                          SvgPicture.asset(
                            AppStrings.roundBlueLogo,
                            color: Colors.white,
                            height: 100.h,
                            width: 100.w,
                          ).paddingOnly(bottom: 25.h, top: 130.h),
                          Container(
                            width: 335.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.header1,
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF336633)),
                                  ).paddingOnly(bottom: 15.h),
                                  Text(
                                    AppStrings.header2,
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF336633)),
                                  ).paddingOnly(bottom: 15.h),
                                  Text(
                                    AppStrings.header3,
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF336633)),
                                  ).paddingOnly(),
                                ],
                              ).paddingOnly(
                                  left: 12.w,
                                  right: 12.w,
                                  top: 15.h,
                                  bottom: 15.h),
                            ),
                          ).paddingOnly(bottom: 36.h),
                          buildButton(
                            context: context,
                            bgColor: const Color(0xFF336633),
                            onPressed: () {
                              Get.toNamed('/GymInstructionScreen',arguments: gender );
                            },
                            textColor: const Color(0xFFD9E9EE),
                            title: AppStrings.gymWorkText,
                            hasImage: false,
                          ).paddingOnly(bottom: 50.h, right: 20.w, left: 20.w),
                        ],
                      ).paddingOnly(left: 20.w, right: 20.w)
        ,
      ),
    );
  }
}
