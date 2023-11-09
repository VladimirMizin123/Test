import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_scrren_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/change_password/change_password_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/setting/delete_account_bottom_sheet_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/setting/unit/unit_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

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
      "screen": const ChangePasswordScreen(),
    },
    {
      "image": AssetsUtils.unit,
      "title": "Units",
      "color": AppColors.disable,
      "image1": AssetsUtils.forwardArrow,
      "screen": const UnitScreen(),
    },
    {
      "image": AssetsUtils.notificationIcn,
      "title": "Notifications",
      "color": AppColors.disable,
      "image1": AssetsUtils.logOut,
      "screen": ''
    },
    // {
    //   "image": AssetsUtils.icGps,
    //   "title": "GPS",
    //   "color": AppColors.transparentColor,
    //   "image1": AssetsUtils.logOut,
    //   "screen": ''
    // },
  ];

  bool isNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AccountTitleWidget(
                title: "Settings",
                widget: accountScreenListWidget(
                  children: List.generate(
                    settingDataList.length,
                    (index) {
                      var data = settingDataList[index];
                      return accountScreenDataWidget(
                        onTap: () async {
                          if (data["title"].toString() == 'GPS') {
                            await Geolocator.openAppSettings();
                          }

                          if (data["screen"].toString().isEmpty) {
                            return;
                          }

                          Get.to(data["screen"]);
                        },
                        color: data["color"],
                        leading: SvgImage(image: data["image"]),
                        title: Text(data["title"]),
                        trailing: data["title"].toString() == 'Notifications'
                            ? CupertinoSwitch(
                                value: isNotification,
                                onChanged: (value) {
                                  isNotification = value;
                                  setState(() {});
                                },
                              )
                            : SvgImage(image: data["image1"]),
                      );
                    },
                  ),
                ).paddingOnly(top: 150.h, right: 23.w, left: 23.w),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              30.w,
                            ),
                            topRight: Radius.circular(30.w)),
                      ),
                      context: context,
                      builder: (context) {
                        return Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.w),
                              topLeft: Radius.circular(30.w),
                            ),
                          ),
                          child: deleteAccountBottomSheetWidget(
                            buttonWidget: Container(
                              height: 60,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: buildButton(
                                          context: context,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          title: "Delete",
                                          textColor: AppColors.whiteColor,
                                          bgColor: AppColors.primaryBlueColor),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: buildBorderButton(
                                          context: context,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          title: "Cancel",
                                          textColor: AppColors.primaryBlueColor,
                                          bgColor: AppColors.whiteColor,
                                          borderColor:
                                              AppColors.primaryBlueColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Delete Account",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGray),
                  ),
                ),
              ).paddingOnly(top: 250.h),
            ],
          ),
        ),
      ),
    );
  }
}
