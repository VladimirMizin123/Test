import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class PurchaseOptions extends StatelessWidget {
  const PurchaseOptions({super.key, required this.month, required this.price, this.savePercentage, this.isSelected = false});

  final String price;
  final String? savePercentage;
  final String month;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: isSelected ? 120.w : 100.w,
      height: isSelected ? 132.h : 122.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isSelected ? AppColors.appColor : AppColors.disabledColor),
        color: Colors.white.withOpacity(0.95),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.appColor : AppColors.disabledColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            child: Center(
              child: Text(
                month,
                style: textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontSize: isSelected ? 18.sp : 16.sp,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$$price',
                style: textTheme.titleLarge!.copyWith(
                  fontSize: isSelected ? 24.sp : 18.sp,
                ),
              ).paddingAll(savePercentage != null ? 0.sp : 20.sp),
              if (savePercentage != null)
                Text(
                  'save over',
                  style: textTheme.bodySmall!.copyWith(
                    color: const Color(0xFF5F5F5F),
                  ),
                ),
              if (savePercentage != null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
                  // margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.letsEatButton : const Color(0xFFF9D5C5),
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                  child: Text(
                    '$savePercentage%',
                    style: textTheme.titleLarge!.copyWith(
                      color: isSelected ? const Color(0xFFF9D5C5) : AppColors.letsEatButton,
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
