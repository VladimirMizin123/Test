import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key, this.gender = 'Non'});

  final String gender;

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final routeName = '/GenderScreen';

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
            image: widget.gender == 'Male'
                ? const AssetImage(AssetsUtils.maleBG)
                : widget.gender == 'Female'
                    ? const AssetImage(AssetsUtils.femaleBG)
                    : widget.gender == 'Non'
                        ? const AssetImage(AssetsUtils.nonGenderBG)
                        : const AssetImage('AppStrings.mindyBG'),
            fit: BoxFit.fill,
          ),
        ),
        child: widget.gender == 'Male'
            ? ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    StringUtils.maleHeader,
                    textAlign: TextAlign.center,
                    style: textTheme.displayLarge!.copyWith(color: const Color(0xFF004C63), letterSpacing: -0.8, fontWeight: FontWeight.w800),
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
                    onPressed: () {},
                    textColor: const Color(0xFFD9E9EE),
                    title: StringUtils.lestItBetter,
                    hasImage: false,
                  ).paddingOnly(bottom: 10.h, right: 20.w, left: 20.w, top: 365.h),
                ],
              )
            : widget.gender == 'Female'
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        StringUtils.femaleHeader,
                        textAlign: TextAlign.center,
                        style: textTheme.displayLarge!.copyWith(color: const Color(0xFFCE6B53), letterSpacing: -0.8, fontWeight: FontWeight.w800),
                      ).paddingOnly(top: 20.h),
                      Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AssetsUtils.roundBlueLogo,
                          height: 120.h,
                          width: 120.w,
                          color: Color(0xFFCE6B53),
                        ).paddingOnly(top: 24.h, right: 20.w),
                      ),
                      const Spacer(),
                      buildButton(
                        context: context,
                        bgColor: const Color(0xFFCE6B53),
                        onPressed: () {},
                        textColor: const Color(0xFFF9D5C5),
                        title: StringUtils.lestItBetter,
                        hasImage: false,
                      ).paddingOnly(bottom: 10.h, right: 20.w, left: 20.w, top: 365.h),
                    ],
                  )
                : widget.gender == 'Non'
                    ? ListView(
                        shrinkWrap: true,
                        children: [
                          Text(
                            StringUtils.mindy,
                            textAlign: TextAlign.center,
                            style: textTheme.displayLarge!.copyWith(color: const Color(0xFF336633), letterSpacing: -0.8, fontWeight: FontWeight.w800),
                          ).paddingOnly(top: 25.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SvgPicture.asset(
                              AssetsUtils.roundBlueLogo,
                              height: 96.h,
                              width: 96.w,
                              color: Color(0xFF336633),
                            ).paddingOnly(top: 25.h, right: 20.w),
                          ),
                          const Spacer(),
                          buildButton(
                            context: context,
                            bgColor: const Color(0xFF336633),
                            onPressed: () {},
                            textColor: const Color(0xFFD9E9EE),
                            title: StringUtils.lestItBetter,
                            hasImage: false,
                          ).paddingOnly(bottom: 10.h, right: 20.w, left: 20.w, top: 380.h),
                        ],
                      )
                    : Container(),
      ),
    );
  }
}
