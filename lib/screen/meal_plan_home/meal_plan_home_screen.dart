import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class MealPlanHomeScreen extends StatefulWidget {
  const MealPlanHomeScreen({super.key});

  @override
  State<MealPlanHomeScreen> createState() => _MealPlanHomeScreenState();
}

class _MealPlanHomeScreenState extends State<MealPlanHomeScreen> {
  final routeName = '/MealPlanHomeScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height.h,
          width: size.width.w,
          child: Column(
            children: [
              Image.asset(
                AppStrings.gymEatsLogo,
                height: 20.h,
                width: 56.w,
                color: AppColors.primaryBlue,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AppStrings.user,
                    height: 25.h,
                    width: 25.w,
                    color: AppColors.darkGray,
                  ),
                  Text(
                    AppStrings.mealPlan,
                    style: textTheme.displayMedium
                        ?.copyWith(color: const Color(0xFF010101)),
                  ),
                  Image.asset(
                    AppStrings.filter,
                    height: 25.h,
                    width: 25.w,
                    color: AppColors.darkGray,
                  )
                ],
              ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
              Divider(color: AppColors.darkGray, height: 5.h),
              Text(
                AppStrings.showGroceryList,
                style: textTheme.headlineSmall
                    ?.copyWith(color: AppColors.primaryBlue),
              ).paddingSymmetric(vertical: 8.h),
              Container(
                color: Colors.grey.withOpacity(0.05),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Day 1',
                      style: textTheme.headlineSmall
                          ?.copyWith(color: AppColors.middleGray),
                    ),
                    Wrap(
                      children: [
                        arrowButton(icon: AppStrings.arrowBack)
                            .paddingOnly(right: 5.w),
                        arrowButton(icon: AppStrings.arrowForward),
                      ],
                    )
                  ],
                ),
              ),
              /* ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return mealPlanCard();
                },
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
