import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final routeName = '/GenderScreen';
  dynamic argument = Get.arguments;
  String gender = Get.arguments.gender.toString();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: gender == StringUtils.male
                ? const AssetImage(AssetsUtils.maleBG)
                : gender == StringUtils.female
                    ? const AssetImage(AssetsUtils.femaleBG)
                    : const AssetImage(AssetsUtils.nonGenderBG),
            fit: BoxFit.fill,
          ),
        ),
        child: gender == StringUtils.male
            ? Column(
                children: [
                  Text(
                    '${argument == null ? '' : argument.firstName}, you did it!',
                    textAlign: TextAlign.center,
                    style: textTheme.displayLarge!.copyWith(
                        color: const Color(0xFF004C63),
                        letterSpacing: -0.8,
                        fontWeight: FontWeight.w800),
                  ).paddingOnly(top: 40.h),
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AssetsUtils.roundBlueLogo,
                      height: 100.h,
                      width: 100.w,
                    ).paddingOnly(top: 25.h, right: 20.w),
                  ),
                  const Spacer(),
                  buildButton(
                    context: context,
                    bgColor: const Color(0xFF004C63),
                    onPressed: () {
                      Get.toNamed('/GymWorkInfoScreen', arguments: gender);
                    },
                    textColor: const Color(0xFFD9E9EE),
                    title: StringUtils.lestItBetter,
                    hasImage: false,
                  ).paddingOnly(
                      bottom: 10.h, right: 20.w, left: 20.w, top: 365.h),
                ],
              )
            : gender == StringUtils.female
                ? Column(
                    //shrinkWrap: true,
                    children: [
                      Text(
                        '${argument.firstName}, you did it!',
                        textAlign: TextAlign.center,
                        style: textTheme.displayLarge!.copyWith(
                            color: const Color(0xFFCE6B53),
                            letterSpacing: -0.8,
                            fontWeight: FontWeight.w800),
                      ).paddingOnly(top: 20.h),
                      Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(AssetsUtils.roundBlueLogo,
                                height: 120.h,
                                width: 120.w,
                                colorFilter: const ColorFilter.mode(
                                    Color(0xFFCE6B53), BlendMode.srcIn))
                            .paddingOnly(top: 24.h, right: 20.w),
                      ),
                      const Spacer(),
                      buildButton(
                        context: context,
                        bgColor: const Color(0xFFCE6B53),
                        onPressed: () {
                          Get.toNamed('/GymWorkInfoScreen', arguments: gender);
                        },
                        textColor: const Color(0xFFF9D5C5),
                        title: StringUtils.lestItBetter,
                        hasImage: false,
                      ).paddingOnly(
                          bottom: 10.h, right: 20.w, left: 20.w, top: 365.h),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        '${argument.firstName}, you did it!',
                        textAlign: TextAlign.center,
                        style: textTheme.displayLarge!.copyWith(
                            color: const Color(0xFF336633),
                            letterSpacing: -0.8,
                            fontWeight: FontWeight.w800),
                      ).paddingOnly(top: 25.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(AssetsUtils.roundBlueLogo,
                                height: 96.h,
                                width: 96.w,
                                colorFilter: const ColorFilter.mode(
                                    Color(0xFF336633), BlendMode.srcIn))
                            .paddingOnly(top: 25.h, right: 20.w),
                      ),
                      const Spacer(),
                      buildButton(
                        context: context,
                        bgColor: const Color(0xFF336633),
                        onPressed: () {
                          Get.toNamed('/GymWorkInfoScreen', arguments: gender);
                        },
                        textColor: const Color(0xFFD9E9EE),
                        title: StringUtils.lestItBetter,
                        hasImage: false,
                      ).paddingOnly(
                          bottom: 10.h, right: 20.w, left: 20.w, top: 380.h),
                    ],
                  ),
      ),
    );
  }
}
