import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/subscription/subscription_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/choose_store_screen.dart';
import 'package:gymeats_mobile/screen/journal/journal_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/meal_plan_home_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_screen.dart';
import 'package:gymeats_mobile/service/in_app_purchase_service.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class AppManagerScreen extends StatefulWidget {
  final String routeName;
  final int? selectIndex;
  final bool isOrderComplete;
  const AppManagerScreen({
    super.key,
    this.routeName = '',
    this.selectIndex,
    this.isOrderComplete = false,
  });

  @override
  State<AppManagerScreen> createState() => _AppManagerScreenState();
}

class _AppManagerScreenState extends State<AppManagerScreen>
    with WidgetsBindingObserver {
  int selectedIndex = 2;

  DateTime? currentBackPressTime;
  bool isLoading = false;
  bool hasPremium = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectIndex ?? 2;
    IapService.i.fetchStatus();
    Constant.i.handleStoreCache();
    Constant.i.storeCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // debugPrint('DASHBOARD SCREEN _______________________________');

        DateTime now = DateTime.now();

        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;

          return Future.value(false);
        }
        await SystemNavigator.pop();
        return Future.value(true);
      },
      child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        bloc: IapService.i.bloc,
        builder: (context, state) => Scaffold(
          body: getScreen(),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(AssetsUtils.icMealPlan,
                      color: selectedIndex == 0
                          ? AppColors.letsEatButton
                          : AppColors.middleGray),
                  label: StringUtils.mealPlan),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(AssetsUtils.icGrocery,
                      color: selectedIndex == 1
                          ? AppColors.letsEatButton
                          : AppColors.middleGray),
                  label: StringUtils.grocery),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(AssetsUtils.icDashboard,
                      color: selectedIndex == 2
                          ? AppColors.letsEatButton
                          : AppColors.middleGray),
                  label: StringUtils.dashboard),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(AssetsUtils.icRestaurants,
                      color: selectedIndex == 3
                          ? AppColors.letsEatButton
                          : AppColors.middleGray),
                  label: StringUtils.restaurants),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(AssetsUtils.icJournal,
                      color: selectedIndex == 4
                          ? AppColors.letsEatButton
                          : AppColors.middleGray),
                  label: StringUtils.journal),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: AppColors.letsEatButton,
            unselectedItemColor: AppColors.middleGray,
            unselectedLabelStyle: FontUtils.h10(
                fontColor: AppColors.letsEatButton, fontWeight: FWT.semiBold),
            selectedLabelStyle: FontUtils.h10(
                fontColor: AppColors.middleGray, fontWeight: FWT.bold),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            onTap: (int value) {
              setState(() {
                selectedIndex = value;
              });
            },
            elevation: 10,
          ),
        ),
        listener: (context, state) {
          if (state is SubscriptionStatusState) {
            if (state.status?.data == "Active") {
              PreferenceUtils.setBool(subscriptionStatus, true);
              hasPremium = true;
            } else {
              PreferenceUtils.setBool(subscriptionStatus, false);
              hasPremium = false;
              Get.offAllNamed("/PremiumScreen", parameters: {
                "fromDashboard": 'true',
              });
              setState(() {});
            }
          }

          if (state is SubscriptionStatusErrorState) {
            PreferenceUtils.setBool(subscriptionStatus, false);
            showToast(message: state.message, isSuccess: false);
            hasPremium = false;
            Get.offAllNamed("/PremiumScreen", parameters: {
              "fromDashboard": 'true',
            });
            setState(() {});
          }

          if (state is SubStatusLoader) {
            isLoading = state.loader;
            setState(() {});
          }
        },
      ),
    );
  }

  getScreen() {
    switch (selectedIndex) {
      case 0:
        return const MealPlanHomeScreen();
      case 1:
        return const ChooseGroceryStore();

      case 2:
        return DashBoardScreen(isOrderComplete: widget.isOrderComplete);
      case 3:
        return const RestaurantScreen();
      case 4:
        return const JournalScreen();
      default:
    }
  }
}
//JournalScreen

  