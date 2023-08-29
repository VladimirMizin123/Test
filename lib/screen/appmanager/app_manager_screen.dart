

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/grocery/grocery_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/meal_plan_home_screen.dart';

class AppManagerScreen extends StatefulWidget {
  final String routeName;
  const AppManagerScreen({super.key, this.routeName = ''});

  @override
  State<AppManagerScreen> createState() => _AppManagerScreenState();
}

class _AppManagerScreenState extends State<AppManagerScreen> with WidgetsBindingObserver {
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icMealPlan, color: selectedIndex == 0 ? AppColors.letsEatButton : AppColors.middleGray), label: StringUtils.mealPlan),
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icGrocery, color: selectedIndex == 1 ? AppColors.letsEatButton : AppColors.middleGray), label: StringUtils.grocery),
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icDashboard, color: selectedIndex == 2 ? AppColors.letsEatButton : AppColors.middleGray), label: StringUtils.dashboard),
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icRestaurants, color: selectedIndex == 3 ? AppColors.letsEatButton : AppColors.middleGray), label: StringUtils.restaurants),
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icJournal, color: selectedIndex == 4 ? AppColors.letsEatButton : AppColors.middleGray), label: StringUtils.journal),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.letsEatButton,
        unselectedItemColor: AppColors.middleGray,
        unselectedLabelStyle: FontUtils.h10(fontColor: AppColors.letsEatButton, fontWeight: FWT.semiBold),
        selectedLabelStyle: FontUtils.h10(fontColor: AppColors.middleGray, fontWeight: FWT.bold),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 10,
      ),
    );
  }
  getScreen() {
    switch (selectedIndex) {
      case 0:
        return const MealPlanHomeScreen();
      case 1:
        return const GroceryPlanScreen();
      case 2:
        return const DashBoardScreen();
      case 3:
        return Container();
      case 4:
        return Container();
      default:
    }
  }
}