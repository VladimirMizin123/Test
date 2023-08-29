import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final routeName = '/JournalScreen';
  DateTime datetime = DateTime.now();
  int currentIndex = 0;
  bool yesTap = false;
  bool noTap = false;
  bool defaultImage = true;

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
    var totalDays = daysInMonth(datetime);
    var listOfDates = List<int>.generate(totalDays, (i) => i + 1);
    List<Widget> carouselList = [
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      AssetsUtils.user,
                      height: 25.h,
                      width: 25.w,
                      color: AppColors.darkGray,
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
                ).paddingSymmetric(vertical: 5.h),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      DateFormat.yMMMMd().format(datetime),
                      style: textTheme.headlineSmall
                          ?.copyWith(color: AppColors.middleGray),
                    ),
                    children: [
                      SizedBox(
                        height: 60.h,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listOfDates.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final bool isSelected = index == datetime.day - 1;
                            final currentDate = DateTime(datetime.year,
                                datetime.month, listOfDates[index]);
                            final dayAbbreviation =
                                DateFormat.E().format(currentDate);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  datetime = DateTime(datetime.year,
                                      datetime.month, listOfDates[index]);
                                });
                              },
                              child: Container(
                                height: 60.h,
                                padding: const EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
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
                                    Text(dayAbbreviation),
                                    Container(
                                      height: 25.h,
                                      width: 25.w,
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
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                            style: textTheme.headlineSmall
                                ?.copyWith(color: AppColors.darkGray),
                          ),
                          Text(
                            '1700 / 2000 cal',
                            style: textTheme.bodyLarge
                                ?.copyWith(color: AppColors.middleGray),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 8.w),
                      commonProgressbar(
                        width: 300.w,
                        lineHeight: 8.0,
                        percent: 0.7,
                        progressColor: AppColors.primaryBlue,
                      ).paddingOnly(top: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          calciumDataView(
                            title: 'Carbs',
                            textTheme: textTheme,
                            gramCount: '100',
                            totalGram: '177',
                            progressColor: AppColors.mint,
                          ),
                          calciumDataView(
                            title: 'Protein',
                            textTheme: textTheme,
                            gramCount: '32',
                            totalGram: '48',
                            progressColor: AppColors.skyBlue,
                          ),
                          calciumDataView(
                            title: 'Fat',
                            textTheme: textTheme,
                            gramCount: '100',
                            totalGram: '177',
                            progressColor: AppColors.coral,
                          ),
                        ],
                      ).paddingOnly(top: 5.h),
                    ],
                  ).paddingAll(5),
                ),
                Text(
                  'Food',
                  style: textTheme.headlineSmall
                      ?.copyWith(color: AppColors.middleGray),
                ).paddingOnly(top: 5.h),
                dashBoardCardView(
                  width: double.infinity.w,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          AssetsUtils.breakFastIcon,
                          height: 25.h,
                          width: 25.w,
                          color: AppColors.darkGray,
                        ),
                        title: Row(
                          children: [
                            Text(
                              'Breakfast   ',
                              style: textTheme.headlineSmall
                                  ?.copyWith(color: AppColors.darkGray),
                            ),
                            Text(
                              '200 cal',
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.terracotta),
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
                      Divider(color: AppColors.middleGray, height: 1.h)
                          .paddingSymmetric(horizontal: 15.w),
                      commonJournalFoodData(
                        title: 'Chickpea Flour Omlette With Asparagus',
                        subTitle: '1 serving',
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 13.h,
                          color: AppColors.darkGray,
                        ),
                        textTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w400),
                        subTextTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.terracotta,
                            fontWeight: FontWeight.w400),
                      ).paddingOnly(top: 10.h),
                      commonJournalFoodData(
                        title: 'Bread',
                        subTitle: '1 slice',
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 13.h,
                          color: AppColors.darkGray,
                        ),
                        textTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w400),
                        subTextTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.terracotta,
                            fontWeight: FontWeight.w400),
                      ).paddingOnly(top: 10.h, bottom: 10.h),
                    ],
                  ),
                ),
                commonFoodItemView(
                    textTheme: textTheme,
                    image: AssetsUtils.lunchIcon,
                    title: StringUtils.lunch),
                commonFoodItemView(
                    textTheme: textTheme,
                    image: AssetsUtils.dinnerIcon,
                    title: StringUtils.dinner),
                commonFoodItemView(
                    textTheme: textTheme,
                    image: AssetsUtils.snackIcon,
                    title: StringUtils.snack),
                Text(
                  'Routine',
                  style: textTheme.headlineSmall
                      ?.copyWith(color: AppColors.middleGray),
                ).paddingOnly(top: 15.h),
                dashBoardCardView(
                  width: double.infinity.w,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          AssetsUtils.water,
                          height: 25.h,
                          width: 25.w,
                          color: AppColors.darkGray,
                        ),
                        title: Text(
                          'Water',
                          style: textTheme.headlineSmall
                              ?.copyWith(color: AppColors.darkGray),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 15.h, color: const Color(0xFF010101)),
                        horizontalTitleGap: 0.0,
                      ),
                      Divider(color: AppColors.middleGray, height: 1.h)
                          .paddingSymmetric(horizontal: 15.w),
                      commonJournalFoodData(
                        title: 'Water',
                        subTitle: '750 ml',
                        child: Icon(
                          Icons.remove,
                          size: 18.h,
                          color: AppColors.darkGray,
                        ),
                        textTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w400),
                        subTextTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.terracotta,
                            fontWeight: FontWeight.w400),
                      ).paddingOnly(top: 7.h, bottom: 10.h),
                    ],
                  ),
                ),
                dashBoardCardView(
                  width: double.infinity.w,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          AssetsUtils.dumBBell,
                          height: 25.h,
                          width: 25.w,
                          color: AppColors.darkGray,
                        ),
                        title: Text(
                          'Add exercise',
                          style: textTheme.headlineSmall
                              ?.copyWith(color: AppColors.darkGray),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15.h,
                          color: const Color(0xFF010101),
                        ),
                        horizontalTitleGap: 0.0,
                      ),
                      Divider(color: AppColors.middleGray, height: 1.h)
                          .paddingSymmetric(horizontal: 15.w),
                      commonJournalFoodData(
                        title: StringUtils.running,
                        subTitle: '220 cal burned',
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 13.h,
                          color: AppColors.darkGray,
                        ),
                        textTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w400),
                        subTextTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.terracotta,
                            fontWeight: FontWeight.w400),
                      ).paddingOnly(top: 10.h),
                      commonJournalFoodData(
                        title: 'Workout',
                        subTitle: '220 cal burned',
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 13.h,
                          color: AppColors.darkGray,
                        ),
                        textTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w400),
                        subTextTheme: textTheme.bodySmall?.copyWith(
                            color: AppColors.terracotta,
                            fontWeight: FontWeight.w400),
                      ).paddingOnly(top: 10.h, bottom: 10.h),
                    ],
                  ),
                ),
                Text(
                  'Daily Recap',
                  style: textTheme.headlineSmall
                      ?.copyWith(color: AppColors.middleGray),
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
                ).paddingOnly(bottom: 20.w, top: 15.h)
              ],
            ).paddingSymmetric(horizontal: 20.w),
          ),
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
                border: yesTap
                    ? Border.all(color: AppColors.greenPressed, width: 2.w)
                    : null,
                mainAxisAlignment: yesTap
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                onTap: () {
                  setState(() {
                    yesTap = true;
                    noTap = false;
                    defaultImage = false;
                  });
                },
                showImage: yesTap
                    ? Image.asset(AssetsUtils.greenRight,
                        height: 20.h, width: 20.w)
                    : const SizedBox()),
            commonYesNoButton(
                textTheme: textTheme,
                title: StringUtils.no,
                textColor: AppColors.terracottaPressed,
                bgColor: AppColors.coral,
                border: noTap
                    ? Border.all(color: AppColors.terracottaPressed, width: 2.w)
                    : null,
                mainAxisAlignment: noTap
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                onTap: () {
                  setState(() {
                    yesTap = false;
                    noTap = true;
                    defaultImage = false;
                  });
                },
                showImage: noTap
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
          percent: 0.7,
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
    TextTheme? textTheme,
  }) {
    return Column(
      children: [
        dashBoardCardView(
          width: double.infinity.w,
          child: ListTile(
            leading: Image.asset(
              image,
              height: 25.h,
              width: 25.w,
              color: AppColors.darkGray,
            ),
            title: Text(
              title,
              style:
                  textTheme?.headlineSmall?.copyWith(color: AppColors.darkGray),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15.h,
              color: const Color(0xFF010101),
            ),
            horizontalTitleGap: 0.0,
          ),
        ),
        commonBorderView(
          child: commonJournalFoodData(
            title: StringUtils.smokedMackerel,
            subTitle: StringUtils.calCount,
            child: Container(
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
            textTheme: textTheme?.bodySmall?.copyWith(
                color: AppColors.darkGray, fontWeight: FontWeight.w400),
            subTextTheme: textTheme?.bodySmall?.copyWith(
                color: AppColors.terracotta, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    ).paddingOnly(top: 20.h);
  }
}
