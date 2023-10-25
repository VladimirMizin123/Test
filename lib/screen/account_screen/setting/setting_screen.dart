import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/account_scrren_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/setting/change_password_screen.dart';

import '../../../widget/svg_image.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List settingDataList = [
    {
      "image": AssetsUtils.lock,
      "title": "Change password",
      "color": AppColors.disable,
      "image1": AssetsUtils.forwardArrow,
      "screen": ChangePasswordScreen(),
    },
    {
      "image": AssetsUtils.unit,
      "title": "Units",
      "color": AppColors.disable,
      "image1": AssetsUtils.forwardArrow,
      "screen": ChangePasswordScreen(),
    },
    {
      "image": AssetsUtils.notificationIcn,
      "title": "Notifications",
      "color": AppColors.disable,
      "image1": AssetsUtils.logOut,
      "screen": ChangePasswordScreen(),
    },
    {
      "image": AssetsUtils.icGps,
      "title": "GPS",
      "color": AppColors.transparentColor,
      "image1": AssetsUtils.logOut,
      "screen": ChangePasswordScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AccountTitleWidget(
                title: "Settings",
                widget: accountScreenListWidget(
                  children: List.generate(
                    settingDataList.length,
                    (index) {
                      var data = settingDataList[index];
                      return accountScreenDataWidget(
                        onTap: () {
                          print("data");
                          Get.to(data["screen"]);
                        },
                        color: data["color"],
                        leading: SvgImage(image: data["image"]),
                        title: Text(data["title"]),
                        trailing: SvgImage(image: data["image1"]),
                      );
                    },
                  ),
                ).paddingOnly(top: 150.h, right: 23.w, left: 23.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
