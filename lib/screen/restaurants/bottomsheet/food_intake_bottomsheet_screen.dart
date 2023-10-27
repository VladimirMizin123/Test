import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

import '../../../bloc/journal/get_journal_data/get_user_journal_event.dart';
import '../../../bloc/journal/get_journal_data/get_user_journal_state.dart';

class LogFoodIntakeBottomSheet extends StatefulWidget {
  const LogFoodIntakeBottomSheet(
      {super.key,
      this.nutritionixGetNxMealInfoByNameModelData,
      required this.isMainScreen});
  final NutritionixGetNxMealInfoByNameModelData?
      nutritionixGetNxMealInfoByNameModelData;
  final bool isMainScreen;
  @override
  State<LogFoodIntakeBottomSheet> createState() =>
      _LogFoodIntakeBottomSheetState();
}

class _LogFoodIntakeBottomSheetState extends State<LogFoodIntakeBottomSheet> {
  int selectedIndex = -1;
  List option = ['BreakFast', 'Lunch', 'Snack', 'Dinner'];
  GetUserJournalBloc bloc = GetUserJournalBloc();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) => Material(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 3.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.disable),
                  ),
                ),
                const SizedBox(height: 10),
                SvgPicture.asset(AssetsUtils.icQuestionMarkIcon),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.isMainScreen == true
                        ? 'Tell us what you are looking for?'
                        : 'For which meal will we write down the dish?',
                    style: FontUtils.h20(
                      fontColor: AppColors.darkGray,
                      fontWeight: FWT.medium,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                myWidget(
                    title: 'Breakfast',
                    isSelected: selectedIndex == 0 ? true : false,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    }),
                const SizedBox(height: 10),
                myWidget(
                    title: 'Lunch',
                    isSelected: selectedIndex == 1 ? true : false,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    }),
                const SizedBox(height: 10),
                myWidget(
                    title: 'Snack',
                    isSelected: selectedIndex == 2 ? true : false,
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    }),
                const SizedBox(height: 10),
                myWidget(
                    title: 'Dinner',
                    isSelected: selectedIndex == 3 ? true : false,
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    }),
                const SizedBox(height: 15),
                state is AddItemLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : simpleTextBorderButton(
                        context: context,
                        color: AppColors.terracotta,
                        lableColor: AppColors.terracotta,
                        buttonLable: selectedIndex == -1
                            ? 'Back'
                            : widget.isMainScreen == true
                                ? 'Continue'
                                : 'Log Dish',
                        height: screenSize.height * 0.065,
                        width: screenSize.width,
                        isLoadingWidget: false,
                        onTap: () {
                          if (selectedIndex == -1) {
                            Get.back();
                          } else {
                            if (widget.isMainScreen == true) {
                              Get.back(result: option[selectedIndex]);
                            } else {
                              bloc.add(
                                AddEatenMealData(
                                  value: 1,
                                  mealName: widget
                                          .nutritionixGetNxMealInfoByNameModelData!
                                          .foodName ??
                                      '',
                                  recipeId: widget
                                          .nutritionixGetNxMealInfoByNameModelData!
                                          .nixItemId ??
                                      '',
                                  mealType: option[selectedIndex],
                                  noOfServing: widget
                                          .nutritionixGetNxMealInfoByNameModelData!
                                          .servingQty ??
                                      0,
                                  userId:
                                      PreferenceUtils.getString(prefUserData),
                                  calorie: widget
                                          .nutritionixGetNxMealInfoByNameModelData!
                                          .nfCalories ??
                                      '',
                                  carbs: widget
                                          .nutritionixGetNxMealInfoByNameModelData!
                                          .nfTotalCarbohydrate ??
                                      0,
                                  fat: widget
                                          .nutritionixGetNxMealInfoByNameModelData!
                                          .nfTotalFat ??
                                      0,
                                  protein: widget
                                          .nutritionixGetNxMealInfoByNameModelData!
                                          .nfProtein ??
                                      0,
                                ),
                              );
                            }
                          }
                        },
                        isDarkColor: true,
                        isFillColor: selectedIndex == -1 ? false : true,
                      ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myWidget(
      {bool isSelected = false, VoidCallback? onTap, String? title}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? AppColors.primaryBlue : Colors.transparent),
          color: AppColors.whiteColor,
          boxShadow: boxShadowWidget,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: FontUtils.h16(
                    fontColor: AppColors.darkGray, fontWeight: FWT.medium),
              ),
              Container(
                height: 22.h,
                width: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryBlue, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: isSelected,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBlue),
                        height: 14.h,
                        width: 14.w,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
