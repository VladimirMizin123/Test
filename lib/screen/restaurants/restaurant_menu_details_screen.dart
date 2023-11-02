import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/update_cart_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_Add_button.dart';

class RestaurantMenuDetailsScreen extends StatefulWidget {
  const RestaurantMenuDetailsScreen(
      {super.key,
      required this.data,
      required this.restaurantId,
      this.shoppingListData});
  final MenuItemList data;
  final String restaurantId;
  final ShoppingListData? shoppingListData;

  @override
  State<RestaurantMenuDetailsScreen> createState() =>
      _RestaurantMenuDetailsScreenState();
}

class _RestaurantMenuDetailsScreenState
    extends State<RestaurantMenuDetailsScreen> {
  int item = 0;
  dynamic price = 0;
  bool selectFirst = false;
  bool selectSecond = false;
  bool isAddUpdate = false;
  Map<String, dynamic> selectedData = {};
  List data = [];
  List addApiData = [];
  List<Map<String, dynamic>> optionsList = [];

  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool addToCart = false;
  bool isAdding = false;

  getData() async {
    if (widget.data.customizations != null) {
      for (var element in widget.data.customizations!) {
        selectedData.addAll(
          {
            element.name!: [],
          },
        );
      }
    }
    item = widget.data.cartQuantity!;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        body: SingleChildScrollView(
          child: BlocConsumer(
            bloc: restaurantBloc,
            listener: (context, state) {
              if (state is AddToRestaurantCartLoadingState) {
                isAdding = true;
              }
              if (state is AddToRestaurantCartSuccessState) {
                widget.data.cartQuantity = state.data[0]['quantity'];
                widget.data.cartPrice = state.data[0]['price'];
                widget.data.isAdded = true;
                isAdding = false;

                addApiData = state.data;

                // widget.shoppingListData?.productId = state.data[0]['productId'];
                // widget.shoppingListData?.userId = state.data[0]['userId'];
                // widget.shoppingListData?.unitSize = state.data[0]['unitSize'];
                // widget.shoppingListData?.isChecked = state.data[0]['isChecked'];
                // widget.shoppingListData?.unitOfMeasurement =
                //     state.data[0]['unitOfMeasurement'];
                // widget.shoppingListData?.brandName = state.data[0]['brandName'];
                // widget.shoppingListData?.recipeId = state.data[0]['recipeId'];
                // widget.shoppingListData?.mealmeStoreId =
                //     state.data[0]['mealmeStoreId'];
                // widget.shoppingListData?.productType =
                //     state.data[0]['productType'];
                // widget.shoppingListData?.options =
                //     state.data[0]['options'] ?? [];
                // widget.shoppingListData?.quantity = state.data[0]['quantity'];
                // widget.shoppingListData?.price = state.data[0]['price'];
                // widget.shoppingListData?.productName =
                //     state.data[0]['productName'];
              }
              if (state is AddToRestaurantCartErrorState) {
                isAdding = false;
              }

              ///UpdateToRestaurantCart State ====================================================================

              if (state is UpdateToRestaurantCartSuccessState) {
                if (state.data['productId'] == widget.data.productId) {
                  widget.data.cartQuantity = state.data['quantity'];
                  widget.data.cartPrice = state.data['price'];
                  item = state.data['quantity'];

                  if (isAddUpdate == true) {
                    widget.data.isAddUpdated = false;
                  } else {
                    widget.data.isRemoveUpdated = false;
                  }

                  isAddUpdate = false;
                }
              }

              if (state is UpdateToRestaurantCartLoadingState) {
                if (state.productId == widget.data.productId) {
                  if (isAddUpdate == true) {
                    widget.data.isAddUpdated = true;
                  } else {
                    widget.data.isRemoveUpdated = true;
                  }
                }
              }

              if (state is UpdateToRestaurantCartErrorState) {
                if (state.productId == widget.data.productId) {
                  if (isAddUpdate == true) {
                    widget.data.isAddUpdated = false;
                  } else {
                    widget.data.isRemoveUpdated = false;
                  }

                  isAddUpdate = false;
                }
              }

              ///Remove To RestaurantCart State ====================================================================

              if (state is RemoveShoppingListItemSuccessState) {
                if (state.productId == widget.data.productId) {
                  widget.data.cartQuantity = 0;
                  widget.data.cartPrice = 0;
                  item = 0;
                  widget.data.isAdded = false;
                  if (isAddUpdate == true) {
                    widget.data.isAddUpdated = false;
                  } else {
                    widget.data.isRemoveUpdated = false;
                  }

                  isAddUpdate = false;
                }

                // for (var element in restaurantMenu!.categories!) {
                //   for (var element1 in element.menuItemList!) {
                //     if (state.productId == element1.productId) {
                //       element1.cartQuantity = 0;
                //       element1.cartPrice = 0;
                //
                //       if (isAddUpdate == true) {
                //         element1.isAddUpdated = false;
                //       } else {
                //         element1.isRemoveUpdated = false;
                //       }
                //       element1.isAdded = false;
                //       isAddUpdate = false;
                //       restaurantBloc.add(GetShoppingListEvent());
                //     }
                //   }
                // }
              }

              if (state is RemoveShoppingListItemLoadingState) {
                if (state.productId == widget.data.productId) {
                  if (isAddUpdate == true) {
                    widget.data.isAddUpdated = true;
                  } else {
                    widget.data.isRemoveUpdated = true;
                  }
                }
              }

              if (state is RemoveShoppingListItemErrorState) {
                if (state.productId == widget.data.productId) {
                  if (isAddUpdate == true) {
                    widget.data.isAddUpdated = false;
                  } else {
                    widget.data.isRemoveUpdated = false;
                  }
                }
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: widget.data.image == null ||
                              widget.data.image!.isEmpty
                          ? const DecorationImage(
                              image: AssetImage(AssetsUtils.food3),
                              fit: BoxFit.cover)
                          : DecorationImage(
                              image: NetworkImage(widget.data.image!),
                              fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.h, left: 15.w),
                        child: GestureDetector(
                          onTap: () {
                            Get.back(result: addToCart);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      height: widget.data.customizations == null ||
                              widget.data.customizations!.isEmpty
                          ? size.height * 0.55
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.data.name!,
                            style: FontUtils.h24(
                              fontColor: Colors.black,
                              fontWeight: FWT.medium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              widget.data.formattedPrice!,
                              style: FontUtils.h18(
                                fontColor: Colors.black,
                                fontWeight: FWT.medium,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
                            child: Text(
                              widget.data.description ?? '',
                              style: FontUtils.h14(
                                fontColor: const Color(0xffA2A4A7),
                                fontWeight: FWT.lightMedium,
                              ),
                            ),
                          ),
                          widget.data.customizations == null ||
                                  widget.data.customizations!.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: List.generate(
                                    widget.data.customizations!.length,
                                    (index) => Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: widget
                                                          .data
                                                          .customizations?[
                                                              index]
                                                          .minChoiceOptions ==
                                                      0
                                                  ? 250.w
                                                  : 140.w,
                                              child: Text(
                                                widget
                                                        .data
                                                        .customizations?[index]
                                                        .name ??
                                                    '',
                                                style: FontUtils.h18(
                                                  fontColor: Colors.black,
                                                  fontWeight: FWT.semiBold,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            widget.data.customizations?[index]
                                                        .minChoiceOptions ==
                                                    0
                                                ? Text(
                                                    'Optional',
                                                    style: FontUtils.h12(
                                                      fontColor:
                                                          AppColors.middleGray,
                                                      fontWeight: FWT.regular,
                                                    ),
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        'Choose ${widget.data.customizations?[index].minChoiceOptions ?? 1} option',
                                                        style: FontUtils.h14(
                                                          fontColor:
                                                              Colors.black,
                                                          fontWeight:
                                                              FWT.regular,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8.w,
                                                                vertical: 4.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.coral,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          'Required',
                                                          style: FontUtils.h12(
                                                            fontColor: AppColors
                                                                .terracotta,
                                                            fontWeight:
                                                                FWT.regular,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          margin: EdgeInsets.only(bottom: 16.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffECECED),
                                                  width: 1)),
                                          child: Column(
                                            children: List.generate(
                                              widget.data.customizations![index]
                                                  .options!.length,
                                              (index1) => Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedData
                                                                .forEach(
                                                              (key, value) {
                                                                if (key ==
                                                                    widget
                                                                        .data
                                                                        .customizations![
                                                                            index]
                                                                        .name) {
                                                                  if (value.toString().contains(widget
                                                                      .data
                                                                      .customizations![
                                                                          index]
                                                                      .options![
                                                                          index1]
                                                                      .name!)) {
                                                                    value.removeWhere((element) =>
                                                                        element ==
                                                                        widget
                                                                            .data
                                                                            .customizations![index]
                                                                            .options![index1]
                                                                            .name!);

                                                                    optionsList.removeWhere((element) =>
                                                                        element[
                                                                            'option_id'] ==
                                                                        widget
                                                                            .data
                                                                            .customizations?[index]
                                                                            .options?[index1]
                                                                            .optionId);
                                                                  } else {
                                                                    if (widget
                                                                            .data
                                                                            .customizations![
                                                                                index]
                                                                            .maxChoiceOptions! <
                                                                        value.length +
                                                                            1) {
                                                                      value.removeAt(
                                                                          0);

                                                                      for (var j =
                                                                              0;
                                                                          j < widget.data.customizations![index].options!.length;
                                                                          j++) {
                                                                        for (var i =
                                                                                0;
                                                                            i < optionsList.length;
                                                                            i++) {
                                                                          print(
                                                                              'matched');
                                                                          if (widget
                                                                              .data
                                                                              .customizations![index]
                                                                              .options![j]
                                                                              .optionId!
                                                                              .contains(optionsList[i]['option_id'])) {
                                                                            optionsList.removeAt(i);

                                                                            break;
                                                                          }
                                                                        }
                                                                      }

                                                                      /// add data in option list
                                                                      optionsList
                                                                          .add({
                                                                        "option_id":
                                                                            widget.data.customizations?[index].options?[index1].optionId ??
                                                                                '',
                                                                        "quantity":
                                                                            1,
                                                                        "marked_price": widget
                                                                            .data
                                                                            .customizations?[index]
                                                                            .options?[index1]
                                                                            .price
                                                                      });

                                                                      value.add(widget
                                                                          .data
                                                                          .customizations![
                                                                              index]
                                                                          .options![
                                                                              index1]
                                                                          .name);
                                                                    } else {
                                                                      value.add(widget
                                                                          .data
                                                                          .customizations![
                                                                              index]
                                                                          .options![
                                                                              index1]
                                                                          .name);

                                                                      /// add data in option list
                                                                      optionsList
                                                                          .add({
                                                                        "option_id":
                                                                            widget.data.customizations?[index].options?[index1].optionId ??
                                                                                '',
                                                                        "quantity":
                                                                            1,
                                                                        "marked_price": widget
                                                                            .data
                                                                            .customizations?[index]
                                                                            .options?[index1]
                                                                            .price
                                                                      });
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                            );
                                                          });
                                                        },
                                                        child: Image.asset(
                                                          selectedData[widget
                                                                      .data
                                                                      .customizations![
                                                                          index]
                                                                      .name]
                                                                  .contains(widget
                                                                      .data
                                                                      .customizations![
                                                                          index]
                                                                      .options![
                                                                          index1]
                                                                      .name)
                                                              ? AssetsUtils
                                                                  .terracotaCheck
                                                              : AssetsUtils
                                                                  .greyCircle,
                                                          height: 18.h,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12.w,
                                                      ),
                                                      SizedBox(
                                                        width: 230.w,
                                                        child: Text(
                                                          widget
                                                                  .data
                                                                  .customizations?[
                                                                      index]
                                                                  .options?[
                                                                      index1]
                                                                  .name ??
                                                              '',
                                                          style: FontUtils.h15(
                                                            fontColor:
                                                                Colors.black,
                                                            fontWeight:
                                                                FWT.lightMedium,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        widget
                                                                .data
                                                                .customizations?[
                                                                    index]
                                                                .options?[
                                                                    index1]
                                                                .formattedPrice ??
                                                            '',
                                                      )
                                                    ],
                                                  ),
                                                  widget
                                                                  .data
                                                                  .customizations![
                                                                      index]
                                                                  .options!
                                                                  .length -
                                                              1 ==
                                                          index1
                                                      ? const SizedBox()
                                                      : Divider(
                                                          color: const Color(
                                                              0xffECECED),
                                                          thickness: 1,
                                                          height: 20.h,
                                                        )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          widget.data.customizations == null ||
                                  widget.data.customizations!.isEmpty
                              ? const Spacer()
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (widget.data.isAdded == true) {
                                      isAddUpdate = false;

                                      if (widget.data.cartQuantity == 1) {
                                        restaurantBloc.add(
                                            RemoveShoppingListItemEvent(
                                                productID:
                                                    widget.data.productId!));
                                      } else {
                                        if (widget.shoppingListData == null) {
                                          restaurantBloc.add(
                                            UpdateRestaurantCartEvent(
                                                updateItemList:
                                                    UpdateRestaurantItemsToShoppingListModel(
                                              unitSize: addApiData[0]
                                                  ['unitSize'],
                                              productName: addApiData[0]
                                                  ['productName'],
                                              quantity:
                                                  widget.data.cartQuantity! - 1,
                                              price: (widget.data.cartPrice! /
                                                      widget
                                                          .data.cartQuantity!) *
                                                  (widget.data.cartQuantity! -
                                                      1),
                                              productType: addApiData[0]
                                                  ['productType'],
                                              mealmeStoreId: addApiData[0]
                                                  ['mealmeStoreId'],
                                              recipeId: addApiData[0]
                                                  ['recipeId'],
                                              brandName: addApiData[0]
                                                  ['brandName'],
                                              unitOfMeasurement: addApiData[0]
                                                  ['unitOfMeasurement'],
                                              isChecked: addApiData[0]
                                                  ['isChecked'],
                                              userId: addApiData[0]['userId'],
                                              oldProductId: addApiData[0]
                                                  ['productId'],
                                              newProductId: '',
                                              itemOptions: addApiData[0]
                                                      ['options'] ??
                                                  [],
                                            )),
                                          );
                                        } else {
                                          restaurantBloc.add(
                                            UpdateRestaurantCartEvent(
                                              updateItemList:
                                                  UpdateRestaurantItemsToShoppingListModel(
                                                productName: widget
                                                        .shoppingListData!
                                                        .productName ??
                                                    '',
                                                oldProductId: widget
                                                        .shoppingListData!
                                                        .productId ??
                                                    '',
                                                newProductId: '',
                                                quantity:
                                                    widget.data.cartQuantity! -
                                                        1,
                                                price: (widget.data.cartPrice! /
                                                        widget.data
                                                            .cartQuantity!) *
                                                    (widget.data.cartQuantity! -
                                                        1),
                                                itemOptions: widget
                                                        .shoppingListData!
                                                        .options ??
                                                    [],
                                                productType: widget
                                                        .shoppingListData!
                                                        .productType ??
                                                    'Restaurant',
                                                mealmeStoreId: widget
                                                        .shoppingListData!
                                                        .mealmeStoreId ??
                                                    widget.restaurantId,
                                                unitOfMeasurement: widget
                                                        .shoppingListData!
                                                        .unitOfMeasurement ??
                                                    '',
                                                recipeId: widget
                                                        .shoppingListData!
                                                        .recipeId ??
                                                    '',
                                                userId: widget.shoppingListData!
                                                        .userId ??
                                                    userId,
                                                brandName: widget
                                                        .shoppingListData!
                                                        .brandName ??
                                                    '',
                                                isChecked: widget
                                                        .shoppingListData!
                                                        .isChecked ??
                                                    false,
                                                unitSize: widget
                                                        .shoppingListData!
                                                        .unitSize ??
                                                    0,
                                              ),
                                            ),
                                          );
                                        }
                                      }

                                      setState(() {
                                        addToCart = true;
                                      });
                                    } else {
                                      setState(() {
                                        item--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: size.height * 0.060,
                                    width: size.height * 0.060,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: AppColors.terracotta)),
                                    child: Center(
                                      child: widget.data.isRemoveUpdated == true
                                          ? Transform.scale(
                                              scale: 0.5,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: AppColors.terracotta,
                                              ),
                                            )
                                          : widget.data.cartQuantity == 1
                                              ? SvgPicture.asset(
                                                  AssetsUtils.icDelete,
                                                  color: AppColors.terracotta,
                                                )
                                              : const Icon(
                                                  Icons.remove,
                                                  color: AppColors.terracotta,
                                                ),
                                    ),
                                    // child: const Center(child: Icon(Icons.remove, size: 27)),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  height: size.height * 0.060,
                                  width: size.height * 0.060,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.disable),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                      child: Text(
                                    '$item',
                                    style: FontUtils.h18(
                                        fontWeight: FWT.semiBold,
                                        fontColor: AppColors.darkGray),
                                  )),
                                ),
                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: () {
                                    if (widget.data.isAdded == true) {
                                      isAddUpdate = true;

                                      if (widget.shoppingListData == null) {
                                        restaurantBloc.add(
                                          UpdateRestaurantCartEvent(
                                              updateItemList:
                                                  UpdateRestaurantItemsToShoppingListModel(
                                            unitSize: addApiData[0]['unitSize'],
                                            productName: addApiData[0]
                                                ['productName'],
                                            price: (widget.data.cartPrice! /
                                                    widget.data.cartQuantity!) *
                                                (widget.data.cartQuantity! + 1),
                                            productType: addApiData[0]
                                                ['productType'],
                                            mealmeStoreId: addApiData[0]
                                                ['mealmeStoreId'],
                                            recipeId: addApiData[0]['recipeId'],
                                            brandName: addApiData[0]
                                                ['brandName'],
                                            unitOfMeasurement: addApiData[0]
                                                ['unitOfMeasurement'],
                                            isChecked: addApiData[0]
                                                ['isChecked'],
                                            userId: addApiData[0]['userId'],
                                            oldProductId: addApiData[0]
                                                ['productId'],
                                            quantity:
                                                widget.data.cartQuantity! + 1,
                                            newProductId: '',
                                            itemOptions:
                                                addApiData[0]['options'] ?? [],
                                          )),
                                        );
                                      } else {
                                        restaurantBloc.add(
                                          UpdateRestaurantCartEvent(
                                            updateItemList:
                                                UpdateRestaurantItemsToShoppingListModel(
                                              productName: widget
                                                      .shoppingListData!
                                                      .productName ??
                                                  '',
                                              oldProductId: widget
                                                      .shoppingListData!
                                                      .productId ??
                                                  '',
                                              newProductId: '',
                                              quantity:
                                                  widget.data.cartQuantity! + 1,
                                              price: (widget.data.cartPrice! /
                                                      widget
                                                          .data.cartQuantity!) *
                                                  (widget.data.cartQuantity! +
                                                      1),
                                              itemOptions: widget
                                                      .shoppingListData!
                                                      .options ??
                                                  [],
                                              productType: widget
                                                      .shoppingListData!
                                                      .productType ??
                                                  'Restaurant',
                                              mealmeStoreId: widget
                                                      .shoppingListData!
                                                      .mealmeStoreId ??
                                                  widget.restaurantId,
                                              unitOfMeasurement: widget
                                                      .shoppingListData!
                                                      .unitOfMeasurement ??
                                                  '',
                                              recipeId: widget.shoppingListData!
                                                      .recipeId ??
                                                  '',
                                              userId: widget.shoppingListData!
                                                      .userId ??
                                                  userId,
                                              brandName: widget
                                                      .shoppingListData!
                                                      .brandName ??
                                                  '',
                                              isChecked: widget
                                                      .shoppingListData!
                                                      .isChecked ??
                                                  false,
                                              unitSize: widget.shoppingListData!
                                                      .unitSize ??
                                                  0,
                                            ),
                                          ),
                                        );
                                      }

                                      setState(() {
                                        addToCart = true;
                                      });
                                    } else {
                                      setState(() {
                                        item++;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: size.height * 0.060,
                                    width: size.height * 0.060,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: AppColors.coral,
                                    ),
                                    child: Center(
                                      child: widget.data.isAddUpdated == true
                                          ? Transform.scale(
                                              scale: 0.5,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: AppColors.terracotta,
                                              ))
                                          : const Icon(
                                              Icons.add,
                                              size: 27,
                                              color: AppColors.terracotta,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isAdding == true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : RestaurantMealAddButtonWidget(
                                  onTap: () {
                                    if (widget.data.isAdded == false) {
                                      if (item > 0) {
                                        price = widget.data.originalPrice;

                                        if (price == 0) {
                                          for (var element in optionsList) {
                                            price =
                                                price + element['marked_price'];
                                          }

                                          price = price * item;
                                        } else {
                                          price = price * item;

                                          for (var element in optionsList) {
                                            price =
                                                price + element['marked_price'];
                                          }
                                        }

                                        // log('--edwd--->>>>>${{
                                        //   'productName': widget.data.name ?? '',
                                        //   'productId':
                                        //       widget.data.productId ?? '',
                                        //   'price': price,
                                        //   'quantity': item,
                                        //   'options': optionsList,
                                        //   'mealmeStoreId': widget.restaurantId,
                                        //   'productType': 'Restaurant',
                                        //   'isChecked': false,
                                        // }}');

                                        restaurantBloc.add(
                                          AddRestaurantCartEvent(
                                            addItemsList: [
                                              AddRestaurantItemsToShoppingListModel(
                                                productId:
                                                    widget.data.productId ?? '',
                                                productName:
                                                    widget.data.name ?? '',
                                                quantity: item,
                                                price: price,
                                                options: optionsList,
                                                mealmeStoreId:
                                                    widget.restaurantId,
                                                productType: 'Restaurant',
                                                isChecked: false,
                                                recipeId: '',
                                                unitOfMeasurement: '',
                                                unitSize: 0,
                                                brandName: '',
                                              ),
                                            ],
                                          ),
                                        );

                                        setState(() {
                                          addToCart = true;
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Please Select One Item',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    } else {
                                      Get.to(
                                        () => RestaurantCart(data: {
                                          'image': AssetsUtils.restaurantFood1,
                                          'title': widget.data.name!,
                                          'price': widget.data.formattedPrice!,
                                          'count': item
                                        }),
                                        // transition: Transition.fadeIn,
                                      );
                                    }
                                  },
                                  buttonLable: widget.data.isAdded == true
                                      ? 'View Cart'
                                      : 'Add to cart',
                                  isFillColor: true,
                                  selectedItemCount: widget.data.cartQuantity!,
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Image.asset(
                              AssetsUtils.gymEatsSpoon,
                              height: 22.h,
                              width: 56.w,
                              color: AppColors.terracotta,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
