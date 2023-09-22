import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/firebase_deep_link.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';

import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../bloc/forgot_password/forgot_password_event.dart';
import '../../bloc/forgot_password/forgot_password_state.dart';
import '../../constant/string_utils.dart';
import '../../constant/color_utils.dart';
import '../../widget/app_center_loader.dart';
import '../../widget/app_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final routeName = '/ResetPasswordScreen';
  final emailController = TextEditingController();

  ForgotPasswordBloc bloc = ForgotPasswordBloc();

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
                    AssetsUtils.gymEatsLogo,
                    fit: BoxFit.cover,
                    height: 60.h,
                  ),
                  const SizedBox()
                ],
              ).paddingOnly(top: 15.h),
              Text(
                StringUtils.resetPassword,
                style: textTheme.displayLarge?.copyWith(
                    letterSpacing: -0.8,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ).paddingOnly(top: 16.h, bottom: 0),
              Text(
                StringUtils.subResetPassword,
                style:
                    textTheme.bodyLarge?.copyWith(color: AppColors.middleGray),
              ),
              commonTextField(
                      context: context,
                      controller: emailController,
                      hintText: StringUtils.email)
                  .paddingOnly(top: 20.h),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                  bloc: bloc,
                  listener: (context, state) {
                    if (state is ForgotSuccessState) {
                      emailController.clear();
                    }
                  },
                  builder: (context, state) {
                    if (state is ForgotLoadingState) {
                      return const AppCenterLoader();
                    }
                    return buildButton(
                        context: context,
                        onPressed: () {
                          bloc.add(
                              ButtonClickEvent(email: emailController.text));
                        },
                        textColor: Colors.white,
                        bgColor: AppColors.primaryBlue,
                        title: StringUtils.sendInstructions);
                  }).paddingOnly(top: 25.h)
            ],
          ),
        ),
      ),
    );
  }
}
