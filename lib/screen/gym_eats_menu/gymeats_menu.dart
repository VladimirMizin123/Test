import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_TextStyle.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/controller/home_screen_controller.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class GymEatsMenuScreen extends StatefulWidget {
  const GymEatsMenuScreen({super.key});

  @override
  State<GymEatsMenuScreen> createState() => _GymEatsMenuScreenState();
}

class _GymEatsMenuScreenState extends State<GymEatsMenuScreen> {
  final routeName = '/GymEatsMenu';
  HomeScreenController homeController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity.h,
        width: double.infinity.w,
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 45.h),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetsUtils.gymMenuBg), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            GetBuilder<HomeScreenController>(builder: (controller) {
              controller = homeController;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(dialGoalList.length, (index) {
                  final text = dialGoalList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: buildButton(
                      context: context,
                      bgColor: homeController.selectedItems[index]
                          ? AppColors.appColor
                          : Colors.white.withOpacity(0.8),
                      textColor: homeController.selectedItems[index]
                          ? const Color(0xFFC1EACE)
                          : AppColors.appColor,
                      onPressed: () {
                        homeController.selectEats(index);
                        Get.toNamed('/LoginScreen');
                      },
                      title: text,
                    ),
                  );
                }),
              );
            }),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity.w,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Choose the option that best reflects your current\ngoals",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.gymEatsStyle
                        .copyWith(color: const Color(0xFF336633)),
                  ),
                  SizedBox(height: 16.h),
                  Image.asset(
                    AssetsUtils.gymEatsSpoon,
                    height: 44.h,
                    width: 126.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
