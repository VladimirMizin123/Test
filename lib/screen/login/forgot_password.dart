import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_string.dart';
import '../../widget/app_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final routeName = '/forgot-password';
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height.h,
          width: size.width.w,
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.darkGray,
                      ),
                    ),
                    Image.asset(
                      AppStrings.gymEatsLogo,
                      fit: BoxFit.cover,
                      height: 60.h,
                    ),
                    const SizedBox()
                  ],
                ).paddingOnly(top: 15.h),
                Text(
                  AppStrings.createPassword,
                  style: textTheme.displayLarge?.copyWith(
                      letterSpacing: -0.8,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF010101)),
                ).paddingOnly(top: 16.h),
                Text(
                  AppStrings.enterPassword,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: AppColors.middleGray),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.newPassword,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.darkGray),
                    ).paddingOnly(bottom: 5.h, top: 24.h),
                    commonTextField(
                            context: context,
                            controller: newPassController,
                            hintText: AppStrings.writePassword)
                        .paddingOnly(left: 2.w, right: 2.w),
                    Row(
                      children: [
                        Container(
                          height: 6.h,
                          width: 6.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF010101),
                          ),
                        ),
                        Text(
                          AppStrings.validatePassLength,
                          style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGray),
                        )
                      ],
                    ).paddingOnly(top: 5.h),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.confirmPassword,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.darkGray),
                    ).paddingOnly(bottom: 5.h, top: 24.h),
                    commonTextField(
                            context: context,
                            controller: confirmPassController,
                            hintText: AppStrings.writePassword)
                        .paddingOnly(left: 2.w, right: 2.w),
                    Row(
                      children: [
                        Container(
                          height: 6.h,
                          width: 6.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF010101),
                          ),
                        ),
                        Text(
                          AppStrings.matchPassword,
                          style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGray),
                        )
                      ],
                    ).paddingOnly(top: 5.h),
                  ],
                ),
                buildButton(
                        context: context,
                        onPressed: () {},
                        textColor: AppColors.skyBlue,
                        bgColor: const Color(0xFF004C63),
                        title: AppStrings.resetPassword)
                    .paddingOnly(top: 25.h, bottom: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
