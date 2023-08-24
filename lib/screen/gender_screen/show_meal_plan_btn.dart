import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';

class ShowMealPlanBtnScreen extends StatelessWidget {
  const ShowMealPlanBtnScreen({super.key, this.chooseGender = 'Non'});

  final routeName = '/ShowMealPlanBtn';
  final String? chooseGender;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: bodyView(
        context: context,
        bgColor: chooseGender == 'Male'
            ? AppColors.primaryBlue
            : chooseGender == 'Female'
                ? AppColors.terracotta
                : chooseGender == 'Non'
                    ? AppColors.green
                    : Colors.black,
        textColor: chooseGender == 'Male'
            ? AppColors.skyBlue
            : chooseGender == 'Female'
                ? AppColors.coral
                : chooseGender == 'Non'
                    ? AppColors.mint
                    : Colors.black,
        image: chooseGender == 'Male'
            ? AssetsUtils.male_meal_Bg
            : chooseGender == 'Female'
                ? AssetsUtils.female_meal_Bg
                : chooseGender == 'Non'
                    ? AssetsUtils.non_meal_Bg
                    : '',
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
            StringUtils.allSet,
            textAlign: TextAlign.center,
            style: textTheme?.displayMedium?.copyWith(color: Colors.white),
          ).paddingOnly(top: 50.h),
          Text(
            StringUtils.checkMealPlan,
            textAlign: TextAlign.center,
            style: textTheme?.displayMedium?.copyWith(color: Colors.white),
          ).paddingOnly(top: 15.h),
          SvgPicture.asset(
            AssetsUtils.roundBlueLogo,
            color: Colors.white,
            height: 100.h,
            width: 100.w,
          ).paddingOnly(top: 250.h),
          buildButton(context: context, textColor: textColor, title: StringUtils.showMealBtnText, onPressed: () {}, bgColor: bgColor, hasImage: false).paddingOnly(top: 24.h, bottom: 20.h),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}
