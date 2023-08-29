import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_bloc.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_event.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/skip_meal_bottomsheet.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/swap_meal_bottomsheet.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../widget/app_center_loader.dart';

class GroceryPlanScreen extends StatefulWidget {
  const GroceryPlanScreen({super.key});

  @override
  State<GroceryPlanScreen> createState() => _GroceryPlanScreenState();
}

class _GroceryPlanScreenState extends State<GroceryPlanScreen> {
  final routeName = '/MealPlanHomeScreen';
  int selectedDayIndex = 0;
  final PageController _pageController = PageController();
  List<FetchMealPlanData> mealPlanList = [];

  MealPlanBloc bloc = MealPlanBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bloc.add(MealPlanFetchEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<MealPlanBloc, FetchMealPlanState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is FetchMealPlanSuccessState) {
              mealPlanList = state.mealPlanList;
            }

            if (state is SkipMealPlanLoadingState) {}
            if (state is SkipMealPlanSuccessState) {
              log('SKIP MEAL PLAN');
              for (var i = 0; i < mealPlanList.length; i++) {
                for (var j = 0; j < mealPlanList[i].meals!.length; j++) {
                  if (mealPlanList[i].meals![j].id == state.mealID) {
                    mealPlanList[i].meals![j].isSkipped = true;
                  }
                }
              }
            }
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
                        Text(StringUtils.mealPlan, style: FontUtils.h20(fontColor: AppColors.oxFF010101)),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/FoodPreferencesScreen');
                          },
                          child: Image.asset(
                            AssetsUtils.filter,
                            height: 20.h,
                            width: 20.w,
                            color: AppColors.darkGray,
                          ),
                        )
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                    Divider(color: AppColors.darkGray, height: 3.h),
                    Text(state is FetchMealPlanSuccessState ? StringUtils.regenerateGroceryList : 'Clear My Grocery List', style: FontUtils.h18(fontColor: AppColors.primaryBlue, fontWeight: FWT.medium)).paddingSymmetric(vertical: 10.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search for item',
                          hintStyle: FontUtils.h16(),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    ListView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppColors.appColor,
                                    value: true,
                                    onChanged: (bool? value) {},
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'almond milk',
                                    style: FontUtils.h16(fontColor: AppColors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(6)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          child: Center(child: Text('GYM EATS')),
                                        ),
                                      )),
                                  SizedBox(width: 8.w),
                                  Container(
                                    height: size.height * 0.065,
                                    width: size.height * 0.065,
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.skyBlue), borderRadius: BorderRadius.circular(6)),
                                    child: Center(child: SvgPicture.asset(AssetsUtils.icDelete)),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    height: size.height * 0.065,
                                    width: size.height * 0.065,
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                        child: Text(
                                      '1',
                                      style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                    )),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    height: size.height * 0.065,
                                    width: size.height * 0.065,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.disable),
                                      borderRadius: BorderRadius.circular(6),
                                      color: AppColors.skyBlue,
                                    ),
                                    child: const Center(child: Icon(Icons.add, size: 27)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              const Divider(color: AppColors.disable),
                              SizedBox(height: 5.h),
                            ],
                          ),
                        );
                      },
                    ),
                    mealPlanList.isEmpty
                        ? const SizedBox()
                        : Container(
                            color: Colors.grey.withOpacity(0.05),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${StringUtils.day} ${mealPlanList[selectedDayIndex].day}',
                                  style: FontUtils.h20(fontColor: AppColors.middleGray, fontWeight: FWT.medium),
                                ),
                                Wrap(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (selectedDayIndex == 0) {
                                            return;
                                          }
                                          _pageController.jumpToPage(selectedDayIndex - 1);
                                        },
                                        child: arrowButton(icon: AssetsUtils.arrowBack, isDisable: selectedDayIndex == 0).paddingOnly(right: 8.w)),
                                    GestureDetector(
                                        onTap: () {
                                          if (selectedDayIndex == mealPlanList.length - 1) {
                                            return;
                                          }
                                          _pageController.jumpToPage(selectedDayIndex + 1);
                                        },
                                        child: arrowButton(icon: AssetsUtils.arrowForward, isDisable: selectedDayIndex == mealPlanList.length - 1)),
                                  ],
                                )
                              ],
                            ),
                          ),
                    mealPlanList.isEmpty
                        ? state is FetchMealPlanLoadingState
                            ? const Expanded(child: AppCenterLoader())
                            : const SizedBox()
                        : Expanded(
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              onPageChanged: (int? value) {
                                setState(() {
                                  selectedDayIndex = value ?? 0;
                                });
                                debugPrint('CURRENT PAGE : $value');
                              },
                              children: mealPlanList.map((e) {
                                return SingleChildScrollView(
                                  child: ListView.builder(
                                    itemCount: e.meals!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return mealPlanCard(
                                        mealData: e.meals![index],
                                        context: context,
                                        onSkipMealTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return SkipMealBottomSheet(
                                                  bloc: bloc,
                                                  mealData: e.meals![index],
                                                );
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
                          ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
