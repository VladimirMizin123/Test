import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/dashboard/add_water_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/order_history_hint_screen.dart';
import 'package:gymeats_mobile/screen/journal/exercise/add_exercise_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/convert_units_widget/water_convert.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_bloc.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_event.dart';
import 'package:gymeats_mobile/bloc/dashboard/get_dashboard/get_dashboard_state.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/get_dashboard_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';

final CartBloc cartBloc = CartBloc();

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key, this.isOrderComplete = false});
  final bool isOrderComplete;

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final routeName = '/DashBoardScreen';
  int currentIndex = 0;

  GetMealLogByDate mealDateModel = GetMealLogByDate();
  GetUserJournalBloc journalBloc = GetUserJournalBloc();

  AccountBloc accountBloc = AccountBloc();

  bool isLoader = false;

  int? weightValue;
  int? heightValue;
  int? energyValue;
  int? waterValue;
  String? unitId;

  GetDashboardBloc bloc = GetDashboardBloc();
  GetDashboardModel model = GetDashboardModel();
  num outOfTotalCalories = 0.0;
  List<MealData> trackerDataList = [];

  num waterML = PreferenceUtils.getNum(prefWaterML);
  num exerciseCal = PreferenceUtils.getNum(prefExerciseCAl);

  List<Widget> carouselList = [];
  bool isDoneLoader = false;
  String mealId = '';
  List<MealDataByDate> logData = [];
  bool hasPremium = false;
  MealPlanBloc mealPlanBloc = MealPlanBloc();
  bool cacheLoader = false;

  @override
  void initState() {
    String trackerList = PreferenceUtils.getString(trackerListStore);
    String dashboardList = PreferenceUtils.getString(dashboardModelPref);
    String mealList = PreferenceUtils.getString(mealDataByDatePref);

    if (![trackerList, dashboardList, mealList]
        .any((element) => element.isEmpty)) {
      try {
        cacheLoader = true;
        trackerDataList = mealDataModelFromJson(trackerList);
        model = GetDashboardModel.fromJson(jsonDecode(dashboardList));
        logData = mealDateByDate(mealList);
        loadDashboard(model, logData);
      } catch (e) {
        cacheLoader = false;
        log(e.toString());
      }
    }
    bloc.add(GenMealTrackerData());
    bloc.add(GetAllergiesAndRestriction());
    mealPlanBloc.add(MealPlanFetchEvent());
    bloc.add(GetDashboardData());

    /* dateBloc.add(GetMealLogByDateData(

        date: DateFormat('yyyy-MM-dd').format(DateTime.now())));*/
    PreferenceUtils.setInt(userMealPlanCountState, 0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      accountBloc.add(GetUnitInfoEvent());
    });

    if (widget.isOrderComplete && !PreferenceUtils.getBool(showOrderHint)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OrderHistoryHintScreen(),
        );
        PreferenceUtils.setBool(showOrderHint, true);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    carouselList = [
      BlocConsumer(
        bloc: accountBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetUnitInfoSuccessState) {
            isLoader = false;

            weightValue = state.unitData?.weightType == 'Pound' ? 1 : 2;
            waterValue = state.unitData?.waterType == 'Floz' ? 1 : 2;
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              commonSliderView(
                icon: AssetsUtils.breakFastIcon,
                title: StringUtils.breakfast,
                textTheme: Theme.of(context).textTheme,
                context: context,
                weightValue: weightValue,
              ),
              commonSliderView(
                  icon: AssetsUtils.lunchIcon,
                  title: StringUtils.lunch,
                  textTheme: Theme.of(context).textTheme,
                  context: context,
                  weightValue: weightValue),
            ],
          );
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          commonSliderView(
              icon: AssetsUtils.snackIcon,
              title: StringUtils.snack,
              textTheme: Theme.of(context).textTheme,
              context: context,
              weightValue: weightValue),
          commonSliderView(
              icon: AssetsUtils.dinnerIcon,
              title: StringUtils.dinner,
              textTheme: Theme.of(context).textTheme,
              context: context,
              weightValue: weightValue),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
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
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountScreen(),
                          ));
                      accountBloc.add(GetUnitInfoEvent());
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
                    if (state is LoadDashboardData || cacheLoader) {
                      return initView();
                    }
                    if (state is LoadMealData && !cacheLoader) {
                      return const AppCenterLoader();
                    }
                    if (state is LoadingDoneState || cacheLoader) {
                      return initView();
                    }
                    if (state is LoadingData && !cacheLoader) {
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
                      loadDashboard(state.model, state.data);
                    }
                    if (state is LoadMealData) {
                      isDoneLoader = false;
                      trackerDataList = state.trackerDataList;
                      bloc.add(AddIngredientGroceryList());
                    }
                    if (state is LoadingDoneState) {
                      isDoneLoader = true;
                      mealId = state.mealID;
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
    double per = (model.data?.totalIntakeFood?.toDouble().ceil() ?? 0) /
        (model.data?.totalCalorie?.toDouble().ceil() ?? 0);
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
                        percent:
                            per > 1 || per.isInfinite || per.isNaN ? 1.0 : per,
                        center: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${outOfTotalCalories.toDouble().round().toString()}cal left\n',
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
                                    'out of ${model.data?.totalCalorie?.toDouble().round().toString()}cal',
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
                            calCount: model.data?.totalIntakeFood
                                ?.toDouble()
                                .floor()
                                .toString(),
                            textTheme: Theme.of(context).textTheme,
                          ),
                          SizedBox(height: 15.h),
                          calDataView(
                            imgIcon: AssetsUtils.dumBBell,
                            title: 'Burned',
                            calCount: model.data?.totalBurnedByExercise
                                ?.toDouble()
                                .floor()
                                .toString(),
                            textTheme: Theme.of(context).textTheme,
                          ),
                        ],
                      ).paddingOnly(left: 30.w),
                    )
                  ],
                ),
                BlocConsumer(
                  bloc: accountBloc,
                  builder: (context, state) {
                    if (state is GetUnitInfoSuccessState) {
                      isLoader = false;

                      weightValue =
                          state.unitData?.weightType == 'Pound' ? 1 : 2;
                      waterValue = state.unitData?.waterType == 'Floz' ? 1 : 2;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calciumDataView(
                          title: 'Carbs',
                          textTheme: Theme.of(context).textTheme,
                          gramCount: model.data?.totalIntakeCarbs
                              ?.toDouble()
                              .floor()
                              .toString(),
                          totalGram: model.data?.totalCarbs
                              ?.toDouble()
                              .round()
                              .toString(),
                          progressColor: AppColors.mint,
                          percentage:
                              model.data!.totalIntakeCarbs!.toDouble().ceil() /
                                  model.data!.totalCarbs!.toDouble().ceil(),
                        ),
                        calciumDataView(
                            percentage: model.data!.totalIntakeProtein!
                                    .toDouble()
                                    .ceil() /
                                model.data!.totalProtein!.toDouble().ceil(),
                            title: 'Protein',
                            textTheme: Theme.of(context).textTheme,
                            gramCount: model.data?.totalIntakeProtein
                                ?.toDouble()
                                .floor()
                                .toString(),
                            totalGram: model.data!.totalProtein
                                ?.toDouble()
                                .floor()
                                .toString(),
                            progressColor: AppColors.skyBlue),
                        calciumDataView(
                          percentage:
                              model.data!.totalIntakeFat!.toDouble().ceil() /
                                  model.data!.totalFat!.toDouble().ceil(),
                          title: 'Fat',
                          textTheme: Theme.of(context).textTheme,
                          gramCount: model.data!.totalIntakeFat
                              ?.toDouble()
                              .floor()
                              .toString(),
                          totalGram: model.data!.totalFat!
                              .toDouble()
                              .floor()
                              .toString(),
                          progressColor: AppColors.coral,
                        ),
                      ],
                    );
                  },
                  listener: (BuildContext context, Object? state) {},
                )
              ],
            ).paddingAll(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocConsumer(
                bloc: accountBloc,
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is GetUnitInfoSuccessState) {
                    isLoader = false;

                    weightValue = state.unitData?.weightType == 'Pound' ? 1 : 2;

                    heightValue =
                        state.unitData?.heightType == 'Inches' ? 1 : 2;
                    energyValue =
                        state.unitData?.energyType == 'Kilojoules' ? 1 : 2;
                    waterValue = state.unitData?.waterType == 'Floz' ? 1 : 2;
                    unitId = state.unitData?.unitId;
                  }
                  return Expanded(
                    child: Builder(builder: (context) {
                      String? mydailyWaterGoals;
                      if (waterValue == 1) {
                        var value = (model.data!.dailyWaterGoals! * 0.033814);

                        mydailyWaterGoals = value.toStringAsFixed(2).toString();
                      } else {
                        mydailyWaterGoals =
                            model.data!.dailyWaterGoals.toString();
                      }
                      return InkWell(
                        onTap: () async {
                          Get.toNamed('/AddWaterScreen',
                                  arguments: AddWaterArguments(
                                      dailyGoal: mydailyWaterGoals.toString(),
                                      isWatervalue: waterValue))!
                              .then((value) {
                            bloc.add(GetDashboardData());
                          });
                        },
                        child: Builder(builder: (context) {
                          return dashBoardCardView(
                            margin: EdgeInsets.only(
                                left: 20.w, top: 15.h, bottom: 5.h),
                            child: waterExerciseDataView(
                              percentage: model.data!.totalIntakeWater! /
                                  model.data!.dailyWaterGoals!,
                              title: StringUtils.water,
                              textTheme: Theme.of(context).textTheme,
                              progressColor: AppColors.primaryBlue,
                              image: AssetsUtils.water,
                              type: StringUtils.rate,
                              // countValue: model.data!.dailyWaterGoals!.toString(),
                              countValue: mydailyWaterGoals.toString(),
                              mlCalCount: convertMilliToOz(
                                  textValue: model.data!.totalIntakeWater!,
                                  isWatervalue: waterValue),
                              tag: waterValue == 1
                                  ? StringUtils.oz
                                  : StringUtils.ml,
                            ),
                          );
                        }),
                      );
                    }),
                  );
                },
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
                bool isSkipped = false;
                logData.map((e) {
                  if (e.mealId == trackerDataList[index].id) {
                    isEaten = e.value.toString() == 'ATE';
                    isSkipped = e.value.toString() == 'SKIPPED';
                  }
                }).toList();

                return commonEatTypeData(
                  image: trackerDataList[index].recipe!.mainImage,
                  eatTitle: trackerDataList[index].meal,
                  eatSubTitle: trackerDataList[index].recipe!.name ?? '',
                  textTheme: Theme.of(context).textTheme,
                  trailing: isSkipped
                      ? SvgPicture.asset(
                          AssetsUtils.icSkippedIcon,
                          width: 25.w,
                        )
                      : InkWell(
                          onTap: isEaten
                              ? null
                              : () {
                                  if (!trackerDataList[index].isDone) {
                                    bloc.add(AddEatenMealData(
                                        value: 1,
                                        mealName:
                                            trackerDataList[index].recipe!.name,
                                        mealType: trackerDataList[index].meal,
                                        noOfServing: trackerDataList[index]
                                            .numOfServings,
                                        recipeId:
                                            trackerDataList[index].recipe!.id,
                                        userId: PreferenceUtils.getString(
                                            prefUserData),
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
                                        mealId: trackerDataList[index]
                                            .id
                                            .toString()));
                                  }
                                },
                          child: isDoneLoader &&
                                  trackerDataList[index].id == mealId
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
                  calText: trackerDataList[index]
                      .calories!
                      .toDouble()
                      .round()
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
    return Expanded(
      child: Column(
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
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
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
      percent: percentage.isNaN || percentage.isInfinite
          ? 0
          : percentage > 1
              ? 1
              : percentage,
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
    if (waterValue == 1) {}
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

  void loadDashboard(
      GetDashboardModel model, List<MealDataByDate>? data) async {
    this.model = model;
    outOfTotalCalories =
        (model.data?.totalCalorie ?? 0) - (model.data?.totalIntakeFood ?? 0);
    logData = data ?? [];
    await PreferenceUtils.setString(
        totalCalorie, (model.data?.totalCalorie ?? 0).toString());
    await PreferenceUtils.setString(
        totalProtein, (model.data?.totalProtein ?? 0).toString());
    await PreferenceUtils.setString(
        totalFat, (model.data?.totalFat ?? 0).toString());
    await PreferenceUtils.setString(
        totalCarbs, (model.data?.totalCarbs ?? 0).toString());
    setState(() {});
  }
}
