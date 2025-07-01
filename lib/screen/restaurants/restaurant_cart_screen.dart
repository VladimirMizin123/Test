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
import 'package:gymeats_mobile/service/signalr_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isGoingBack = false;

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
    this.syncCartWithServer();
  }

  Future<void> syncCartWithServer({bool? isOpened}) async {
    print('SYNC CART');
    print(isOpened);
    final signalR = SignalRService();

    try {
      final prefs = await SharedPreferences.getInstance();
      final address = prefs.getString('currentUserAddress') ?? '';
      final isCartOpened = prefs.getBool('cart-opened') ?? false;

      List<Map<String, dynamic>> serverResult;

      if (isOpened == null) {
        print('Cart already opened, calling getCartInformation');
        await signalR.openRestaurantCart();
        serverResult = await signalR.getCartInformation();
      } else {
        print('Cart not opened yet, calling openRestaurantCart');
        serverResult = await signalR.getCartInformation();
        await prefs.setBool('cart-opened', true);
      }

      print('RESULT FROM SIGNAL R');
      mergeCartDataFromServer(serverResult);

    } catch (e) {
      print('Error syncing cart: $e');
    }
  }

  void mergeCartDataFromServer(List<dynamic> serverCartItems) {
    print('mergeCartDataFromServer');

    final Map<String, List<dynamic>> groupedByName = {};

    for (var item in serverCartItems) {
      final itemName = item['Name'] as String?;
      if (itemName == null) continue;

      groupedByName.putIfAbsent(itemName, () => []).add(item);
    }

    for (var entry in groupedByName.entries) {
      final name = entry.key;
      final serverItemsForName = entry.value;

      final existingItems = cartData.where((e) => e.productName == name).toList();

      for (int i = 0; i < serverItemsForName.length; i++) {
        final serverItem = serverItemsForName[i];
        final itemPriceStr = serverItem['Price'] as String?;
        final itemUrl = serverItem['ItemUrl'] as String?;
        final itemQuantity = int.tryParse(serverItem['Quantity']?.toString() ?? '0');

        if (itemPriceStr == null) continue;

        final parsedPrice = (double.tryParse(itemPriceStr.replaceAll('\$', '').trim()) ?? 0.0) * 100;
        final int newPrice = parsedPrice.toInt();

        if (i < existingItems.length) {
          existingItems[i].price = newPrice;
          existingItems[i].quantity = itemQuantity;
        } else {
          cartData.add(
            ShoppingListData(
              productName: name,
              price: newPrice,
              quantity: itemQuantity,
              mealmeStoreId: itemUrl,
              image: itemUrl
            ),
          );
        }
      }
    }

    price = 0;
    for (var element in cartData) {
      price += element.price ?? 0;
    }

    setState(() {});
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
                      final result = await Get.to(
                        () => CheckOutScreen(
                          isFromGrocery: false,
                          cartData: cartData,
                          orderData: orderData,
                          getUserAddress: widget.userAddress,
                          currentAddress: streetDetailsController.text,
                        ),
                        transition: Transition.fadeIn,
                      );

                      if (result == true) {
                        syncCartWithServer();
                      }
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
                            _isGoingBack
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    if (_isGoingBack) return;

                                    setState(() => _isGoingBack = true);

                                    final signalR = SignalRService();
                                    final prefs = await SharedPreferences.getInstance();

                                    try {
                                      await signalR.CloseViewCart();
                                      await prefs.setBool('cart-opened', false);

                                      if (mounted) Get.back(result: true);
                                    } catch (e) {
                                      print("Error closing cart: $e");
                                    } finally {
                                      if (mounted) setState(() => _isGoingBack = false);
                                    }
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
                                                           onTap: ()  async{
                                                              print('11');
                                                              final signalR = SignalRService();
                                                              await signalR.adjustCartItemQuantity(cartData[index].mealmeStoreId!, 'decrement');
                                                              await  syncCartWithServer(isOpened: true);
                                                              // cartBloc.add(ChangeQty(
                                                              //     productID: cartData[
                                                              //             index]
                                                              //         .productId,
                                                              //     type: ModifyType
                                                              //         .decrement));
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
                                                            onTap: ()  async{
                                                              final signalR = SignalRService();
                                                              await signalR.adjustCartItemQuantity(cartData[index].mealmeStoreId!, 'increment');
                                                              await  syncCartWithServer(isOpened: true);
                                                              // cartBloc.add(ChangeQty(
                                                              //     productID: cartData[
                                                              //             index]
                                                              //         .productId,
                                                              //     type: ModifyType
                                                              //         .increment));
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
                                          // if (!loadCreateOrder) ...[
                                          //   Padding(
                                          //     padding:
                                          //         EdgeInsets.only(bottom: 16.h),
                                          //     child: Text(
                                          //       ' Order Notes',
                                          //       style: FontUtils.h18(
                                          //         fontColor:
                                          //             const Color(0xff000000),
                                          //         fontWeight: FWT.semiBold,
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   Container(
                                          //     padding:
                                          //         const EdgeInsets.symmetric(
                                          //             horizontal: 16,
                                          //             vertical: 0),
                                          //     width: MediaQuery.of(context)
                                          //         .size
                                          //         .width,
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.white,
                                          //       borderRadius:
                                          //           BorderRadius.circular(8),
                                          //       boxShadow: [
                                          //         BoxShadow(
                                          //           color:
                                          //               const Color(0xff004C63)
                                          //                   .withOpacity(0.08),
                                          //           offset: const Offset(0, 0),
                                          //           blurRadius: 16,
                                          //         )
                                          //       ],
                                          //     ),
                                          //     child: TextFormField(
                                          //       style: const TextStyle(
                                          //           color: Colors.black),
                                          //       controller: notes,
                                          //       decoration: InputDecoration(
                                          //         enabledBorder:
                                          //             OutlineInputBorder(
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   8),
                                          //           borderSide: BorderSide.none,
                                          //         ),
                                          //         focusedBorder:
                                          //             OutlineInputBorder(
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   8),
                                          //           borderSide: BorderSide.none,
                                          //         ),
                                          //         border: OutlineInputBorder(
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   8),
                                          //           borderSide: BorderSide.none,
                                          //         ),
                                          //         contentPadding:
                                          //             const EdgeInsets.all(0),
                                          //         hintText:
                                          //             'Add order Notes.....',
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   SizedBox(height: 16.h),
                                          // ],
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
                                                        String userMobile = PreferenceUtils.getString(prefUserMobile);
                                                        if (userMobile.isEmpty) {
                                                          print('⚠️ User mobile is empty, defaulting to 1234567890');
                                                          userMobile = '1234567890';
                                                        }
                                                        int userPhone = int.tryParse(userMobile) ?? 1234567890;

                                                        final orderModel = CreateOrderModel(
                                                          userId: userId,
                                                          pickup: widget.pickUp,
                                                          mealmeItems: [],
                                                          userAddress: u_add.UserAddress(latitude: 0.0, longitude: 0.0),
                                                          userPhone: userPhone,
                                                          driverTipCents: 0,
                                                          pickupTipCents: 0,
                                                          userDropoffNotes: notes.text,

                                                          productType: 'food',
                                                          totalAmount: 0,
                                                          subtotal: 0,
                                                          deliveryFee: 0,
                                                          taxesOtherFee: 0,
                                                          store: OrderStoreModel(
                                                            storeId: '123',
                                                            storeName: 'Test Store',
                                                            storeLogo: 'https://dummyimage.com/100x100/000/fff&text=Logo',
                                                          ),
                                                        );

                                                    
                                                      restaurantBloc.add(
                                                      CreateOrderEvent(
                                                        context: context,
                                                        lat: 0.0,
                                                        lng: 0.0,
                                                        createOrderModel: orderModel,
                                                        isMock: true,
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
