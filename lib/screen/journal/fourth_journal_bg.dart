import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../constant/asset_utils.dart';
import '../../constant/string_utils.dart';

class ForthJournalBGView extends StatelessWidget {
  const ForthJournalBGView({super.key});

  final routeName = '/ForthJournalBGView';

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
            image: AssetImage(AssetsUtils.journalBG4),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            buildGymEatsHeader(
                bgColor: Colors.white.withOpacity(0.8),
                child: Column(
                  children: [
                    Text(
                      StringUtils.journalText5,
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium
                          ?.copyWith(color: AppColors.green, height: 1.2),
                    ).paddingSymmetric(horizontal: 5.w),
                    Image.asset(
                      AssetsUtils.gymEatsSpoon,
                      height: 36.h,
                      width: 103.w,
                      color: AppColors.green,
                    ).paddingOnly(top: 10.h),
                  ],
                )).paddingOnly(top: 48.h, left: 20.w, right: 20.w),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: ()=>Get.back(),
                child: Container(
                  height: 40.h,
                  width: 75.w,
                  margin: EdgeInsets.only(right: 20.w),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.40),
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      StringUtils.skip,
                      style:
                          textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ).paddingOnly(bottom: 35.h),
          ],
        ),
      ),
    );
  }
}
