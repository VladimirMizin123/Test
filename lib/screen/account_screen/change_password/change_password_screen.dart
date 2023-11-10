import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import '../../../constant/color_utils.dart';
import '../account/account_scrren_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isOb = false;
  AccountBloc accountBloc = AccountBloc();
  final formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AccountBloc, AccountState>(
            bloc: accountBloc,
            listener: (context, state) {
              if (state is ChangePasswordSuccessState) {
                Get.back();
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: AccountTitleWidget(
                        title: "Change Password",
                        widget: Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.transparentColor,
                            ),
                            margin: EdgeInsets.only(
                                top: 150.h, right: 23.w, left: 23.w),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  labelWidget(
                                    text: "Old Password",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  commonTextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Enter Old Password';
                                        } else {
                                          return null;
                                        }
                                      },
                                      textEditingController:
                                          oldPasswordController,
                                      enableBorderColor: AppColors.disable,
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isOb = !isOb;
                                            });
                                          },
                                          child: isOb
                                              ? const Icon(Icons.visibility_off)
                                              : Icon(Icons.remove_red_eye)),
                                      width: double.infinity,
                                      hintText: "Old Password",
                                      obscureText: isOb,
                                      hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300),
                                      style: TextStyle(),
                                      vertical: 15.h,
                                      horizontal: 20.w),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  labelWidget(
                                    text: "New Password",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  commonTextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Enter New Password';
                                        } else if (!RegExp(
                                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                            .hasMatch(value)) {
                                          return 'Enter valid password';
                                        } else {
                                          return null;
                                        }
                                      },
                                      textEditingController:
                                          newPasswordController,
                                      enableBorderColor: AppColors.disable,
                                      width: double.infinity,
                                      hintText: StringUtils.writeNewPassword,
                                      obscureText: false,
                                      hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300),
                                      vertical: 15.h,
                                      horizontal: 18.w),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  labelWidget(
                                    text: "Confirm New Password",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  commonTextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Enter Confirm Password';
                                        } else if (!RegExp(
                                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                            .hasMatch(value)) {
                                          return 'Enter valid password';
                                        } else if (newPasswordController.text !=
                                            value) {
                                          return 'Confirm password doesn\'t match new password ';
                                        } else {
                                          return null;
                                        }
                                      },
                                      textEditingController:
                                          confirmPasswordController,
                                      enableBorderColor: AppColors.disable,
                                      width: double.infinity,
                                      hintText: StringUtils.writeNewPassword,
                                      obscureText: false,
                                      hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300),
                                      vertical: 15.h,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300),
                                      horizontal: 18.w),
                                ],
                              ).paddingOnly(left: 12.w, right: 12.w, top: 20.h),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (state is ChangePasswordLoadingState)
                      SizedBox(
                        width: double.infinity.w,
                        height: 48.h,
                        child: const AppCenterLoader(),
                      ).paddingOnly(
                          right: 16.w, left: 16.w, top: 16.h, bottom: 16.h)
                    else
                      buildButton(
                          context: context,
                          bgColor: AppColors.primaryBlueColor,
                          textColor: AppColors.whiteColor,
                          title: "Update",
                          onPressed: () {
                            String email =
                                PreferenceUtils.getString(prefUserEmail);
                            print('=email===>${email}');

                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            accountBloc.add(
                              ChangeProfilePasswordEvent(
                                  currentPassword: oldPasswordController.text,
                                  newPassword: newPasswordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                  email: email),
                            );
                          }).paddingOnly(left: 22.w, right: 22.w, top: 20.h),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
