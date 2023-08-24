import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
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
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height.h,
          width: size.width.w,
          child: Column(
            children: [
              Image.asset(
                AssetsUtils.gymEatsLogo,
                height: 20.h,
                width: 56.w,
                color: AppColors.primaryBlue,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AssetsUtils.user,
                    height: 25.h,
                    width: 25.w,
                    color: AppColors.darkGray,
                  ),
                  Text(StringUtils.mealPlan, style: FontUtils.h20(fontColor: AppColors.oxFF010101)),
                  Image.asset(
                    AssetsUtils.filter,
                    height: 20.h,
                    width: 20.w,
                    color: AppColors.darkGray,
                  )
                ],
              ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
              Divider(color: AppColors.darkGray, height: 3.h),
              Text(StringUtils.showGroceryList, style: FontUtils.h18(fontColor: AppColors.primaryBlue, fontWeight: FWT.medium)).paddingSymmetric(vertical: 10.h),
              Container(
                color: Colors.grey.withOpacity(0.05),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Day 1',
                      style: FontUtils.h20(fontColor: AppColors.middleGray, fontWeight: FWT.medium),
                    ),
                    Wrap(
                      children: [
                        arrowButton(icon: AssetsUtils.arrowBack).paddingOnly(right: 8.w),
                        arrowButton(icon: AssetsUtils.arrowForward),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return mealPlanCard(mealTitle: 'Breakfast', mealDescription: 'Smoked Mackerel Salad With Fennel And Apple', mealCal: '421 cal', context: context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
