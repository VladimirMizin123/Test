import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/screen/dashboard/add_water_screen.dart';
import 'package:gymeats_mobile/screen/journal/exercise/add_exercise_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../bloc/dashboard/get_dashboard/get_dashboard_bloc.dart';
import '../../bloc/dashboard/get_dashboard/get_dashboard_event.dart';
import '../../bloc/dashboard/get_dashboard/get_dashboard_state.dart';
import '../../constant/string_utils.dart';
import '../../models/fetch_meal_plan_model.dart';
import '../../models/get_dashboard_model.dart';
import '../../widget/app_center_loader.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final routeName = '/DashBoardScreen';
  int currentIndex = 0;

  GetMealLogByDate mealDateModel = GetMealLogByDate();
  GetUserJournalBloc journalBloc = GetUserJournalBloc();

  // String recipeIdView = '';
  // List<MealDataByDate> idDataList = [];

  GetDashboardBloc bloc = GetDashboardBloc();
  GetDashboardModel model = GetDashboardModel();
  num outOfTotalCalories = 0.0;
  List<MealData> trackerDataList = [];

  num waterML = PreferenceUtils.getInt(prefWaterML);
  num exerciseCal = PreferenceUtils.getInt(prefExerciseCAl);

  List<Widget> carouselList = [];
  bool isDoneLoader = false;
  String mealId = '';
  List<MealDataByDate> logData = [];

  @override
  void initState() {
    super.initState();
    bloc.add(GenMealTrackerData());
    /* dateBloc.add(GetMealLogByDateData(
        date: DateFormat('yyyy-MM-dd').format(DateTime.now())));*/
    PreferenceUtils.setInt(userMealPlanCountState, 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    print('Token:- ${PreferenceUtils.getString(prefToken)}');

    carouselList = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          commonSliderView(
              icon: AssetsUtils.breakFastIcon,
              title: StringUtils.breakfast,
              textTheme: Theme.of(context).textTheme,
              context: context),
          commonSliderView(
              icon: AssetsUtils.lunchIcon,
              title: StringUtils.lunch,
              textTheme: Theme.of(context).textTheme,
              context: context),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          commonSliderView(
              icon: AssetsUtils.snackIcon,
              title: StringUtils.snack,
              textTheme: Theme.of(context).textTheme,
              context: context),
          commonSliderView(
              icon: AssetsUtils.dinnerIcon,
              title: StringUtils.dinner,
              textTheme: Theme.of(context).textTheme,
              context: context),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   primary: true,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leadingWidth: 35.w,
      //   automaticallyImplyLeading: false,
      //   leading: Image.asset(
      //     AppStrings.user,
      //     color: AppColors.darkGray,
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     AppStrings.dashBoard,
      //     style:
      //         textTheme.displayMedium?.copyWith(color: const Color(0xFF010101)),
      //   ),
      //   actions: [
      //     Image.asset(
      //       AppStrings.notification,
      //       height: 25.h,
      //       width: 25.w,
      //       color: AppColors.darkGray,
      //     )
      //   ],
      // ),
      body: SafeArea(
        child: SizedBox(
          height: size.height.h,
          width: size.width.w,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      //Get.toNamed('ProfileScreen');
                      Get.toNamed('/GoogleMapScreen', arguments: {
                        "string": 'isFromDashboard',
                        "userData": ''
                      });
                    },
                    child: Image.asset(
                      AssetsUtils.user,
                      height: 25.h,
                      width: 25.w,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    StringUtils.dashboard,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: const Color(0xFF010101)),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed('/OrderHistoryScreen');
                    },
                    child: Image.asset(
                      AssetsUtils.notification,
                      height: 25.h,
                      width: 25.w,
                      color: AppColors.darkGray,
                    ),
                  )
                ],
              ).paddingSymmetric(horizontal: 6, vertical: 5.h),
              Expanded(
                child: BlocConsumer(
                  bloc: bloc,
                  builder: (context, state) {
                    print('state : $state');
                    if (state is LoadDashboardData) {
                      print("logData:- $logData");
                      return initView();
                    }
                    if (state is LoadMealData) {
                      return const AppCenterLoader();
                    }
                    if (state is LoadingDoneState) {
                      print("logData:- $logData");
                      return initView();
                    }
                    if (state is LoadingData) {
                      return const AppCenterLoader();
                    }
                    if (state is ErrorStateData) {
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
                    }
                    return Container();
                  },
                  listener: (context, state) async {
                    if (state is LoadDashboardData) {
                      model = state.model;
                      outOfTotalCalories = model.data!.totalCalorie! -
                          model.data!.totalIntakeFood!;
                      logData = state.data ?? [];

                      await PreferenceUtils.setString(
                          totalCalorie, model.data!.totalCalorie.toString());
                      await PreferenceUtils.setString(
                          totalProtein, model.data!.totalProtein.toString());
                      await PreferenceUtils.setString(
                          totalFat, model.data!.totalFat.toString());
                      await PreferenceUtils.setString(
                          totalCarbs, model.data!.totalCarbs.toString());

                      print(
                          '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
                      print(model.data!.totalCalorie);
                      print(model.data!.totalProtein);
                      print(model.data!.totalFat);
                      print(model.data!.totalCarbs);

                      // print('logData : $logData');

                      // for (var element in logData) {
                      //   print('element : ${element.id}');
                      //   print('element : ${element.recipeId}');
                      // }
                    }
                    if (state is LoadMealData) {
                      isDoneLoader = false;
                      trackerDataList = state.trackerDataList;

                      bloc.add(GetDashboardData());
                    }
                    if (state is LoadingDoneState) {
                      isDoneLoader = true;
                      mealId = state.mealID;
                    }

                    if (state is ErrorStateData) {
                      //showToast(isSuccess: false, message: state.errMessage);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget initView() {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          dashBoardCardView(
            width: 315.w,
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140.w,
                      child: CircularPercentIndicator(
                        radius: 68.0,
                        animation: true,
                        animationDuration: 1200,
                        lineWidth: 8.0,
                        percent: model.data!.totalIntakeFood!
                                        .toDouble()
                                        .ceil() /
                                    model.data!.totalCalorie!
                                        .toDouble()
                                        .ceil() >
                                1
                            ? 1.0
                            : model.data!.totalIntakeFood!.toDouble().ceil() /
                                model.data!.totalCalorie!.toDouble().ceil(),
                        center: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${int.parse(outOfTotalCalories.toString().split('.')[1]) >= 50 ? outOfTotalCalories.toDouble().ceil().toString() : outOfTotalCalories.toDouble().floor().toString()}cal left\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: AppColors.darkGray),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Single tapped.
                                  },
                              ),
                              TextSpan(
                                text:
                                    'out of ${int.parse(model.data!.totalCalorie!.toString().split('.')[1]) >= 50 ? model.data!.totalCalorie!.toDouble().ceil().toString() : model.data!.totalCalorie!.toDouble().floor().toString()}cal',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.middleGray,
                                        fontWeight: FontWeight.w500),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Single tapped.
                                  },
                              ),
                            ],
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: AppColors.lightGrey,
                        progressColor: AppColors.primaryBlue,
                      ),
                    ).paddingOnly(left: 5.w),
                    SizedBox(
                      width: 140.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          calDataView(
                            imgIcon: AssetsUtils.breakFastIcon,
                            title: 'Eaten',
                            calCount: /*int.parse(model.data!.totalIntakeFood!
                                          .toString()
                                          .split('.')[1]) >=
                                      50
                                  ? model.data!.totalIntakeFood!
                                      .toDouble()
                                      .ceil()
                                      .toString()
                                  :*/
                                model.data!.totalIntakeFood!
                                    .toDouble()
                                    .floor()
                                    .toString(),
                            textTheme: Theme.of(context).textTheme,
                          ),
                          SizedBox(height: 15.h),
                          calDataView(
                            imgIcon: AssetsUtils.dumBBell,
                            title: 'Burned',
                            calCount: /*int.parse(model
                                          .data!.totalBurnedByExercise!
                                          .toString()
                                          .split('.')[1]) >=
                                      50
                                  ? model.data!.totalBurnedByExercise!
                                      .toDouble()
                                      .ceil()
                                      .toString()
                                  :*/
                                model.data!.totalBurnedByExercise!
                                    .toDouble()
                                    .floor()
                                    .toString(),
                            textTheme: Theme.of(context).textTheme,
                          ),
                        ],
                      ).paddingOnly(left: 30.w),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calciumDataView(
                      title: 'Carbs',
                      textTheme: Theme.of(context).textTheme,
                      gramCount: /*int.parse(model.data!.totalIntakeCarbs!
                                    .toString()
                                    .split('.')[1]) >=
                                50
                            ? model.data!.totalIntakeCarbs!
                                .toDouble()
                                .ceil()
                                .toString()
                            :*/
                          model.data!.totalIntakeCarbs!
                              .toDouble()
                              .floor()
                              .toString(),
                      totalGram: int.parse(model.data!.totalCarbs!
                                  .toString()
                                  .split('.')[1]) >=
                              50
                          ? model.data!.totalCarbs!.toDouble().ceil().toString()
                          : model.data!.totalCarbs!
                              .toDouble()
                              .floor()
                              .toString(),
                      progressColor: AppColors.mint,
                      percentage:
                          model.data!.totalIntakeCarbs!.toDouble().ceil() /
                              model.data!.totalCarbs!.toDouble().ceil(),
                    ),
                    calciumDataView(
                        percentage:
                            model.data!.totalIntakeProtein!.toDouble().ceil() /
                                model.data!.totalProtein!.toDouble().ceil(),
                        title: 'Protein',
                        textTheme: Theme.of(context).textTheme,
                        gramCount: /*int.parse(model.data!.totalIntakeProtein!
                                      .toString()
                                      .split('.')[1]) >=
                                  50
                              ? model.data!.totalIntakeProtein!
                                  .toDouble()
                                  .ceil()
                                  .toString()
                              :*/
                            model.data!.totalIntakeProtein!
                                .toDouble()
                                .floor()
                                .toString(),
                        totalGram: /*int.parse(model.data!.totalProtein!
                                      .toString()
                                      .split('.')[1]) >=
                                  50
                              ? model.data!.totalProtein!
                                  .toDouble()
                                  .ceil()
                                  .toString()
                              :*/
                            model.data!.totalProtein!
                                .toDouble()
                                .floor()
                                .toString(),
                        progressColor: AppColors.skyBlue),
                    calciumDataView(
                      percentage:
                          model.data!.totalIntakeFat!.toDouble().ceil() /
                              model.data!.totalFat!.toDouble().ceil(),
                      title: 'Fat',
                      textTheme: Theme.of(context).textTheme,
                      gramCount: /*int.parse(model.data!.totalIntakeFat!
                                    .toString()
                                    .split('.')[1]) >=
                                50
                            ? model.data!.totalIntakeFat!
                                .toDouble()
                                .ceil()
                                .toString()
                            :*/
                          model.data!.totalIntakeFat!
                              .toDouble()
                              .floor()
                              .toString(),
                      totalGram: /*int.parse(model.data!.totalFat!
                                    .toString()
                                    .split('.')[1]) >=
                                50
                            ? model.data!.totalFat!.toDouble().ceil().toString()
                            :*/
                          model.data!.totalFat!.toDouble().floor().toString(),
                      progressColor: AppColors.coral,
                    ),
                  ],
                )
              ],
            ).paddingAll(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    Get.toNamed('/AddWaterScreen',
                            arguments: AddWaterArguments(
                                dailyGoal:
                                    model.data!.dailyWaterGoals.toString()))!
                        .then((value) {
                      bloc.add(GetDashboardData());
                    });
                  },
                  child: dashBoardCardView(
                    margin: EdgeInsets.only(left: 20.w, top: 15.h, bottom: 5.h),
                    child: waterExerciseDataView(
                      percentage: model.data!.totalIntakeWater! /
                          model.data!.dailyWaterGoals!,
                      title: StringUtils.water,
                      textTheme: Theme.of(context).textTheme,
                      progressColor: AppColors.primaryBlue,
                      image: AssetsUtils.water,
                      type: StringUtils.rate,
                      countValue: model.data!.dailyWaterGoals!.toString(),
                      mlCalCount: model.data!.totalIntakeWater!.toString(),
                      tag: StringUtils.ml,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/AddExerciseScreen',
                            arguments:
                                AddExerciseArguments(dateTime: DateTime.now()))!
                        .then((value) {
                      bloc.add(GetDashboardData());
                    });
                    /*Get.toNamed('/SecondDashBoardView',
                              arguments: AddEntryArguments(
                                  exerciseLogList: ExerciseLogList(
                                      caloriesBurned: model
                                          .data!.dailyExerciseGoals!
                                          .toInt())))
                          ?.then((value) {
                        setState(() {
                          if (value == null) {
                            return;
                          }
                          exerciseCal = exerciseCal + int.parse(value);
                        });
                      });*/
                  },
                  child: dashBoardCardView(
                    margin:
                        EdgeInsets.only(right: 15.w, top: 15.h, bottom: 5.h),
                    child: waterExerciseDataView(
                      percentage: model.data!.totalBurnedByExercise! /
                          model.data!.dailyExerciseGoals!,
                      title: StringUtils.exercise,
                      textTheme: Theme.of(context).textTheme,
                      progressColor: AppColors.letsEatButton,
                      image: AssetsUtils.icExercise,
                      type: StringUtils.goal,
                      countValue: model.data!.dailyExerciseGoals!.toString(),
                      mlCalCount: model.data!.totalBurnedByExercise.toString(),
                      tag: StringUtils.cal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trackerDataList.length,
              itemBuilder: (BuildContext context, int index) {
                bool isEaten = false;

                logData.map((e) {
                  if (e.mealId == trackerDataList[index].id) {
                    if (e.value.toString() == 'ATE') {
                      isEaten = true;
                    }
                  }
                }).toList();

                return commonEatTypeData(
                  image: trackerDataList[index].recipe!.mainImage,
                  eatTitle: trackerDataList[index].meal,
                  eatSubTitle: trackerDataList[index].recipe!.name ?? '',
                  textTheme: Theme.of(context).textTheme,
                  trailing: InkWell(
                    onTap: isEaten
                        ? null
                        : () {
                            if (!trackerDataList[index].isDone) {
                              bloc.add(AddEatenMealData(
                                  value: 1,
                                  mealName: trackerDataList[index].recipe!.name,
                                  mealType: trackerDataList[index].meal,
                                  noOfServing:
                                      trackerDataList[index].numOfServings,
                                  recipeId: trackerDataList[index].recipe!.id,
                                  userId:
                                      PreferenceUtils.getString(prefUserData),
                                  calorie: trackerDataList[index]
                                      .recipe!
                                      .nutrientsPerServing!
                                      .calories,
                                  carbs: trackerDataList[index]
                                      .recipe!
                                      .nutrientsPerServing!
                                      .carbs,
                                  fat: trackerDataList[index]
                                      .recipe!
                                      .nutrientsPerServing!
                                      .fat,
                                  protein: trackerDataList[index]
                                      .recipe!
                                      .nutrientsPerServing!
                                      .protein,
                                  mealId:
                                      trackerDataList[index].id.toString()));
                            }
                          },
                    child: isDoneLoader && trackerDataList[index].id == mealId
                        ? SizedBox(
                            height: 25.h,
                            width: 25.w,
                            child: const AppCenterLoader())
                        : Container(
                            width: 25.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isEaten
                                  ? AppColors.primaryBlue
                                  : AppColors.skyBlue,
                            ),
                            child: Center(
                              child: Icon(
                                isEaten ? Icons.check : Icons.add,
                                color: isEaten
                                    ? Colors.white
                                    : AppColors.primaryBlue,
                              ),
                            ),
                          ),
                  ),
                  calText: int.parse(trackerDataList[index]
                              .calories
                              .toString()
                              .split('.')[1]) >=
                          50
                      ? trackerDataList[index]
                          .calories!
                          .toDouble()
                          .ceil()
                          .toString()
                      : trackerDataList[index]
                          .calories!
                          .toDouble()
                          .floor()
                          .toString(),
                );
              }),
          SizedBox(
            child: CarouselSlider(
              items: carouselList,
              options: CarouselOptions(
                autoPlay: false,
                height: 120.h,
                initialPage: currentIndex,
                viewportFraction: 1.05,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                scrollDirection: Axis.horizontal,
              ),
            ).paddingOnly(left: 20.w, top: 10.h),
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
                  color: currentIndex == 0
                      ? AppColors.primaryBlue
                      : AppColors.disable,
                ),
              ),
              Container(
                height: 8.h,
                width: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == 1
                      ? AppColors.primaryBlue
                      : AppColors.disable,
                ),
              )
            ],
          ).paddingOnly(bottom: 20.w, top: 0.h),
        ],
      ),
    );
  }

  Widget calDataView(
      {String? imgIcon,
      String? title,
      String? calCount,
      TextTheme? textTheme}) {
    return Row(
      children: [
        Container(
            height: 50.h,
            width: 3.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: AppColors.terracotta)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  imgIcon.toString(),
                  height: 25.h,
                  width: 25.w,
                ).paddingOnly(left: 12.w),
                Text(
                  title.toString(),
                  style: textTheme?.bodyLarge
                      ?.copyWith(color: AppColors.middleGray),
                ).paddingOnly(left: 8.w)
              ],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: calCount,
                    style: textTheme?.headlineSmall!
                        .copyWith(color: AppColors.terracotta),
                  ),
                  TextSpan(
                    text: ' cal',
                    style: textTheme?.bodyMedium!.copyWith(
                        color: AppColors.darkGray, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ).paddingOnly(left: 12.w)
          ],
        )
      ],
    );
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
        SizedBox(
          height: 5.h,
        ),
        commonProgressbar(
            progressColor: progressColor,
            width: 76.w,
            lineHeight: 10.0,
            percentage: percentage),
        SizedBox(
          height: 5.h,
        ),
        Text(
          '$gramCount / $totalGram g',
          style: textTheme?.bodyMedium?.copyWith(color: AppColors.darkGray),
        )
      ],
    );
  }

  Widget commonProgressbar({
    Color? progressColor,
    double? width,
    double? lineHeight,
    required double percentage,
  }) {
    return LinearPercentIndicator(
      width: width,
      barRadius: const Radius.circular(10),
      animation: true,
      padding: EdgeInsets.zero,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: percentage > 1 ? 1 : percentage,
      center: const Text(""),
      progressColor: progressColor,
    );
  }

  Widget waterExerciseDataView(
      {String? title,
      String? mlCalCount,
      Color? progressColor,
      String? tag,
      String? image,
      String? type,
      TextTheme? textTheme,
      required double percentage,
      String? countValue}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title.toString(),
                style: textTheme?.headlineSmall
                    ?.copyWith(color: AppColors.darkGray),
              ),
              addIcon(),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(
                image.toString(),
                height: 30.h,
                width: 30.w,
              ),
              Text(
                ' $mlCalCount $tag',
                style: textTheme?.headlineSmall
                    ?.copyWith(color: AppColors.darkGray),
              )
            ],
          ),
          Text(
            '${StringUtils.daily} $type: $countValue $tag',
            style: textTheme?.bodySmall?.copyWith(color: AppColors.darkGray),
          ),
          SizedBox(
            height: 12.h,
          ),
          commonProgressbar(
              progressColor: progressColor,
              lineHeight: 8.0,
              percentage: percentage),
        ],
      ),
    );
  }

  Widget commonEatTypeData({
    String? image,
    String? eatTitle,
    String? eatSubTitle,
    required String calText,
    TextTheme? textTheme,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 76, 99, 0.08),
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ]),
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h),
      child: Center(
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              height: 40,
              width: 40,
              imageUrl: image ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                color: AppColors.lightGrey,
              )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Row(
            children: [
              Text(
                eatTitle.toString(),
                style: textTheme?.headlineSmall
                    ?.copyWith(color: AppColors.darkGray),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Image.asset(
                    AssetsUtils.fire,
                    height: 18.h,
                    width: 18.w,
                  ),
                  Text(
                    calText,
                    style: textTheme?.bodySmall?.copyWith(
                        color: AppColors.darkGray, fontWeight: FontWeight.w400),
                  )
                ],
              )
            ],
          ),
          subtitle: Text(
            eatSubTitle.toString(),
            style: textTheme?.bodySmall?.copyWith(
                color: AppColors.darkGray, fontWeight: FontWeight.w400),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
