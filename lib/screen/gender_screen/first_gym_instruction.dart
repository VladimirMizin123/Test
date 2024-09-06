import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/network_image_widget.dart';

class FirstGymInstructionScreen extends StatelessWidget {
  FirstGymInstructionScreen({
    super.key,
  });

  final routeName = '/FirstGymInstructionScreen';
  final String gender = Get.arguments as String;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: gender == StringUtils.male
            ? commonInstructionView(
                context: context,
                imgList: AssetsUtils.dashboardBlue,
                bgColor: const Color(0xFF004C63),
                borderColor: const Color(0xFF004C63),
                header1: const Color(0xFF002E3B),
                header2: const Color(0xFF004C63),
                textColor1: const Color(0xFF004C63),
                textColor2: const Color(0xFFD9E9EE),
                textTheme: textTheme)
            : gender == StringUtils.female
                ? commonInstructionView(
                    context: context,
                    imgList: AssetsUtils.dashboardCoral,
                    bgColor: const Color(0xFFCE6B53),
                    borderColor: const Color(0xFFCE6B53),
                    header1: const Color(0xFFA55642),
                    header2: const Color(0xFFCE6B53),
                    textColor1: const Color(0xFFCE6B53),
                    textColor2: const Color(0xFFF9D5C5),
                    textTheme: textTheme)
                : commonInstructionView(
                    context: context,
                    imgList: AssetsUtils.dashboardGreen,
                    bgColor: const Color(0xFF336633),
                    borderColor: const Color(0xFF336633),
                    header1: const Color(0xFF1F3D1F),
                    header2: const Color(0xFF336633),
                    textColor1: const Color(0xFF336633),
                    textColor2: const Color(0xFFC1EACE),
                    textTheme: textTheme),
      ),
    );
  }

  Widget commonInstructionView({
    TextTheme? textTheme,
    BuildContext? context,
    Color? header1,
    Color? header2,
    Color? borderColor,
    Color? bgColor,
    Color? textColor1,
    Color? textColor2,
    List<String>? imgList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringUtils.genderInstruction1,
          textAlign: TextAlign.center,
          style: textTheme?.headlineSmall?.copyWith(color: header1),
        ).paddingOnly(top: 35.h, bottom: 16.h),
        Text(
          StringUtils.genderSubInstruction,
          textAlign: TextAlign.start,
          style: textTheme?.bodyLarge?.copyWith(
            color: header2,
            fontWeight: FontWeight.w400,
          ),
        ).paddingSymmetric(horizontal: 8.w),
        if (imgList?.isNotEmpty ?? false) ...[
          Align(
            child: NetworkImageWidget(
              url: imgList!.first,
              height: 80,
              width: context!.width * 0.8,
              fit: BoxFit.cover,
            ),
          ).paddingOnly(top: 15.h),
          SizedBox(height: 5.h),
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 275,
                width: 207,
                child: NetworkImageWidget(
                  url: imgList[1],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: -120,
                bottom: -50,
                child: SizedBox(
                  height: 228,
                  width: 171,
                  child: NetworkImageWidget(
                    url: imgList[2],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 45),
        Row(
          children: [
            SizedBox(
              width: 163.w,
              child: buildBorderButton(
                context: context!,
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
                  Get.toNamed('/SecondGymInstructionScreen', arguments: gender);
                },
                bgColor: bgColor,
              ),
            )
          ],
        ).paddingOnly(top: 16.h, bottom: 58.h),
      ],
    ).paddingSymmetric(horizontal: 10.w);
  }
}
