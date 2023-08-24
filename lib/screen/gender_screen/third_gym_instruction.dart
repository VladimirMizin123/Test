import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';

import '../../widget/app_widget.dart';

class ThirdGymInstructionScreen extends StatelessWidget {
  const ThirdGymInstructionScreen({super.key, this.chooseGender = 'Non'});

  final String chooseGender;
  final routeName = '/ThirdGymInstruction';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
          child: chooseGender == 'Male'
              ? commonInstructionView(
                  context: context,
                  textTheme: textTheme,
                  header1: ColorUtils.bluePressed,
                  header2: ColorUtils.primaryBlue,
                  borderColor: ColorUtils.primaryBlue,
                  Bgcolor: ColorUtils.primaryBlue,
                  image: AssetsUtils.male_instrucion3,
                  textColor1: ColorUtils.primaryBlue,
                  textColor2: ColorUtils.skyBlue,
                )
              : chooseGender == 'Female'
                  ? commonInstructionView(
                      context: context,
                      textTheme: textTheme,
                      header1: ColorUtils.terracottaPressed,
                      header2: ColorUtils.terracotta,
                      borderColor: ColorUtils.terracotta,
                      Bgcolor: ColorUtils.terracotta,
                      image: AssetsUtils.female_instrucion3,
                      textColor1: ColorUtils.terracotta,
                      textColor2: ColorUtils.coral,
                    )
                  : chooseGender == 'Non'
                      ? commonInstructionView(
                          context: context,
                          textTheme: textTheme,
                          header1: ColorUtils.greenPressed,
                          header2: ColorUtils.green,
                          borderColor: ColorUtils.green,
                          Bgcolor: ColorUtils.green,
                          image: AssetsUtils.non_instrucion3,
                          textColor1: ColorUtils.green,
                          textColor2: ColorUtils.mint,
                        )
                      : const SizedBox()),
    );
  }

  Widget commonInstructionView({TextTheme? textTheme, BuildContext? context, String? image, Color? header1, Color? header2, Color? borderColor, Color? Bgcolor, Color? textColor1, Color? textColor2}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringUtils.gender_Instruction3,
          textAlign: TextAlign.center,
          style: textTheme?.headlineSmall?.copyWith(color: header1, height: 1.2),
        ).paddingOnly(top: 35.h, bottom: 16.h),
        Text(StringUtils.gender_subInstruction4, style: textTheme?.bodyLarge?.copyWith(color: header2, fontWeight: FontWeight.w400)).paddingOnly(bottom: 12.h, left: 10.w, right: 10.w),
        Text(StringUtils.gender_subInstruction5, style: textTheme?.bodyLarge?.copyWith(color: header2, fontWeight: FontWeight.w400)).paddingOnly(left: 10.w, right: 10.w, bottom: 12.h),
        Center(
          child: Image.asset(
            image!,
            height: 350.h,
            width: 328.w,
          ),
        ).paddingOnly(bottom: 27.h),
        Row(
          children: [
            SizedBox(
              width: 163.w,
              child: buildBorderButton(
                context: context!,
                borderColor: borderColor!,
                bgColor: Colors.white,
                onPressed: () {},
                title: StringUtils.previous,
                textColor: textColor1,
              ),
            ).paddingOnly(right: 10.w),
            SizedBox(
              width: 163.w,
              child: buildButton(
                context: context,
                hasImage: false,
                textColor: textColor2,
                title: StringUtils.next,
                onPressed: () {},
                bgColor: Bgcolor,
              ),
            )
          ],
        ).paddingOnly(bottom: 58.h),
      ],
    ).paddingSymmetric(horizontal: 10.w);
  }
}
