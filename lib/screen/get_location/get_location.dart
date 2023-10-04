import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/models/add_address_data_navigate_model.dart';
import 'package:gymeats_mobile/models/find_address_model.dart';
import 'package:gymeats_mobile/models/find_latlng_model.dart';
import 'package:gymeats_mobile/models/search_address_model.dart';
import 'package:gymeats_mobile/repository/google_map_searching.dart';
import 'package:gymeats_mobile/screen/get_location/search_location.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';

import '../../bloc/google_map/add_address/add_address_event.dart';
import '../../bloc/google_map/add_address/add_address_state.dart';

class GetUserAddress extends StatefulWidget {
  const GetUserAddress({super.key});

  @override
  State<GetUserAddress> createState() => _GetUserAddressState();
}

class _GetUserAddressState extends State<GetUserAddress> {
  final routeName = '/GoogleMapScreen';

  late GoogleMapController mapController;
  AddAddressBloc bloc = AddAddressBloc();
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Timer? _debounce;

  static List ofcHomeList = ['Home', 'Office'];
  LatLng? selectedLatLng;
  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 14.4746,
  );
  String? selectedLocationValue;
  List<Marker> markers = [];
  Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
        await GeolocatorPlatform.instance.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await GeolocatorPlatform.instance.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await GeolocatorPlatform.instance.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    BitmapDescriptor? customIcon;

// make sure to initialize before map loading
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(0, 0),
      ),
      AssetsUtils.currentLocationMarker,
    ).then((d) {
      customIcon = d;
    });
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();

    print('==aaa====>$position');
    selectedLatLng = LatLng(position.latitude, position.longitude);

    currentPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.4746,
    );

    markers = [
      Marker(
        markerId: const MarkerId('0'),
        position: LatLng(position.latitude, position.longitude),
        icon: customIcon!,
      )
    ];
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    setState(() {});
    return true;
  }

  String ofcHomeValue = ofcHomeList.first;
  int ofcHomeInt = 0;
  final GoogleMapSearchRepository _googleMapSearchRepository =
      GoogleMapSearchRepository();
  List<Prediction> searchList = [];

  Future<void> searchLocation(String value) async {
    await _googleMapSearchRepository.searchLocation(value).fold((left) {
      showToast(isSuccess: false, message: left.errorMessage!);
    }, (right) {
      // showToast(isSuccess: true, message: right.message!);
      SearchAddressResponseModel(
          predictions: right.predictions, status: right.status);

      searchList = right.predictions ?? [];
      setState(() {});
    });
  }

  String streetNum = '';
  String streetName = '';
  String city = '';
  String state = '';
  String country = '';
  String zipcode = '';

  Future<void> findAddressURL({String? lat, String? lng}) async {
    streetNum = '';
    streetName = '';
    city = '';
    state = '';
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
                  ?.where((element1) => element1 == 'sublocality_level_3')
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
            state = element.longName ?? "";
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

        print('==streetNum=====>${streetNum}');
        print('==city=====>${city}');
        print('==streetName=====>${streetName}');
        print('==state=====>${state}');
        print('==country=====>${country}');
        print('==zipcode=====>${zipcode}');
      }

      searchTextController.text = right.results?.first.formattedAddress ??
          right.plusCode?.compoundCode ??
          "";
      setState(() {});
    });
  }

  Future<void> findLatLng(String value) async {
    print('==value====>${value}');

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

  addAddress() {}

  FocusNode searchTextFocus = FocusNode();
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    var argumentsValue = Get.arguments;
    return Scaffold(
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is LoadingState) {
            return const AppCenterLoader();
          } else {
            return Column(
              children: [
                ///Google Map===========================================

                Expanded(
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

                          await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(
                              size: Size(0, 0),
                            ),
                            AssetsUtils.locationMarker,
                          ).then((d) {
                            customIcon = d;
                          });

                          if (markers.length > 1) {
                            markers.removeLast();
                          }
                          markers.add(
                            Marker(
                              markerId: const MarkerId('1'),
                              position:
                                  LatLng(argument.latitude, argument.longitude),
                              icon: customIcon!,
                            ),
                          );

                          selectedLatLng =
                              LatLng(argument.latitude, argument.longitude);
                          currentPosition = CameraPosition(
                            target:
                                LatLng(argument.latitude, argument.longitude),
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
                          top: 40.h,
                          left: 10.w,
                          child: const BackButtonWidget())
                    ],
                  ),
                ),

                Container(
                  height: 342,
                  width: Get.width,
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 22.h,
                      ),
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
                          var result =
                              await Get.to(() => const SearchLocation());
                          if (result != null) {
                            selectedLocationValue = result.description;

                            findLatLng(result.placeId ?? '');
                          }
                        },
                        child: Container(
                          height: 48.h,
                          width: 335.w,
                          margin: EdgeInsets.only(top: 22.h, bottom: 22.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xff004C63).withOpacity(0.08),
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

                          // child: TextFormField(
                          //   controller: searchTextController,
                          //   focusNode: searchTextFocus,
                          //   readOnly: true,
                          //   decoration: InputDecoration(
                          //       hintText: 'Search',
                          //       hintStyle: TextStyle(
                          //         color: const Color(0xff5F5F5F),
                          //         fontWeight: FontWeight.w300,
                          //         fontSize: 14.sp,
                          //       ),
                          //       enabledBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(8.r),
                          //         borderSide: const BorderSide(
                          //             color: Colors.transparent),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(8.r),
                          //         borderSide: const BorderSide(
                          //             color: Colors.transparent),
                          //       ),
                          //       prefixIcon: Padding(
                          //         padding: EdgeInsets.all(14.h),
                          //         child: Image.asset(
                          //           AssetsUtils.locationIcon,
                          //           height: 20.h,
                          //           width: 20.w,
                          //         ),
                          //       )
                          //       // suffixIcon: Container(
                          //       //   decoration: BoxDecoration(
                          //       //     color: Colors.grey.shade200,
                          //       //     borderRadius: BorderRadius.circular(6.r),
                          //       //   ),
                          //       //   padding:
                          //       //       const EdgeInsets.symmetric(horizontal: 10),
                          //       //   margin: const EdgeInsets.only(right: 10),
                          //       //   child: DropdownButton(
                          //       //     underline: const SizedBox(),
                          //       //     icon: const SizedBox(),
                          //       //     value: ofcHomeValue,
                          //       //     items: List.generate(
                          //       //       ofcHomeList.length,
                          //       //       (index) => DropdownMenuItem(
                          //       //         value: ofcHomeList[index],
                          //       //         child: Text(
                          //       //           ofcHomeList[index],
                          //       //         ),
                          //       //       ),
                          //       //     ),
                          //       //     onChanged: (value) {
                          //       //       ofcHomeValue = value.toString();
                          //       //       setState(() {});
                          //       //       print('value====>${value}');
                          //       //     },
                          //       //   ),
                          //       // ),
                          //       ),
                          //   onChanged: (value) {
                          //     if (_debounce?.isActive ?? false) {
                          //       _debounce?.cancel();
                          //     }
                          //     _debounce =
                          //         Timer(const Duration(milliseconds: 500), () {
                          //       searchLocation(value);
                          //     });
                          //   },
                          // ),
                        ),
                      ),

                      ///Current location======================================================
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

                      SizedBox(
                        height: 12.h,
                      ),

                      ///OFFICE======================================================

                      ...List.generate(
                        2,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                ofcHomeValue = ofcHomeList[index];
                                ofcHomeInt = index;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  AssetsUtils.markerFlag,
                                  height: 15.h,
                                  width: 22.w,
                                  color: ofcHomeInt == index
                                      ? Colors.red
                                      : Colors.black,
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  ofcHomeList[index],
                                  style: TextStyle(
                                    color: ofcHomeInt == index
                                        ? Colors.red
                                        : const Color(0xff373737),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Avenir',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          await findAddressURL(
                            lat: selectedLatLng?.latitude.toString(),
                            lng: selectedLatLng?.longitude.toString(),
                          );

                          String userID =
                              PreferenceUtils.getString(prefUserData);

                          if (argumentsValue == 'isFromRegister') {
                            AddAddressModel addAddressModel = AddAddressModel();
                            addAddressModel.latitude = selectedLatLng?.latitude;
                            addAddressModel.longitude =
                                selectedLatLng?.longitude;

                            addAddressModel.streetNum = streetNum;
                            addAddressModel.streetName = streetName;
                            addAddressModel.city = city;
                            addAddressModel.state = state.toString();
                            addAddressModel.country = country;
                            addAddressModel.addressType =
                                ofcHomeValue.toLowerCase();
                            addAddressModel.zipcode = zipcode;
                            addAddressModel.isPrimary = false;

                            Get.back(result: addAddressModel);
                          } else {
                            bloc.add(
                              SaveClickEvent(
                                latitude: selectedLatLng!.latitude,
                                longitude: selectedLatLng!.longitude,
                                streetNum: streetNum,
                                streetName: streetName,
                                city: city,
                                state: state.toString(),
                                country: country,
                                addressType: ofcHomeValue.toLowerCase(),
                                zipcode: zipcode,
                                isPrimary: false,
                                userId: userID,
                              ),
                            );
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
                )
              ],
            );
          }
        },
      ),
    );
  }
}
