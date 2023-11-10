import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/account_screen/about/pivacy/privacy_policy_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/about/terms_conditions_screen/terms_conditions_screens.dart';
import '../../../constant/asset_utils.dart';
import '../../../constant/color_utils.dart';
import '../../../widget/svg_image.dart';
import '../account/account_scrren_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  List aboutDataList = [
    {
      "title": "Privacy Policy",
      "color": AppColors.disable,
      "screen": const PolicyScreen(),
    },
    {
      "title": "Terms and Conditions",
      "color": AppColors.transparentColor,
      "screen": const ConditionScreen(),
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
                title: "About",
                widget: accountScreenListWidget(
                    children: List.generate(aboutDataList.length, (index) {
                  var data = aboutDataList[index];
                  return accountScreenDataWidget(
                    onTap: () {
                      print('object');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => data["screen"],
                          ));
                    },
                    color: data["color"],
                    leading: Text(
                      data["title"],
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: const SvgImage(
                      image: AssetsUtils.forwardArrow,
                    ),
                  );
                })).paddingOnly(top: 150.h, right: 23.w, left: 23.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
