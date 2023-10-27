import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/order_details_screen.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/restaurants/add_debit_card_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/order_details_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/payment_method_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});
  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 10.20,
  );
  late GoogleMapController mapController;
  LatLng? selectedLatLng;
  String? selectedLocationValue;
  List<Marker> markers = [];

  /// Get Current location ---------------------------------------------------------
  Future getCurrentLocation() async {
    bool serviceEnabled = await _handleLocationPermission();
    if (!serviceEnabled) return;

    BitmapDescriptor? customIcon;

// make sure to initialize before map loading
    customIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(AssetsUtils.currentLocationMarker, 150));

    Position position = await GeolocatorPlatform.instance.getCurrentPosition();

    selectedLatLng = LatLng(position.latitude, position.longitude);

    currentPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.4746,
    );

    setState(() {
      markers = [
        Marker(
          markerId: const MarkerId('0'),
          position: LatLng(position.latitude, position.longitude),
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

  /// Permission Handler for location ---------------------------------------------------------
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings().then((value) async {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            Navigator.pop(context);
            showToast(
                message: 'Location permissions are denied', isSuccess: false);
            return false;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.deniedForever) {
            Get.back();
            showToast(
                message:
                    'Location permissions are permanently denied, we cannot request permissions.',
                isSuccess: false);
            return false;
          }
        }
      });
      return false;
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Navigator.pop(context);
          showToast(
              message: 'Location permissions are denied', isSuccess: false);
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // await appSettingDialogBox();

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever) {
          if (Get.arguments['string'] == 'isFromDashboard') {
            Get.back();
            showToast(
                message:
                    'Location permissions are permanently denied, we cannot request permissions.',
                isSuccess: false);
          } else {
            Get.offNamed('/PremiumScreen');
            showToast(
                message:
                    'Location permissions are permanently denied, we cannot request permissions.',
                isSuccess: false);
          }
          showToast(
              message:
                  'Location permissions are permanently denied, we cannot request permissions.',
              isSuccess: false);
          return false;
        }
        if (permission == LocationPermission.denied) {
          if (Get.arguments['string'] == 'isFromDashboard') {
            Get.back();
            showToast(
                message: 'Location permissions are denied', isSuccess: false);
          } else {
            Get.offNamed('/PremiumScreen');
            showToast(
                message: 'Location permissions are denied', isSuccess: false);
          }
          showToast(
              message: 'Location permissions are denied', isSuccess: false);
          return false;
        }
      }
    }

    return true;
  }

  String result = '';
  List<dynamic> data = [];
  @override
  void initState() {
    getData();
    super.initState();
    getCurrentLocation();
  }

  List cardData = [];

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    data = jsonDecode(pref.getString('cardData').toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                              color: const Color(0xff004C63).withOpacity(0.08),
                              offset: const Offset(0, 0),
                              blurRadius: 16,
                            )
                          ],
                        ),
                        child: data.isEmpty
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
                                        () => const PaymentMethodScreen(),
                                        transition: Transition.fadeIn,
                                      );
                                    },
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
                              )
                            : Row(
                                children: [
                                  SvgPicture.asset(AssetsUtils.icVisa),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Visa',
                                        style: TextStyle(
                                          color: Color(0xff010101),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Ending 1234',
                                        style: TextStyle(
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
                                        () => const PaymentMethodScreen(),
                                        transition: Transition.fadeIn,
                                      )!
                                          .then((value) => (value) {
                                                setState(() {
                                                  getData();
                                                });
                                              });
                                    },
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
                              color: const Color(0xff004C63).withOpacity(0.08),
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
                            const Text(
                              'Bring me the order',
                              style: TextStyle(
                                color: Color(0xff010101),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.offAll(
                                  () => const AppManagerScreen(
                                    selectIndex: 3,
                                  ),
                                );

                                // showModalBottomSheet(
                                //   context: context,
                                //   builder: (context) {
                                //     return const DeliverOrderBottomSheet();
                                //   },
                                //   isDismissible: false,
                                //   shape: OutlineInputBorder(
                                //     borderRadius: BorderRadius.only(
                                //       topLeft: Radius.circular(16.r),
                                //       topRight: Radius.circular(16.r),
                                //     ),
                                //     borderSide: const BorderSide(
                                //       color: Colors.transparent,
                                //     ),
                                //   ),
                                // ).then((value) {
                                //   setState(() {
                                //     result = value;
                                //   });
                                // });
                              },
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
                              color: const Color(0xff004C63).withOpacity(0.08),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AssetsUtils.icHome),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Text(
                                    'Where?',
                                    style: TextStyle(
                                      color: AppColors.darkGray,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      Get.offAll(
                                        () => const AppManagerScreen(
                                          selectIndex: 3,
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

                      /// Order List ------------------------------------------------------------------------

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            Image.asset(
                              AssetsUtils.menuIcon,
                              height: 16,
                              width: 18,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, right: 8.w),
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: AppColors.darkGray,
                            )
                          ],
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
                              color: const Color(0xff004C63).withOpacity(0.08),
                              offset: const Offset(0, 0),
                              blurRadius: 16,
                            )
                          ],
                        ),
                        child: TextFormField(
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
                        const Icon(Icons.info_outline),
                        const Spacer(),
                        Text(
                          'FREE',
                          style: FontUtils.h14(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.lightMedium,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
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
                          const Icon(Icons.info_outline),
                          const Spacer(),
                          Text(
                            '\$4.00',
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
                          '\$0.30',
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
                            '\$ 16.37',
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
                      child: simpleTextBorderButton(
                        color: AppColors.terracotta,
                        width: MediaQuery.of(context).size.width,
                        isFillColor: true,
                        height: 40.h,
                        isLoadingWidget: false,
                        buttonLable: 'Confirm ',
                        lableColor: Colors.white,
                        onTap: () {
                          Get.to(
                            () => const RestaurantOrderDetailsScreen(),
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
      ),
    );
  }
}
