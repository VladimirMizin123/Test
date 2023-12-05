import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_state.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_event.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
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
  AddNewGroceryItemBloc addNewGroceryItemBloc = AddNewGroceryItemBloc();
  AddNewMealBloc addNewMealBloc = AddNewMealBloc();
  NutritionixGetNxMealInfoByNameModelData?
      nutritionixGetNxMealInfoByNameModelData;
  int productCount = 0;
  bool remove = false;
  bool add = false;
  bool delete = false;
  bool addItem = false;
  @override
  void initState() {
    super.initState();

    if (widget.arguments!.isFromGroceryScreen == true) {
      groceryBloc.add(GroceryDetailsMealInfoEvent(
          groceryProductName: widget.arguments!.productName!));
      setState(() {
        productCount = 1;
      });
    } else if (widget.arguments!.isFromJournalScreen == true) {
      groceryBloc.add(GroceryDetailsMealInfoEvent(
          groceryProductName: widget.arguments!.productName!));
      setState(() {
        productCount = 1;
      });
    } else {
      if (widget.arguments!.isFromCustomMealScreen == true) {
        groceryBloc.add(GroceryDetailsMealInfoEvent(
            groceryProductName: widget.arguments!.productName!));
        setState(() {
          productCount = 1;
        });
      } else {
        groceryBloc.add(
          GroceryDetailsMealInfoEvent(
            groceryProductName: widget.arguments!.groceryShoppingData!.itemName,
          ),
        );
        setState(() {
          productCount = widget.arguments!.groceryShoppingData!.quantity ?? 0;
        });
      }
    }
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
                      Text('Item Details',
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
                          ? state
                                  is GroceryNutritionixGetNxMealInfoByNameLoadingState
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const SizedBox()
                          : BlocConsumer(
                              bloc: addNewGroceryItemBloc,
                              listener: (context, state) {
                                /// Remove Update State=========================================================

                                ///----------Loading State
                                if (state
                                    is UpdateRemoveGroceryListLoadingState) {
                                  remove = true;
                                }

                                ///----------Error State
                                if (state
                                    is UpdateRemoveGroceryListErrorState) {
                                  remove = false;
                                }

                                ///----------Success State
                                if (state
                                    is UpdateRemoveGroceryListSuccessState) {
                                  remove = false;
                                  productCount = productCount - 1;
                                  widget.arguments!.groceryShoppingData!
                                      .quantity = widget.arguments!
                                          .groceryShoppingData!.quantity -
                                      1;
                                }

                                /// Add Update State=========================================================
                                ///----------Loading State
                                if (state is UpdateAddGroceryListLoadingState) {
                                  add = true;
                                }

                                ///----------Error State
                                if (state is UpdateAddGroceryListErrorState) {
                                  add = false;
                                }

                                ///----------Success State
                                if (state is UpdateAddGroceryListSuccessState) {
                                  add = false;
                                  productCount = productCount + 1;
                                  widget.arguments!.groceryShoppingData!
                                      .quantity = widget.arguments!
                                          .groceryShoppingData!.quantity +
                                      1;
                                }

                                /// Remove Item Stat ===========================================================

                                ///----------Loading State
                                if (state is RemoveGroceryItemLoadingState) {
                                  delete = true;
                                }

                                ///----------Success State
                                if (state is RemoveGroceryItemSuccessState) {
                                  delete = false;
                                  Get.back();
                                }

                                ///----------Error State
                                if (state is RemoveGroceryItemErrorState) {
                                  delete = false;
                                }

                                if (state is LoadingState) {
                                  addItem = true;
                                }
                                if (state is ErrorState) {
                                  addItem = false;
                                }
                                if (state is AddGroceryItemSuccessfulState) {
                                  addItem = false;
                                }
                              },
                              builder: (context, state) =>
                                  SingleChildScrollView(
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
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? widget.arguments
                                                              ?.productName ??
                                                          ''
                                                      : nutritionixGetNxMealInfoByNameModelData!
                                                              .foodName ??
                                                          '',
                                                  style: FontUtils.h16(
                                                      fontColor:
                                                          AppColors.black,
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
                                              // widget.arguments!.groceryShoppingData!
                                              //             .quantity! >
                                              //         1
                                              //     ?
                                              if (widget
                                                      .arguments?.isShowData !=
                                                  true)
                                                GestureDetector(
                                                  onTap: () {
                                                    if (productCount != 1) {
                                                      setState(
                                                        () {
                                                          if (remove == false) {
                                                            if (widget
                                                                    .arguments!
                                                                    .isFromGroceryScreen ==
                                                                true) {
                                                            } else {
                                                              addNewGroceryItemBloc
                                                                  .add(
                                                                UpdateRemoveNewGroceryItem(
                                                                  userId:
                                                                      userId,
                                                                  id: widget
                                                                      .arguments!
                                                                      .groceryShoppingData!
                                                                      .id!,
                                                                  itemName: widget
                                                                      .arguments!
                                                                      .groceryShoppingData!
                                                                      .itemName!
                                                                      .toString(),
                                                                  quantity: widget
                                                                          .arguments!
                                                                          .groceryShoppingData!
                                                                          .quantity -
                                                                      1,
                                                                  measurementType: widget
                                                                      .arguments!
                                                                      .groceryShoppingData!
                                                                      .measurementType!
                                                                      .toString(),
                                                                  measurementValue: widget
                                                                      .arguments!
                                                                      .groceryShoppingData!
                                                                      .measurementValue!
                                                                      .toString(),
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    height: size.height * 0.070,
                                                    width: size.height * 0.070,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: AppColors.skyBlue,
                                                    ),
                                                    child: Center(
                                                      child: remove == true
                                                          ? Transform.scale(
                                                              scale: 0.5,
                                                              child:
                                                                  const CircularProgressIndicator())
                                                          : const Icon(
                                                              Icons.remove,
                                                              size: 27,
                                                            ),
                                                    ),
                                                    // child: const Center(child: Icon(Icons.remove, size: 27)),
                                                  ),
                                                ),
                                              // : GestureDetector(
                                              //     onTap: () {
                                              //       // groceryBloc.add(
                                              //       //     RemoveGroceryEvent(
                                              //       //         productID: widget
                                              //       //             .arguments!
                                              //       //             .groceryShoppingData!
                                              //       //             .itemName!));
                                              //       addNewGroceryItemBloc.add(
                                              //         RemoveGroceryItemEvent(
                                              //           userGroceryListId: widget
                                              //               .arguments!
                                              //               .groceryShoppingData!
                                              //               .id!,
                                              //         ),
                                              //       );
                                              //     },
                                              //     child: Container(
                                              //       height: size.height * 0.070,
                                              //       width: size.height * 0.070,
                                              //       decoration: BoxDecoration(
                                              //           border: Border.all(
                                              //               color: AppColors
                                              //                   .skyBlue),
                                              //           borderRadius:
                                              //               BorderRadius.circular(
                                              //                   6)),
                                              //       child: Center(
                                              //           child: delete == true
                                              //               ? Transform.scale(
                                              //                   scale: 0.5,
                                              //                   child:
                                              //                       const CircularProgressIndicator())
                                              //               : SvgPicture.asset(
                                              //                   AssetsUtils
                                              //                       .icDelete)),
                                              //     ),
                                              //   ),
                                              // Container(
                                              //   height: size.height * 0.070,
                                              //   width: size.height * 0.070,
                                              //   decoration: BoxDecoration(
                                              //       border: Border.all(
                                              //           color: AppColors.skyBlue),
                                              //       borderRadius:
                                              //           BorderRadius.circular(6)),
                                              //   child: Center(
                                              //       child: SvgPicture.asset(
                                              //           AssetsUtils.icDelete)),
                                              // ),
                                              SizedBox(width: 8.w),
                                              Container(
                                                height: size.height * 0.070,
                                                width: size.height * 0.070,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            AppColors.disable),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: Center(
                                                    child: Text(
                                                  productCount.toString(),
                                                  style: FontUtils.h18(
                                                      fontWeight: FWT.semiBold,
                                                      fontColor:
                                                          AppColors.darkGray),
                                                )),
                                              ),

                                              SizedBox(width: 8.w),
                                              if (widget
                                                      .arguments?.isShowData !=
                                                  true)
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(
                                                      () {
                                                        if (add == false) {
                                                          if (widget.arguments!
                                                                  .isFromGroceryScreen ==
                                                              true) {
                                                          } else {
                                                            addNewGroceryItemBloc
                                                                .add(
                                                              UpdateAddNewGroceryItem(
                                                                userId: userId,
                                                                id: widget
                                                                    .arguments!
                                                                    .groceryShoppingData!
                                                                    .id!,
                                                                itemName: widget
                                                                    .arguments!
                                                                    .groceryShoppingData!
                                                                    .itemName!
                                                                    .toString(),
                                                                quantity: widget
                                                                        .arguments!
                                                                        .groceryShoppingData!
                                                                        .quantity +
                                                                    1,
                                                                measurementType: widget
                                                                    .arguments!
                                                                    .groceryShoppingData!
                                                                    .measurementType!
                                                                    .toString(),
                                                                measurementValue: widget
                                                                    .arguments!
                                                                    .groceryShoppingData!
                                                                    .measurementValue!
                                                                    .toString(),
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: size.height * 0.070,
                                                    width: size.height * 0.070,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: AppColors.skyBlue,
                                                    ),
                                                    child: Center(
                                                      child: add == true
                                                          ? Transform.scale(
                                                              scale: 0.5,
                                                              child:
                                                                  const CircularProgressIndicator())
                                                          : const Icon(
                                                              Icons.add,
                                                              size: 27),
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(width: 8.w),
                                              widget.arguments?.isShowData ==
                                                      true
                                                  ? SizedBox()
                                                  : Expanded(
                                                      flex: 2,
                                                      child:
                                                          DropdownButtonFormField(
                                                              decoration: const InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .black))),
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              value:
                                                                  _selectProduct,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              items: productList
                                                                  .map((e) =>
                                                                      DropdownMenuItem(
                                                                        value:
                                                                            e,
                                                                        child:
                                                                            Text(e),
                                                                      ))
                                                                  .toList(),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _selectProduct =
                                                                      val!;
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
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? widget.arguments?.cal ??
                                                          0.0
                                                      : nutritionixGetNxMealInfoByNameModelData!
                                                                  .nfCalories ==
                                                              null
                                                          ? 0
                                                          : double.parse(
                                                              nutritionixGetNxMealInfoByNameModelData!
                                                                  .nfCalories
                                                                  .toString()),
                                                  double.parse(double.parse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalCalorie))
                                                      .toStringAsFixed(2)),
                                                  AppColors.primaryBlue),
                                              myProgressBarCardView(
                                                  'Fat',
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? widget.arguments?.fat ??
                                                          0.0
                                                      : nutritionixGetNxMealInfoByNameModelData!
                                                                  .nfTotalFat ==
                                                              null ? 0 : double.parse(
                                                              nutritionixGetNxMealInfoByNameModelData!
                                                                  .nfTotalFat
                                                                  .toString()),
                                                  double.parse(double.parse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalFat))
                                                      .toStringAsFixed(2)),
                                                  AppColors.coral),
                                              myProgressBarCardView(
                                                  'Carbs',
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? widget.arguments
                                                              ?.carbs ??
                                                          0.0
                                                      : nutritionixGetNxMealInfoByNameModelData!
                                                                  .nfTotalCarbohydrate ==
                                                              null
                                                          ? 0
                                                          : double.parse(
                                                              nutritionixGetNxMealInfoByNameModelData!
                                                                  .nfTotalCarbohydrate
                                                                  .toString()),
                                                  double.parse(double.parse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalCarbs))
                                                      .toStringAsFixed(2)),
                                                  AppColors.mint),
                                              myProgressBarCardView(
                                                  'Protein',
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? widget.arguments
                                                              ?.protein ??
                                                          0.0
                                                      : nutritionixGetNxMealInfoByNameModelData!
                                                                  .nfTotalFat ==
                                                              null
                                                          ? 0
                                                          : double.parse(
                                                              nutritionixGetNxMealInfoByNameModelData!
                                                                  .nfTotalFat
                                                                  .toString()),
                                                  double.parse(double.parse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalProtein))
                                                      .toStringAsFixed(2)),
                                                  AppColors.skyBlue),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  'Nutritional Information',
                                                  style: FontUtils.h24(
                                                      fontColor:
                                                          AppColors.darkGray,
                                                      fontWeight:
                                                          FWT.semiBold))),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Calories',
                                                  style: FontUtils.h16(
                                                      fontColor:
                                                          AppColors.darkGray,
                                                      fontWeight: FWT.medium)),
                                              Text(
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? '${widget.arguments?.cal ?? 0} cal'
                                                      : '${(nutritionixGetNxMealInfoByNameModelData?.nfCalories ?? 0.00).toStringAsFixed(2)} cal',
                                                  style: FontUtils.h16(
                                                      fontColor:
                                                          AppColors.darkGray,
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
                                                      fontColor:
                                                          AppColors.darkGray,
                                                      fontWeight: FWT.medium)),
                                              Text(
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? '${widget.arguments?.protein ?? 0} g'
                                                      : '${(nutritionixGetNxMealInfoByNameModelData?.nfProtein ?? 0).toStringAsFixed(2)} g',
                                                  style: FontUtils.h16(
                                                      fontColor:
                                                          AppColors.darkGray,
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
                                                      fontColor:
                                                          AppColors.darkGray,
                                                      fontWeight: FWT.medium)),
                                              Text(
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? '${widget.arguments?.carbs ?? 0} g'
                                                      : '${(nutritionixGetNxMealInfoByNameModelData?.nfTotalCarbohydrate ?? 0)?.toStringAsFixed(2)} g',
                                                  style: FontUtils.h16(
                                                      fontColor:
                                                          AppColors.darkGray,
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
                                                      fontColor:
                                                          AppColors.darkGray,
                                                      fontWeight: FWT.medium)),
                                              Text(
                                                  widget.arguments
                                                              ?.isShowData ==
                                                          true
                                                      ? '${widget.arguments?.fat ?? 0} g'
                                                      : '${(nutritionixGetNxMealInfoByNameModelData?.nfTotalFat ?? 0)?.toStringAsFixed(2) ?? 0} g',
                                                  style: FontUtils.h16(
                                                      fontColor:
                                                          AppColors.darkGray,
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
                                          addItem == true
                                              ? const CircularProgressIndicator()
                                              : widget.arguments!
                                                          .isFromCustomMealScreen ==
                                                      true
                                                  ? simpleTextBorderButton(
                                                      context: context,
                                                      buttonLable: 'Back',
                                                      height:
                                                          size.height * 0.065,
                                                      width: size.width,
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      isDarkColor: true,
                                                      isFillColor: true,
                                                    )
                                                  : simpleTextBorderButton(
                                                      context: context,
                                                      buttonLable: 'Add Item',
                                                      height:
                                                          size.height * 0.065,
                                                      width: size.width,
                                                      onTap: () {
                                                        if (widget.arguments!
                                                                .isFromGroceryScreen ==
                                                            true) {
                                                          addNewGroceryItemBloc
                                                              .add(
                                                            AddNewGroceryItem(
                                                              userId: userId,
                                                              groceryItems: [
                                                                widget
                                                                    .arguments!
                                                                    .groceryDetails!
                                                              ],
                                                            ),
                                                          );
                                                        } else if (widget
                                                                .arguments!
                                                                .isFromJournalScreen ==
                                                            true) {
                                                          addNewMealBloc.add(
                                                            AddNewMeal(
                                                              name: nutritionixGetNxMealInfoByNameModelData!
                                                                      .foodName ??
                                                                  '',
                                                              protein: nutritionixGetNxMealInfoByNameModelData
                                                                      ?.nfProtein
                                                                      .toString() ??
                                                                  '0',
                                                              fat: nutritionixGetNxMealInfoByNameModelData
                                                                      ?.nfTotalFat
                                                                      .toString() ??
                                                                  '0',
                                                              carbs: nutritionixGetNxMealInfoByNameModelData
                                                                      ?.nfTotalCarbohydrate
                                                                      .toString() ??
                                                                  '0',
                                                              calorie: nutritionixGetNxMealInfoByNameModelData
                                                                      ?.nfCalories
                                                                      .toString() ??
                                                                  '0',
                                                              type: widget
                                                                  .arguments!
                                                                  .type
                                                                  .toString()
                                                                  .removeAllWhitespace,
                                                              userId: userId
                                                                  .toString(),
                                                              quantity: '1',
                                                            ),
                                                          );
                                                        } else {}

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
                                  ))),
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
      percent: percentage!.isGreaterThan(1) ? 1 : percentage,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }
}

class GroceryItemDetailsArguments {
  final GroceryDetails? groceryShoppingData;
  final bool isFromGroceryScreen;
  final bool isFromCustomMealScreen;
  final bool isFromJournalScreen;
  final String? productName;
  final String? productID;
  final String? type;
  final Map<String, dynamic>? groceryDetails;
  final bool isShowData;
  final double? cal;
  final double? fat;
  final double? carbs;
  final double? protein;
  final int? quantity;

  GroceryItemDetailsArguments(
      {this.groceryShoppingData,
      this.isFromGroceryScreen = false,
      this.isFromCustomMealScreen = false,
      this.isFromJournalScreen = false,
      this.productName,
      this.productID,
      this.type,
      this.groceryDetails,
      this.isShowData = false,
      this.cal,
      this.fat,
      this.carbs,
      this.protein,
      this.quantity});
}
