import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/bloc_screen/bloc_demo.dart';
import 'package:gymeats_mobile/screen/gender_screen/Gym_works_info.dart';
import 'package:gymeats_mobile/screen/gender_screen/five_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gender_screen/forth_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gender_screen/gender_screen.dart';
import 'package:gymeats_mobile/screen/gender_screen/first_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gender_screen/second_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gender_screen/show_meal_plan_btn.dart';
import 'package:gymeats_mobile/screen/gender_screen/third_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gym_eats_menu/gymeats_menu.dart';
import 'package:gymeats_mobile/screen/home/home.dart';
import 'package:gymeats_mobile/screen/login/forgot_password.dart';
import 'package:gymeats_mobile/screen/login/login.dart';
import 'package:gymeats_mobile/screen/login/open_email_app.dart';
import 'package:gymeats_mobile/screen/login/reset_password.dart';
import 'package:gymeats_mobile/screen/premiums/premium_screen.dart';
import 'package:gymeats_mobile/screen/sign_up/sign_up_screen.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';

void main() {
  runApp(const MyApp());
}

enum GENDER { NON, MALE, FEMALE }

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
            initialRoute: '/forgot-password',
            getPages: [
              GetPage(
                name: '/login',
                page: () => const LoginScreen(),
              ),
              GetPage(
                name: '/reset-password',
                page: () => const ResetPasswordScreen(),
              ),
              GetPage(
                name: '/open-email-app',
                page: () => const OpenEmailAppScreen(),
              ),
              GetPage(
                name: '/forgot-password',
                page: () => const ForgotPasswordScreen(),
              ),
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
                name: '/GenderScreen',
                page: () => const GenderScreen(),
              ),
              GetPage(
                name: '/GymWorkInfo',
                page: () => const GymWorkInfoScreen(),
              ),
              GetPage(
                name: '/GymInstruction',
                page: () => const GymInstructionScreen(),
              ),
              GetPage(
                name: '/SecondGymInstruction',
                page: () => const SecondGymInstructionScreen(),
              ),
              GetPage(
                name: '/ThirdGymInstruction',
                page: () => const ThirdGymInstructionScreen(),
              ),
              GetPage(
                name: '/FourthGymInstruction',
                page: () => const FourthGymInstructionScreen(),
              ),
              GetPage(
                name: '/FiveGymInstruction',
                page: () => const FiveGymInstructionScreen(),
              ),
              GetPage(
                name: '/ShowMealPlanBtn',
                page: () => const ShowMealPlanBtnScreen(),
              ),
            ],
          );
        },
        child: const GymWorkInfoScreen());
  }
}
