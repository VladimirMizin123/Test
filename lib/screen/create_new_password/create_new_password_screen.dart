import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';

import '../../app/firebase_deep_link.dart';
import '../../bloc/reset_password/reset_password_bloc.dart';
import '../../bloc/reset_password/reset_password_event.dart';
import '../../bloc/reset_password/reset_password_state.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../widget/app_center_loader.dart';
import '../../widget/app_widget.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final routeName = '/setNewPassword';
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  String? resetToken;
  bool isPassword = false;

  ResetPasswordBloc bloc = ResetPasswordBloc();

  @override
  void initState() {
    super.initState();

    resetToken = PreferenceUtils.getString(forgetPassToken);
  }

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
                      onTap: () {
                        Get.offAllNamed('/LoginScreen');
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.darkGray,
                      ),
                    ),
                    Image.asset(
                      AssetsUtils.gymEatsLogo,
                      fit: BoxFit.cover,
                      height: 60.h,
                    ),
                    const SizedBox()
                  ],
                ).paddingOnly(top: 15.h),
                Text(
                  StringUtils.createPassword,
                  style: textTheme.displayLarge?.copyWith(
                      letterSpacing: -0.8,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF010101)),
                ).paddingOnly(top: 16.h),
                Text(
                  StringUtils.enterPassword,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: AppColors.middleGray),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringUtils.newPassword,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.darkGray),
                    ).paddingOnly(bottom: 5.h, top: 24.h),
                    commonTextField(
                            context: context,
                            controller: newPassController,
                            eyeShow: true,
                            isPassword: isPassword,
                            onTap: () {
                              isPassword = !isPassword;
                              setState(() {});
                            },
                            hintText: StringUtils.writePassword)
                        .paddingOnly(left: 2.w, right: 2.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 6.h,
                          width: 6.h,
                          margin: EdgeInsets.only(right: 15.w, top: 5.h),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF010101),
                          ),
                        ),
                        Text(
                          StringUtils.validatePassLength,
                          style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              fontSize: 11.5.sp,
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
                      StringUtils.confirmPassword,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.darkGray),
                    ).paddingOnly(bottom: 5.h, top: 24.h),
                    commonTextField(
                            context: context,
                            controller: confirmPassController,
                            eyeShow: true,
                            hintText: StringUtils.writeConfirmPassword)
                        .paddingOnly(left: 2.w, right: 2.w),
                    Row(
                      children: [
                        Container(
                          height: 6.h,
                          width: 6.h,
                          margin: EdgeInsets.only(right: 15.w),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF010101),
                          ),
                        ),
                        Text(
                          StringUtils.matchPassword,
                          style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGray),
                        )
                      ],
                    ).paddingOnly(top: 5.h),
                  ],
                ),
                BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                    bloc: bloc,
                    builder: (context, state) {
                      if (state is ResetLoadingState) {
                        return const AppCenterLoader();
                      }
                      return buildButton(
                          context: context,
                          onPressed: () {
                            bloc.add(ButtonClickEvent(
                                password: newPassController.text,
                                confirmPassword: confirmPassController.text,
                                passwordResetToken: PreferenceUtils.getString(
                                    forgetPassToken)));
                          },
                          textColor: AppColors.skyBlue,
                          bgColor: const Color(0xFF004C63),
                          title: StringUtils.resetPassword);
                    },
                    listener: (context, state) {
                      if (state is ResetSuccessState) {
                        newPassController.clear();
                        confirmPassController.clear();
                      }
                    }).paddingOnly(top: 25.h, bottom: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
