import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as s;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_bloc.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_bloc.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_event.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/find_address_model.dart';
import 'package:gymeats_mobile/models/find_latlng_model.dart';
import 'package:gymeats_mobile/models/search_address_model.dart';
import 'package:gymeats_mobile/repository/google_map_searching.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/get_location/address_confirmation.dart';
import 'package:gymeats_mobile/screen/get_location/search_location.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../restaurants/model/get_user_address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUserAddress extends StatefulWidget {
  const GetUserAddress({super.key});

  @override
  State<GetUserAddress> createState() => _GetUserAddressState();
}

class _GetUserAddressState extends State<GetUserAddress>
    with WidgetsBindingObserver {
  final routeName = '/GoogleMapScreen';

  GoogleMapController? mapController;
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
  int cartCount = 0;

  Future getCurrentLocation() async {
    try {
      bool serviceEnabled = await _handleLocationPermission();
      BitmapDescriptor? customIcon;

// make sure to initialize before map loading
      customIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset(AssetsUtils.currentLocationMarker, 200));

      if (!serviceEnabled) {
        print('SERVICE NOT ENABLED');
        LatLng defaultLatLng = LatLng(37.7749, -122.4194);
        currentPosition = CameraPosition(
          target: LatLng(defaultLatLng.latitude, defaultLatLng.longitude),
          zoom: 14.4746,
        );

        markers = [
          Marker(
            markerId: const MarkerId('0'),
            position: LatLng(defaultLatLng.latitude, defaultLatLng.longitude),
            icon: customIcon,
          )
        ];

        setState(() {
          mapController
              ?.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
        });
        return;
      }

      Position position =
          await GeolocatorPlatform.instance.getCurrentPosition();

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
      
      print('GET CURRENT LOCATION');
      print(currentPosition);
      setState(() {
        mapController
            ?.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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
    print('handleLocationPermission');
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('11');
    if (!serviceEnabled) {
      print('22');

      await Geolocator.openLocationSettings().then((value) async {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          print('33');
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            showToast(
                message: 'Location permissions are denied', isSuccess: false);
            // return await appSettingDialogBox();
            return false;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          print('44');
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.deniedForever ||
              permission == LocationPermission.denied) {
            showToast(
                message:
                    'Location permissions are permanently denied, we cannot request permissions.',
                isSuccess: false);
            // return await appSettingDialogBox();
            return false;
          }
        }
      });
      return false;
    } else {
      print('55');
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print('88');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
              print('66');
          showToast(
              message: permission == LocationPermission.deniedForever
                  ? 'Location permissions are permanently denied, we cannot request permissions.'
                  : 'Location permissions are denied',
              isSuccess: false);
          // return await appSettingDialogBox();
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // await appSettingDialogBox();
         print('77');
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever) {
          showToast(
              message:
                  'Location permissions are permanently denied, we cannot request permissions.',
              isSuccess: false);
          return false;
        }
        if (permission == LocationPermission.denied) {
          showToast(
              message: 'Location permissions are denied', isSuccess: false);
          return false;
        }
      }
    }

    return true;
  }

  Future<bool> isPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return false;
    }
    return true;
  }

  Future<bool> appSettingDialogBox() async {
    bool fromRegister = argumentsValue?['string'] == 'isFromRegister';
    bool value = fromRegister
        // ignore: use_build_context_synchronously
        ? await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return SimpleDialog(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'The application needs your location to show nearby stores and restaurants. Please enable location services on your device or enter your address manually',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.whileInUse ||
                                  permission == LocationPermission.always) {
                                Get.back(result: true);
                              } else {
                                Get.back(result: false);
                              }
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
                                  'Manually',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.whileInUse ||
                                  permission == LocationPermission.always) {
                                Get.back(result: true);
                              } else {
                                await Geolocator.openAppSettings();
                              }
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
                                  'Allow',
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
          )
        // ignore: use_build_context_synchronously
        : await showDialog(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
                              if (!(await isPermissionGranted())) {
                                await openAppSettings();
                              } else {
                                Get.back(result: true);
                              }
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
    try {
      streetNum = '';
      streetName = '';
      city = '';
      stateName = '';
      country = '';
      zipcode = '';

      await _googleMapSearchRepository.findAddressURL(lat: lat, lng: lng).fold(
          (left) {
        showToast(isSuccess: false, message: left.errorMessage ?? "");
      }, (right) {
        // showToast(isSuccess: true, message: right.message!);
        FindAddressResponseModel(
            plusCode: right.plusCode,
            status: right.status,
            results: right.results);

        if (right.results?.isNotEmpty ?? false) {
          final addressComponents =
              right.results?.first.addressComponents ?? [];

          for (final component in addressComponents) {
            final types = component.types ?? [];

            if (types.contains('street_number') || types.contains('premise')) {
              streetNum = component.longName ?? "";
            } else if (types.contains('route') ||
                types.contains('sublocality_level_2')) {
              streetName = component.longName ?? "";
            } else if (types.contains('locality')) {
              city = component.longName ?? "";
            } else if (types.contains('administrative_area_level_1')) {
              stateName = component.shortName ?? "";
            } else if (types.contains('country')) {
              country = component.shortName ?? "";
            } else if (types.contains('postal_code')) {
              zipcode = component.longName ?? "";
            }
          }
        }

        searchTextController.text = (right.results?.first.formattedAddress) ??
            (right.plusCode?.compoundCode) ??
            "";
        setState(() {});
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> findLatLng(String value) async {
    try {
      await _googleMapSearchRepository.findLatLng(value).fold((left) {
        showToast(isSuccess: false, message: left.errorMessage!);
      }, (right) async {
        // showToast(isSuccess: true, message: right.message!);
        FindLatLngResponseModel(
            result: right.result,
            status: right.status,
            htmlAttributions: right.htmlAttributions);

        selectedLatLng = LatLng(right.result?.geometry?.location?.lat ?? 0,
            right.result?.geometry?.location?.lng ?? 0);

        BitmapDescriptor? customIcon;

// make sure to initialize before map loading
        customIcon = BitmapDescriptor.fromBytes(
            await getBytesFromAsset(AssetsUtils.currentLocationMarker, 200));

        currentPosition = CameraPosition(
          target: LatLng(
              selectedLatLng?.latitude ?? 0, selectedLatLng?.longitude ?? 0),
          zoom: 14.4746,
        );

        if (markers.length > 1) {
          markers.removeLast();
        }
        markers.add(
          Marker(
              markerId: const MarkerId('1'),
              position: LatLng(selectedLatLng?.latitude ?? 0,
                  selectedLatLng?.longitude ?? 0),
              icon: customIcon),
        );

        mapController
            ?.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
        searchList.clear();

        // !  Find Address Data
        final addressComponents = right.result?.addressComponents ?? [];

        for (final component in addressComponents) {
          final types = component.types ?? [];

          if (types.contains('street_number') || types.contains('premise')) {
            streetNum = component.longName ?? "";
          } else if (types.contains('route') ||
              types.contains('sublocality_level_2')) {
            streetName = component.longName ?? "";
          } else if (types.contains('locality')) {
            city = component.longName ?? "";
          } else if (types.contains('administrative_area_level_1')) {
            stateName = component.shortName ?? "";
          } else if (types.contains('country')) {
            country = component.shortName ?? "";
          } else if (types.contains('postal_code')) {
            zipcode = component.longName ?? "";
          }
        }
        setState(() {});
      });
    } catch (e) {
      log(e.toString());
    }
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
      if (argumentsValue?['string'] != 'isFromRegister') {
        addressBloc.add(GetUserAddressEvent());
        cartBloc.add(GetCartEvent());
      }
    });
    cartBloc.stream.listen((state) {
      if (state is RestaurantCartState) {
        cartCount = state.shoppingList.length;
      }
    });
  }

  MyAddressBloc addressBloc = MyAddressBloc();

  String? selectedAddress;
  List<UserAddress>? userAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  onMapCreated: (controller) {
                    _onMapCreated(controller);
                  },
                  initialCameraPosition: currentPosition,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  onTap: (argument) async {
                    try {
                      BitmapDescriptor? customIcon;

                      customIcon = BitmapDescriptor.fromBytes(
                        await getBytesFromAsset(
                            AssetsUtils.locationMarker, 150),
                      );

                      if (markers.length > 1) {
                        markers.removeLast();
                      }
                      markers.add(
                        Marker(
                          markerId: const MarkerId('1'),
                          position:
                              LatLng(argument.latitude, argument.longitude),
                          icon: customIcon,
                        ),
                      );

                      selectedLatLng =
                          LatLng(argument.latitude, argument.longitude);
                      currentPosition = CameraPosition(
                        target: LatLng(argument.latitude, argument.longitude),
                        zoom: 14.4746,
                      );
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(currentPosition));

                      findAddressURL(
                        lat: argument.latitude.toString(),
                        lng: argument.longitude.toString(),
                      );

                      setState(() {});
                    } catch (e) {
                      log(e.toString());
                    }
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
                        bool showManual =
                            argumentsValue?['string'] == 'isFromRestaurant' ||
                                argumentsValue?['string'] == 'isFromCheckout' ||
                                argumentsValue?['string'] == 'isFromGrocery';
                        return state is GetUserAddressLoadingState
                            ? const SizedBox()
                            : ListView.separated(
                                itemCount: userAddress?.length ?? 0,
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
                                          onTap: () async {
                                            final prefs = await SharedPreferences.getInstance();
                                            prefs.setBool('AddressUpdated', true);
                                            print('✅ ADDDRESS UPDATED!');

                                            if (cartCount != 0) {
                                              dynamic result = await Constant.i
                                                  .showAlertDialog(
                                                context: context,
                                                title: StringUtils
                                                    .changingAddressWillClear,
                                                desc: StringUtils
                                                    .youAlreadyHaveAnotherAddressInYourCart,
                                                cancelTask:
                                                    StringUtils.dontChange,
                                                confirmTask: StringUtils.change,
                                              );
                                              if (result != true) {
                                                return;
                                              }
                                              cartBloc.add(RemoveCart());
                                            }
                                            if (userAddress![index].isPrimary ==
                                                    false ||
                                                !PreferenceUtils
                                                    .isManualLocation) {
                                              final add = userAddress![index];
                                              addressBloc.add(
                                                SetPrimaryAddressEvent(
                                                  lat: userAddress![index]
                                                      .latitude,
                                                  lng: userAddress![index]
                                                      .longitude,
                                                  addressId:
                                                      userAddress![index].id,
                                                  onSuccess: () async {
                                                    if (argumentsValue?[
                                                                'string'] ==
                                                            'isFromRestaurant' ||
                                                        argumentsValue?[
                                                                'string'] ==
                                                            'isFromCheckout' ||
                                                        argumentsValue?[
                                                                'string'] ==
                                                            'isFromGrocery') {
                                                      await PreferenceUtils
                                                          .setManualLoation(
                                                              true);
                                                    }

                                                    PreferenceUtils
                                                        .setFoodMenuAddress(
                                                      req: {
                                                        "user_street_num":
                                                            add.streetNum ?? "",
                                                        "user_street_name":
                                                            add.streetName ??
                                                                "",
                                                        "user_city":
                                                            add.city ?? "",
                                                        "user_state":
                                                            add.state ?? "",
                                                        "user_country":
                                                            add.country ?? "",
                                                        "user_zipcode":
                                                            add.zipcode ?? "",
                                                        "extended_address":
                                                            add.extendedAddress ??
                                                                "",
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            }
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
                                                    ? (showManual &&
                                                            !PreferenceUtils
                                                                .isManualLocation)
                                                        ? AppColors.darkGray
                                                        : AppColors.terracotta
                                                    : AppColors.darkGray,
                                              ),
                                              SizedBox(
                                                width: 16.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  '${userAddress![index].streetName} ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: userAddress![index]
                                                                .isPrimary ==
                                                            true
                                                        ? (showManual &&
                                                                !PreferenceUtils
                                                                    .isManualLocation)
                                                            ? AppColors.darkGray
                                                            : AppColors
                                                                .terracotta
                                                        : AppColors.darkGray,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                              );
                      },
                      listener: (context, state) async {
                        if (state is SetAddressPrimarySuccessState) {
                          Constant.i.removeStore();
                          if (argumentsValue?['string'] == 'isFromRestaurant' ||
                              argumentsValue?['string'] == 'isFromCheckout' ||
                              argumentsValue?['string'] == 'isFromGrocery') {
                            if (argumentsValue?['string'] == 'isFromGrocery') {
                              Get.offAll(
                                  () => const AppManagerScreen(selectIndex: 1));
                            } else {
                              Get.offAll(
                                () => const AppManagerScreen(selectIndex: 3),
                              );
                            }
                          } else if (argumentsValue?['string'] ==
                              'isFromGroceryCheckout') {
                            Get.offAll(
                              () => const AppManagerScreen(selectIndex: 1),
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
                      bool isFromRegister =
                          argumentsValue?['string'] == 'isFromRegister';

                      if (!isFromRegister && selectedLatLng == null) {
                        LocationPermission permission =
                            await Geolocator.checkPermission();
                        if (permission == LocationPermission.denied ||
                            permission == LocationPermission.deniedForever) {
                          var result =
                              await Get.to(() => const SearchLocation());
                          if (result != null) {
                            selectedLocationValue = result.description;

                            findLatLng(result.placeId ?? '');
                          }
                          return;
                        }
                      }

                      if ((await isPermissionGranted()) &&
                          selectedLatLng == null) {
                        showToast(
                            message: "Wait Fetching Address", isSuccess: false);
                        Position position = await GeolocatorPlatform.instance
                            .getCurrentPosition();
                        selectedLatLng =
                            LatLng(position.latitude, position.longitude);
                      }

                      await findAddressURL(
                        lat: selectedLatLng?.latitude.toString(),
                        lng: selectedLatLng?.longitude.toString(),
                      );

                      Map<String, dynamic> addressData = {
                        'latitude': selectedLatLng?.latitude.toStringAsFixed(6),
                        'longitude':
                            selectedLatLng?.longitude.toStringAsFixed(6),
                        'street_Num': streetNum,
                        'street_Name': streetName,
                        'city': city,
                        'state': stateName.toString(),
                        'country': country,
                        'addressType': '',
                        'zipcode': zipcode,
                        'isPrimary': true,
                      };

                      if (selectedLatLng != null) {
                        Get.to(
                          () => AddressConfirmation(
                            locationData: addressData,
                            arguments: argumentsValue,
                          ),
                        );
                      } else {
                        var result = await Get.to(() => const SearchLocation());
                        if (result != null) {
                          selectedLocationValue = result.description;

                          findLatLng(result.placeId ?? '');
                        }
                      }
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
