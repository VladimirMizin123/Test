import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/checkout_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/update_cart_items_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class RestaurantCart extends StatefulWidget {
  const RestaurantCart({super.key});

  @override
  State<RestaurantCart> createState() => _RestaurantCartState();
}

class _RestaurantCartState extends State<RestaurantCart> {
  List<ShoppingListData> cartData = [];
  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool loading = false;
  bool isAddUpdate = false;
  bool isApiCall = false;
  @override
  void initState() {
    super.initState();
    restaurantBloc.add(GetShoppingListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        body: SafeArea(
          child: bloc.BlocConsumer(
            bloc: restaurantBloc,
            listener: (context, state) {
              if (state is GetShoppingListLoadingState) {
                loading = true;
              }
              if (state is GetShoppingListSuccessState) {
                cartData = state.shoppingListData!;
                loading = false;
              }
              if (state is GetShoppingListErrorState) {
                loading = false;
              }

              ///UpdateToRestaurantCart State ====================================================================

              if (state is UpdateToRestaurantCartSuccessState) {
                for (var element in cartData) {
                  if (state.data['productId'] == element.productId) {
                    element.quantity = state.data['quantity'];
                    element.price = state.data['price'];

                    if (isAddUpdate == true) {
                      element.isAddUpdated = false;
                    } else {
                      element.isRemoveUpdated = false;
                    }

                    isAddUpdate = false;
                  }
                }
              }

              if (state is UpdateToRestaurantCartLoadingState) {
                for (var element in cartData) {
                  if (state.productId == element.productId) {
                    if (isAddUpdate == true) {
                      element.isAddUpdated = true;
                    } else {
                      element.isRemoveUpdated = true;
                    }
                  }
                }
              }

              if (state is UpdateToRestaurantCartErrorState) {
                for (var element in cartData) {
                  if (state.productId == element.productId) {
                    if (isAddUpdate == true) {
                      element.isAddUpdated = false;
                    } else {
                      element.isRemoveUpdated = false;
                    }

                    isAddUpdate = false;
                  }
                }
              }

              ///Remove To RestaurantCart State ====================================================================

              if (state is RemoveShoppingListItemSuccessState) {
                for (var element1 in cartData) {
                  if (state.productId == element1.productId) {
                    element1.quantity = 0;
                    element1.price = 0;

                    if (isAddUpdate == true) {
                      element1.isAddUpdated = false;
                    } else {
                      element1.isRemoveUpdated = false;
                    }
                    isAddUpdate = false;
                  }
                }

                cartData.removeWhere(
                    (element) => element.productId == state.productId);
              }

              if (state is RemoveShoppingListItemLoadingState) {
                for (var element1 in cartData) {
                  if (state.productId == element1.productId) {
                    if (isAddUpdate == true) {
                      element1.isAddUpdated = true;
                    } else {
                      element1.isRemoveUpdated = true;
                    }
                  }
                }
              }

              if (state is RemoveShoppingListItemErrorState) {
                for (var element1 in cartData) {
                  if (state.productId == element1.productId) {
                    if (isAddUpdate == true) {
                      element1.isAddUpdated = true;
                    } else {
                      element1.isRemoveUpdated = true;
                    }
                    isAddUpdate = false;
                  }
                }
              }
            },
            builder: (context, state) {
              return Column(
                children: [
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: 3,
                      bottom: 20.h,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back(result: isApiCall);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                        const Text(
                          'Restaurant / Cart',
                          style: TextStyle(
                            color: Color(0xFF010101),
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 30,
                        )
                      ],
                    ),
                  ),
                  loading == true
                      ? const Expanded(child: AppCenterLoader())
                      : cartData.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  'Currently No Items in Cart',
                                  style: FontUtils.h18(
                                    fontColor: AppColors.darkGray,
                                    fontWeight: FWT.medium,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  /// Cart List ----------------------------------------------------------------
                                  Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: cartData.length,
                                      physics: const BouncingScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Column(
                                            children: [
                                              IntrinsicHeight(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 20.w),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${cartData[index].quantity}x',
                                                            style:
                                                                FontUtils.h18(
                                                              fontColor:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FWT.medium,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 230.w,
                                                            child: Text(
                                                              '${cartData[index].productName}',
                                                              style: FontUtils.h16(
                                                                  fontColor:
                                                                      AppColors
                                                                          .darkGray,
                                                                  fontWeight: FWT
                                                                      .regular),
                                                            ),
                                                          ),
                                                          Text(
                                                            '\$${cartData[index].price / 100}',
                                                            style:
                                                                FontUtils.h18(
                                                              fontColor:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FWT.medium,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                isApiCall =
                                                                    true;
                                                              });

                                                              for (var element
                                                                  in cartData) {
                                                                if (element
                                                                        .productId ==
                                                                    cartData[
                                                                            index]
                                                                        .productId) {
                                                                  // isRemoveUpdate = true;

                                                                  if (cartData[
                                                                              index]
                                                                          .quantity ==
                                                                      1) {
                                                                    restaurantBloc.add(RemoveShoppingListItemEvent(
                                                                        productID:
                                                                            cartData[index].productId!));
                                                                  } else {
                                                                    restaurantBloc
                                                                        .add(
                                                                      UpdateRestaurantCartEvent(
                                                                        updateItemList:
                                                                            UpdateRestaurantItemsToShoppingListModel(
                                                                          productName:
                                                                              element.productName ?? '',
                                                                          oldProductId:
                                                                              element.productId ?? '',
                                                                          newProductId:
                                                                              '',
                                                                          quantity:
                                                                              cartData[index].quantity! - 1,
                                                                          price:
                                                                              (cartData[index].price! / cartData[index].quantity!) * (cartData[index].quantity! - 1),
                                                                          itemOptions: [],
                                                                          productType:
                                                                              element.productType ?? 'Restaurant',
                                                                          mealmeStoreId:
                                                                              element.mealmeStoreId,
                                                                          unitOfMeasurement:
                                                                              element.unitOfMeasurement ?? '',
                                                                          recipeId:
                                                                              element.recipeId ?? '',
                                                                          userId:
                                                                              element.userId ?? userId,
                                                                          brandName:
                                                                              element.brandName ?? '',
                                                                          isChecked:
                                                                              element.isChecked ?? false,
                                                                          unitSize:
                                                                              element.unitSize ?? 0,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                              }
                                                            },
                                                            child: cartData[index]
                                                                        .isRemoveUpdated ==
                                                                    true
                                                                ? Transform
                                                                    .scale(
                                                                    scale: 0.5,
                                                                    child:
                                                                        const CircularProgressIndicator(
                                                                      color: AppColors
                                                                          .terracotta,
                                                                    ),
                                                                  )
                                                                : cartData[index]
                                                                            .quantity ==
                                                                        1
                                                                    ? SvgPicture
                                                                        .asset(
                                                                        AssetsUtils
                                                                            .icDelete,
                                                                        color: AppColors
                                                                            .terracotta,
                                                                      )
                                                                    : SvgPicture
                                                                        .asset(
                                                                        AssetsUtils
                                                                            .icRemove,
                                                                        height:
                                                                            22.h,
                                                                        alignment:
                                                                            Alignment.bottomLeft,
                                                                      ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                isApiCall =
                                                                    true;
                                                              });
                                                              for (var element
                                                                  in cartData) {
                                                                if (element
                                                                        .productId ==
                                                                    cartData[
                                                                            index]
                                                                        .productId) {
                                                                  isAddUpdate =
                                                                      true;

                                                                  restaurantBloc
                                                                      .add(
                                                                    UpdateRestaurantCartEvent(
                                                                      updateItemList:
                                                                          UpdateRestaurantItemsToShoppingListModel(
                                                                        productName:
                                                                            element.productName ??
                                                                                '',
                                                                        oldProductId:
                                                                            element.productId ??
                                                                                '',
                                                                        newProductId:
                                                                            '',
                                                                        quantity:
                                                                            cartData[index].quantity! +
                                                                                1,
                                                                        price: (cartData[index].price! / cartData[index].quantity!) *
                                                                            (cartData[index].quantity! +
                                                                                1),
                                                                        itemOptions: [],
                                                                        productType:
                                                                            element.productType ??
                                                                                'Restaurant',
                                                                        mealmeStoreId:
                                                                            element.mealmeStoreId,
                                                                        unitOfMeasurement:
                                                                            element.unitOfMeasurement ??
                                                                                '',
                                                                        recipeId:
                                                                            element.recipeId ??
                                                                                '',
                                                                        userId: element.userId ??
                                                                            userId,
                                                                        brandName:
                                                                            element.brandName ??
                                                                                '',
                                                                        isChecked:
                                                                            element.isChecked ??
                                                                                false,
                                                                        unitSize:
                                                                            element.unitSize ??
                                                                                0,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            child: cartData[index]
                                                                        .isAddUpdated ==
                                                                    true
                                                                ? Transform
                                                                    .scale(
                                                                        scale:
                                                                            0.5,
                                                                        child:
                                                                            const CircularProgressIndicator(
                                                                          color:
                                                                              AppColors.terracotta,
                                                                        ))
                                                                : Image.asset(
                                                                    AssetsUtils
                                                                        .icAdd,
                                                                    height:
                                                                        22.h,
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomLeft,
                                                                  ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                endIndent: 20.w,
                                                indent: 20.w,
                                                height: 20.h,
                                                color: AppColors.disabledColor,
                                                thickness: 1,
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Total',
                                                  style: FontUtils.h18(
                                                    fontColor:
                                                        AppColors.darkGray,
                                                    fontWeight: FWT.medium,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '\$ 16.37',
                                                  style: FontUtils.h24(
                                                    fontColor:
                                                        const Color(0xff010101),
                                                    fontWeight: FWT.medium,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: simpleTextBorderButton(
                                              color: AppColors.terracotta,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              isFillColor: true,
                                              height: 40.h,
                                              isLoadingWidget: false,
                                              buttonLable: 'Checkout ',
                                              lableColor: Colors.white,
                                              onTap: () {
                                                Get.to(
                                                  () => const CheckOutScreen(),
                                                  transition: Transition.fadeIn,
                                                );
                                              },
                                              context: context,
                                              isDarkColor: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
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
