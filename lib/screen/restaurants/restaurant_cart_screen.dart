// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/checkout_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'model/get_user_address_model.dart' as address;
import 'model/create_order_response_model.dart' as order;
import 'package:gymeats_mobile/screen/restaurants/model/create_order_request_model.dart'
    as u_add;

class RestaurantCart extends StatefulWidget {
  const RestaurantCart({
    super.key,
    required this.pickUp,
    required this.userAddress,
  });
  final address.UserAddress? userAddress;

  final bool pickUp;

  @override
  State<RestaurantCart> createState() => _RestaurantCartState();
}

class _RestaurantCartState extends State<RestaurantCart> {
  List<ShoppingListData> cartData = [];
  RestaurantBloc restaurantBloc = RestaurantBloc();
  dynamic price = 0;
  bool loadCreateOrder = false;

  order.CreateOrderData? orderData;
  final formKey = GlobalKey<FormState>();

  TextEditingController addressNameController = TextEditingController();
  TextEditingController streetDetailsController = TextEditingController();
  TextEditingController apartmentNumberController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    cartBloc.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: bloc.BlocConsumer<CartBloc, CartState>(
            bloc: cartBloc,
            listener: (context, state) {
              if (state is RestaurantCartState) {
                cartData = state.shoppingList;
                price = 0;
                for (var element in cartData) {
                  price = price + element.price;
                }
                setState(() {});
              }
            },
            builder: (context, state) {
              return bloc.BlocConsumer(
                bloc: restaurantBloc,
                listener: (context, state) async {
                  if (state is CreateOrderLoadingState) {
                    loadCreateOrder = true;
                  }
                  if (state is CreateOrderErrorState) {
                    loadCreateOrder = false;
                  }
                  if (state is CreateOrderSuccessState) {
                    orderData = state.orderData;
                    if (orderData != null) {
                      Get.to(
                        () => CheckOutScreen(
                          isFromGrocery: false,
                          cartData: cartData,
                          orderData: orderData,
                          getUserAddress: widget.userAddress,
                          currentAddress: streetDetailsController.text,
                        ),
                        transition: Transition.fadeIn,
                      );
                    }

                    loadCreateOrder = false;
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      5.height,
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
                                Get.back(result: true);
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
                            30.width,
                          ],
                        ),
                      ),
                      cartData.isEmpty
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
                                                  width: context.width,
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
                                                            '\$${(cartData[index].price ?? 0) / 100}',
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
                                                              cartBloc.add(
                                                                  ChangeQty(
                                                                productID: cartData[
                                                                        index]
                                                                    .productId,
                                                                type: ModifyType
                                                                    .decrement,
                                                              ));
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
                                                              cartBloc.add(ChangeQty(
                                                                  productID: cartData[
                                                                          index]
                                                                      .productId,
                                                                  type: ModifyType
                                                                      .increment));
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!loadCreateOrder) ...[
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 16.h),
                                              child: Text(
                                                ' Order Notes',
                                                style: FontUtils.h18(
                                                  fontColor:
                                                      const Color(0xff000000),
                                                  fontWeight: FWT.semiBold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xff004C63)
                                                            .withOpacity(0.08),
                                                    offset: const Offset(0, 0),
                                                    blurRadius: 16,
                                                  )
                                                ],
                                              ),
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                controller: notes,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  hintText:
                                                      'Add order Notes.....',
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 16.h),
                                          ],
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
                                                  '\$ ${price / 100}',
                                                  style: FontUtils.h24(
                                                    fontColor:
                                                        const Color(0xff010101),
                                                    fontWeight: FWT.medium,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          loadCreateOrder
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: simpleTextBorderButton(
                                                    color: AppColors.terracotta,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    isFillColor: true,
                                                    height: 40.h,
                                                    isLoadingWidget: false,
                                                    buttonLable: 'Checkout ',
                                                    lableColor: Colors.white,
                                                    onTap: () async {
                                                      (double?, double?) pos =
                                                          await Constant
                                                              .i.position;
                                                      if (cartData
                                                          .any((element) {
                                                        int pr =
                                                            element.price ?? 0;
                                                        return element
                                                                    .orderMax !=
                                                                null &&
                                                            (pr <
                                                                    element
                                                                        .orderMin! ||
                                                                pr >
                                                                    element
                                                                        .orderMax!);
                                                      })) {
                                                        showToast(
                                                            message:
                                                                "Your order amount not should be greater than \$${(cartData.first.orderMax ?? 0) / 100}",
                                                            isSuccess: false);
                                                        return;
                                                      }

                                                      List<CreateOrderMealmeItems>
                                                          data = [];

                                                      for (var element
                                                          in cartData) {
                                                        List<SelectedOptions>
                                                            optionList = [];
                                                        for (var element1
                                                            in element
                                                                .options!) {
                                                          optionList.add(
                                                            SelectedOptions(
                                                              quantity: element1
                                                                  .quantity,
                                                              markedPrice: element1
                                                                  .markedPrice,
                                                              optionId: element1
                                                                  .optionId,
                                                            ),
                                                          );
                                                        }
                                                        double
                                                            productMarkedPrice =
                                                            element.originalPrice
                                                                    ?.toDouble() ??
                                                                0;
                                                        data.add(
                                                          CreateOrderMealmeItems(
                                                            productId: element
                                                                .productId,
                                                            productType: 1,
                                                            quantity: element
                                                                .quantity,
                                                            notes: '',
                                                            productMarkedPrice: productMarkedPrice
                                                                        .isNaN ||
                                                                    productMarkedPrice
                                                                        .isInfinite
                                                                ? 0
                                                                : productMarkedPrice
                                                                    .toInt(),
                                                            selectedOptions:
                                                                optionList,
                                                          ),
                                                        );
                                                      }

                                                      double? lat = pos.$1 ??
                                                          widget.userAddress
                                                              ?.latitude ??
                                                          0;
                                                      double? lng = pos.$2 ??
                                                          widget.userAddress
                                                              ?.longitude ??
                                                          0;

                                                      restaurantBloc.add(
                                                        CreateOrderEvent(
                                                          context: context,
                                                          lat: lat,
                                                          lng: lng,
                                                          createOrderModel:
                                                              CreateOrderModel(
                                                            userId: userId,
                                                            pickup:
                                                                widget.pickUp,
                                                            mealmeItems: data,
                                                            userAddress: u_add
                                                                .UserAddress(
                                                              latitude: lat,
                                                              longitude: lng,
                                                            ),
                                                            userPhone:
                                                                int.parse(
                                                              PreferenceUtils.getString(
                                                                          prefUserMobile)
                                                                      .isNotEmpty
                                                                  ? PreferenceUtils
                                                                      .getString(
                                                                          prefUserMobile)
                                                                  : '1234567890',
                                                            ),
                                                            driverTipCents: 0,
                                                            pickupTipCents: 0,
                                                            userDropoffNotes:
                                                                notes.text,
                                                          ),
                                                        ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
