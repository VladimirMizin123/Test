import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_event.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_item_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../bloc/grocery/add_new_grocery/add_new_grocery_state.dart';

class BarCodeGroceryItemDetails extends StatefulWidget {
  final String? scanData;
  final String? type;
  final String? mealType;
  final DateTime? selectedDate;
  const BarCodeGroceryItemDetails({
    super.key,
    this.scanData,
    this.type,
    this.mealType,
    required this.selectedDate,
  });

  @override
  State<BarCodeGroceryItemDetails> createState() =>
      _BarCodeGroceryItemDetailsState();
}

class _BarCodeGroceryItemDetailsState extends State<BarCodeGroceryItemDetails> {
  GroceryBloc groceryBloc = GroceryBloc();
  BarcodeScannerData? barcodeScannerData;
  int totalCount = 1;
  AddNewMealBloc getAddNewMealBloc = AddNewMealBloc();
  @override
  void initState() {
    super.initState();
    groceryBloc.add(BarcodeScanEvent(barcode: widget.scanData ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<GroceryBloc, GroceryState>(
          bloc: groceryBloc,
          listener: (context, state) {
            if (state is BarcodeScannerSuccessState) {
              barcodeScannerData = state.barcodeScannerData;
            }

            if (state is AddNewCustomMealSuccessState) {
              Navigator.pop(context);
            }
            if (state is BarcodeScannerErrorState) {
              log("Call Error");
              Get.offNamed("/AddNewItemScreen", arguments: {
                "title": widget.mealType,
                "date": widget.selectedDate,
              });
            }
          },
          builder: (context, state) {
            return SafeArea(
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
                            Get.back();
                          },
                          child: const Icon(Icons.keyboard_arrow_left_outlined,
                              size: 30)),
                      Text('Grocery Item Details',
                          style: FontUtils.h20(
                              fontColor: AppColors.oxFF010101,
                              fontWeight: FWT.semiBold)),
                      Opacity(
                        opacity: 0,
                        child: Image.asset(
                          AssetsUtils.filter,
                          height: 20.h,
                          width: 20.w,
                          color: AppColors.darkGray,
                        ),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                  Expanded(
                    child: barcodeScannerData == null
                        ? state is BarcodeScannerLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const SizedBox()
                        : BlocConsumer(
                            bloc: getAddNewMealBloc,
                            listener: (context, state) {},
                            builder: (context, state) => SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            barcodeScannerData?.foodName ?? '',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.black,
                                                fontWeight: FWT.medium),
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        const Icon(Icons.info_outline,
                                            color: AppColors.primaryBlue)
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    GridView(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 2,
                                              crossAxisSpacing: 6.w,
                                              mainAxisSpacing: 6.h),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        myProgressBarCardView(
                                            'Cal',
                                            barcodeScannerData?.nfCalories ==
                                                    null
                                                ? 0
                                                : double.tryParse(
                                                        barcodeScannerData
                                                                ?.nfCalories
                                                                .toString() ??
                                                            "") ??
                                                    0,
                                            double.parse(double.tryParse(
                                                        PreferenceUtils
                                                            .getString(
                                                                totalCalorie))
                                                    ?.toStringAsFixed(2) ??
                                                "0"),
                                            AppColors.primaryBlue),
                                        myProgressBarCardView(
                                          'Fat',
                                          barcodeScannerData?.nfTotalFat == null
                                              ? 0
                                              : double.tryParse(
                                                      barcodeScannerData
                                                              ?.nfTotalFat
                                                              .toString() ??
                                                          "") ??
                                                  0,
                                          double.parse(double.parse(
                                                  PreferenceUtils.getString(
                                                      totalFat))
                                              .toStringAsFixed(2)),
                                          AppColors.coral,
                                          isGram: true,
                                        ),
                                        myProgressBarCardView(
                                          'Carbs',
                                          barcodeScannerData
                                                      ?.nfTotalCarbohydrate ==
                                                  null
                                              ? 0
                                              : double.tryParse(barcodeScannerData
                                                          ?.nfTotalCarbohydrate
                                                          .toString() ??
                                                      "") ??
                                                  0,
                                          double.parse(double.tryParse(
                                                      PreferenceUtils.getString(
                                                          totalCarbs))
                                                  ?.toStringAsFixed(2) ??
                                              "0"),
                                          AppColors.mint,
                                          isGram: true,
                                        ),
                                        myProgressBarCardView(
                                          'Protein',
                                          barcodeScannerData?.nfTotalFat == null
                                              ? 0
                                              : double.tryParse(
                                                      barcodeScannerData
                                                              ?.nfTotalFat
                                                              .toString() ??
                                                          "") ??
                                                  0,
                                          double.tryParse(double.tryParse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalProtein))
                                                      ?.toStringAsFixed(2) ??
                                                  "0") ??
                                              0,
                                          AppColors.skyBlue,
                                          isGram: true,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Nutritional Information',
                                            style: FontUtils.h24(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.semiBold))),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Calories',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.medium)),
                                        Text(
                                            '${barcodeScannerData?.nfCalories ?? 0} cal',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.medium)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Divider(
                                        color: AppColors.disabledColor,
                                        height: 2.h),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Protein',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.medium)),
                                        Text(
                                            '${barcodeScannerData?.nfProtein ?? 0}g',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.medium)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Divider(
                                        color: AppColors.disabledColor,
                                        height: 2.h),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Carbs',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.medium)),
                                        Text(
                                            '${barcodeScannerData?.nfTotalCarbohydrate ?? 0}g',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.medium)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Divider(
                                        color: AppColors.disabledColor,
                                        height: 2.h),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Fat',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.medium)),
                                        Text(
                                            '${barcodeScannerData?.nfTotalFat ?? 0}g',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.medium)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Divider(
                                        color: AppColors.disabledColor,
                                        height: 2.h),
                                    const SizedBox(height: 40),
                                    state is AddNewMealLoadingState
                                        ? const AppCenterLoader()
                                        : simpleTextBorderButton(
                                            context: context,
                                            buttonLable: 'Add Item',
                                            height: size.height * 0.065,
                                            width: size.width,
                                            isLoadingWidget:
                                                state is LoadingState,
                                            onTap: () {
                                              getAddNewMealBloc.add(
                                                AddNewMeal(
                                                  name: barcodeScannerData
                                                          ?.foodName ??
                                                      '',
                                                  protein: barcodeScannerData
                                                          ?.nfProtein
                                                          .toString() ??
                                                      '',
                                                  fat: barcodeScannerData
                                                          ?.nfTotalFat
                                                          .toString() ??
                                                      '',
                                                  carbs: barcodeScannerData
                                                          ?.nfTotalCarbohydrate
                                                          .toString() ??
                                                      '',
                                                  calorie: barcodeScannerData
                                                          ?.nfCalories
                                                          .toString() ??
                                                      '',
                                                  type: widget.type
                                                          ?.toString()
                                                          .removeAllWhitespace ??
                                                      '',
                                                  userId: userId,
                                                  quantity: '1',
                                                  date: widget.selectedDate
                                                      ?.toIso8601String(),
                                                ),
                                              );
                                            },
                                            isDarkColor: true,
                                            isFillColor: true,
                                          ),
                                    SizedBox(height: 14.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget myProgressBarCardView(
      String title, double value, double totalValue, Color progressBarColor,
      {bool isGram = false}) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.whiteColor,
          boxShadow: const [
            BoxShadow(
                color: AppColors.black, blurRadius: 30, spreadRadius: -30),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: FontUtils.h20(
                    fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                commonProgressBar(
                    progressColor: progressBarColor,
                    width: screenSize.width * 0.27,
                    percentage: value / totalValue,
                    lineHeight: 12),
              ],
            ),
            Text(
                '${value.toStringAsFixed(2)} / ${totalValue.toStringAsFixed(2)} ${isGram ? "g" : "cal"}',
                style: FontUtils.h15(
                    fontColor: AppColors.darkGray,
                    fontWeight: FWT.lightMedium)),
          ],
        ));
  }

  Widget commonProgressBar(
      {Color? progressColor,
      double? width,
      double? percentage,
      double? lineHeight}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: const Radius.circular(10),
      animation: true,
      lineHeight: lineHeight ?? 5.0,
      animationDuration: 2000,
      percent: percentage != null && percentage > 1 ? 1 : percentage ?? 0,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }
}
