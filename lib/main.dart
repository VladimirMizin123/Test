// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/build_my_profile/build_my_profile_screen.dart';
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
import 'package:gymeats_mobile/screen/meal_plan_home/meal_plan_home_screen.dart';
import 'package:gymeats_mobile/screen/reset_password/reset_password_screen.dart';
import 'package:gymeats_mobile/screen/login/login_screen.dart';
import 'package:gymeats_mobile/screen/open_email/open_email_app_screen.dart';
import 'package:gymeats_mobile/screen/forgot_password/forgot_password_screen.dart';
import 'package:gymeats_mobile/screen/premiums/premium_screen.dart';
import 'package:gymeats_mobile/screen/sign_up/sign_up_screen.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_1.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_2.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_3.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_4.dart';
import 'package:gymeats_mobile/screen/user_photo_selection/user_photo_selection_screen.dart';
import 'package:gymeats_mobile/screen/user_survey/user_survey_screen.dart';
import 'package:gymeats_mobile/screen/user_type/user_type_screen.dart';
import 'app/firebase_deep_link.dart';
import 'app/sharedPrefrence.dart';
import 'constant/app_string.dart';
import 'models/get_survey_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceUtils.init();
  /*await Firebase.initializeApp(
    name: 'GymEats',
    options: FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId),
  );*/
  // initDynamicLinks();
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
          initialRoute: '/FourthPersonalizedWelcome',
          getPages: [
            GetPage(
              name: '/LoginScreen',
              page: () => const LoginScreen(),
            ),
            GetPage(
              name: '/ForgotPasswordScreen',
              page: () => const ForgotPasswordScreen(),
            ),
            GetPage(
              name: '/OpenEmailAppScreen',
              page: () => const OpenEmailAppScreen(),
            ),
            GetPage(
              name: '/ResetPasswordScreen',
              page: () => const ResetPasswordScreen(),
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
              name: '/UserTypeScreen',
              page: () => const UserTypeScreen(),
            ),
            GetPage(
              name: '/UserInfoSelectionScreen',
              page: () => const UserSurveyScreen(gender: ''),
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
            GetPage(
              name: '/MealPlanHomeScreen',
              page: () => const MealPlanHomeScreen(),
            ),
            GetPage(
              name: '/UserPhotoSelectionScreen',
              page: () => const UserPhotoSelectionScreen(),
            ),
            GetPage(
              name: '/FirstPersonalizedWelcome',
              page: () => const FirstPersonalizedWelcomeScreen(),
            ),
            GetPage(
              name: '/SecondPersonalizedWelcome',
              page: () => const SecondPersonalizedWelcomeScreen(),
            ),
            GetPage(
              name: '/ThirdPersonalizedWelcome',
              page: () => const ThirdPersonalizedWelcomeScreen(),
            ),
            GetPage(
              name: '/FourthPersonalizedWelcome',
              page: () => const FourthPersonalizedWelcomeScreen(),
            ),
            GetPage(
              name: '/build_my_profile_screen',
              page: () => const BuildMyProfileScreen(),
            ),
          ],
        );
      },
      child: const FourthPersonalizedWelcomeScreen(),
      // child: const UserSurveyScreen(gender: AppStrings.male,),
    );
  }
}
