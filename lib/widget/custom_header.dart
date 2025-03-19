import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';

class CustomTopHeader extends StatelessWidget {
  const CustomTopHeader({
    super.key,
    this.ignoreHPadding = false,
    required this.title,
  });
  final bool ignoreHPadding;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AssetsUtils.gymEatsLogo,
          height: 20.h,
          width: 56.w,
          color: AppColors.primaryBlue,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 19,
                color: AppColors.darkGray,
              ),
            ),
            Text(title, style: FontUtils.h20(fontColor: AppColors.oxFF010101)),
            const SizedBox(),
          ],
        ).paddingSymmetric(horizontal: ignoreHPadding ? 0 : 15, vertical: 5.h),
      ],
    );
  }
}
