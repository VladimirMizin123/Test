import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

import '../../constant/string_utils.dart';
import '../../widget/app_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final routeName = '/';

  @override
  void initState() {
    super.initState();
    AssetsUtils.welcomeBg;
    AssetsUtils.welcomeLogo;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetsUtils.welcomeBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Image.asset(
                  AssetsUtils.welcomeLogo,
                  height: 160.h,
                  width: 160.w,
                ),
                SizedBox(height: 50.h),
                buildButton(
                  context: context,
                  title: StringUtils.letsEat,
                  onPressed: () {
                    Get.toNamed('/GymEatsMenu');
                  },
                  bgColor: ColorUtils.letsEatButton,
                  textColor: ColorUtils.letsEat,
                ),
                SizedBox(height: 40.h),
              ],
            )
          ],
        ),
      ),
    );
  }
}
