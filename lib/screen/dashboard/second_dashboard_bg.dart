import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/models/exercise_log_details_model.dart';
import 'package:gymeats_mobile/screen/dashboard/add_entry_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import '../../constant/asset_utils.dart';
import '../../constant/string_utils.dart';

class SecondDashBoardView extends StatelessWidget {
  const SecondDashBoardView({super.key});

  final routeName = '/second-dashboard';

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
            image: AssetImage(AssetsUtils.dashBoardBG2),
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
                    StringUtils.dashBoardText2,
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
                        'Rebekah - 37 years old',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: AppColors.terracotta),
                      )
                    ],
                  ).paddingOnly(top: 10.h)
                ],
              ).paddingOnly(left: 5.w, right: 5.w),
            ).paddingOnly(left: 20.w, right: 20.w, top: 48.h),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: (){
                  Get.toNamed('/AddEntryScreen',arguments: AddEntryArguments(isFromHistory: false,exerciseLogList: ExerciseLogList()))!.then((value) {
                    Get.back(result: value);
                  });
                },
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
                      'Skip',
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
