import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/about/about_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/account_scrren_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/program/program_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/setting/setting_screen.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';
import 'address/address_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List settingList = [
    {
      "image": AssetsUtils.profileIcon,
      "title": "Profile",
      "subtitle": "",
      "color": AppColors.disable,
      "screen": ProfileScreen()
    },
    {
      "image": AssetsUtils.icHome,
      "title": "Me Address",
      "subtitle": "",
      "color": AppColors.disable,
      "screen": AddressScreen()
    },
    {
      "image": AssetsUtils.icMealPlan,
      "title": "Programme",
      "subtitle": "Diet",
      "color": AppColors.transparentColor,
      "screen": ProgramScreen()
    },
  ];

  List settingList1 = [
    {
      "image": AssetsUtils.about,
      "title": "About",
      "color": AppColors.disable,
      "screen": AboutScreen()
    },
    {
      "image": AssetsUtils.chat,
      "title": "Support",
      "color": AppColors.disable,
      "screen": AboutScreen()
    },
    {
      "image": AssetsUtils.setting,
      "title": "Settings",
      "color": AppColors.transparentColor,
      "screen": SettingScreen()
    },
  ];

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
                title: "Account",
                widget: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200, spreadRadius: 1)
                    ],
                  ),
                  margin: EdgeInsets.only(top: 150.h, right: 23.w, left: 23.w),
                  child: Column(
                    children: [
                      accountScreenListWidget(
                          children: List.generate(settingList.length, (index) {
                        var data = settingList[index];
                        return accountScreenDataWidget(
                          onTap: () {
                            Get.to(data["screen"]);
                          },
                          color: data["color"],
                          leading: SvgImage(image: data["image"]),
                          title: Text(data["title"]),
                          trailing: const SvgImage(
                            image: AssetsUtils.forwardArrow,
                          ),
                        );
                      })),
                      SizedBox(
                        height: 20.h,
                      ),
                      accountScreenListWidget(
                        children: List.generate(
                          settingList1.length,
                          (index) {
                            var data = settingList1[index];
                            return accountScreenDataWidget(
                              onTap: () {
                                Get.to(data["screen"]);
                              },
                              color: data["color"],
                              leading: SvgImage(image: data["image"]),
                              title: Text(data["title"]),
                              trailing: const SvgImage(
                                image: AssetsUtils.forwardArrow,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              const Text(
                "Log out",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
