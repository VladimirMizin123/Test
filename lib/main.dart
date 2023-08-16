import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/gym_eats_menu/gymeats_menu.dart';
import 'package:gymeats_mobile/screen/home/home.dart';
import 'package:gymeats_mobile/screen/premiums/premium_screen.dart';
import 'package:gymeats_mobile/screen/sign_up/sign_up_screen.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/screen/user_type/user_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: AppColors.lightTheme(),
            home: child,
            initialRoute: '/',
            getPages: [
              GetPage(
                name: '/',
                page: () => const Home(),
              ),
              GetPage(
                name: '/GymEatsMenu',
                page: () => const GymEatsMenuScreen(),
              ),
              GetPage(
                name: '/SignUpScreen',
                page: () => const SignUpScreen(),
              ),
              GetPage(
                name: '/PremiumScreen',
                page: () => const PremiumScreen(),
              ),
            GetPage(
                name: '/UserTypeScreen',
                page: () => const UserTypeScreen(),
              ),
            ],
          );
        },
      child: const UserTypeScreen(),
    );
  }
}
