import 'dart:async';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as s;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_bloc.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_bloc.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_event.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/models/find_address_model.dart';
import 'package:gymeats_mobile/models/find_latlng_model.dart';
import 'package:gymeats_mobile/models/search_address_model.dart';
import 'package:gymeats_mobile/repository/google_map_searching.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/get_location/address_confirmation.dart';
import 'package:gymeats_mobile/screen/get_location/search_location.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';

import 'dart:ui' as ui;

import '../restaurants/model/get_user_address_model.dart';

class GetUserAddress extends StatefulWidget {
  const GetUserAddress({super.key});

  @override
  State<GetUserAddress> createState() => _GetUserAddressState();
}

class _GetUserAddressState extends State<GetUserAddress>
    with WidgetsBindingObserver {
  final routeName = '/GoogleMapScreen';

  late GoogleMapController mapController;
  AddAddressBloc bloc = AddAddressBloc();
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  LatLng? selectedLatLng;
  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 14.4746,
  );
  String? selectedLocationValue;
  List<Marker> markers = [];

  Future getCurrentLocation() async {
    bool serviceEnabled = await _handleLocationPermission();
    if (!serviceEnabled) return;

    BitmapDescriptor? customIcon;

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
                        var permissionValue = await Geolocator.openAppSettings()
                            .then((value) async {});
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

  final GoogleMapSearchRepository _googleMapSearchRepository =
      GoogleMapSearchRepository();
  List<Prediction> searchList = [];
  String streetNum = '';
  String streetName = '';
  String city = '';
  String stateName = '';
  String country = '';
  String zipcode = '';

  Future<void> findAddressURL({String? lat, String? lng}) async {
    streetNum = '';
    streetName = '';
    city = '';
    stateName = '';
    country = '';
    zipcode = '';

    await _googleMapSearchRepository.findAddressURL(lat: lat, lng: lng).fold(
        (left) {
      showToast(isSuccess: false, message: left.errorMessage!);
    }, (right) {
      // showToast(isSuccess: true, message: right.message!);
      FindAddressResponseModel(
          plusCode: right.plusCode,
          status: right.status,
          results: right.results);

      if (right.results?.isNotEmpty ?? false) {
        right.results!.first.addressComponents?.forEach((element) {
          ///streetNum

          List<String> streetNumList = element.types
                  ?.where((element1) => element1 == 'premise')
                  .toList() ??
              [];

          if (streetNumList.isNotEmpty) {
            streetNum = element.longName ?? "";
          }

          ///streetName

          List<String> streetNameList = element.types
                  ?.where((element1) => element1 == 'sublocality_level_2')
                  .toList() ??
              [];

          if (streetNameList.isNotEmpty) {
            streetName = element.longName ?? "";
          }

          ///city

          List<String> cityList = element.types
                  ?.where((element1) => element1 == 'locality')
                  .toList() ??
              [];

          if (cityList.isNotEmpty) {
            city = element.longName ?? "";
          }

          ///State

          List<String> stateList = element.types
                  ?.where(
                      (element1) => element1 == 'administrative_area_level_1')
                  .toList() ??
              [];

          if (stateList.isNotEmpty) {
            stateName = element.longName ?? "";
          }

          ///country

          List<String> countryList = element.types
                  ?.where((element1) => element1 == 'country')
                  .toList() ??
              [];

          if (countryList.isNotEmpty) {
            country = element.longName ?? "";
          }

          ///ZIP CODE
          List<String> pinCodeList = element.types
                  ?.where((element1) => element1 == 'postal_code')
                  .toList() ??
              [];

          if (pinCodeList.isNotEmpty) {
            zipcode = element.longName ?? "";
          }
        });
      }

      searchTextController.text = right.results?.first.formattedAddress ??
          right.plusCode?.compoundCode ??
          "";
      setState(() {});
    });
  }

  Future<void> findLatLng(String value) async {
    await _googleMapSearchRepository.findLatLng(value).fold((left) {
      showToast(isSuccess: false, message: left.errorMessage!);
    }, (right) async {
      // showToast(isSuccess: true, message: right.message!);
      FindLatLngResponseModel(
          result: right.result,
          status: right.status,
          htmlAttributions: right.htmlAttributions);

      selectedLatLng = LatLng(right.result!.geometry!.location!.lat!,
          right.result!.geometry!.location!.lng!);

      BitmapDescriptor? customIcon;

// make sure to initialize before map loading
      await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(0, 0),
        ),
        AssetsUtils.locationMarker,
      ).then((d) {
        customIcon = d;
      });

      currentPosition = CameraPosition(
        target: LatLng(selectedLatLng!.latitude, selectedLatLng!.longitude),
        zoom: 14.4746,
      );

      if (markers.length > 1) {
        markers.removeLast();
      }
      markers.add(
        Marker(
            markerId: const MarkerId('1'),
            position:
                LatLng(selectedLatLng!.latitude, selectedLatLng!.longitude),
            icon: customIcon!),
      );

      mapController
          .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
      searchList.clear();
      setState(() {});
    });
  }

  FocusNode searchTextFocus = FocusNode();
  TextEditingController searchTextController = TextEditingController();
  dynamic argumentsValue;
  @override
  void initState() {
    super.initState();

    getCurrentLocation();
    argumentsValue = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (argumentsValue['string'] != 'isFromRegister') {
        addressBloc.add(GetUserAddressEvent());
      }
    });
  }

  MyAddressBloc addressBloc = MyAddressBloc();

  String? selectedAddress;
  List<UserAddress>? userAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ///Google Map===========================================
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.43,
            child: Stack(
              children: [
                GoogleMap(
                  markers: Set<Marker>.of(markers),
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: currentPosition,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  onTap: (argument) async {
                    BitmapDescriptor? customIcon;

                    customIcon = BitmapDescriptor.fromBytes(
                      await getBytesFromAsset(AssetsUtils.locationMarker, 150),
                    );

                    if (markers.length > 1) {
                      markers.removeLast();
                    }
                    markers.add(
                      Marker(
                        markerId: const MarkerId('1'),
                        position: LatLng(argument.latitude, argument.longitude),
                        icon: customIcon,
                      ),
                    );

                    selectedLatLng =
                        LatLng(argument.latitude, argument.longitude);
                    currentPosition = CameraPosition(
                      target: LatLng(argument.latitude, argument.longitude),
                      zoom: 14.4746,
                    );
                    mapController.animateCamera(
                        CameraUpdate.newCameraPosition(currentPosition));

                    findAddressURL(
                      lat: argument.latitude.toString(),
                      lng: argument.longitude.toString(),
                    );

                    setState(() {});
                  },
                ),
                Positioned(
                    top: 40.h, left: 10.w, child: const BackButtonWidget())
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: Get.width,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.h),

                  Text(
                    'Add delivery address',
                    style: TextStyle(
                      color: const Color(0xff010101),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: '',
                    ),
                  ),

                  /// SEARCHBAR========================================

                  GestureDetector(
                    onTap: () async {
                      var result = await Get.to(() => const SearchLocation());
                      if (result != null) {
                        selectedLocationValue = result.description;

                        findLatLng(result.placeId ?? '');
                      }
                    },
                    child: Container(
                      width: 335.w,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      margin: EdgeInsets.only(top: 18.h, bottom: 18.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xff004C63).withOpacity(0.08),
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 16)
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Image.asset(
                              AssetsUtils.searchIcon,
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                          SizedBox(
                            width: 280.w,
                            child: Text(
                              selectedLocationValue ?? 'Search',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xff5F5F5F),
                                fontWeight: FontWeight.w300,
                                fontSize: 14.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///CURRENT LOCATION======================================================
                  Row(
                    children: [
                      Icon(
                        Icons.my_location_outlined,
                        color: const Color(0xffCE6B53),
                        size: 22.w,
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await getCurrentLocation();
                        },
                        child: Text(
                          'Current location',
                          style: TextStyle(
                            color: const Color(0xffCE6B53),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Avenir',
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 10.h),

                  /// ADDRESS LIST ======================================================

                  Expanded(
                    child: BlocConsumer(
                      bloc: addressBloc,
                      builder: (context, state) {
                        return userAddress == null
                            ? const SizedBox()
                            : ListView.separated(
                                itemCount: userAddress!.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return userAddress?[index].isSelected == true
                                      ? Center(
                                          child: Transform.scale(
                                            scale: 0.5,
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            addressBloc.add(
                                              SetPrimaryAddressEvent(
                                                  addressId:
                                                      userAddress![index].id),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                AssetsUtils.markerFlag,
                                                height: 15.h,
                                                width: 22.w,
                                                color: userAddress![index]
                                                            .isPrimary ==
                                                        true
                                                    ? AppColors.terracotta
                                                    : AppColors.darkGray,
                                              ),
                                              SizedBox(
                                                width: 16.w,
                                              ),
                                              Text(
                                                '${userAddress![index].streetName} ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: userAddress![index]
                                                              .isPrimary ==
                                                          true
                                                      ? AppColors.terracotta
                                                      : AppColors.darkGray,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                              );
                      },
                      listener: (context, state) {
                        if (state is SetAddressPrimarySuccessState) {
                          if (argumentsValue['string'] == 'isFromRestaurant' ||
                              argumentsValue['string'] == 'isFromCheckout') {
                            Get.offAll(
                              () => const AppManagerScreen(
                                selectIndex: 3,
                              ),
                            );
                          } else if (argumentsValue['string'] ==
                              'isFromGroceryCheckout') {
                            Get.offAll(
                              () => const AppManagerScreen(
                                selectIndex: 1,
                              ),
                            );
                          } else {
                            Get.back();
                          }
                          if (userAddress != null) {
                            for (var element in userAddress!) {
                              if (element.id == state.id) {
                                element.isSelected = false;
                              }
                            }
                          }
                        }

                        if (state is GetUserAddressSuccessState) {
                          userAddress = state.userAddress;
                        }

                        if (state is SetAddressPrimaryLoadingState) {
                          if (userAddress != null) {
                            for (var element in userAddress!) {
                              if (element.id == state.id) {
                                element.isSelected = true;
                              }
                            }
                          }
                        }
                        if (state is SetAddressPrimaryErrorState) {
                          if (userAddress != null) {
                            for (var element in userAddress!) {
                              if (element.id == state.id) {
                                element.isSelected = false;
                              }
                            }
                          }
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {
                      await findAddressURL(
                        lat: selectedLatLng?.latitude.toString(),
                        lng: selectedLatLng?.longitude.toString(),
                      );

                      Map<String, dynamic> addressData = {
                        'latitude': selectedLatLng?.latitude,
                        'longitude': selectedLatLng?.longitude,
                        'street_Num': streetNum,
                        'street_Name': streetName,
                        'city': city,
                        'state': stateName.toString(),
                        'country': country,
                        'addressType': '',
                        'zipcode': zipcode,
                        'isPrimary': true,
                      };

                      Get.to(
                        () => AddressConfirmation(
                          locationData: addressData,
                          arguments: argumentsValue,
                        ),
                      );
                    },
                    child: Container(
                      height: 48.h,
                      margin: EdgeInsets.only(top: 0.h, bottom: 10.h),
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: const Color(0xffCE6B53),
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Avenir',
                          ),
                        ),
                      ),
                    ),
                  ),

                  Center(
                    child: Image.asset(
                      AssetsUtils.gymEatsSpoon,
                      height: 20.h,
                      width: 56.w,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
