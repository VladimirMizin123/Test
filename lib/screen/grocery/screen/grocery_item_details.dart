import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_shopping_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GroceryItemDetails extends StatefulWidget {
  final GroceryItemDetailsArguments? arguments;
  const GroceryItemDetails({super.key, this.arguments});

  @override
  State<GroceryItemDetails> createState() => _GroceryItemDetailsState();
}

class _GroceryItemDetailsState extends State<GroceryItemDetails> {
  String _selectProduct = 'Spoon';
  List<String> productList = ['Spoon', 'Cup'];
  GroceryBloc groceryBloc = GroceryBloc();
  NutritionixGetNxMealInfoByNameModelData?
      nutritionixGetNxMealInfoByNameModelData;
  int productCount = 0;

  @override
  void initState() {
    super.initState();
    groceryBloc.add(GroceryDetailsMealInfoEvent(
        groceryProductName: widget.arguments!.groceryShoppingData!.itemName!));

    setState(() {
      productCount = widget.arguments!.groceryShoppingData!.quantity ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<GroceryBloc, GroceryState>(
          bloc: groceryBloc,
          listener: (context, state) {
            if (state is GroceryNutritionixGetNxMealInfoByNameSuccessState) {
              nutritionixGetNxMealInfoByNameModelData =
                  state.nutritionixGetNxMealInfoByNameModelData;
            }

            // Grocery Add-Remove STATE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            // if (state is GroceryAddToShoppingLoadingState) {
            //   if (widget.arguments!.groceryShoppingData!.productId! == state.productId) {
            //     widget.arguments!.groceryShoppingData!.isAddItem = state.isAdd;
            //     widget.arguments!.groceryShoppingData!.isRemoveItem = state.isRemove;
            //   }
            // }
            //
            // if (state is GroceryAddToShoppingSuccessState) {
            //   if (widget.arguments!.groceryShoppingData!.productId == state.recipesAddToGroceryData!.productId) {
            //     widget.arguments!.groceryShoppingData!.isAddItem = false;
            //     widget.arguments!.groceryShoppingData!.isRemoveItem = false;
            //     widget.arguments!.groceryShoppingData!.quantity = state.recipesAddToGroceryData!.quantity;
            //   }
            // }
            //
            // if (state is GroceryAddToShoppingErrorState) {
            //   widget.arguments!.groceryShoppingData!.isAddItem = false;
            //   widget.arguments!.groceryShoppingData!.isRemoveItem = false;
            // }
            //
            // // Grocery Delete STATE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            // if (state is RemoveGroceryLoadingState) {
            //   if (widget.arguments!.groceryShoppingData!.productId! == state.productId) {
            //     widget.arguments!.groceryShoppingData!.isDeleteLoading = true;
            //   }
            // }
            //
            // if (state is RemoveGrocerySuccessState) {
            //   if (widget.arguments!.groceryShoppingData!.productId == state.productID) {
            //     widget.arguments!.groceryShoppingData!.isDeleteLoading = false;
            //     Navigator.pop(context);
            //   }
            // }
            //
            // if (state is RemoveGroceryErrorState) {
            //   if (widget.arguments!.groceryShoppingData!.productId == state.productID) {
            //     widget.arguments!.groceryShoppingData!.isDeleteLoading = false;
            //   }
            // }
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
                      Text('Grocery List',
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
                    child: nutritionixGetNxMealInfoByNameModelData == null
                        ? state is GroceryNutritionixGetNxMealInfoByNameLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const SizedBox()
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          nutritionixGetNxMealInfoByNameModelData!
                                                  .foodName ??
                                              '',
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
                                  Row(
                                    children: [
                                      // widget.arguments!.groceryShoppingData!.quantity! > 1
                                      //     ?
                                      GestureDetector(
                                        onTap: () {
                                          if (productCount != 1) {
                                            setState(() {
                                              productCount = productCount - 1;
                                            });
                                          }
                                          // groceryBloc.add(GroceryAddToShoppingListEvent(
                                          //   productID: widget.arguments!.groceryShoppingData!.productId!,
                                          //   mealmeStoreId: widget.arguments!.groceryShoppingData!.mealmeStoreId!,
                                          //   price: widget.arguments!.groceryShoppingData!.price.toString(),
                                          //   productName: widget.arguments!.groceryShoppingData!.productName!,
                                          //   quantity: (widget.arguments!.groceryShoppingData!.quantity! - 1).toString(),
                                          //   recipeId: widget.arguments!.groceryShoppingData!.recipeId!,
                                          //   unitOfMeasurement: widget.arguments!.groceryShoppingData!.unitOfMeasurement!,
                                          //   unitSize: widget.arguments!.groceryShoppingData!.unitSize.toString(),
                                          //   isAdd: false,
                                          //   isRemove: true,
                                          //   isChecked: widget.arguments!.groceryShoppingData!.isAddedForViewCart ?? false,
                                          // ));
                                        },
                                        child: Container(
                                          height: size.height * 0.070,
                                          width: size.height * 0.070,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: AppColors.skyBlue,
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.remove, size: 27),
                                          ),
                                          // child: const Center(child: Icon(Icons.remove, size: 27)),
                                        ),
                                      ),
                                      // : GestureDetector(
                                      //     onTap: () {
                                      //       groceryBloc.add(RemoveGroceryEvent(productID: widget.arguments!.groceryShoppingData!.productId!));
                                      //     },
                                      //     child: Container(
                                      //       height: size.height * 0.070,
                                      //       width: size.height * 0.070,
                                      //       decoration: BoxDecoration(border: Border.all(color: AppColors.skyBlue), borderRadius: BorderRadius.circular(6)),
                                      //       child: Center(child: widget.arguments!.groceryShoppingData!.isDeleteLoading ?? false ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator()) : SvgPicture.asset(AssetsUtils.icDelete)),
                                      //     ),
                                      //   ),
                                      // Container(
                                      //   height: size.height * 0.070,
                                      //   width: size.height * 0.070,
                                      //   decoration: BoxDecoration(border: Border.all(color: AppColors.skyBlue), borderRadius: BorderRadius.circular(6)),
                                      //   child: Center(child: SvgPicture.asset(AssetsUtils.icDelete)),
                                      // ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        height: size.height * 0.070,
                                        width: size.height * 0.070,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.disable),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Center(
                                            child: Text(
                                          productCount.toString(),
                                          style: FontUtils.h18(
                                              fontWeight: FWT.semiBold,
                                              fontColor: AppColors.darkGray),
                                        )),
                                      ),
                                      // Container(
                                      //   height: size.height * 0.070,
                                      //   width: size.height * 0.070,
                                      //   decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(6)),
                                      //   child: Center(
                                      //       child: Text(
                                      //     '0',
                                      //     style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                      //   )),
                                      // ),
                                      SizedBox(width: 8.w),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productCount = productCount + 1;
                                          });
                                          // groceryBloc.add(GroceryAddToShoppingListEvent(
                                          //   productID: widget.arguments!.groceryShoppingData!.productId!,
                                          //   mealmeStoreId: widget.arguments!.groceryShoppingData!.mealmeStoreId!,
                                          //   price: widget.arguments!.groceryShoppingData!.price.toString(),
                                          //   productName: widget.arguments!.groceryShoppingData!.productName!,
                                          //   quantity: (widget.arguments!.groceryShoppingData!.quantity! + 1).toString(),
                                          //   recipeId: widget.arguments!.groceryShoppingData!.recipeId!,
                                          //   unitOfMeasurement: widget.arguments!.groceryShoppingData!.unitOfMeasurement!,
                                          //   unitSize: widget.arguments!.groceryShoppingData!.unitSize.toString(),
                                          //   isAdd: true,
                                          //   isRemove: false,
                                          //   isChecked: widget.arguments!.groceryShoppingData!.isAddedForViewCart ?? false,
                                          // ));
                                        },
                                        child: Container(
                                          height: size.height * 0.070,
                                          width: size.height * 0.070,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: AppColors.skyBlue,
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add, size: 27),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   height: size.height * 0.070,
                                      //   width: size.height * 0.070,
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(6),
                                      //     color: AppColors.skyBlue,
                                      //   ),
                                      //   child: const Center(child: Icon(Icons.add, size: 27)),
                                      // ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        flex: 2,
                                        child: DropdownButtonFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black))),
                                            padding: EdgeInsets.zero,
                                            value: _selectProduct,
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                          nutritionixGetNxMealInfoByNameModelData!
                                                      .nfCalories ==
                                                  null
                                              ? 0
                                              : double.parse(
                                                  nutritionixGetNxMealInfoByNameModelData!
                                                      .nfCalories
                                                      .toString()),
                                          double.parse(double.parse(
                                                  PreferenceUtils.getString(
                                                      totalCalorie))
                                              .toStringAsFixed(2)),
                                          AppColors.primaryBlue),
                                      myProgressBarCardView(
                                          'Fat',
                                          nutritionixGetNxMealInfoByNameModelData!
                                                      .nfTotalFat ==
                                                  null
                                              ? 0
                                              : double.parse(
                                                  nutritionixGetNxMealInfoByNameModelData!
                                                      .nfTotalFat
                                                      .toString()),
                                          double.parse(double.parse(
                                                  PreferenceUtils.getString(
                                                      totalFat))
                                              .toStringAsFixed(2)),
                                          AppColors.coral),
                                      myProgressBarCardView(
                                          'Carbs',
                                          nutritionixGetNxMealInfoByNameModelData!
                                                      .nfTotalCarbohydrate ==
                                                  null
                                              ? 0
                                              : double.parse(
                                                  nutritionixGetNxMealInfoByNameModelData!
                                                      .nfTotalCarbohydrate
                                                      .toString()),
                                          double.parse(double.parse(
                                                  PreferenceUtils.getString(
                                                      totalCarbs))
                                              .toStringAsFixed(2)),
                                          AppColors.mint),
                                      myProgressBarCardView(
                                          'Protein',
                                          nutritionixGetNxMealInfoByNameModelData!
                                                      .nfTotalFat ==
                                                  null
                                              ? 0
                                              : double.parse(
                                                  nutritionixGetNxMealInfoByNameModelData!
                                                      .nfTotalFat
                                                      .toString()),
                                          double.parse(double.parse(
                                                  PreferenceUtils.getString(
                                                      totalProtein))
                                              .toStringAsFixed(2)),
                                          AppColors.skyBlue),
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
                                      Text('2g',
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
                                      Text('2g',
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
                                      Text('2g',
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
                                      Text('2g',
                                          style: FontUtils.h16(
                                              fontColor: AppColors.darkGray,
                                              fontWeight: FWT.medium)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(
                                      color: AppColors.disabledColor,
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
                                  const SizedBox(height: 15),
                                  simpleTextBorderButton(
                                    context: context,
                                    buttonLable: 'Add Item',
                                    height: size.height * 0.065,
                                    width: size.width,
                                    isLoadingWidget: state
                                        is GroceryAddToShoppingLoadingState,
                                    onTap: () {
                                      print('object');
                                      // groceryBloc.add(GroceryAddToShoppingListEvent(
                                      //   productID: widget.arguments!.groceryShoppingData!.productId!,
                                      //   mealmeStoreId: widget.arguments!.groceryShoppingData!.mealmeStoreId!,
                                      //   price: widget.arguments!.groceryShoppingData!.price.toString(),
                                      //   productName: widget.arguments!.groceryShoppingData!.productName!,
                                      //   quantity: productCount.toString(),
                                      //   recipeId: widget.arguments!.groceryShoppingData!.recipeId!,
                                      //   unitOfMeasurement: widget.arguments!.groceryShoppingData!.unitOfMeasurement!,
                                      //   unitSize: widget.arguments!.groceryShoppingData!.unitSize.toString(),
                                      //   isAdd: true,
                                      //   isRemove: false,
                                      //   isChecked: widget.arguments!.groceryShoppingData!.isAddedForViewCart ?? false,
                                      // ));
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

  Widget myProgressBarCardView(
      String title, double value, double totalValue, Color progressBarColor) {
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
                '${value.toStringAsFixed(2)} / ${totalValue.toStringAsFixed(2)} cal',
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
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: percentage ?? 0,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }
}

class GroceryItemDetailsArguments {
  final GroceryDetails? groceryShoppingData;
  final bool isFromGroceryScreen;

  GroceryItemDetailsArguments(
      {this.groceryShoppingData, this.isFromGroceryScreen = false});
}
