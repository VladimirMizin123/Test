import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_event.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_state.dart';
import 'package:gymeats_mobile/screen/journal/journal_search_screen.dart';
import 'package:gymeats_mobile/screen/journal/journal_skip_meal_bottomsheet.dart';
import 'package:gymeats_mobile/screen/journal/journal_swap_meal_bottomsheet.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/screen/journal/scan_barcode_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/arguments/meal_plan_arguments_screen.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/font_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/fetch_meal_plan_model.dart';
import '../../widget/app_widget.dart';
import '../../widget/svg_image.dart';

class JournalMealScreen extends StatefulWidget {
  const JournalMealScreen({Key? key}) : super(key: key);

  @override
  State<JournalMealScreen> createState() => _JournalMealScreenState();
}

class _JournalMealScreenState extends State<JournalMealScreen> {
  final routeName = '/JournalMealScreen';

  JournalPlanBloc journalPlanBloc = JournalPlanBloc();
  List<MealData> mealList = [];
  JournalMealScreenArguments? journalMealScreenArguments = Get.arguments;
  // List<FetchMealPlanData> mealPlanList = [];
  TextEditingController controller = TextEditingController();
  BarcodeScannerData? barcodeScannerData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      journalPlanBloc.add(JournalPlanFetchEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<JournalPlanBloc, JournalMealPlanState>(
        bloc: journalPlanBloc,
        listener: (BuildContext context, JournalMealPlanState state) {
          if (state is JournalFetchMealPlanSuccessState) {
            for (var i = 0; i < state.mealPlanList.length; i++) {
              if (DateTime(state.mealPlanList[i].date!.year, state.mealPlanList[i].date!.month, state.mealPlanList[i].date!.day) == DateTime(journalMealScreenArguments!.dateTime!.year, journalMealScreenArguments!.dateTime!.month, journalMealScreenArguments!.dateTime!.day)) {
                for (var j = 0; j < state.mealPlanList[i].meals!.length; j++) {
                  if (state.mealPlanList[i].meals![j].meal!.trim().toLowerCase() == journalMealScreenArguments!.mealType!.trim().toLowerCase()) {
                    mealList.add(state.mealPlanList[i].meals![j]);
                  }
                }
                break;
              }
            }
          }

          if (state is JournalSkipMealPlanSuccessState) {
            for (var i = 0; i < mealList.length; i++) {
              if (mealList[i].id == state.mealID) {
                mealList[i].isSkipped = true;
              }
            }
          }

          if (state is JournalSwapMealDetailsState) {
            Get.back();
            for (var i = 0; i < mealList.length; i++) {
              if (mealList[i].id == state.mealId) {
                mealList[i].recipe!.id = state.similarMealData!.id;
                mealList[i].calories = state.similarMealData!.nutrientsPerServing!.calories;
                mealList[i].meal = '';
                mealList[i].numOfServings = state.similarMealData!.serving;
                mealList[i].recipe!.mainImage = state.similarMealData!.mainImage;
                break;
              }
            }
          }
          if (state is JournalBarcodeScannerState) {
            log(state.barcode!, name: 'BarCode - - - - - - - - - - - - - - - - - - - - - - - - ');
            controller.text = state.barcode ?? '';
          }

          if (state is JournalBarcodeScannerSuccessState) {
            barcodeScannerData = state.barcodeScannerData;
          }
        },
        builder: (BuildContext context, JournalMealPlanState state) {
          return SafeArea(
              child: SizedBox(
            height: size.height.h,
            width: size.width.w,
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
                        Navigator.pop(context);
                      },
                      child: const SvgImage(
                        image: AssetsUtils.icBack,
                        color: AppColors.darkGray,
                      ),
                    ),
                    Text(journalMealScreenArguments!.mealType!.capitalize ?? '', style: FontUtils.h20(fontColor: AppColors.oxFF010101)),
                    SizedBox(height: 20.h, width: 20.w)
                  ],
                ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    height: 48.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: boxShadowWidget,
                    ),
                    child: Row(
                      children: [
                        const SvgImage(
                          image: AssetsUtils.icSearch,
                        ).marginOnly(left: 15),
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            readOnly: true,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            onChanged: (value) {
                              // onChange(value);
                            },
                            onTap: () {
                              // Get.toNamed('/JournalSearchScreen');
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return JournalSearchScreen(
                                  journalMealScreenArguments: journalMealScreenArguments!,
                                );
                              }));
                            },
                            decoration: InputDecoration(
                              filled: false,
                              isDense: true,
                              hintText: "Search for Item",
                              hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: AppColors.middleGray),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: InkWell(
                            onTap: () {
                              // onClear();
                              Get.toNamed(
                                "/ScanBarcodeScreen",
                                arguments: ScanBarcodeArguments(journalPlanBloc: journalPlanBloc),
                              );
                            },
                            child: const SvgImage(
                              image: AssetsUtils.icBarcode,
                            ).marginOnly(right: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                    child: Text(
                      StringUtils.basedMeal,
                      style: FontUtils.h16(fontColor: AppColors.middleGray),
                    ),
                  ),
                ),
                Expanded(
                  child: 
                  // state is JournalBarcodeScannerLoadingState
                  //     ? const AppCenterLoader()
                  //     : barcodeScannerData == null
                  //         ? const Text('No Data Found!')
                  //         : mealPlanCard(
                  //                       onTap: () {
                  //                         // Get.toNamed('/MealDetailsScreen', arguments: MealPlanArguments(mealData: barcodeScannerData.metadata, currentSelectedData: journalMealScreenArguments!.dateTime));
                  //                       },
                  //                       mealData: MealData(
                  //                       calories: barcodeScannerData!.nfCalories.toDouble(),
                  //                       meal: barcodeScannerData!.brandName,
                  //                       numOfServings: barcodeScannerData
                  //                       ),
                  //                       context: context,
                  //                       onSkipMealTap: () {
                  //                         showModalBottomSheet(
                  //                           context: context,
                  //                           builder: (context) {
                  //                             return JournalSkipMealBottomSheet(
                  //                               bloc: journalPlanBloc,
                  //                               mealData: mealList[index],
                  //                             );
                  //                           },
                  //                           isDismissible: false,
                  //                         );
                  //                       },
                  //                       onSwapMealTap: () {
                  //                         showModalBottomSheet(
                  //                           context: context,
                  //                           builder: (context) {
                  //                             return JournalSwapMealBottomSheet(journalPlanBloc: journalPlanBloc, mealData: mealList[index]);
                  //                           },
                  //                         );
                  //                       },
                  //                     ),),
                          mealList.isEmpty
                              ? state is JournalFetchMealPlanLoadingState
                                  ? const AppCenterLoader()
                                  : const SizedBox()
                              : SingleChildScrollView(
                                  child: ListView.builder(
                                    itemCount: mealList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return mealPlanCard(
                                        onTap: () {
                                          // Get.toNamed('/MealDetailsScreen', arguments: MealPlanArguments(mealData: e.meals![index]));
                                          Get.toNamed('/MealDetailsScreen', arguments: MealPlanArguments(mealData: mealList[index], currentSelectedData: journalMealScreenArguments!.dateTime));
                                        },
                                        mealData: mealList[index],
                                        context: context,
                                        onSkipMealTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return JournalSkipMealBottomSheet(
                                                bloc: journalPlanBloc,
                                                mealData: mealList[index],
                                              );
                                            },
                                            isDismissible: false,
                                          );
                                        },
                                        onSwapMealTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return JournalSwapMealBottomSheet(journalPlanBloc: journalPlanBloc, mealData: mealList[index]);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                ),
                buildButton(
                        context: context,
                        title: StringUtils.addNewItem,
                        hasImage: false,
                        textColor: AppColors.skyBlue,
                        onPressed: () {
                          Get.toNamed(
                            "/AddNewItemScreen",
                          );
                          // bloc.add(SaveClickEvent(
                          //     userId: userId,
                          //     workoutTime: minutesController.text,
                          //     exerciseName: entryController.text,
                          //     caloriesBurned: caloriesBurnedController.text,
                          //     createdBy: ''));
                        },
                        bgColor: AppColors.primaryBlue)
                    .paddingOnly(bottom: 20.h, left: 20.w, right: 20.w)
              ],
            ),
          ));
        },
      ),
    );
  }
}

class JournalMealScreenArguments {
  final List<MealData>? breakFastList;
  final DateTime? dateTime;
  final String? mealType;

  JournalMealScreenArguments({required this.breakFastList, required this.dateTime, this.mealType});
}
