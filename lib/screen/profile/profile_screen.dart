import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 25.sp,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: Column(children: [
        ListTile(
          title: const Text('LogOut'),
          onTap: () {
            PreferenceUtils.clearPrefs();
            Get.offAllNamed('LoginScreen');
          },
        )
      ]),
    );
  }
}
