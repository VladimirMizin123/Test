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
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_bloc.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_state.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/find_address_model.dart';
import 'package:gymeats_mobile/models/find_latlng_model.dart';
import 'package:gymeats_mobile/models/search_address_model.dart';
import 'package:gymeats_mobile/repository/google_map_searching.dart';
import 'package:gymeats_mobile/screen/account_screen/map_address/map_address_second_step.dart';
import 'package:gymeats_mobile/screen/account_screen/map_address/search_map_address.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../../bloc/google_map/add_address/add_address_event.dart';
import '../../../constant/asset_utils.dart';
import '../../../widget/back_button_widget.dart';

class MapAddressScreen extends StatefulWidget {
  final UserAddress? userAddress;

  const MapAddressScreen({super.key, this.userAddress});

  @override
  State<MapAddressScreen> createState() => _MapAddressScreenState();
}

class _MapAddressScreenState extends State<MapAddressScreen> {
  GoogleMapController? mapController;
  final formKey = GlobalKey<FormState>();

  AddAddressBloc bloc = AddAddressBloc();

  final GoogleMapSearchRepository _googleMapSearchRepository =
      GoogleMapSearchRepository();

  LatLng? selectedLatLng;
  String? selectedLocationValue;
  Marker? marker;

  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 14.4746,
  );

  String streetNum = '';
  String streetName = '';
  String city = '';
  String stateData = '';
  String country = '';
  String zipcode = '';

  TextEditingController addressNameController = TextEditingController();
  TextEditingController streetDetailsController = TextEditingController();
  TextEditingController apartmentNumberController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityField = TextEditingController();
  TextEditingController stateField = TextEditingController();
  TextEditingController countryField = TextEditingController();

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future getCurrentLocation() async {
    try {
      bool serviceEnabled = await _handleLocationPermission();

      BitmapDescriptor? customIcon;

// make sure to initialize before map loading
      customIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset(AssetsUtils.currentLocationMarker, 200));

      if (serviceEnabled) {
        Position position =
            await GeolocatorPlatform.instance.getCurrentPosition();

        selectedLatLng = LatLng(position.latitude, position.longitude);
      } else {
        selectedLatLng = LatLng(37.7749, -122.4194);
      }

      findAddressURL(
        lat: selectedLatLng?.latitude.toStringAsFixed(6).toString(),
        lng: selectedLatLng?.longitude.toStringAsFixed(6).toString(),
      );

      currentPosition = CameraPosition(
        target: LatLng(
            selectedLatLng?.latitude ?? 0.0, selectedLatLng?.longitude ?? 0.0),
        zoom: 14.4746,
      );

      marker = Marker(
        markerId: const MarkerId('0'),
        position: LatLng(
            selectedLatLng?.latitude ?? 0.0, selectedLatLng?.longitude ?? 0.0),
        icon: customIcon,
      );

      setState(() {
        mapController
            ?.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
      });
      return true;
    } catch (e) {
      print("-------Error :${e.toString()}----------");
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

  appSettingDialogBox() async {
    dynamic value = await showDialog(
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
                        await Geolocator.openAppSettings()
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

    return value == true;
  }

  Future<void> findLatLng(String value) async {
    try {
      //  final placeDetailsUrl =
      //     'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapApiKey';

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

        customIcon = BitmapDescriptor.fromBytes(
            await getBytesFromAsset(AssetsUtils.currentLocationMarker, 200));

        currentPosition = CameraPosition(
          target: LatLng(
              selectedLatLng?.latitude ?? 0, selectedLatLng?.longitude ?? 0),
          zoom: 14.4746,
        );

        marker = Marker(
            markerId: const MarkerId('1'),
            position: LatLng(
                selectedLatLng?.latitude ?? 0, selectedLatLng?.longitude ?? 0),
            icon: customIcon);

        mapController
            ?.animateCamera(CameraUpdate.newCameraPosition(currentPosition));

        // !  Find Address Data
        final addressComponents = right.result?.addressComponents ?? [];
        apartmentNumberController.clear();
        streetDetailsController.clear();
        cityField.clear();
        stateField.clear();
        countryField.clear();
        zipCodeController.clear();

        for (final component in addressComponents) {
          final types = component.types ?? [];

          if (types.contains('street_number') || types.contains('premise')) {
            apartmentNumberController.text = component.longName ?? "";
          } else if (types.contains('route') ||
              types.contains('sublocality_level_2')) {
            streetDetailsController.text = component.longName ?? "";
          } else if (types.contains('locality')) {
            cityField.text = component.longName ?? "";
          } else if (types.contains('administrative_area_level_1')) {
            stateField.text = component.shortName ?? "";
          } else if (types.contains('country')) {
            countryField.text = component.shortName ?? "";
          } else if (types.contains('postal_code')) {
            zipCodeController.text = component.longName ?? "";
          }
        }

        setState(() {});
      });
    } catch (e) {
      log(e.toString());
    }
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
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            showToast(
                message: 'Location permissions are denied', isSuccess: false);
            // return await appSettingDialogBox();
            return false;
          }
        }
        if (permission == LocationPermission.deniedForever) {
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
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
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

  Future<void> findAddressURL({String? lat, String? lng}) async {
    streetNum = '';
    streetName = '';
    city = '';
    stateData = '';
    country = '';
    zipcode = '';

    streetDetailsController.text = '';
    apartmentNumberController.text = '';
    floorNumberController.text = '';
    zipCodeController.text = '';

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
        final addressComponents = right.results?.first.addressComponents ?? [];

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
            stateData = component.shortName ?? "";
          } else if (types.contains('country')) {
            country = component.shortName ?? "";
          } else if (types.contains('postal_code')) {
            zipcode = component.longName ?? "";
          }
        }
      }

      streetDetailsController.text = streetName;
      apartmentNumberController.text = streetNum;
      floorNumberController.text = '';
      zipCodeController.text = zipcode;
      cityField.text = city;
      stateField.text = stateData;
      countryField.text = country;
    });
  }

  getDataFromPrevious() async {
    try {
      widget.userAddress;

      streetNum = '';
      streetName = '';
      city = '';
      stateData = '';
      country = '';
      zipcode = '';

      selectedLatLng =
          LatLng(widget.userAddress!.latitude!, widget.userAddress!.longitude!);

      addressNameController.text = widget.userAddress?.addressType ?? "";
      streetName = widget.userAddress?.streetName ?? '';
      streetDetailsController.text = streetName.isNotEmpty ? streetName : '';
      apartmentNumberController.text = widget.userAddress?.streetNum ?? '';
      floorNumberController.text =
          widget.userAddress?.extendedAddress?.toString() ?? "";
      zipCodeController.text = widget.userAddress?.zipcode ?? "";
      stateField.text = widget.userAddress?.state ?? "";
      cityField.text = widget.userAddress?.city ?? "";
      countryField.text = widget.userAddress?.country ?? "";

      currentPosition = CameraPosition(
        target: LatLng(
            widget.userAddress!.latitude!, widget.userAddress!.longitude!),
        zoom: 14.4746,
      );

      BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(AssetsUtils.locationMarker, 150),
      );

      marker = Marker(
        markerId: const MarkerId('0'),
        position: LatLng(
            widget.userAddress!.latitude!, widget.userAddress!.longitude!),
        icon: customIcon,
      );
      List<String> addressList = [
        apartmentNumberController.text,
        streetName,
        cityField.text,
        stateField.text,
        countryField.text
      ];
      addressList.removeWhere((element) => element.isEmpty);
      selectedLocationValue = addressList.join(", ");

      setState(() {
        mapController
            ?.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.userAddress != null) {
      getDataFromPrevious();
    } else {
      getCurrentLocation();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder(
            bloc: bloc,
            builder: (context, state) {
              if (state is AddAddressLoadingState) {
                return const AppCenterLoader();
              } else {
                return Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                          GoogleMap(
                            myLocationEnabled: false,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            compassEnabled: true,
                            onMapCreated: (controller) async {
                              _onMapCreated(controller);
                            },
                            initialCameraPosition: currentPosition,
                            markers: {
                              marker ??
                                  const Marker(
                                    markerId: MarkerId("0"),
                                  ), // Marker
                            },
                            onTap: (argument) async {
                              try {
                                BitmapDescriptor? customIcon;

                                customIcon = BitmapDescriptor.fromBytes(
                                  await getBytesFromAsset(
                                      AssetsUtils.locationMarker, 150),
                                );

                                marker = Marker(
                                  markerId: const MarkerId('1'),
                                  position: LatLng(
                                      argument.latitude, argument.longitude),
                                  icon: customIcon,
                                );

                                selectedLatLng = LatLng(
                                    argument.latitude, argument.longitude);
                                print(
                                    "Lat : ${argument.latitude} , Lng : ${argument.longitude}  ");

                                currentPosition = CameraPosition(
                                  target: LatLng(
                                      argument.latitude, argument.longitude),
                                  zoom: 14.4746,
                                );
                                mapController?.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        currentPosition));

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
                            top: 40.h,
                            left: 10.w,
                            child: const BackButtonWidget(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Trouble locating your address?\nTry using search instead",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          15.height,
                          GestureDetector(
                            onTap: () async {
                              var result =
                                  await Get.to(() => const SearchMapAddress());
                              if (result != null && result is Prediction) {
                                selectedLocationValue = result.description;

                                findLatLng(result.placeId ?? '');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xff004C63)
                                          .withOpacity(0.08),
                                      offset: const Offset(0, 0),
                                      spreadRadius: 0,
                                      blurRadius: 16)
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Image.asset(
                                      AssetsUtils.searchIcon,
                                      height: 20.h,
                                      width: 20.w,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      selectedLocationValue ??
                                          'Search street, city ,district...',
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
                        ],
                      ),
                    ),
                    buildButton(
                      context: context,
                      title: "Next",
                      onPressed: () async {
                        final result = await Get.to(
                          () => MapAddressSecondStep(
                            userAddress: widget.userAddress,
                            selectedLatLng: selectedLatLng,
                            addressNameController: addressNameController,
                            cityField: cityField,
                            apartmentNumberController:
                                apartmentNumberController,
                            stateField: stateField,
                            countryField: countryField,
                            floorNumberController: floorNumberController,
                            streetDetailsController: streetDetailsController,
                            zipCodeController: zipCodeController,
                          ),
                        );
                        if (result == true) {
                          Get.back(result: result);
                        }
                      },
                      textColor: AppColors.whiteColor,
                      bgColor: AppColors.primaryBlueColor,
                    ).paddingOnly(
                        left: 22.w, right: 22.w, top: 12.h, bottom: 10.h),
                    if (widget.userAddress != null)
                      InkWell(
                        onTap: () {
                          bloc.add(DeleteClickEvent(
                            isFrom: 'isFromProfile',
                            addressId: widget.userAddress?.id ?? '',
                          ));
                        },
                        child: Text(
                          "Delete address",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryBlueColor),
                        ).paddingOnly(top: 7.h, bottom: 5.h),
                      ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
