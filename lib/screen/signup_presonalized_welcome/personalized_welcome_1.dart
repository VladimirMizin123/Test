import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class FirstPersonalizedWelcomeScreen extends StatelessWidget {
  const FirstPersonalizedWelcomeScreen({super.key, this.chooseGender = 'Female'});

  final String chooseGender;
  final routeName = '/FirstPersonalizedWelcome';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: chooseGender == 'Male'
                ? const AssetImage(AssetsUtils.malePersonalized1)
                : chooseGender == 'Female'
                    ? const AssetImage(AssetsUtils.feMalePersonalized1)
                    : chooseGender == 'Non'
                        ? const AssetImage(AssetsUtils.nonPersonalized1)
                        : const AssetImage('AppStrings.mindyBG'),
            fit: BoxFit.cover,
          ),
        ),
        child: chooseGender == 'Male'
            ? Column(
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    AssetsUtils.roundBlueLogo,
                    height: 100.h,
                    width: 100.w,
                  ),
                  buildGymEatsHeader(
                      bgColor: Colors.white.withOpacity(0.8),
                      child: Column(
                        children: [
                          Text(
                            StringUtils.welcomeBack,
                            style: textTheme.displayMedium?.copyWith(color: AppColors.primaryBlue),
                          ).paddingOnly(bottom: 10.h),
                          Text(
                            StringUtils.readyToStep,
                            textAlign: TextAlign.center,
                            style: textTheme.displayMedium?.copyWith(color: AppColors.primaryBlue, height: 1.1),
                          ),
                        ],
                      )).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                  buildButton(
                    context: context,
                    bgColor: AppColors.primaryBlue,
                    onPressed: () {},
                    textColor: AppColors.skyBlue,
                    title: StringUtils.iAmReady,
                    hasImage: false,
                  ).paddingOnly(bottom: 20.h, right: 20.w, left: 20.w),
                ],
              )
            : chooseGender == 'Female'
                ? Column(
                    children: [
                      const Spacer(),
                      SvgPicture.asset(
                        AssetsUtils.roundBlueLogo,
                        height: 100.h,
                        width: 100.w,
                        color: Colors.white,
                      ),
                      buildGymEatsHeader(
                          bgColor: Colors.white.withOpacity(0.8),
                          child: Column(
                            children: [
                              Text(
                                StringUtils.welcomeBack,
                                style: textTheme.displayMedium?.copyWith(color: AppColors.terracotta),
                              ).paddingOnly(bottom: 10.h),
                              Text(
                                StringUtils.readyToStep,
                                textAlign: TextAlign.center,
                                style: textTheme.displayMedium?.copyWith(color: AppColors.terracotta, height: 1.1),
                              ),
                            ],
                          )).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                      buildButton(
                        context: context,
                        bgColor: AppColors.terracotta,
                        onPressed: () {},
                        textColor: AppColors.coral,
                        title: StringUtils.iAmReady,
                        hasImage: false,
                      ).paddingOnly(bottom: 20.h, right: 20.w, left: 20.w),
                    ],
                  )
                : chooseGender == 'Non'
                    ? Column(
                        children: [
                          Image.asset(
                            AssetsUtils.gymEatsLogo,
                            height: 60.h,
                            width: 168.w,
                            color: Colors.white,
                          ).paddingOnly(top: 35.h),
                          buildGymEatsHeader(
                              bgColor: Colors.white.withOpacity(0.8),
                              child: Column(
                                children: [
                                  Text(
                                    StringUtils.welcomeBack,
                                    style: textTheme.displayMedium?.copyWith(color: AppColors.green),
                                  ).paddingOnly(bottom: 10.h),
                                  Text(
                                    StringUtils.readyToStep,
                                    textAlign: TextAlign.center,
                                    style: textTheme.displayMedium?.copyWith(color: AppColors.green, height: 1.1),
                                  ),
                                ],
                              )).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                          const Spacer(),
                          buildButton(
                            context: context,
                            bgColor: AppColors.green,
                            onPressed: () {},
                            textColor: AppColors.mint,
                            title: StringUtils.iAmReady,
                            hasImage: false,
                          ).paddingOnly(bottom: 20.h, right: 20.w, left: 20.w),
                        ],
                      )
                    : Container(),
      ),
    );
  }
}
