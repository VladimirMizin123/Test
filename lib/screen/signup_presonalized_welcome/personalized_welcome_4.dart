import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class FourthPersonalizedWelcomeScreen extends StatelessWidget {
  const FourthPersonalizedWelcomeScreen(
      {super.key, this.gender = 'Male', this.isReady = true});
  final String gender;
  final bool isReady;

  final routeName = '/FourthPersonalizedWelcome';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final finalGetGender = Get.arguments;
    String btnText = isReady ? StringUtils.iAmReady : "Loading...";

    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: finalGetGender == 'Male'
                ? const AssetImage(AssetsUtils.malePersonalized4)
                : finalGetGender == 'Female'
                    ? const AssetImage(AssetsUtils.feMalePersonalized4)
                    : finalGetGender == 'Non-binary'
                        ? const AssetImage(AssetsUtils.nonPersonalized4)
                        : const AssetImage(AssetsUtils.nonPersonalized4),
            fit: BoxFit.cover,
          ),
        ),
        child: finalGetGender == 'Male'
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: SvgPicture.asset(
                        AssetsUtils.roundBlueLogo,
                        height: 95.h,
                        width: 95.w,
                        color: Colors.white,
                      ).paddingOnly(top: 70.h, left: 20.w),
                    ),
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
                              StringUtils.livingPresent,
                              textAlign: TextAlign.center,
                              style: textTheme.displayMedium
                                  ?.copyWith(color: Colors.white, height: 1.1),
                            ),
                          ],
                        )).paddingOnly(left: 20.w, right: 20.w, top: 120.h),
                    buildButton(
                      context: context,
                      bgColor: AppColors.primaryBlue,
                      onPressed: () {
                        if (isReady) {
                          Get.toNamed('/AppManagerScreen',
                              arguments: finalGetGender,
                              preventDuplicates: false);
                        }
                      },
                      textColor: AppColors.skyBlue,
                      title: btnText,
                      hasImage: false,
                    ).paddingOnly(
                        bottom: 10.h, right: 20.w, left: 20.w, top: 220.h),
                  ],
                ),
              )
            : finalGetGender == 'Female'
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
                                StringUtils.livingPresent,
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
                        ).paddingOnly(left: 20.w, top: 30.h),
                      ),
                      const Spacer(),
                      buildButton(
                        context: context,
                        bgColor: AppColors.terracotta,
                        onPressed: () {
                          if (isReady) {
                            Get.toNamed('/AppManagerScreen',
                                arguments: finalGetGender,
                                preventDuplicates: false);
                          }
                        },
                        textColor: AppColors.coral,
                        title: btnText,
                        hasImage: false,
                      ).paddingOnly(bottom: 20.h, right: 20.w, left: 20.w),
                    ],
                  )
                : finalGetGender == 'Non-binary'
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
                                    StringUtils.livingPresent,
                                    textAlign: TextAlign.center,
                                    style: textTheme.displayMedium?.copyWith(
                                        color: Colors.white, height: 1.1),
                                  ),
                                ],
                              )).paddingOnly(right: 20.w, left: 20.w),
                          buildButton(
                            context: context,
                            bgColor: AppColors.green,
                            onPressed: () {
                              if (isReady) {
                                Get.toNamed('/AppManagerScreen',
                                    arguments: finalGetGender,
                                    preventDuplicates: false);
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
                                    StringUtils.livingPresent,
                                    textAlign: TextAlign.center,
                                    style: textTheme.displayMedium?.copyWith(
                                        color: Colors.white, height: 1.1),
                                  ),
                                ],
                              )).paddingOnly(right: 20.w, left: 20.w),
                          buildButton(
                            context: context,
                            bgColor: AppColors.green,
                            onPressed: () {
                              if (isReady) {
                                Get.toNamed('/AppManagerScreen',
                                    arguments: finalGetGender,
                                    preventDuplicates: false);
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
