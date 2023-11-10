
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_state.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_event.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_item_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_item_details.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_event.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_state.dart';
import 'package:gymeats_mobile/screen/journal/journal_meal_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

class JournalSearchScreen extends StatefulWidget {
  final JournalMealScreenArguments? journalMealScreenArguments;
  final String? isFrom;
  const JournalSearchScreen(
      {super.key, this.journalMealScreenArguments, this.isFrom});

  @override
  State<JournalSearchScreen> createState() => _JournalSearchScreenState();
}

class _JournalSearchScreenState extends State<JournalSearchScreen> {
  TextEditingController searchController = TextEditingController();
  JournalPlanBloc journalPlanBloc = JournalPlanBloc();
  AddNewGroceryItemBloc addNewGroceryItemBloc = AddNewGroceryItemBloc();
  AddNewMealBloc getAddNewMealBloc = AddNewMealBloc();
  List<Cart> groceryMultiSearchModelDataList = [];
  List<MealData> mealList = [];

  List<Map<String, dynamic>> groceryDetails = [];

  bool add = false;
  bool isButtonEnable = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // journalPlanBloc.add(JournalPlanFetchEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<JournalPlanBloc, JournalMealPlanState>(
          bloc: journalPlanBloc,
          listener: (context, state) {
            if (state is JournalSearchSuccessState) {
              groceryMultiSearchModelDataList =
                  state.groceryMultiSearchProductList ?? [];
            }
            if (state is JournalAddToGrocerySuccessState) {
              // MAKE STATUS TRUE AND CHANGE ICON PLUS SIGN TO CHECK SIGN IN THIS LIST - groceryMultiSearchModelDataList
            }
            if (state is JournalFetchMealPlanSuccessState) {
              for (var i = 0; i < state.mealPlanList.length; i++) {
                if (DateTime(
                        state.mealPlanList[i].date!.year,
                        state.mealPlanList[i].date!.month,
                        state.mealPlanList[i].date!.day) ==
                    DateTime(
                        widget.journalMealScreenArguments!.dateTime!.year,
                        widget.journalMealScreenArguments!.dateTime!.month,
                        widget.journalMealScreenArguments!.dateTime!.day)) {
                  mealList = state.mealPlanList[i].meals ?? [];
                  break;
                }
              }
            }

            if (state is JournalAddEatenLoadingState) {
              setState(() {
                for (var i = 0;
                    i < groceryMultiSearchModelDataList.length;
                    i++) {
                  for (var j = 0;
                      j <
                          groceryMultiSearchModelDataList[i]
                              .groceryResult!
                              .length;
                      j++) {
                    for (var k = 0;
                        k <
                            groceryMultiSearchModelDataList[i]
                                .groceryResult![j]
                                .products!
                                .length;
                        k++) {
                      if (groceryMultiSearchModelDataList[i]
                              .groceryResult![j]
                              .products![k]
                              .productId ==
                          state.mealID) {
                        groceryMultiSearchModelDataList[i]
                            .groceryResult![j]
                            .products![k]
                            .isLoading = true;
                      }
                    }
                  }
                }
                // for (var i = 0; i < mealList.length; i++) {
                //   if (mealList[i].id == state.mealID) {
                //     mealList[i].isLoadingAddedForEatenMeal = true;
                //   }
                // }
              });
            }

            if (state is JournalAddEatenSuccessState) {
              setState(() {
                for (var i = 0;
                    i < groceryMultiSearchModelDataList.length;
                    i++) {
                  for (var j = 0;
                      j <
                          groceryMultiSearchModelDataList[i]
                              .groceryResult!
                              .length;
                      j++) {
                    for (var k = 0;
                        k <
                            groceryMultiSearchModelDataList[i]
                                .groceryResult![j]
                                .products!
                                .length;
                        k++) {
                      if (groceryMultiSearchModelDataList[i]
                              .groceryResult![j]
                              .products![k]
                              .productId ==
                          state.mealID) {
                        groceryMultiSearchModelDataList[i]
                            .groceryResult![j]
                            .products![k]
                            .isLoading = false;
                        groceryMultiSearchModelDataList[i]
                            .groceryResult![j]
                            .products![k]
                            .isAddedToShoppingList = true;
                      }
                    }
                  }
                }
                // for (var i = 0; i < mealList.length; i++) {
                //   if (mealList[i].id == state.mealID) {
                //     mealList[i].isLoadingAddedForEatenMeal = false;
                //     mealList[i].isAddedForEatenMeal = true;
                //   }
                // }
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
                      widget.isFrom == 'Grocery'
                          ? const SizedBox()
                          : Text(widget.journalMealScreenArguments!.mealType!,
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
                  SizedBox(height: 15.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: boxShadowWidget,
                      ),
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (String value) {
                          journalPlanBloc.add(JournalSearchEvent(
                            journalSearchModelList: [
                              GrocerySearchModel(
                                  groceryName: searchController.text,
                                  quantity: 0)
                            ],
                          ));
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search for item',
                          hintStyle: FontUtils.h16(),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Expanded(
                    child:

                        // mealList.isEmpty
                        //     ? state is JournalFetchMealPlanLoadingState
                        //         ? const AppCenterLoader()
                        //         : const SizedBox()
                        //     : SingleChildScrollView(
                        //         child: ListView.builder(
                        //           itemCount: mealList.length,
                        //           shrinkWrap: true,
                        //           scrollDirection: Axis.vertical,
                        //           physics: const NeverScrollableScrollPhysics(),
                        //           itemBuilder: (BuildContext context, int index) {
                        //             return Padding(
                        //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        //               child: Container(
                        //                 decoration: BoxDecoration(color: Colors.white, boxShadow: boxShadowWidget, borderRadius: BorderRadius.circular(8)),
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.all(12),
                        //                   child: Row(
                        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                     children: [
                        //                       Column(
                        //                         crossAxisAlignment: CrossAxisAlignment.start,
                        //                         children: [
                        //                           Text(
                        //                             mealList[index].recipe!.name ?? '',
                        //                             style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.medium),
                        //                           ),
                        //                           Row(
                        //                             children: [
                        //                               Text(
                        //                                 '1 slice, Dave’s Killer Bread - ',
                        //                                 style: FontUtils.h12(fontColor: AppColors.middleGray, fontWeight: FWT.medium),
                        //                               ),
                        //                               Text(
                        //                                 '110 cal',
                        //                                 style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.medium),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       mealList[index].isAddedForEatenMeal
                        //                           ? SvgPicture.asset(AssetsUtils.icAddCircle, height: 30)
                        //                           : mealList[index].isLoadingAddedForEatenMeal
                        //                               ? const Center(child: CircularProgressIndicator())
                        //                               : GestureDetector(
                        //                                   onTap: () {
                        //                                     journalPlanBloc.add(JournalAddToEatenEvent(mealID: mealList[index].id!));
                        //                                   },
                        //                                   child: SvgPicture.asset(AssetsUtils.icAddIcon, height: 30)),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             );
                        //             // mealPlanCard(
                        //             //   onTap: () {
                        //             //     // Get.toNamed('/MealDetailsScreen', arguments: MealPlanArguments(mealData: e.meals![index]));
                        //             //     Get.toNamed('/MealDetailsScreen', arguments: MealPlanArguments(mealData: mealList[index], currentSelectedData: widget.journalMealScreenArguments.dateTime));
                        //             //   },
                        //             //   mealData: mealList[index],
                        //             //   context: context,
                        //             //   onSkipMealTap: () {
                        //             //     showModalBottomSheet(
                        //             //       context: context,
                        //             //       builder: (context) {
                        //             //         return JournalSkipMealBottomSheet(
                        //             //           bloc: journalPlanBloc,
                        //             //           mealData: mealList[index],
                        //             //         );
                        //             //       },
                        //             //       isDismissible: false,
                        //             //     );
                        //             //   },
                        //             //   onSwapMealTap: () {
                        //             //     showModalBottomSheet(
                        //             //       context: context,
                        //             //       builder: (context) {
                        //             //         return JournalSwapMealBottomSheet(journalPlanBloc: journalPlanBloc, mealData: mealList[index]);
                        //             //       },
                        //             //     );
                        //             //   },
                        //             // );
                        //           },
                        //         ),
                        //       ),
                        state is JournalSearchLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : BlocConsumer(
                                bloc: addNewGroceryItemBloc,
                                listener: (context, state) {
                                  if (state is LoadingState) {
                                    add = true;
                                  }
                                  if (state is AddGroceryItemSuccessfulState) {
                                    add = false;
                                  }

                                  if (state is ErrorState) {
                                    add = false;
                                  }
                                },
                                builder: (context, state) => BlocConsumer(
                                  bloc: getAddNewMealBloc,
                                  listener: (context, state) {
                                    if (state is AddNewMealLoadingState) {
                                      setState(() {
                                        for (var i = 0;
                                            i <
                                                groceryMultiSearchModelDataList
                                                    .length;
                                            i++) {
                                          for (var j = 0;
                                              j <
                                                  groceryMultiSearchModelDataList[
                                                          i]
                                                      .groceryResult!
                                                      .length;
                                              j++) {
                                            for (var k = 0;
                                                k <
                                                    groceryMultiSearchModelDataList[
                                                            i]
                                                        .groceryResult![j]
                                                        .products!
                                                        .length;
                                                k++) {
                                              print(
                                                  'Condition>>>${groceryMultiSearchModelDataList[i].groceryResult![j].products![k].productId == state.productId}');

                                              if (groceryMultiSearchModelDataList[
                                                          i]
                                                      .groceryResult![j]
                                                      .products![k]
                                                      .productId ==
                                                  state.productId) {
                                                groceryMultiSearchModelDataList[
                                                        i]
                                                    .groceryResult![j]
                                                    .products![k]
                                                    .isLoading = true;
                                              }
                                            }
                                          }
                                        }
                                        // for (var i = 0; i < mealList.length; i++) {
                                        //   if (mealList[i].id == state.mealID) {
                                        //     mealList[i].isLoadingAddedForEatenMeal = true;
                                        //   }
                                        // }
                                      });
                                    }
                                    if (state is AddNewMealSuccessfulState) {
                                      setState(() {
                                        for (var i = 0;
                                            i <
                                                groceryMultiSearchModelDataList
                                                    .length;
                                            i++) {
                                          for (var j = 0;
                                              j <
                                                  groceryMultiSearchModelDataList[
                                                          i]
                                                      .groceryResult!
                                                      .length;
                                              j++) {
                                            for (var k = 0;
                                                k <
                                                    groceryMultiSearchModelDataList[
                                                            i]
                                                        .groceryResult![j]
                                                        .products!
                                                        .length;
                                                k++) {
                                              if (groceryMultiSearchModelDataList[
                                                          i]
                                                      .groceryResult![j]
                                                      .products![k]
                                                      .productId ==
                                                  state.productId) {
                                                groceryMultiSearchModelDataList[
                                                        i]
                                                    .groceryResult![j]
                                                    .products![k]
                                                    .isLoading = false;
                                                groceryMultiSearchModelDataList[
                                                            i]
                                                        .groceryResult![j]
                                                        .products![k]
                                                        .isAddedToShoppingList =
                                                    true;
                                              }
                                            }
                                          }
                                        }
                                        // for (var i = 0; i < mealList.length; i++) {
                                        //   if (mealList[i].id == state.mealID) {
                                        //     mealList[i].isLoadingAddedForEatenMeal = false;
                                        //     mealList[i].isAddedForEatenMeal = true;
                                        //   }
                                        // }
                                      });
                                    }
                                    if (state is AddNewMealErrorState) {
                                      setState(() {
                                        for (var i = 0;
                                            i <
                                                groceryMultiSearchModelDataList
                                                    .length;
                                            i++) {
                                          for (var j = 0;
                                              j <
                                                  groceryMultiSearchModelDataList[
                                                          i]
                                                      .groceryResult!
                                                      .length;
                                              j++) {
                                            for (var k = 0;
                                                k <
                                                    groceryMultiSearchModelDataList[
                                                            i]
                                                        .groceryResult![j]
                                                        .products!
                                                        .length;
                                                k++) {
                                              if (groceryMultiSearchModelDataList[
                                                          i]
                                                      .groceryResult![j]
                                                      .products![k]
                                                      .productId ==
                                                  state.productId) {
                                                groceryMultiSearchModelDataList[
                                                        i]
                                                    .groceryResult![j]
                                                    .products![k]
                                                    .isLoading = false;
                                                groceryMultiSearchModelDataList[
                                                            i]
                                                        .groceryResult![j]
                                                        .products![k]
                                                        .isAddedToShoppingList =
                                                    true;
                                              }
                                            }
                                          }
                                        }
                                        // for (var i = 0; i < mealList.length; i++) {
                                        //   if (mealList[i].id == state.mealID) {
                                        //     mealList[i].isLoadingAddedForEatenMeal = false;
                                        //     mealList[i].isAddedForEatenMeal = true;
                                        //   }
                                        // }
                                      });
                                    }
                                  },
                                  builder: (context, state) => Column(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: ListView.builder(
                                            itemCount:
                                                groceryMultiSearchModelDataList
                                                    .length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return ListView.builder(
                                                itemCount:
                                                    groceryMultiSearchModelDataList[
                                                            i]
                                                        .groceryResult!
                                                        .length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, ind) {
                                                  return ListView.builder(
                                                    itemCount:
                                                        groceryMultiSearchModelDataList[
                                                                i]
                                                            .groceryResult![ind]
                                                            .products!
                                                            .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12,
                                                                vertical: 6),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (widget.isFrom ==
                                                                'Journal') {
                                                              Get.toNamed(
                                                                '/GroceryItemDetails',
                                                                arguments: GroceryItemDetailsArguments(
                                                                    productName: groceryMultiSearchModelDataList[
                                                                            i]
                                                                        .groceryResult![
                                                                            ind]
                                                                        .products![
                                                                            index]
                                                                        .itemName,
                                                                    isFromJournalScreen:
                                                                        true,
                                                                    type: widget
                                                                        .journalMealScreenArguments!
                                                                        .mealType!),
                                                              );
                                                            } else {
                                                              Get.toNamed(
                                                                '/GroceryItemDetails',
                                                                arguments:
                                                                    GroceryItemDetailsArguments(
                                                                  isFromGroceryScreen:
                                                                      true,
                                                                  productName: groceryMultiSearchModelDataList[
                                                                          i]
                                                                      .groceryResult![
                                                                          ind]
                                                                      .products![
                                                                          index]
                                                                      .itemName,
                                                                  groceryDetails: {
                                                                    "itemName": groceryMultiSearchModelDataList[
                                                                            i]
                                                                        .groceryResult![
                                                                            ind]
                                                                        .products![
                                                                            index]
                                                                        .itemName
                                                                        .toString(),
                                                                    "quantity":
                                                                        1,
                                                                    "measurementType": groceryMultiSearchModelDataList[
                                                                            i]
                                                                        .groceryResult![
                                                                            ind]
                                                                        .products![
                                                                            index]
                                                                        .unitOfMeasurement
                                                                        .toString(),
                                                                    "measurementValue": groceryMultiSearchModelDataList[
                                                                            i]
                                                                        .groceryResult![
                                                                            ind]
                                                                        .products![
                                                                            index]
                                                                        .unitSize
                                                                        .toString()
                                                                  },
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow:
                                                                    boxShadowWidget,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(12),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            270.w,
                                                                        child:
                                                                            Text(
                                                                          groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].itemName ??
                                                                              '',
                                                                          style: FontUtils.h16(
                                                                              fontColor: AppColors.black,
                                                                              fontWeight: FWT.medium),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            '1 slice, Dave’s Killer Bread - ',
                                                                            style:
                                                                                FontUtils.h12(fontColor: AppColors.middleGray, fontWeight: FWT.medium),
                                                                          ),
                                                                          Text(
                                                                            '110 cal',
                                                                            style:
                                                                                FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.medium),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  groceryMultiSearchModelDataList[i]
                                                                          .groceryResult![
                                                                              ind]
                                                                          .products![
                                                                              index]
                                                                          .isAddedToShoppingList
                                                                      ? SvgPicture.asset(
                                                                          AssetsUtils
                                                                              .icAddCircle,
                                                                          height:
                                                                              30)
                                                                      : groceryMultiSearchModelDataList[i]
                                                                              .groceryResult![ind]
                                                                              .products![index]
                                                                              .isLoading
                                                                          ? const Center(child: CircularProgressIndicator())
                                                                          : GestureDetector(
                                                                              onTap: () {
                                                                                if (widget.isFrom == 'Journal') {
                                                                                  getAddNewMealBloc.add(
                                                                                    AddNewMeal(
                                                                                      name: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].itemName ?? '',
                                                                                      protein: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].protein ?? '0',
                                                                                      fat: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].fat ?? '0',
                                                                                      carbs: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].carbs ?? '0',
                                                                                      calorie: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].calorie ?? '0',
                                                                                      type: widget.journalMealScreenArguments!.mealType.toString().removeAllWhitespace ?? '',
                                                                                      userId: userId.toString(),
                                                                                      quantity: '1',
                                                                                      id: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].productId,
                                                                                    ),
                                                                                  );

                                                                                  // journalPlanBloc.add(
                                                                                  //   JournalAddToEatenEvent(
                                                                                  //     mealId: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].productId!,
                                                                                  //     calorie: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].calorie,
                                                                                  //     carbs: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].carbs,
                                                                                  //     fat: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].fat,
                                                                                  //     protein: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].protein,
                                                                                  //     mealType: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].mealType,
                                                                                  //     noOfServing: 1,
                                                                                  //     recipeId: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].productId!,
                                                                                  //     mealName: groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].itemName,
                                                                                  //   ),
                                                                                  // );
                                                                                } else {
                                                                                  if (groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].isAddedToShoppingList == false) {
                                                                                    groceryDetails.add({
                                                                                      "itemName": groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].itemName.toString(),
                                                                                      "quantity": 1,
                                                                                      "measurementType": groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].unitOfMeasurement.toString(),
                                                                                      "measurementValue": groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].unitSize.toString()
                                                                                    });
                                                                                    groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].isAddedToShoppingList = true;
                                                                                    isButtonEnable = true;
                                                                                  }

                                                                                  setState(() {});
                                                                                }
                                                                              },
                                                                              child: SvgPicture.asset(AssetsUtils.icAddIcon, height: 30)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      widget.isFrom == 'Grocery'
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              child: add == true
                                                  ? const CircularProgressIndicator()
                                                      .paddingOnly(
                                                          bottom: 30.h,
                                                          top: 10.h)
                                                  : buildButton(
                                                      context: context,
                                                      bgColor: isButtonEnable
                                                          ? AppColors
                                                              .primaryBlue
                                                          : AppColors.disable,
                                                      hasImage: false,
                                                      onPressed: () {
                                                        // ADD NEW ITEM API,
                                                        addNewGroceryItemBloc
                                                            .add(
                                                          AddNewGroceryItem(
                                                            userId: userId,
                                                            groceryItems:
                                                                groceryDetails,
                                                          ),
                                                        );
                                                      },
                                                      textColor: Colors.white,
                                                      title:
                                                          StringUtils.addItem,
                                                    ).paddingOnly(
                                                      bottom: 30.h, top: 10.h),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
