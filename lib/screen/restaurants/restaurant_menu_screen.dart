import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/filter_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/update_cart_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_Add_button.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_details_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_details_screen.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({
    super.key,
    this.restaurantName,
    required this.restaurantId,
    required this.pickup,
    required this.mealType,
  });
  final String? restaurantName;
  final String restaurantId;
  final String mealType;
  final bool pickup;

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  List selectedTabData = [];

  List mealType = [
    'I can eat',
    'Price',
  ];

  int select = 0;
  int cartCount = 0;

  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool loading = false;
  bool loading1 = false;
  bool isAddUpdate = false;
  bool isRemoveUpdate = false;
  String priceValue = '';
  RestaurantMenu? restaurantMenu;
  List<ShoppingListData> cartData = [];
  ShoppingListData? selectedCartData;
  List<MenuItemList> menuItem = [];
  bool hasCartData = false;

  @override
  void initState() {
    super.initState();

    restaurantBloc.add(
      GetRestaurantMenuListEvent(
        widget.restaurantId,
        widget.pickup,
        widget.mealType,
      ),
    );

    restaurantBloc.add(GetShoppingListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: bloc.BlocConsumer(
          bloc: restaurantBloc,
          listener: (context, state) {
            ///GetRestaurantMenuList State ====================================================================

            if (state is GetRestaurantMenuListLoadingState) {
              loading = true;
            }
            if (state is GetRestaurantMenuListSuccessState) {
              restaurantMenu = state.restaurantMenuList;
              cartCount = 0;
              for (var i = 0; i < restaurantMenu!.categories!.length; i++) {
                for (var j = 0;
                    j < restaurantMenu!.categories![i].menuItemList!.length;
                    j++) {
                  for (var k = 0; k < cartData.length; k++) {
                    if (cartData[k].productId ==
                        restaurantMenu!
                            .categories![i].menuItemList![j].productId) {
                      restaurantMenu!.categories![i].menuItemList![j]
                          .cartQuantity = cartData[k].quantity;
                      restaurantMenu!.categories![i].menuItemList![j]
                          .cartPrice = cartData[k].price;
                      restaurantMenu!.categories![i].menuItemList![j].isAdded =
                          true;

                      hasCartData = true;
                      cartCount++;
                    }
                  }
                }
              }
              loading = false;
            }
            if (state is GetRestaurantMenuListErrorState) {
              loading = false;
            }

            ///GetShoppingList State ====================================================================

            if (state is GetShoppingListLoadingState) {
              loading1 = true;
            }
            if (state is GetShoppingListSuccessState) {
              cartData.clear();
              cartData = state.shoppingListData!;

              if (restaurantMenu != null) {
                cartCount = 0;
                for (var i = 0; i < restaurantMenu!.categories!.length; i++) {
                  for (var j = 0;
                      j < restaurantMenu!.categories![i].menuItemList!.length;
                      j++) {
                    for (var k = 0; k < cartData.length; k++) {
                      if (cartData[k].productId ==
                          restaurantMenu!
                              .categories![i].menuItemList![j].productId) {
                        restaurantMenu!.categories![i].menuItemList![j]
                            .cartQuantity = cartData[k].quantity;
                        restaurantMenu!.categories![i].menuItemList![j]
                            .cartPrice = cartData[k].price;
                        restaurantMenu!
                            .categories![i].menuItemList![j].isAdded = true;

                        hasCartData = true;
                        cartCount++;
                      }
                    }
                  }
                }
              }

              loading1 = false;
            }
            if (state is GetShoppingListErrorState) {
              loading1 = false;
            }

            ///UpdateToRestaurantCart State ====================================================================

            if (state is UpdateToRestaurantCartSuccessState) {
              for (var element in restaurantMenu!.categories!) {
                for (var element1 in element.menuItemList!) {
                  if (state.data['productId'] == element1.productId) {
                    element1.cartQuantity = state.data['quantity'];
                    element1.cartPrice = state.data['price'];

                    if (isAddUpdate == true) {
                      element1.isAddUpdated = false;
                    } else {
                      element1.isRemoveUpdated = false;
                    }

                    isAddUpdate = false;
                  }
                }
              }
            }

            if (state is UpdateToRestaurantCartLoadingState) {
              for (var element in restaurantMenu!.categories!) {
                for (var element1 in element.menuItemList!) {
                  if (state.productId == element1.productId) {
                    if (isAddUpdate == true) {
                      element1.isAddUpdated = true;
                    } else {
                      element1.isRemoveUpdated = true;
                    }
                  }
                }
              }
            }

            if (state is UpdateToRestaurantCartErrorState) {
              for (var element in restaurantMenu!.categories!) {
                for (var element1 in element.menuItemList!) {
                  if (state.productId == element1.productId) {
                    if (isAddUpdate == true) {
                      element1.isAddUpdated = false;
                    } else {
                      element1.isRemoveUpdated = false;
                    }

                    isAddUpdate = false;
                  }
                }
              }
            }

            ///Remove To RestaurantCart State ====================================================================

            if (state is RemoveShoppingListItemSuccessState) {
              for (var element in restaurantMenu!.categories!) {
                for (var element1 in element.menuItemList!) {
                  if (state.productId == element1.productId) {
                    element1.cartQuantity = 0;
                    element1.cartPrice = 0;

                    if (isAddUpdate == true) {
                      element1.isAddUpdated = false;
                    } else {
                      element1.isRemoveUpdated = false;
                    }
                    element1.isAdded = false;
                    isAddUpdate = false;
                    restaurantBloc.add(GetShoppingListEvent());
                  }
                }
              }
            }

            if (state is RemoveShoppingListItemLoadingState) {
              for (var element in restaurantMenu!.categories!) {
                for (var element1 in element.menuItemList!) {
                  if (state.productId == element1.productId) {
                    if (isAddUpdate == true) {
                      element1.isAddUpdated = true;
                    } else {
                      element1.isRemoveUpdated = true;
                    }
                  }
                }
              }
            }

            if (state is RemoveShoppingListItemErrorState) {
              for (var element in restaurantMenu!.categories!) {
                for (var element1 in element.menuItemList!) {
                  if (state.productId == element1.productId) {
                    if (isAddUpdate == true) {
                      element1.isAddUpdated = false;
                    } else {
                      element1.isRemoveUpdated = false;
                    }

                    isAddUpdate = false;
                  }
                }
              }
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Center(
                  child: Image.asset(
                    AssetsUtils.gymEatsSpoon,
                    height: 22.h,
                    width: 56.w,
                    color: AppColors.terracotta,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 8, bottom: 20.h, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                        ),
                      ),
                      SizedBox(
                        width: 270.w,
                        child: Text(
                          '${widget.restaurantName} Menu',
                          style: const TextStyle(
                            color: Color(0xFF010101),
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                ),
                loading == true || loading1 == true
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              top: 20, left: 16, right: 16),
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Shimmer.fromColors(
                                baseColor: AppColors.disable.withOpacity(0.20),
                                highlightColor:
                                    AppColors.disable.withOpacity(0.20),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: AppColors.disable,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            height: 80,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.disable,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: AppColors.disable,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: AppColors.disable,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                        color: AppColors.disable,
                                        thickness: 1.2),
                                  ],
                                ));
                          },
                        ),
                      )
                    : restaurantMenu == null
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'Currently No Menu Found',
                                style: FontUtils.h18(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium,
                                ),
                              ),
                            ),
                          )
                        : restaurantMenu!.categories!.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Text(
                                    'Currently No Menu Found',
                                    style: FontUtils.h18(
                                      fontColor: AppColors.darkGray,
                                      fontWeight: FWT.medium,
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Meal type Slider ------------------------------------------------------------
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(
                                            restaurantMenu!.categories!.length,
                                            (index) => GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  select = index;
                                                  // tabMenu[controller.select];
                                                });
                                              },
                                              child: Container(
                                                height: 30.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25.w),
                                                decoration: BoxDecoration(
                                                  border: BorderDirectional(
                                                    bottom: BorderSide(
                                                      color: index == select
                                                          ? AppColors
                                                              .primaryBlue
                                                          : AppColors
                                                              .disabledColor,
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    restaurantMenu!
                                                        .categories![index]
                                                        .name!,
                                                    style: FontUtils.h18(
                                                      fontWeight: FWT.medium,
                                                      fontColor: index == select
                                                          ? AppColors
                                                              .primaryBlue
                                                          : AppColors
                                                              .disabledColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// Tab bar ----------------------------------------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16, bottom: 20),
                                      child: SizedBox(
                                        height: 40.h,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: mealType.length,
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                // if (selectedTabData
                                                //     .contains(mealType[index])) {
                                                //   setState(() {
                                                //     selectedTabData
                                                //         .remove(mealType[index]);
                                                //   });
                                                // } else {
                                                //   setState(() {
                                                //     selectedTabData
                                                //         .add(mealType[index]);
                                                //   });
                                                // }

                                                if (index != 0) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return FilterBottomSheet(
                                                        filterType:
                                                            mealType[index],
                                                        price: priceValue,
                                                      );
                                                    },
                                                    isDismissible: false,
                                                    shape: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                16.r),
                                                        topRight:
                                                            Radius.circular(
                                                                16.r),
                                                      ),
                                                      borderSide:
                                                          const BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        priceValue = value;
                                                      });

                                                      /// WHEN RANGE OF RATING IS SELECTED ------------------------------------------------------
                                                      //
                                                      // else {
                                                      //   ratingFilter.addAll(data
                                                      //       .where((element) =>
                                                      //   element.weightedRatingValue! >=
                                                      //       int.parse(rating.first) &&
                                                      //       element.weightedRatingValue! <=
                                                      //           int.parse(rating.last))
                                                      //       .toList());
                                                      // }
                                                    } else {
                                                      setState(() {
                                                        priceValue = '';
                                                      });
                                                    }
                                                  });
                                                }
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: index == 1 &&
                                                          priceValue.isNotEmpty
                                                      ? AppColors.coral
                                                      : AppColors.lightGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      mealType[index],
                                                      style: FontUtils.h18(
                                                        fontColor: index == 1 &&
                                                                priceValue
                                                                    .isNotEmpty
                                                            ? AppColors
                                                                .terracotta
                                                            : AppColors
                                                                .darkGray,
                                                        fontWeight: FWT.medium,
                                                      ),
                                                    ),
                                                    index != 0
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios_outlined,
                                                              size: 15,
                                                              color: index ==
                                                                          1 &&
                                                                      priceValue
                                                                          .isNotEmpty
                                                                  ? AppColors
                                                                      .terracotta
                                                                  : AppColors
                                                                      .darkGray,
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    /// Restaurant Menu ----------------------------------------------------------------

                                    Builder(
                                      builder: (context) {
                                        int? index = -1;

                                        if (priceValue.isNotEmpty) {
                                          index = restaurantMenu!
                                              .categories![select].menuItemList
                                              ?.indexWhere((element) => priceValue ==
                                                      '40'
                                                  ? int.parse(priceValue) <=
                                                      ((element.originalPrice)! /
                                                          100)
                                                  : int.parse(priceValue.split('-').first) <=
                                                          ((element
                                                                  .originalPrice)! /
                                                              100) &&
                                                      int.parse(priceValue
                                                              .split('-')
                                                              .last) >=
                                                          ((element
                                                                  .originalPrice)! /
                                                              100));

                                          if (index! < 0) {
                                            return Expanded(
                                              child: Center(
                                                child: Text(
                                                  'Currently No Menu Found',
                                                  style: FontUtils.h18(
                                                    fontColor:
                                                        AppColors.darkGray,
                                                    fontWeight: FWT.medium,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        }

                                        return Expanded(
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: restaurantMenu!
                                                  .categories![select]
                                                  .menuItemList!
                                                  .length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              separatorBuilder:
                                                  (context, index) {
                                                return const SizedBox(
                                                  height: 10,
                                                );
                                              },
                                              itemBuilder: (context, index) {
                                                return priceValue.isNotEmpty
                                                    ? (priceValue == "40"
                                                            ? int.parse(
                                                                    priceValue) <=
                                                                ((restaurantMenu!
                                                                        .categories![
                                                                            select]
                                                                        .menuItemList![
                                                                            index]
                                                                        .originalPrice)! /
                                                                    100)
                                                            : int.parse(priceValue
                                                                        .split(
                                                                            '-')
                                                                        .first) <=
                                                                    ((restaurantMenu!
                                                                            .categories![
                                                                                select]
                                                                            .menuItemList![
                                                                                index]
                                                                            .originalPrice)! /
                                                                        100) &&
                                                                int.parse(priceValue
                                                                        .split(
                                                                            '-')
                                                                        .last) >=
                                                                    ((restaurantMenu!
                                                                            .categories![select]
                                                                            .menuItemList![index]
                                                                            .originalPrice)! /
                                                                        100))
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              for (var element
                                                                  in cartData) {
                                                                if (element
                                                                        .productId ==
                                                                    restaurantMenu!
                                                                        .categories![
                                                                            select]
                                                                        .menuItemList![
                                                                            index]
                                                                        .productId) {
                                                                  selectedCartData =
                                                                      element;
                                                                }
                                                              }

                                                              selectedCartData ==
                                                                      null
                                                                  ? Get.to(
                                                                          () =>
                                                                              RestaurantMealDetails(
                                                                                data: restaurantMenu!.categories![select].menuItemList![index],
                                                                                restaurantId: widget.restaurantId,
                                                                              ),
                                                                          transition: Transition
                                                                              .fadeIn)!
                                                                      .then(
                                                                          (value) {
                                                                      if (value ==
                                                                          true) {
                                                                        restaurantBloc
                                                                            .add(GetShoppingListEvent());
                                                                      }
                                                                    })
                                                                  : Get.to(
                                                                          () =>
                                                                              RestaurantMealDetails(
                                                                                data: restaurantMenu!.categories![select].menuItemList![index],
                                                                                restaurantId: widget.restaurantId,
                                                                                shoppingListData: selectedCartData,
                                                                              ),
                                                                          transition: Transition
                                                                              .fadeIn)!
                                                                      .then(
                                                                          (value) {
                                                                      if (value ==
                                                                          true) {
                                                                        restaurantBloc
                                                                            .add(GetShoppingListEvent());
                                                                      }
                                                                    });
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal:
                                                                        20.w,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      restaurantMenu!.categories![select].menuItemList![index].image ==
                                                                              null
                                                                          ? Image
                                                                              .asset(
                                                                              AssetsUtils.food1,
                                                                              width: 80.w,
                                                                            )
                                                                          : Image
                                                                              .network(
                                                                              restaurantMenu!.categories![select].menuItemList![index].image!,
                                                                              width: 80.w,
                                                                            ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                130.w,
                                                                            child:
                                                                                Text(
                                                                              restaurantMenu!.categories![select].menuItemList![index].name!,
                                                                              style: FontUtils.h16(
                                                                                fontColor: AppColors.darkGray,
                                                                                fontWeight: FWT.regular,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                150.w,
                                                                            child:
                                                                                Text(
                                                                              restaurantMenu!.categories![select].menuItemList![index].description ?? '',
                                                                              style: FontUtils.h14(
                                                                                fontColor: const Color(0xffA2A4A7),
                                                                                fontWeight: FWT.light,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      restaurantMenu!
                                                                              .categories![select]
                                                                              .menuItemList![index]
                                                                              .highLightedColor!
                                                                              .isEmpty
                                                                          ? const SizedBox()
                                                                          : Image.asset(
                                                                              restaurantMenu!.categories![select].menuItemList![index].highLightedColor == 'Red'
                                                                                  ? AssetsUtils.canEatRed
                                                                                  : restaurantMenu!.categories![select].menuItemList![index].highLightedColor == 'Yellow'
                                                                                      ? AssetsUtils.canEatYellow
                                                                                      : AssetsUtils.icCanEat,
                                                                              width: 25.w,
                                                                            ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            restaurantMenu!.categories![select].menuItemList![index].formattedPrice.toString(),
                                                                            style:
                                                                                FontUtils.h18(
                                                                              fontColor: Colors.black,
                                                                              fontWeight: FWT.medium,
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              log('cartData---------->>>>>> ${cartData}');

                                                                              for (var element in cartData) {
                                                                                if (element.productId == restaurantMenu!.categories![select].menuItemList![index].productId) {
                                                                                  selectedCartData = element;
                                                                                }
                                                                              }

                                                                              selectedCartData == null
                                                                                  ? await Get.to(
                                                                                      () => RestaurantMenuDetailsScreen(
                                                                                        data: restaurantMenu!.categories![select].menuItemList![index],
                                                                                        restaurantId: widget.restaurantId,
                                                                                      ),
                                                                                      transition: Transition.fadeIn,
                                                                                    )!
                                                                                      .then((value) {
                                                                                      if (value == true) {
                                                                                        restaurantBloc.add(GetShoppingListEvent());
                                                                                      }
                                                                                    })
                                                                                  : await Get.to(
                                                                                      () => RestaurantMenuDetailsScreen(
                                                                                        data: restaurantMenu!.categories![select].menuItemList![index],
                                                                                        restaurantId: widget.restaurantId,
                                                                                        shoppingListData: selectedCartData,
                                                                                      ),
                                                                                      transition: Transition.fadeIn,
                                                                                    )!
                                                                                      .then((value) {
                                                                                      if (value == true) {
                                                                                        restaurantBloc.add(GetShoppingListEvent());
                                                                                      }
                                                                                    });
                                                                            },
                                                                            child:
                                                                                Image.asset(
                                                                              AssetsUtils.icAdd,
                                                                              height: 22.h,
                                                                              alignment: Alignment.bottomRight,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                restaurantMenu!
                                                                            .categories![select]
                                                                            .menuItemList![index]
                                                                            .cartQuantity ==
                                                                        0
                                                                    ? const SizedBox()
                                                                    : Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        height: size.height *
                                                                            0.08,
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 16.w),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                color: const Color(0xff004C63).withOpacity(0.08),
                                                                                offset: const Offset(0, 0),
                                                                                blurRadius: 18),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text('\$${double.parse((restaurantMenu!.categories![select].menuItemList![index].cartPrice / 100).toString()).toStringAsFixed(2)}',
                                                                                style: FontUtils.h18(fontColor: const Color(0xff010101), fontWeight: FWT.semiBold)),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    for (var element in cartData) {
                                                                                      if (element.productId == restaurantMenu!.categories![select].menuItemList![index].productId) {
                                                                                        isRemoveUpdate = true;

                                                                                        if (restaurantMenu!.categories![select].menuItemList![index].cartQuantity == 1) {
                                                                                        } else {
                                                                                          restaurantBloc.add(
                                                                                            UpdateRestaurantCartEvent(
                                                                                              updateItemList: UpdateRestaurantItemsToShoppingListModel(
                                                                                                productName: element.productName ?? '',
                                                                                                oldProductId: element.productId ?? '',
                                                                                                newProductId: '',
                                                                                                quantity: restaurantMenu!.categories![select].menuItemList![index].cartQuantity! - 1,
                                                                                                price: (restaurantMenu!.categories![select].menuItemList![index].cartPrice! / restaurantMenu!.categories![select].menuItemList![index].cartQuantity!) * (restaurantMenu!.categories![select].menuItemList![index].cartQuantity! - 1),
                                                                                                itemOptions: element.options ?? [],
                                                                                                productType: element.productType ?? 'Restaurant',
                                                                                                mealmeStoreId: element.mealmeStoreId ?? widget.restaurantId,
                                                                                                unitOfMeasurement: element.unitOfMeasurement ?? '',
                                                                                                recipeId: element.recipeId ?? '',
                                                                                                userId: element.userId ?? userId,
                                                                                                brandName: element.brandName ?? '',
                                                                                                isChecked: element.isChecked ?? false,
                                                                                                unitSize: element.unitSize ?? 0,
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    height: size.height * 0.060,
                                                                                    width: size.height * 0.060,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.terracotta)),
                                                                                    child: Center(
                                                                                      child: restaurantMenu!.categories![select].menuItemList![index].isRemoveUpdated == true
                                                                                          ? Transform.scale(
                                                                                              scale: 0.5,
                                                                                              child: const CircularProgressIndicator(
                                                                                                color: AppColors.terracotta,
                                                                                              ),
                                                                                            )
                                                                                          : restaurantMenu!.categories![select].menuItemList![index].cartQuantity == 1
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
                                                                                    border: Border.all(color: AppColors.disable),
                                                                                    borderRadius: BorderRadius.circular(6),
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Text(
                                                                                    '${restaurantMenu!.categories![select].menuItemList![index].cartQuantity}',
                                                                                    style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                                                                  )),
                                                                                ),
                                                                                SizedBox(width: 8.w),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    for (var element in cartData) {
                                                                                      if (element.productId == restaurantMenu!.categories![select].menuItemList![index].productId) {
                                                                                        isAddUpdate = true;

                                                                                        restaurantBloc.add(
                                                                                          UpdateRestaurantCartEvent(
                                                                                            updateItemList: UpdateRestaurantItemsToShoppingListModel(
                                                                                              productName: element.productName ?? '',
                                                                                              oldProductId: element.productId ?? '',
                                                                                              newProductId: '',
                                                                                              quantity: restaurantMenu!.categories![select].menuItemList![index].cartQuantity! + 1,
                                                                                              price: (restaurantMenu!.categories![select].menuItemList![index].cartPrice! / restaurantMenu!.categories![select].menuItemList![index].cartQuantity!) * (restaurantMenu!.categories![select].menuItemList![index].cartQuantity! + 1),
                                                                                              itemOptions: element.options ?? [],
                                                                                              productType: element.productType ?? 'Restaurant',
                                                                                              mealmeStoreId: element.mealmeStoreId ?? widget.restaurantId,
                                                                                              unitOfMeasurement: element.unitOfMeasurement ?? '',
                                                                                              recipeId: element.recipeId ?? '',
                                                                                              userId: element.userId ?? userId,
                                                                                              brandName: element.brandName ?? '',
                                                                                              isChecked: element.isChecked ?? false,
                                                                                              unitSize: element.unitSize ?? 0,
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
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
                                                                                      child: restaurantMenu!.categories![select].menuItemList![index].isAddUpdated == true
                                                                                          ? Transform.scale(
                                                                                              scale: 0.5,
                                                                                              child: const CircularProgressIndicator(
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
                                                                          ],
                                                                        ),
                                                                      ),
                                                                Divider(
                                                                  endIndent:
                                                                      20.w,
                                                                  indent: 20.w,
                                                                  color: AppColors
                                                                      .disabledColor,
                                                                  thickness: 1,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          for (var element
                                                              in cartData) {
                                                            if (element
                                                                    .productId ==
                                                                restaurantMenu!
                                                                    .categories![
                                                                        select]
                                                                    .menuItemList![
                                                                        index]
                                                                    .productId) {
                                                              selectedCartData =
                                                                  element;
                                                            }
                                                          }

                                                          selectedCartData ==
                                                                  null
                                                              ? Get.to(
                                                                      () =>
                                                                          RestaurantMealDetails(
                                                                            data:
                                                                                restaurantMenu!.categories![select].menuItemList![index],
                                                                            restaurantId:
                                                                                widget.restaurantId,
                                                                          ),
                                                                      transition:
                                                                          Transition
                                                                              .fadeIn)!
                                                                  .then(
                                                                      (value) {
                                                                  if (value ==
                                                                      true) {
                                                                    restaurantBloc
                                                                        .add(
                                                                            GetShoppingListEvent());
                                                                  }
                                                                })
                                                              : Get.to(
                                                                      () =>
                                                                          RestaurantMealDetails(
                                                                            data:
                                                                                restaurantMenu!.categories![select].menuItemList![index],
                                                                            restaurantId:
                                                                                widget.restaurantId,
                                                                            shoppingListData:
                                                                                selectedCartData,
                                                                          ),
                                                                      transition:
                                                                          Transition
                                                                              .fadeIn)!
                                                                  .then(
                                                                      (value) {
                                                                  if (value ==
                                                                      true) {
                                                                    restaurantBloc
                                                                        .add(
                                                                      GetShoppingListEvent(),
                                                                    );
                                                                  }
                                                                });
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    20.w,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  restaurantMenu!
                                                                              .categories![
                                                                                  select]
                                                                              .menuItemList![
                                                                                  index]
                                                                              .image ==
                                                                          null
                                                                      ? Image
                                                                          .asset(
                                                                          AssetsUtils
                                                                              .food1,
                                                                          width:
                                                                              80.w,
                                                                        )
                                                                      : Image
                                                                          .network(
                                                                          restaurantMenu!
                                                                              .categories![select]
                                                                              .menuItemList![index]
                                                                              .image!,
                                                                          width:
                                                                              80.w,
                                                                        ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            130.w,
                                                                        child:
                                                                            Text(
                                                                          restaurantMenu!
                                                                              .categories![select]
                                                                              .menuItemList![index]
                                                                              .name!,
                                                                          style:
                                                                              FontUtils.h16(
                                                                            fontColor:
                                                                                AppColors.darkGray,
                                                                            fontWeight:
                                                                                FWT.regular,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            150.w,
                                                                        child:
                                                                            Text(
                                                                          restaurantMenu!.categories![select].menuItemList![index].description ??
                                                                              '',
                                                                          style:
                                                                              FontUtils.h14(
                                                                            fontColor:
                                                                                const Color(0xffA2A4A7),
                                                                            fontWeight:
                                                                                FWT.light,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  restaurantMenu!
                                                                          .categories![
                                                                              select]
                                                                          .menuItemList![
                                                                              index]
                                                                          .highLightedColor!
                                                                          .isEmpty
                                                                      ? const SizedBox()
                                                                      : Image
                                                                          .asset(
                                                                          restaurantMenu!.categories![select].menuItemList![index].highLightedColor == 'Red'
                                                                              ? AssetsUtils.canEatRed
                                                                              : restaurantMenu!.categories![select].menuItemList![index].highLightedColor == 'Yellow'
                                                                                  ? AssetsUtils.canEatYellow
                                                                                  : AssetsUtils.icCanEat,
                                                                          width:
                                                                              25.w,
                                                                        ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        restaurantMenu!
                                                                            .categories![select]
                                                                            .menuItemList![index]
                                                                            .formattedPrice
                                                                            .toString(),
                                                                        style: FontUtils
                                                                            .h18(
                                                                          fontColor:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FWT.medium,
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          for (var element
                                                                              in cartData) {
                                                                            if (element.productId ==
                                                                                restaurantMenu!.categories![select].menuItemList![index].productId) {
                                                                              selectedCartData = element;
                                                                            }
                                                                          }

                                                                          selectedCartData == null
                                                                              ? await Get.to(
                                                                                  () => RestaurantMenuDetailsScreen(
                                                                                    data: restaurantMenu!.categories![select].menuItemList![index],
                                                                                    restaurantId: widget.restaurantId,
                                                                                  ),
                                                                                  transition: Transition.fadeIn,
                                                                                )!
                                                                                  .then((value) {
                                                                                  if (value == true) {
                                                                                    restaurantBloc.add(GetShoppingListEvent());
                                                                                  }
                                                                                })
                                                                              : await Get.to(
                                                                                  () => RestaurantMenuDetailsScreen(
                                                                                    data: restaurantMenu!.categories![select].menuItemList![index],
                                                                                    restaurantId: widget.restaurantId,
                                                                                    shoppingListData: selectedCartData,
                                                                                  ),
                                                                                  transition: Transition.fadeIn,
                                                                                )!
                                                                                  .then((value) {
                                                                                  if (value == true) {
                                                                                    restaurantBloc.add(GetShoppingListEvent());
                                                                                  }
                                                                                });
                                                                        },
                                                                        child: Image
                                                                            .asset(
                                                                          AssetsUtils
                                                                              .icAdd,
                                                                          height:
                                                                              22.h,
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            restaurantMenu!
                                                                        .categories![
                                                                            select]
                                                                        .menuItemList![
                                                                            index]
                                                                        .cartQuantity ==
                                                                    0
                                                                ? const SizedBox()
                                                                : Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: size
                                                                            .height *
                                                                        0.08,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16.w),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: const Color(0xff004C63).withOpacity(
                                                                                0.08),
                                                                            offset: const Offset(0,
                                                                                0),
                                                                            blurRadius:
                                                                                18),
                                                                      ],
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            '\$${double.parse((restaurantMenu!.categories![select].menuItemList![index].cartPrice / 100).toString()).toStringAsFixed(2)}',
                                                                            style:
                                                                                FontUtils.h18(fontColor: const Color(0xff010101), fontWeight: FWT.semiBold)),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                for (var element in cartData) {
                                                                                  if (element.productId == restaurantMenu!.categories![select].menuItemList![index].productId) {
                                                                                    isRemoveUpdate = true;

                                                                                    if (restaurantMenu!.categories![select].menuItemList![index].cartQuantity == 1) {
                                                                                      restaurantBloc.add(RemoveShoppingListItemEvent(productID: restaurantMenu!.categories![select].menuItemList![index].productId!));
                                                                                    } else {
                                                                                      restaurantBloc.add(
                                                                                        UpdateRestaurantCartEvent(
                                                                                          updateItemList: UpdateRestaurantItemsToShoppingListModel(
                                                                                            productName: element.productName ?? '',
                                                                                            oldProductId: element.productId ?? '',
                                                                                            newProductId: '',
                                                                                            quantity: restaurantMenu!.categories![select].menuItemList![index].cartQuantity! - 1,
                                                                                            price: (restaurantMenu!.categories![select].menuItemList![index].cartPrice! / restaurantMenu!.categories![select].menuItemList![index].cartQuantity!) * (restaurantMenu!.categories![select].menuItemList![index].cartQuantity! - 1),
                                                                                            itemOptions: [],
                                                                                            productType: element.productType ?? 'Restaurant',
                                                                                            mealmeStoreId: element.mealmeStoreId ?? widget.restaurantId,
                                                                                            unitOfMeasurement: element.unitOfMeasurement ?? '',
                                                                                            recipeId: element.recipeId ?? '',
                                                                                            userId: element.userId ?? userId,
                                                                                            brandName: element.brandName ?? '',
                                                                                            isChecked: element.isChecked ?? false,
                                                                                            unitSize: element.unitSize ?? 0,
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                height: size.height * 0.060,
                                                                                width: size.height * 0.060,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.terracotta)),
                                                                                child: Center(
                                                                                  child: restaurantMenu!.categories![select].menuItemList![index].isRemoveUpdated == true
                                                                                      ? Transform.scale(
                                                                                          scale: 0.5,
                                                                                          child: const CircularProgressIndicator(
                                                                                            color: AppColors.terracotta,
                                                                                          ),
                                                                                        )
                                                                                      : restaurantMenu!.categories![select].menuItemList![index].cartQuantity == 1
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
                                                                                border: Border.all(color: AppColors.disable),
                                                                                borderRadius: BorderRadius.circular(6),
                                                                              ),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                '${restaurantMenu!.categories![select].menuItemList![index].cartQuantity}',
                                                                                style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                                                              )),
                                                                            ),
                                                                            SizedBox(width: 8.w),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                for (var element in cartData) {
                                                                                  if (element.productId == restaurantMenu!.categories![select].menuItemList![index].productId) {
                                                                                    isAddUpdate = true;

                                                                                    restaurantBloc.add(
                                                                                      UpdateRestaurantCartEvent(
                                                                                        updateItemList: UpdateRestaurantItemsToShoppingListModel(
                                                                                          productName: element.productName ?? '',
                                                                                          oldProductId: element.productId ?? '',
                                                                                          newProductId: '',
                                                                                          quantity: restaurantMenu!.categories![select].menuItemList![index].cartQuantity! + 1,
                                                                                          price: (restaurantMenu!.categories![select].menuItemList![index].cartPrice! / restaurantMenu!.categories![select].menuItemList![index].cartQuantity!) * (restaurantMenu!.categories![select].menuItemList![index].cartQuantity! + 1),
                                                                                          itemOptions: [],
                                                                                          productType: element.productType ?? 'Restaurant',
                                                                                          mealmeStoreId: element.mealmeStoreId ?? widget.restaurantId,
                                                                                          unitOfMeasurement: element.unitOfMeasurement ?? '',
                                                                                          recipeId: element.recipeId ?? '',
                                                                                          userId: element.userId ?? userId,
                                                                                          brandName: element.brandName ?? '',
                                                                                          isChecked: element.isChecked ?? false,
                                                                                          unitSize: element.unitSize ?? 0,
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
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
                                                                                  child: restaurantMenu!.categories![select].menuItemList![index].isAddUpdated == true
                                                                                      ? Transform.scale(
                                                                                          scale: 0.5,
                                                                                          child: const CircularProgressIndicator(
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
                                                                      ],
                                                                    ),
                                                                  ),
                                                            Divider(
                                                              endIndent: 20.w,
                                                              indent: 20.w,
                                                              color: AppColors
                                                                  .disabledColor,
                                                              thickness: 1,
                                                            )
                                                          ],
                                                        ),
                                                      );
                                              }),
                                        );
                                      },
                                    ),

                                    hasCartData == true && cartCount != 0
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h),
                                            child:
                                                RestaurantMealAddButtonWidget(
                                              onTap: () {
                                                Get.to(
                                                  () => RestaurantCart(),
                                                  // transition: Transition.fadeIn,
                                                );
                                              },
                                              buttonLable: 'View Cart',
                                              isFillColor: true,
                                              selectedItemCount:
                                                  cartData.length,
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              )
              ],
            );
          },
        ),
      ),
    );
  }
}
