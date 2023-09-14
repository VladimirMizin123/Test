import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/models/daily_recap_modal.dart';
import 'package:gymeats_mobile/models/get_meal_tracker_data_model.dart';
import 'package:gymeats_mobile/screen/dashboard/add_water_screen.dart';
import 'package:gymeats_mobile/screen/journal/exercise/add_exercise_screen.dart';
import 'package:gymeats_mobile/screen/journal/journal_meal_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../app/functions.dart';
import '../../app/sharedPrefrence.dart';
import '../../bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import '../../bloc/journal/get_journal_data/get_user_journal_event.dart';
import '../../bloc/journal/get_journal_data/get_user_journal_state.dart';
import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/exercise_log_details_model.dart';
import '../../models/fetch_meal_plan_model.dart';
import '../../models/get_dashboard_model.dart';
import '../../models/water_log_details_model.dart';
import '../../widget/app_center_loader.dart';
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
  bool yesTap = false;
  bool noTap = false;
  bool defaultImage = true;

  bool isDoneLoader = false;

  var listOfDates = [];
  List<Widget> carouselList = [];
  final scrollController = AutoScrollController();
  int waterML = 0;

  GetDashboardModel? model;
  List<MealData>? mealTrackerDataList = [];
  List<TrackerData>? tmpMealTrackerDataList = [];
  List<MealData> breakFastList = [];
  List<MealData>? lunchDataList = [];
  List<MealData>? dinnerDataList = [];
  List<MealData>? snackDataList = [];
  WaterData? waterData;
  ExerciseData? exerciseData;
  List<DailyRecapData>? recapData;

  GetUserJournalBloc bloc = GetUserJournalBloc();

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  @override
  void initState() {
    super.initState();
    bloc.add(GetUserJournalData(date: dateTimeNow()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToToday();
    });
  }

  void scrollToToday() {
    final todayIndex = DateTime.now().day - 1; // Adjust for zero-based index
    scrollController.scrollToIndex(
      todayIndex,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    var totalDays = daysInMonth(selectedDateTime);
    listOfDates = List<int>.generate(totalDays, (i) => i + 1);
    carouselList = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          commonSliderView(
              image: defaultImage
                  ? AssetsUtils.dailyRecap1
                  : yesTap
                      ? AssetsUtils.noteRecap1
                      : noTap
                          ? AssetsUtils.noteRecap2
                          : '',
              title: StringUtils.sliderText1,
              textTheme: textTheme),
          commonSliderView(
              image: defaultImage
                  ? AssetsUtils.dailyRecap2
                  : yesTap
                      ? AssetsUtils.waterRecap1
                      : noTap
                          ? AssetsUtils.waterRecap2
                          : '',
              title: StringUtils.sliderText2,
              textTheme: textTheme),
        ],
      ),
      commonSliderView(
          image: defaultImage
              ? AssetsUtils.dailyRecap3
              : yesTap
                  ? AssetsUtils.dumBellRecap1
                  : noTap
                      ? AssetsUtils.dumBellRecap2
                      : '',
          title: StringUtils.sliderText3,
          textTheme: textTheme),
    ];

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
                    style: textTheme.displayMedium?.copyWith(color: const Color(0xFF010101)),
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
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                    style: textTheme.headlineSmall?.copyWith(color: AppColors.middleGray),
                  ),
                  children: [
                    SizedBox(
                      height: 70.h,
                      child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: listOfDates.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final bool isSelected = index == selectedDateTime.day - 1;
                          final currentDate = DateTime(selectedDateTime.year, selectedDateTime.month, listOfDates[index]);
                          final dayAbbreviation = DateFormat.E().format(currentDate);
                          return AutoScrollTag(
                            key: ValueKey(index),
                            controller: scrollController,
                            index: index,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDateTime = DateTime(selectedDateTime.year, selectedDateTime.month, listOfDates[index]);
                                });
                                bloc.add(GetUserJournalData(date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
                              },
                              child: Container(
                                height: 70.h,
                                width: 50.w,
                                // padding: const EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(horizontal: 2.w),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.terracotta : Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: isSelected ? Colors.transparent : AppColors.terracotta, width: 1.w),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      dayAbbreviation,
                                      style: TextStyle(color: isSelected ? Colors.white : AppColors.middleGray, fontWeight: FontWeight.w300, fontSize: 14),
                                    ),
                                    Container(
                                      height: 42.h,
                                      width: 42.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected ? Colors.white : Colors.transparent,
                                      ),
                                      child: Center(
                                        child: Text(
                                          listOfDates[index].toString(),
                                          style: textTheme.bodyLarge?.copyWith(color: AppColors.middleGray),
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
                  builder: (context, state) {
                    if (state is LoadingData) {
                      return const AppCenterLoader();
                    }
                    if (state is LoadGenMealData) {
                      return const AppCenterLoader();
                    }
                    if (state is LoadUserJournalData) {
                      return const AppCenterLoader();
                    }
                    if (state is LoadWaterData) {
                      return const AppCenterLoader();
                    }
                    if (state is AllExerciseSuccessState) {
                      return initView(textTheme);
                    }
                    if (state is LoadingDoneState) {
                      return initView(textTheme);
                    }
                    /* if (state is ErrorStateData) {
                      return Center(
                        child: Text(
                          state.errMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    }*/

                    return Container();
                  },
                  listener: (context, state) async {
                    if (state is LoadUserJournalData) {
                      model = state.model;
                      if (dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString()) == dateTimeNow()) {
                        PreferenceUtils.setInt(userMealPlanCountState, 0);
                        bloc.add(GenMealData());
                        // bloc.add(MealTrackerData(
                        //     date: dateTimeYYYYMMDD(
                        //         dateTimeVal: datetime.toString())));
                      } else {
                        bloc.add(MealTrackerData(date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
                      }
                    }
                    if (state is ErrorJournalState) {
                      if (dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString()) == dateTimeNow()) {
                        bloc.add(GenMealData());
                      } else {
                        bloc.add(MealTrackerData(date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
                      }
                    }

                    if (state is LoadGenMealData) {
                      isDoneLoader = false;
                      mealTrackerDataList = state.genMealDataList;
                      bloc.add(GetWaterDetails(date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
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
                      bloc.add(MealTrackerData(date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
                    }
                    if (state is LoadMealTrackData) {
                      print("Meal Id->${state.mealTrackDataList[0].value}");
                      tmpMealTrackerDataList = state.mealTrackDataList;
                    }
                    if (state is ErrorGenTrackState) {
                      bloc.add(GetWaterDetails(date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
                    }
                    if (state is LoadWaterData) {
                      waterData = state.data;
                      waterML = waterData!.totalWaterIntake!;
                      bloc.add(GetExerciseDetails(date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
                    }
                    if (state is ErrorWaterDataState) {
                      bloc.add(GetExerciseDetails(date: dateTimeYYYYMMDD(dateTimeVal: selectedDateTime.toString())));
                    }
                    if (state is AllExerciseSuccessState) {
                      exerciseData = state.data;
                    }

                    // if (state is DailyRecapSuccessState) {
                    //   recapData = state.recapData;
                    // }

                    
                    if (state is LoadingDoneState) {
                      isDoneLoader = true;
                    }
                  },
                ),
                // child: initView(textTheme),
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w),
        ),
      ),
    );
  }

  Widget initView(textTheme) => SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model != null) ...{
            dashBoardCardView(
              height: 130.h,
              width: double.infinity.w,
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daily intake',
                        style: textTheme.headlineSmall?.copyWith(color: AppColors.darkGray),
                      ),
                      Text(
                        '${int.parse(model!.data!.totalIntakeFood!.toString().split('.')[1]) >= 50 ? model!.data!.totalIntakeFood!.toDouble().ceil().toString() : model!.data!.totalIntakeFood!.toDouble().floor().toString()} / ${int.parse(model!.data!.totalCalorie!.toString().split('.')[1]) >= 50 ? model!.data!.totalCalorie!.toDouble().ceil().toString() : model!.data!.totalCalorie!.toDouble().floor().toString()} cal',
                        style: textTheme.bodyLarge?.copyWith(color: AppColors.middleGray),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 8.w),
                  commonProgressbar(
                    width: 300.w,
                    lineHeight: 8.0,
                    percent: model!.data!.totalIntakeFood!.toDouble().ceil() / model!.data!.totalCalorie!.toDouble().ceil(),
                    progressColor: AppColors.primaryBlue,
                  ).paddingOnly(top: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calciumDataView(
                        title: 'Carbs',
                        textTheme: textTheme,
                        gramCount: int.parse(model!.data!.totalIntakeCarbs!.toString().split('.')[1]) >= 50 ? model!.data!.totalIntakeCarbs!.toDouble().ceil().toString() : model!.data!.totalIntakeCarbs!.toDouble().floor().toString(),
                        totalGram: int.parse(model!.data!.totalCarbs!.toString().split('.')[1]) >= 50 ? model!.data!.totalCarbs!.toDouble().ceil().toString() : model!.data!.totalCarbs!.toDouble().floor().toString(),
                        progressColor: AppColors.mint,
                        percentage: model!.data!.totalIntakeCarbs!.toDouble().ceil() / model!.data!.totalCarbs!.toDouble().ceil(),
                      ),
                      calciumDataView(
                        title: 'Protein',
                        textTheme: textTheme,
                        gramCount: int.parse(model!.data!.totalIntakeProtein!.toString().split('.')[1]) >= 50 ? model!.data!.totalIntakeProtein!.toDouble().ceil().toString() : model!.data!.totalIntakeProtein!.toDouble().floor().toString(),
                        totalGram: int.parse(model!.data!.totalProtein!.toString().split('.')[1]) >= 50 ? model!.data!.totalProtein!.toDouble().ceil().toString() : model!.data!.totalProtein!.toDouble().floor().toString(),
                        progressColor: AppColors.skyBlue,
                        percentage: model!.data!.totalIntakeProtein!.toDouble().ceil() / model!.data!.totalProtein!.toDouble().ceil(),
                      ),
                      calciumDataView(
                        title: 'Fat',
                        textTheme: textTheme,
                        gramCount: int.parse(model!.data!.totalIntakeFat!.toString().split('.')[1]) >= 50 ? model!.data!.totalIntakeFat!.toDouble().ceil().toString() : model!.data!.totalIntakeFat!.toDouble().floor().toString(),
                        totalGram: int.parse(model!.data!.totalFat!.toString().split('.')[1]) >= 50 ? model!.data!.totalFat!.toDouble().ceil().toString() : model!.data!.totalFat!.toDouble().floor().toString(),
                        progressColor: AppColors.coral,
                        percentage: model!.data!.totalIntakeFat!.toDouble().ceil() / model!.data!.totalFat!.toDouble().ceil(),
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
                    style: textTheme.headlineSmall?.copyWith(color: AppColors.middleGray),
                  ).paddingOnly(top: 5.h),
                ),
                dashBoardCardView(
                  width: double.infinity.w,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed("/JournalMealScreen", arguments: JournalMealScreenArguments(breakFastList: breakFastList,mealType: breakFastList[0].meal!, dateTime: selectedDateTime));
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
                                style: textTheme.headlineSmall?.copyWith(color: AppColors.darkGray),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${int.parse(breakFastList[0].calories!.toString().split('.')[1]) >= 50 ? breakFastList[0].calories!.toDouble().ceil().toString() : breakFastList[0].calories!.toDouble().floor().toString()} cal',
                                style: textTheme.bodyLarge?.copyWith(color: AppColors.terracotta),
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
                      Divider(color: AppColors.middleGray, height: 1.h).paddingSymmetric(horizontal: 15.w),
                      ListView.builder(
                          itemCount: breakFastList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed('/MealDetailsScreen', arguments: MealPlanArguments(mealData: breakFastList[index], currentSelectedData: selectedDateTime));
                              },
                              child: commonJournalFoodData(
                                title: breakFastList[index].recipe!.name!,
                                subTitle: '${breakFastList[index].numOfServings} serving',
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13.h,
                                  color: AppColors.darkGray,
                                ),
                                textTheme: textTheme.bodySmall?.copyWith(color: AppColors.darkGray, fontWeight: FontWeight.w400),
                                subTextTheme: textTheme.bodySmall?.copyWith(color: AppColors.terracotta, fontWeight: FontWeight.w400),
                              ).paddingOnly(top: 10.h, bottom: 10.h),
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
                  cal: int.parse(lunchDataList![0].calories!.toString().split('.')[1]) >= 50 ? lunchDataList![0].calories!.toDouble().ceil().toString() : lunchDataList![0].calories!.toDouble().floor().toString(),
                ),
                commonFoodItemView(
                  textTheme: textTheme,
                  image: AssetsUtils.dinnerIcon,
                  title: StringUtils.dinner,
                  dataList: dinnerDataList,
                  cal: int.parse(dinnerDataList![0].calories!.toString().split('.')[1]) >= 50 ? dinnerDataList![0].calories!.toDouble().ceil().toString() : dinnerDataList![0].calories!.toDouble().floor().toString(),
                ),
                commonFoodItemView(
                  textTheme: textTheme,
                  image: AssetsUtils.snackIcon,
                  title: StringUtils.snack,
                  dataList: snackDataList,
                  cal: int.parse(snackDataList![0].calories!.toString().split('.')[1]) >= 50 ? snackDataList![0].calories!.toDouble().ceil().toString() : snackDataList![0].calories!.toDouble().floor().toString(),
                ),
              ],
            ),
          },
          Text(
            'Routine',
            style: textTheme.headlineSmall?.copyWith(color: AppColors.middleGray),
          ).paddingOnly(top: 15.h),
          dashBoardCardView(
            width: double.infinity.w,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    print(model!.data!.dailyWaterGoals);
                    Get.toNamed('/AddWaterScreen', arguments: AddWaterArguments(dailyGoal: model!.data!.dailyWaterGoals.toString()))?.then((value) {
                      setState(() {
                        waterML = waterML + int.parse(value);
                      });
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
                      style: textTheme.headlineSmall?.copyWith(color: AppColors.darkGray),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15.h, color: const Color(0xFF010101)),
                    horizontalTitleGap: 0.0,
                  ),
                ),
                Divider(color: AppColors.middleGray, height: 1.h).paddingSymmetric(horizontal: 15.w),
                InkWell(
                  onTap: () {
                    Get.toNamed('/AddWaterScreen', arguments: [model!.data!.dailyWaterGoals!, waterML.toString()])?.then((value) {
                      setState(() {
                        waterML = waterML + int.parse(value);
                      });
                    });
                  },
                  child: commonJournalFoodData(
                    title: 'Water',
                    subTitle: waterML.toString(),
                    child: Icon(
                      Icons.remove,
                      size: 18.h,
                      color: AppColors.darkGray,
                    ),
                    textTheme: textTheme.bodySmall?.copyWith(color: AppColors.darkGray, fontWeight: FontWeight.w400),
                    subTextTheme: textTheme.bodySmall?.copyWith(color: AppColors.terracotta, fontWeight: FontWeight.w400),
                  ).paddingOnly(top: 7.h, bottom: 10.h),
                ),
              ],
            ),
          ),
          dashBoardCardView(
            width: double.infinity.w,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed('/AddExerciseScreen', arguments: AddExerciseArguments(dateTime: selectedDateTime));
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
                      style: textTheme.headlineSmall?.copyWith(color: AppColors.darkGray),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15.h,
                      color: const Color(0xFF010101),
                    ),
                    horizontalTitleGap: 0.0,
                  ),
                ),
                Divider(color: AppColors.middleGray, height: 1.h).paddingSymmetric(horizontal: 15.w),
                exerciseData!.exerciseLogList!.isNotEmpty && exerciseData!.exerciseLogList!.isNotEmpty
                    ? commonJournalFoodData(
                        // title: StringUtils.running,
                        title: exerciseData!.exerciseLogList![0].exerciseName!,
                        subTitle: exerciseData!.exerciseLogList![0].caloriesBurned!.toString(),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 13.h,
                          color: AppColors.darkGray,
                        ),
                        textTheme: textTheme.bodySmall?.copyWith(color: AppColors.darkGray, fontWeight: FontWeight.w400),
                        subTextTheme: textTheme.bodySmall?.copyWith(color: AppColors.terracotta, fontWeight: FontWeight.w400),
                      ).paddingOnly(top: 10.h, bottom: 10.h)
                    : const Offstage(),
                exerciseData!.exerciseLogList!.isNotEmpty && exerciseData!.exerciseLogList!.length > 1
                    ? commonJournalFoodData(
                        title: exerciseData!.exerciseLogList![1].exerciseName!,
                        subTitle: exerciseData!.exerciseLogList![1].caloriesBurned!.toString(),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 13.h,
                          color: AppColors.darkGray,
                        ),
                        textTheme: textTheme.bodySmall?.copyWith(color: AppColors.darkGray, fontWeight: FontWeight.w400),
                        subTextTheme: textTheme.bodySmall?.copyWith(color: AppColors.terracotta, fontWeight: FontWeight.w400),
                      ).paddingOnly(bottom: 10.h)
                    : const Offstage(),
              ],
            ),
          ),
          Text(
            'Daily Recap',
            style: textTheme.headlineSmall?.copyWith(color: AppColors.middleGray),
          ).paddingOnly(top: 7.h),
          SizedBox(
            height: 200.h,
            child: CarouselSlider(
              items: carouselList,
              options: CarouselOptions(
                autoPlay: false,
                height: 200.h,
                initialPage: currentIndex,
                viewportFraction: 1.05,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                scrollDirection: Axis.horizontal,
              ),
            ).paddingOnly(top: 10.h),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 8.h,
                width: 8.w,
                margin: EdgeInsets.only(right: 5.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == 0 ? AppColors.primaryBlue : AppColors.disable,
                ),
              ),
              Container(
                height: 8.h,
                width: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == 1 ? AppColors.primaryBlue : AppColors.disable,
                ),
              )
            ],
          ).paddingOnly(bottom: 20.w, top: 15.h)
        ],
      ));

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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: bgColor, border: border),
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
            Text(title, textAlign: TextAlign.center, style: textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray)),
            commonYesNoButton(
                textTheme: textTheme,
                bgColor: AppColors.mint,
                textColor: AppColors.greenPressed,
                title: StringUtils.yes,
                border: yesTap ? Border.all(color: AppColors.greenPressed, width: 2.w) : null,
                mainAxisAlignment: yesTap ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                onTap: () {
                  setState(() {
                    yesTap = true;
                    noTap = false;
                    defaultImage = false;
                  });
                },
                showImage: yesTap ? Image.asset(AssetsUtils.greenRight, height: 20.h, width: 20.w) : const SizedBox()),
            commonYesNoButton(
                textTheme: textTheme,
                title: StringUtils.no,
                textColor: AppColors.terracottaPressed,
                bgColor: AppColors.coral,
                border: noTap ? Border.all(color: AppColors.terracottaPressed, width: 2.w) : null,
                mainAxisAlignment: noTap ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                onTap: () {
                  setState(() {
                    yesTap = false;
                    noTap = true;
                    defaultImage = false;
                  });
                },
                showImage: noTap ? Image.asset(AssetsUtils.terracottaRight, height: 20.h, width: 20.w) : const SizedBox()),
          ],
        ));
  }

  Widget commonProgressbar({Color? progressColor, double? width, double? lineHeight, double? percent}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: const Radius.circular(10),
      animation: true,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: percent ?? 0.0,
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
          percent: percentage,
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: AppColors.disable)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child!,
        ],
      ),
    );
  }

  Widget commonFoodItemView({String image = '', String title = '', String cal = '', TextTheme? textTheme, List<MealData>? dataList}) {
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
            Get.toNamed("/JournalMealScreen", arguments: JournalMealScreenArguments(breakFastList: dataList, mealType: title, dateTime: selectedDateTime));
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
                    style: textTheme?.headlineSmall?.copyWith(color: AppColors.darkGray),
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
                    bloc.add(AddEatenMealData(mealId: dataList[0].id!));
                  }
                },
                child: isDoneLoader
                    ? SizedBox(height: 25.h, width: 25.w, child: const AppCenterLoader())
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
              textTheme: textTheme?.bodySmall?.copyWith(color: AppColors.darkGray, fontWeight: FontWeight.w400),
              subTextTheme: textTheme?.bodySmall?.copyWith(color: AppColors.terracotta, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    ).paddingOnly(top: 20.h);
  }
}
