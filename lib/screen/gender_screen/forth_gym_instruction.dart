import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/constant/app_string.dart';

import '../../widget/app_widget.dart';

class FourthGymInstructionScreen extends StatelessWidget {
   FourthGymInstructionScreen({super.key});

  final routeName = '/FourthGymInstruction';
  final String gender = Get.arguments as String;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
          child: gender == AppStrings.male
              ? commonInstructionView(
                  context: context,
                  textTheme: textTheme,
                  header1: AppColors.bluePressed,
                  header2: AppColors.primaryBlue,
                  borderColor: AppColors.primaryBlue,
                  Bgcolor: AppColors.primaryBlue,
                  image: AppStrings.male_instrucion4,
                  textColor1: AppColors.primaryBlue,
                  textColor2: AppColors.skyBlue,
                )
              : gender == AppStrings.female
                  ? commonInstructionView(
                      context: context,
                      textTheme: textTheme,
                      header1: AppColors.terracottaPressed,
                      header2: AppColors.terracotta,
                      borderColor: AppColors.terracotta,
                      Bgcolor: AppColors.terracotta,
                      image: AppStrings.female_instrucion4,
                      textColor1: AppColors.terracotta,
                      textColor2: AppColors.coral,
                    )
                  : commonInstructionView(
                          context: context,
                          textTheme: textTheme,
                          header1: AppColors.greenPressed,
                          header2: AppColors.green,
                          borderColor: AppColors.green,
                          Bgcolor: AppColors.green,
                          image: AppStrings.non_instrucion4,
                          textColor1: AppColors.green,
                          textColor2: AppColors.mint,
                        )
                      ),
    );
  }

  Widget commonInstructionView(
      {TextTheme? textTheme,
      BuildContext? context,
      String? image,
      Color? header1,
      Color? header2,
      Color? borderColor,
      Color? Bgcolor,
      Color? textColor1,
      Color? textColor2}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.genderInstruction4,
          textAlign: TextAlign.center,
          style:
              textTheme?.headlineSmall?.copyWith(color: header1, height: 1.2),
        ).paddingOnly(top: 35.h, bottom: 16.h, left: 5.w, right: 5.w),
        Text(AppStrings.gendersubInstruction6,
                style: textTheme?.bodyLarge
                    ?.copyWith(color: header2, fontWeight: FontWeight.w400))
            .paddingOnly(bottom: 12.h, left: 10.w, right: 10.w),
        Text(AppStrings.gendersubInstruction7,
                style: textTheme?.bodyLarge
                    ?.copyWith(color: header2, fontWeight: FontWeight.w400))
            .paddingOnly(left: 10.w, right: 10.w),
        Center(
          child: Image.asset(
            image!,
            height: 365.h,
            width: 320.w,
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 163.w,
              child: buildBorderButton(
                context: context!,
                borderColor: borderColor!,
                bgColor: Colors.white,
                onPressed: () {Get.back();},
                title: AppStrings.previous,
                textColor: textColor1,
              ),
            ).paddingOnly(right: 10.w),
            SizedBox(
              width: 163.w,
              child: buildButton(
                context: context,
                hasImage: false,
                textColor: textColor2,
                title: AppStrings.next,
                onPressed: () {
                  Get.toNamed('/FiveGymInstructionScreen',arguments: gender );
                },
                bgColor: Bgcolor,
              ),
            )
          ],
        ).paddingOnly(bottom: 58.h),
      ],
    ).paddingSymmetric(horizontal: 10.w);
  }
}
