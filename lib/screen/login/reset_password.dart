import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_string.dart';
import '../../widget/app_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final routeName = '/reset-password';
  final resetPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height.h,
          width: size.width.w,
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.darkGray,
                      ),
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
                AppStrings.resetPassword,
                style: textTheme.displayLarge?.copyWith(
                    letterSpacing: -0.8,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ).paddingOnly(top: 16.h, bottom: 0),
              Text(
                AppStrings.subResetPassword,
                style:
                    textTheme.bodyLarge?.copyWith(color: AppColors.middleGray),
              ),
              commonTextField(
                      context: context,
                      controller: resetPasswordController,
                      hintText: AppStrings.email)
                  .paddingOnly(top: 20.h),
              buildButton(
                      context: context,
                      onPressed: () {
                        Get.toNamed('/open-email-app');
                      },
                      textColor: Colors.white,
                      bgColor: AppColors.disable,
                      title: AppStrings.sendInstructions)
                  .paddingOnly(top: 25.h),
            ],
          ),
        ),
      ),
    );
  }
}
