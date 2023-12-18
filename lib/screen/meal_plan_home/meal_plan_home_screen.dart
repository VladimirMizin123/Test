import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_screen.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/arguments/meal_plan_arguments_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/skip_meal_bottomsheet.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/swap_meal_bottomsheet.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/food_preferences/food_preferences_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

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
  List<FetchMealPlanData> mealPlanList = [];
  List<MealDataByDate> mealDataByDate = [];
  bool isLoadingData = false;
  bool isReadyToShowWidget = false;
  MealPlanBloc mealPlanBloc = MealPlanBloc();

  getData() {
    mealPlanList = box.read('mealPlan');

    for (var i = 0; i < mealPlanList.length; i++) {
      mealPlanBloc.add(GetMealLogByDateEvent(
          date:
              "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"));
      break;
    }
  }

  @override
  void initState() {
    super.initState();
    log("INIT STATE");
    getData();
    //mealPlanBloc.add(MealPlanFetchEvent());
    // print('DATATATATA >>>>> ${box.read('mealPlan')}');
  }

  final box = GetStorage();
  bool hasGrocery = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<MealPlanBloc, FetchMealPlanState>(
          bloc: mealPlanBloc,
          listener: (context, state) async {
            if (state is FetchMealPlanSuccessState) {
              mealPlanList = state.mealPlanList;
              isLoadingData = false;
              for (var i = 0; i < mealPlanList.length; i++) {
                mealPlanBloc.add(GetMealLogByDateEvent(
                    date:
                        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"));
                break;
              }
            }

            if (state is FetchMealPlanLoadingState) {
              isLoadingData = true;
            }
            log("state == > $state");
            if (state is OnGetMealLogByDateSuccessState) {
              // MAKE SKIP OBJECT FROM HERE,,,,,
              mealDataByDate = state.modelData ?? [];

              for (var k = 0; k < mealDataByDate.length; k++) {
                // print('K --- $k');
                for (var i = 0; i < mealPlanList.length; i++) {
                  for (var j = 0; j < mealPlanList[i].meals!.length; j++) {
                    // print('${mealPlanList[i].meals![j].id == mealDataByDate[k].mealId}');
                    if (mealPlanList[i].meals![j].id ==
                            mealDataByDate[k].mealId &&
                        mealDataByDate[k].value == 'SKIPPED') {
                      mealPlanList[i].meals![j].isSkipped = true;
                    }
                  } // TWVhbDoxNTQ2NDM1NzY=
                }
              }

              for (var i = 0; i < mealPlanList.length; i++) {
                if (mealPlanList[i].date!.year == DateTime.now().year &&
                    mealPlanList[i].date!.month == DateTime.now().month &&
                    mealPlanList[i].date!.day == DateTime.now().day) {
                  print('JUMP DAY :::: ${mealPlanList.length}');
                  print('JUMP DAY :::: $i');
                  _pageController.jumpToPage(i);
                  isReadyToShowWidget = true;
                  break;
                }
              }
              log(state.hasGrocery.toString(), name: "HAS GROCERY");

              hasGrocery = state.hasGrocery;
              print("===>>>>>" + hasGrocery.toString());
              setState(() {});
            }

            if (state is FetchMealPlanErrorState) {
              for (var i = 0; i < mealPlanList.length; i++) {
                if (mealPlanList[i].date!.year == DateTime.now().year &&
                    mealPlanList[i].date!.month == DateTime.now().month &&
                    mealPlanList[i].date!.day == DateTime.now().day) {
                  print('JUMP DAY :::: ${mealPlanList.length}');
                  print('JUMP DAY :::: $i');
                  _pageController.jumpToPage(i);
                  isReadyToShowWidget = true;
                  break;
                }
              }
              log(state.hasGrocery.toString(), name: "HAS GROCERY");

              hasGrocery = state.hasGrocery;
            }

            if (state is SwapMealDetailsState) {
              Get.back();
              for (var i = 0; i < mealPlanList.length; i++) {
                // print("${mealPlanList[i].day} == ${state.day}");
                if (mealPlanList[i].date == state.dateTime) {
                  for (var j = 0; j < mealPlanList[i].meals!.length; j++) {
                    print("${mealPlanList[i].meals![j].id} == ${state.mealId}");
                    if (mealPlanList[i].meals![j].id == state.mealId) {
                      mealPlanList[i].meals![j].id = state.similarMealData!.id;
                      mealPlanList[i].meals![j].meal =
                          state.similarMealData!.mealTags![0]; //
                      mealPlanList[i].meals![j].recipe!.name =
                          state.similarMealData!.name; //
                      mealPlanList[i].meals![j].numOfServings =
                          state.similarMealData!.serving;
                      mealPlanList[i].meals![j].recipe!.id =
                          state.similarMealData!.id;
                      mealPlanList[i].meals![j].calories = state
                          .similarMealData!.nutrientsPerServing!.calories; //
                      mealPlanList[i].meals![j].recipe!.mainImage =
                          state.similarMealData!.mainImage;
                      mealPlanList[i].meals![j].recipe!.databaseId =
                          state.similarMealData!.databaseId;
                      mealPlanList[i].meals![j].recipe!.serving =
                          state.similarMealData!.serving;
                      mealPlanList[i].meals![j].numOfServings =
                          state.similarMealData!.numberOfServings;
                      mealPlanList[i].meals![j].recipe!.serving =
                          state.similarMealData!.serving;
                      mealPlanList[i].meals![j].recipe!.instructions =
                          state.similarMealData!.instructions;
                      mealPlanList[i]
                              .meals![j]
                              .recipe!
                              .nutrientsPerServing!
                              .calories =
                          state.similarMealData!.nutrientsPerServing!.calories;
                      mealPlanList[i]
                              .meals![j]
                              .recipe!
                              .nutrientsPerServing!
                              .carbs =
                          state.similarMealData!.nutrientsPerServing!.carbs;
                      mealPlanList[i]
                              .meals![j]
                              .recipe!
                              .nutrientsPerServing!
                              .fat =
                          state.similarMealData!.nutrientsPerServing!.fat;
                      mealPlanList[i]
                              .meals![j]
                              .recipe!
                              .nutrientsPerServing!
                              .protein =
                          state.similarMealData!.nutrientsPerServing!.protein;
                      break;
                    }
                  }
                  break;
                }
              }
            }
            if (state is SkipMealPlanSuccessState) {
              log('SKIP MEAL PLAN');
              for (var i = 0; i < mealPlanList.length; i++) {
                for (var j = 0; j < mealPlanList[i].meals!.length; j++) {
                  if (mealPlanList[i].meals![j].id == state.mealID) {
                    mealPlanList[i].meals![j].isSkipped = true;
                  }
                } // TWVhbDoxNTQ2NDM1NzY=
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountScreen(),
                                ));
                          },
                          child: Image.asset(
                            AssetsUtils.user,
                            height: 25.h,
                            width: 25.w,
                            color: AppColors.darkGray,
                          ),
                        ),
                        Text(StringUtils.mealPlan,
                            style:
                                FontUtils.h20(fontColor: AppColors.oxFF010101)),
                        GestureDetector(
                          onTap: () {
                            // Get.toNamed('/FoodPreferencesScreen');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const FoodPreferencesScreen();
                            })).then((value) {
                              mealPlanBloc.add(MealPlanFetchEvent());
                            });
                          },
                          child: Image.asset(
                            AssetsUtils.filter,
                            height: 20.h,
                            width: 20.w,
                            color: AppColors.darkGray,
                          ),
                        )
                      ],
                    ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                    Divider(color: AppColors.darkGray, height: 3.h),

                    state is ClearGroceryListLoadingState
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )
                        : GestureDetector(
                            onTap: () {
                              log(hasGrocery.toString());
                              hasGrocery
                                  ? Get.offAll(
                                      () => const AppManagerScreen(
                                        selectIndex: 1,
                                      ),
                                    )
                                  : mealPlanBloc
                                      .add(ClearUserGroceryMealPlanEvent());
                            },
                            child: Text(
                                    hasGrocery
                                        ? StringUtils.showGroceryList
                                        : StringUtils.regenerateGroceryList,
                                    style: FontUtils.h18(
                                        fontColor: AppColors.primaryBlue,
                                        fontWeight: FWT.medium))
                                .paddingSymmetric(vertical: 10.h),
                          ),

                    ///
                    // state is ClearGroceryListLoadingState
                    //     ? const Center(
                    //         child: Padding(
                    //           padding: EdgeInsets.symmetric(vertical: 20),
                    //           child: CircularProgressIndicator(),
                    //         ),
                    //       )
                    //     : GestureDetector(
                    //         onTap: () {
                    //           setState(() {
                    //             // searchGroceryDetails.clear();
                    //             // checkbox.clear();
                    //           });
                    //           // addNewGroceryItemBloc.add(ClearUserGroceryEvent());
                    //         },
                    //         child: Text(StringUtils.regenerateGroceryList,
                    //                 style: FontUtils.h18(
                    //                     fontColor: AppColors.primaryBlue,
                    //                     fontWeight: FWT.medium))
                    //             .paddingSymmetric(vertical: 10.h),
                    //       ),

                    mealPlanList.isEmpty
                        ? const SizedBox()
                        : isReadyToShowWidget
                            ? Container(
                                color: Colors.grey.withOpacity(0.05),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${StringUtils.day} ${mealPlanList[selectedDayIndex].day}',
                                      style: FontUtils.h20(
                                          fontColor: AppColors.middleGray,
                                          fontWeight: FWT.medium),
                                    ),
                                    Wrap(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (selectedDayIndex == 0) {
                                                _pageController.jumpToPage(
                                                    selectedDayIndex + 1);
                                              } else {
                                                _pageController.jumpToPage(
                                                    selectedDayIndex + 1);
                                              }
                                            },
                                            child: arrowButton(
                                                    icon: AssetsUtils.arrowBack,
                                                    isDisable:
                                                        selectedDayIndex ==
                                                            mealPlanList
                                                                    .length -
                                                                1)
                                                .paddingOnly(right: 8.w)),
                                        GestureDetector(
                                          onTap: () {
                                            if (selectedDayIndex ==
                                                mealPlanList.length) {
                                            } else {
                                              _pageController.jumpToPage(
                                                  selectedDayIndex - 1);
                                            }
                                          },
                                          child: arrowButton(
                                              icon: AssetsUtils.arrowForward,
                                              isDisable: selectedDayIndex == 0
                                              // isDisable: selectedDayIndex ==
                                              //     mealPlanList.length - 1,
                                              ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Opacity(
                                opacity: 0,
                                child: Container(
                                  color: Colors.grey.withOpacity(0.05),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 8.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '',
                                        style: FontUtils.h20(
                                            fontColor: AppColors.middleGray,
                                            fontWeight: FWT.medium),
                                      ),
                                      Wrap(
                                        children: [
                                          arrowButton(
                                                  icon: AssetsUtils.arrowBack,
                                                  isDisable:
                                                      selectedDayIndex == 0)
                                              .paddingOnly(right: 8.w),
                                          arrowButton(
                                              icon: AssetsUtils.arrowForward,
                                              isDisable: selectedDayIndex ==
                                                  mealPlanList.length - 1),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                    mealPlanList.isEmpty
                        ? const SizedBox()
                        : Expanded(
                            child: Stack(
                              children: [
                                PageView(
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return mealPlanCard(
                                            onTap: () {
                                              Get.toNamed('/MealDetailsScreen',
                                                  arguments: MealPlanArguments(
                                                      mealData:
                                                          e.meals![index]));
                                            },
                                            mealData: e.meals![index],
                                            context: context,
                                            onSkipMealTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return SkipMealBottomSheet(
                                                    bloc: mealPlanBloc,
                                                    mealData: e.meals![index],
                                                  );
                                                },
                                                isDismissible: false,
                                              );
                                            },
                                            onSwapMealTap: () {
                                              // print(e.meals![index].id);

                                              // for (var i = 0; i < mealPlanList.length; i++) {
                                              //   for (var j = 0; j < mealPlanList[i].meals!.length; j++) {
                                              //     if (mealPlanList[i].meals![j].id == e.meals![index].id) {
                                              //       print("${mealPlanList[i].meals![j].id} == ${e.meals![index].id}");
                                              //     }
                                              //     break;
                                              //   }
                                              // }
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return SwapMealBottomSheet(
                                                    mealPlanBloc: mealPlanBloc,
                                                    mealData: e.meals![index],
                                                    day: e.day,
                                                    dateTime: e.date,
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                                isReadyToShowWidget
                                    ? const SizedBox()
                                    : Container(
                                        color: Colors.white,
                                        child: const AppCenterLoader(),
                                      ),
                              ],
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
