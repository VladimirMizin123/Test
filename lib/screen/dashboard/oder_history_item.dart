import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';

class OrderHistoryItem extends StatelessWidget {
  const OrderHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height.h,
      width: MediaQuery.of(context).size.width.w,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringUtils.orderProgressText,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: const Color(0xFF010101)),
          ).paddingOnly(top: 8.h),
          SizedBox(height: 15.0.h),
          Container(
            width: double.infinity.w,
            // padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(.1),
                  spreadRadius: 0.8,
                  blurRadius: 0.16,
                  offset: const Offset(0, 0),
                )
              ],
              /*  border: Border.all(
                    color: AppColors.terracotta,
                    width: 1.w,
                    style: BorderStyle.solid),*/
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: 0),
                  minVerticalPadding: 0,
                  leading: Image.asset(
                    AssetsUtils.storeImage,
                    height: 40.h,
                    width: 40.w,
                  ),
                  title: Text(
                    StringUtils.storeText,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: const Color(0xFF010101)),
                  ),
                  subtitle: Text(
                    StringUtils.storeAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF010101),
                        fontWeight: FontWeight.w400),
                  ),
                  contentPadding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 5.0, top: 5.0),
                  dense: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: Divider(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  StringUtils.orderType,
                                  style: TextStyle(
                                    color: AppColors.darkGray,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  'Delivery',
                                  style: TextStyle(
                                    color: AppColors.oxFF010101,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  StringUtils.deliveryTime,
                                  style: TextStyle(
                                    color: AppColors.darkGray,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '10:00-10:20',
                                  style: TextStyle(
                                    color: AppColors.oxFF010101,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/OrderDetailsScreen');
                        },
                        child: Row(
                          children: [
                            Text(
                              StringUtils.details,
                              style: TextStyle(
                                color: AppColors.terracotta,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.terracotta),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
