import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class SecondPersonalizedWelcomeScreen extends StatelessWidget {
  const SecondPersonalizedWelcomeScreen(
      {super.key, this.chooseGender = 'Female'});

  final String chooseGender;
  final routeName = '/SecondPersonalizedWelcome';

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
            opacity: chooseGender == 'Female' ? 0.9 : 1.0,
            image: chooseGender == 'Male'
                ? const AssetImage(AppStrings.malePersonalized2)
                : chooseGender == 'Female'
                    ? const AssetImage(AppStrings.feMalePersonalized2)
                    : chooseGender == 'Non'
                        ? const AssetImage(AppStrings.nonPersonalized2)
                        : const AssetImage('AppStrings.mindyBG'),
            fit: BoxFit.cover,
          ),
        ),
        child: chooseGender == 'Male'
            ? Column(
                children: [
                  Image.asset(
                    AppStrings.gymEatsLogo,
                    height: 60.h,
                    width: 168.w,
                    color: AppColors.primaryBlue,
                  ).paddingOnly(top: 35.h),
                  buildGymEatsHeader(
                      bgColor: Colors.transparent,
                      child: Column(
                        children: [
                          Text(
                            AppStrings.welcomeBack,
                            style: textTheme.displayMedium
                                ?.copyWith(color: AppColors.primaryBlue),
                          ).paddingOnly(bottom: 10.h),
                          Text(
                            AppStrings.eachMeal,
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
                    onPressed: () {},
                    textColor: AppColors.skyBlue,
                    title: AppStrings.iAmReady,
                    hasImage: false,
                  ).paddingOnly(bottom: 20.h, right: 20.w, left: 20.w),
                ],
              )
            : chooseGender == 'Female'
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: SvgPicture.asset(
                            AppStrings.roundBlueLogo,
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
                                  AppStrings.welcomeBack,
                                  style: textTheme.displayMedium
                                      ?.copyWith(color: Colors.white),
                                ).paddingOnly(bottom: 10.h),
                                Text(
                                  AppStrings.eachMeal,
                                  textAlign: TextAlign.center,
                                  style: textTheme.displayMedium?.copyWith(
                                      color: Colors.white, height: 1.1),
                                ),
                              ],
                            )).paddingOnly(left: 20.w, right: 20.w, top: 110.h),
                        buildButton(
                          context: context,
                          bgColor: AppColors.terracotta,
                          onPressed: () {},
                          textColor: AppColors.coral,
                          title: AppStrings.iAmReady,
                          hasImage: false,
                        ).paddingOnly(
                            bottom: 10.h, right: 20.w, left: 20.w, top: 210.h),
                      ],
                    ),
                  )
                : chooseGender == 'Non'
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              AppStrings.gymEatsLogo,
                              height: 60.h,
                              width: 168.w,
                              color: AppColors.green,
                            ).paddingOnly(top: 35.h),
                            buildGymEatsHeader(
                                    bgColor: Colors.white.withOpacity(0.8),
                                    child: Column(
                                      children: [
                                        Text(
                                          AppStrings.welcomeBack,
                                          style: textTheme.displayMedium
                                              ?.copyWith(
                                                  color: AppColors.green),
                                        ).paddingOnly(bottom: 10.h),
                                        Text(
                                          AppStrings.eachMeal,
                                          textAlign: TextAlign.center,
                                          style: textTheme.displayMedium
                                              ?.copyWith(
                                                  color: AppColors.green,
                                                  height: 1.1),
                                        ),
                                      ],
                                    ))
                                .paddingOnly(
                                    bottom: 10.h,
                                    right: 20.w,
                                    left: 20.w,
                                    top: 370.h),
                            buildButton(
                              context: context,
                              bgColor: AppColors.green,
                              onPressed: () {},
                              textColor: AppColors.mint,
                              title: AppStrings.iAmReady,
                              hasImage: false,
                            ).paddingOnly(
                                bottom: 10.h,
                                right: 20.w,
                                left: 20.w,
                                top: 10.h),
                          ],
                        ),
                      )
                    : Container(),
      ),
    );
  }
}
