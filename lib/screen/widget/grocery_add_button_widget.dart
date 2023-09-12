import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

import '../../constant/font_utils.dart';

class GroceryAddButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFillColor;
  final String buttonLable;
  final int selectedItemCount;
  const GroceryAddButtonWidget({super.key, required this.onTap, required this.isFillColor, required this.buttonLable, required this.selectedItemCount});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
            width: double.infinity.w,
            height: 48.h,
            decoration: BoxDecoration(border: Border.all(color: AppColors.primaryBlue, width: 1), color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(AssetsUtils.icShoppingIcon),
                  Center(child: Text(buttonLable, style: FontUtils.h20(fontColor: AppColors.whiteColor, fontWeight: FWT.semiBold))),
                  Container(
                      height: screenSize.height * 0.04,
                      width: screenSize.height * 0.04,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.blueFocusedColor,
                      ),
                      child: Center(
                          child: Text(
                        selectedItemCount.toString(),
                        style: FontUtils.h18(fontColor: AppColors.whiteColor, fontWeight: FWT.semiBold),
                      ))),
                ],
              ),
            )),
      ),
    );
  }
}
