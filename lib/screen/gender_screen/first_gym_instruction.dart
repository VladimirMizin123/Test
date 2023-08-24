import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class GymInstructionScreen extends StatelessWidget {
  const GymInstructionScreen({super.key, this.chooseGender = 'Female'});

  final String chooseGender;
  final routeName = '/GymInstruction';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: chooseGender == 'Male'
            ? commonInstructionView(context: context, image: AssetsUtils.male_instrucion1, Bgcolor: const Color(0xFF004C63), borderColor: const Color(0xFF004C63), header1: const Color(0xFF002E3B), header2: const Color(0xFF004C63), textColor1: const Color(0xFF004C63), textColor2: const Color(0xFFD9E9EE), textTheme: textTheme)
            : chooseGender == 'Female'
                ? commonInstructionView(context: context, image: AssetsUtils.female_instrucion1, Bgcolor: const Color(0xFFCE6B53), borderColor: const Color(0xFFCE6B53), header1: const Color(0xFFA55642), header2: const Color(0xFFCE6B53), textColor1: const Color(0xFFCE6B53), textColor2: const Color(0xFFF9D5C5), textTheme: textTheme)
                : chooseGender == 'Non'
                    ? commonInstructionView(context: context, image: AssetsUtils.non_instrucion1, Bgcolor: const Color(0xFF336633), borderColor: const Color(0xFF336633), header1: const Color(0xFF1F3D1F), header2: const Color(0xFF336633), textColor1: const Color(0xFF336633), textColor2: const Color(0xFFC1EACE), textTheme: textTheme)
                    : const SizedBox(),
      ),
    );
  }

  Widget commonInstructionView({TextTheme? textTheme, BuildContext? context, String? image, Color? header1, Color? header2, Color? borderColor, Color? Bgcolor, Color? textColor1, Color? textColor2}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringUtils.gender_Instruction1,
          textAlign: TextAlign.center,
          style: textTheme?.headlineSmall?.copyWith(color: header1),
        ).paddingOnly(top: 35.h, bottom: 16.h),
        Text(
          StringUtils.gender_subInstruction,
          textAlign: TextAlign.start,
          style: textTheme?.bodyLarge?.copyWith(
            color: header2,
            fontWeight: FontWeight.w400,
          ),
        ).paddingSymmetric(horizontal: 8.w),
        Image.asset(
          image!,
          height: 350.h,
          width: 350.w,
        ).paddingOnly(top: 15.h),
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
        ).paddingOnly(top: 16.h, bottom: 58.h),
      ],
    ).paddingSymmetric(horizontal: 10.w);
  }
}
