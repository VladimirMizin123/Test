import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class ThirdPersonalizedWelcomeScreen extends StatelessWidget {
  const ThirdPersonalizedWelcomeScreen(
      {super.key, this.chooseGender = 'Female'});

  final String chooseGender;
  final routeName = '/ThirdPersonalizedWelcome';

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
                ? const AssetImage(AppStrings.malePersonalized3)
                : chooseGender == 'Female'
                    ? const AssetImage(AppStrings.feMalePersonalized3)
                    : chooseGender == 'Non'
                        ? const AssetImage(AppStrings.nonPersonalized3)
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
                            AppStrings.neverUnderestimate,
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
                ? Column(
                    children: [
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
                                AppStrings.neverUnderestimate,
                                textAlign: TextAlign.center,
                                style: textTheme.displayMedium?.copyWith(
                                    color: Colors.white, height: 1.1),
                              ),
                            ],
                          )).paddingOnly(left: 20.w, right: 20.w, top: 35.h),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          AppStrings.roundBlueLogo,
                          height: 90.h,
                          width: 90.w,
                          color: Colors.white,
                        ).paddingOnly(left: 20.w),
                      ),
                      const Spacer(),
                      buildButton(
                        context: context,
                        bgColor: AppColors.terracotta,
                        onPressed: () {},
                        textColor: AppColors.coral,
                        title: AppStrings.iAmReady,
                        hasImage: false,
                      ).paddingOnly(bottom: 20.h, right: 20.w, left: 20.w),
                    ],
                  )
                : chooseGender == 'Non'
                    ? Column(
                        children: [
                          Image.asset(
                            AppStrings.gymEatsLogo,
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
                                        AppStrings.welcomeBack,
                                        style: textTheme.displayMedium
                                            ?.copyWith(color: Colors.white),
                                      ).paddingOnly(bottom: 10.h),
                                      Text(
                                        AppStrings.neverUnderestimate,
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
                            onPressed: () {},
                            textColor: AppColors.mint,
                            title: AppStrings.iAmReady,
                            hasImage: false,
                          ).paddingOnly(
                              bottom: 20.h, right: 20.w, left: 20.w, top: 10.h),
                        ],
                      )
                    : Container(),
      ),
    );
  }
}
