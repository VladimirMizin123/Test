import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BarCodeGroceryItemDetails extends StatefulWidget {
  final String? scanData;
  const BarCodeGroceryItemDetails({super.key, this.scanData});

  @override
  State<BarCodeGroceryItemDetails> createState() => _BarCodeGroceryItemDetailsState();
}

class _BarCodeGroceryItemDetailsState extends State<BarCodeGroceryItemDetails> {
  String _selectProduct = 'Spoon';
  List<String> productList = ['Spoon', 'Cup'];
  GroceryBloc groceryBloc = GroceryBloc();
  BarcodeScannerData? barcodeScannerData;
  int totalCount = 1;

  @override
  void initState() {
    super.initState();
    groceryBloc.add(BarcodeScanEvent(barcode: widget.scanData!));
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
                          child: const Icon(Icons.keyboard_arrow_left_outlined, size: 30)),
                      Text('Grocery Item Details', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
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
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          barcodeScannerData!.foodName ?? '',
                                          style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.medium),
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      const Icon(Icons.info_outline, color: AppColors.primaryBlue)
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (totalCount != 1) {
                                            totalCount = totalCount - 1;
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          height: size.height * 0.070,
                                          width: size.height * 0.070,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: AppColors.skyBlue,
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.remove, size: 27),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        height: size.height * 0.070,
                                        width: size.height * 0.070,
                                        decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(6)),
                                        child: Center(
                                            child: Text(
                                          totalCount.toString(),
                                          style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                        )),
                                      ),
                                      SizedBox(width: 8.w),
                                      GestureDetector(
                                        onTap: () {
                                          totalCount = totalCount + 1;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: size.height * 0.070,
                                          width: size.height * 0.070,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: AppColors.skyBlue,
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add, size: 27),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        flex: 2,
                                        child: DropdownButtonFormField(
                                            decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
                                            padding: EdgeInsets.zero,
                                            value: _selectProduct,
                                            borderRadius: BorderRadius.circular(12),
                                            items: productList
                                                .map((e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(e),
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                _selectProduct = val!;
                                              });
                                            }),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),
                                  GridView(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2, crossAxisSpacing: 6.w, mainAxisSpacing: 6.h),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      myProgressBarCardView('Cal', barcodeScannerData!.nfCalories == null ? 0 : double.parse(barcodeScannerData!.nfCalories.toString()), double.parse(double.parse(PreferenceUtils.getString(totalCalorie)).toStringAsFixed(2)), AppColors.primaryBlue),
                                      myProgressBarCardView('Fat', barcodeScannerData!.nfTotalFat == null ? 0 : double.parse(barcodeScannerData!.nfTotalFat.toString()), double.parse(double.parse(PreferenceUtils.getString(totalFat)).toStringAsFixed(2)), AppColors.coral),
                                      myProgressBarCardView('Carbs', barcodeScannerData!.nfTotalCarbohydrate == null ? 0 : double.parse(barcodeScannerData!.nfTotalCarbohydrate.toString()), double.parse(double.parse(PreferenceUtils.getString(totalCarbs)).toStringAsFixed(2)), AppColors.mint),
                                      myProgressBarCardView('Protein', barcodeScannerData!.nfTotalFat == null ? 0 : double.parse(barcodeScannerData!.nfTotalFat.toString()), double.parse(double.parse(PreferenceUtils.getString(totalProtein)).toStringAsFixed(2)), AppColors.skyBlue),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Align(alignment: Alignment.centerLeft, child: Text('Nutritional Information', style: FontUtils.h24(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold))),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Calories', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                      Text('${barcodeScannerData!.nfCalories}g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(color: AppColors.disabledColor, height: 2.h),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Protein', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                      Text('${barcodeScannerData!.nfProtein}g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(color: AppColors.disabledColor, height: 2.h),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Carbs', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                      Text('${barcodeScannerData!.nfTotalCarbohydrate}g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(color: AppColors.disabledColor, height: 2.h),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                      Text('${barcodeScannerData!.nfTotalFat}g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(color: AppColors.disabledColor, height: 2.h),

                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10),
                                  // Divider(color: AppColors.disabledColor, height: 2.h),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                  //     Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10),
                                  // Divider(color: AppColors.disabledColor, height: 2.h),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                  //     Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 15),
                                  simpleTextBorderButton(
                                    context: context,
                                    buttonLable: 'Add Item',
                                    height: size.height * 0.065,
                                    width: size.width,
                                    isLoadingWidget: state is AddNewCustomMealLoadingState,
                                    onTap: () {
                                      groceryBloc.add(AddNewCustomMealEvent(
                                        calorie: barcodeScannerData!.nfCalories.toString(),
                                        carbs: barcodeScannerData!.nfTotalCarbohydrate.toString(),
                                        fat: barcodeScannerData!.nfTotalFat.toString(),
                                        name: barcodeScannerData!.foodName,
                                        protein: barcodeScannerData!.nfProtein.toString(),
                                        type: 'breakfast',
                                      ));
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
                ],
              ),
            );
          }),
    );
  }

  Widget myProgressBarCardView(String title, double value, double totalValue, Color progressBarColor) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.whiteColor,
          boxShadow: const [
            BoxShadow(color: AppColors.black, blurRadius: 30, spreadRadius: -30),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: FontUtils.h20(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                commonProgressBar(progressColor: progressBarColor, width: screenSize.width * 0.27, percentage: value / totalValue, lineHeight: 12),
              ],
            ),
            Text('${value.toStringAsFixed(2)} / ${totalValue.toStringAsFixed(2)} cal', style: FontUtils.h15(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
          ],
        ));
  }

  Widget commonProgressBar({Color? progressColor, double? width, double? percentage, double? lineHeight}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: const Radius.circular(10),
      animation: true,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: percentage ?? 0,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }
}
