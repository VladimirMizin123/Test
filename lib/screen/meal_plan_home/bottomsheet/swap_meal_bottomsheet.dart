import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';
import 'package:gymeats_mobile/screen/widget/swap_meal_card_widget.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class SwapMealBottomSheet extends StatefulWidget {
  final MealPlanBloc mealPlanBloc;
  final MealData? mealData;
  final int? day;
  const SwapMealBottomSheet({super.key, required this.mealPlanBloc, this.mealData, this.day});

  @override
  State<SwapMealBottomSheet> createState() => _SwapMealBottomSheetState();
}

class _SwapMealBottomSheetState extends State<SwapMealBottomSheet> {
  bool selectedIndex = false;
  List<SimilarMealData> similarMealDataList = [];

  @override
  void initState() {
    super.initState();
    widget.mealPlanBloc.add(FetchSwapMealItemEvent(recipeID: widget.mealData!.recipe!.id, serving: widget.mealData!.numOfServings));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer<MealPlanBloc, FetchMealPlanState>(
        bloc: widget.mealPlanBloc,
        listener: (context, state) {
          if (state is FetchSwapMealLoadingState) {}

          if (state is FetchSwapMealSuccessState) {
            similarMealDataList = state.similarMealData ?? [];
          }
        },
        builder: (context, state) {
          return Material(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.disable),
                      )),
                  const SizedBox(height: 15),
                  Text(
                    StringUtils.swapMeal,
                    style: FontUtils.h22(fontColor: AppColors.darkGray, fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: state is FetchSwapMealLoadingState
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
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12),
                                          child: SwapMealCardWidget(
                                            context: context,
                                            similarMealData: similarMealDataList[index],
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = true;
                                                for (var i = 0; i < similarMealDataList.length; i++) {
                                                  print('$i');
                                                  print('${i == index}');
                                                  print('- - - - - - - - - - - - - - - ');
                                                  if (i == index) {
                                                    similarMealDataList[index].isSelectedForSwap = true;
                                                  } else {
                                                    similarMealDataList[index].isSelectedForSwap = false;
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : const SizedBox(),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: simpleTextBorderButton(
                          context: context,
                          buttonLable: selectedIndex ? 'Confirm New Meal' : StringUtils.back,
                          height: screenSize.height * 0.055,
                          width: screenSize.width * 0.85,
                          isFillColor: selectedIndex,
                          onTap: () {
                            if (!selectedIndex) {
                              Get.back();
                            } else {
                              for (var i = 0; i < similarMealDataList.length; i++) {
                                if (similarMealDataList[i].isSelectedForSwap) {
                                  print('SHARE....');
                                  widget.mealPlanBloc.add(SwapMealDetailsEvent(similarMealData: similarMealDataList[i], day: widget.day, mealId: widget.mealData!.id!));
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
