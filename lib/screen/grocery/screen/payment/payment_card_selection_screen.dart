import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

class PaymentCardSelectionScreen extends StatelessWidget {
  const PaymentCardSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                const BackButtonWidget(),
                Text('Checkout', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                Opacity(opacity: 0, child: Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101))),
              ],
            ).paddingSymmetric(horizontal: 6, vertical: 5.h),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Saved payment method',
                  style: FontUtils.h20(fontColor: AppColors.middleGray),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/AddCardScreen');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.whiteColor,
                        boxShadow: boxShadowWidget,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Row(
                          children: [
                            SvgPicture.asset(AssetsUtils.icVisaLogo, height: 25),
                            const SizedBox(width: 15),
                            Expanded(
                                child: Text(
                              'Bring me the order',
                              style: FontUtils.h18(fontColor: AppColors.black, fontWeight: FWT.medium),
                            )),
                            Text(
                              'Add',
                              style: FontUtils.h16(fontColor: AppColors.terracotta),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.terracotta),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Add payment method',
                  style: FontUtils.h20(fontColor: AppColors.middleGray),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.whiteColor,
                      boxShadow: boxShadowWidget,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                        children: [
                          SvgPicture.asset(AssetsUtils.icVisaLogo, height: 25),
                          const SizedBox(width: 15),
                          Expanded(
                              child: Text(
                            'Bring me the order',
                            style: FontUtils.h18(fontColor: AppColors.black, fontWeight: FWT.medium),
                          )),
                          Text(
                            'Add',
                            style: FontUtils.h16(fontColor: AppColors.terracotta),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.terracotta),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
