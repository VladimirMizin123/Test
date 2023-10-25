import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/account_scrren_widget.dart';

class EditProfileSceen extends StatefulWidget {
  const EditProfileSceen({super.key});

  @override
  State<EditProfileSceen> createState() => _EditProfileSceenState();
}

class _EditProfileSceenState extends State<EditProfileSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AccountTitleWidget(
                title: "Profile",
                widget: Container(
                  height: 500,
                  margin: EdgeInsets.only(top: 150.h, right: 23.w, left: 23.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    // color: AppColors.skyColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200, spreadRadius: 1)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
