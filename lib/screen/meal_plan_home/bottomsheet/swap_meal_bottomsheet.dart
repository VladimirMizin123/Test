import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class SwapMealBottomSheet extends StatefulWidget {
  const SwapMealBottomSheet({super.key});

  @override
  State<SwapMealBottomSheet> createState() => _SwapMealBottomSheetState();
}

class _SwapMealBottomSheetState extends State<SwapMealBottomSheet> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      color: AppColors.whiteColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.center,
                child: Container(
                  height: 3.h,
                  width: 80.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.disable),
                )),
            const SizedBox(height: 15),
            Text(
             StringUtils.swapMeal,
              style: FontUtils.h22(fontColor: AppColors.darkGray, fontWeight: FWT.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: swapMealCard(
                          mealTitle: 'Breakfast',
                          mealDescription: 'Smoked Mackerel Salad With Fennel And Apple',
                          mealCal: '421 cal',
                          context: context,
                        ),
                      );
                    }),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: simpleTextBorderButton(
                    context: context,
                    buttonLable: StringUtils.back,
                    height: screenSize.height * 0.055,
                    width: screenSize.width * 0.85,
                    onTap: () {
                      Get.back();
                    },
                    isDarkColor: true)),
          ],
        ),
      ),
    );
  }
}
