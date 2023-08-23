import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class FourthPersonalizedWelcomeScreen extends StatelessWidget {
  const FourthPersonalizedWelcomeScreen(
      {super.key, this.chooseGender = 'Female'});

  final String chooseGender;
  final routeName = '/FourthPersonalizedWelcome';

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
                ? const AssetImage(AppStrings.malePersonalized4)
                : chooseGender == 'Female'
                    ? const AssetImage(AppStrings.feMalePersonalized4)
                    : chooseGender == 'Non'
                        ? const AssetImage(AppStrings.nonPersonalized4)
                        : const AssetImage('AppStrings.mindyBG'),
            fit: BoxFit.cover,
          ),
        ),
        child: chooseGender == 'Male'
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
                              AppStrings.livingPresent,
                              textAlign: TextAlign.center,
                              style: textTheme.displayMedium
                                  ?.copyWith(color: Colors.white, height: 1.1),
                            ),
                          ],
                        )).paddingOnly(left: 20.w, right: 20.w, top: 120.h),
                    buildButton(
                      context: context,
                      bgColor: AppColors.primaryBlue,
                      onPressed: () {},
                      textColor: AppColors.skyBlue,
                      title: AppStrings.iAmReady,
                      hasImage: false,
                    ).paddingOnly(
                        bottom: 10.h, right: 20.w, left: 20.w, top: 220.h),
                  ],
                ),
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
                                AppStrings.livingPresent,
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
                        ).paddingOnly(left: 20.w, top: 30.h),
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
                                    AppStrings.livingPresent,
                                    textAlign: TextAlign.center,
                                    style: textTheme.displayMedium?.copyWith(
                                        color: Colors.white, height: 1.1),
                                  ),
                                ],
                              )).paddingOnly(right: 20.w, left: 20.w),
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
