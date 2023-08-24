import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/screen/premiums/puchase_options_widget.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0XFFECECED).withOpacity(0.5),
          image: DecorationImage(
            image: AssetImage(AssetsUtils.premiumScreenBG),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          top: true,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.chevron_left,
                    color: const Color(0XFF373737),
                    size: 36.sp,
                    fill: 0,
                  ),
                ).paddingOnly(
                  left: 10.w,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w),
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.80),
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: Column(
                  children: [
                    Text(
                      'No more guessing! With GYM EATS I’m no longer eating ignorant–I know what foods are best for me and it shows!',
                      style: textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFCE6B53),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AssetsUtils.gymEatsSpoon,
                          color: ColorUtils.letsEatButton,
                          height: 22.h,
                          width: 64.w,
                        ),
                        Text(
                          'Chandler - 27 lbs',
                          style: textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFFCE6B53),
                          ),
                        )
                      ],
                    ).paddingOnly(top: 16.h),
                  ],
                ),
              ),
              Spacer(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  PurchaseOptions(
                    //isSelected: true,
                    month: '1 Month',
                    price: '9.99',
                    //savePercentage: '',
                  ).paddingSymmetric(horizontal: 4.w),
                  PurchaseOptions(
                    month: '6 Month',
                    price: '49.99',
                    savePercentage: '10',
                    //isSelected: true,
                  ).paddingSymmetric(horizontal: 4.w),
                  PurchaseOptions(
                    // isSelected: true,
                    month: '12 Month',
                    price: '99.99',
                    savePercentage: '15',
                  ).paddingSymmetric(horizontal: 4.w),
                ]).paddingSymmetric(horizontal: 18.w),
              ),
              buildButton(
                context: context,
                title: 'Start 14 days free trial',
                bgColor: ColorUtils.appColor,
                textColor: Color(0xFFC1EACE),
                onPressed: () {},
              ).paddingOnly(bottom: 8.h, top: 23.h, right: 20.w, left: 20.w),
              Text('No commitment. Cancel any time.',
                  style: textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  )),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Privacy Policy',
                      style: textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w800),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Single tapped.
                        },
                    ),
                    TextSpan(
                      text: '      Restore',
                      style: textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w800),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Single tapped.
                        },
                    ),
                    TextSpan(
                      text: '      Terms of Use',
                      style: textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w800),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Single tapped.
                        },
                    ),
                  ],
                ),
              ).paddingSymmetric(vertical: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
