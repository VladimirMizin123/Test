import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
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
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class RestaurantMenuDetailsScreen extends StatefulWidget {
  const RestaurantMenuDetailsScreen({
    super.key,
    required this.data,
    required this.restaurantId,
    this.shoppingListData,
    required this.cartCount,
    required this.pickUp,
    this.onCustomizationChange,
  });
  final MenuItemList data;
  final String restaurantId;
  final ShoppingListData? shoppingListData;
  final int cartCount;
  final bool pickUp;
  final Function(List<Customization>)? onCustomizationChange;

  @override
  State<RestaurantMenuDetailsScreen> createState() =>
      _RestaurantMenuDetailsScreenState();
}

class _RestaurantMenuDetailsScreenState
    extends State<RestaurantMenuDetailsScreen> {
  int item = 0;
  dynamic price = 0;
  int cartCount = 0;
  bool selectFirst = false;
  bool selectSecond = false;
  bool isAddUpdate = false;
  bool customizationChange = false;
  Map<String, dynamic> selectedData = {};
  List selectedOption = [];
  List data = [];
  List addApiData = [];
  List<Map<String, dynamic>> optionsList = [];
  List<Map<String, dynamic>> secondOptionsList = [];
  ShoppingListData? shoppingListData;
  List<Customization> customizationList = [];

  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool addToCart = false;
  bool isAdding = false;
  bool loading = false;

  getData() async {
    selectedOption.clear();
    secondOptionsList.clear();
    optionsList.clear();
    for (Customization element in customizationList) {
      selectedData.addAll(
        {
          element.name!: [],
          'isRequired': element.minChoiceOptions,
        },
      );
    }
    if (shoppingListData != null) {
      for (var element in shoppingListData!.options!) {
        selectedOption.add(element.optionId);
      }
    }
    item = widget.data.cartQuantity!;
  }

  void _handleCustomization() {
    if (customizationList.isEmpty &&
        (widget.data.shouldFetchCustomizations ?? false)) {
      restaurantBloc.add(FetchCustomizationEvent(
        productId: widget.data.productId ?? "",
        callback: (menu) {
          customizationList = menu.customizations ?? [];
          widget.onCustomizationChange?.call(customizationList);
          setState(() {});
          log(customizationList.length.toString());
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    shoppingListData = widget.shoppingListData;
    cartCount = widget.cartCount;
    customizationList = widget.data.customizations ?? [];
    getData();
    _handleCustomization();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        body: bloc.BlocConsumer(
          bloc: restaurantBloc,
          listener: (context, state) {
            if (state is AddToRestaurantCartLoadingState) {
              if (customizationChange == false) {
                isAdding = true;
              } else {
                if (state.productId == widget.data.productId) {
                  if (isAddUpdate == true) {
                    widget.data.isAddUpdated = true;
                  } else {
                    widget.data.isRemoveUpdated = true;
                  }
                }
              }
            }
            if (state is AddToRestaurantCartSuccessState) {
              widget.data.cartQuantity = state.data[0]['quantity'];
              widget.data.cartPrice = state.data[0]['price'];
              widget.data.isAdded = true;

              isAdding = false;

              addApiData = state.data;

              cartCount = cartCount + 1;

              if (state.data[0]['productId'] == widget.data.productId) {
                item = state.data[0]['quantity'];
                if (isAddUpdate == true) {
                  widget.data.isAddUpdated = false;
                } else {
                  widget.data.isRemoveUpdated = false;
                }
                isAddUpdate = false;
              }

              customizationChange = false;
            }
            if (state is AddToRestaurantCartErrorState) {
              if (customizationChange == false) {
                isAdding = false;
              } else {
                if (state.productId == widget.data.productId) {
                  if (isAddUpdate == true) {
                    widget.data.isAddUpdated = true;
                  } else {
                    widget.data.isRemoveUpdated = true;
                  }
                }
                customizationChange = false;
              }
            }

            ///Update To RestaurantCart State ====================================================================

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
              cartCount = cartCount - 1;

              if (customizationChange == true) {
                price = widget.data.originalPrice;

                isAddUpdate == true
                    ? item = widget.data.cartQuantity! + 1
                    : item = widget.data.cartQuantity! - 1;

                if (price == 0) {
                  for (var element in secondOptionsList) {
                    price = price + element['marked_price'];
                  }

                  isAddUpdate == true
                      ? price = price * item
                      : price = price * item;
                } else {
                  isAddUpdate == true
                      ? price = price * item
                      : price = price * item;

                  for (var element in secondOptionsList) {
                    price = price + element['marked_price'];
                  }
                }

                restaurantBloc.add(
                  AddRestaurantCartEvent(
                    addItemsList: [
                      AddRestaurantItemsToShoppingListModel(
                        productId: widget.data.productId ?? '',
                        productName: widget.data.name ?? '',
                        quantity: item,
                        price: price,
                        options: secondOptionsList,
                        mealmeStoreId: widget.restaurantId,
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
              } else {
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
              }
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

            /// Get SHopping List State ==========================================================================

            if (state is GetShoppingListSuccessState) {
              if (state.shoppingListData!.isEmpty) {
                widget.data.cartQuantity = 0;
                widget.data.cartPrice = 0;
                widget.data.isAdded = false;
                selectedOption.clear();
                secondOptionsList.clear();
                optionsList.clear();
                getData();
                item = 0;
              } else {
                for (var element in state.shoppingListData!) {
                  if (element.productId == widget.data.productId) {
                    shoppingListData = element;
                    widget.data.cartQuantity = element.quantity;
                    widget.data.cartPrice = element.price;
                    item = element.quantity!;
                    getData();
                  }
                }
              }
              loading = false;
            }

            if (state is GetShoppingListLoadingState) {
              loading = true;
            }
            if (state is GetShoppingListErrorState) {
              loading = false;
            }
          },
          builder: (context, state) {
            return loading == true
                ? const Align(
                    alignment: Alignment.center,
                    child: AppCenterLoader(),
                  )
                : SingleChildScrollView(
                    child: Column(
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
                            height: customizationList.isEmpty
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    widget.data.formattedPrice!,
                                    style: FontUtils.h18(
                                      fontColor: Colors.black,
                                      fontWeight: FWT.medium,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 10.w, bottom: 10.h),
                                  child: Text(
                                    widget.data.description ?? '',
                                    style: FontUtils.h14(
                                      fontColor: const Color(0xffA2A4A7),
                                      fontWeight: FWT.lightMedium,
                                    ),
                                  ),
                                ),
                                bloc.BlocBuilder(
                                  bloc: restaurantBloc,
                                  builder: (context, state) {
                                    return state
                                            is FetchCustomizationLoaderState
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AppCenterLoader(),
                                            ],
                                          ).paddingOnly(top: 20, bottom: 20)
                                        : const SizedBox.shrink();
                                  },
                                ),
                                customizationList.isEmpty
                                    ? const SizedBox()
                                    : Column(
                                        children: List.generate(
                                          customizationList.length,
                                          (index) => Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: customizationList[
                                                                    index]
                                                                .minChoiceOptions ==
                                                            0
                                                        ? 250.w
                                                        : 140.w,
                                                    child: Text(
                                                      customizationList[index]
                                                              .name ??
                                                          '',
                                                      style: FontUtils.h18(
                                                        fontColor: Colors.black,
                                                        fontWeight:
                                                            FWT.semiBold,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  customizationList[index]
                                                              .minChoiceOptions ==
                                                          0
                                                      ? Text(
                                                          'Optional',
                                                          style: FontUtils.h12(
                                                            fontColor: AppColors
                                                                .middleGray,
                                                            fontWeight:
                                                                FWT.regular,
                                                          ),
                                                        )
                                                      : Row(
                                                          children: [
                                                            Text(
                                                              'Choose ${customizationList[index].minChoiceOptions ?? 1} option',
                                                              style:
                                                                  FontUtils.h14(
                                                                fontColor:
                                                                    Colors
                                                                        .black,
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
                                                                      horizontal:
                                                                          8.w,
                                                                      vertical:
                                                                          4.h),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .coral,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Text(
                                                                'Required',
                                                                style: FontUtils
                                                                    .h12(
                                                                  fontColor:
                                                                      AppColors
                                                                          .terracotta,
                                                                  fontWeight: FWT
                                                                      .regular,
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
                                                padding:
                                                    const EdgeInsets.all(12),
                                                margin: EdgeInsets.only(
                                                    bottom: 16.h),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffECECED),
                                                        width: 1)),
                                                child: Column(
                                                  children: List.generate(
                                                    customizationList[index]
                                                        .options!
                                                        .length,
                                                    (index1) => Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                log('widget.data.isAdded---------->>>>>> ${widget.data.isAdded}');

                                                                log('customizationChange---------->>>>>> $customizationChange');

                                                                if (widget.data
                                                                        .isAdded ==
                                                                    true) {
                                                                  selectedOption
                                                                      .clear();

                                                                  customizationChange =
                                                                      true;
                                                                }

                                                                setState(() {
                                                                  selectedData
                                                                      .forEach(
                                                                    (key,
                                                                        value) {
                                                                      if (key ==
                                                                          customizationList[index]
                                                                              .name) {
                                                                        if (value
                                                                            .toString()
                                                                            .contains(customizationList[index].options![index1].name!)) {
                                                                          value.removeWhere((element) =>
                                                                              element ==
                                                                              customizationList[index].options![index1].name!);

                                                                          widget.data.isAdded == true
                                                                              ? secondOptionsList.removeWhere((element) => element['option_id'] == customizationList[index].options?[index1].optionId)
                                                                              : optionsList.removeWhere((element) => element['option_id'] == customizationList[index].options?[index1].optionId);
                                                                        } else {
                                                                          if (customizationList[index].maxChoiceOptions! <
                                                                              value.length + 1) {
                                                                            value.removeAt(0);

                                                                            if (widget.data.isAdded ==
                                                                                true) {
                                                                              for (var j = 0; j < customizationList[index].options!.length; j++) {
                                                                                for (var i = 0; i < secondOptionsList.length; i++) {
                                                                                  if (customizationList[index].options![j].optionId!.contains(secondOptionsList[i]['option_id'])) {
                                                                                    secondOptionsList.removeAt(i);

                                                                                    break;
                                                                                  }
                                                                                }
                                                                              }

                                                                              secondOptionsList.add({
                                                                                "option_id": customizationList[index].options?[index1].optionId ?? '',
                                                                                "quantity": 1,
                                                                                "marked_price": customizationList[index].options?[index1].price
                                                                              });
                                                                            } else {
                                                                              for (var j = 0; j < customizationList[index].options!.length; j++) {
                                                                                for (var i = 0; i < optionsList.length; i++) {
                                                                                  if (customizationList[index].options![j].optionId!.contains(optionsList[i]['option_id'])) {
                                                                                    optionsList.removeAt(i);

                                                                                    break;
                                                                                  }
                                                                                }
                                                                              }

                                                                              optionsList.add({
                                                                                "option_id": customizationList[index].options?[index1].optionId ?? '',
                                                                                "quantity": 1,
                                                                                "marked_price": customizationList[index].options?[index1].price
                                                                              });
                                                                            }

                                                                            value.add(customizationList[index].options![index1].name);
                                                                          } else {
                                                                            value.add(customizationList[index].options![index1].name);

                                                                            widget.data.isAdded == true
                                                                                ? secondOptionsList.add({
                                                                                    "option_id": customizationList[index].options?[index1].optionId ?? '',
                                                                                    "quantity": 1,
                                                                                    "marked_price": customizationList[index].options?[index1].price
                                                                                  })
                                                                                :

                                                                                /// add data in option list
                                                                                optionsList.add({
                                                                                    "option_id": customizationList[index].options?[index1].optionId ?? '',
                                                                                    "quantity": 1,
                                                                                    "marked_price": customizationList[index].options?[index1].price
                                                                                  });
                                                                          }
                                                                        }
                                                                      }
                                                                    },
                                                                  );
                                                                });
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                (selectedData[customizationList[index].name]?.contains(customizationList[index].options![index1].name) ??
                                                                            false) ||
                                                                        selectedOption.contains(customizationList[index]
                                                                            .options![
                                                                                index1]
                                                                            .optionId)
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
                                                                customizationList[
                                                                            index]
                                                                        .options?[
                                                                            index1]
                                                                        .name ??
                                                                    '',
                                                                style: FontUtils
                                                                    .h15(
                                                                  fontColor:
                                                                      Colors
                                                                          .black,
                                                                  fontWeight: FWT
                                                                      .lightMedium,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              customizationList[
                                                                          index]
                                                                      .options?[
                                                                          index1]
                                                                      .formattedPrice ??
                                                                  '',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          ],
                                                        ),
                                                        customizationList[index]
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
                                customizationList.isEmpty
                                    ? const Spacer()
                                    : const SizedBox(),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          bool isSelected = false;
                                          if (widget.data.isAdded == true) {
                                            isAddUpdate = false;

                                            if (widget.data.cartQuantity == 1) {
                                              restaurantBloc.add(
                                                  RemoveShoppingListItemEvent(
                                                      productID: widget
                                                          .data.productId!));
                                            } else {
                                              if (shoppingListData == null) {
                                                for (var element in widget
                                                    .data.customizations!) {
                                                  if (selectedData[element.name]
                                                              .length >=
                                                          element
                                                              .minChoiceOptions &&
                                                      selectedData[element.name]
                                                              .length <=
                                                          element
                                                              .maxChoiceOptions) {
                                                  } else {
                                                    isSelected = true;
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          'Please Select Required Item',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                  }
                                                }

                                                if (isSelected == false) {
                                                  restaurantBloc.add(
                                                    UpdateRestaurantCartEvent(
                                                        updateItemList:
                                                            UpdateRestaurantItemsToShoppingListModel(
                                                      unitSize: addApiData[0]
                                                          ['unitSize'],
                                                      productName: addApiData[0]
                                                          ['productName'],
                                                      quantity: widget.data
                                                              .cartQuantity! -
                                                          1,
                                                      price: (widget.data
                                                                  .cartPrice! /
                                                              widget.data
                                                                  .cartQuantity!) *
                                                          (widget.data
                                                                  .cartQuantity! -
                                                              1),
                                                      productType: addApiData[0]
                                                          ['productType'],
                                                      mealmeStoreId:
                                                          addApiData[0]
                                                              ['mealmeStoreId'],
                                                      recipeId: addApiData[0]
                                                          ['recipeId'],
                                                      brandName: addApiData[0]
                                                          ['brandName'],
                                                      unitOfMeasurement:
                                                          addApiData[0][
                                                              'unitOfMeasurement'],
                                                      isChecked: addApiData[0]
                                                          ['isChecked'],
                                                      userId: addApiData[0]
                                                          ['userId'],
                                                      oldProductId:
                                                          addApiData[0]
                                                              ['productId'],
                                                      newProductId: '',
                                                      itemOptions: [],
                                                    )),
                                                  );
                                                }
                                              } else {
                                                if (customizationChange ==
                                                    true) {
                                                  restaurantBloc.add(
                                                    RemoveShoppingListItemEvent(
                                                        productID: widget
                                                            .shoppingListData!
                                                            .productId!),
                                                  );
                                                } else {
                                                  for (var element
                                                      in customizationList) {
                                                    if (selectedData[element
                                                                    .name]
                                                                .length >=
                                                            element
                                                                .minChoiceOptions &&
                                                        selectedData[element
                                                                    .name]
                                                                .length <=
                                                            element
                                                                .maxChoiceOptions) {
                                                    } else {
                                                      isSelected = true;
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'Please Select Required Item',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                            Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    }
                                                  }

                                                  if (isSelected == false) {
                                                    restaurantBloc.add(
                                                      UpdateRestaurantCartEvent(
                                                        updateItemList:
                                                            UpdateRestaurantItemsToShoppingListModel(
                                                          productName:
                                                              shoppingListData!
                                                                      .productName ??
                                                                  '',
                                                          oldProductId:
                                                              shoppingListData!
                                                                      .productId ??
                                                                  '',
                                                          newProductId: '',
                                                          quantity: widget.data
                                                                  .cartQuantity! -
                                                              1,
                                                          price: (widget.data
                                                                      .cartPrice! /
                                                                  widget.data
                                                                      .cartQuantity!) *
                                                              (widget.data
                                                                      .cartQuantity! -
                                                                  1),
                                                          itemOptions: [],
                                                          productType:
                                                              shoppingListData!
                                                                      .productType ??
                                                                  'Restaurant',
                                                          mealmeStoreId:
                                                              shoppingListData!
                                                                      .mealmeStoreId ??
                                                                  widget
                                                                      .restaurantId,
                                                          unitOfMeasurement:
                                                              shoppingListData!
                                                                      .unitOfMeasurement ??
                                                                  '',
                                                          recipeId:
                                                              shoppingListData!
                                                                      .recipeId ??
                                                                  '',
                                                          userId:
                                                              shoppingListData!
                                                                      .userId ??
                                                                  userId,
                                                          brandName:
                                                              shoppingListData!
                                                                      .brandName ??
                                                                  '',
                                                          isChecked:
                                                              shoppingListData!
                                                                      .isChecked ??
                                                                  false,
                                                          unitSize:
                                                              shoppingListData!
                                                                      .unitSize ??
                                                                  0,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            }

                                            addToCart = true;
                                          } else {
                                            if (item > 0) {
                                              item--;
                                            }
                                          }
                                          setState(() {
                                            addToCart = true;
                                          });
                                        },
                                        child: Container(
                                          height: size.height * 0.060,
                                          width: size.height * 0.060,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: AppColors.terracotta)),
                                          child: Center(
                                            child: widget
                                                        .data.isRemoveUpdated ==
                                                    true
                                                ? Transform.scale(
                                                    scale: 0.5,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color:
                                                          AppColors.terracotta,
                                                    ),
                                                  )
                                                : widget.data.cartQuantity == 1
                                                    ? SvgPicture.asset(
                                                        AssetsUtils.icDelete,
                                                        color: AppColors
                                                            .terracotta,
                                                      )
                                                    : const Icon(
                                                        Icons.remove,
                                                        color: AppColors
                                                            .terracotta,
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
                                          border: Border.all(
                                              color: AppColors.disable),
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                          bool isSelected = false;
                                          if (widget.data.isAdded == true) {
                                            isAddUpdate = true;

                                            if (shoppingListData == null) {
                                              for (var element
                                                  in customizationList) {
                                                if (selectedData[element.name]
                                                            .length >=
                                                        element
                                                            .minChoiceOptions &&
                                                    selectedData[element.name]
                                                            .length <=
                                                        element
                                                            .maxChoiceOptions) {
                                                } else {
                                                  isSelected = true;
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'Please Select Required Item',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                              }

                                              if (isSelected == false) {
                                                restaurantBloc.add(
                                                  UpdateRestaurantCartEvent(
                                                      updateItemList:
                                                          UpdateRestaurantItemsToShoppingListModel(
                                                    unitSize: addApiData[0]
                                                        ['unitSize'],
                                                    productName: addApiData[0]
                                                        ['productName'],
                                                    price: (widget.data
                                                                .cartPrice! /
                                                            widget.data
                                                                .cartQuantity!) *
                                                        (widget.data
                                                                .cartQuantity! +
                                                            1),
                                                    productType: addApiData[0]
                                                        ['productType'],
                                                    mealmeStoreId: addApiData[0]
                                                        ['mealmeStoreId'],
                                                    recipeId: addApiData[0]
                                                        ['recipeId'],
                                                    brandName: addApiData[0]
                                                        ['brandName'],
                                                    unitOfMeasurement:
                                                        addApiData[0][
                                                            'unitOfMeasurement'],
                                                    isChecked: addApiData[0]
                                                        ['isChecked'],
                                                    userId: addApiData[0]
                                                        ['userId'],
                                                    oldProductId: addApiData[0]
                                                        ['productId'],
                                                    quantity: widget.data
                                                            .cartQuantity! +
                                                        1,
                                                    newProductId: '',
                                                    itemOptions: [],
                                                  )),
                                                );
                                              }
                                            } else {
                                              if (customizationChange == true) {
                                                for (var element in widget
                                                    .data.customizations!) {
                                                  if (selectedData[element.name]
                                                              .length >=
                                                          element
                                                              .minChoiceOptions &&
                                                      selectedData[element.name]
                                                              .length <=
                                                          element
                                                              .maxChoiceOptions) {
                                                  } else {
                                                    isSelected = true;
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          'Please Select Required Item',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                  }
                                                }

                                                if (isSelected == false) {
                                                  restaurantBloc.add(
                                                    RemoveShoppingListItemEvent(
                                                        productID: widget
                                                            .shoppingListData!
                                                            .productId!),
                                                  );
                                                }
                                              } else {
                                                for (var element
                                                    in customizationList) {
                                                  if (selectedData[element.name]
                                                              .length >=
                                                          element
                                                              .minChoiceOptions &&
                                                      selectedData[element.name]
                                                              .length <=
                                                          element
                                                              .maxChoiceOptions) {
                                                  } else {
                                                    isSelected = true;
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          'Please Select Required Item',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                  }
                                                }

                                                if (isSelected == false) {
                                                  restaurantBloc.add(
                                                    UpdateRestaurantCartEvent(
                                                      updateItemList:
                                                          UpdateRestaurantItemsToShoppingListModel(
                                                        productName:
                                                            shoppingListData!
                                                                    .productName ??
                                                                '',
                                                        oldProductId:
                                                            shoppingListData!
                                                                    .productId ??
                                                                '',
                                                        newProductId: '',
                                                        quantity: widget.data
                                                                .cartQuantity! +
                                                            1,
                                                        price: (widget.data
                                                                    .cartPrice! /
                                                                widget.data
                                                                    .cartQuantity!) *
                                                            (widget.data
                                                                    .cartQuantity! +
                                                                1),
                                                        itemOptions: [],
                                                        productType:
                                                            shoppingListData!
                                                                    .productType ??
                                                                'Restaurant',
                                                        mealmeStoreId:
                                                            shoppingListData!
                                                                    .mealmeStoreId ??
                                                                widget
                                                                    .restaurantId,
                                                        unitOfMeasurement:
                                                            shoppingListData!
                                                                    .unitOfMeasurement ??
                                                                '',
                                                        recipeId:
                                                            shoppingListData!
                                                                    .recipeId ??
                                                                '',
                                                        userId:
                                                            shoppingListData!
                                                                    .userId ??
                                                                userId,
                                                        brandName:
                                                            shoppingListData!
                                                                    .brandName ??
                                                                '',
                                                        isChecked:
                                                            shoppingListData!
                                                                    .isChecked ??
                                                                false,
                                                        unitSize:
                                                            shoppingListData!
                                                                    .unitSize ??
                                                                0,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
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
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: AppColors.coral,
                                          ),
                                          child: Center(
                                            child: widget.data.isAddUpdated ==
                                                    true
                                                ? Transform.scale(
                                                    scale: 0.5,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color:
                                                          AppColors.terracotta,
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
                                        child: CircularProgressIndicator())
                                    : RestaurantMealAddButtonWidget(
                                        onTap: () {
                                          if (state ==
                                              FetchCustomizationLoaderState) {
                                            showToast(
                                              message:
                                                  'Please wait for customization',
                                              isSuccess: false,
                                              color: Colors.black,
                                            );
                                            return;
                                          }
                                          bool isSelected = false;
                                          if (widget.data.isAdded == false) {
                                            if (item > 0) {
                                              for (var element in widget
                                                  .data.customizations!) {
                                                if (selectedData[element.name]
                                                            .length >=
                                                        element
                                                            .minChoiceOptions &&
                                                    selectedData[element.name]
                                                            .length <=
                                                        element
                                                            .maxChoiceOptions) {
                                                } else {
                                                  isSelected = true;
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'Please Select Required Item',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                              }

                                              if (isSelected == false) {
                                                price =
                                                    widget.data.originalPrice;

                                                if (price == 0) {
                                                  for (var element
                                                      in optionsList) {
                                                    price = price +
                                                        element['marked_price'];
                                                  }

                                                  price = price * item;
                                                } else {
                                                  price = price * item;

                                                  for (var element
                                                      in optionsList) {
                                                    price = price +
                                                        element['marked_price'];
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
                                                        productId: widget.data
                                                                .productId ??
                                                            '',
                                                        productName:
                                                            widget.data.name ??
                                                                '',
                                                        quantity: item,
                                                        price: price,
                                                        options: optionsList,
                                                        mealmeStoreId:
                                                            widget.restaurantId,
                                                        productType:
                                                            'Restaurant',
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
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: 'Please Select One Item',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                          } else {
                                            Get.to(
                                              () => RestaurantCart(
                                                  pickUp: widget.pickUp),
                                              transition: Transition.fadeIn,
                                            )!
                                                .then((value) {
                                              if (value == true) {
                                                restaurantBloc.add(
                                                    GetShoppingListEvent());
                                              }
                                            });
                                          }
                                        },
                                        buttonLable: widget.data.isAdded == true
                                            ? 'View Cart'
                                            : 'Add to cart',
                                        isFillColor: true,
                                        selectedItemCount:
                                            widget.data.isAdded == true
                                                ? cartCount
                                                : 0,
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
                    ),
                  );
          },
        ),
      ),
    );
  }
}
