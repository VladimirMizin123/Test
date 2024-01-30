import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class OrderHistoryHintScreen extends StatelessWidget {
  const OrderHistoryHintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkGray.withOpacity(0.80),
      body: SafeArea(
        child: SizedBox(
          height: screenSize.height.h,
          width: screenSize.width.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -15,
                top: -5,
                child: Container(
                  // color: Colors.red,
                  height: 80,
                  width: 80,

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.toNamed('/OrderHistoryScreen');
                    },
                    child: Center(
                      child: Image.asset(
                        AssetsUtils.notification,
                        height: 25.h,
                        width: 25.w,
                        color: AppColors.darkGray,
                      ).paddingOnly(bottom: 5),
                    ),
                  ),
                ),
              ),
              Center(
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    width: context.width,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 0),
                          blurRadius: 16,
                          spreadRadius: 0,
                          color: const Color(0xFF4C63).withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AssetsUtils.gymEatsLogoRound,
                          color: AppColors.green,
                          height: 60,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "You can check your order here!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "Avenir",
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ).paddingOnly(left: 10, right: 10),
                      ],
                    ),
                  ).paddingOnly(left: 20, right: 20),
                ),
              ),
              Positioned.fill(
                bottom: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: simpleTextBorderButton(
                        context: context,
                        buttonLable: 'I got it!',
                        isDarkColor: true,
                        isFillColor: true,
                        color: AppColors.whiteColor,
                        height: screenSize.height * 0.07,
                        width: double.infinity,
                        lableColor: AppColors.primaryBlue,
                        txtColor: AppColors.primaryBlue,
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
