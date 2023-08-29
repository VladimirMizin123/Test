import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../constant/asset_utils.dart';
import '../../constant/string_utils.dart';

class FirstDashBoardView extends StatelessWidget {
  const FirstDashBoardView({super.key});

  final routeName = '/first-dashboard';

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
            image: AssetImage(AssetsUtils.dashBoardBG),
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
                      StringUtils.dashBoardText,
                      style: textTheme.bodyLarge
                          ?.copyWith(color: AppColors.terracotta),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AssetsUtils.gymEatsSpoon,
                          height: 23.h,
                          width: 65.w,
                          color: AppColors.terracotta,
                        ),
                        Text(
                          'Jill - 38 years old',
                          style: textTheme.bodyLarge
                              ?.copyWith(color: AppColors.terracotta),
                        )
                      ],
                    ).paddingOnly(top: 10.h)
                  ],
                )).paddingOnly(bottom: 30.h, left: 20.w, right: 20.w),
          ],
        ),
      ),
    );
  }
}
