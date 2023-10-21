import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../constant/asset_utils.dart';
import '../../constant/string_utils.dart';

class RestaurantBGView extends StatelessWidget {
  const RestaurantBGView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return Future(
          () => false,
        );
      },
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetsUtils.journalBG7),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RestaurantScreen(),
                        ),
                        (route) => false);
                  },
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
                        StringUtils.skip,
                        style: textTheme.headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              buildGymEatsHeader(
                  bgColor: Colors.white.withOpacity(0.8),
                  child: Column(
                    children: [
                      Image.asset(
                        AssetsUtils.gymEatsSpoon,
                        height: 44.h,
                        width: 126.w,
                        color: AppColors.primaryBlue,
                      ).paddingOnly(bottom: 3.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(height: 1.1),
                          children: [
                            TextSpan(
                              text: StringUtils.eatingBetter,
                              style: textTheme.displayMedium!.copyWith(
                                  color: AppColors.primaryBlue,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900),
                            ),
                            TextSpan(
                              text: StringUtils.evenBetter,
                              style: textTheme.displayMedium!.copyWith(
                                  color: AppColors.primaryBlue,
                                  fontSize: 22.sp),
                            ),
                          ],
                        ),
                      ).paddingSymmetric(vertical: 8.h),
                      Text(
                        StringUtils.inviteFrd,
                        textAlign: TextAlign.center,
                        style: textTheme.displayMedium?.copyWith(
                            color: AppColors.primaryBlue, height: 1.2),
                      ).paddingSymmetric(horizontal: 5.w),
                    ],
                  )).paddingOnly(left: 20.w, right: 20.w),
              buildButton(
                      context: context,
                      title: StringUtils.inviteFriend,
                      textColor: Colors.white,
                      onPressed: () {},
                      bgColor: AppColors.primaryBlue,
                      hasImage: false)
                  .paddingOnly(bottom: 35.h, left: 20.w, right: 20.w, top: 10.h)
            ],
          ),
        ),
      ),
    );
  }
}
