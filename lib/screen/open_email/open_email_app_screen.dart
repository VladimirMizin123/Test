import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../widget/app_widget.dart';

class OpenEmailAppScreen extends StatelessWidget {
  const OpenEmailAppScreen({super.key});

  final routeName = '/OpenEmailAppScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height.h,
          width: size.width.w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    AssetsUtils.emailApp,
                    height: 170.h,
                    width: 170.w,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  StringUtils.checkMail,
                  style: textTheme.displayLarge?.copyWith(
                      letterSpacing: -0.8, color: const Color(0xFF010101)),
                ).paddingOnly(top: 60.h),
                Text(
                  StringUtils.checkSubMail,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: AppColors.middleGray, fontSize: 17.sp),
                ).paddingSymmetric(horizontal: 20.w),
                buildButton(
                        context: context,
                        onPressed: () {
                          openGmailHomePage();
                        },
                        textColor: const Color(0xFFD9E9EE),
                        bgColor: const Color(0xFF004C63),
                        title: StringUtils.openEmailAppBtn)
                    .paddingOnly(top: 60.h),
                InkWell(
                  onTap: () {
                    Get.toNamed('/LoginScreen');
                  },
                  child: Text(
                    StringUtils.skipText,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall
                        ?.copyWith(color: AppColors.primaryBlue),
                  ).paddingOnly(top: 20.h),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Didn’t receive the email? Check your spam filter or ',
                        style: textTheme.bodySmall!.copyWith(
                            color: AppColors.darkGray,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300),
                      ),
                      TextSpan(
                        text: 'try another email address',
                        style: textTheme.bodySmall!.copyWith(
                            color: AppColors.terracotta,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Single tapped.
                            Get.toNamed('/ResetPasswordScreen');
                          },
                      ),
                    ],
                  ),
                ).paddingOnly(top: 100.h, right: 10.w),
              ],
            ).paddingSymmetric(horizontal: 20.w, vertical: 10.h),
          ),
        ),
      ),
    );
  }

  void openGmailHomePage() async {
    if (Platform.isAndroid) {
      AndroidIntent intent = const AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.APP_EMAIL',
      );
      debugPrint(intent.toString());
      intent.launch().catchError((e) {
        debugPrint(e.toString());
      });
    } else if (Platform.isIOS) {
      launch("message://").catchError((e) {});
    }
  }
}
