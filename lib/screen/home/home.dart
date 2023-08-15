import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import '../../constant/app_string.dart';
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
    AppStrings.welcomeBg;
    AppStrings.welcomeLogo;
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
            image: AssetImage(AppStrings.welcomeBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Image.asset(
                  AppStrings.welcomeLogo,
                  height: 160.h,
                  width: 160.w,
                ),
                SizedBox(height: 50.h),
                buildButton(
                  title: AppStrings.letsEat,
                  onPressed: () {
                    Get.toNamed('/GymEatsMenu');
                  },
                  bgColor: AppColors.letsEatButton,
                  textColor: AppColors.letsEat,
                ),
                SizedBox(height: 40.h),
                Container(
                  height: 4.h,
                  width: 135.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
