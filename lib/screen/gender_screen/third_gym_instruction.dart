import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/network_image_widget.dart';

import '../../widget/app_widget.dart';

class ThirdGymInstructionScreen extends StatelessWidget {
  ThirdGymInstructionScreen({
    super.key,
  });

  final routeName = '/ThirdGymInstructionScreen';
  final String gender = Get.arguments as String;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
          child: gender == StringUtils.male
              ? commonInstructionView(
                  context: context,
                  textTheme: textTheme,
                  imgList: AssetsUtils.iResturantBlue,
                  header1: AppColors.bluePressed,
                  header2: AppColors.primaryBlue,
                  borderColor: AppColors.primaryBlue,
                  bgColor: AppColors.primaryBlue,
                  textColor1: AppColors.primaryBlue,
                  textColor2: AppColors.skyBlue,
                )
              : gender == StringUtils.female
                  ? commonInstructionView(
                      context: context,
                      textTheme: textTheme,
                      imgList: AssetsUtils.iResturantCoral,
                      header1: AppColors.terracottaPressed,
                      header2: AppColors.terracotta,
                      borderColor: AppColors.terracotta,
                      bgColor: AppColors.terracotta,
                      textColor1: AppColors.terracotta,
                      textColor2: AppColors.coral,
                    )
                  : commonInstructionView(
                      context: context,
                      textTheme: textTheme,
                      imgList: AssetsUtils.iResturantGreen,
                      header1: AppColors.greenPressed,
                      header2: AppColors.green,
                      borderColor: AppColors.green,
                      bgColor: AppColors.green,
                      textColor1: AppColors.green,
                      textColor2: AppColors.mint,
                    )),
    );
  }

  Widget commonInstructionView(
      {TextTheme? textTheme,
      BuildContext? context,
      List<String>? imgList,
      Color? header1,
      Color? header2,
      Color? borderColor,
      Color? bgColor,
      Color? textColor1,
      Color? textColor2}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringUtils.genderInstruction3,
          textAlign: TextAlign.center,
          style:
              textTheme?.headlineSmall?.copyWith(color: header1, height: 1.2),
        ).paddingOnly(top: 35.h, bottom: 16.h),
        Text(StringUtils.genderSubInstruction4,
                style: textTheme?.bodyLarge
                    ?.copyWith(color: header2, fontWeight: FontWeight.w400))
            .paddingOnly(bottom: 12.h, left: 10.w, right: 10.w),
        Text(StringUtils.genderSubInstruction5,
                style: textTheme?.bodyLarge
                    ?.copyWith(color: header2, fontWeight: FontWeight.w400))
            .paddingOnly(left: 10.w, right: 10.w, bottom: 12.h),
        Align(
          child: SizedBox(
            height: 80,
            child: NetworkImageWidget(
              url: imgList!.first,
              height: 80,
              width: context!.width * 0.8,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 275,
              width: 207,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: NetworkImageWidget(url: imgList[1], fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 60,
              right: -120,
              child: SizedBox(
                height: 100,
                width: 171,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: NetworkImageWidget(url: imgList[2], fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              top: 180,
              right: -120,
              child: SizedBox(
                height: 100,
                width: 171,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: NetworkImageWidget(url: imgList[3], fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 46),
        Row(
          children: [
            SizedBox(
              width: 163.w,
              child: buildBorderButton(
                context: context,
                borderColor: borderColor!,
                bgColor: Colors.white,
                onPressed: () {
                  Get.back();
                },
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
                onPressed: () {
                  Get.toNamed('/FourthGymInstructionScreen', arguments: gender);
                },
                bgColor: bgColor,
              ),
            )
          ],
        ).paddingOnly(bottom: 58.h),
      ],
    ).paddingSymmetric(horizontal: 10.w);
  }
}
