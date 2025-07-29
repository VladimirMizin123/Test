import 'dart:developer';
import 'dart:ui' as ui;
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/card_bloc/card_bloc.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/models/payment_status_model.dart';
import 'package:gymeats_mobile/models/stripe_card_model.dart';
import 'package:gymeats_mobile/repository/get_restaurant_details.dart';
import 'package:gymeats_mobile/screen/account_screen/card_screen/view/card_crud_screen.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/payment/payment_success_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_checkout_request_model.dart'
    as checkout;

import 'package:gymeats_mobile/screen/restaurants/model/create_product_request_model.dart'
    as product;
import 'package:gymeats_mobile/screen/restaurants/model/create_product_response_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';

import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/credit_card_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bloc/restaurant_event.dart';
import 'bloc/restaurant_state.dart';
import 'model/get_user_address_model.dart' as address;
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart'
    as res_addd;
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart'
    as groc_add;
import 'package:gymeats_mobile/service/signalr_service.dart';
import 'dart:convert';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_request_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({
    super.key,
    this.cartData,
    this.orderData,
    this.groceryList,
    required this.isFromGrocery,
    this.hasMultipleStore = false,
    required this.getUserAddress,
    this.grocAdd,
    this.createMultipleOrder = false,
    this.currentAddress,
    // required this.subtotal,
    // required this.pickup,
  });
  
  final address.UserAddress? getUserAddress;
  final groc_add.Address? grocAdd;
  final bool isFromGrocery;
  final bool hasMultipleStore;
  final bool createMultipleOrder;
  final String? currentAddress;
  final List<GroceryDetails>? groceryList;

  final dynamic /*List<ShoppingListData>*/ cartData;
  final dynamic /*order.CreateOrderData?*/ orderData;

  // final int subtotal;
  // final bool pickup;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final ApiServices apiServices = ApiServices();
  GoogleMapController? _mapController;
  String orderId = '';
  bool _isGoingBack = false;
  bool isCheckoutLoading = false;
  bool paymentSucceed = false;

  Future<void> getCheckout() async {
    setState(() {
      isCheckoutLoading = true;
    });
    final signalR = SignalRService();
    final data = await signalR.goToCheckout();

    final fareItems = data['FareBreakdownItems'] as List<dynamic>?;

    if (fareItems == null) {
      return;
    }

    int? subtotal = _getAmountByLabel(fareItems, 'Subtotal');
    int? deliveryFee = _getAmountByLabel(fareItems, 'Delivery Fee');
    int? serviceFee = _getAmountByLabel(fareItems, 'Fees');
    int? taxesAndFees = _getAmountByLabel(fareItems, 'Taxes & Other Fees');

    setState(() {
      widget.orderData?.finalQuote?.quote?.subtotal = (subtotal ?? 0);
      widget.orderData?.finalQuote?.quote?.deliveryFeeCents = (deliveryFee ?? 0);
      widget.orderData?.finalQuote?.quote?.serviceFeeCents = (serviceFee ?? 0);
      widget.orderData?.finalQuote?.quote?.salesTaxCents = (taxesAndFees ?? 0);
      isCheckoutLoading = false;
    });
  }

  int _getAmountByLabel(List<dynamic> items, String label) {
    final item = items.firstWhere(
      (e) => e['Label'] == label,
      orElse: () => null,
    );

    if (item != null) {
      final amount = item['Amount'] as num;
      return (amount * 100).round(); 
    }

    return 0;
  }


  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    (double?, double?) i = await Constant.i.position;
    double lat = (widget.grocAdd?.latitude) ??
        (findResAddress?.latitude ??
            (i.$1 ?? (widget.getUserAddress?.latitude ?? 0)));
    double lng = (widget.grocAdd?.longitude) ??
        (findResAddress?.longitude ??
            (i.$2 ?? widget.getUserAddress?.longitude ?? 0));
    getCurrentLocation(latitude: lat, longitude: lng);
  }

  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 1.20,
  );

  GoogleMapController? mapController;
  LatLng? selectedLatLng;
  String? selectedLocationValue;
  List<Marker>? markers = [];
  bool paymentStatusLoader = false;

  final CardBloc _cardBloc = CardBloc();

  List<StripeCard> cardList = [];
  bool cardLoading = false;

  /// Get Current location ---------------------------------------------------------
  Future getCurrentLocation({dynamic latitude, dynamic longitude}) async {
    try {
      BitmapDescriptor? customIcon;

// make sure to initialize before map loading
      customIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset(AssetsUtils.currentLocationMarker, 150));
      selectedLatLng = LatLng(latitude, longitude);
      currentPosition = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers = [
        Marker(
          markerId: const MarkerId('0'),
          position: LatLng(latitude, longitude),
          icon: customIcon,
        )
      ];

      mapController
          ?.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
      setState(() {});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Marker Icon for location ---------------------------------------------------------
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  String result = '';
  List<dynamic> data = [];
  // Map<String, dynamic> cardData = {};
  StripeCard? selectedCard;
  bool loadCreateOrder = false;
  int maxAttempt = 3;

  // order.CreateOrderData? orderData;
  List<product.ProductMealmeItems> productMealMeData = [];

  // bool createOrder = false;
  ProductData? productData;
  bool webViewOpen = false;

  WebViewController controller = WebViewController();

  RestaurantBloc restaurantBloc = RestaurantBloc();

  // bool getAddressLoadingState = false;

  // address.UserAddress? getUserAddress;
  TextEditingController notes = TextEditingController();
  int selectedIndex = 0;
  // List<String> optionsList = ['Bring me the order', 'I will pick it up myself'];
    List<String> optionsList = ['Bring me the order'];

  // RxBool ;

  @override
  void initState() {
    restaurantBloc.add(GetUserAddressEvent());
    restaurantBloc.add(GetDeliveryStatusEvent());

    _cardBloc.add(ListAllCardEvent());
    getCheckout();
    super.initState();
  }

  @override
  void dispose() {
    PreferenceUtils.removePref(paymentCard);
    super.dispose();
  }

  Future<bool> handleAutoPayment(Map<String, dynamic> data, StripeCard selectedCard) async {
  try {
    setState(() {
      paymentSucceed = false;
    });
    if (selectedCard == null || paymentSucceed == true) {
      return false;
    }

    Stripe.publishableKey = data['publishableKey'];
    await Stripe.instance.applySettings();

    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: data['paymentIntentClientSecret'],
      data: PaymentMethodParams.cardFromMethodId(
        paymentMethodData: PaymentMethodDataCardFromMethod(
          paymentMethodId: selectedCard.id!,
        ),
      ),
    );

    setState(() {
      paymentSucceed = true;
    });


    final signalR = SignalRService();
    await signalR.placeOrder();

    final url = '${ApiUrls.baseUrl}api/MealmeOrder/UpdateOrderStatus';
    final body = {
      "orderId": data['orderId'],
      "uberEatsOrderId": "string",
      "orderStatus": 2,
    };

    print("UpdateOrderStatus: $url");
    print("Req: ${jsonEncode(body)}");

    final response = await apiServices.post(url, body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("UpdateOrderStatus Success: ${response.body}");
      return true;
    } else {
      print("UpdateOrderStatus Error: ${response.body}");
      return false;
    }

  } catch (e) {
    return false;
  }
}

  res_addd.Address? get findResAddress {
    if (widget.cartData is List<ShoppingListData>) {
      List<ShoppingListData> data = widget.cartData as List<ShoppingListData>;
      if (data.isNotEmpty && selectedIndex == 1) {
        return data.first.resAddress;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double subTotal =
        (widget.orderData?.finalQuote?.quote?.subtotal ?? 0) / 100;
    double deliveryFee =
        (widget.orderData?.finalQuote?.quote?.deliveryFeeCents ?? 0) / 100;
    double serviceFee =
        (widget.orderData?.finalQuote?.quote?.serviceFeeCents ?? 0) / 100;
    double serviceFeeTax =
        (widget.orderData?.finalQuote?.quote?.salesTaxCents ?? 0) / 100;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: bloc.BlocConsumer<CardBloc, CardState>(
          bloc: _cardBloc,
          listener: (_, state) {
            if (state is CardLoadingState) {
              cardLoading = state.isLoading;
              setState(() {});
            }

            if (state is CardFetchSuccessState) {
              cardList = state.cardList;
              print("CARD LIST $cardList");

              StripeCard? card = cardList.firstWhereOrNull((element) => element.isPrimary ?? false);

              if (cardList.isNotEmpty) {
                print('CARD LIST IS NOT EMPTYT $card');
                selectedCard = cardList.first;
                print(cardList.first);
              } else {
                selectedCard = null;
              }
              print('SELECTED CARD: $selectedCard');
              setState(() {});
            }
          },
          builder: (context, state) {
            return bloc.BlocConsumer(
              bloc: restaurantBloc,
              listener: (context, state) {
                if (state is CreateProductLoadingState) {
                  loadCreateOrder = true;
                }
                if (state is CreateProductErrorState) {
                  loadCreateOrder = false;
                }
                if (state is CreateProductSuccessState) {
                  // productData = state.productData;
                  // print(selectedCard?.id);

                  // restaurantBloc.add(
                  //   CreateCheckoutEvent(
                  //     createCheckOutRequestModel:
                  //         checkout.CreateCheckOutRequestModel(
                  //       userId: userId,
                  //       isPickUp: selectedIndex == 1,
                  //       phoneNumber: 0,
                  //       mealmeOrderId: orderId,
                  //       priceId: 'string',
                  //       totalPrice: 100,
                  //       cardId: selectedCard?.id,
                  //       productType:
                  //           widget.isFromGrocery ? "Grocery" : "Restaurant",
                  //     ),
                  //   ),
                  // );
                }


                if (state is CreateCheckoutLoadingState) {
                  loadCreateOrder = true;
                }
                if (state is CreateCheckoutErrorState) {
                  loadCreateOrder = false;
                }
                if (state is CreateOrderSuccessState) {
                  final orderId = state.orderData?.orderId;

                  restaurantBloc.add(
                    CreateCheckoutEvent(
                      createCheckOutRequestModel:
                          checkout.CreateCheckOutRequestModel(
                        userId: userId,
                        isPickUp: false,
                        phoneNumber: 0,
                        mealmeOrderId: orderId,
                        priceId: 'string',
                        totalPrice: double.parse(
                          (subTotal + deliveryFee + serviceFee + serviceFeeTax).toStringAsFixed(2),
                        ),
                        cardId: selectedCard?.id,
                        productType:
                            widget.isFromGrocery ? "Grocery" : "Restaurant",
                      ),
                    ),
                  );

                  // if (orderId != null) {
                  //   setState(() {
                  //     this.orderId = orderId;
                  //   });

                  //   final productType = widget.isFromGrocery ? 'Grocery' : 'Restaurant';

                  //   final requestModel = product.CreateProductRequestModel(
                  //     orderId: orderId,
                  //     productType: productType,
                  //     totalAmount: 1,
                  //   );

                  //   restaurantBloc.add(
                  //     CreateProductEvent(
                  //       createProductRequestModel: requestModel,
                  //     ),
                  //   );
                  // }
                }
                if (state is CreateCheckoutSuccessState) {
                  loadCreateOrder = false;
                  print('Create checkout success!');
                  final Map<String, dynamic> data = Map<String, dynamic>.from(state.data);

                  handleAutoPayment(data, selectedCard!).then((result) {
                    if (result == true) {
                      Get.offAll(() => const PaymentSuccessScreen()); 
                    } else {
                      showToast(
                        message: "Something went wrong with payment",
                        isSuccess: false,
                      );
                    }
                  });
                }
                /// Update Delivery Status ---------------------------------------------------

                if (state is GetDeliveryStatusSuccessState) {
                  selectedIndex = state.data['isPickUp'] == true ? 1 : 0;
                  if (_mapController != null) {
                    _onMapCreated(_mapController!);
                  }
                }
              },
              builder: (context, state) {
                if (paymentStatusLoader) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (webViewOpen == true) {
                  return WebViewWidget(controller: controller);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
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

                                    try {
                                      PreferenceUtils.removePref(paymentCard);
                                      signalR.goBack();

                                      if (mounted) Get.back(result: true);
                                    } catch (e) {
                                      print("Error going back: $e");
                                    } finally {
                                      if (mounted) setState(() => _isGoingBack = false);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                  ),
                                ),
                            const Text(
                              'Checkout',
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
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Payment method --------------------------------------------------------------------
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.h, bottom: 16.h),
                                  child: Text(
                                    'Payment method',
                                    style: FontUtils.h18(
                                      fontColor: const Color(0xff5F5F5F),
                                      fontWeight: FWT.medium,
                                    ),
                                  ),
                                ),
                                cardLoading
                                    ? cardLoader()
                                    : cardList.isEmpty
                                        ? defaultCard()
                                        : Builder(
                                            builder: (_) {
                                              StripeCard card = cardList
                                                      .firstWhereOrNull(
                                                          (element) =>
                                                              element
                                                                  .isPrimary ??
                                                              false) ??
                                                  cardList.first;
                                              return CreditCardWidget(
                                                card: card,
                                                onTap: () {
                                                  Get.to(
                                                    () => CardCrudScreen(
                                                      cardBloc: _cardBloc,
                                                      card: card,
                                                      deleteAccess: false,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),

                                ///Delivery info --------------------------------------------------------------------
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.h, bottom: 16.h),
                                  child: Text(
                                    'Delivery info',
                                    style: FontUtils.h18(
                                      fontColor: const Color(0xff5F5F5F),
                                      fontWeight: FWT.medium,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Text(
                                    ' Order Notes',
                                    style: FontUtils.h18(
                                      fontColor: const Color(0xff000000),
                                      fontWeight: FWT.semiBold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff004C63)
                                            .withOpacity(0.08),
                                        offset: const Offset(0, 0),
                                        blurRadius: 16,
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: notes,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.all(0),
                                      hintText: 'Add order Notes.....',
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16.h),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff004C63)
                                            .withOpacity(0.08),
                                        offset: const Offset(0, 0),
                                        blurRadius: 16,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          AssetsUtils.deliveryInfo),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        // selectedIndex == 0
                                        //     ? 'Bring me the order'
                                        //     : 'I will pick it up myself',
                                        'Bring me the order',
                                        style: const TextStyle(
                                          color: Color(0xff010101),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const Spacer(),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     showModalBottomSheet(
                                      //       context: context,
                                      //       builder: (context) {
                                      //         return DeliverOrderBottomSheet(
                                      //           isFrom: 'isFromCheckout',
                                      //           selectedIndex: selectedIndex,
                                      //         );
                                      //       },
                                      //       isDismissible: true,
                                      //       enableDrag: true,
                                      //       showDragHandle: false,
                                      //       isScrollControlled: true,
                                      //       shape: OutlineInputBorder(
                                      //         borderRadius: BorderRadius.only(
                                      //           topLeft: Radius.circular(16.r),
                                      //           topRight: Radius.circular(16.r),
                                      //         ),
                                      //         borderSide: const BorderSide(
                                      //           color: Colors.transparent,
                                      //         ),
                                      //       ),
                                      //     ).then((value) {
                                      //       setState(() {
                                      //         List<String> options = [
                                      //           'Bring me the order',
                                      //           'I will pick it up myself'
                                      //         ];
                                      //         result = value ??
                                      //             options[selectedIndex];
                                      //         int sIndex =
                                      //             result == 'Bring me the order'
                                      //                 ? 0
                                      //                 : 1;

                                      //         if (selectedIndex != sIndex) {
                                      //           Get.offAll(AppManagerScreen(
                                      //               selectIndex:
                                      //                   widget.isFromGrocery
                                      //                       ? 1
                                      //                       : 3));
                                      //         }
                                      //       });
                                      //     });
                                      //   },
                                      //   child: Row(
                                      //     children: [
                                      //       Text(
                                      //         'Edit',
                                      //         style: FontUtils.h14(
                                      //           fontColor: AppColors.terracotta,
                                      //           fontWeight: FWT.lightMedium,
                                      //         ),
                                      //       ),
                                      //       const Icon(
                                      //         Icons.keyboard_arrow_right_sharp,
                                      //         color: AppColors.terracotta,
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),

                                /// Google Map ------------------------------------------------------------------------

                                Container(
                                  height: 200.h,
                                  margin: EdgeInsets.symmetric(vertical: 16.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff004C63)
                                            .withOpacity(0.08),
                                        offset: const Offset(0, 0),
                                        blurRadius: 16,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: GoogleMap(
                                          markers:
                                              Set<Marker>.of(markers ?? []),
                                          onMapCreated: (controller) {
                                            if (!selectedIndex.isNegative) {
                                              _onMapCreated(controller);
                                            } else {
                                              _mapController = controller;
                                            }
                                          },
                                          initialCameraPosition:
                                              currentPosition,
                                          myLocationButtonEnabled: true,
                                          zoomControlsEnabled: false,
                                          compassEnabled: true,
                                          onTap: (argument) async {},
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 12, vertical: 16),
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       Get.to(() => const GetUserAddress(),
                                      //           transition: Transition.fadeIn,
                                      //           arguments: {
                                      //             "string": 'isFromCheckout',
                                      //             "userData": ''
                                      //           });
                                      //     },
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         SvgPicture.asset(
                                      //             AssetsUtils.icHome),
                                      //         const SizedBox(
                                      //           width: 15,
                                      //         ),
                                      //         SizedBox(
                                      //           width: 200.w,
                                      //           child: Text(
                                      //             widget.grocAdd?.streetAddr ??
                                      //                 (findResAddress
                                      //                         ?.streetAddr ??
                                      //                     (PreferenceUtils
                                      //                             .isManualLocation
                                      //                         ? (widget
                                      //                                 .getUserAddress
                                      //                                 ?.streetName ??
                                      //                             'Where?')
                                      //                         : widget.currentAddress ??
                                      //                             "Current Location")),
                                      //             style: const TextStyle(
                                      //               color: AppColors.darkGray,
                                      //               fontSize: 14,
                                      //               fontWeight: FontWeight.w300,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         const Spacer(),
                                      //         const Icon(
                                      //           Icons
                                      //               .keyboard_arrow_right_sharp,
                                      //           color: AppColors.darkGray,
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),

                                /// Order List ------------------------------------------------------------------------

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  clipBehavior: Clip.none,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xff004C63)
                                                .withOpacity(0.08),
                                            offset: const Offset(0, 0),
                                            blurRadius: 16,
                                          )
                                        ],
                                      ),
                                      child: Theme(
                                        data: ThemeData(
                                            dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                          shape: Border.all(
                                              color: Colors.transparent),
                                          collapsedShape: Border.all(
                                              color: Colors.transparent),
                                          title: Row(
                                            children: [
                                              Image.asset(
                                                AssetsUtils.menuIcon,
                                                height: 16,
                                                width: 18,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.w, right: 8.w),
                                                child: const Text(
                                                  'Your Order',
                                                  style: TextStyle(
                                                    color: Color(0xff010101),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 9,
                                                        vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: AppColors.terracotta,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${widget.cartData.length}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            Container(
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
                                              child: Column(
                                                children: _yourOrder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: const Color(0xff004C63).withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 0),
                          )
                        ]),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              isCheckoutLoading == true ?  
                              const Center(
                                child:
                                    CircularProgressIndicator())
                              :
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: FontUtils.h14(
                                          fontColor: AppColors.darkGray,
                                          fontWeight: FWT.lightMedium,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\$$subTotal',
                                        style: FontUtils.h14(
                                          fontColor: AppColors.darkGray,
                                          fontWeight: FWT.lightMedium,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Delivery fee',
                                        style: FontUtils.h14(
                                          fontColor: AppColors.darkGray,
                                          fontWeight: FWT.lightMedium,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.info_outline, size: 20),
                                      const Spacer(),
                                      Text(
                                        '\$$deliveryFee',
                                        style: FontUtils.h14(
                                          fontColor: AppColors.darkGray,
                                          fontWeight: FWT.lightMedium,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Service fee',
                                          style: FontUtils.h14(
                                            fontColor: AppColors.darkGray,
                                            fontWeight: FWT.lightMedium,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.info_outline,
                                            size: 20),
                                        const Spacer(),
                                        Text(
                                          '\$$serviceFee',
                                          style: FontUtils.h14(
                                            fontColor: AppColors.darkGray,
                                            fontWeight: FWT.lightMedium,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Service fee tax',
                                        style: FontUtils.h14(
                                          fontColor: AppColors.darkGray,
                                          fontWeight: FWT.lightMedium,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\$$serviceFeeTax',
                                        style: FontUtils.h14(
                                          fontColor: AppColors.darkGray,
                                          fontWeight: FWT.lightMedium,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Total',
                                          style: FontUtils.h18(
                                            fontColor: AppColors.darkGray,
                                            fontWeight: FWT.medium,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$ ${(subTotal + deliveryFee + serviceFee + serviceFeeTax).toStringAsFixed(2)}',
                                          style: FontUtils.h24(
                                            fontColor: const Color(0xff010101),
                                            fontWeight: FWT.medium,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: 
                                // loadCreateOrder == true
                                //     ? const Center(
                                //         child: CircularProgressIndicator(),
                                //       )
                                //     : 
                                    simpleTextBorderButton(
                                        color: AppColors.terracotta,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        isFillColor: true,
                                        height: 40.h,
                                        isLoadingWidget: false,
                                        buttonLable: 'Confirm',
                                        lableColor: Colors.white,
                                        onTap: () {
                                          //   if (createOrder == false) {
                                          //     List<CreateOrderMealmeItems> data = [];
                                          //
                                          //     for (var element in widget.cartData) {
                                          //       List<SelectedOptions> optionList = [];
                                          //       for (var element1
                                          //           in element.options!) {
                                          //         optionList.add(
                                          //           SelectedOptions(
                                          //             quantity: element1.quantity,
                                          //             markedPrice:
                                          //                 element1.markedPrice,
                                          //             optionId: element1.optionId,
                                          //           ),
                                          //         );
                                          //       }
                                          //
                                          //       data.add(
                                          //         CreateOrderMealmeItems(
                                          //           productId: element.productId,
                                          //           productType: 1,
                                          //           quantity: element.quantity,
                                          //           notes: notes.text,
                                          //           productMarkedPrice: element.price,
                                          //           selectedOptions: optionList,
                                          //         ),
                                          //       );
                                          //     }
                                          //
                                          //     restaurantBloc.add(
                                          //       CreateOrderEvent(
                                          //         createOrderModel: CreateOrderModel(
                                          //           userId: userId,
                                          //           pickup: widget.pickup,
                                          //           mealmeItems: data,
                                          //           userAddress: UserAddress(
                                          //             latitude:
                                          //                 getUserAddress?.latitude,
                                          //             longitude:
                                          //                 getUserAddress?.longitude,
                                          //             streetName:
                                          //                 getUserAddress?.streetName,
                                          //             streetNum:
                                          //                 getUserAddress?.streetNum,
                                          //             city: getUserAddress?.city,
                                          //             country:
                                          //                 getUserAddress?.country,
                                          //             state: getUserAddress?.state,
                                          //             zipcode:
                                          //                 getUserAddress?.zipcode,
                                          //           ),
                                          //           userPhone: int.parse(
                                          //             PreferenceUtils.getString(
                                          //                         prefUserMobile)
                                          //                     .isNotEmpty
                                          //                 ? PreferenceUtils.getString(
                                          //                     prefUserMobile)
                                          //                 : '1234567890',
                                          //           ),
                                          //           driverTipCents: 0,
                                          //           pickupTipCents: 0,
                                          //           userDropoffNotes: notes.text,
                                          //         ),
                                          //       ),
                                          //     );
                                          //   } else {
                                          /// Create Product / Create Checkout Api

                                          if (selectedCard == null) {
                                            showToast(
                                              message:
                                                  'Please Select Card For Payment',
                                              isSuccess: false,
                                              color: AppColors.black,
                                            );
                                          } else {
                                              productMealMeData.clear();

                                              List<CreateOrderMealmeItems> data = [];
                                              for (var element in widget.orderData!.finalQuote!.items!) {
                                                data.add(
                                                  CreateOrderMealmeItems(
                                                    productId: element.productId,
                                                    name: element.name,
                                                    image: element.image,
                                                    productType: int.tryParse(
                                                      widget.isFromGrocery ? 'Grocery' : 'Restaurant',
                                                    ),
                                                    quantity: element.quantity ?? 0,
                                                    notes: '',
                                                    productMarkedPrice: element.markedPrice ?? 0,
                                                    selectedOptions: [],
                                                  ),
                                                );
                                              }

                                              final productType = widget.isFromGrocery ? 'Grocery' : 'Restaurant';

                                              final userMobile = PreferenceUtils.getString(prefUserMobile);
                                              final userPhone = int.tryParse(userMobile.isNotEmpty ? userMobile : '1234567890') ?? 1234567890;

                                              SharedPreferences.getInstance().then((prefs) {
                                                 final jsonString = prefs.getString("currentRestaurant");
                                                final Map<String, dynamic> restaurantData =
                                                    jsonString != null ? jsonDecode(jsonString) : {};

                                                final String storeId = restaurantData["id"] ?? "defaultStoreId";
                                                final String storeName = restaurantData["name"] ?? "Default Store";
                                                final String storeLogo = restaurantData["logo"] ?? "";
                                              
                                                final orderModel = CreateOrderModel(
                                                  userId: userId,
                                                  pickup: false,
                                                  mealmeItems: data,
                                                  userAddress: UserAddress(latitude: 0.0, longitude: 0.0),
                                                  userPhone: userPhone,
                                                  driverTipCents: 0,
                                                  pickupTipCents: 0,
                                                  userDropoffNotes: notes.text,
                                                  productType: productType,
                                                  totalAmount: widget.orderData?.totalPrice?.toDouble() ?? 0,
                                                  subtotal: widget.orderData?.totalPrice?.toDouble() ?? 0,
                                                  deliveryFee: 0,
                                                  taxesOtherFee: 0,
                                                  store: OrderStoreModel(
                                                    storeId: widget.orderData?.finalQuote?.storeId ?? 'store123',
                                                    storeName: widget.orderData?.finalQuote?.store ?? 'Test Store',
                                                    storeLogo: 'https://dummyimage.com/100x100/000/fff&text=Logo',
                                                  ),
                                                );

                                                restaurantBloc.add(
                                                  CreateOrderEvent(
                                                    context: context,
                                                    lat: 0.0,
                                                    lng: 0.0,
                                                    createOrderModel: orderModel,
                                                    isMock: false,
                                                  ),
                                                );
                                              });
                                             

                                              // restaurantBloc.add(
                                              //   CreateProductEvent(
                                              //     createProductRequestModel: product.CreateProductRequestModel(
                                              //       userId: userId,
                                              //       orderId: widget.orderData?.orderId,
                                              //       totalAmount: widget.orderData?.totalPrice ?? 0,
                                              //       mealmeItems: productMealMeData,
                                              //     ),
                                              //   ),
                                              // );
                                            }
                                          // }
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
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _yourOrder() {
    if (widget.cartData is List<MenuItemList>) {
      List<MenuItemList> cartList = widget.cartData as List<MenuItemList>;
      return List.generate(
        cartList.length,
        (index) {
          MenuItemList cart = cartList[index];
          return _orderCardWidget(
              cart.cartQuantity ?? 0, cart.name ?? "", cart.price);
        },
      );
    }
    if (widget.cartData is List<ShoppingListData>) {
      List<ShoppingListData> cartList =
          widget.cartData as List<ShoppingListData>;
      return List.generate(
        cartList.length,
        (index) {
          ShoppingListData cart = cartList[index];
          return _orderCardWidget(
            cart.quantity ?? 0,
            cart.productName ?? "",
            cart.price,
          );
        },
      );
    }
    List<Cart> cart =
        widget.cartData is List<Cart> ? widget.cartData as List<Cart> : [];
    return List.generate(
      cart.length,
      (index) {
        List<GroceryResult> groceryList = cart[index].groceryResult ?? [];

        return Column(
          children: groceryList
              .map((e) =>
                  e.products
                      ?.where((element) => element.isAddedToShoppingList)
                      .map(
                    (e) {
                      return _orderCardWidget(
                          e.cartItemCount, '${e.itemName}', e.price);
                    },
                  ).toList() ??
                  [])
              .toList()
              .expand((element) => element)
              .toList(),
        );
      },
    );
  }

  Widget _orderCardWidget(int qty, String productName, int? price) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${qty}x',
                style: FontUtils.h14(
                  fontColor: Colors.black,
                  fontWeight: FWT.medium,
                ),
              ),
              SizedBox(
                width: 230.w,
                child: Text(
                  productName,
                  style: FontUtils.h15(
                      fontColor: AppColors.darkGray, fontWeight: FWT.regular),
                ),
              ),
              Text(
                '\$${(price ?? 0) / 100}',
                style: FontUtils.h15(
                  fontColor: Colors.black,
                  fontWeight: FWT.medium,
                ),
              )
            ],
          ),
          Container(
            height: 0.2,
            color: Colors.black,
            margin: const EdgeInsets.symmetric(
              vertical: 8,
            ),
          )
        ],
      ),
    );
  }

  Widget cardLoader() {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey,
      highlightColor: AppColors.lightGrey.withOpacity(0.95),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.disable,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget defaultCard() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: AppColors.terracotta,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff004C63).withOpacity(0.08),
              offset: const Offset(0, 0),
              blurRadius: 16,
            )
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(AssetsUtils.debitCard),
            const SizedBox(
              width: 15,
            ),
            const Text(
              'Choose payment\nmethod',
              style: TextStyle(
                color: Color(0xff010101),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Get.to(() => CardCrudScreen(cardBloc: _cardBloc)),
              child: Row(
                children: [
                  Text('Edit',
                      style: FontUtils.h14(
                          fontColor: AppColors.terracotta,
                          fontWeight: FWT.lightMedium)),
                  const Icon(
                    Icons.keyboard_arrow_right_sharp,
                    color: AppColors.terracotta,
                  )
                ],
              ),
            )
          ],
        ),
      );
}
