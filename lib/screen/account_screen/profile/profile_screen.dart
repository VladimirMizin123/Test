import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../../constant/color_utils.dart';
import '../account_scrren_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  AccountTitleWidget(
                    title: "Profile",
                    widget: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200, spreadRadius: 1)
                        ],
                      ),
                      margin:
                          EdgeInsets.only(top: 140.h, right: 23.w, left: 23.w),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8.h),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  child: SvgPicture.asset(AssetsUtils.appleLogo,
                                      fit: BoxFit.fill,
                                      height: 50,
                                      width: 50,
                                      color: Colors.yellow),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  "Edit profile photo",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          profileDataWidget(
                            text: "name",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                obscureText: false,
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                          profileDataWidget(
                            text: "Goal/Focus",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                          profileDataWidget(
                            text: "Weight",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                          profileDataWidget(
                            text: "Target Weight",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                          profileDataWidget(
                            text: "Height",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: "required",
                                hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.middleGray)),
                          ),
                          profileDataWidget(
                            text: "Birthdate",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                          profileDataWidget(
                            text: "Gender",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400),
                            widget: commonTextFormField(
                                width: 140.w,
                                horizontal: 10,
                                vertical: 0,
                                hintText: ""),
                          ),
                        ],
                      ).paddingOnly(
                        right: 16.w,
                        left: 16.w,
                      ),
                    ),
                  ),
                ],
              ),
              buildButton(
                      context: context,
                      title: "Update",
                      bgColor: AppColors.primaryBlueColor,
                      textColor: AppColors.whiteColor,
                      onPressed: () {})
                  .paddingOnly(
                      right: 16.w, left: 16.w, top: 16.h, bottom: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
