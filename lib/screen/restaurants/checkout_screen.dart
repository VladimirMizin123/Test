import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/restaurants/add_debit_card_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_checkout_request_model.dart'
    as checkout;
import 'package:gymeats_mobile/screen/restaurants/model/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_response_model.dart'
    as order;
import 'package:gymeats_mobile/screen/restaurants/model/create_product_request_model.dart'
    as product;
import 'package:gymeats_mobile/screen/restaurants/model/create_product_response_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/order_details_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bloc/restaurant_event.dart';
import 'bloc/restaurant_state.dart';
import 'model/get_user_address_model.dart' as address;

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({
    super.key,
    required this.cartData,
    required this.subtotal,
    required this.pickup,
  });
  final List<ShoppingListData> cartData;
  final int subtotal;
  final bool pickup;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 1.20,
  );
  late GoogleMapController mapController;
  LatLng? selectedLatLng;
  String? selectedLocationValue;
  List<Marker> markers = [];

  /// Get Current location ---------------------------------------------------------
  Future getCurrentLocation({dynamic latitude, dynamic longitude}) async {
    BitmapDescriptor? customIcon;

// make sure to initialize before map loading
    customIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(AssetsUtils.currentLocationMarker, 150));
    selectedLatLng = LatLng(latitude, longitude);

    currentPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );

    setState(() {
      markers = [
        Marker(
          markerId: const MarkerId('0'),
          position: LatLng(latitude, longitude),
          icon: customIcon!,
        )
      ];
    });
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    setState(() {});
    return true;
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
  Map<String, dynamic> cardData = {};
  bool loadCreateOrder = false;
  order.CreateOrderData? orderData;
  List<product.ProductMealmeItems> productMealMeData = [];
  bool createOrder = false;
  ProductData? productData;
  bool webViewOpen = false;

  WebViewController controller = WebViewController();

  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool getAddressLoadingState = false;
  address.UserAddress? getUserAddress;
  TextEditingController notes = TextEditingController();
  int selectedIndex = -1;
  @override
  void initState() {
    super.initState();
    restaurantBloc.add(GetUserAddressEvent());
    restaurantBloc.add(GetDeliveryStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: bloc.BlocConsumer(
          bloc: restaurantBloc,
          listener: (context, state) {
            /// User Address State---------------------------------------------------
            if (state is GetUserAddressSuccessState) {
              if (state.userAddress.isEmpty) {
              } else {
                /// address is primary then primary will be taken
                for (var i = 0; i < state.userAddress.length; i++) {
                  if (state.userAddress[i].isPrimary == true) {
                    getUserAddress = state.userAddress[i];
                    break;
                  }
                }

                /// address is not primary then first will be taken
                getUserAddress ??= state.userAddress[0];

                getCurrentLocation(
                    latitude: getUserAddress?.latitude,
                    longitude: getUserAddress?.longitude);
              }

              getAddressLoadingState = false;
            }
            if (state is GetUserAddressLoadingState) {
              getAddressLoadingState = true;
            }
            if (state is GetUserAddressErrorState) {
              getAddressLoadingState = false;
            }

            /// Create Order State ---------------------------------------------------

            if (state is CreateOrderLoadingState) {
              loadCreateOrder = true;
            }
            if (state is CreateOrderErrorState) {
              loadCreateOrder = false;
            }
            if (state is CreateOrderSuccessState) {
              orderData = state.orderData;
              if (orderData != null) {
                createOrder = true;
              }

              log('loadCreateOrder---------->>>>>> $loadCreateOrder');

              loadCreateOrder = false;
            }

            /// Create Product State ---------------------------------------------------

            if (state is CreateProductLoadingState) {
              loadCreateOrder = true;
            }
            if (state is CreateProductErrorState) {
              loadCreateOrder = false;
            }
            if (state is CreateProductSuccessState) {
              productData = state.productData;

              restaurantBloc.add(
                CreateCheckoutEvent(
                  createCheckOutRequestModel:
                      checkout.CreateCheckOutRequestModel(
                    userId: userId,
                    phoneNumber: productData!.priceId!.userPhone,
                    mealmeOrderId: productData!.priceId!.mealmeOrderId,
                    priceId: productData!.priceId!.priceId,
                    totalPrice: productData!.priceId!.totalAmount,
                    mealmeItems: productData!.priceId!.mealmeItems,
                    userCardDetails: checkout.UserCardDetails(
                      cardNumer: cardData['number'],
                      cvc: cardData['cvv'],
                      expirationMonth: int.parse(
                        cardData['valid'].toString().split('/').first,
                      ),
                      expirationYear: int.parse(
                        cardData['valid'].toString().split('/').last,
                      ),
                    ),
                  ),
                ),
              );
            }

            /// Create Checkout State ---------------------------------------------------

            if (state is CreateCheckoutLoadingState) {
              loadCreateOrder = true;
            }
            if (state is CreateCheckoutErrorState) {
              loadCreateOrder = false;
            }
            if (state is CreateCheckoutSuccessState) {
              loadCreateOrder = false;

              webViewOpen = true;
              controller
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      const Center(child: CircularProgressIndicator());
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url
                          .startsWith('https://gymeats.azurewebsites.net/')) {
                        Get.to(() => RestaurantOrderDetailsScreen(
                              mealMeOrderId:
                                  productData?.priceId?.mealmeOrderId ?? '',
                            ));
                        return NavigationDecision.prevent;
                      } else {
                        return NavigationDecision.navigate;
                      }
                    },
                  ),
                )
                ..loadRequest(
                  Uri.parse(state.data['confirmUrl']),
                );
            }

            /// Update Delivery Status ---------------------------------------------------

            if (state is GetDeliveryStatusSuccessState) {
              selectedIndex = state.data['isPickUp'] == true ? 1 : 0;
            }
          },
          builder: (context, state) {
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
                        GestureDetector(
                          onTap: () {
                            Get.back();
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
                              padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                              child: Text(
                                'Payment method',
                                style: FontUtils.h18(
                                  fontColor: const Color(0xff5F5F5F),
                                  fontWeight: FWT.medium,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.terracotta,
                                ),
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
                              child: cardData.isEmpty
                                  ? Row(
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
                                          onTap: () async {
                                            await Get.to(
                                              () => const AddDebitCardScreen(),
                                              transition: Transition.fadeIn,
                                            )!
                                                .then((value) {
                                              if (value != null) {
                                                cardData = value;
                                                setState(() {});
                                              }
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Text('Edit',
                                                  style: FontUtils.h14(
                                                      fontColor:
                                                          AppColors.terracotta,
                                                      fontWeight:
                                                          FWT.lightMedium)),
                                              const Icon(
                                                Icons
                                                    .keyboard_arrow_right_sharp,
                                                color: AppColors.terracotta,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        SvgPicture.asset(AssetsUtils.icVisa),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Visa',
                                              style: TextStyle(
                                                color: Color(0xff010101),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Ending ${cardData['number'].toString().substring(cardData['number'].toString().length - 4)}',
                                              style: const TextStyle(
                                                color: Color(0xff010101),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            await Get.to(
                                              () => AddDebitCardScreen(
                                                data: cardData,
                                              ),
                                              transition: Transition.fadeIn,
                                            )!
                                                .then((value) {
                                              if (value != null) {
                                                cardData = value;
                                                setState(() {});
                                              }
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Edit',
                                                style: FontUtils.h14(
                                                  fontColor:
                                                      AppColors.terracotta,
                                                  fontWeight: FWT.lightMedium,
                                                ),
                                              ),
                                              const Icon(
                                                Icons
                                                    .keyboard_arrow_right_sharp,
                                                color: AppColors.terracotta,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                            ),

                            ///Delivery info --------------------------------------------------------------------
                            Padding(
                              padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                              child: Text(
                                'Delivery info',
                                style: FontUtils.h18(
                                  fontColor: const Color(0xff5F5F5F),
                                  fontWeight: FWT.medium,
                                ),
                              ),
                            ),
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
                                  SvgPicture.asset(AssetsUtils.deliveryInfo),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    selectedIndex == 0
                                        ? 'Bring me the order'
                                        : 'I will pick it myself',
                                    style: const TextStyle(
                                      color: Color(0xff010101),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return DeliverOrderBottomSheet(
                                            isFrom: 'isFromCheckout',
                                            selectedIndex: selectedIndex,
                                          );
                                        },
                                        isDismissible: false,
                                        enableDrag: false,
                                        showDragHandle: false,
                                        shape: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.r),
                                            topRight: Radius.circular(16.r),
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Edit',
                                          style: FontUtils.h14(
                                            fontColor: AppColors.terracotta,
                                            fontWeight: FWT.lightMedium,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_right_sharp,
                                          color: AppColors.terracotta,
                                        )
                                      ],
                                    ),
                                  ),
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
                                      markers: Set<Marker>.of(markers),
                                      onMapCreated: _onMapCreated,
                                      initialCameraPosition: currentPosition,
                                      myLocationButtonEnabled: true,
                                      zoomControlsEnabled: false,
                                      compassEnabled: true,
                                      onTap: (argument) async {},
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => const GetUserAddress(),
                                            transition: Transition.fadeIn,
                                            arguments: {
                                              "string": 'isFromCheckout',
                                              "userData": ''
                                            });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(AssetsUtils.icHome),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: 200.w,
                                            child: Text(
                                              getUserAddress?.streetName ??
                                                  'Where?',
                                              style: const TextStyle(
                                                color: AppColors.darkGray,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.keyboard_arrow_right_sharp,
                                            color: AppColors.darkGray,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Order List ------------------------------------------------------------------------

                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              clipBehavior: Clip.none,
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
                                    shape:
                                        Border.all(color: Colors.transparent),
                                    collapsedShape:
                                        Border.all(color: Colors.transparent),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 9, vertical: 1),
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
                                                  fontWeight: FontWeight.w400),
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
                                              color: const Color(0xff004C63)
                                                  .withOpacity(0.08),
                                              offset: const Offset(0, 0),
                                              blurRadius: 16,
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: List.generate(
                                            widget.cartData.length,
                                            (index) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              margin: const EdgeInsets.only(
                                                  bottom: 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                        '${widget.cartData[index].quantity}x',
                                                        style: FontUtils.h14(
                                                          fontColor:
                                                              Colors.black,
                                                          fontWeight:
                                                              FWT.medium,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 230.w,
                                                        child: Text(
                                                          '${widget.cartData[index].productName}',
                                                          style: FontUtils.h15(
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray,
                                                              fontWeight:
                                                                  FWT.regular),
                                                        ),
                                                      ),
                                                      Text(
                                                        '\$${widget.cartData[index].price! / 100}',
                                                        style: FontUtils.h15(
                                                          fontColor:
                                                              Colors.black,
                                                          fontWeight:
                                                              FWT.medium,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 0.2,
                                                    color: Colors.black,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 8,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            /// Order Notes--------------------------------------------------------------------
                            Padding(
                              padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
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

                            SizedBox(
                              height: 16.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                          createOrder == true
                              ? Column(
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
                                          '\$${orderData!.finalQuote!.quote!.subtotal! / 100}',
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
                                        const Icon(Icons.info_outline,
                                            size: 20),
                                        const Spacer(),
                                        Text(
                                          '\$${orderData!.finalQuote!.quote!.deliveryFeeCents! / 100}',
                                          style: FontUtils.h14(
                                            fontColor: AppColors.darkGray,
                                            fontWeight: FWT.lightMedium,
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
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
                                            '\$${orderData!.finalQuote!.quote!.serviceFeeCents! / 100}',
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
                                          '\$${orderData!.finalQuote!.quote!.salesTaxCents! / 100}',
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
                                            '\$ ${orderData!.finalQuote!.quote!.totalWithoutTips! / 100}',
                                            style: FontUtils.h24(
                                              fontColor:
                                                  const Color(0xff010101),
                                              fontWeight: FWT.medium,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: FontUtils.h18(
                                          fontColor: AppColors.darkGray,
                                          fontWeight: FWT.medium,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\$${widget.subtotal / 100}',
                                        style: FontUtils.h24(
                                          fontColor: const Color(0xff010101),
                                          fontWeight: FWT.medium,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: loadCreateOrder == true
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : simpleTextBorderButton(
                                    color: AppColors.terracotta,
                                    width: MediaQuery.of(context).size.width,
                                    isFillColor: true,
                                    height: 40.h,
                                    isLoadingWidget: false,
                                    buttonLable: createOrder == true
                                        ? 'Confirm '
                                        : 'Create Order',
                                    lableColor: Colors.white,
                                    onTap: () {
                                      if (createOrder == false) {
                                        List<CreateOrderMealmeItems> data = [];

                                        for (var element in widget.cartData) {
                                          List<SelectedOptions> optionList = [];
                                          for (var element1
                                              in element.options!) {
                                            optionList.add(
                                              SelectedOptions(
                                                quantity: element1.quantity,
                                                markedPrice:
                                                    element1.markedPrice,
                                                optionId: element1.optionId,
                                              ),
                                            );
                                          }

                                          data.add(
                                            CreateOrderMealmeItems(
                                              productId: element.productId,
                                              productType: 1,
                                              quantity: element.quantity,
                                              notes: notes.text,
                                              productMarkedPrice: element.price,
                                              selectedOptions: optionList,
                                            ),
                                          );
                                        }

                                        restaurantBloc.add(
                                          CreateOrderEvent(
                                            createOrderModel: CreateOrderModel(
                                              userId: userId,
                                              pickup: widget.pickup,
                                              mealmeItems: data,
                                              userAddress: UserAddress(
                                                latitude:
                                                    getUserAddress?.latitude,
                                                longitude:
                                                    getUserAddress?.longitude,
                                                streetName:
                                                    getUserAddress?.streetName,
                                                streetNum:
                                                    getUserAddress?.streetNum,
                                                city: getUserAddress?.city,
                                                country:
                                                    getUserAddress?.country,
                                                state: getUserAddress?.state,
                                                zipcode:
                                                    getUserAddress?.zipcode,
                                              ),
                                              userPhone: int.parse(
                                                PreferenceUtils.getString(
                                                            prefUserMobile)
                                                        .isNotEmpty
                                                    ? PreferenceUtils.getString(
                                                        prefUserMobile)
                                                    : '1234567890',
                                              ),
                                              driverTipCents: 0,
                                              pickupTipCents: 0,
                                              userDropoffNotes: notes.text,
                                            ),
                                          ),
                                        );
                                      } else {
                                        /// Create Product / Create Checkout Api

                                        if (cardData.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg:
                                                'Please Select Card For Payment',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          for (var element in orderData!
                                              .finalQuote!.items!) {
                                            productMealMeData.add(
                                              product.ProductMealmeItems(
                                                name: element.name,
                                                markedPrice:
                                                    element.markedPrice,
                                                quantity: element.quantity,
                                                productType: '1',
                                                productId: element.productId,
                                                image: element.image,
                                                basePrice: element.basePrice,
                                              ),
                                            );
                                          }

                                          restaurantBloc.add(
                                            CreateProductEvent(
                                              createProductRequestModel: product
                                                  .CreateProductRequestModel(
                                                userId: userId,
                                                orderId: orderData?.orderId,
                                                totalAmount:
                                                    orderData?.totalPrice,
                                                mealmeItems: productMealMeData,
                                              ),
                                            ),
                                          );
                                        }
                                      }
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
        ),
      ),
    );
  }
}
