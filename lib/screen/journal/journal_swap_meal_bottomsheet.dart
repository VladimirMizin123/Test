import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_event.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_state.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';
import 'package:gymeats_mobile/screen/widget/swap_meal_card_widget.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class JournalSwapMealBottomSheet extends StatefulWidget {
  final JournalPlanBloc journalPlanBloc;
  final MealData? mealData;
  final int? day;
  const JournalSwapMealBottomSheet(
      {super.key, required this.journalPlanBloc, this.mealData, this.day});

  @override
  State<JournalSwapMealBottomSheet> createState() =>
      _JournalSwapMealBottomSheetState();
}

class _JournalSwapMealBottomSheetState
    extends State<JournalSwapMealBottomSheet> {
  bool isSelectAnyOneMeal = false;
  List<SimilarMealData> similarMealDataList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.journalPlanBloc.add(JournalFetchSwapMealItemEvent(
        recipeID: widget.mealData!.recipe!.id,
        noOfServing: widget.mealData!.numOfServings));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer<JournalPlanBloc, JournalMealPlanState>(
        bloc: widget.journalPlanBloc,
        listener: (context, state) {
          if (state is JournalFetchSwapMealLoadingState) {}

          if (state is JournalFetchSwapMealSuccessState) {
            similarMealDataList = state.similarMealData ?? [];
          }
        },
        builder: (context, state) {
          return Material(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 3.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.disable),
                      )),
                  const SizedBox(height: 15),
                  Text(
                    StringUtils.swapMeal,
                    style: FontUtils.h22(
                        fontColor: AppColors.darkGray, fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: state is JournalFetchSwapMealLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ))
                        : similarMealDataList.isNotEmpty
                            ? SingleChildScrollView(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ListView.builder(
                                      itemCount: similarMealDataList.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 12),
                                          child: SwapMealCardWidget(
                                            context: context,
                                            similarMealData:
                                                similarMealDataList[index],
                                            onTap: () {
                                              isSelectAnyOneMeal = true;
                                              setState(() {
                                                for (var i = 0;
                                                    i <
                                                        similarMealDataList
                                                            .length;
                                                    i++) {
                                                  if (i == index) {
                                                    similarMealDataList[i]
                                                            .isSelectedForSwap =
                                                        true;
                                                  } else {
                                                    similarMealDataList[i]
                                                            .isSelectedForSwap =
                                                        false;
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : const Center(
                                child: Text(
                                "No results found",
                                style: TextStyle(color: AppColors.black),
                              )),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: isLoading
                          ? const AppCenterLoader()
                          : simpleTextBorderButton(
                              context: context,
                              buttonLable: isSelectAnyOneMeal
                                  ? 'Confirm New Meal'
                                  : StringUtils.back,
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.85,
                              isFillColor: isSelectAnyOneMeal,
                              onTap: () {
                                if (!isSelectAnyOneMeal) {
                                  Get.back();
                                } else {
                                  for (var i = 0;
                                      i < similarMealDataList.length;
                                      i++) {
                                    if (similarMealDataList[i]
                                        .isSelectedForSwap!) {
                                      isLoading = true;
                                      setState(() {});
                                      widget.journalPlanBloc.add(
                                        JournalSwapMealDetailsEvent(
                                            similarMealData:
                                                similarMealDataList[i],
                                            day: widget.day,
                                            mealId: widget.mealData!.id!,
                                            onComplete: () {
                                              isLoading = false;
                                              setState(() {});
                                              MealPlanBloc()
                                                  .add(MealPlanFetchEvent());
                                            }),
                                      );
                                      break;
                                    }
                                  }
                                }
                              },
                              isDarkColor: true)),
                ],
              ),
            ),
          );
        });
  }
}
