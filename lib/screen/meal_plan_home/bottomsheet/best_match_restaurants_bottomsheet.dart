import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';

class BestMatchRestaurantsBottomSheet extends StatelessWidget {
  const BestMatchRestaurantsBottomSheet({super.key});

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
              'See Best Matches',
              style: FontUtils.h22(fontColor: AppColors.darkGray, fontWeight: FWT.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 76, 99, 0.08), blurRadius: 5, spreadRadius: 2)],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      AssetsUtils.defaultImage,
                                      height: screenSize.height * 0.22,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   child: SizedBox(
                                //     height: 60.h,
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         Text('mealDescription' ?? '', overflow: TextOverflow.ellipsis, maxLines: 2, style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.regular)),
                                //         Text('mealCal' ?? '', style: FontUtils.h14(fontColor: AppColors.letsEatButton, fontWeight: FWT.lightMedium)),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(width: 10),
                                // Container(
                                //   height: 20.h,
                                //   width: 20.w,
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                                //   ),
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Container(
                                //         decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryBlue),
                                //         height: 14.h,
                                //         width: 14.w,
                                //       ),
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
