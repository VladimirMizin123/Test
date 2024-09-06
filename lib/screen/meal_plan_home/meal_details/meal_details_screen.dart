import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/functions.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/arguments/meal_plan_arguments_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/best_match_restaurants/best_match_restaurants_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/add_items_shopping_list_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/fatch_meal_details_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MealDetailsScreen extends StatefulWidget {
  final MealPlanArguments? mealDataArguments;
  const MealDetailsScreen({super.key, this.mealDataArguments});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  int selectedIndex = 0;
  MealPlanBloc mealPlanBloc = MealPlanBloc();
  AddNewGroceryItemBloc addNewGroceryItemBloc = AddNewGroceryItemBloc();
  bool addItem = false;
  bool isAddButtonEnable = false;
  FetchModelData? fetchModelData;

  List<GrocerySearchModel> grocerySearchList = [];
  JournalPlanBloc journalPlanBloc = JournalPlanBloc();
  List<Cart> searchCartList = [];
  bool isCircularLoading = false;
  bool addData = false;
  BarcodeScannerData? barcodeScannerData;
  NutritionixGetNxMealInfoByNameModelData?
      nutritionixGetNxMealInfoByNameModelData;

  MealDataByDate? mealDataByDate;
  bool isLoading = false;
  bool isMealPlanLoading = false;

  @override
  void initState() {
    super.initState();
    mealPlanBloc.add(GetMealLogByDateEvent(
        date: widget.mealDataArguments?.currentSelectedData != null
            ? dateTimeYYYYMMDD(
                dateTimeVal:
                    widget.mealDataArguments!.currentSelectedData.toString())
            : "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"));

    log(widget.mealDataArguments!.productName.toString(),
        name: "mealDataArguments");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.mealDataArguments!.isFromScanner == true) {
        mealPlanBloc.add(BarcodeScanEvent(
            barcode: widget.mealDataArguments!.barcodeNumber!));
      } else {
        log(widget.mealDataArguments?.mealData?.recipe?.id ?? "null".toString(),
            name: "RECIPE ID");
        log(
            widget.mealDataArguments?.mealData?.recipe?.name ??
                "null".toString(),
            name: "RECIPE NAME");

        mealPlanBloc.add(FetchMealDetailsEvent(
            recipeID: widget.mealDataArguments!.mealData?.recipe?.id,
            recipeName: widget.mealDataArguments?.mealData?.recipe?.name));
      }
    });
  }

  double convertFractionToFloat(String fraction) {
    // Split the fraction string into two parts, the numerator and the denominator.
    List<String> parts = fraction.split('/');

    // Convert the numerator and denominator to floats.
    num numerator = num.parse(parts[0]);
    num denominator = num.parse(parts[1]);

    // Divide the numerator by the denominator and return the result.
    return numerator / denominator;
  }

  @override
  Widget build(BuildContext context) {
    // final weightValue = widget.mealDataArguments?.weightValue;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<MealPlanBloc, FetchMealPlanState>(
          bloc: mealPlanBloc,
          listener: (context, state) {
            if (state is MealDetailsLoadingState) {
              isMealPlanLoading = state.isLoading;
            }
            if (state is MealDetailsSuccessState) {
              fetchModelData = state.fetchModelData;
            }

            if (state is GrocerySearchLoadingState) {
              isCircularLoading = true;
            }

            if (state is GrocerySearchSuccessState) {
              searchCartList = state.groceryMultiSearchProductList ?? [];

              List<AddItemsToShoppingListModal> addItemsList = [];
              // isCircularLoading = false;

              for (var i = 0; i < searchCartList.length; i++) {
                for (var j = 0;
                    j < searchCartList[i].groceryResult!.length;
                    j++) {
                  for (var k = 0;
                      k < searchCartList[i].groceryResult![j].products!.length;
                      k++) {
                    addItemsList.add(
                      AddItemsToShoppingListModal(
                        productId: searchCartList[i]
                            .groceryResult![j]
                            .products![k]
                            .productId!,
                        price: searchCartList[i]
                            .groceryResult![j]
                            .products![k]
                            .price!,
                        unitOfMeasurement: searchCartList[i]
                                    .groceryResult![j]
                                    .products![k]
                                    .unitOfMeasurement ==
                                null
                            ? ''
                            : searchCartList[i]
                                .groceryResult![j]
                                .products![k]
                                .unitOfMeasurement!,
                        unitSize: searchCartList[i]
                            .groceryResult![j]
                            .products![k]
                            .unitSize!
                            .toInt(),
                        productName: searchCartList[i]
                                .groceryResult![j]
                                .products![k]
                                .itemName ??
                            '',
                        quantity: 1,
                        isChecked: true,
                        recipeId: fetchModelData!.recipe!.id!,
                        mealmeStoreId: '',
                      ),
                    );
                  }
                }
              }
              mealPlanBloc
                  .add(AddToGroceryListEvent(addItemsList: addItemsList));
            }

            if (state is AddToGrocerySuccessState) {
              isCircularLoading = false;
            }

            if (state is BarcodeScannerSuccessState) {
              barcodeScannerData = state.barcodeScannerData;
              mealPlanBloc.add(FetchMealDetailsByNameEvent(
                  recipeName: barcodeScannerData!.foodName));
            }

            if (state is NutritionixGetNxMealInfoByNameSuccessState) {
              nutritionixGetNxMealInfoByNameModelData =
                  state.nutritionixGetNxMealInfoByNameModelData;
            }

            if (state is OnGetMealLogByDateLoadingState) {
              isLoading = state.value;
            }
            if (state is SkipMealPlanLoadingState) {
              isLoading = state.value;
            }

            if (state is RemoveMealPlanLoadingState) {
              isLoading = state.value;
            }

            if (state is OnGetMealLogByDateSuccessState) {
              mealDataByDate = state.modelData!.firstWhereOrNull(
                (element) =>
                    element.mealId == widget.mealDataArguments!.mealData!.id,
              );
            }
            if (state is SkipMealPlanSuccessState ||
                state is OnRemoveMealLogSuccessState) {
              // Get Meal Log
              mealPlanBloc.add(GetMealLogByDateEvent(
                  date: widget.mealDataArguments?.currentSelectedData != null
                      ? dateTimeYYYYMMDD(
                          dateTimeVal: widget
                              .mealDataArguments!.currentSelectedData
                              .toString())
                      : "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"));
            }
          },
          builder: (context, state) {
            num weight = fetchModelData?.recipe?.servingWeight ?? 0;
            num servingGram = num.tryParse(
                    nutritionixGetNxMealInfoByNameModelData
                            ?.servingWeightGrams ??
                        "") ??
                0;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SafeArea(
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
                              child:
                                  const Icon(Icons.arrow_back_ios_new_rounded)),
                          Text(StringUtils.planMealDetails,
                              style: FontUtils.h20(
                                  fontColor: AppColors.oxFF010101,
                                  fontWeight: FWT.bold)),
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
                    Expanded(
                      child: widget.mealDataArguments!.isFromScanner == true
                          ? state is BarcodeScannerLoadingState
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : state is BarcodeScannerErrorState
                                  ? const Center(
                                      child: Text(
                                        'No Data Found!\nPlease check barcode!',
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : state
                                          is NutritionixGetNxMealInfoByNameLoadingState
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : nutritionixGetNxMealInfoByNameModelData ==
                                              null
                                          ? const SizedBox()
                                          : SingleChildScrollView(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      nutritionixGetNxMealInfoByNameModelData!
                                                              .foodName ??
                                                          '',
                                                      style: FontUtils.h18(
                                                          fontColor:
                                                              AppColors.black,
                                                          fontWeight:
                                                              FWT.medium),
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '${nutritionixGetNxMealInfoByNameModelData!.servingUnit} serving${servingGram > 0 ? ", ${nutritionixGetNxMealInfoByNameModelData!.servingWeightGrams}g" : ""}',
                                                        style: FontUtils.h14(
                                                            fontColor: AppColors
                                                                .middleGray,
                                                            fontWeight: FWT
                                                                .lightMedium),
                                                      )),
                                                  SizedBox(height: 12.h),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          nutritionixGetNxMealInfoByNameModelData!
                                                              .photo!.thumb!),
                                                      // image: const AssetImage('assets/image/defaultImage.png'),
                                                      height:
                                                          screenSize.height *
                                                              0.25,
                                                      width: screenSize.width,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),

                                                  /// UnComment this when you get the response of below data...
                                                  // SizedBox(height: 12.h),
                                                  // Row(
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 1,
                                                  //       child: tabView(
                                                  //           title: 'Ingredients',
                                                  //           isSelected: selectedIndex == 0 ? true : false,
                                                  //           onTap: () {
                                                  //             setState(() {
                                                  //               selectedIndex = 0;
                                                  //             });
                                                  //           }),
                                                  //     ),
                                                  //     Expanded(
                                                  //       flex: 1,
                                                  //       child: tabView(
                                                  //           title: 'Info',
                                                  //           isSelected: selectedIndex == 1 ? true : false,
                                                  //           onTap: () {
                                                  //             setState(() {
                                                  //               selectedIndex = 1;
                                                  //             });
                                                  //           }),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // const SizedBox(height: 10),
                                                  // selectedIndex == 0
                                                  //     ? Column(
                                                  //         children: [
                                                  //           ListView.builder(
                                                  //             itemCount: fetchModelData!.recipe!.ingredients!.length,
                                                  //             shrinkWrap: true,
                                                  //             physics: const NeverScrollableScrollPhysics(),
                                                  //             itemBuilder: (context, index) {
                                                  //               return Padding(
                                                  //                 padding: const EdgeInsets.only(top: 10),
                                                  //                 child: Row(
                                                  //                   children: [
                                                  //                     const CircleAvatar(
                                                  //                       maxRadius: 5,
                                                  //                       backgroundColor: AppColors.mint,
                                                  //                     ),
                                                  //                     const SizedBox(width: 20),
                                                  //                     Text(fetchModelData!.recipe!.ingredients![index].name ?? '', style: FontUtils.h14(fontWeight: FWT.regular)),
                                                  //                     const Spacer(),
                                                  //                     Transform.scale(
                                                  //                       scale: 1.2,
                                                  //                       child: Checkbox(
                                                  //                         value: fetchModelData!.recipe!.ingredients![index].isSelected,
                                                  //                         onChanged: (bool? value) {
                                                  //                           setState(() {
                                                  //                             fetchModelData!.recipe!.ingredients![index].isSelected = !fetchModelData!.recipe!.ingredients![index].isSelected;

                                                  //                             if (value == false) {
                                                  //                               grocerySearchList.removeWhere((element) => element.groceryName == fetchModelData!.recipe!.ingredients![index].name);
                                                  //                             } else {
                                                  //                               grocerySearchList.add(GrocerySearchModel(groceryName: fetchModelData!.recipe!.ingredients![index].name, quantity: 1));
                                                  //                             }

                                                  //                             for (var i = 0; i < fetchModelData!.recipe!.ingredients!.length; i++) {
                                                  //                               if (fetchModelData!.recipe!.ingredients![i].isSelected) {
                                                  //                                 isAddButtonEnable = true;
                                                  //                                 break;
                                                  //                               } else {
                                                  //                                 isAddButtonEnable = false;
                                                  //                               }
                                                  //                             }
                                                  //                           });
                                                  //                         },
                                                  //                         activeColor: AppColors.appColor,
                                                  //                       ),
                                                  //                     )
                                                  //                   ],
                                                  //                 ),
                                                  //               );
                                                  //             },
                                                  //           )
                                                  //         ],
                                                  //       )
                                                  //     : Column(children: [
                                                  //         GridView(
                                                  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2, crossAxisSpacing: 6.w, mainAxisSpacing: 6.h),
                                                  //           shrinkWrap: true,
                                                  //           physics: const NeverScrollableScrollPhysics(),
                                                  //           children: [
                                                  //             myProgressBarCardView('Cal', double.parse(fetchModelData!.recipe!.nutrientsPerServing!.calories!.toString()), double.parse(PreferenceUtils.getString(totalCalorie)).floor().toDouble(), AppColors.primaryBlue),
                                                  //             myProgressBarCardView('Fat', double.parse(fetchModelData!.recipe!.nutrientsPerServing!.fat!.toString()), double.parse(PreferenceUtils.getString(totalFat)).floor().toDouble(), AppColors.coral),
                                                  //             myProgressBarCardView('Carbs', double.parse(fetchModelData!.recipe!.nutrientsPerServing!.carbs!.toString()), double.parse(PreferenceUtils.getString(totalCarbs)).floor().toDouble(), AppColors.mint),
                                                  //             myProgressBarCardView('Protein', double.parse(fetchModelData!.recipe!.nutrientsPerServing!.protein!.toString()), double.parse(PreferenceUtils.getString(totalProtein)).floor().toDouble(), AppColors.skyBlue),
                                                  //           ],
                                                  //         ),
                                                  //         const SizedBox(height: 10),
                                                  //         Align(alignment: Alignment.centerLeft, child: Text('Nutritional Information', style: FontUtils.h24(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold))),
                                                  //         const SizedBox(height: 10),
                                                  //         Row(
                                                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //           children: [
                                                  //             Text('Calories', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //             Text('${fetchModelData!.recipe!.nutritionalInfo!.calories}g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //           ],
                                                  //         ),
                                                  //         const SizedBox(height: 10),
                                                  //         Divider(color: AppColors.disabledColor, height: 2.h),
                                                  //         const SizedBox(height: 10),
                                                  //         Row(
                                                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //           children: [
                                                  //             Text('Protein', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //             Text('${fetchModelData!.recipe!.nutritionalInfo!.protein}g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //           ],
                                                  //         ),
                                                  //         const SizedBox(height: 10),
                                                  //         Divider(color: AppColors.disabledColor, height: 2.h),
                                                  //         const SizedBox(height: 10),
                                                  //         Row(
                                                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //           children: [
                                                  //             Text('Carbs', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //             Text('${fetchModelData!.recipe!.nutritionalInfo!.carbs}g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //           ],
                                                  //         ),
                                                  //         const SizedBox(height: 10),
                                                  //         Divider(color: AppColors.disabledColor, height: 2.h),
                                                  //         const SizedBox(height: 10),
                                                  //         Row(
                                                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //           children: [
                                                  //             Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //             Text('${fetchModelData!.recipe!.nutritionalInfo!.fat}g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //           ],
                                                  //         ),
                                                  //         const SizedBox(height: 10),
                                                  //         Divider(color: AppColors.disabledColor, height: 2.h),

                                                  //         // Row(
                                                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //         //   children: [
                                                  //         //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //   ],
                                                  //         // ),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Row(
                                                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //         //   children: [
                                                  //         //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //   ],
                                                  //         // ),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Divider(color: AppColors.disabledColor, height: 2.h),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Row(
                                                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //         //   children: [
                                                  //         //     Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //         //     Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //         //   ],
                                                  //         // ),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Row(
                                                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //         //   children: [
                                                  //         //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //   ],
                                                  //         // ),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Row(
                                                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //         //   children: [
                                                  //         //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //   ],
                                                  //         // ),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Divider(color: AppColors.disabledColor, height: 2.h),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Row(
                                                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //         //   children: [
                                                  //         //     Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //         //     Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                                                  //         //   ],
                                                  //         // ),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Row(
                                                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //         //   children: [
                                                  //         //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //   ],
                                                  //         // ),
                                                  //         // const SizedBox(height: 10),
                                                  //         // Row(
                                                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //         //   children: [
                                                  //         //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                  //         //   ],
                                                  //         // ),
                                                  //       ]),
                                                  // const SizedBox(height: 15),
                                                  // GestureDetector(
                                                  //   onTap: () {
                                                  //     if (isAddButtonEnable) {
                                                  //       mealPlanBloc.add(
                                                  //         GrocerySearchEvent(grocerySearchModelList: grocerySearchList),
                                                  //       );

                                                  //       // bloc.add(GroceryAddToShoppingListEvent(
                                                  //       //   productID: '',
                                                  //       //   productName: widget.mealDataArguments!.mealData!.recipe!.name!,
                                                  //       //   price: '',
                                                  //       //   unitSize: '',
                                                  //       //   unitOfMeasurement: '',
                                                  //       //   quantity: '1',
                                                  //       //   recipeId: '',
                                                  //       //   mealmeStoreId: '',
                                                  //       //   isAdd: true,
                                                  //       //   isRemove: false,
                                                  //       //   isChecked: false,
                                                  //       // ));
                                                  //     } else {
                                                  //       Fluttertoast.showToast(msg: 'Select atleast 1 Ingredients');
                                                  //     }
                                                  //   },
                                                  //   child: Padding(
                                                  //     padding: EdgeInsets.symmetric(vertical: 4.h),
                                                  //     child: Container(
                                                  //       height: screenSize.height * 0.065,
                                                  //       width: screenSize.width,
                                                  //       decoration: isAddButtonEnable ? BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)) : BoxDecoration(color: AppColors.gray, borderRadius: BorderRadius.circular(8)),
                                                  //       child: Center(child: isCircularLoading ? const CircularProgressIndicator(color: AppColors.whiteColor) : Text(StringUtils.addToGroceryList, style: FontUtils.h16(fontColor: AppColors.whiteColor, fontWeight: FWT.semiBold))),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // // simpleTextBorderButton(
                                                  // //   context: context,
                                                  // //   buttonLable: StringUtils.addToGroceryList,
                                                  // //   height: screenSize.height * 0.065,
                                                  // //   width: screenSize.width,
                                                  // //   isLoadingWidget: state is AddToGroceryLoadingState ? true : false,
                                                  // //   onTap: () {
                                                  // //     if (isAddButtonEnable) {
                                                  // //       bloc.add(AddToGroceryListEvent(databaseIdOfRecipes: widget.mealDataArguments!.mealData!.recipe!.databaseId!));
                                                  // //     }
                                                  // //   },
                                                  // //   isDarkColor: isAddButtonEnable,
                                                  // //   isFillColor: isAddButtonEnable,
                                                  // // ),
                                                  // SizedBox(height: 14.h),
                                                  // GestureDetector(
                                                  //   onTap: () {
                                                  //     // Get.toNamed('/BestMatchRestaurantsScreen');
                                                  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  //       return BestMatchRestaurantsScreen(productName: fetchModelData!.recipe!.name!);
                                                  //     }));
                                                  //   },
                                                  //   child: Row(
                                                  //     crossAxisAlignment: CrossAxisAlignment.center,
                                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                                  //     children: [
                                                  //       Flexible(
                                                  //         child: Text(
                                                  //           'Order Best Match from Restaurant',
                                                  //           style: FontUtils.h20(fontColor: AppColors.primaryBlue, fontWeight: FWT.semiBold),
                                                  //         ),
                                                  //       ),
                                                  //       SizedBox(width: 10.w),
                                                  //       const Icon(
                                                  //         Icons.arrow_forward_ios_rounded,
                                                  //         color: AppColors.primaryBlue,
                                                  //         size: 20,
                                                  //       )
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                  // SizedBox(height: 14.h),
                                                  // Align(
                                                  //   alignment: Alignment.centerLeft,
                                                  //   child: Text(
                                                  //     'Recipe',
                                                  //     style: FontUtils.h22(fontColor: AppColors.middleGray, fontWeight: FWT.semiBold),
                                                  //   ),
                                                  // ),
                                                  // SizedBox(height: 7.h),
                                                  // Row(
                                                  //   children: [
                                                  //     Expanded(flex: 1, child: myWidget(imgURL: AssetsUtils.icTimelineIcon, title: '${fetchModelData!.recipe!.totalTime}', onTap: () {})),
                                                  //     const SizedBox(width: 10),
                                                  //     Expanded(flex: 1, child: myWidget(imgURL: AssetsUtils.icServingIcon, title: '${fetchModelData!.recipe!.serving} Servings', onTap: () {})),
                                                  //     const SizedBox(width: 10),
                                                  //     Expanded(flex: 1, child: myWidget(imgURL: AssetsUtils.icIngredientsIcon, title: '${fetchModelData!.recipe!.ingredientsCount} Ingredients', onTap: () {})),
                                                  //   ],
                                                  // ),
                                                  // SizedBox(height: 7.h),
                                                  // ListView.builder(
                                                  //     itemCount: fetchModelData!.recipe!.instructions!.length,
                                                  //     shrinkWrap: true,
                                                  //     physics: const NeverScrollableScrollPhysics(),
                                                  //     itemBuilder: (context, index) {
                                                  //       return Column(
                                                  //         children: [
                                                  //           Padding(
                                                  //             padding: const EdgeInsets.only(top: 10),
                                                  //             child: Row(
                                                  //               crossAxisAlignment: CrossAxisAlignment.start,
                                                  //               children: [
                                                  //                 Container(
                                                  //                   decoration: BoxDecoration(
                                                  //                     border: Border.all(color: AppColors.appColor, width: 2),
                                                  //                     shape: BoxShape.circle,
                                                  //                   ),
                                                  //                   height: 35,
                                                  //                   width: 35,
                                                  //                   child: Center(
                                                  //                     child: Text(
                                                  //                       '${index + 1}',
                                                  //                       style: FontUtils.h16(fontColor: AppColors.appColor, fontWeight: FWT.medium),
                                                  //                     ),
                                                  //                   ),
                                                  //                 ),
                                                  //                 SizedBox(width: 10.w),
                                                  //                 Expanded(
                                                  //                   child: Text(
                                                  //                     fetchModelData!.recipe!.instructions![index],
                                                  //                     style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium),
                                                  //                   ),
                                                  //                 ),
                                                  //               ],
                                                  //             ),
                                                  //           ),
                                                  //           index != fetchModelData!.recipe!.instructions!.length - 1
                                                  //               ? const Divider(
                                                  //                   color: AppColors.disabledColor,
                                                  //                   thickness: 1.2,
                                                  //                 )
                                                  //               : const SizedBox(),
                                                  //         ],
                                                  //       );
                                                  //     }),
                                                  // SizedBox(height: 10.h),
                                                  // Container(
                                                  //   height: screenSize.height * 0.08,
                                                  //   width: screenSize.width * 0.40,
                                                  //   decoration: const BoxDecoration(
                                                  //       color: AppColors.coral,
                                                  //       borderRadius: BorderRadius.only(
                                                  //         bottomLeft: Radius.circular(60),
                                                  //         topLeft: Radius.circular(60),
                                                  //         topRight: Radius.circular(80),
                                                  //         bottomRight: Radius.circular(12),
                                                  //       )),
                                                  //   child: Center(
                                                  //     child: Text(
                                                  //       'Enjoy!',
                                                  //       style: FontUtils.h28(fontColor: AppColors.terracotta, fontWeight: FWT.semiBold),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // SizedBox(height: 20.h),
                                                ],
                                              ),
                                            )
                          : isMealPlanLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : fetchModelData != null
                                  ? SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              fetchModelData!.recipe!.name!,
                                              style: FontUtils.h18(
                                                  fontColor: AppColors.black,
                                                  fontWeight: FWT.medium),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${fetchModelData!.recipe!.serving} serving${weight > 0 ? ", ${weight.toStringAsFixed(2)}g" : ""}',
                                                style: FontUtils.h14(
                                                    fontColor:
                                                        AppColors.middleGray,
                                                    fontWeight:
                                                        FWT.lightMedium),
                                              )),
                                          SizedBox(height: 12.h),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image(
                                              image: NetworkImage(
                                                  fetchModelData!
                                                      .recipe!.mainImage!),
                                              // image: const AssetImage('assets/image/defaultImage.png'),
                                              height: screenSize.height * 0.25,
                                              width: screenSize.width,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 12.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: tabView(
                                                    title: 'Ingredients',
                                                    isSelected:
                                                        selectedIndex == 0
                                                            ? true
                                                            : false,
                                                    onTap: () {
                                                      setState(() {
                                                        selectedIndex = 0;
                                                      });
                                                    }),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: tabView(
                                                    title: 'Info',
                                                    isSelected:
                                                        selectedIndex == 1
                                                            ? true
                                                            : false,
                                                    onTap: () {
                                                      setState(() {
                                                        selectedIndex = 1;
                                                      });
                                                    }),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          selectedIndex == 0
                                              ? Column(
                                                  children: [
                                                    ListView.builder(
                                                      itemCount: fetchModelData!
                                                          .recipe!
                                                          .parsedIngredientLines!
                                                          .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10),
                                                          child: Row(
                                                            children: [
                                                              const CircleAvatar(
                                                                maxRadius: 5,
                                                                backgroundColor:
                                                                    AppColors
                                                                        .mint,
                                                              ),
                                                              const SizedBox(
                                                                  width: 20),
                                                              Expanded(
                                                                child: Text(
                                                                  fetchModelData!
                                                                          .recipe!
                                                                          .parsedIngredientLines![
                                                                              index]
                                                                          .ingredientLine ??
                                                                      '',
                                                                  style: FontUtils.h14(
                                                                      fontWeight:
                                                                          FWT.regular),
                                                                ),
                                                              ),
                                                              Transform.scale(
                                                                scale: 1.2,
                                                                child: Checkbox(
                                                                  value: fetchModelData!
                                                                      .recipe!
                                                                      .parsedIngredientLines![
                                                                          index]
                                                                      .isSelected,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      fetchModelData!
                                                                          .recipe!
                                                                          .parsedIngredientLines![
                                                                              index]
                                                                          .isSelected = !fetchModelData!.recipe!.parsedIngredientLines![index].isSelected;

                                                                      if (value ==
                                                                          false) {
                                                                        grocerySearchList.removeWhere((element) =>
                                                                            element.groceryName ==
                                                                            fetchModelData!.recipe!.parsedIngredientLines![index].ingredient);
                                                                      } else {
                                                                        grocerySearchList.add(GrocerySearchModel(
                                                                            groceryName:
                                                                                fetchModelData!.recipe!.parsedIngredientLines![index].ingredient,
                                                                            quantity: 1));
                                                                      }

                                                                      for (var i =
                                                                              0;
                                                                          i < fetchModelData!.recipe!.parsedIngredientLines!.length;
                                                                          i++) {
                                                                        if (fetchModelData!
                                                                            .recipe!
                                                                            .parsedIngredientLines![i]
                                                                            .isSelected) {
                                                                          isAddButtonEnable =
                                                                              true;
                                                                          break;
                                                                        } else {
                                                                          isAddButtonEnable =
                                                                              false;
                                                                        }
                                                                      }
                                                                    });
                                                                  },
                                                                  activeColor:
                                                                      AppColors
                                                                          .appColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                )
                                              : Column(children: [
                                                  GridView(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            childAspectRatio: 2,
                                                            crossAxisSpacing:
                                                                6.w,
                                                            mainAxisSpacing:
                                                                6.h),
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    children: [
                                                      myProgressBarCardView(
                                                          'Cal',
                                                          double.tryParse(fetchModelData!
                                                                      .recipe!
                                                                      .nutrientsPerServing
                                                                      ?.calories
                                                                      .toString() ??
                                                                  "0.0") ??
                                                              0.0,
                                                          double.tryParse(PreferenceUtils
                                                                      .getString(
                                                                          totalCalorie))
                                                                  ?.floor()
                                                                  .toDouble() ??
                                                              0,
                                                          AppColors.primaryBlue,
                                                          'cal'),
                                                      myProgressBarCardView(
                                                        'Fat',
                                                        double.tryParse(fetchModelData!
                                                                .recipe!
                                                                .nutrientsPerServing!
                                                                .fat!
                                                                .toString()) ??
                                                            0.0,
                                                        double.tryParse(PreferenceUtils
                                                                    .getString(
                                                                        totalFat))
                                                                ?.floor()
                                                                .toDouble() ??
                                                            0.0,
                                                        AppColors.coral,
                                                        "g",
                                                      ),
                                                      myProgressBarCardView(
                                                        'Carbs',
                                                        double.tryParse(fetchModelData!
                                                                .recipe!
                                                                .nutrientsPerServing!
                                                                .carbs!
                                                                .toString()) ??
                                                            0.0,
                                                        double.tryParse(PreferenceUtils
                                                                    .getString(
                                                                        totalCarbs))
                                                                ?.floor()
                                                                .toDouble() ??
                                                            0.0,
                                                        AppColors.mint,
                                                        "g",
                                                      ),
                                                      myProgressBarCardView(
                                                        'Protein',
                                                        double.tryParse(fetchModelData!
                                                                .recipe!
                                                                .nutrientsPerServing!
                                                                .protein!
                                                                .toString()) ??
                                                            0,
                                                        double.tryParse(PreferenceUtils
                                                                    .getString(
                                                                        totalProtein))
                                                                ?.floor()
                                                                .toDouble() ??
                                                            0,
                                                        AppColors.skyBlue,
                                                        "g",
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          'Nutritional Information',
                                                          style: FontUtils.h24(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight: FWT
                                                                  .semiBold))),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Saturated Fat',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                      Text(
                                                          '${(fetchModelData?.recipe?.nutritionalInfo?.nfSaturatedFat ?? 0.00).toStringAsFixed(2)} g',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Divider(
                                                      color: AppColors
                                                          .disabledColor,
                                                      height: 2.h),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Cholesterol',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                      Text(
                                                          '${(fetchModelData?.recipe?.nutritionalInfo?.nfCholesterol ?? 0.00).toStringAsFixed(2)} mg',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Divider(
                                                      color: AppColors
                                                          .disabledColor,
                                                      height: 2.h),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Sodium',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                      Text(
                                                          '${(fetchModelData?.recipe?.nutritionalInfo?.nfSodium ?? 0.00).toStringAsFixed(2)} mg',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Divider(
                                                      color: AppColors
                                                          .disabledColor,
                                                      height: 2.h),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Dietary Fiber',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                      Text(
                                                          // "${weightKGToPound(textValue: fetchModelData?.recipe?.nutritionalInfo?.nfDietaryFiber ?? 0.00, weightValue: weightValue)} ${weightValue == 1 ? "Pound" : "g"}",
                                                          '${(fetchModelData?.recipe?.nutritionalInfo?.nfDietaryFiber ?? 0.00).toStringAsFixed(2)} g',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Divider(
                                                      color: AppColors
                                                          .disabledColor,
                                                      height: 2.h),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Sugar',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                      Text(
                                                          '${(fetchModelData?.recipe?.nutritionalInfo?.nfSugars ?? 0.00).toStringAsFixed(2)} g',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Divider(
                                                      color: AppColors
                                                          .disabledColor,
                                                      height: 2.h),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Potassium',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                      Text(
                                                          '${(fetchModelData?.recipe?.nutritionalInfo?.nfPotassium ?? 0.00).toStringAsFixed(2)} mg',
                                                          style: FontUtils.h16(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.medium)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Divider(
                                                      color: AppColors
                                                          .disabledColor,
                                                      height: 2.h),

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
                                                ]),
                                          const SizedBox(height: 15),
                                          (widget.mealDataArguments!
                                                      .isJournalMeal ??
                                                  false)
                                              ? GestureDetector(
                                                  onTap: () {
                                                    if (mealDataByDate !=
                                                        null) {
                                                      mealPlanBloc.add(
                                                          RemoveMealLogEvent(
                                                              mealId:
                                                                  mealDataByDate
                                                                          ?.id ??
                                                                      ""));
                                                    } else {
                                                      mealPlanBloc.add(
                                                        SkipMealPlanEvent(
                                                          value: 1,
                                                          mealID: widget
                                                                  .mealDataArguments!
                                                                  .mealData
                                                                  ?.id ??
                                                              "",
                                                          calorie: fetchModelData!
                                                                  .recipe!
                                                                  .nutrientsPerServing!
                                                                  .calories ??
                                                              0,
                                                          mealName: widget
                                                              .mealDataArguments!
                                                              .mealData!
                                                              .recipe!
                                                              .name,
                                                          mealType: widget
                                                              .mealDataArguments!
                                                              .mealData!
                                                              .meal,
                                                          noOfServing:
                                                              fetchModelData!
                                                                  .recipe!
                                                                  .serving,
                                                          fat: fetchModelData!
                                                              .recipe!
                                                              .nutrientsPerServing!
                                                              .fat,
                                                          protein: fetchModelData!
                                                              .recipe!
                                                              .nutrientsPerServing!
                                                              .protein,
                                                          carbs: fetchModelData!
                                                              .recipe!
                                                              .nutrientsPerServing!
                                                              .carbs,
                                                          recipeId: widget
                                                                  .mealDataArguments!
                                                                  .mealData!
                                                                  .recipe!
                                                                  .id ??
                                                              "",
                                                          date: widget.mealDataArguments
                                                                      ?.currentSelectedData !=
                                                                  null
                                                              ? dateTimeYYYYMMDD(
                                                                  dateTimeVal: widget
                                                                      .mealDataArguments!
                                                                      .currentSelectedData
                                                                      .toString())
                                                              : null,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: isLoading
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : Container(
                                                          height: screenSize
                                                                  .height *
                                                              0.065,
                                                          width:
                                                              screenSize.width,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: mealDataByDate !=
                                                                        null
                                                                    ? AppColors
                                                                        .primaryBlue
                                                                    : AppColors
                                                                        .whiteColor),
                                                            color: mealDataByDate !=
                                                                    null
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .primaryBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                                  mealDataByDate !=
                                                                          null
                                                                      ? StringUtils
                                                                          .remove
                                                                      : StringUtils
                                                                          .logmeal,
                                                                  style: FontUtils.h16(
                                                                      fontColor: mealDataByDate !=
                                                                              null
                                                                          ? AppColors
                                                                              .primaryBlue
                                                                          : AppColors
                                                                              .whiteColor,
                                                                      fontWeight:
                                                                          FWT.semiBold))),
                                                        ),
                                                )
                                              : BlocConsumer(
                                                  bloc: addNewGroceryItemBloc,
                                                  listener: (context, state) {
                                                    if (state is LoadingState) {
                                                      addItem = true;
                                                    }
                                                    if (state
                                                        is AddGroceryItemSuccessfulState) {
                                                      addItem = false;
                                                    }
                                                    if (state is ErrorState) {
                                                      addItem = false;
                                                    }
                                                  },
                                                  builder: (context, state) =>
                                                      GestureDetector(
                                                    onTap: () {
                                                      if (isAddButtonEnable) {
                                                        // mealPlanBloc.add(
                                                        //   GrocerySearchEvent(
                                                        //       grocerySearchModelList:
                                                        //           grocerySearchList),
                                                        // );

                                                        // bloc.add(GroceryAddToShoppingListEvent(
                                                        //   productID: '',
                                                        //   productName: widget.mealDataArguments!.mealData!.recipe!.name!,
                                                        //   price: '',
                                                        //   unitSize: '',
                                                        //   unitOfMeasurement: '',
                                                        //   quantity: '1',
                                                        //   recipeId: '',
                                                        //   mealmeStoreId: '',
                                                        //   isAdd: true,
                                                        //   isRemove: false,
                                                        //   isChecked: false,
                                                        // ));

                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            groceryDetails = [];

                                                        for (var i = 0;
                                                            i <
                                                                grocerySearchList
                                                                    .length;
                                                            i++) {
                                                          for (var j = 0;
                                                              j <
                                                                  fetchModelData!
                                                                      .recipe!
                                                                      .parsedIngredientLines!
                                                                      .length;
                                                              j++) {
                                                            if (grocerySearchList[
                                                                    i]
                                                                .groceryName!
                                                                .toLowerCase()
                                                                .contains(fetchModelData!
                                                                    .recipe!
                                                                    .parsedIngredientLines![
                                                                        j]
                                                                    .ingredient!
                                                                    .toLowerCase())) {
                                                              groceryDetails
                                                                  .add(
                                                                {
                                                                  'itemName':
                                                                      grocerySearchList[i]
                                                                              .groceryName ??
                                                                          '',
                                                                  'quantity':
                                                                      grocerySearchList[i]
                                                                              .quantity ??
                                                                          1,
                                                                  'measurementType': fetchModelData!
                                                                          .recipe!
                                                                          .parsedIngredientLines![
                                                                              j]
                                                                          .unit ??
                                                                      '',
                                                                  'measurementValue': fetchModelData!
                                                                      .recipe!
                                                                      .parsedIngredientLines![
                                                                          j]
                                                                      .quantity
                                                                      .toString()
                                                                },
                                                              );
                                                            }
                                                          }
                                                        }

                                                        addNewGroceryItemBloc
                                                            .add(
                                                          AddNewGroceryItem(
                                                            userId: userId,
                                                            groceryItems:
                                                                groceryDetails,
                                                          ),
                                                        );
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Select atleast 1 Ingredients');
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.h),
                                                      child: addItem == true
                                                          ? const CircularProgressIndicator()
                                                          : Container(
                                                              height: screenSize
                                                                      .height *
                                                                  0.065,
                                                              width: screenSize
                                                                  .width,
                                                              decoration:
                                                                  isAddButtonEnable
                                                                      ? BoxDecoration(
                                                                          color: AppColors
                                                                              .primaryBlue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8))
                                                                      : BoxDecoration(
                                                                          color:
                                                                              AppColors.gray,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                              child: Center(
                                                                  child: Text(
                                                                      StringUtils
                                                                          .addToGroceryList,
                                                                      style: FontUtils.h16(
                                                                          fontColor: AppColors
                                                                              .whiteColor,
                                                                          fontWeight:
                                                                              FWT.semiBold))),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                          // simpleTextBorderButton(
                                          //   context: context,
                                          //   buttonLable: StringUtils.addToGroceryList,
                                          //   height: screenSize.height * 0.065,
                                          //   width: screenSize.width,
                                          //   isLoadingWidget: state is AddToGroceryLoadingState ? true : false,
                                          //   onTap: () {
                                          //     if (isAddButtonEnable) {
                                          //       bloc.add(AddToGroceryListEvent(databaseIdOfRecipes: widget.mealDataArguments!.mealData!.recipe!.databaseId!));
                                          //     }
                                          //   },
                                          //   isDarkColor: isAddButtonEnable,
                                          //   isFillColor: isAddButtonEnable,
                                          // ),
                                          SizedBox(height: 14.h),
                                          GestureDetector(
                                            onTap: () {
                                              // Get.toNamed('/BestMatchRestaurantsScreen');

                                              log(
                                                  fetchModelData!.recipe!.name!
                                                      .toString(),
                                                  name: "NAME");
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return BestMatchRestaurantsScreen(
                                                    productName: fetchModelData!
                                                        .recipe!.name!);
                                              }));
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Order Best Match from Restaurant',
                                                    style: FontUtils.h20(
                                                        fontColor: AppColors
                                                            .primaryBlue,
                                                        fontWeight:
                                                            FWT.semiBold),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: AppColors.primaryBlue,
                                                  size: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 14.h),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Recipe',
                                              style: FontUtils.h22(
                                                  fontColor:
                                                      AppColors.middleGray,
                                                  fontWeight: FWT.semiBold),
                                            ),
                                          ),
                                          SizedBox(height: 7.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: myWidget(
                                                      imgURL: AssetsUtils
                                                          .icTimelineIcon,
                                                      title:
                                                          '${fetchModelData!.recipe!.totalTime}',
                                                      onTap: () {})),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                  flex: 1,
                                                  child: myWidget(
                                                      imgURL: AssetsUtils
                                                          .icServingIcon,
                                                      title:
                                                          '${fetchModelData!.recipe!.serving} Servings',
                                                      onTap: () {})),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                  flex: 1,
                                                  child: myWidget(
                                                      imgURL: AssetsUtils
                                                          .icIngredientsIcon,
                                                      title:
                                                          '${fetchModelData!.recipe!.ingredientsCount} Ingredients',
                                                      onTap: () {})),
                                            ],
                                          ),
                                          SizedBox(height: 7.h),
                                          ListView.builder(
                                              itemCount: fetchModelData!
                                                  .recipe!.instructions!.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .appColor,
                                                                  width: 2),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            height: 35,
                                                            width: 35,
                                                            child: Center(
                                                              child: Text(
                                                                '${index + 1}',
                                                                style: FontUtils.h16(
                                                                    fontColor:
                                                                        AppColors
                                                                            .appColor,
                                                                    fontWeight:
                                                                        FWT.medium),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.w),
                                                          Expanded(
                                                            child: Text(
                                                              fetchModelData!
                                                                      .recipe!
                                                                      .instructions![
                                                                  index],
                                                              style: FontUtils.h16(
                                                                  fontColor:
                                                                      AppColors
                                                                          .darkGray,
                                                                  fontWeight: FWT
                                                                      .medium),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    index !=
                                                            fetchModelData!
                                                                    .recipe!
                                                                    .instructions!
                                                                    .length -
                                                                1
                                                        ? const Divider(
                                                            color: AppColors
                                                                .disabledColor,
                                                            thickness: 1.2,
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                );
                                              }),
                                          SizedBox(height: 10.h),
                                          Container(
                                            height: screenSize.height * 0.08,
                                            width: screenSize.width * 0.40,
                                            decoration: const BoxDecoration(
                                                color: AppColors.coral,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(60),
                                                  topLeft: Radius.circular(60),
                                                  topRight: Radius.circular(80),
                                                  bottomRight:
                                                      Radius.circular(12),
                                                )),
                                            child: Center(
                                              child: Text(
                                                'Enjoy!',
                                                style: FontUtils.h28(
                                                    fontColor:
                                                        AppColors.terracotta,
                                                    fontWeight: FWT.semiBold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget myWidget(
      {required String imgURL,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.whiteColor,
            boxShadow: const [
              BoxShadow(
                  color: AppColors.black, blurRadius: 15, spreadRadius: -20),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              children: [
                SvgPicture.asset(imgURL),
                const SizedBox(height: 10),
                Text(title,
                    style: FontUtils.h15(
                        fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
              ],
            ),
          )),
    );
  }

  Widget tabView(
      {required String title,
      bool isSelected = false,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.grayColor,
                    width: 1.4))),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            title,
            style: FontUtils.h18(
                fontColor:
                    isSelected ? AppColors.primaryBlue : AppColors.grayColor,
                fontWeight: FWT.semiBold),
          ),
        )),
      ),
    );
  }

  Widget commonProgressBar(
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
      percent: percent!,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }

  Widget myProgressBarCardView(String title, double value, double totalValue,
      Color progressBarColor, String unit) {
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
                  lineHeight: 12,
                  percent:
                      (value / totalValue).isInfinite ? 0 : value / totalValue,
                ),
              ],
            ),
            Text('$value / $totalValue $unit',
                style: FontUtils.h15(
                    fontColor: AppColors.darkGray,
                    fontWeight: FWT.lightMedium)),
          ],
        ));
  }
}
