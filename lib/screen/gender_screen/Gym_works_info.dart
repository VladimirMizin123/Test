import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';

import '../../widget/app_widget.dart';

class GymWorkInfoScreen extends StatefulWidget {
  const GymWorkInfoScreen({super.key, this.chooseGender = 'Non'});

  final String? chooseGender;

  @override
  State<GymWorkInfoScreen> createState() => _GymWorkInfoScreenState();
}

class _GymWorkInfoScreenState extends State<GymWorkInfoScreen> {
  final routeName = '/GymWorkInfo';

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
            image: widget.chooseGender == 'Male'
                ? const AssetImage(AssetsUtils.maleBG2)
                : widget.chooseGender == 'Female'
                    ? const AssetImage(AssetsUtils.femaleBG2)
                    : widget.chooseGender == 'Non'
                        ? const AssetImage(AssetsUtils.nonGenderBG2)
                        : const AssetImage('AppStrings.mindyBG2'),
            fit: BoxFit.cover,
          ),
        ),
        child: widget.chooseGender == 'Male'
            ? ListView(
                shrinkWrap: true,
                children: [
                  Image.asset(
                    AssetsUtils.gymEatsLogo,
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
                            StringUtils.header1,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFF004C63)),
                          ).paddingOnly(bottom: 15.h),
                          Text(
                            StringUtils.header2,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFF004C63)),
                          ).paddingOnly(bottom: 15.h),
                          Text(
                            StringUtils.header3,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFF004C63)),
                          ).paddingOnly(),
                        ],
                      ).paddingOnly(left: 12.w, right: 12.w, top: 15.h, bottom: 15.h),
                    ),
                  ).paddingOnly(bottom: 36.h, top: 180.h),
                  buildButton(
                    context: context,
                    bgColor: const Color(0xFF004C63),
                    onPressed: () {
                      Get.toNamed('/GymWorkInfo');
                    },
                    textColor: const Color(0xFFD9E9EE),
                    title: StringUtils.gymWorkText,
                    hasImage: false,
                  ).paddingOnly(bottom: 10.h, right: 20.w, left: 20.w),
                ],
              )
            : widget.chooseGender == 'Female'
                ? ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SvgPicture.asset(
                        AssetsUtils.roundBlueLogo,
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
                                StringUtils.header1,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFFC58575)),
                              ).paddingOnly(bottom: 15.h),
                              Text(
                                StringUtils.header2,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFFC58575)),
                              ).paddingOnly(bottom: 15.h),
                              Text(
                                StringUtils.header3,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFFC58575)),
                              ).paddingOnly(),
                            ],
                          ).paddingOnly(left: 12.w, right: 12.w, top: 15.h, bottom: 15.h),
                        ),
                      ).paddingOnly(bottom: 36.h, top: 135.h),
                      buildButton(
                        context: context,
                        bgColor: const Color(0xFFCE6B53),
                        onPressed: () {
                          Get.toNamed('/GymWorkInfo');
                        },
                        textColor: const Color(0xFFF9D5C5),
                        title: StringUtils.gymWorkText,
                        hasImage: false,
                      ).paddingOnly(bottom: 50.h, right: 20.w, left: 20.w),
                    ],
                  )
                : widget.chooseGender == 'Non'
                    ? ListView(
                        children: [
                          SvgPicture.asset(
                            AssetsUtils.roundBlueLogo,
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
                                    StringUtils.header1,
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFF336633)),
                                  ).paddingOnly(bottom: 15.h),
                                  Text(
                                    StringUtils.header2,
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFF336633)),
                                  ).paddingOnly(bottom: 15.h),
                                  Text(
                                    StringUtils.header3,
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: Color(0xFF336633)),
                                  ).paddingOnly(),
                                ],
                              ).paddingOnly(left: 12.w, right: 12.w, top: 15.h, bottom: 15.h),
                            ),
                          ).paddingOnly(bottom: 36.h),
                          buildButton(
                            context: context,
                            bgColor: const Color(0xFF336633),
                            onPressed: () {
                              Get.toNamed('/GymWorkInfo');
                            },
                            textColor: const Color(0xFFD9E9EE),
                            title: StringUtils.gymWorkText,
                            hasImage: false,
                          ).paddingOnly(bottom: 50.h, right: 20.w, left: 20.w),
                        ],
                      ).paddingOnly(left: 20.w, right: 20.w)
                    : const SizedBox(),
      ),
    );
  }
}
