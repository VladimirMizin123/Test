import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class PurchaseOptions extends StatelessWidget {
  const PurchaseOptions({
    super.key,
    required this.month,
    required this.price,
    this.savePercentage,
    this.isSelected = false,
    this.onTap,
  });

  final String price;
  final String? savePercentage;
  final String month;
  final bool isSelected;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        width: isSelected ? 120 : 100,
        height: isSelected ? 132 : 122,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: isSelected ? AppColors.appColor : AppColors.disabledColor),
          color: Colors.white.withOpacity(0.95),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppColors.appColor : AppColors.disabledColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.r),
                  topRight: Radius.circular(6.r),
                ),
              ),
              child: Center(
                child: Text(
                  month,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                    fontSize: isSelected ? 18.sp : 16.sp,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    price,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                      fontSize: isSelected ? 24.sp : 18.sp,
                    ),
                  ),
                  if (savePercentage != null) ...[
                    Text(
                      'save over',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF5F5F5F),
                      ),
                    ),
                  ],
                  if (savePercentage != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.r),
                      height: 30,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.letsEatButton
                            : const Color(0xFFF9D5C5),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        '$savePercentage%',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge!.copyWith(
                          color: isSelected
                              ? const Color(0xFFF9D5C5)
                              : AppColors.letsEatButton,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
