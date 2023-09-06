

// List<CameraDescription> cameras = [];

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/build_my_profile/build_my_profile_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/add_entry_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/add_water_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/first_dashboard_bg.dart';
import 'package:gymeats_mobile/screen/dashboard/order_details_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/order_history_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/second_dashboard_bg.dart';
import 'package:gymeats_mobile/screen/dashboard/third_dashboard_bg.dart';
import 'package:gymeats_mobile/screen/forgot_password/forgot_password_screen.dart';
import 'package:gymeats_mobile/screen/gender_screen/Gym_works_info.dart';
import 'package:gymeats_mobile/screen/gender_screen/first_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gender_screen/five_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gender_screen/forth_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gender_screen/gender_screen.dart';
import 'package:gymeats_mobile/screen/gender_screen/second_gym_instruction.dart';
import 'package:gymeats_mobile/screen/gender_screen/show_meal_plan_btn.dart';
import 'package:gymeats_mobile/screen/gender_screen/third_gym_instruction.dart';
import 'package:gymeats_mobile/screen/grocery/screen/address/add_delivery_address_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/address/map_address_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/address/search_delivery_address_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/checkout/checkoput_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/choose_store_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_cart_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_item_details.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_search_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/grocery_product_details_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/item_catalog_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/payment/add_card_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/payment/payment_card_selection_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/payment/payment_success_screen.dart';
import 'package:gymeats_mobile/screen/gym_eats_menu/gymeats_menu.dart';
import 'package:gymeats_mobile/screen/home/home.dart';
import 'package:gymeats_mobile/screen/journal/add_exercise_screen.dart';
import 'package:gymeats_mobile/screen/journal/add_new_item_screen.dart';
import 'package:gymeats_mobile/screen/journal/fifth_journal_bg.dart';
import 'package:gymeats_mobile/screen/journal/first_journal_bg.dart';
import 'package:gymeats_mobile/screen/journal/fourth_journal_bg.dart';
import 'package:gymeats_mobile/screen/journal/grocery_item_details_screen.dart';
import 'package:gymeats_mobile/screen/journal/journal_screen.dart';
import 'package:gymeats_mobile/screen/journal/scan_barcode_screen.dart';
import 'package:gymeats_mobile/screen/journal/second_journal_bg.dart';
import 'package:gymeats_mobile/screen/journal/sixth_journal_bg.dart';
import 'package:gymeats_mobile/screen/journal/third_journal_bg.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/arguments/meal_plan_arguments_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/best_match_restaurants/best_match_restaurants_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/food_preferences/food_preferences_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/invite_friend_screen/invite_friend_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/meal_details/meal_details_screen.dart';
import 'package:gymeats_mobile/screen/open_email/open_email_app_screen.dart';
import 'package:gymeats_mobile/screen/premiums/premium_screen.dart';
import 'package:gymeats_mobile/screen/reset_password/reset_password_screen.dart';
import 'package:gymeats_mobile/screen/sign_up/sign_up_screen.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_1.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_2.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_3.dart';
import 'package:gymeats_mobile/screen/signup_presonalized_welcome/personalized_welcome_4.dart';
import 'package:gymeats_mobile/screen/user_photo_selection/user_photo_selection_screen.dart';
import 'package:gymeats_mobile/screen/user_sign_up_info/user_sing_up_info_screen.dart';
import 'package:gymeats_mobile/screen/user_survey/user_survey_screen.dart';
import 'package:gymeats_mobile/screen/user_type/user_type_screen.dart';

import 'app/firebase_deep_link.dart';
import 'app/sharedPrefrence.dart';
import 'bloc/user_sign_up_info/user_sign_up_info_bloc.dart';
import 'bloc/user_sign_up_info/user_sign_up_info_event.dart';
import 'screen/login/login_screen.dart';


// import this all  file
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();
  await PreferenceUtils.init();
  await Firebase.initializeApp(
    name: 'GymEats',
    options: FirebaseOptions(apiKey: apiKey, appId: appId, messagingSenderId: messagingSenderId, projectId: projectId),
  );
  await initDynamicLinks();
  if (PreferenceUtils.getBool(prefIsLogin)) {
    if (PreferenceUtils.getBool(prefIsConfirmEmail)) {
      userId = PreferenceUtils.getString(prefUserData);
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final UserSignUpInfoBloc bloc = UserSignUpInfoBloc();

  @override
  Widget build(BuildContext context) {
    bloc.add(LatLogEvent());
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
          initialRoute: PreferenceUtils.getBool(prefIsLogin) && PreferenceUtils.getBool(prefIsConfirmEmail) ? '/AppManagerScreen' : '/AppManagerScreen',
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
              name: '/AppManagerScreen',
              page: () => const AppManagerScreen(),
            ),
            GetPage(
              name: '/ChooseStoreScreen',
              page: () => const ChooseStoreScreen(),
            ),
            GetPage(
              name: '/MealDetailsScreen',
              page: () {
                MealPlanArguments? argument = (Get.arguments is MealPlanArguments) ? Get.arguments : null;
                return MealDetailsScreen(mealDataArguments: argument);
              },
            ),
            GetPage(
              name: '/GrocerySearchScreen',
              page: () => const GrocerySearchScreen(),
            ),
            GetPage(
              name: '/GroceryProductDetails',
              page: () => const GroceryProductDetails(),
            ),
            GetPage(
              name: '/GroceryCartScreen',
              page: () => const GroceryCartScreen(),
            ),
            GetPage(
              name: '/GroceryItemDetails',
              page: () => const GroceryItemDetails(),
            ),
            GetPage(
              name: '/FoodPreferencesScreen',
              page: () => const FoodPreferencesScreen(),
            ),
            GetPage(
              name: '/BestMatchRestaurantsScreen',
              page: () => const BestMatchRestaurantsScreen(),
            ),
            GetPage(
              name: '/CheckoutScreen',
              page: () => const CheckoutScreen(),
            ),
            GetPage(
              name: '/PaymentCardSelectionScreen',
              page: () => const PaymentCardSelectionScreen(),
            ),
            GetPage(
              name: '/AddCardScreen',
              page: () => const AddCardScreen(),
            ),
            GetPage(
              name: '/DashboardScreen',
              page: () => const DashBoardScreen(),
            ),
            GetPage(
              name: '/GymEatsMenuScreen',
              page: () => const GymEatsMenuScreen(),
            ),
            GetPage(
              name: '/InviteFriendScreen',
              page: () => const InviteFriendScreen(),
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
              name: '/UserSurveyScreen',
              page: () => const UserSurveyScreen(),
            ),
            GetPage(
              name: '/GenderScreen',
              page: () => const GenderScreen(),
            ),
            GetPage(
              name: '/GymInstructionScreen',
              page: () => GymInstructionScreen(),
            ),
            GetPage(
              name: '/SecondGymInstructionScreen',
              page: () => SecondGymInstructionScreen(),
            ),
            GetPage(
              name: '/ThirdGymInstructionScreen',
              page: () => ThirdGymInstructionScreen(),
            ),
            GetPage(
              name: '/MapAddressScreen',
              page: () => const MapAddressScreen(),
            ),
            GetPage(
              name: '/SearchDeliveryAddressScreen',
              page: () => const SearchDeliveryAddressScreen(),
            ),
            GetPage(
              name: '/PaymentSuccessScreen',
              page: () => const PaymentSuccessScreen(),
            ),
            GetPage(
              name: '/AddDeliveryAddressScreen',
              page: () => const AddDeliveryAddressScreen(),
            ),
            GetPage(
              name: '/FourthGymInstructionScreen',
              page: () => FourthGymInstructionScreen(),
            ),
            GetPage(
              name: '/ItemCatalogScreen',
              page: () => const ItemCatalogScreen(),
            ),
            GetPage(
              name: '/FiveGymInstructionScreen',
              page: () => FiveGymInstructionScreen(),
            ),
            GetPage(
              name: '/ShowMealPlanBtnScreen',
              page: () => ShowMealPlanBtnScreen(),
            ),
            GetPage(
              name: '/FirstDashBoardView',
              page: () => const FirstDashBoardView(),
            ),
            GetPage(
              name: '/SecondDashBoardView',
              page: () => const SecondDashBoardView(),
            ),
            GetPage(
              name: '/ThirdDashBoardView',
              page: () => const ThirdDashBoardView(),
            ),
            GetPage(
              name: '/DashBoardScreen',
              page: () => const DashBoardScreen(),
            ),
            GetPage(
              name: '/AddWaterScreen',
              page: () => const AddWaterScreen(),
            ),
            GetPage(
              name: '/AddEntryScreen',
              page: () => const AddEntryScreen(),
            ),
            GetPage(
              name: '/OrderHistoryScreen',
              page: () => const OrderHistoryScreen(),
            ),
            GetPage(
              name: '/UserPhotoSelectionScreen',
              page: () => const UserPhotoSelectionScreen(),
            ),
            GetPage(
              name: '/UserSignUpInfoScreen',
              page: () => const UserSignUpInfoScreen(),
            ),
            GetPage(
              name: '/FirstPersonalizedWelcomeScreen',
              page: () => const FirstPersonalizedWelcomeScreen(),
            ),
            GetPage(
              name: '/SecondPersonalizedWelcomeScreen',
              page: () => const SecondPersonalizedWelcomeScreen(),
            ),
            GetPage(
              name: '/ThirdPersonalizedWelcomeScreen',
              page: () => const ThirdPersonalizedWelcomeScreen(),
            ),
            GetPage(
              name: '/FourthPersonalizedWelcomeScreen',
              page: () => const FourthPersonalizedWelcomeScreen(),
            ),
            GetPage(
              name: '/BuildMyProfileScreen',
              page: () => const BuildMyProfileScreen(),
            ),
            GetPage(
              name: '/OrderDetailsScreen',
              page: () => const OrderDetailsScreen(),
            ),
            GetPage(
              name: '/GymWorkInfoScreen',
              page: () => const GymWorkInfoScreen(),
            ),
            GetPage(
              name: '/FirstJournalBGView',
              page: () => const FirstJournalBGView(),
            ),
            GetPage(
              name: '/SecondJournalBGView',
              page: () => const SecondJournalBGView(),
            ),
            GetPage(
              name: '/ThirdJournalBGView',
              page: () => const ThirdJournalBGView(),
            ),
            GetPage(
              name: '/ForthJournalBGView',
              page: () => const ForthJournalBGView(),
            ),
            GetPage(
              name: '/FifthJournalBGView',
              page: () => const FifthJournalBGView(),
            ),
            GetPage(
              name: '/SixJournalBGView',
              page: () => const SixJournalBGView(),
            ),
            GetPage(
              name: '/JournalScreen',
              page: () => const JournalScreen(),
            ),
            GetPage(
              name: '/AddExerciseScreen',
              page: () => const AddExerciseScreen(),
            ),
            GetPage(
              name: '/ScanBarcodeScreen',
              page: () => const ScanBarcodeScreen(/*cameras: cameras*/),
            ),
            GetPage(
              name: '/GroceryItemDetailsScreen',
              page: () => const GroceryItemDetailsScreen(),
            ),
            GetPage(
              name: '/AddNewItemScreen',
              page: () => const AddNewItemScreen(),
            ),
            GetPage(
              name: '/MealScreen',
              page: () => const MealScreen(),
            ),
          ],
        );
      },
      child: const Home(),
    );
  }
}
