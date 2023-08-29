import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_event.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/skip_meal_bottomsheet.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/swap_meal_bottomsheet.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../app/sharedPrefrence.dart';
import '../../widget/app_center_loader.dart';

class MealPlanHomeScreen extends StatefulWidget {
  const MealPlanHomeScreen({super.key});

  @override
  State<MealPlanHomeScreen> createState() => _MealPlanHomeScreenState();
}

class _MealPlanHomeScreenState extends State<MealPlanHomeScreen> {
  final routeName = '/MealPlanHomeScreen';
  int selectedDayIndex = 0;
  final PageController _pageController = PageController();

  MealPlanBloc bloc = MealPlanBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bloc.add(MealPlanFetchEvent(userID: userId!, calorie: 1000));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<MealPlanBloc, FetchMealPlanState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is FetchMealPlanSuccessState) {}
          },
          builder: (context, state) {
            return SafeArea(
              child: SizedBox(
                height: size.height.h,
                width: size.width.w,
                child: Column(
                  children: [
                    Image.asset(
                      AssetsUtils.gymEatsLogo,
                      height: 20.h,
                      width: 56.w,
                      color: AppColors.primaryBlue,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AssetsUtils.user,
                          height: 25.h,
                          width: 25.w,
                          color: AppColors.darkGray,
                        ),
                        Text(StringUtils.mealPlan,
                            style:
                                FontUtils.h20(fontColor: AppColors.oxFF010101)),
                        Image.asset(
                          AssetsUtils.filter,
                          height: 20.h,
                          width: 20.w,
                          color: AppColors.darkGray,
                        )
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                    Divider(color: AppColors.darkGray, height: 3.h),
                    Text(
                            state is FetchMealPlanSuccessState
                                ? StringUtils.regenerateGroceryList
                                : StringUtils.showGroceryList,
                            style: FontUtils.h18(
                                fontColor: AppColors.primaryBlue,
                                fontWeight: FWT.medium))
                        .paddingSymmetric(vertical: 10.h),
                    state is FetchMealPlanLoadingState
                        ? const SizedBox()
                        : state is FetchMealPlanSuccessState
                            ? Container(
                                color: Colors.grey.withOpacity(0.05),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${StringUtils.day} ${state.mealPlanList[selectedDayIndex].day}',
                                      style: FontUtils.h20(
                                          fontColor: AppColors.middleGray,
                                          fontWeight: FWT.medium),
                                    ),
                                    Wrap(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (selectedDayIndex == 0) {
                                                return;
                                              }
                                              _pageController.jumpToPage(
                                                  selectedDayIndex - 1);
                                            },
                                            child: arrowButton(
                                                    icon: AssetsUtils.arrowBack,
                                                    isDisable:
                                                        selectedDayIndex == 0)
                                                .paddingOnly(right: 8.w)),
                                        GestureDetector(
                                            onTap: () {
                                              if (selectedDayIndex ==
                                                  state.mealPlanList.length -
                                                      1) {
                                                return;
                                              }
                                              _pageController.jumpToPage(
                                                  selectedDayIndex + 1);
                                            },
                                            child: arrowButton(
                                                icon: AssetsUtils.arrowForward,
                                                isDisable: selectedDayIndex ==
                                                    state.mealPlanList.length -
                                                        1)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                    state is FetchMealPlanLoadingState
                        ? const SizedBox()
                        : state is FetchMealPlanSuccessState
                            ? Expanded(
                                child: PageView(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  onPageChanged: (int? value) {
                                    setState(() {
                                      selectedDayIndex = value ?? 0;
                                    });
                                    debugPrint('CURRENT PAGE : $value');
                                  },
                                  children: state.mealPlanList.map((e) {
                                    return SingleChildScrollView(
                                      child: ListView.builder(
                                        itemCount: e.meals!.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return mealPlanCard(
                                            mealData: e.meals![index],
                                            // image: e.meals![index].recipe!.mainImage,
                                            // mealTitle: e.meals![index].meal,
                                            // mealDescription: e.meals![index].recipe!.name,
                                            // mealCal: '${e.meals![index].calories!.toStringAsFixed(2)} cal',
                                            context: context,
                                            onSkipMealTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return const SkipMealBottomSheet();
                                                  });
                                            },
                                            onSwapMealTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return const SwapMealBottomSheet();
                                                  });
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : const SizedBox(),
                    state is FetchMealPlanLoadingState
                        ? const Expanded(child: AppCenterLoader())
                        : const SizedBox(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
