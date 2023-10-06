import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_state.dart';
import 'package:gymeats_mobile/models/daily_recap_modal.dart';
import 'package:gymeats_mobile/models/get_meal_tracker_data_model.dart';
import 'package:gymeats_mobile/screen/dashboard/add_water_screen.dart';
import 'package:gymeats_mobile/screen/journal/exercise/add_exercise_screen.dart';
import 'package:gymeats_mobile/screen/journal/journal_meal_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/arguments/meal_plan_arguments_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../app/functions.dart';
import '../../bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import '../../bloc/journal/get_journal_data/get_user_journal_event.dart';
import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/exercise_log_details_model.dart';
import '../../models/fetch_meal_plan_model.dart';
import '../../models/get_dashboard_model.dart';
import '../../models/water_log_details_model.dart';
import '../../widget/app_center_loader.dart';

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

  var listOfDates = [];
  final scrollController = AutoScrollController();
  int waterML = 0;

  GetDashboardModel? getDashboardModel;
  List<MealData>? mealTrackerDataList = [];
  List<TrackerData>? tmpMealTrackerDataList = [];
  List<MealData> breakFastList = [];
  List<MealData>? lunchDataList = [];
  List<MealData>? dinnerDataList = [];
  List<MealData>? snackDataList = [];
  List<DailyRecapData> recapDataList = [];
  WaterData? waterData;
  ExerciseData? exerciseData;
  GetUserJournalBloc bloc = GetUserJournalBloc();
  bool isAllDataLoading = false;
  bool isRemoveWater = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToToday();
      bloc.add(GetUserJournalData(date: dateTimeNow()));
      if (dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString()) ==
          dateTimeNow()) {
        PreferenceUtils.setInt(userMealPlanCountState, 0);
        bloc.add(GenMealData());
      } else {
        bloc.add(MealTrackerData(
            date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
      }
      bloc.add(GetWaterDetails(
          date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
      bloc.add(GetExerciseDetails(
          date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
      bloc.add(DailyRecapEvent());
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    var totalDays = daysInMonth(selectedDateTime);
    listOfDates = List<int>.generate(totalDays, (i) => i + 1);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height.h,
          width: size.width.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('ProfileScreen');
                    },
                    child: Image.asset(
                      AssetsUtils.user,
                      height: 25.h,
                      width: 25.w,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    StringUtils.journal,
                    style: textTheme.displayMedium
                        ?.copyWith(color: const Color(0xFF010101)),
                  ),
                  Image.asset(
                    AssetsUtils.notification,
                    height: 25.h,
                    width: 25.w,
                    color: AppColors.darkGray,
                  )
                ],
              ).paddingSymmetric(horizontal: 6, vertical: 5.h),
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
                    dateTimeDDMMMYYYY(dateTimeVal: selectedDateTime.toString()),
                    style: textTheme.headlineSmall
                        ?.copyWith(color: AppColors.middleGray),
                  ),
                  children: [
                    SizedBox(
                      height: 80.h,
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listOfDates.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final bool isSelected =
                              index == selectedDateTime.day - 1;
                          final currentDate = DateTime(selectedDateTime.year,
                              selectedDateTime.month, listOfDates[index]);
                          final dayAbbreviation =
                              DateFormat.E().format(currentDate);
                          return AutoScrollTag(
                            key: ValueKey(index),
                            controller: scrollController,
                            index: index,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDateTime = DateTime(
                                      selectedDateTime.year,
                                      selectedDateTime.month,
                                      listOfDates[index]);
                                });
                                bloc.add(GetUserJournalData(
                                    date: dateTimeYYYYMMDD(
                                        dateTimeVal:
                                            selectedDateTime.toString())));
                              },
                              child: Container(
                                height: 70.h,
                                width: 50.w,
                                // padding: const EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(horizontal: 2.w),
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
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      dayAbbreviation,
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
                                          listOfDates[index].toString(),
                                          style: textTheme.bodyLarge?.copyWith(
                                              color: AppColors.middleGray),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocConsumer(
                  bloc: bloc,
                  listener: (context, state) async {},
                  builder: (context, state) {
                    if (state is GetUserJournalDataLoading) {
                      // return const AppCenterLoader();
                      isAllDataLoading = true;
                    }

                    if (state is LoadUserJournalData) {
                      getDashboardModel = state.model;
                    }

                    if (state is LoadGenMealData) {
                      isDoneLoader = false;
                      mealTrackerDataList = state.genMealDataList;

                      breakFastList.clear();
                      mealTrackerDataList!.map((e) {
                        if (e.meal == 'breakfast') {
                          breakFastList.add(e);
                        } else if (e.meal == 'lunch') {
                          lunchDataList!.add(e);
                        } else if (e.meal == 'dinner') {
                          dinnerDataList!.add(e);
                        } else {
                          snackDataList!.add(e);
                        }
                      }).toList();
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

                    return isAllDataLoading
                        ? const AppCenterLoader()
                        : SingleChildScrollView(
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
                                              '${getDashboardModel!.data!.totalIntakeFood!.toDouble().floor().toString()} / ${getDashboardModel!.data!.totalCalorie!.toDouble().floor().toString()} cal',
                                              style: textTheme.bodyLarge
                                                  ?.copyWith(
                                                      color:
                                                          AppColors.middleGray),
                                            ),
                                          ],
                                        ).paddingSymmetric(horizontal: 8.w),
                                        commonProgressbar(
                                          width: 300.w,
                                          lineHeight: 8.0,
                                          percent: getDashboardModel!
                                                  .data!.totalIntakeFood!
                                                  .toDouble()
                                                  .ceil() /
                                              getDashboardModel!
                                                  .data!.totalCalorie!
                                                  .toDouble()
                                                  .ceil(),
                                          progressColor: AppColors.primaryBlue,
                                        ).paddingOnly(top: 5.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            calciumDataView(
                                              title: 'Carbs',
                                              textTheme: textTheme,
                                              gramCount: /*int.parse(
                                                          getDashboardModel!
                                                              .data!
                                                              .totalIntakeCarbs!
                                                              .toString()
                                                              .split('.')[1]) >=
                                                      50
                                                  ? getDashboardModel!
                                                      .data!.totalIntakeCarbs!
                                                      .toDouble()
                                                      .ceil()
                                                      .toString()
                                                  :*/
                                                  getDashboardModel!
                                                      .data!.totalIntakeCarbs!
                                                      .toDouble()
                                                      .floor()
                                                      .toString(),
                                              totalGram: /*int.parse(
                                                          getDashboardModel!
                                                              .data!.totalCarbs!
                                                              .toString()
                                                              .split('.')[1]) >=
                                                      50
                                                  ? getDashboardModel!
                                                      .data!.totalCarbs!
                                                      .toDouble()
                                                      .ceil()
                                                      .toString()
                                                  :*/
                                                  getDashboardModel!
                                                      .data!.totalCarbs!
                                                      .toDouble()
                                                      .floor()
                                                      .toString(),
                                              progressColor: AppColors.mint,
                                              percentage: getDashboardModel!
                                                      .data!.totalIntakeCarbs!
                                                      .toDouble()
                                                      .ceil() /
                                                  getDashboardModel!
                                                      .data!.totalCarbs!
                                                      .toDouble()
                                                      .ceil(),
                                            ),
                                            calciumDataView(
                                              title: 'Protein',
                                              textTheme: textTheme,
                                              gramCount: /*int.parse(
                                                          getDashboardModel!
                                                              .data!
                                                              .totalIntakeProtein!
                                                              .toString()
                                                              .split('.')[1]) >=
                                                      50
                                                  ? getDashboardModel!
                                                      .data!.totalIntakeProtein!
                                                      .toDouble()
                                                      .ceil()
                                                      .toString()
                                                  :*/
                                                  getDashboardModel!
                                                      .data!.totalIntakeProtein!
                                                      .toDouble()
                                                      .floor()
                                                      .toString(),
                                              totalGram: /*int.parse(
                                                          getDashboardModel!
                                                              .data!
                                                              .totalProtein!
                                                              .toString()
                                                              .split('.')[1]) >=
                                                      50
                                                  ? getDashboardModel!
                                                      .data!.totalProtein!
                                                      .toDouble()
                                                      .ceil()
                                                      .toString()
                                                  :*/
                                                  getDashboardModel!
                                                      .data!.totalProtein!
                                                      .toDouble()
                                                      .floor()
                                                      .toString(),
                                              progressColor: AppColors.skyBlue,
                                              percentage: getDashboardModel!
                                                      .data!.totalIntakeProtein!
                                                      .toDouble()
                                                      .ceil() /
                                                  getDashboardModel!
                                                      .data!.totalProtein!
                                                      .toDouble()
                                                      .ceil(),
                                            ),
                                            calciumDataView(
                                              title: 'Fat',
                                              textTheme: textTheme,
                                              gramCount: /*int.parse(
                                                          getDashboardModel!
                                                              .data!
                                                              .totalIntakeFat!
                                                              .toString()
                                                              .split('.')[1]) >=
                                                      50
                                                  ? getDashboardModel!
                                                      .data!.totalIntakeFat!
                                                      .toDouble()
                                                      .ceil()
                                                      .toString()
                                                  :*/
                                                  getDashboardModel!
                                                      .data!.totalIntakeFat!
                                                      .toDouble()
                                                      .floor()
                                                      .toString(),
                                              totalGram: /*int.parse(
                                                          getDashboardModel!
                                                              .data!.totalFat!
                                                              .toString()
                                                              .split('.')[1]) >=
                                                      50
                                                  ? getDashboardModel!
                                                      .data!.totalFat!
                                                      .toDouble()
                                                      .ceil()
                                                      .toString()
                                                  :*/
                                                  getDashboardModel!
                                                      .data!.totalFat!
                                                      .toDouble()
                                                      .floor()
                                                      .toString(),
                                              progressColor: AppColors.coral,
                                              percentage: getDashboardModel!
                                                      .data!.totalIntakeFat!
                                                      .toDouble()
                                                      .ceil() /
                                                  getDashboardModel!
                                                      .data!.totalFat!
                                                      .toDouble()
                                                      .ceil(),
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
                                                  color: AppColors.middleGray),
                                        ).paddingOnly(top: 5.h),
                                      ),
                                      dashBoardCardView(
                                        width: double.infinity.w,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                    "/JournalMealScreen",
                                                    arguments:
                                                        JournalMealScreenArguments(
                                                            breakFastList:
                                                                breakFastList,
                                                            mealType:
                                                                breakFastList[0]
                                                                    .meal!,
                                                            dateTime:
                                                                selectedDateTime));
                                              },
                                              child: ListTile(
                                                leading: Image.asset(
                                                  AssetsUtils.breakFastIcon,
                                                  height: 25.h,
                                                  width: 25.w,
                                                  color: AppColors.darkGray,
                                                ),
                                                title: Row(
                                                  children: [
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      breakFastList[0].meal!,
                                                      style: textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                              color: AppColors
                                                                  .darkGray),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      '${int.parse(breakFastList[0].calories!.toString().split('.')[1]) >= 50 ? breakFastList[0].calories!.toDouble().ceil().toString() : breakFastList[0].calories!.toDouble().floor().toString()} cal',
                                                      style: textTheme.bodyLarge
                                                          ?.copyWith(
                                                              color: AppColors
                                                                  .terracotta),
                                                    ),
                                                  ],
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
                                                    color: AppColors.middleGray,
                                                    height: 1.h)
                                                .paddingSymmetric(
                                                    horizontal: 15.w),
                                            ListView.builder(
                                                itemCount: breakFastList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  print(
                                                      '-----?>>>>${breakFastList.length}');
                                                  return InkWell(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          '/MealDetailsScreen',
                                                          arguments: MealPlanArguments(
                                                              mealData:
                                                                  breakFastList[
                                                                      index],
                                                              currentSelectedData:
                                                                  selectedDateTime));
                                                    },
                                                    child:
                                                        commonJournalFoodData(
                                                      title:
                                                          breakFastList[index]
                                                              .recipe!
                                                              .name!,
                                                      subTitle:
                                                          '${breakFastList[index].numOfServings} serving',
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 13.h,
                                                        color:
                                                            AppColors.darkGray,
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
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                      commonFoodItemView(
                                          textTheme: textTheme,
                                          image: AssetsUtils.lunchIcon,
                                          title: StringUtils.lunch,
                                          dataList: lunchDataList,
                                          cal: int.parse(lunchDataList![0]
                                                      .calories!
                                                      .toString()
                                                      .split('.')[1]) >=
                                                  50
                                              ? lunchDataList![0]
                                                  .calories!
                                                  .toDouble()
                                                  .ceil()
                                                  .toString()
                                              : lunchDataList![0]
                                                  .calories!
                                                  .toDouble()
                                                  .floor()
                                                  .toString(),
                                          isLoaderWidgetShow: state
                                                  is AddItemLoadingState &&
                                              state.title == StringUtils.lunch),
                                      commonFoodItemView(
                                          textTheme: textTheme,
                                          image: AssetsUtils.dinnerIcon,
                                          title: StringUtils.dinner,
                                          dataList: dinnerDataList,
                                          cal: int.parse(dinnerDataList![0]
                                                      .calories!
                                                      .toString()
                                                      .split('.')[1]) >=
                                                  50
                                              ? dinnerDataList![0]
                                                  .calories!
                                                  .toDouble()
                                                  .ceil()
                                                  .toString()
                                              : dinnerDataList![0]
                                                  .calories!
                                                  .toDouble()
                                                  .floor()
                                                  .toString(),
                                          isLoaderWidgetShow:
                                              state is AddItemLoadingState &&
                                                  state.title ==
                                                      StringUtils.dinner),
                                      commonFoodItemView(
                                          textTheme: textTheme,
                                          image: AssetsUtils.snackIcon,
                                          title: StringUtils.snack,
                                          dataList: snackDataList,
                                          cal: int.parse(snackDataList![0]
                                                      .calories!
                                                      .toString()
                                                      .split('.')[1]) >=
                                                  50
                                              ? snackDataList![0]
                                                  .calories!
                                                  .toDouble()
                                                  .ceil()
                                                  .toString()
                                              : snackDataList![0]
                                                  .calories!
                                                  .toDouble()
                                                  .floor()
                                                  .toString(),
                                          isLoaderWidgetShow: state
                                                  is AddItemLoadingState &&
                                              state.title == StringUtils.snack),
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
                                                            dailyGoal:
                                                                getDashboardModel!
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
                                                  style: textTheme.headlineSmall
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
                                                    color: AppColors.middleGray,
                                                    height: 1.h)
                                                .paddingSymmetric(
                                                    horizontal: 15.w),
                                            InkWell(
                                              onTap: () {
                                                // REMOVE WATER
                                                if (getDashboardModel!.data!
                                                        .totalIntakeWater ==
                                                    0) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Walter Goal Can\'t be 0');
                                                } else {
                                                  bloc.add(RemoveWaterEvent(
                                                      quantity:
                                                          waterML.toString()));
                                                }
                                              },
                                              child: commonJournalFoodData(
                                                title: 'Water',
                                                subTitle: waterML.toString(),
                                                child: isRemoveWater
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : Icon(
                                                        Icons.remove,
                                                        size: 18.h,
                                                        color:
                                                            AppColors.darkGray,
                                                      ),
                                                textTheme: textTheme.bodySmall
                                                    ?.copyWith(
                                                        color:
                                                            AppColors.darkGray,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                subTextTheme: textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .terracotta,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ).paddingOnly(
                                                  top: 7.h, bottom: 10.h),
                                            ),
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
                                                  style: textTheme.headlineSmall
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
                                                    color: AppColors.middleGray,
                                                    height: 1.h)
                                                .paddingSymmetric(
                                                    horizontal: 15.w),
                                            exerciseData!.exerciseLogList!
                                                        .isNotEmpty &&
                                                    exerciseData!
                                                        .exerciseLogList!
                                                        .isNotEmpty
                                                ? commonJournalFoodData(
                                                    // title: StringUtils.running,
                                                    title: exerciseData!
                                                        .exerciseLogList![0]
                                                        .exerciseName!,
                                                    subTitle: exerciseData!
                                                        .exerciseLogList![0]
                                                        .caloriesBurned!
                                                        .toString(),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 13.h,
                                                      color: AppColors.darkGray,
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
                                                    top: 10.h, bottom: 10.h)
                                                : const Offstage(),
                                            exerciseData!.exerciseLogList!
                                                        .isNotEmpty &&
                                                    exerciseData!
                                                            .exerciseLogList!
                                                            .length >
                                                        1
                                                ? commonJournalFoodData(
                                                    title: exerciseData!
                                                        .exerciseLogList![1]
                                                        .exerciseName!,
                                                    subTitle: exerciseData!
                                                        .exerciseLogList![1]
                                                        .caloriesBurned!
                                                        .toString(),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 13.h,
                                                      color: AppColors.darkGray,
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
                                                  ).paddingOnly(bottom: 10.h)
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
                                                      ? AssetsUtils.dailyRecap1
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
                                                        queID:
                                                            recapDataList[index]
                                                                .id,
                                                        recapAns: true,
                                                      ),
                                                    );
                                                  },
                                                  onNoTap: () {
                                                    setState(() {});
                                                    recapDataList[index]
                                                        .isSelected = 1;
                                                    bloc.add(DailyRecapAnsEvent(
                                                        queID:
                                                            recapDataList[index]
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
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w),
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
    return Column(
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
        )
      ],
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
            Text(
              title,
              style: textTheme,
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
      height: 48.h,
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
    bool? isLoaderWidgetShow,
  }) {
    bool isDone = false;
    for (var element in tmpMealTrackerDataList!) {
      if (dataList![0].meal == element.meal!.meal) {
        isDone = element.value == "ATE";
      }
    }
    // CONFLICT RESOLVED
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Get.toNamed("/JournalMealScreen", arguments: [dataList]);
            Get.toNamed("/JournalMealScreen",
                arguments: JournalMealScreenArguments(
                    breakFastList: dataList,
                    mealType: title,
                    dateTime: selectedDateTime));
          },
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
        commonBorderView(
          child: InkWell(
            onTap: () {
              Get.toNamed("/ForthJournalBGView");
            },
            child: commonJournalFoodData(
              title: dataList![0].recipe!.name!,
              subTitle: '$cal ${StringUtils.calCount}',
              child: InkWell(
                onTap: () {
                  if (!isDone) {
                    bloc.add(AddEatenMealData(
                      mealId: dataList[0].id!,
                      title: title,
                    ));
                  }
                },
                child: isLoaderWidgetShow ?? false
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
                            isDone ? Icons.check : Icons.add,
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
      ],
    ).paddingOnly(top: 20.h);
  }
}
