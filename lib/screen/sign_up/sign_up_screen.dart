import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_TextStyle.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/controller/home_screen_controller.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

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
                      AppStrings.gymEatsLogo,
                      fit: BoxFit.cover,
                      height: 60.h,
                    ),
                  ),
                  Text(
                    'You are one step closer to eating better!',
                    style: AppTextStyle.butttonTextStyle
                        .copyWith(color: const Color(0xFF004C63)),
                  ).paddingOnly(top: 10),
                  Text(
                    'Create your GYM EATS account to continue',
                    style: AppTextStyle.butttonTextStyle.copyWith(
                        color: const Color(0xFF5F5F5F),
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400),
                  ).paddingOnly(top: 18),
                  commonTextField(
                          controller: homeController.fNameController,
                          hintText: 'First Name')
                      .paddingOnly(top: 8),
                  commonTextField(
                          controller: homeController.lastNameController,
                          hintText: 'Last Name')
                      .paddingOnly(top: 16),
                  commonTextField(
                          controller: homeController.emailController,
                          hintText: 'Email address')
                      .paddingOnly(top: 16),
                  commonTextField(
                          controller: homeController.passwordController,
                          hintText: 'Password')
                      .paddingOnly(top: 16),
                  buildButton(
                          onPressed: () {},
                          textColor: Color(0xFFD9E9EE),
                          bgColor: const Color(0xFF004C63),
                          title: 'Join GYM EATS')
                      .paddingOnly(top: 25.h),
                  const Text('or').paddingSymmetric(vertical: 15.h),
                  buildButton(
                      onPressed: () {},
                      textColor: const Color(0xFFD9E9EE),
                      bgColor: Colors.black,
                      title: 'Continue with Apple'),
                  Wrap(
                    children: [
                      Text('Already have an account?  ',
                          style: TextStyle(
                              fontSize: 14.sp, color: Color(0xFF373737))),
                      Text('Log In',
                          style: TextStyle(
                              fontSize: 16.sp, color: Color(0xFF004C63))),
                    ],
                  ).paddingOnly(top: 22.h),
                  Column(
                    children: [
                      Text(
                        'By clicking "Sign up", you agree to our terms and that you ',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      Wrap(
                        children: [
                          Text('have read our ',
                              style: TextStyle(fontSize: 12.sp)),
                          Text('Privacy Policy.',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF336633))),
                        ],
                      ),
                    ],
                  ).paddingSymmetric(vertical: 50.h),
                  Container(
                    height: 4.h,
                    width: 135.w,
                    margin: EdgeInsets.only(top: 20.h, bottom: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
