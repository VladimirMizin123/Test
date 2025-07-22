import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as get_route;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_dashboard_model.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/food_intake_bottomsheet_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/res_category_data_service/res_categorydata_service.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_screen.dart';
import 'package:gymeats_mobile/widget/calorie_details_dialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../restaurants/bloc/restaurant_event.dart';
import '../../restaurants/bloc/restaurant_state.dart';
import '../../restaurants/model/get_user_address_model.dart';

class BestMatchRestaurantsScreen extends StatefulWidget {
  final String productName;
  const BestMatchRestaurantsScreen({super.key, required this.productName});

  @override
  State<BestMatchRestaurantsScreen> createState() =>
      _BestMatchRestaurantsScreenState();
}

class _BestMatchRestaurantsScreenState
    extends State<BestMatchRestaurantsScreen> {
  RestaurantBloc restaurantBloc = RestaurantBloc();

  Set<RestaurantList> restaurantList = {};
  UserAddress? getUserAddress;
  bool getAddressLoadingState = false;
  bool getRestaurantMenuLoadingState = false;
  String mealType = '';
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String? verifyLoaderId;
  final GlobalKey _alertKey = GlobalKey();
  int deliveryType = 0;
  final PanelController _controller = PanelController();

  GetDashboardModel dashboardModel = GetDashboardModel();

  @override
  void initState() {
    super.initState();
    dashboardModel = GetDashboardModel.fromJson(
        jsonDecode(PreferenceUtils.getString(dashboardModelPref)));
    restaurantBloc.add(GetUserAddressEvent());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showLogIntakeBottomSheet();
    });
  }

  showLogIntakeBottomSheet({GetUserAddress? getUserAddress}) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const LogFoodIntakeBottomSheet(isMainScreen: true);
      },
      isDismissible: false,
      enableDrag: false,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      ),
    ).then((value) {
      if (value == null) {
        Get.back();
        return;
      }
      setState(() {
        deliveryType = 0;
      });
      mealType = value;
    });
  }

  Future<void> showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DeliverOrderBottomSheet(
          selectedIndex: deliveryType,
          isFrom: 'isFromBestMatch',
        );
      },
      isDismissible: false,
      enableDrag: false,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      ),
    ).then((value) {
      if (value != null && value != -1) {
        setState(() {
          deliveryType = int.tryParse(value?.toString() ?? "") ?? 0;
          // print('DELIVERY TYPE : $deliveryType');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: restaurantBloc,
      listener: (context, state) {
        // ! Verify Restaurant Loader
        if (state is VerifyRestaurantLoader) {
          verifyLoaderId = state.id;
          if (verifyLoaderId == null) {
            if (_alertKey.currentContext != null) {
              Get.back();
            }
          } else {
            DateTime time = DateTime.now();
            showGeneralDialog(
              barrierDismissible: false,
              context: context,
              barrierColor: Colors.black54,
              pageBuilder: (BuildContext context, _, __) {
                return Material(
                  key: _alertKey,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: context.width * 0.8,
                      constraints: const BoxConstraints(maxWidth: 300),
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                  color: AppColors.primaryBlue),
                              20.height,
                              StreamBuilder(
                                stream: Stream.periodic(
                                    const Duration(milliseconds: 500)),
                                builder: (_, __) {
                                  int ml = DateTime.now()
                                      .difference(time)
                                      .inMilliseconds;
                                  return Text(
                                    ml > 1500
                                        ? StringUtils.organizingMenuItems
                                        : StringUtils.fetchingYourDelicious,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ).paddingAll(15),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                                restaurantBloc.prevId = null;
                                verifyLoaderId = null;
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          setState(() {});
        }
        // !
        if (state is GetUserAddressSuccessState) {
          if (state.userAddress.isEmpty) {
            Get.to(() => const GetUserAddress(),
                /*transition: Transition.fadeIn,*/
                arguments: {"string": 'isFromRestaurant', "userData": ''});
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

            if (getUserAddress!.streetName.toString().isEmpty ||
                getUserAddress!.streetName == null) {
              Get.to(() => const GetUserAddress(),
                  /*transition: Transition.fadeIn,*/
                  arguments: {"string": 'isFromRestaurant', "userData": ''});
            } else {
              restaurantBloc.add(
                GetRestaurantListEvent(
                  getUserAddress?.latitude ?? 0,
                  getUserAddress?.longitude ?? 0,
                  deliveryType == 1,
                  categoryDataList.map((e) => e["title"]).toList(),
                  mealName: widget.productName,
                  storeLocal: false,
                ),
              );
            }
          }
          getAddressLoadingState = false;
        }
        if (state is GetUserAddressLoadingState) {
          getAddressLoadingState = true;
        }
        if (state is GetUserAddressErrorState) {
          getAddressLoadingState = false;
        }

        /* /// Delivery Status state --------------------------------------------------------
              if (state is GetDeliveryStatusSuccessState) {
                selectedIndex = state.data['isPickUp'] == true ? 1 : 0;
              }*/

        /// Restaurant state --------------------------------------------------------
        if (state is GetRestaurantListLoadingState) {
          getRestaurantMenuLoadingState = true;
        }
        if (state is GetRestaurantListSuccessState) {
          // allRestaurantList = state.restaurantList;
          restaurantList = Set.from(state.restaurantList);
          restaurantList.forEach((element) {
            var markerIdVal = element.id.toString();
            final MarkerId markerId = MarkerId(markerIdVal);

            // creating a new MARKER
            final Marker marker = Marker(
              markerId: markerId,
              position: LatLng(element.address?.latitude ?? 0,
                  element.address?.longitude ?? 0),
              infoWindow: InfoWindow(
                  title: element.name,
                  snippet: element.address?.streetAddr ?? ''),
            );

            setState(() {
              // adding a new marker to map
              markers[markerId] = marker;
            });
          });
          // dataList = state.restaurantList;
          getRestaurantMenuLoadingState = false;
        }
        if (state is GetRestaurantListErrorState) {
          getRestaurantMenuLoadingState = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SlidingUpPanel(
            controller: _controller,
            body: Stack(
              children: [
                SizedBox(
                  height: context.height * 0.55,
                  width: context.width,
                  child: getAddressLoadingState == true
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primaryBlue),
                        )
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(getUserAddress?.latitude ?? 0,
                                getUserAddress?.longitude ?? 0),
                            zoom: 15,
                          ),
                          markers: markers.values.toSet(),
                        ),
                ),
                Positioned(
                  top: 40,
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.keyboard_arrow_left_sharp,
                        color: AppColors.darkGray, size: 40),
                  ),
                ),
              ],
            ),
            minHeight: context.height * 0.45,
            panelBuilder: (sc) => Container(
              color: AppColors.whiteColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 3.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.disable),
                        )),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'See Best Matches',
                        style: FontUtils.h22(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    getAddressLoadingState == true ||
                            getRestaurantMenuLoadingState == true
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryBlue),
                          ).paddingOnly(top: 30)
                        : restaurantList.isNotEmpty
                            ? Expanded(
                                child: ListView.separated(
                                  controller: sc,
                                  itemCount: restaurantList.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  padding:
                                      const EdgeInsets.only(bottom: 10, top: 5),
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 16);
                                  },
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      onRestaurantTap(
                                          res: restaurantList.elementAt(index));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            height: 160,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: restaurantList
                                                      .elementAt(index)
                                                      .logoPhotos!
                                                      .isEmpty
                                                  ? const DecorationImage(
                                                      image: AssetImage(
                                                        AssetsUtils
                                                            .restaurantFood,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : DecorationImage(
                                                      image: NetworkImage(
                                                          restaurantList
                                                              .elementAt(index)
                                                              .logoPhotos![0]),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                restaurantList
                                                            .elementAt(index)
                                                            .quotes
                                                            ?.cheapestDelivery
                                                            ?.deliveryFee
                                                            ?.deliveryFeeFlat ==
                                                        0
                                                    ? Container(
                                                        width: 109,
                                                        margin: const EdgeInsets
                                                            .all(12),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: Center(
                                                          child: Text(
                                                            'Free Delivery',
                                                            style:
                                                                FontUtils.h16(
                                                              fontColor:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FWT.regular,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                const Spacer(),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    height: 30,
                                                    width: 109,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    margin:
                                                        const EdgeInsets.all(9),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Image.asset(AssetsUtils
                                                            .ratingStar),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4),
                                                          child: Center(
                                                            child: Text(
                                                              restaurantList
                                                                  .elementAt(
                                                                      index)
                                                                  .weightedRatingValue!
                                                                  .toStringAsFixed(
                                                                      1),
                                                              style:
                                                                  FontUtils.h16(
                                                                fontColor:
                                                                    Colors
                                                                        .black,
                                                                fontWeight:
                                                                    FWT.regular,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            '(${restaurantList.elementAt(index).aggregatedRatingCount ?? ''})',
                                                            style:
                                                                FontUtils.h12(
                                                              fontColor:
                                                                  AppColors
                                                                      .disable,
                                                              fontWeight:
                                                                  FWT.regular,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, bottom: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    restaurantList
                                                            .elementAt(index)
                                                            .name ??
                                                        '',
                                                    style: FontUtils.h18(
                                                      fontColor:
                                                          AppColors.darkGray,
                                                      fontWeight: FWT.semiBold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 22,
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.lightGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      restaurantList
                                                                  .elementAt(
                                                                      index)
                                                                  .cuisines!
                                                                  .isEmpty ||
                                                              restaurantList
                                                                      .elementAt(
                                                                          index)
                                                                      .cuisines ==
                                                                  []
                                                          ? ''
                                                          : restaurantList
                                                              .elementAt(index)
                                                              .cuisines![0],
                                                      style: FontUtils.h14(
                                                        fontColor:
                                                            AppColors.darkGray,
                                                        fontWeight:
                                                            FWT.lightMedium,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: Text(
                                    'Currently No Restaurant Found',
                                    style: FontUtils.h18(
                                      fontColor: AppColors.darkGray,
                                      fontWeight: FWT.medium,
                                    ),
                                  ),
                                ),
                              )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onRestaurantTap({required RestaurantList res}) async {
    try {
      if ((dashboardModel.data?.totalIntakeFood?.round() ?? 0) >=
          (dashboardModel.data?.totalCalorie?.round() ?? 0)) {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.transparentColor,
          isScrollControlled: true,
          builder: (context) => CalorieDetailsDialog(
            dashboardModel: dashboardModel,
            onContinueTap: () => verifyRestaurant(res: res),
          ),
        );
      } else {
        verifyRestaurant(res: res);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void verifyRestaurant({required RestaurantList res}) async {
    try {
      restaurantBloc.prevId = res.id;
      if (verifyLoaderId != null) {
        return;
      }

      restaurantBloc.add(
        RestaurantVerifyEvent(
          latitude: getUserAddress?.latitude ?? 0,
          longitude: getUserAddress?.longitude ?? 0,
          pickup: false,
          id: res.id ?? "",
          restaurantName: res.name,
          mealType: mealType,
          context: context,
          onVerify: (menu, quote) async {
            print("VERIFIED");
            await Future.delayed(Duration(milliseconds: 500));
            print(verifyLoaderId);
            if (verifyLoaderId != null || !mounted) {
              return;
            }
            Get.to(
              () => RestaurantMenuScreen(
                getUserAddress: getUserAddress,
                address: res.address ?? Address(),
                userId: res.id ?? "",
                restaurantName: res.name ?? '',
                restaurantId: res.id ?? "",
                pickup: deliveryType == 1,
                bloc: restaurantBloc,
                mealType: mealType,
                menu: menu,
                startedLoading: true,
                quote: quote,
              ),
              transition: get_route.Transition.fadeIn,
            );
          },
          notVerify: () {
            print('NOT VERIFIED');
          },
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
