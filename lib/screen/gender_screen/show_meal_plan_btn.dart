import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_string.dart';

class ShowMealPlanBtnScreen extends StatelessWidget {
   ShowMealPlanBtnScreen({super.key});

  final routeName = '/ShowMealPlanBtn';
  final String gender = Get.arguments as String;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: bodyView(
        context: context,
        bgColor: gender == AppStrings.male
            ? AppColors.primaryBlue
            : gender == AppStrings.female
                ? AppColors.terracotta
                :AppColors.green
                   ,
        textColor: gender == AppStrings.male
            ? AppColors.skyBlue
            : gender ==AppStrings.female
                ? AppColors.coral
                : AppColors.mint
                    ,
        image: gender == AppStrings.male
            ? AppStrings.male_meal_Bg
            : gender ==AppStrings.female
                ? AppStrings.female_meal_Bg
                : AppStrings.non_meal_Bg,
        textTheme: textTheme,
      ),
    );
  }

  Widget bodyView({
    BuildContext? context,
    String? image,
    Color? bgColor,
    TextTheme? textTheme,
    Color? textColor,
  }) {
    final size = MediaQuery.of(context!).size;
    return Container(
      height: size.height.h,
      width: size.width.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image.toString()),
          fit: BoxFit.fill,
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            AppStrings.allSet,
            textAlign: TextAlign.center,
            style: textTheme?.displayMedium?.copyWith(color: Colors.white),
          ).paddingOnly(top: 50.h),
          Text(
            AppStrings.checkMealPlan,
            textAlign: TextAlign.center,
            style: textTheme?.displayMedium?.copyWith(color: Colors.white),
          ).paddingOnly(top: 15.h),
          SvgPicture.asset(
            AppStrings.roundBlueLogo,
            color: Colors.white,
            height: 100.h,
            width: 100.w,
          ).paddingOnly(top: 250.h),
          buildButton(
                  context: context,
                  textColor: textColor,
                  title: AppStrings.showMealBtnText,
                  onPressed: () {},
                  bgColor: bgColor,
                  hasImage: false)
              .paddingOnly(top: 24.h, bottom: 20.h),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}
