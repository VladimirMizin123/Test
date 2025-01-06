import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class ThirdPersonalizedWelcomeScreen extends StatelessWidget {
  const ThirdPersonalizedWelcomeScreen({
    super.key,
    this.gender = 'Male',
    this.isReady = true,
  });
  final String gender;
  final bool isReady;

  final routeName = '/ThirdPersonalizedWelcome';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final Gender = Get.arguments;
    String btnText = isReady ? StringUtils.iAmReady : "Loading...";

    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Gender == 'Male'
                ? const AssetImage(AssetsUtils.malePersonalized3)
                : Gender == 'Female'
                    ? const AssetImage(AssetsUtils.feMalePersonalized3)
                    : Gender == 'Non-binary'
                        ? const AssetImage(AssetsUtils.nonPersonalized3)
                        : const AssetImage(AssetsUtils.nonPersonalized3),
            fit: BoxFit.cover,
          ),
        ),
        child: Gender == 'Male'
            ? Column(
                children: [
                  Image.asset(
                    AssetsUtils.gymEatsLogo,
                    height: 60.h,
                    width: 168.w,
                    color: AppColors.primaryBlue,
                  ).paddingOnly(top: 35.h),
                  buildGymEatsHeader(
                      bgColor: Colors.transparent,
                      child: Column(
                        children: [
                          Text(
                            StringUtils.welcomeBack,
                            style: textTheme.displayMedium
                                ?.copyWith(color: AppColors.primaryBlue),
                          ).paddingOnly(bottom: 10.h),
                          Text(
                            StringUtils.neverUnderestimate,
                            textAlign: TextAlign.center,
                            style: textTheme.displayMedium?.copyWith(
                                color: AppColors.primaryBlue, height: 1.1),
                          ),
                        ],
                      )).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                  const Spacer(),
                  buildButton(
                    context: context,
                    bgColor: AppColors.primaryBlue,
                    onPressed: () {
                      if (isReady) {
                        Get.offAllNamed('/AppManagerScreen', arguments: gender);
                      }
                    },
                    textColor: AppColors.skyBlue,
                    title: btnText,
                    hasImage: false,
                  ).paddingOnly(bottom: 20.h, right: 20.w, left: 20.w),
                ],
              )
            : Gender == 'Female'
                ? Column(
                    children: [
                      buildGymEatsHeader(
                          bgColor: Colors.transparent,
                          child: Column(
                            children: [
                              Text(
                                StringUtils.welcomeBack,
                                style: textTheme.displayMedium
                                    ?.copyWith(color: Colors.white),
                              ).paddingOnly(bottom: 10.h),
                              Text(
                                StringUtils.neverUnderestimate,
                                textAlign: TextAlign.center,
                                style: textTheme.displayMedium?.copyWith(
                                    color: Colors.white, height: 1.1),
                              ),
                            ],
                          )).paddingOnly(left: 20.w, right: 20.w, top: 35.h),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          AssetsUtils.roundBlueLogo,
                          height: 90.h,
                          width: 90.w,
                          color: Colors.white,
                        ).paddingOnly(left: 20.w),
                      ),
                      const Spacer(),
                      buildButton(
                        context: context,
                        bgColor: AppColors.terracotta,
                        onPressed: () {
                          if (isReady) {
                            Get.offAllNamed('/AppManagerScreen',
                                arguments: gender);
                          }
                        },
                        textColor: AppColors.coral,
                        title: btnText,
                        hasImage: false,
                      ).paddingOnly(bottom: 20.h, right: 20.w, left: 20.w),
                    ],
                  )
                : Gender == 'Non-binary'
                    ? Column(
                        children: [
                          Image.asset(
                            AssetsUtils.gymEatsLogo,
                            height: 60.h,
                            width: 168.w,
                            color: AppColors.green,
                          ).paddingOnly(top: 35.h),
                          const Spacer(),
                          buildGymEatsHeader(
                                  bgColor: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Text(
                                        StringUtils.welcomeBack,
                                        style: textTheme.displayMedium
                                            ?.copyWith(color: Colors.white),
                                      ).paddingOnly(bottom: 10.h),
                                      Text(
                                        StringUtils.neverUnderestimate,
                                        textAlign: TextAlign.center,
                                        style: textTheme.displayMedium
                                            ?.copyWith(
                                                color: Colors.white,
                                                height: 1.1),
                                      ),
                                    ],
                                  ))
                              .paddingOnly(
                                  bottom: 10.h, right: 20.w, left: 20.w),
                          buildButton(
                            context: context,
                            bgColor: AppColors.green,
                            onPressed: () {
                              if (isReady) {
                                Get.offAllNamed('/AppManagerScreen',
                                    arguments: gender);
                              }
                            },
                            textColor: AppColors.mint,
                            title: btnText,
                            hasImage: false,
                          ).paddingOnly(
                              bottom: 20.h, right: 20.w, left: 20.w, top: 10.h),
                        ],
                      )
                    : Column(
                        children: [
                          Image.asset(
                            AssetsUtils.gymEatsLogo,
                            height: 60.h,
                            width: 168.w,
                            color: AppColors.green,
                          ).paddingOnly(top: 35.h),
                          const Spacer(),
                          buildGymEatsHeader(
                                  bgColor: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Text(
                                        StringUtils.welcomeBack,
                                        style: textTheme.displayMedium
                                            ?.copyWith(color: Colors.white),
                                      ).paddingOnly(bottom: 10.h),
                                      Text(
                                        StringUtils.neverUnderestimate,
                                        textAlign: TextAlign.center,
                                        style: textTheme.displayMedium
                                            ?.copyWith(
                                                color: Colors.white,
                                                height: 1.1),
                                      ),
                                    ],
                                  ))
                              .paddingOnly(
                                  bottom: 10.h, right: 20.w, left: 20.w),
                          buildButton(
                            context: context,
                            bgColor: AppColors.green,
                            onPressed: () {
                              if (isReady) {
                                Get.offAllNamed('/AppManagerScreen',
                                    arguments: gender);
                              }
                            },
                            textColor: AppColors.mint,
                            title: btnText,
                            hasImage: false,
                          ).paddingOnly(
                              bottom: 20.h, right: 20.w, left: 20.w, top: 10.h),
                        ],
                      ),
      ),
    );
  }
}
