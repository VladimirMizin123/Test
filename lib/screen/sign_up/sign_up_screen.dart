import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/controller/home_screen_controller.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../bloc/user_sign_up_info/user_sign_up_info_bloc.dart';
import '../../bloc/user_sign_up_info/user_sign_up_info_event.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final themeData = Theme.of(context);
    return GetBuilder<HomeScreenController>(builder: (homeController) {
      homeController = homeScreenController;
      return Scaffold(
        body: SafeArea(
          child: Container(
            height: size.height.h,
            width: size.width.w,
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      AssetsUtils.gymEatsLogo,
                      fit: BoxFit.cover,
                      height: 60.h,
                    ),
                  ),
                  Text(
                    'You are one step closer to eating better!',
                    style: textTheme.headlineSmall!.copyWith(
                      color: themeData.primaryColor,
                    ),
                    // style: AppTextStyle.butttonTextStyle
                    //     .copyWith(color: const Color(0xFF004C63)),
                  ).paddingOnly(top: 10),
                  Text(
                    'Create your GYM EATS account to continue',
                    style: textTheme.bodyMedium!.copyWith(color: const Color(0xFF5F5F5F), fontSize: 17.sp, fontWeight: FontWeight.w400),
                  ).paddingOnly(top: 18),
                  commonTextField(
                          context: context,
                          controller: homeController.fNameController,
                          hintText: StringUtils.fName)
                      .paddingOnly(top: 8),
                  commonTextField(
                          context: context,
                          controller: homeController.lastNameController,
                          hintText: StringUtils.lName)
                      .paddingOnly(top: 16),
                  commonTextField(
                          context: context,
                          controller: homeController.emailController,
                          hintText: StringUtils.email)
                      .paddingOnly(top: 16),
                  commonTextField(
                          isPassword: true,
                          context: context,
                          controller: homeController.passwordController,
                          hintText: StringUtils.password)
                      .paddingOnly(top: 16),
                  commonTextField(
                          isPassword: true,
                          context: context,
                          controller: homeController.confirmPasswordController,
                          hintText: StringUtils.confirmPassword)
                      .paddingOnly(top: 16),
                  buildButton(
                          context: context,
                          onPressed: () {
                            homeController.joinGymEatButton();
                          },
                          textColor: const Color(0xFFD9E9EE),
                          bgColor: const Color(0xFF004C63),
                          title: StringUtils.joinGymEats)
                      .paddingOnly(top: 25.h),
                  Text(
                    StringUtils.or,
                    style: textTheme.bodyLarge,
                  ).paddingSymmetric(vertical: 15.h),
                  buildButton(
                      context: context,
                      hasImage: true,
                      imagePath: AssetsUtils.appleLogo,
                      onPressed: () async {
                        await homeController.appleSignIn();
                      },
                      textColor: const Color(0xFFD9E9EE),
                      bgColor: Colors.black,
                      title: StringUtils.apple),
                  Wrap(
                    children: [
                      Text(StringUtils.alreadyAccount,
                          style: textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFF373737),
                          )),
                      InkWell(
                        onTap: () {
                          Get.toNamed('/LoginScreen');
                          // Login Screen
                        },
                        child: Text(StringUtils.logIn, style: textTheme.bodyLarge!.copyWith(decoration: TextDecoration.underline, color: themeData.primaryColor, fontSize: 14.sp, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ).paddingOnly(top: 22.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'By clicking "Sign up", you agree to our terms and that you have read our ',
                          style: textTheme.bodySmall!.copyWith(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: textTheme.bodySmall!.copyWith(color: const Color(0XFF336633), fontSize: 14.sp, fontWeight: FontWeight.w400),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Single tapped.
                            },
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(color: Colors.blue[300]),
                        ),
                      ],
                    ),
                  ).paddingSymmetric(vertical: 50.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
