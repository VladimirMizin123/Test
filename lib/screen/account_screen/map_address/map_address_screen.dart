import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import '../../../constant/asset_utils.dart';
import '../../../widget/back_button_widget.dart';
import 'package:flutter/services.dart' as s;
import 'dart:ui' as ui;

import 'map_address_screen_widget.dart';

class MapAddressScreen extends StatefulWidget {
  const MapAddressScreen({super.key});

  @override
  State<MapAddressScreen> createState() => _MapAddressScreenState();
}

class _MapAddressScreenState extends State<MapAddressScreen> {
  late GoogleMapController mapController;
  final List<Marker> _markers = <Marker>[];

  final LatLng center = const LatLng(-33.86, 151.20);

  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 14.4746,
  );
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  appSettingDialogBox() async {
    bool value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Location permissions are permanently denied, Please Enable Location Permission.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back(result: false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Close',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // setState(() {
                        //   lifeCycleCall = true;
                        // });
                        var permissionValue = await Geolocator.openAppSettings()
                            .then((value) async {});
                        // setState(() {
                        //   lifeCycleCall = false;
                        // });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Setting',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );

    return value;
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
        await appSettingDialogBox();

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

  Future getCurrentLocation() async {
    bool serviceEnabled = await _handleLocationPermission();
    if (!serviceEnabled) return;

    BitmapDescriptor? customIcon;
    List<Marker> markers = [];
    LatLng? selectedLatLng;

    /// Marker Icon for location ---------------------------------------------------------
    Future<Uint8List> getBytesFromAsset(String path, int width) async {
      ByteData data = await s.rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
    }

// make sure to initialize before map loading
    customIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(AssetsUtils.currentLocationMarker, 200));
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();

    selectedLatLng = LatLng(position.latitude, position.longitude);

    currentPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.4746,
    );

    markers = [
      Marker(
        markerId: const MarkerId('0'),
        position: LatLng(position.latitude, position.longitude),
        icon: customIcon,
      )
    ];

    setState(() {
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 330,
                    child: GoogleMap(
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      compassEnabled: true,
                      // markers: Set<Marker>.of(_markers),
                      markers: {
                        const Marker(
                          markerId: MarkerId("Sydney"),
                          position: LatLng(-33.86, 151.20),
                        ), // Marker
                      },
                      initialCameraPosition: currentPosition,
                      onMapCreated: _onMapCreated,
                    ),
                  ),
                  Positioned(
                    top: 40.h,
                    left: 10.w,
                    child: const BackButtonWidget(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    mapDetailWidget(title: "Name", initialValue: "Home"),
                    mapDetailWidget(
                        title: "Street",
                        initialValue: "430 Tanyard Rd, Rocky Mount"),
                    mapDetailWidget(
                        title: "Apartment number ", initialValue: "18"),
                    mapDetailWidget(title: "Flour", initialValue: "3"),
                    mapDetailWidget(title: "Zip", initialValue: "24151"),
                  ],
                ).paddingOnly(left: 22.w, right: 22.w, top: 8.h),
              ),
            ),
            buildButton(
                    context: context,
                    title: "Save",
                    onPressed: () {},
                    textColor: AppColors.whiteColor,
                    bgColor: AppColors.primaryBlueColor)
                .paddingOnly(left: 22.w, right: 22.w, top: 12.h),
            Text(
              "Delete address",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlueColor),
            ).paddingOnly(top: 7.h, bottom: 5.h),
          ],
        ),
      ),
    );
  }
}
