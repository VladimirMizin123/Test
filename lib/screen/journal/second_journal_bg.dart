import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../constant/asset_utils.dart';
import '../../constant/string_utils.dart';

class SecondJournalBGView extends StatelessWidget {
  const SecondJournalBGView({super.key});

  final routeName = '/SecondJournalBGView';

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
            image: AssetImage(AssetsUtils.journalBG2),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sabrina', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                    Text('31 years old', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                    Text('27 lbs lost', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                  ],
                ).paddingOnly(top: 48.h, left: 20.w),
                Container(
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
                      style: textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            buildGymEatsHeader(
                bgColor: Colors.white.withOpacity(0.8),
                child: Column(
                  children: [
                    Text(
                      StringUtils.journalText2,
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium?.copyWith(color: AppColors.terracottaPressed, height: 1.2),
                    ).paddingSymmetric(horizontal: 5.w),
                    Text(
                      StringUtils.journalText3,
                      style: textTheme.displayMedium?.copyWith(color: AppColors.terracottaPressed),
                    ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                    Image.asset(
                      AssetsUtils.gymEatsSpoon,
                      height: 36.h,
                      width: 103.w,
                      color: AppColors.terracottaPressed,
                    ).paddingOnly(top: 5.h),
                  ],
                )).paddingOnly(bottom: 35.h, left: 20.w, right: 20.w),
          ],
        ),
      ),
    );
  }
}
