import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

// meal_plan branch code
class FoodPreferencesScreen extends StatefulWidget {
  const FoodPreferencesScreen({super.key});

  @override
  State<FoodPreferencesScreen> createState() => _FoodPreferencesScreenState();
}

class _FoodPreferencesScreenState extends State<FoodPreferencesScreen> {
  MealPlanBloc mealPlanBloc = MealPlanBloc();
  List<Edge> edgesRestrictionList = [];
  List<String> restrictionIdList = [];

  @override
  void initState() {
    super.initState();
    mealPlanBloc.add(GetAllRestrictionEvent());
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<MealPlanBloc, FetchMealPlanState>(
          bloc: mealPlanBloc,
          listener: (context, state) {
            if (state is GetAllRestrictionLoadingState) {}

            if (state is GetAllRestrictionSuccessState) {
              edgesRestrictionList = state.edgesRestrictionList ?? [];
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 4.h),
                          Image.asset(
                            AssetsUtils.gymEatsLogo,
                            height: 20.h,
                            width: 56.w,
                            color: AppColors.primaryBlue,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3.w, bottom: 12.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(Icons.arrow_back_ios_new_rounded)),
                                Text(StringUtils.foodPreferences, style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.bold)),
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
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Tell us if you want to avoid some food.',
                              style: FontUtils.h14(fontColor: AppColors.middleGray, fontWeight: FWT.medium),
                            ),
                          ),
                          Expanded(
                            child: state is GetAllRestrictionLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : edgesRestrictionList.isEmpty
                                    ? const Center(child: Text('No Data Found!'))
                                    : SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: ListView.builder(
                                          itemCount: edgesRestrictionList.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return myWidget(
                                              edgesRestrictionList[index].node.name,
                                              edgesRestrictionList[index].node.isRestricted ?? false,
                                              (bool vale) {
                                                setState(() {
                                                  if (edgesRestrictionList[index].node.isRestricted == true) {
                                                    edgesRestrictionList[index].node.isRestricted = false;
                                                    restrictionIdList.removeWhere((element) => element == edgesRestrictionList[index].node.id);
                                                  } else {
                                                    edgesRestrictionList[index].node.isRestricted = true;

                                                    restrictionIdList.add(edgesRestrictionList[index].node.id);
                                                  }
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                          ),
                          // myWidget('Avoid fish', false),
                          // myWidget('Add more sweets', true),
                          // myWidget('Add more seafood', true),
                          // myWidget('Avoid pork', false),
                          // myWidget('Avoid nuts', false),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    simpleTextBorderButton(
                      context: context,
                      buttonLable: 'Save',
                      height: screenSize.height * 0.065,
                      width: screenSize.width,
                      onTap: () {
                        mealPlanBloc.add(AddUserRestrictionEvent(edgeRestrictionList: restrictionIdList));
                      },
                      isDarkColor: true,
                      isFillColor: true,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget myWidget(
    String title,
    bool value,
    Function(bool)? onChange,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          CupertinoSwitch(value: value, onChanged: onChange, activeColor: AppColors.switchColor),
        ],
      ),
    );
  }
}
