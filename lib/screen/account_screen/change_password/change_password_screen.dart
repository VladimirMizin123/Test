import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AccountTitleWidget(
                title: "Change Password",
                widget: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.transparentColor,
                  ),
                  margin: EdgeInsets.only(top: 150.h, right: 23.w, left: 23.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelWidget(
                        text: "Old Password",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      commonTextFormField(
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
                          hintText: "",
                          obscureText: isOb,
                          hintStyle: TextStyle(),
                          style: TextStyle(),
                          vertical: 15.h,
                          horizontal: 20.w),
                      SizedBox(
                        height: 14.h,
                      ),
                      labelWidget(
                        text: "New Password",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      commonTextFormField(
                          enableBorderColor: AppColors.disable,
                          width: double.infinity,
                          hintText: StringUtils.writeNewPassword,
                          obscureText: false,
                          hintStyle: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w300),
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w300),
                          vertical: 15.h,
                          horizontal: 18.w),
                      SizedBox(
                        height: 14.h,
                      ),
                      labelWidget(
                        text: "Confirm New Password",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      commonTextFormField(
                          enableBorderColor: AppColors.disable,
                          width: double.infinity,
                          hintText: StringUtils.writeNewPassword,
                          obscureText: false,
                          hintStyle: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w300),
                          vertical: 15.h,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w300),
                          horizontal: 18.w),
                    ],
                  ).paddingOnly(left: 12.w, right: 12.w, top: 20.h),
                ),
              ),
              SizedBox(
                height: 150.h,
              ),
              buildButton(
                      context: context,
                      bgColor: AppColors.primaryBlueColor,
                      textColor: AppColors.whiteColor,
                      title: "Update",
                      onPressed: () {})
                  .paddingOnly(left: 22.w, right: 22.w, top: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
