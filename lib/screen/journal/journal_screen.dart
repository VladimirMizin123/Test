import 'dart:developer';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_event.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_item_state.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_state.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/daily_recap_modal.dart';
import 'package:gymeats_mobile/models/get_custom_meal_list_model.dart';
import 'package:gymeats_mobile/models/get_meal_tracker_data_model.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/dashboard/add_water_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/edit_water_screen.dart';
import 'package:gymeats_mobile/screen/journal/exercise/add_exercise_screen.dart';
import 'package:gymeats_mobile/screen/journal/journal_meal_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';

import 'package:gymeats_mobile/app/functions.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_event.dart';
import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/exercise_log_details_model.dart';
import '../../models/fetch_meal_plan_model.dart';
import '../../models/get_dashboard_model.dart';
import '../../models/water_log_details_model.dart';
import '../../widget/app_center_loader.dart';
import '../dashboard/add_entry_screen.dart';
import '../grocery/screen/grocery_item_details.dart';
import '../meal_plan_home/arguments/meal_plan_arguments_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final routeName = '/JournalScreen';
  DateTime selectedDateTime = DateTime.now();
  int currentIndex = 0;
  bool defaultImage = true;

  bool isDoneLoader = false;

  final scrollController = AutoScrollController();
  num waterML = 0;

  GetDashboardModel? getDashboardModel;
  List<MealData>? mealTrackerDataList = [];
  List<TrackerData>? tmpMealTrackerDataList = [];
  List<MealData> breakFastList = [];
  List<MealData>? lunchDataList = [];
  List<MealData>? dinnerDataList = [];
  List<MealData>? snackDataList = [];
  List<CustomMealDetails> customMealData = [];
  List<CustomMealDetails> breakFastCustomList = [];
  List<CustomMealDetails>? lunchDataCustomList = [];
  List<CustomMealDetails>? dinnerDataCustomList = [];
  List<CustomMealDetails>? snackDataCustomList = [];
  List<DailyRecapData> recapDataList = [];
  List<MealDataByDate> logData = [];
  List<Map<String, dynamic>> isBreakFastEatenOption = [];
  List<Map<String, dynamic>> isDinnerEatenOption = [];
  List<Map<String, dynamic>> isLunchEatenOption = [];
  List<Map<String, dynamic>> isSnackEatenOption = [];
  WaterData? waterData;
  ExerciseData? exerciseData;
  GetUserJournalBloc bloc = GetUserJournalBloc();
  AddNewMealBloc addNewMealBloc = AddNewMealBloc();
  bool isAllDataLoading = false;
  bool isRemoveWater = false;
  UserAddress? getUserAddress;

  RestaurantBloc restaurantBloc = RestaurantBloc();
  AccountBloc accountBloc = AccountBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToToday();
      addNewMealBloc.add(GetCustomListEvent(dateTime: DateTime.now()));
      bloc.add(JournalGetDashboardDataEvent(dateTime: DateTime.now()));
      bloc.add(GetUserJournalData(date: dateTimeNow()));
      if (dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString()) ==
          dateTimeNow()) {
        PreferenceUtils.setInt(userMealPlanCountState, 0);
        bloc.add(GenMealData(date: dateTimeNow()));
      } else {
        bloc.add(MealTrackerData(
            date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
      }

      bloc.add(GetWaterDetails(
          date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
      bloc.add(GetExerciseDetails(
          date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
      bloc.add(DailyRecapEvent());
      // restaurantBloc.add(GetShoppingListEvent());
      // restaurantBloc.add(GetDeliveryStatusEvent());
      restaurantBloc.add(GetUserAddressEvent());
      accountBloc.add(GetUnitInfoEvent());
    });
  }

  void scrollToToday() {
    final todayIndex = DateTime.now().day - 1; // Adjust for zero-based index
    scrollController.scrollToIndex(
      todayIndex,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  DateTime get now => DateTime.now();
  int? waterValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AccountBloc, AccountState>(
          bloc: accountBloc,
          listener: (context, state) {
            if (state is GetUnitInfoSuccessState) {
              waterValue = state.unitData?.waterType == 'Floz' ? 1 : 2;
            }
          },
          builder: (context, state) {
            return SizedBox(
              height: size.height.h,
              width: size.width.w,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountScreen(),
                              ));
                          accountBloc.add(GetUnitInfoEvent());
                        },
                        child: SvgPicture.asset(
                          AssetsUtils.userSvg,
                          color: AppColors.darkGray,
                        ),
                      ),
                      Text(StringUtils.journal,
                          style:
                              FontUtils.h20(fontColor: AppColors.oxFF010101)),
                      InkWell(
                        onTap: () {
                          Get.toNamed('/OrderHistoryScreen');
                        },
                        child: SvgPicture.asset(AssetsUtils.notificationSvg),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 15, vertical: 5.h),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      onExpansionChanged: ((newState) {
                        debugPrint('onExpansionChanged--> $newState');
                        if (newState) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            scrollToToday();
                          });
                        }
                      }),
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        dateTimeDDMMMYYYY(
                            dateTimeVal: selectedDateTime.toString()),
                        style: textTheme.headlineSmall
                            ?.copyWith(color: AppColors.middleGray),
                      ),
                      children: [
                        EasyInfiniteDateTimeLine(
                          firstDate: DateTime(2015),
                          focusDate: selectedDateTime,
                          lastDate: DateTime(DateTime.now().year + 10, 12, 31),
                          showTimelineHeader: false,
                          timeLineProps:
                              const EasyTimeLineProps(separatorPadding: 8.0),
                          dayProps: EasyDayProps(height: 80.h, width: 50.w),

                          /// *
                          onDateChange: (selectedDate) {
                            selectedDateTime = selectedDate;
                            mealTrackerDataList = [];
                            tmpMealTrackerDataList = [];
                            breakFastList = [];
                            lunchDataList = [];
                            dinnerDataList = [];
                            snackDataList = [];
                            recapDataList = [];
                            logData = [];
                            bloc.add(
                              GetUserJournalData(
                                date: dateTimeYYYYMMDD(
                                    dateTimeVal: selectedDateTime.toString()),
                              ),
                            );
                            bloc.add(JournalGetDashboardDataEvent(
                                dateTime: selectedDateTime));
                            addNewMealBloc.add(
                                GetCustomListEvent(dateTime: selectedDateTime));
                            bloc.add(GenMealData(
                                date: dateTimeYYYYMMDD(
                                    dateTimeVal: selectedDateTime.toString())));
                            bloc.add(MealTrackerData(
                                date: dateTimeYYYYMMDD(
                                    dateTimeVal: selectedDateTime.toString())));
                            bloc.add(GetWaterDetails(
                                date: dateTimeYYYYMMDD(
                                    dateTimeVal: selectedDateTime.toString())));
                            bloc.add(GetExerciseDetails(
                                date: dateTimeYYYYMMDD(
                                    dateTimeVal: selectedDateTime.toString())));
                            bloc.add(DailyRecapEvent());
                            setState(() {});
                          },
                          itemBuilder: (context, fullDate, isSelected, onTap) {
                            String dayName = DateFormat('EEE').format(fullDate);
                            int dayNumber = fullDate.day;
                            return GestureDetector(
                              onTap: () => onTap.call(),
                              child: Container(
                                height: 70.h,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.terracotta
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : AppColors.terracotta,
                                      width: 1.w),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(height: 5.h),
                                    Text(
                                      dayName.capitalizeFirst ?? "",
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.middleGray,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14),
                                    ),
                                    Container(
                                      height: 42.h,
                                      width: 42.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                      ),
                                      child: Center(
                                        child: Text(
                                          dayNumber.toString(),
                                          style: textTheme.bodyLarge?.copyWith(
                                              color: AppColors.middleGray),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 20.w),
                  Expanded(
                    child: BlocConsumer(
                      bloc: bloc,
                      listener: (context, state) async {
                        if (state is JournalLoadDashboardDataState) {
                          logData = state.data ?? [];
                          logData.map((e) {
                            customMealData.map((e1) {
                              if (e.mealId == e1.id || e.recipeId == e1.id) {
                                if (e.value == 'ATE') {
                                  e1.isEaten = true;
                                }
                              }
                            });
                          });

                          int difference =
                              DateTime(now.year, now.month, now.day)
                                  .difference(selectedDateTime)
                                  .inDays;
                          if (difference > 0) {
                            mealTrackerDataList = logData
                                .map(
                                  (e) => MealData(
                                    id: e.mealId,
                                    calories: e.calorie?.toDouble(),
                                    meal: e.mealType,
                                    recipe: Recipe(
                                      id: e.recipeId,
                                      name: e.mealName,
                                      nutrientsPerServing: NutrientsPerServing(
                                        calories: e.calorie?.toDouble(),
                                        carbs: e.carbs?.toDouble(),
                                        fat: e.fat?.toDouble(),
                                        protein: e.protein?.toDouble(),
                                      ),
                                    ),
                                    numOfServings: e.noOfServing?.toInt(),
                                  ),
                                )
                                .toList();
                            for (MealDataByDate e in logData) {
                              MealData data = MealData(
                                id: e.mealId,
                                calories: e.calorie?.toDouble(),
                                meal: e.mealType,
                                recipe: Recipe(
                                  id: e.recipeId,
                                  name: e.mealName,
                                  nutrientsPerServing: NutrientsPerServing(
                                    calories: e.calorie?.toDouble(),
                                    carbs: e.carbs?.toDouble(),
                                    fat: e.fat?.toDouble(),
                                    protein: e.protein?.toDouble(),
                                  ),
                                ),
                                numOfServings: e.noOfServing?.toInt(),
                              );

                              if (e.mealType?.toLowerCase() == 'breakfast') {
                                breakFastList.add(data);
                              } else if (e.mealType?.toLowerCase() == 'lunch') {
                                lunchDataList!.add(data);
                              } else if (e.mealType?.toLowerCase() ==
                                  'dinner') {
                                dinnerDataList!.add(data);
                              } else {
                                snackDataList!.add(data);
                              }
                            }

                            setState(() {});
                          }
                        }

                        if (state is AddItemSuccessState) {
                          // bloc.add(JournalGetDashboardDataEvent());
                          bloc.add(JournalGetDashboardDataEvent(
                              dateTime: selectedDateTime));
                          logData.add(MealDataByDate(mealId: state.mealID));
                          bloc.add(GetUserJournalData(
                              date: dateTimeYYYYMMDD(
                                  dateTimeVal: selectedDateTime.toString())));
                          if (dateTimeYYYYMMDD(
                                  dateTimeVal: selectedDateTime.toString()) ==
                              dateTimeNow()) {
                            PreferenceUtils.setInt(userMealPlanCountState, 0);
                            bloc.add(GenMealData(
                                date: dateTimeYYYYMMDD(
                                    dateTimeVal: selectedDateTime.toString())));
                          } else {
                            bloc.add(MealTrackerData(
                                date: dateTimeYYYYMMDD(
                                    dateTimeVal: selectedDateTime.toString())));
                          }
                          // addNewMealBloc.add(GetCustomListEvent());
                          setState(() {});
                        }

                        if (state is RemoveWaterLoadingData) {
                          isRemoveWater = true;
                        }
                        if (state is RemoveWaterErrorState) {
                          isRemoveWater = false;
                        }

                        if (state is RemoveWaterSuccessState) {
                          waterML = 0;
                          isRemoveWater = false;
                        }

                        if (state is GetUserJournalDataLoading) {
                          // return const AppCenterLoader();
                          isAllDataLoading = true;
                        }

                        if (state is LoadUserJournalData) {
                          getDashboardModel = state.model;
                        }

                        if (state is LoadGenMealData) {
                          isDoneLoader = false;

                          int diffenrence =
                              DateTime(now.year, now.month, now.day)
                                  .difference(selectedDateTime)
                                  .inDays;
                          if (diffenrence <= 0) {
                            mealTrackerDataList = state.genMealDataList;

                            breakFastList.clear();
                            lunchDataList!.clear();
                            dinnerDataList!.clear();
                            snackDataList!.clear();
                            mealTrackerDataList!.map((e) {
                              if (e.meal?.toLowerCase() == 'breakfast') {
                                breakFastList.add(e);
                              } else if (e.meal?.toLowerCase() == 'lunch') {
                                lunchDataList!.add(e);
                              } else if (e.meal?.toLowerCase() == 'dinner') {
                                dinnerDataList!.add(e);
                              } else {
                                snackDataList!.add(e);
                              }
                            }).toList();
                          }
                        }

                        if (state is LoadMealTrackData) {
                          tmpMealTrackerDataList = state.mealTrackDataList;
                        }

                        if (state is LoadWaterData) {
                          waterData = state.data;
                          waterML = waterData!.totalWaterIntake!;
                        }

                        if (state is AllExerciseLogSuccessState) {
                          exerciseData = state.data;
                        }

                        if (state is DailyRecapSuccessState) {
                          recapDataList = state.recapData ?? [];
                          isAllDataLoading = false;
                        }

                        if (state is LoadingDoneState) {
                          isDoneLoader = true;
                        }
                      },
                      builder: (context, state) {
                        return BlocConsumer(
                          bloc: addNewMealBloc,
                          listener: (context, state) {
                            if (state is GetCustomMealListSuccessState) {
                              customMealData = state.customMealDetails!;

                              int difference =
                                  DateTime(now.year, now.month, now.day)
                                      .difference(selectedDateTime)
                                      .inDays;
                              if (difference <= 0) {
                                breakFastCustomList.clear();
                                lunchDataCustomList?.clear();
                                dinnerDataCustomList?.clear();
                                snackDataCustomList?.clear();
                                customMealData.map((e) {
                                  if (e.type?.trim() == 'BreakFast' ||
                                      e.type?.trim().toLowerCase() ==
                                          'breakfast') {
                                    breakFastCustomList.add(e);
                                  } else if (e.type?.trim() == 'Lunch' ||
                                      e.type?.trim() == 'lunch') {
                                    lunchDataCustomList!.add(e);
                                  } else if (e.type?.trim() == 'Dinner' ||
                                      e.type?.trim() == 'dinner') {
                                    dinnerDataCustomList?.add(e);
                                  } else {
                                    snackDataCustomList?.add(e);
                                  }
                                }).toList();
                              }
                            }
                          },
                          builder: (context, state) {
                            double dailyIntake = (getDashboardModel
                                        ?.data?.totalIntakeFood
                                        ?.toDouble()
                                        .ceil() ??
                                    0) /
                                (getDashboardModel?.data?.totalCalorie
                                        ?.toDouble()
                                        .ceil() ??
                                    0);
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (getDashboardModel != null) ...{
                                    dashBoardCardView(
                                      width: double.infinity.w,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Daily intake',
                                                style: textTheme.headlineSmall
                                                    ?.copyWith(
                                                        color:
                                                            AppColors.darkGray),
                                              ),
                                              Text(
                                                '${(getDashboardModel?.data?.totalIntakeFood?.toDouble().floor() ?? 0).toString()} / ${(getDashboardModel?.data?.totalCalorie?.toDouble() ?? 0).floor().toString()} cal',
                                                style: textTheme.bodyLarge
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .middleGray),
                                              ),
                                            ],
                                          ).paddingSymmetric(horizontal: 8.w),
                                          commonProgressbar(
                                            width: 300.w,
                                            lineHeight: 8.0,
                                            percent: dailyIntake.isNaN ||
                                                    dailyIntake.isInfinite
                                                ? 0
                                                : dailyIntake,
                                            progressColor:
                                                AppColors.primaryBlue,
                                          ).paddingOnly(top: 5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              calciumDataView(
                                                title: 'Carbs',
                                                textTheme: textTheme,
                                                gramCount: (getDashboardModel
                                                            ?.data
                                                            ?.totalIntakeCarbs
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                                totalGram: (getDashboardModel
                                                            ?.data?.totalCarbs
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                                progressColor: AppColors.mint,
                                                percentage: (getDashboardModel
                                                                ?.data
                                                                ?.totalCarbs ??
                                                            0) ==
                                                        0
                                                    ? 0
                                                    : (getDashboardModel?.data
                                                                ?.totalIntakeCarbs
                                                                ?.toDouble()
                                                                .ceil() ??
                                                            0) /
                                                        (getDashboardModel
                                                                ?.data!
                                                                .totalCarbs
                                                                ?.toDouble()
                                                                .ceil() ??
                                                            0),
                                              ),
                                              calciumDataView(
                                                title: 'Protein',
                                                textTheme: textTheme,
                                                gramCount: (getDashboardModel
                                                            ?.data
                                                            ?.totalIntakeProtein
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                                totalGram: (getDashboardModel
                                                            ?.data?.totalProtein
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                                progressColor:
                                                    AppColors.skyBlue,
                                                percentage: (getDashboardModel
                                                                ?.data
                                                                ?.totalProtein ??
                                                            0) ==
                                                        0
                                                    ? 0
                                                    : (getDashboardModel?.data
                                                                ?.totalIntakeProtein
                                                                ?.toDouble()
                                                                .ceil() ??
                                                            0) /
                                                        (getDashboardModel?.data
                                                                ?.totalProtein
                                                                ?.toDouble()
                                                                .ceil() ??
                                                            0),
                                              ),
                                              calciumDataView(
                                                title: 'Fat',
                                                textTheme: textTheme,
                                                gramCount: (getDashboardModel
                                                            ?.data
                                                            ?.totalIntakeFat
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                                totalGram: (getDashboardModel
                                                            ?.data?.totalFat
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                                progressColor: AppColors.coral,
                                                percentage: (getDashboardModel
                                                                ?.data
                                                                ?.totalFat ??
                                                            0) ==
                                                        0
                                                    ? 0
                                                    : (getDashboardModel?.data
                                                                ?.totalIntakeFat
                                                                ?.toDouble()
                                                                .ceil() ??
                                                            0) /
                                                        (getDashboardModel
                                                                ?.data?.totalFat
                                                                ?.toDouble()
                                                                .ceil() ??
                                                            0),
                                              ),
                                            ],
                                          ).paddingOnly(top: 5.h),
                                        ],
                                      ).paddingAll(5),
                                    ),
                                  },
                                  if (mealTrackerDataList!.isNotEmpty) ...{
                                    Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Food',
                                            style: textTheme.headlineSmall
                                                ?.copyWith(
                                                    color:
                                                        AppColors.middleGray),
                                          ).paddingOnly(top: 5.h),
                                        ),
                                        if (breakFastList.isNotEmpty) ...[
                                          commonFoodItemView(
                                            textTheme: textTheme,
                                            image: AssetsUtils.breakFastIcon,
                                            title: StringUtils.breakfast,
                                            dataList: breakFastList,
                                            isEatenn: isBreakFastEatenOption,
                                            customDataList: breakFastCustomList,
                                            cal: breakFastList[0]
                                                    .calories
                                                    ?.toDouble()
                                                    .round()
                                                    .toString() ??
                                                "0.0",
                                            isLoaderWidgetShow:
                                                state is AddItemLoadingState &&
                                                    state.title ==
                                                        StringUtils.breakfast,
                                          ),
                                        ],
                                        if (lunchDataList?.isNotEmpty ?? false)
                                          commonFoodItemView(
                                            textTheme: textTheme,
                                            image: AssetsUtils.lunchIcon,
                                            title: StringUtils.lunch,
                                            dataList: lunchDataList,
                                            isEatenn: isLunchEatenOption,
                                            customDataList: lunchDataCustomList,
                                            cal: int.parse(lunchDataList?[0]
                                                            .calories!
                                                            .toString()
                                                            .split('.')[1] ??
                                                        "0") >=
                                                    50
                                                ? (lunchDataList![0]
                                                            .calories
                                                            ?.toDouble()
                                                            .ceil() ??
                                                        0)
                                                    .toString()
                                                : (lunchDataList![0]
                                                            .calories
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                            isLoaderWidgetShow:
                                                state is AddItemLoadingState,
                                          ),
                                        if (dinnerDataList?.isNotEmpty ?? false)
                                          commonFoodItemView(
                                            textTheme: textTheme,
                                            image: AssetsUtils.dinnerIcon,
                                            title: StringUtils.dinner,
                                            dataList: dinnerDataList,
                                            isEatenn: isDinnerEatenOption,
                                            customDataList:
                                                dinnerDataCustomList,
                                            cal: int.parse(dinnerDataList![0]
                                                            .calories
                                                            ?.toString()
                                                            .split('.')[1] ??
                                                        "0") >=
                                                    50
                                                ? (dinnerDataList![0]
                                                            .calories
                                                            ?.toDouble()
                                                            .ceil() ??
                                                        0)
                                                    .toString()
                                                : (dinnerDataList![0]
                                                            .calories
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                            isLoaderWidgetShow:
                                                state is AddItemLoadingState &&
                                                    state.title ==
                                                        StringUtils.dinner,
                                          ),
                                        if (snackDataList?.isNotEmpty ?? false)
                                          commonFoodItemView(
                                            textTheme: textTheme,
                                            image: AssetsUtils.snackIcon,
                                            title: StringUtils.snack,
                                            dataList: snackDataList,
                                            isEatenn: isSnackEatenOption,
                                            customDataList: snackDataCustomList,
                                            cal: int.parse(snackDataList![0]
                                                            .calories
                                                            ?.toString()
                                                            .split('.')[1] ??
                                                        "0") >=
                                                    50
                                                ? (snackDataList![0]
                                                            .calories
                                                            ?.toDouble()
                                                            .ceil() ??
                                                        0)
                                                    .toString()
                                                : (snackDataList![0]
                                                            .calories
                                                            ?.toDouble()
                                                            .floor() ??
                                                        0)
                                                    .toString(),
                                            isLoaderWidgetShow:
                                                state is AddItemLoadingState &&
                                                    state.title ==
                                                        StringUtils.snack,
                                          ),
                                      ],
                                    ),
                                  },
                                  getDashboardModel == null
                                      ? const SizedBox()
                                      : Text(
                                          'Routine',
                                          style: textTheme.headlineSmall
                                              ?.copyWith(
                                                  color: AppColors.middleGray),
                                        ).paddingOnly(top: 15.h),
                                  getDashboardModel == null
                                      ? const SizedBox()
                                      : dashBoardCardView(
                                          width: double.infinity.w,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.toNamed('/AddWaterScreen',
                                                          arguments: AddWaterArguments(
                                                              dailyGoal: getDashboardModel!
                                                                  .data!
                                                                  .dailyWaterGoals
                                                                  .toString()))
                                                      ?.then((value) {
                                                    bloc.add(GetWaterDetails(
                                                        date: dateTimeYYYYMMDD(
                                                            dateTimeVal:
                                                                selectedDateTime
                                                                    .toString())));
                                                    // if (value != null) {
                                                    //   setState(() {
                                                    //     waterML = waterML + int.parse(value);
                                                    //   });
                                                    // }
                                                  });
                                                },
                                                child: ListTile(
                                                  leading: Image.asset(
                                                    AssetsUtils.water,
                                                    height: 25.h,
                                                    width: 25.w,
                                                    color: AppColors.darkGray,
                                                  ),
                                                  title: Text(
                                                    'Water',
                                                    style: textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .darkGray),
                                                  ),
                                                  trailing: Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 15.h,
                                                      color: const Color(
                                                          0xFF010101)),
                                                  horizontalTitleGap: 0.0,
                                                ),
                                              ),
                                              Divider(
                                                      color:
                                                          AppColors.middleGray,
                                                      height: 1.h)
                                                  .paddingSymmetric(
                                                      horizontal: 15.w),
                                              Builder(builder: (context) {
                                                String myDailyWaterGoals = "";
                                                if (waterValue == 1) {
                                                  var value =
                                                      (waterML * 0.033814);

                                                  myDailyWaterGoals =
                                                      value.toStringAsFixed(2);
                                                } else {
                                                  myDailyWaterGoals =
                                                      waterML.toString();
                                                }

                                                return InkWell(
                                                  onTap: () async {
                                                    await Get.toNamed(
                                                      '/EditWaterScreen',
                                                      arguments:
                                                          EditWaterArguments(
                                                        myDailyWaterGoals
                                                            .toString(),
                                                        getDashboardModel!.data!
                                                            .dailyWaterGoals
                                                            .toString(),
                                                      ),
                                                    )?.then((value) {
                                                      bloc.add(GetWaterDetails(
                                                          date: dateTimeYYYYMMDD(
                                                              dateTimeVal:
                                                                  selectedDateTime
                                                                      .toString())));
                                                    });
                                                  },
                                                  child: commonJournalFoodData(
                                                    title: 'Water',
                                                    subTitle:
                                                        "$myDailyWaterGoals ${(waterValue == 1 ? StringUtils.oz : StringUtils.ml)}",
                                                    child: isRemoveWater
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : Icon(
                                                            Icons.remove,
                                                            size: 18.h,
                                                            color: AppColors
                                                                .darkGray,
                                                          ),
                                                    textTheme: textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .darkGray,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    subTextTheme: textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .terracotta,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ).paddingOnly(
                                                      top: 7.h, bottom: 10.h),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                  exerciseData == null
                                      ? const SizedBox()
                                      : dashBoardCardView(
                                          width: double.infinity.w,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.toNamed(
                                                          '/AddExerciseScreen',
                                                          arguments:
                                                              AddExerciseArguments(
                                                                  dateTime:
                                                                      selectedDateTime))!
                                                      .then((value) {
                                                    bloc.add(GetExerciseDetails(
                                                        date: dateTimeYYYYMMDD(
                                                            dateTimeVal:
                                                                selectedDateTime
                                                                    .toString())));
                                                  });
                                                  //   .then((value) {
                                                  // setState(() {
                                                  //   exerciseCal = exerciseCal + int.parse(value);
                                                  // });
                                                  // });
                                                },
                                                child: ListTile(
                                                  leading: Image.asset(
                                                    AssetsUtils.dumBBell,
                                                    height: 25.h,
                                                    width: 25.w,
                                                    color: AppColors.darkGray,
                                                  ),
                                                  title: Text(
                                                    'Add exercise',
                                                    style: textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .darkGray),
                                                  ),
                                                  trailing: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 15.h,
                                                    color:
                                                        const Color(0xFF010101),
                                                  ),
                                                  horizontalTitleGap: 0.0,
                                                ),
                                              ),
                                              Divider(
                                                      color:
                                                          AppColors.middleGray,
                                                      height: 1.h)
                                                  .paddingSymmetric(
                                                      horizontal: 15.w),
                                              exerciseData!.exerciseLogList!
                                                          .isNotEmpty &&
                                                      exerciseData!
                                                          .exerciseLogList!
                                                          .isNotEmpty
                                                  ? InkWell(
                                                      onTap: () async {
                                                        await Get.toNamed(
                                                          "/AddEntryScreen",
                                                          arguments:
                                                              AddEntryArguments(
                                                            exerciseLogList:
                                                                exerciseData!
                                                                    .exerciseLogList![0],
                                                            isFromHistory: true,
                                                          ),
                                                        );
                                                        print(
                                                            "object:--------> ${exerciseData!.exerciseLogList?[0].exerciseId}");

                                                        bloc.add(
                                                          GetExerciseDetails(
                                                            date:
                                                                dateTimeYYYYMMDD(
                                                              dateTimeVal:
                                                                  selectedDateTime
                                                                      .toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child:
                                                          commonJournalFoodData(
                                                        // title: StringUtils.running,
                                                        title: exerciseData!
                                                            .exerciseLogList![0]
                                                            .exerciseName!,
                                                        subTitle: exerciseData!
                                                            .exerciseLogList![0]
                                                            .caloriesBurned!
                                                            .toString(),
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 13.h,
                                                          color: AppColors
                                                              .darkGray,
                                                        ),
                                                        textTheme: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .darkGray,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        subTextTheme: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .terracotta,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ).paddingOnly(
                                                              top: 10.h,
                                                              bottom: 10.h),
                                                    )
                                                  : const Offstage(),
                                              exerciseData!.exerciseLogList!
                                                          .isNotEmpty &&
                                                      exerciseData!
                                                              .exerciseLogList!
                                                              .length >
                                                          1
                                                  ? InkWell(
                                                      onTap: () async {
                                                        await Get.toNamed(
                                                          "/AddEntryScreen",
                                                          arguments:
                                                              AddEntryArguments(
                                                            exerciseLogList:
                                                                exerciseData!
                                                                    .exerciseLogList![1],
                                                            isFromHistory: true,
                                                          ),
                                                        );
                                                        bloc.add(
                                                          GetExerciseDetails(
                                                            date:
                                                                dateTimeYYYYMMDD(
                                                              dateTimeVal:
                                                                  selectedDateTime
                                                                      .toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child:
                                                          commonJournalFoodData(
                                                        title: exerciseData!
                                                            .exerciseLogList![1]
                                                            .exerciseName!,
                                                        subTitle: exerciseData!
                                                            .exerciseLogList![1]
                                                            .caloriesBurned!
                                                            .toString(),
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 13.h,
                                                          color: AppColors
                                                              .darkGray,
                                                        ),
                                                        textTheme: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .darkGray,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        subTextTheme: textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .terracotta,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ).paddingOnly(
                                                              bottom: 10.h),
                                                    )
                                                  : const Offstage(),
                                            ],
                                          ),
                                        ),
                                  recapDataList.isEmpty
                                      ? const SizedBox()
                                      : Text(
                                          'Daily Recap',
                                          style: textTheme.headlineSmall
                                              ?.copyWith(
                                                  color: AppColors.middleGray),
                                        ).paddingOnly(top: 7.h),
                                  recapDataList.isEmpty
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: 200.h,
                                          child: ListView.builder(
                                              itemCount: recapDataList.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10, bottom: 10.h),
                                                  child: commonSliderView(
                                                    image: recapDataList[index]
                                                                .isSelected ==
                                                            -1
                                                        ? AssetsUtils
                                                            .dailyRecap1
                                                        : recapDataList[index]
                                                                    .isSelected ==
                                                                0
                                                            ? AssetsUtils
                                                                .noteRecap1
                                                            : AssetsUtils
                                                                .noteRecap2,
                                                    title: recapDataList[index]
                                                            .label ??
                                                        '',
                                                    textTheme: textTheme,
                                                    selectedIndex:
                                                        recapDataList[index]
                                                            .isSelected,
                                                    onYesTap: () {
                                                      setState(() {});
                                                      recapDataList[index]
                                                          .isSelected = 0;
                                                      bloc.add(
                                                        DailyRecapAnsEvent(
                                                          queID: recapDataList[
                                                                  index]
                                                              .id,
                                                          recapAns: true,
                                                        ),
                                                      );
                                                    },
                                                    onNoTap: () {
                                                      setState(() {});
                                                      recapDataList[index]
                                                          .isSelected = 1;
                                                      bloc.add(
                                                          DailyRecapAnsEvent(
                                                              queID:
                                                                  recapDataList[
                                                                          index]
                                                                      .id,
                                                              recapAns: false));
                                                    },
                                                  ),
                                                );
                                              })),

                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Container(
                                  //       height: 8.h,
                                  //       width: 8.w,
                                  //       margin: EdgeInsets.only(right: 5.w),
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: currentIndex == 0 ? AppColors.primaryBlue : AppColors.disable,
                                  //       ),
                                  //     ),
                                  //     Container(
                                  //       height: 8.h,
                                  //       width: 8.w,
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: currentIndex == 1 ? AppColors.primaryBlue : AppColors.disable,
                                  //       ),
                                  //     )
                                  //   ],
                                  // ).paddingOnly(bottom: 20.w, top: 15.h),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ).paddingSymmetric(horizontal: 20.w),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget commonYesNoButton({
    void Function()? onTap,
    BoxBorder? border,
    Color? bgColor,
    Color? textColor,
    MainAxisAlignment? mainAxisAlignment,
    Widget? showImage,
    TextTheme? textTheme,
    String title = '',
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 125.w,
          height: 35.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: bgColor,
              border: border),
          child: Center(
            child: Row(
              mainAxisAlignment: mainAxisAlignment!,
              children: [
                showImage!,
                Text(
                  title,
                  style: textTheme?.headlineSmall?.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget commonSliderView({
    String image = '',
    String title = '',
    TextTheme? textTheme,
    int? selectedIndex,
    VoidCallback? onYesTap,
    VoidCallback? onNoTap,
  }) {
    return dashBoardCardView(
        width: 165.w,
        height: 200.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              height: 35.h,
              width: 35.w,
            ),
            Text(title,
                textAlign: TextAlign.center,
                style:
                    textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray)),
            commonYesNoButton(
                textTheme: textTheme,
                bgColor: AppColors.mint,
                textColor: AppColors.greenPressed,
                title: StringUtils.yes,
                border: selectedIndex == 0
                    ? Border.all(color: AppColors.greenPressed, width: 2.w)
                    : null,
                mainAxisAlignment: selectedIndex == 0
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                onTap: onYesTap,
                // onTap: () {
                //   setState(() {
                //     yesTap = true;
                //     noTap = false;
                //     defaultImage = false;
                //   });
                // },
                showImage: selectedIndex == 0
                    ? Image.asset(AssetsUtils.greenRight,
                        height: 20.h, width: 20.w)
                    : const SizedBox()),
            commonYesNoButton(
                textTheme: textTheme,
                title: StringUtils.no,
                textColor: AppColors.terracottaPressed,
                bgColor: AppColors.coral,
                border: selectedIndex == 1
                    ? Border.all(color: AppColors.terracottaPressed, width: 2.w)
                    : null,
                mainAxisAlignment: selectedIndex == 1
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                onTap: onNoTap,
                // onTap: () {
                //   setState(() {
                //     yesTap = false;
                //     noTap = true;
                //     defaultImage = false;
                //   });
                // },
                showImage: selectedIndex == 1
                    ? Image.asset(AssetsUtils.terracottaRight,
                        height: 20.h, width: 20.w)
                    : const SizedBox()),
          ],
        ));
  }

  Widget commonProgressbar(
      {Color? progressColor,
      double? width,
      double? lineHeight,
      double? percent}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: const Radius.circular(10),
      animation: true,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: (percent ?? 0.0) >= 1 ? 1.0 : percent ?? 0.0,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }

  Widget calciumDataView({
    String? title,
    String? gramCount,
    TextTheme? textTheme,
    String? totalGram,
    Color? progressColor,
    required double percentage,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title.toString(),
            style: textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray),
          ),
          commonProgressbar(
            progressColor: progressColor,
            width: 80.w,
            percent: percentage >= 1.0 ? 1.0 : percentage,
            lineHeight: 8.0,
          ),
          Text(
            '$gramCount / $totalGram g',
            style: textTheme?.bodyMedium?.copyWith(color: AppColors.darkGray),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget commonJournalFoodData({
    String title = '',
    String subTitle = '',
    TextStyle? textTheme,
    TextStyle? subTextTheme,
    Widget? child,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250.w,
              child: Text(
                title,
                style: textTheme,
              ),
            ),
            Text(
              subTitle,
              style: subTextTheme,
            ),
          ],
        ),
        child!,
      ],
    ).paddingSymmetric(horizontal: 15.w);
  }

  Widget commonBorderView({Widget? child}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      width: double.infinity.w,
      margin: EdgeInsets.only(top: 5.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.disable)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child!,
        ],
      ),
    );
  }

  Widget commonFoodItemView({
    String image = '',
    String title = '',
    String cal = '',
    TextTheme? textTheme,
    List<MealData>? dataList,
    List<Map<String, dynamic>>? isEatenn,
    List<CustomMealDetails>? customDataList,
    bool? isLoaderWidgetShow,
  }) {
    // bool isDone = false;
    // for (var element in tmpMealTrackerDataList!) {
    //   if (dataList![0].meal == element.meal!.meal) {
    //     isDone = true; element.value == "ATE";
    //   }
    // }
    bool isEaten = false;
    bool isSkipped = false;
    logData.map((e) {
      if (e.mealId == dataList![0].id) {
        if (e.value.toString() == 'ATE') {
          isEaten = true;
        }
        isSkipped = e.value.toString() == 'SKIPPED';
      }
    }).toList();
    logData.map((e) {
      customDataList?.forEach((element) {
        if (e.mealName == element.name || e.mealId == element.id) {
          if (e.value.toString() == 'ATE') {
            element.isEaten = true;
          }
          element.isSkipped = e.value.toString() == 'SKIPPED';
        }
      });
    }).toList();

    return BlocConsumer(
      bloc: restaurantBloc,
      builder: (context, state) {
        if (state is GetUserAddressSuccessState) {
          for (var i = 0; i < state.userAddress.length; i++) {
            if (state.userAddress[i].isPrimary == true) {
              getUserAddress = state.userAddress[i];
              break;
            }
          }
        }

        return Column(
          children: [
            InkWell(
              onTap: () async {
                log("MEAL ID");

                await Get.toNamed(
                  "/JournalMealScreen",
                  arguments: JournalMealScreenArguments(
                      getUserAddress: getUserAddress,
                      breakFastList: dataList,
                      mealType: title,
                      dateTime: selectedDateTime),
                );
                setState(() {
                  addNewMealBloc
                      .add(GetCustomListEvent(dateTime: selectedDateTime));
                });
                bloc.add(
                    JournalGetDashboardDataEvent(dateTime: selectedDateTime));
                bloc.add(GenMealData(date: dateTimeNow()));
                bloc.add(GetUserJournalData(
                    date: dateTimeYYYYMMDD(
                        dateTimeVal: selectedDateTime.toString())));
              },
              child: Container(
                child: dashBoardCardView(
                  width: double.infinity.w,
                  child: ListTile(
                    leading: Image.asset(
                      image,
                      height: 25.h,
                      width: 25.w,
                      color: AppColors.darkGray,
                    ),
                    title: Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style: textTheme?.headlineSmall
                              ?.copyWith(color: AppColors.darkGray),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15.h,
                      color: const Color(0xFF010101),
                    ),
                    horizontalTitleGap: 0.0,
                  ),
                ),
              ),
            ),
            commonBorderView(
              child: InkWell(
                onTap: () async {
                  log("REDIRECT");
                  log("${dataList[0].recipe!.name}", name: "RECIPE NAME");

                  await Get.toNamed(
                    '/MealDetailsScreen',
                    arguments: MealPlanArguments(
                      currentSelectedData: selectedDateTime,
                      isJournalMeal: true,
                      mealData: MealData(
                        id: dataList[0].id,
                        recipe: Recipe(
                          id: dataList[0].recipe?.id,
                          name: dataList[0].recipe!.name,
                        ),
                      ),
                    ),
                  );
                  bloc.add(
                      JournalGetDashboardDataEvent(dateTime: selectedDateTime));
                  bloc.add(GetUserJournalData(
                      date: dateTimeYYYYMMDD(
                          dateTimeVal: selectedDateTime.toString())));
                  //Get.toNamed("/ForthJournalBGView");
                },
                child: commonJournalFoodData(
                  title: dataList![0].recipe?.name ?? "",
                  subTitle:
                      '${dataList[0].recipe?.nutrientsPerServing?.calories?.toStringAsFixed(2) ?? cal} ${StringUtils.calCount}',
                  child: isSkipped
                      ? SvgPicture.asset(AssetsUtils.icSkippedIcon, height: 25)
                      : InkWell(
                          onTap: () {
                            if (!isEaten) {
                              bloc.add(
                                AddEatenMealData(
                                  value: 1,
                                  mealName: dataList[0].recipe!.name,
                                  recipeId: dataList[0].recipe!.id,
                                  mealType: dataList[0].meal,
                                  noOfServing: dataList[0].numOfServings,
                                  userId:
                                      PreferenceUtils.getString(prefUserData),
                                  calorie: dataList[0]
                                      .recipe!
                                      .nutrientsPerServing!
                                      .calories,
                                  carbs: dataList[0]
                                      .recipe!
                                      .nutrientsPerServing!
                                      .carbs,
                                  fat: dataList[0]
                                      .recipe!
                                      .nutrientsPerServing!
                                      .fat,
                                  protein: dataList[0]
                                      .recipe!
                                      .nutrientsPerServing!
                                      .protein,
                                  title: dataList[0].recipe!.name,
                                  mealId: dataList[0].id,
                                  date: dateTimeYYYYMMDD(
                                      dateTimeVal: selectedDateTime.toString()),
                                ),
                              );
                            }
                          },
                          child: bloc.state is AddItemLoadingState &&
                                  (bloc.state as AddItemLoadingState)
                                          .itemId
                                          .toString() ==
                                      dataList[0].id.toString()
                              ? SizedBox(
                                  height: 25.h,
                                  width: 25.w,
                                  child: const AppCenterLoader())
                              : Container(
                                  height: 25.h,
                                  width: 25.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.skyBlue,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isEaten ? Icons.check : Icons.add,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                        ),
                  textTheme: textTheme?.bodySmall?.copyWith(
                      color: AppColors.darkGray, fontWeight: FontWeight.w400),
                  subTextTheme: textTheme?.bodySmall?.copyWith(
                      color: AppColors.terracotta, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            ...List.generate(
              customDataList?.length ?? 0,
              (index) => commonBorderView(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      '/GroceryItemDetails',
                      arguments: GroceryItemDetailsArguments(
                        productName: customDataList[index].name ?? '',
                        //isFromJournalScreen: true,
                        isFromCustomMealScreen: true,
                        isShowData: true,
                        imageUrl: customDataList[index].imageUrl,
                        protein: customDataList[index].protein ?? 0.0,
                        fat: customDataList[index].fat ?? 0.0,
                        carbs: customDataList[index].carbs ?? 0.0,
                        cal: customDataList[index].calorie ?? 0.0,
                        quantity: customDataList[index].quantity ?? 0,
                      ),
                    );

                    // Get.toNamed("/ForthJournalBGView");
                  },
                  child: commonJournalFoodData(
                    title: customDataList![index].name!,
                    subTitle:
                        '${customDataList[index].calorie?.toStringAsFixed(2)} ${StringUtils.calCount}',
                    child: customDataList[index].isSkipped
                        ? SvgPicture.asset(AssetsUtils.icSkippedIcon,
                            height: 25)
                        : InkWell(
                            onTap: () async {
                              if (!customDataList[index].isEaten) {
                                bloc.add(
                                  AddEatenMealData(
                                    value: 1,
                                    mealName: customDataList[index].name,
                                    mealType: customDataList[index].type,
                                    noOfServing: customDataList[index].quantity,
                                    userId:
                                        PreferenceUtils.getString(prefUserData),
                                    calorie: customDataList[index].calorie,
                                    carbs: customDataList[index].carbs,
                                    fat: customDataList[index].fat,
                                    protein: customDataList[index].protein,
                                    title: customDataList[index].name,
                                    mealId: customDataList[index].id,
                                    date: dateTimeYYYYMMDD(
                                      dateTimeVal: selectedDateTime.toString(),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: bloc.state is AddItemLoadingState &&
                                    (bloc.state as AddItemLoadingState)
                                            .itemId
                                            .toString() ==
                                        customDataList[index].id.toString()
                                ? SizedBox(
                                    height: 25.h,
                                    width: 25.w,
                                    child: const AppCenterLoader())
                                : Container(
                                    height: 25.h,
                                    width: 25.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.skyBlue,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        customDataList[index].isEaten
                                            ? Icons.check
                                            : Icons.add,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                          ),
                    textTheme: textTheme?.bodySmall?.copyWith(
                        color: AppColors.darkGray, fontWeight: FontWeight.w400),
                    subTextTheme: textTheme?.bodySmall?.copyWith(
                        color: AppColors.terracotta,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            )
          ],
        ).paddingOnly(top: 20.h);
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
