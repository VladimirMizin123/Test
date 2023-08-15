import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_TextStyle.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/constant/pallete.dart';
import 'package:gymeats_mobile/controller/home_screen_controller.dart';
import 'package:gymeats_mobile/screen/sign_up/sign_up_screen.dart';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 45.h),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppStrings.gymMenuBg), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GetBuilder<HomeScreenController>(builder: (controller) {
              controller = homeController;
              return SizedBox(
                height: size.height / 2.3,
                child: ListView.builder(
                  itemCount: homeController.chooseEatsList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final text = homeController.chooseEatsList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: buildButton(
                        bgColor: homeController.selectedItems[index]
                            ? Pallete.appColor
                            : Colors.white.withOpacity(0.8),
                        textColor: homeController.selectedItems[index]
                            ? const Color(0xFFC1EACE)
                            : Pallete.appColor,
                        onPressed: () {
                          homeController.selectEats(index);
                          Get.to(const SignUpScreen());
                        },
                        title: text,
                      ),
                    );
                  },
                ),
              );
            }),
            Column(
              children: [
                Container(
                  height: 170.h,
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
                            .copyWith(color: Color(0xFF336633)),
                      ),
                      SizedBox(height: 16.h),
                      Image.asset(
                        AppStrings.gymEatsSpoon,
                        height: 44.h,
                        width: 126.w,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 4.h,
                  width: 135.w,
                  margin: EdgeInsets.only(top: 20.h, bottom: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
