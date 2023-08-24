import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class ThirdDashBoardView extends StatelessWidget {
  const ThirdDashBoardView({super.key});

  final routeName = '/third-dashboard';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppStrings.dashBoardBG3),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 40.h,
                width: 75.w,
                margin: EdgeInsets.only(top: 48.h, right: 20.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.40),
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    'Skip',
                    style:
                        textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            const Spacer(),
            buildGymEatsHeader(
                bgColor: Colors.white.withOpacity(0.8),
                child: Column(
                  children: [
                    Text(
                      AppStrings.dashBoardText3,
                      style: textTheme.bodyLarge
                          ?.copyWith(color: AppColors.terracotta),
                    ).paddingSymmetric(horizontal: 5.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AppStrings.gymEatsSpoon,
                          height: 23.h,
                          width: 65.w,
                          color: AppColors.terracotta,
                        ),
                        Text(
                          'Sheanne - 31 years old',
                          style: textTheme.bodyLarge
                              ?.copyWith(color: AppColors.terracotta),
                        )
                      ],
                    ).paddingOnly(top: 10.h, left: 5.w, right: 5.w)
                  ],
                )).paddingOnly(bottom: 30.h, left: 20.w, right: 20.w),
          ],
        ),
      ),
    );
  }
}
