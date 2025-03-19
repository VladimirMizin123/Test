import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_dashboard_model.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/search_product_sheet.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CalorieDetailsDialog extends StatelessWidget {
  const CalorieDetailsDialog(
      {super.key, required this.dashboardModel, required this.onContinueTap});

  final GetDashboardModel dashboardModel;
  final Function() onContinueTap;

  @override
  Widget build(BuildContext context) {
    double per =
        (dashboardModel.data?.totalIntakeFood?.toDouble().ceil() ?? 0) /
            (dashboardModel.data?.totalCalorie?.toDouble().ceil() ?? 0);
    num outOfTotalCalories = (dashboardModel.data?.totalCalorie ?? 0) -
        (dashboardModel.data?.totalIntakeFood ?? 0);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        constraints: BoxConstraints(
            maxHeight: context.height * 0.9, minHeight: context.height * 0.5),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              10.height,
              const SheetHandle(),
              16.height,
              Image.asset(
                AssetsUtils.gymEatsLogo,
                height: 30.h,
                width: 100.w,
                color: AppColors.primaryBlue,
              ),
              6.height,
              Text("${StringUtils.notification}:",
                  style: FontUtils.h18(
                      fontColor: AppColors.oxFF010101, fontWeight: FWT.bold)),
              Text(StringUtils.thisIsGentleNotification,
                  style: FontUtils.h17(
                      fontColor: AppColors.oxFF010101,
                      fontWeight: FWT.semiBold)),
              10.height,
              Text(StringUtils.doYouStillWantToSearch,
                  style: FontUtils.h17(
                      fontColor: AppColors.errorRedColor,
                      fontWeight: FWT.boldMedium)),
              12.height,
              dashBoardCardView(
                width: 315.w,
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
                            percent: per > 1 || per.isInfinite || per.isNaN
                                ? 1.0
                                : per,
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
                                        'out of ${dashboardModel.data?.totalCalorie?.toDouble().round().toString()}cal',
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
                                calCount: dashboardModel.data?.totalIntakeFood
                                    ?.toDouble()
                                    .floor()
                                    .toString(),
                                textTheme: Theme.of(context).textTheme,
                              ),
                              SizedBox(height: 15.h),
                              calDataView(
                                imgIcon: AssetsUtils.dumBBell,
                                title: 'Burned',
                                calCount: dashboardModel
                                    .data?.totalBurnedByExercise
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calciumDataView(
                          title: 'Carbs',
                          textTheme: Theme.of(context).textTheme,
                          gramCount: dashboardModel.data?.totalIntakeCarbs
                              ?.toDouble()
                              .floor()
                              .toString(),
                          totalGram: dashboardModel.data?.totalCarbs
                              ?.toDouble()
                              .round()
                              .toString(),
                          progressColor: AppColors.mint,
                          percentage: dashboardModel.data!.totalIntakeCarbs!
                                  .toDouble()
                                  .ceil() /
                              dashboardModel.data!.totalCarbs!
                                  .toDouble()
                                  .ceil(),
                        ),
                        calciumDataView(
                            percentage: dashboardModel.data!.totalIntakeProtein!
                                    .toDouble()
                                    .ceil() /
                                dashboardModel.data!.totalProtein!
                                    .toDouble()
                                    .ceil(),
                            title: 'Protein',
                            textTheme: Theme.of(context).textTheme,
                            gramCount: dashboardModel.data?.totalIntakeProtein
                                ?.toDouble()
                                .floor()
                                .toString(),
                            totalGram: dashboardModel.data!.totalProtein
                                ?.toDouble()
                                .floor()
                                .toString(),
                            progressColor: AppColors.skyBlue),
                        calciumDataView(
                          percentage: dashboardModel.data!.totalIntakeFat!
                                  .toDouble()
                                  .ceil() /
                              dashboardModel.data!.totalFat!.toDouble().ceil(),
                          title: 'Fat',
                          textTheme: Theme.of(context).textTheme,
                          gramCount: dashboardModel.data!.totalIntakeFat
                              ?.toDouble()
                              .floor()
                              .toString(),
                          totalGram: dashboardModel.data!.totalFat!
                              .toDouble()
                              .floor()
                              .toString(),
                          progressColor: AppColors.coral,
                        ),
                      ],
                    )
                  ],
                ).paddingAll(8),
              ),
              16.height,
              buildButton(
                context: context,
                title: StringUtils.continueTxt,
                onPressed: () {
                  Get.back();
                  onContinueTap();
                  // verifyRestaurant(res: res);
                },
                bgColor: AppColors.letsEatButton,
                textColor: AppColors.lightGrey,
                borderRadius: 16,
              ),
              12.height,
              buildButton(
                context: context,
                title: StringUtils.dashboard,
                onPressed: () {
                  Get.offAllNamed('/AppManagerScreen');
                },
                bgColor: AppColors.appColor,
                textColor: AppColors.lightGrey,
                borderRadius: 16,
              ),
              20.height,
            ],
          ),
        ),
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
                  title ?? "",
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
            title ?? "",
            style: textTheme?.bodyLarge?.copyWith(color: AppColors.darkGray),
          ),
          SizedBox(height: 5.h),
          commonProgressBar(
            progressColor: progressColor,
            width: 76.w,
            lineHeight: 10.0,
            percentage: percentage,
          ),
          SizedBox(height: 5.h),
          Text(
            '$gramCount / $totalGram g',
            style: textTheme?.bodyMedium?.copyWith(color: AppColors.darkGray),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget commonProgressBar({
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
}
