<<<<<<< Updated upstream
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final routeName = '/DashBoardScreen';
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    List<Widget> carouselList = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          commonSliderView(
            icon: AppStrings.breakFastIcon,
            title: AppStrings.breakfast,
            textTheme: textTheme,
          ),
          commonSliderView(
            icon: AppStrings.lunchIcon,
            title: AppStrings.lunch,
            textTheme: textTheme,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          commonSliderView(
            icon: AppStrings.snackIcon,
            title: AppStrings.snack,
            textTheme: textTheme,
          ),
          commonSliderView(
            icon: AppStrings.dinnerIcon,
            title: AppStrings.dinner,
            textTheme: textTheme,
          ),
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
                  Image.asset(
                    AppStrings.user,
                    height: 25.h,
                    width: 25.w,
                    color: AppColors.darkGray,
                  ),
                  Text(
                    AppStrings.dashBoard,
                    style: textTheme.displayMedium
                        ?.copyWith(color: const Color(0xFF010101)),
                  ),
                  Image.asset(
                    AppStrings.notification,
                    height: 25.h,
                    width: 25.w,
                    color: AppColors.darkGray,
                  )
                ],
              ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    dashBoardCardView(
                      height: 230.h,
                      width: 315.w,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 140.h,
                                width: 140.w,
                                child: CircularPercentIndicator(
                                  radius: 70.0,
                                  animation: true,
                                  animationDuration: 1200,
                                  lineWidth: 8.0,
                                  percent: 0.8,
                                  center: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '300cal left\n',
                                          style: textTheme.headlineSmall!
                                              .copyWith(
                                                  color: AppColors.darkGray),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Single tapped.
                                            },
                                        ),
                                        TextSpan(
                                          text: 'out of 2000cal',
                                          style: textTheme.bodyMedium!.copyWith(
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
                                height: 140.h,
                                width: 140.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    calDataView(
                                      imgIcon: AppStrings.breakFastIcon,
                                      title: 'Eaten',
                                      calCount: '1700',
                                      textTheme: textTheme,
                                    ),
                                    SizedBox(height: 15.h),
                                    calDataView(
                                      imgIcon: AppStrings.dumBBell,
                                      title: 'Burned',
                                      calCount: '320',
                                      textTheme: textTheme,
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
                                  textTheme: textTheme,
                                  gramCount: '100',
                                  totalGram: '177',
                                  progressColor: AppColors.mint),
                              calciumDataView(
                                  title: 'Protein',
                                  textTheme: textTheme,
                                  gramCount: '32',
                                  totalGram: '48',
                                  progressColor: AppColors.skyBlue),
                              calciumDataView(
                                title: 'Fat',
                                textTheme: textTheme,
                                gramCount: '100',
                                totalGram: '177',
                                progressColor: AppColors.coral,
                              ),
                            ],
                          )
                        ],
                      ).paddingAll(10),
                    ),
                    SizedBox(
                      height: 150.h,
                      width: double.infinity.w,
                      child: ListView.builder(
                        itemCount: 2,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return dashBoardCardView(
                            height: 150.h,
                            width: 163.w,
                            margin: EdgeInsets.only(
                                left: 20.w, top: 15.h, bottom: 5.h),
                            child: waterExerciseDataView(
                              title: 'Water',
                              textTheme: textTheme,
                              progressColor: AppColors.primaryBlue,
                              image: AppStrings.water,
                              type: 'Rate',
                              countValue: '2000',
                              ml_cal_Count: '750',
                              tag: 'ml',
                            ),
                          );
                        },
                      ),
                    ),
                    Column(
                      children: [
                        commonEatTypeData(
                          image: AppStrings.breakFastImage,
                          eatTitle: AppStrings.breakfast,
                          eatSubTitle: AppStrings.subBreakfast,
                          textTheme: textTheme,
                          trailing: Container(
                            height: 25.h,
                            width: 25.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.skyBlue,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        commonEatTypeData(
                          image: AppStrings.lunchImage,
                          eatTitle: AppStrings.lunch,
                          eatSubTitle: AppStrings.subLunch,
                          textTheme: textTheme,
                          trailing: Container(
                            height: 25.h,
                            width: 25.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.skyBlue,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        commonEatTypeData(
                          image: AppStrings.snackImage,
                          eatTitle: AppStrings.snack,
                          eatSubTitle: AppStrings.subSnack,
                          textTheme: textTheme,
                          trailing: Container(
                            height: 25.h,
                            width: 25.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.skyBlue,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        commonEatTypeData(
                          image: AppStrings.dinnerImage,
                          eatTitle: AppStrings.dinner,
                          eatSubTitle: AppStrings.subDinner,
                          textTheme: textTheme,
                          trailing: Container(
                            height: 25.h,
                            width: 25.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.skyBlue,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 75.h,
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
                    ).paddingOnly(bottom: 20.w, top: 5.h)
                  ],
                ),
              ),
            ],
          ),
        ),
=======
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/meal_plan_home_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String routeName;
  const DashboardScreen({super.key, this.routeName = ''});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icMealPlan, color: selectedIndex == 0 ? ColorUtils.letsEatButton : ColorUtils.middleGray), label: StringUtils.mealPlan),
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icGrocery, color: selectedIndex == 1 ? ColorUtils.letsEatButton : ColorUtils.middleGray), label: StringUtils.grocery),
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icDashboard, color: selectedIndex == 2 ? ColorUtils.letsEatButton : ColorUtils.middleGray), label: StringUtils.dashboard),
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icRestaurants, color: selectedIndex == 3 ? ColorUtils.letsEatButton : ColorUtils.middleGray), label: StringUtils.restaurants),
          BottomNavigationBarItem(icon: SvgPicture.asset(AssetsUtils.icJournal, color: selectedIndex == 4 ? ColorUtils.letsEatButton : ColorUtils.middleGray), label: StringUtils.journal),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: ColorUtils.letsEatButton,
        unselectedItemColor: ColorUtils.middleGray,
        unselectedLabelStyle: FontUtils.h10(fontColor: ColorUtils.letsEatButton, fontWeight: FWT.semiBold),
        selectedLabelStyle: FontUtils.h10(fontColor: ColorUtils.middleGray, fontWeight: FWT.bold),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 10,
>>>>>>> Stashed changes
      ),
    );
  }

<<<<<<< Updated upstream
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
  }) {
    return Column(
      children: [
        Text(
          title.toString(),
          style: textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray),
        ),
        commonProgressbar(
            progressColor: progressColor, width: 76.w, lineHeight: 10.0),
        Text(
          '$gramCount / $totalGram g',
          style: textTheme?.bodyMedium?.copyWith(color: AppColors.darkGray),
        )
      ],
    );
  }

  Widget commonProgressbar(
      {Color? progressColor, double? width, double? lineHeight}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: const Radius.circular(10),
      animation: true,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: 0.7,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }

  Widget waterExerciseDataView(
      {String? title,
      String? ml_cal_Count,
      Color? progressColor,
      String? tag,
      String? image,
      String? type,
      TextTheme? textTheme,
      String? countValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title.toString(),
              style:
                  textTheme?.headlineSmall?.copyWith(color: AppColors.darkGray),
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
              ' $ml_cal_Count $tag',
              style:
                  textTheme?.headlineSmall?.copyWith(color: AppColors.darkGray),
            )
          ],
        ).paddingOnly(left: 12.w),
        Text(
          'Daily $type: $countValue $tag',
          style: textTheme?.bodySmall?.copyWith(color: AppColors.darkGray),
        ).paddingOnly(left: 15.w),
        commonProgressbar(
            progressColor: progressColor, width: 139.w, lineHeight: 8.0),
      ],
    );
  }

  Widget commonEatTypeData({
    String? image,
    String? eatTitle,
    String? eatSubTitle,
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
          leading: Image.asset(
            image.toString(),
            height: 45.h,
            width: 45.w,
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
                    AppStrings.fire,
                    height: 18.h,
                    width: 18.w,
                  ),
                  Text(
                    '421cal',
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
=======
  getScreen() {
    switch (selectedIndex) {
      case 0:
        return const MealPlanHomeScreen();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return Container();
      default:
    }
>>>>>>> Stashed changes
  }
}
