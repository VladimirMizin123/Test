import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class SkipMealBottomSheet extends StatefulWidget {
  const SkipMealBottomSheet({super.key});

  @override
  State<SkipMealBottomSheet> createState() => _SkipMealBottomSheetState();
}

class _SkipMealBottomSheetState extends State<SkipMealBottomSheet> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      color: AppColors.whiteColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 3.h,
                    width: 80.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.disable),
                  )),
              const SizedBox(height: 10),
              SvgPicture.asset(AssetsUtils.icQuestionMarkIcon),
              const SizedBox(height: 15),
              Text(
                StringUtils.doYouWantToSkipMeal,
                style: FontUtils.h20(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  simpleTextBorderButton(
                      height: screenSize.height * 0.05,
                      width: screenSize.width * 0.43,
                      context: context,
                      buttonLable: StringUtils.cancel,
                      onTap: () {
                        Get.back();
                      },
                      isDarkColor: true),
                  simpleTextBorderButton(
                    height: screenSize.height * 0.05,
                    width: screenSize.width * 0.43,
                    context: context,
                    buttonLable: StringUtils.skip,
                    onTap: () {},
                    isDarkColor: true,
                    isFillColor: true,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Image.asset(
                AssetsUtils.gymEatsLogo,
                height: 20.h,
                width: 56.w,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
