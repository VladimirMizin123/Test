import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_bloc.dart';
import 'package:gymeats_mobile/models/add_address_data_navigate_model.dart';
import 'package:gymeats_mobile/models/find_address_model.dart';
import 'package:gymeats_mobile/models/find_latlng_model.dart';
import 'package:gymeats_mobile/models/search_address_model.dart';
import 'package:gymeats_mobile/repository/google_map_searching.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../bloc/google_map/add_address/add_address_event.dart';
import '../bloc/google_map/add_address/add_address_state.dart';

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

  static List ofcHomeList = ['Office', 'Home'];
  LatLng? selectedLatLng;
  CameraPosition currentPosition = const CameraPosition(
    target: LatLng(21.2147, 72.8887),
    zoom: 14.4746,
  );

  List<Marker> markers = [];
  getCurrentLocation() async {
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
      )
    ];
    setState(() {});
    return true;
  }

  String ofcHomeValue = ofcHomeList.first;
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
    await _googleMapSearchRepository.findLatLng(value).fold((left) {
      showToast(isSuccess: false, message: left.errorMessage!);
    }, (right) {
      // showToast(isSuccess: true, message: right.message!);
      FindLatLngResponseModel(
          result: right.result,
          status: right.status,
          htmlAttributions: right.htmlAttributions);

      selectedLatLng = LatLng(right.result!.geometry!.location!.lat!,
          right.result!.geometry!.location!.lng!);

      currentPosition = CameraPosition(
        target: LatLng(selectedLatLng!.latitude, selectedLatLng!.longitude),
        zoom: 14.4746,
      );

      markers = [
        Marker(
          markerId: const MarkerId('0'),
          position: LatLng(selectedLatLng!.latitude, selectedLatLng!.longitude),
        )
      ];

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
    print('==Get.arguments===>${Get.arguments}');

    var argumentsValue = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Pick Address',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await findAddressURL(
                lat: selectedLatLng!.latitude.toString(),
                lng: selectedLatLng!.longitude.toString(),
              );

              print('==streetNum=====>${streetNum}');
              print('==city=====>${city}');
              print('==streetName=====>${streetName}');
              print('==state=====>${state}');
              print('==country=====>${country}');
              print('==zipcode=====>${zipcode}');
              String userID = PreferenceUtils.getString(prefUserData);

              if (argumentsValue == 'isFromRegister') {
                AddAddressModel addAddressModel = AddAddressModel();
                addAddressModel.latitude = selectedLatLng!.latitude;
                addAddressModel.longitude = selectedLatLng!.longitude;

                addAddressModel.streetNum = streetNum;
                addAddressModel.streetName = streetName;
                addAddressModel.city = city;
                addAddressModel.state = state;
                addAddressModel.country = country;
                addAddressModel.addressType = ofcHomeValue.toLowerCase();
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
                    state: state,
                    country: country,
                    addressType: ofcHomeValue.toLowerCase(),
                    zipcode: zipcode,
                    isPrimary: false,
                    userId: userID,
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is LoadingState) {
            return const AppCenterLoader();
          } else {
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    markers: Set<Marker>.of(markers),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: currentPosition,
                    compassEnabled: true,
                    onTap: (argument) {
                      markers = [
                        Marker(
                          markerId: const MarkerId('0'),
                          position:
                              LatLng(argument.latitude, argument.longitude),
                        )
                      ];

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
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  top: 16,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: searchTextController,
                          focusNode: searchTextFocus,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            suffixIcon: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.only(right: 10),
                              child: DropdownButton(
                                underline: const SizedBox(),
                                icon: const SizedBox(),
                                value: ofcHomeValue,
                                items: List.generate(
                                  ofcHomeList.length,
                                  (index) => DropdownMenuItem(
                                    value: ofcHomeList[index],
                                    child: Text(
                                      ofcHomeList[index],
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  ofcHomeValue = value.toString();
                                  setState(() {});
                                  print('value====>${value}');
                                },
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (_debounce?.isActive ?? false)
                              _debounce?.cancel();
                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
                              searchLocation(value);
                            });
                          },
                        ),
                        if (searchList.isNotEmpty)
                          const Divider(height: 1, color: Colors.black),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                searchTextController.text =
                                    searchList[index].description ?? '';

                                findLatLng(searchList[index].placeId ?? '');
                                searchTextFocus.unfocus();
                                print(
                                    'description=====>${searchList[index].description}');
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child:
                                    Text(searchList[index].description ?? ""),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      )),
    );
  }
}
