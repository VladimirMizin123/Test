import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/screen/account_screen/about/about_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_scrren_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/account_screen/card_screen/view/card_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/program/program_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/setting/setting_screen.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';
import 'package:livechatt/livechatt.dart';

import '../address/address_screen.dart';

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
      "screen": const ProfileScreen()
    },
    {
      "image": AssetsUtils.icHome,
      "title": "My Address",
      "subtitle": "",
      "color": AppColors.disable,
      "screen": const AddressScreen()
    },
    {
      "image": AssetsUtils.icMealPlan,
      "title": "Program",
      "subtitle": "Diet",
      "color": AppColors.disable,
      "screen": const ProgramScreen()
    },
    {
      "image": AssetsUtils.creditCard,
      "title": "Card",
      "subtitle": "",
      "color": AppColors.transparentColor,
      "screen": const CardsScreen()
    },
  ];

  List settingList1 = [
    {
      "image": AssetsUtils.about,
      "title": "About",
      "color": AppColors.disable,
      "screen": const AboutScreen()
    },
    {
      "image": AssetsUtils.chat,
      "title": "Support",
      "color": AppColors.disable,
      "screen": ''
    },
    {
      "image": AssetsUtils.setting,
      "title": "Settings",
      "color": AppColors.transparentColor,
      "screen": const SettingScreen()
    },
  ];
  AccountBloc accountBloc = AccountBloc();
  String fullName = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountBloc.add(GetProfileDetailsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocConsumer<AccountBloc, AccountState>(
                  bloc: accountBloc,
                  listener: (context, state) {
                    if (state is GetProfileDetailsSuccessState) {
                      fullName =
                          '${state.profileDetails?.firstName} ${state.profileDetails?.lastName}';
                      setState(() {});
                    }
                  },
                  builder: (context, state) {
                    return accountTitleWidget(
                      title: "Account",
                      widget: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(
                            top: 150.h, right: 23.w, left: 23.w),
                        child: Column(
                          children: [
                            accountScreenListWidget(
                              children: List.generate(
                                settingList.length,
                                (index) {
                                  var data = settingList[index];
                                  bool isLast = index == settingList.length - 1;
                                  double? size = isLast ? 29 : null;
                                  return accountScreenDataWidget(
                                    onTap: () {
                                      Get.to(data["screen"]);
                                    },
                                    color: data["color"],
                                    leading: SizedBox(
                                      height: size,
                                      width: size,
                                      child: SvgImage(
                                        image: data["image"],
                                        color: const Color(0xFF5F5F5F),
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data["title"],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        Text(data["subtitle"]),
                                      ],
                                    ),
                                    trailing: const SvgImage(
                                      image: AssetsUtils.forwardArrow,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            accountScreenListWidget(
                              children: List.generate(
                                settingList1.length,
                                (index) {
                                  var data = settingList1[index];
                                  return accountScreenDataWidget(
                                    onTap: () {
                                      if (data["title"] == 'Support') {
                                        log("Email : ${PreferenceUtils.getString(prefUserEmail)}");
                                        log("User Name : ${PreferenceUtils.getString(prefUserName)}");
                                        Livechat.beginChat(
                                          Constant.i.chatId,
                                          visitorEmail:
                                              PreferenceUtils.getString(
                                                  prefUserEmail),
                                          visitorName:
                                              PreferenceUtils.getString(
                                                  prefUserName),
                                          customParams: <String, String>{
                                            'org': PreferenceUtils.getString(
                                                prefUserName),
                                            'position': 'user'
                                          },
                                        );
                                      } else {
                                        Get.to(data["screen"]);
                                      }
                                    },
                                    color: data["color"],
                                    leading: SvgImage(image: data["image"]),
                                    title: Text(
                                      data["title"],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
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
                    );
                  }),
              SizedBox(height: 100.h),
              InkWell(
                onTap: () {
                  PreferenceUtils.clearPrefs();
                  PreferenceUtils.setBool("ignoreIntro", true);
                  Get.offAllNamed('LoginScreen');
                },
                child: const Text(
                  "Log out",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ).paddingOnly(bottom: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
