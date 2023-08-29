import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage(AssetsUtils.inviteFriendBg),
            height: screenSize.height,
            width: screenSize.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.58),
                Container(
                  decoration: BoxDecoration(color: AppColors.whiteColor.withOpacity(0.80), borderRadius: BorderRadius.circular(6)),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Image.asset(
                        AssetsUtils.gymEatsLogo,
                        height: 40.h,
                        // fit: BoxFit.cover,
                        color: AppColors.primaryBlue,
                      ),
                      SizedBox(height: 5.h),
                      RichText(
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        text: TextSpan(
                          text: 'Eating better ',
                          style: FontUtils.h26(fontColor: AppColors.primaryBlue, fontWeight: FWT.bold),
                          children: [
                            TextSpan(
                              text: 'with friends is even better!',
                              style: FontUtils.h26(fontColor: AppColors.primaryBlue, fontWeight: FWT.medium),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Invite a friend and earn a\nFREE month!',
                        textAlign: TextAlign.center,
                        style: FontUtils.h26(fontColor: AppColors.primaryBlue, fontWeight: FWT.medium),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                simpleTextBorderButton(
                  context: context,
                  buttonLable: 'Invite a friend',
                  isDarkColor: true,
                  isFillColor: true,
                  height: screenSize.height * 0.07,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
