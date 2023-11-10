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
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_bloc.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_state.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/models/find_address_model.dart';
import 'package:gymeats_mobile/repository/google_map_searching.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../../bloc/google_map/add_address/add_address_event.dart';
import '../../../constant/asset_utils.dart';
import '../../../widget/back_button_widget.dart';
import 'map_address_screen_widget.dart';

class MapAddressScreen extends StatefulWidget {
  final UserAddress? userAddress;

  const MapAddressScreen({super.key, this.userAddress});

  @override
  State<MapAddressScreen> createState() => _MapAddressScreenState();
}

class _MapAddressScreenState extends State<MapAddressScreen> {
  late GoogleMapController mapController;
  final formKey = GlobalKey<FormState>();
  static const List<String> addressTypeList = ['Home', 'Office'];
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

  TextEditingController streetNameController =
      TextEditingController(text: addressTypeList.first);
  TextEditingController streetDetailsController = TextEditingController();
  TextEditingController apartmentNumberController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future getCurrentLocation() async {
    bool serviceEnabled = await _handleLocationPermission();
    if (!serviceEnabled) return;

    BitmapDescriptor? customIcon;

// make sure to initialize before map loading
    customIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(AssetsUtils.currentLocationMarker, 200));
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();

    selectedLatLng = LatLng(position.latitude, position.longitude);
    findAddressURL(
      lat: selectedLatLng?.latitude.toString(),
      lng: selectedLatLng?.longitude.toString(),
    );

    currentPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.4746,
    );

    marker = Marker(
      markerId: const MarkerId('0'),
      position: LatLng(position.latitude, position.longitude),
      icon: customIcon,
    );

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
            stateData = element.longName ?? "";
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

      streetDetailsController.text =
          '${streetName.isNotEmpty ? '$streetName, ' : ''}${city.isNotEmpty ? '$city, ' : ''}${stateData.isNotEmpty ? '$stateData, ' : ''}${country.isNotEmpty ? '$country. ' : ''}';
      apartmentNumberController.text = streetNum;
      floorNumberController.text = '';
      zipCodeController.text = zipcode;

      setState(() {});
    });
  }

  getDataFromPrevious() async {
    widget.userAddress;

    streetNum = '';
    streetName = '';
    city = '';
    stateData = '';
    country = '';
    zipcode = '';

    selectedLatLng =
        LatLng(widget.userAddress!.latitude!, widget.userAddress!.longitude!);

    streetNameController.text =
        addressTypeList.contains((widget.userAddress?.addressType ?? ""))
            ? widget.userAddress?.addressType ?? ""
            : addressTypeList.first;
    streetName = widget.userAddress?.streetName?.split(',').first ?? '';
    streetDetailsController.text =
        '${streetName.isNotEmpty ? '$streetName, ' : ''}${widget.userAddress?.city?.isNotEmpty ?? false ? '${widget.userAddress?.city}, ' : ''}${widget.userAddress?.state?.isNotEmpty ?? false ? '${widget.userAddress?.state}, ' : ''}${widget.userAddress?.country?.isNotEmpty ?? false ? '${widget.userAddress?.country}. ' : ''}';

    '$streetName, ${widget.userAddress?.city ?? ''}, ${widget.userAddress?.state ?? ''}, ${widget.userAddress?.country ?? ''}';
    apartmentNumberController.text = widget.userAddress?.streetNum ?? '';
    floorNumberController.text =
        widget.userAddress?.streetName?.split(',').last.split(' ').last ?? '';
    zipCodeController.text = widget.userAddress?.zipcode ?? "";

    currentPosition = CameraPosition(
      target:
          LatLng(widget.userAddress!.latitude!, widget.userAddress!.longitude!),
      zoom: 14.4746,
    );

    BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(
      await getBytesFromAsset(AssetsUtils.locationMarker, 150),
    );

    marker = Marker(
      markerId: const MarkerId('0'),
      position:
          LatLng(widget.userAddress!.latitude!, widget.userAddress!.longitude!),
      icon: customIcon,
    );

    setState(() {
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 330,
                            child: GoogleMap(
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: false,
                              compassEnabled: true,
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: currentPosition,
                              markers: {
                                marker ??
                                    const Marker(
                                      markerId: MarkerId("0"),
                                    ), // Marker
                              },
                              onTap: (argument) async {
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
                                currentPosition = CameraPosition(
                                  target: LatLng(
                                      argument.latitude, argument.longitude),
                                  zoom: 14.4746,
                                );
                                mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        currentPosition));

                                findAddressURL(
                                  lat: argument.latitude.toString(),
                                  lng: argument.longitude.toString(),
                                );

                                setState(() {});
                              },
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
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              mapDetailWidget(
                                title: "Name",
                                // initialValue: streetNameController.text,
                                // textEditingController: streetNameController,
                                readOnly: true,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButton(
                                          value: streetNameController.text,
                                          items: List.generate(
                                            addressTypeList.length,
                                            (index) => DropdownMenuItem(
                                              value: addressTypeList[index],
                                              child: Text(
                                                addressTypeList[index],
                                              ),
                                            ),
                                          ),
                                          underline: const SizedBox(),
                                          isExpanded: true,
                                          onChanged: (value) {
                                            streetNameController.text =
                                                value ?? "";
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              mapDetailWidget(
                                title: "Street",
                                // initialValue: streetDetailsController.text,
                                textEditingController: streetDetailsController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Street details';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              mapDetailWidget(
                                title: "Apartment number ",
                                // initialValue: apartmentNumberController.text,
                                textEditingController:
                                    apartmentNumberController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Apartment number';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              mapDetailWidget(
                                title: "Flour",
                                // initialValue: floorNumberController.text,
                                textEditingController: floorNumberController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Flour number';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              mapDetailWidget(
                                title: "Zip",
                                // initialValue: zipCodeController.text,
                                textEditingController: zipCodeController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Zip Code';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ).paddingOnly(left: 22.w, right: 22.w, top: 8.h),
                        ),
                      ),
                    ),
                    buildButton(
                            context: context,
                            title: "Save",
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              if (widget.userAddress != null) {
                                /// Update existing address
                                bloc.add(
                                  UpdateClickEvent(
                                    latitude: selectedLatLng!.latitude,
                                    longitude: selectedLatLng!.longitude,
                                    streetNum: apartmentNumberController.text,
                                    streetName:
                                        '${streetName.isNotEmpty ? '$streetName, ' : ''}Floor no. ${floorNumberController.text}',
                                    city: city,
                                    state: stateData,
                                    country: country,
                                    addressType: streetNameController.text,
                                    zipcode: zipCodeController.text,
                                    isPrimary:
                                        widget.userAddress?.isPrimary ?? false,
                                    userId:
                                        PreferenceUtils.getString(prefUserData),
                                    isFrom: 'isFromProfile',
                                    addressId: widget.userAddress?.id ?? '',
                                  ),
                                );
                              } else {
                                ///ADD NEW ADDRESS
                                bloc.add(
                                  SaveClickEvent(
                                    latitude: selectedLatLng!.latitude,
                                    longitude: selectedLatLng!.longitude,
                                    streetNum: apartmentNumberController.text,
                                    streetName:
                                        '${streetName.isNotEmpty ? '$streetName, ' : ''}Floor no. ${floorNumberController.text}',
                                    city: city,
                                    state: stateData,
                                    country: country,
                                    addressType: streetNameController.text,
                                    zipcode: zipCodeController.text,
                                    isPrimary: true,
                                    userId:
                                        PreferenceUtils.getString(prefUserData),
                                    isFrom: 'isFromProfile',
                                  ),
                                );
                              }
                            },
                            textColor: AppColors.whiteColor,
                            bgColor: AppColors.primaryBlueColor)
                        .paddingOnly(
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
