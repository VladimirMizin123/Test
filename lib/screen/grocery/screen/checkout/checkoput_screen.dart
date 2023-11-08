import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_checkout_request_model.dart'
    as checkout;
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_response_model.dart'
    as order;
import 'package:gymeats_mobile/screen/grocery/modal/create_product_request_model.dart'
    as product;
import 'package:gymeats_mobile/screen/grocery/modal/create_product_response_model.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_cart_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/order_details_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/add_debit_card_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../constant/asset_utils.dart';
import '../../../restaurants/model/get_user_address_model.dart' as address;

class CheckoutScreen extends StatefulWidget {
  final GroceryCartScreenArguments? arguments;

  const CheckoutScreen({super.key, this.arguments});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  address.UserAddress? getUserAddress;
  bool getAddressLoadingState = false;

  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 1.20,
  );
  late GoogleMapController mapController;
  LatLng? selectedLatLng;
  List<Marker> markers = [];
  Map<String, dynamic> cardData = {};
  TextEditingController notes = TextEditingController();
  order.CreateOrderData? orderData;
  List<product.ProductMealmeItems> productMealMeData = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Get Current location ---------------------------------------------------------
  Future getCurrentLocation({dynamic latitude, dynamic longitude}) async {
    // bool serviceEnabled = await _handleLocationPermission();
    // if (!serviceEnabled) return;

    BitmapDescriptor? customIcon;

// make sure to initialize before map loading
    customIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(AssetsUtils.currentLocationMarker, 150));

    // Position position = await GeolocatorPlatform.instance.getCurrentPosition();

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

  @override
  void initState() {
    super.initState();
    widget.arguments?.groceryBloc?.add(GetUserAddressEvent());
  }

  bool webViewOpen = false;
  WebViewController controller = WebViewController();

  bool createOrder = false;
  bool loadCreateOrder = false;
  ProductData? productData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: widget.arguments?.groceryBloc,
          listener: (context, state) {
            print('state===========>$state');

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

              print('loadCreateOrder---------->>>>>> $loadCreateOrder');

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

              widget.arguments?.groceryBloc?.add(
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
              print('state.data['
                  ']---------->>>>>> ${state.data['confirmUrl']}');

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
                        Get.to(() => GroceryOrderDetailsScreen(
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
          },
          builder: (BuildContext context, state) {
            return Column(
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
                    const BackButtonWidget(),
                    Text('Checkout',
                        style: FontUtils.h20(
                            fontColor: AppColors.oxFF010101,
                            fontWeight: FWT.semiBold)),
                    Opacity(
                        opacity: 0,
                        child: Text('Edit',
                            style: FontUtils.h16(
                                fontColor: AppColors.oxFF010101))),
                  ],
                ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Payment method',
                              style: FontUtils.h20(
                                  fontColor: AppColors.middleGray),
                            ),
                          ),
                          const SizedBox(height: 15),
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
                                  color:
                                      const Color(0xff004C63).withOpacity(0.08),
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
                                          final value = await Get.to(
                                            () => AddDebitCardScreen(
                                              data: cardData,
                                            ),
                                          );
                                          if (value != null) {
                                            cardData = value;
                                            setState(() {});
                                          }
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
                                              Icons.keyboard_arrow_right_sharp,
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
                                          final value = await Get.to(
                                            () => AddDebitCardScreen(
                                              data: cardData,
                                            ),
                                          );
                                          if (value != null) {
                                            cardData = value;
                                            setState(() {});
                                          }
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
                                      )
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 15),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Delivery info',
                              style: FontUtils.h20(
                                  fontColor: AppColors.middleGray),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.whiteColor,
                              boxShadow: boxShadowWidget,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  SvgPicture.asset(AssetsUtils.icLocation,
                                      color: AppColors.green, height: 25),
                                  const SizedBox(width: 15),
                                  Expanded(
                                      child: Text(
                                    widget.arguments!.askReceiveOrder.index == 0
                                        ? 'Bring me the order'
                                        : 'I will pick it myself',
                                    style: FontUtils.h18(
                                        fontColor: AppColors.black,
                                        fontWeight: FWT.medium),
                                  )),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AppManagerScreen(
                                                    selectIndex: 1),
                                          ),
                                          (route) => false);
                                    },
                                    child: Text(
                                      'Edit',
                                      style: FontUtils.h16(
                                          fontColor: AppColors.terracotta),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.chevron_right_rounded,
                                      color: AppColors.terracotta),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          /// Google Map ------------------------------------------------------------------------

                          Container(
                            height: 200.h,
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff004C63).withOpacity(0.08),
                                  offset: const Offset(0, 0),
                                  blurRadius: 16,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8)),
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      GestureDetector(
                                        onTap: () async {
                                          Get.offAll(
                                            () => const AppManagerScreen(
                                              selectIndex: 1,
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.keyboard_arrow_right_sharp,
                                          color: AppColors.darkGray,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

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
                                data:
                                    ThemeData(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  shape: Border.all(color: Colors.transparent),
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
                                            '${widget.arguments?.edgesList.length}',
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
                                        children: List.generate(
                                          widget.arguments?.edgesList.length ??
                                              0,
                                          (index) => Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${widget.arguments?.edgesList[index].product?.cartItemCount}x',
                                                      style: FontUtils.h14(
                                                        fontColor: Colors.black,
                                                        fontWeight: FWT.medium,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 230.w,
                                                      child: Text(
                                                        '${widget.arguments?.edgesList[index].itemName}',
                                                        style: FontUtils.h15(
                                                            fontColor: AppColors
                                                                .darkGray,
                                                            fontWeight:
                                                                FWT.regular),
                                                      ),
                                                    ),
                                                    Text(
                                                      '\$${((widget.arguments!.edgesList[index].product!.price! / 100) * widget.arguments!.edgesList[index].product!.cartItemCount).toStringAsFixed(2)}',
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

                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Order Notes',
                              style: FontUtils.h20(
                                fontColor: AppColors.middleGray,
                                fontWeight: FWT.semiBold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff004C63).withOpacity(0.08),
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
                                      const Icon(Icons.info_outline, size: 20),
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
                                            fontColor: const Color(0xff010101),
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
                                      '\$ ${totalAmount(widget.arguments?.edgesList ?? []).toStringAsFixed(2)}',
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
                                    print(
                                        '-===getUserAddress?.streetName.isEmpty==>${getUserAddress == null}');
                                    if (getUserAddress == null) {
                                      Fluttertoast.showToast(
                                        msg: 'Please Select Address For Order',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                      return;
                                    }

                                    if (createOrder == false) {
                                      List<CreateOrderGroceryItems> data = [];

                                      for (var element
                                          in widget.arguments!.edgesList) {
                                        data.add(
                                          CreateOrderGroceryItems(
                                            productId:
                                                element.product?.productId,
                                            productType: 2,
                                            quantity:
                                                element.product?.cartItemCount,
                                            notes: notes.text,
                                            productMarkedPrice:
                                                element.product?.originalPrice,
                                            selectedOptions: [],
                                          ),
                                        );
                                      }

                                      widget.arguments?.groceryBloc?.add(
                                        CreateOrderEvent(
                                          createGroceryOrderModel:
                                              CreateGroceryOrderModel(
                                            userId: userId,
                                            pickup: false,
                                            groceryItems: data,
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
                                              country: getUserAddress?.country,
                                              state: getUserAddress?.state,
                                              zipcode: getUserAddress?.zipcode,
                                            ),
                                            userPhone: 1234567890,
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
                                          msg: 'Please Select Card For Payment',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      } else {
                                        for (var element
                                            in orderData!.finalQuote!.items!) {
                                          print(
                                              '==element.image==>${element.image}');
                                          productMealMeData.add(
                                            product.ProductMealmeItems(
                                              name: element.name,
                                              markedPrice: element.markedPrice,
                                              quantity: element.quantity,
                                              productType: '2',
                                              productId: element.productId,
                                              image: (element.image?.isEmpty ??
                                                          false) ||
                                                      element.image == null
                                                  ? 'https://img.freepik.com/premium-photo/shopping-bag-full-fresh-fruits-vegetables-with-assorted-ingredients_8087-2232.jpg'
                                                  : element.image,
                                              basePrice: element.basePrice,
                                            ),
                                          );

                                          print(
                                              '==productMealMeData===>${productMealMeData.last.image}');
                                        }

                                        widget.arguments?.groceryBloc?.add(
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
                // Container(
                //   color: AppColors.whiteColor,
                //   child: Column(
                //     children: [
                //       const SizedBox(height: 10),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 12),
                //         child: Row(
                //           children: [
                //             Text(
                //               'Delivery fee',
                //               style: FontUtils.h14(fontColor: AppColors.black),
                //             ),
                //             const SizedBox(width: 10),
                //             const Icon(Icons.info_outline),
                //             const Spacer(),
                //             Text(
                //               'FREE',
                //               style: FontUtils.h14(fontColor: AppColors.black),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const SizedBox(height: 10),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 12),
                //         child: Row(
                //           children: [
                //             Text(
                //               'Service fee',
                //               style: FontUtils.h14(fontColor: AppColors.black),
                //             ),
                //             const SizedBox(width: 10),
                //             const Icon(Icons.info_outline),
                //             const Spacer(),
                //             Text(
                //               '\$4.00',
                //               style: FontUtils.h14(fontColor: AppColors.black),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const SizedBox(height: 10),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 12),
                //         child: Row(
                //           children: [
                //             Text(
                //               'Service fee tax',
                //               style: FontUtils.h14(fontColor: AppColors.black),
                //             ),
                //             const Spacer(),
                //             Text(
                //               '\$0.30',
                //               style: FontUtils.h14(fontColor: AppColors.black),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const SizedBox(height: 20),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 12),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'Total',
                //               style: FontUtils.h22(
                //                   fontColor: AppColors.black,
                //                   fontWeight: FWT.semiBold),
                //             ),
                //             Text(
                //               '\$ 14.97',
                //               style: FontUtils.h22(
                //                   fontColor: AppColors.black,
                //                   fontWeight: FWT.semiBold),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const SizedBox(height: 20),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 12),
                //         child: simpleTextBorderButton(
                //           context: context,
                //           color: AppColors.green,
                //           buttonLable: 'Checkout ',
                //           height: screenSize.height * 0.065,
                //           width: screenSize.width,
                //           isLoadingWidget: false,
                //           onTap: () {
                //             Get.toNamed('/PaymentCardSelectionScreen');
                //           },
                //           isDarkColor: true,
                //           isFillColor: true,
                //         ),
                //       ),
                //       const SizedBox(height: 30),
                //     ],
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget myWidgetRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: FontUtils.h18(fontColor: AppColors.black),
          ),
          Text(
            value,
            style: FontUtils.h20(
                fontColor: AppColors.black, fontWeight: FWT.semiBold),
          ),
        ],
      ),
    );
  }

  Widget myWidgetIconRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: FontUtils.h18(fontColor: AppColors.black),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.info_outline_rounded),
            ],
          ),
          Text(
            value,
            style: FontUtils.h20(fontColor: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget myWidgetAmountRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: FontUtils.h20(fontColor: AppColors.black),
          ),
          Text(
            value,
            style: FontUtils.h22(
                fontColor: AppColors.black, fontWeight: FWT.semiBold),
          ),
        ],
      ),
    );
  }

  double totalAmount(List<GroceryDetails> edgesList) {
    // '\$ ${(((edgesList[index].product!.price ?? 0) / 100) * edgesList[index].product!.cartItemCount).toStringAsFixed(2)}', //

    double total = 0;
    for (var i = 0; i < edgesList.length; i++) {
      if (edgesList[i].product != null) {
        total = total +
            ((edgesList[i].product!.price! / 100) *
                edgesList[i].product!.cartItemCount);
      }
    }
    return total;
  }
}
