import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

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
                decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(6)),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_outlined,
                    color: AppColors.green,
                  ),
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
