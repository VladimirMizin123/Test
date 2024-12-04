import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key, this.createMultipleOrder = false});
  final bool createMultipleOrder;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage(AssetsUtils.paymentDoneBg),
            height: screenSize.height,
            width: screenSize.width,
            fit: BoxFit.cover,
          ),
          Container(
            color: AppColors.darkGray.withOpacity(0.80),
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
            children: [
              SizedBox(height: screenSize.height * 0.10),
              SvgPicture.asset(
                AssetsUtils.gymEatsLogoRound,
                color: AppColors.whiteColor,
              ),
              SizedBox(height: screenSize.height * 0.06),
              Container(
                height: screenSize.width * 0.80,
                width: screenSize.width * 0.80,
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AssetsUtils.paymentSuccess)
                        .paddingOnly(left: 30),
                    const SizedBox(height: 30),
                    Text(
                      "Your order${createMultipleOrder ? "s" : ""} are successfully placed.",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Avenir",
                        color: AppColors.middleGray,
                      ),
                    ).paddingOnly(right: 10, left: 10),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: simpleTextBorderButton(
                  context: context,
                  buttonLable: 'Dashboard',
                  isDarkColor: true,
                  isFillColor: true,
                  color: AppColors.whiteColor,
                  height: screenSize.height * 0.07,
                  width: double.infinity,
                  lableColor: AppColors.primaryBlue,
                  txtColor: AppColors.primaryBlue,
                  onTap: () {
                    Get.offAll(() => const AppManagerScreen(
                        selectIndex: 2, isOrderComplete: true));
                  },
                ),
              ),
              SizedBox(height: screenSize.height * 0.06),
            ],
          ),
        ],
      ),
    );
  }
}
