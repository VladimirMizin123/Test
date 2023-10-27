import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/food_intake_bottomsheet_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/credit_card.dart';
import 'package:gymeats_mobile/screen/restaurants/filter_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_screen.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const DeliverOrderBottomSheet();
      },
      isDismissible: false,
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
      if (value != null) {
        setState(() {
          result = value;
        });

        if (getUserAddress != null) {
          log('getUserAddress---------->>>>>> ${getUserAddress}');

          restaurantBloc.add(
            GetRestaurantListEvent(
              getUserAddress?.latitude ?? 0,
              getUserAddress?.longitude ?? 0,
              getUserAddress?.streetNum ?? '',
              getUserAddress?.streetName ?? '',
              getUserAddress?.city ?? '',
              getUserAddress?.state ?? '',
              getUserAddress?.country ?? '',
              getUserAddress?.zipcode ?? '',
              result == 'Bring me the order' ? false : true,
              5,
            ),
          );

          restaurantBloc.add(
            GetCousinesEvent(
              getUserAddress?.latitude ?? 0,
              getUserAddress?.longitude ?? 0,
              getUserAddress?.streetNum ?? '',
              getUserAddress?.streetName ?? '',
              getUserAddress?.city ?? '',
              getUserAddress?.state ?? '',
              getUserAddress?.country ?? '',
              getUserAddress?.zipcode ?? '',
              result == 'Bring me the order' ? false : true,
              5,
            ),
          );
        } else {
          log('getUserAddress-----ee----->>>>>> ${getUserAddress}');
        }
      }
    });
  }

  showLogIntakeBottomSheet({GetUserAddress? getUserAddress}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const LogFoodIntakeBottomSheet(
          isMainScreen: true,
        );
      },
      isDismissible: false,
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
      setState(() {
        showBottomSheet();
      });
    });
  }

  List mealType = [
    'All',
    'Italian',
    'Chinese',
    'Asian',
    'Healthy',
    'Cheap',
  ];

  List selectedFoodOrigin = [];
  UserAddress? getUserAddress;
  Set<RestaurantList> restaurantList = {};
  Set<RestaurantList> ratingFilter = {};
  Set<RestaurantList> finalData = {};
  List<RestaurantList> allRestaurantList = [];
  List<RestaurantList> dataList = [];
  CousinesList? cousinesList;
  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool loading = false;
  bool loading1 = false;
  var result = '';
  bool hasData = false;
  bool isRestaurantData = false;
  List rating = [];
  bool isFastDelivery = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurantBloc.add(GetUserAddressEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: bloc.BlocConsumer(
          bloc: restaurantBloc,
          listener: (context, state) {
            if (state is GetUserAddressSuccessState) {
              if (state.userAddress.isEmpty) {
                Get.to(() => const GetUserAddress(),
                    transition: Transition.fadeIn,
                    arguments: {"string": 'isFromCheckout', "userData": ''});
              } else {
                showLogIntakeBottomSheet();

                /// address is primary then primary will be taken
                for (var i = 0; i < state.userAddress.length; i++) {
                  if (state.userAddress[i].isPrimary == true) {
                    getUserAddress = state.userAddress[i];
                    break;
                  }
                }

                /// address is not primary then first will be taken
                getUserAddress ??= state.userAddress[0];
              }
              loading = false;
            }
            if (state is GetUserAddressLoadingState) {
              loading = true;
            }
            if (state is GetUserAddressErrorState) {
              loading = false;
            }

            /// Restaurant state --------------------------------------------------------
            if (state is GetRestaurantListLoadingState) {
              loading = true;
            }
            if (state is GetRestaurantListSuccessState) {
              allRestaurantList = state.restaurantList;
              dataList = state.restaurantList;
              loading = false;
            }
            if (state is GetRestaurantListErrorState) {
              loading = false;
            }

            /// Cousines State ----------------------------------------------------------

            if (state is GetCousinesListLoadingState) {
              loading1 = true;
            }
            if (state is GetCousinesListSuccessState) {
              cousinesList = state.cousinesList;
              cousinesList!.cousines!.isEmpty
                  ? hasData = false
                  : hasData = true;
              loading1 = false;
            }
            if (state is GetCousinesListErrorState) {
              loading1 = false;
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Center(
                    child: Image.asset(
                      AssetsUtils.gymEatsSpoon,
                      height: 22.h,
                      width: 56.w,
                      color: AppColors.terracotta,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Get.toNamed('ProfileScreen');
                        },
                        child: Image.asset(
                          AssetsUtils.user,
                          height: 25.h,
                          width: 25.w,
                          color: AppColors.darkGray,
                        ),
                      ),
                      Text(
                        StringUtils.restaurants,
                        style: textTheme.displayMedium?.copyWith(
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      ),
                      Image.asset(
                        AssetsUtils.notification,
                        height: 25.h,
                        width: 25.w,
                        color: AppColors.darkGray,
                      )
                    ],
                  ),

                  /// Choose Delivery type ---------------------------------------------------------
                  GestureDetector(
                    onTap: () {
                      showBottomSheet();
                    },
                    child: Container(
                      height: 30,
                      width: 225.w,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.terracotta, width: 1),
                        color: AppColors.coral,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            AssetsUtils.deliveryVehicle,
                            width: 15,
                            height: 15,
                            color: AppColors.terracotta,
                          ),
                          Text(
                            result.isEmpty ? 'Choose delivery type' : result,
                            style: const TextStyle(
                                color: AppColors.terracotta,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Avenir'),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.terracotta,
                          )
                        ],
                      ),
                    ),
                  ),

                  /// Search bar -------------------------------------------------------------------

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 48,
                          width: 245.w,
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
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.darkGray,
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              hintText: 'Search for item or place',
                            ),
                          ),
                        ),
                        Container(
                          height: 48,
                          width: 77,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                AssetsUtils.icShoppingIcon,
                                color: AppColors.darkGray,
                              ),
                              Text(
                                '0',
                                style: FontUtils.h18(
                                    fontColor: AppColors.darkGray,
                                    fontWeight: FWT.medium),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Location ---------------------------------------------------------------------
                  IntrinsicWidth(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 55.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AssetsUtils.icRestaurants,
                            height: 14,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              getUserAddress == null
                                  ? 'No Location'
                                  : getUserAddress?.streetName ?? '',
                              style: FontUtils.h14(
                                fontColor: AppColors.darkGray,
                                fontWeight: FWT.lightMedium,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: loading == true || loading1 == true
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              /// Tab bar ----------------------------------------------------------------------

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    height: 40.h,
                                    child: hasData == false
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await Get.to(
                                                    () => FilterScreen(
                                                      cousinesList:
                                                          cousinesList!,
                                                      restaurantList:
                                                          allRestaurantList,
                                                      selectedCategory:
                                                          selectedFoodOrigin,
                                                      rating: rating,
                                                      isFastDelivery:
                                                          isFastDelivery,
                                                      isPickup: result ==
                                                              'Bring me the order'
                                                          ? false
                                                          : true,
                                                    ),
                                                  )!
                                                      .then((value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        restaurantList = value[
                                                            'restaurantData'];

                                                        selectedFoodOrigin =
                                                            value['filterTab'];

                                                        rating =
                                                            value['rating'];

                                                        isFastDelivery = value[
                                                            'fastDelivery'];
                                                      });

                                                      if (restaurantList
                                                          .isEmpty) {
                                                        setState(() {
                                                          isRestaurantData =
                                                              true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          isRestaurantData =
                                                              false;
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        isRestaurantData =
                                                            false;
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 8),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.lightGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          'All',
                                                          style: FontUtils.h18(
                                                            fontColor: AppColors
                                                                .darkGray,
                                                            fontWeight:
                                                                FWT.medium,
                                                          ),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios_outlined,
                                                          size: 15,
                                                          color: AppColors
                                                              .darkGray,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: cousinesList
                                                    ?.cousines!.length,
                                                padding: EdgeInsets.zero,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      /// TAB COLOR CHANGE ON TAP LOGIC ------------------------------------------------------

                                                      if (selectedFoodOrigin
                                                          .contains(cousinesList
                                                                  ?.cousines![
                                                              index])) {
                                                        setState(() {
                                                          selectedFoodOrigin
                                                              .remove(cousinesList
                                                                      ?.cousines![
                                                                  index]);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          selectedFoodOrigin
                                                              .add(cousinesList
                                                                      ?.cousines![
                                                                  index]);
                                                        });
                                                      }

                                                      restaurantList.clear();
                                                      ratingFilter.clear();
                                                      finalData.clear();

                                                      /// WHEN RATING IS SELECTED ------------------------------------------------------
                                                      if (rating.isNotEmpty) {
                                                        /// WHEN ONLY ONE RATING IS SELECTED ------------------------------------------------------
                                                        if (rating.length ==
                                                            1) {
                                                          ratingFilter.addAll(
                                                              allRestaurantList
                                                                  .where((element) =>
                                                                      element
                                                                          .weightedRatingValue! <=
                                                                      int.parse(
                                                                          rating
                                                                              .first))
                                                                  .toList());
                                                        }

                                                        /// WHEN RANGE OF RATING IS SELECTED ------------------------------------------------------
                                                        else {
                                                          ratingFilter.addAll(allRestaurantList
                                                              .where((element) =>
                                                                  element.weightedRatingValue! >=
                                                                      int.parse(
                                                                          rating
                                                                              .first) &&
                                                                  element.weightedRatingValue! <=
                                                                      int.parse(
                                                                          rating
                                                                              .last))
                                                              .toList());
                                                        }

                                                        /// WHEN CATEGORY IS SELECTED ------------------------------------------------------

                                                        if (selectedFoodOrigin
                                                            .isNotEmpty) {
                                                          for (var i = 0;
                                                              i <
                                                                  ratingFilter
                                                                      .length;
                                                              i++) {
                                                            for (var j = 0;
                                                                j <
                                                                    ratingFilter
                                                                        .elementAt(
                                                                            i)
                                                                        .cuisines!
                                                                        .length;
                                                                j++) {
                                                              for (var k = 0;
                                                                  k <
                                                                      selectedFoodOrigin
                                                                          .length;
                                                                  k++) {
                                                                if (ratingFilter
                                                                    .elementAt(
                                                                        i)
                                                                    .cuisines![
                                                                        j]
                                                                    .contains(
                                                                        selectedFoodOrigin[
                                                                            k])) {
                                                                  finalData.add(
                                                                      ratingFilter
                                                                          .elementAt(
                                                                              i));
                                                                }
                                                              }
                                                            }
                                                          }

                                                          /// WHEN FAST DELIVERY IS SELECTED ------------------------------------------------------

                                                          if (isFastDelivery ==
                                                              true) {
                                                            List<RestaurantList>
                                                                data =
                                                                List.from(
                                                                    finalData);

                                                            data.sort(
                                                              (a, b) {
                                                                return a
                                                                    .quotes!
                                                                    .cheapestDelivery!
                                                                    .timeEstimate!
                                                                    .minimum!
                                                                    .compareTo(b
                                                                        .quotes!
                                                                        .cheapestDelivery!
                                                                        .timeEstimate!
                                                                        .minimum!);
                                                              },
                                                            );

                                                            finalData =
                                                                Set.from(data);

                                                            restaurantList =
                                                                finalData;

                                                            if (restaurantList
                                                                .isNotEmpty) {
                                                              isRestaurantData =
                                                                  false;
                                                            } else {
                                                              isRestaurantData =
                                                                  true;
                                                            }
                                                          } else {
                                                            restaurantList =
                                                                finalData;
                                                            if (restaurantList
                                                                .isNotEmpty) {
                                                              isRestaurantData =
                                                                  false;
                                                            } else {
                                                              isRestaurantData =
                                                                  true;
                                                            }
                                                          }
                                                        } else {
                                                          if (isFastDelivery ==
                                                              true) {
                                                            List<RestaurantList>
                                                                data =
                                                                List.from(
                                                                    ratingFilter);

                                                            data.sort(
                                                              (a, b) {
                                                                return a
                                                                    .quotes!
                                                                    .cheapestDelivery!
                                                                    .timeEstimate!
                                                                    .minimum!
                                                                    .compareTo(b
                                                                        .quotes!
                                                                        .cheapestDelivery!
                                                                        .timeEstimate!
                                                                        .minimum!);
                                                              },
                                                            );

                                                            ratingFilter =
                                                                Set.from(data);
                                                            restaurantList =
                                                                ratingFilter;

                                                            if (restaurantList
                                                                .isNotEmpty) {
                                                              isRestaurantData =
                                                                  false;
                                                            } else {
                                                              isRestaurantData =
                                                                  true;
                                                            }
                                                          } else {
                                                            restaurantList =
                                                                ratingFilter;

                                                            if (restaurantList
                                                                .isNotEmpty) {
                                                              isRestaurantData =
                                                                  false;
                                                            } else {
                                                              isRestaurantData =
                                                                  true;
                                                            }
                                                          }
                                                        }
                                                      }

                                                      /// WHEN RATING IS NOT SELECTED AND CATEGORY SELECTED ------------------------------------------------------

                                                      else if (selectedFoodOrigin
                                                          .isNotEmpty) {
                                                        for (var i = 0;
                                                            i <
                                                                allRestaurantList
                                                                    .length;
                                                            i++) {
                                                          for (var j = 0;
                                                              j <
                                                                  allRestaurantList
                                                                      .elementAt(
                                                                          i)
                                                                      .cuisines!
                                                                      .length;
                                                              j++) {
                                                            for (var k = 0;
                                                                k <
                                                                    selectedFoodOrigin
                                                                        .length;
                                                                k++) {
                                                              if (allRestaurantList
                                                                  .elementAt(i)
                                                                  .cuisines![j]
                                                                  .contains(
                                                                      selectedFoodOrigin[
                                                                          k])) {
                                                                finalData.add(
                                                                    allRestaurantList
                                                                        .elementAt(
                                                                            i));
                                                              }
                                                            }
                                                          }
                                                        }

                                                        /// WHEN FAST DELIVERY SELECTED ------------------------------------------------------
                                                        if (isFastDelivery ==
                                                            true) {
                                                          List<RestaurantList>
                                                              data = List.from(
                                                                  finalData);

                                                          data.sort(
                                                            (a, b) {
                                                              return a
                                                                  .quotes!
                                                                  .cheapestDelivery!
                                                                  .timeEstimate!
                                                                  .minimum!
                                                                  .compareTo(b
                                                                      .quotes!
                                                                      .cheapestDelivery!
                                                                      .timeEstimate!
                                                                      .minimum!);
                                                            },
                                                          );

                                                          finalData =
                                                              Set.from(data);

                                                          restaurantList =
                                                              finalData;

                                                          if (restaurantList
                                                              .isNotEmpty) {
                                                            isRestaurantData =
                                                                false;
                                                          } else {
                                                            isRestaurantData =
                                                                true;
                                                          }
                                                        }

                                                        /// WHEN FAST DELIVERY NOT SELECTED ------------------------------------------------------
                                                        else {
                                                          restaurantList =
                                                              finalData;

                                                          if (restaurantList
                                                              .isNotEmpty) {
                                                            isRestaurantData =
                                                                false;
                                                          } else {
                                                            isRestaurantData =
                                                                true;
                                                          }
                                                        }
                                                      } else if (isFastDelivery ==
                                                          true) {
                                                        dataList.sort(
                                                          (a, b) {
                                                            return a
                                                                .quotes!
                                                                .cheapestDelivery!
                                                                .timeEstimate!
                                                                .minimum!
                                                                .compareTo(b
                                                                    .quotes!
                                                                    .cheapestDelivery!
                                                                    .timeEstimate!
                                                                    .minimum!);
                                                          },
                                                        );

                                                        finalData =
                                                            Set.from(dataList);

                                                        restaurantList =
                                                            finalData;
                                                      } else {
                                                        isRestaurantData =
                                                            false;
                                                      }
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: selectedFoodOrigin
                                                                .contains(
                                                                    cousinesList
                                                                            ?.cousines![
                                                                        index])
                                                            ? AppColors.coral
                                                            : AppColors
                                                                .lightGrey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              cousinesList!
                                                                      .cousines![
                                                                  index],
                                                              style:
                                                                  FontUtils.h18(
                                                                fontColor: selectedFoodOrigin.contains(
                                                                        cousinesList?.cousines![
                                                                            index])
                                                                    ? AppColors
                                                                        .terracotta
                                                                    : AppColors
                                                                        .darkGray,
                                                                fontWeight:
                                                                    FWT.medium,
                                                              ),
                                                            ),
                                                          ),
                                                          index == 0
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios_outlined,
                                                                    size: 15,
                                                                    color: selectedFoodOrigin.contains(cousinesList?.cousines![
                                                                            index])
                                                                        ? AppColors
                                                                            .terracotta
                                                                        : AppColors
                                                                            .darkGray,
                                                                  ),
                                                                )
                                                              : const SizedBox()
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                              // : const SizedBox()
                                            ],
                                          ),
                                  ),
                                ),
                              ),

                              /// Restaurant list --------------------------------------------------------------

                              allRestaurantList.isEmpty
                                  ? Expanded(
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
                                  : isRestaurantData == true
                                      ? Expanded(
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
                                      : restaurantList.isNotEmpty
                                          ? Expanded(
                                              child: ListView.separated(
                                                itemCount:
                                                    restaurantList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                padding: const EdgeInsets.only(
                                                    bottom: 10, top: 5),
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 16,
                                                  );
                                                },
                                                itemBuilder: (context, index) =>
                                                    GestureDetector(
                                                  onTap: () {
                                                    result.isEmpty
                                                        ? showBottomSheet()
                                                        : Get.to(
                                                            () =>
                                                                RestaurantMenuScreen(
                                                              restaurantName:
                                                                  restaurantList
                                                                          .elementAt(
                                                                              index)
                                                                          .name ??
                                                                      '',
                                                              restaurantId:
                                                                  restaurantList
                                                                      .elementAt(
                                                                          index)
                                                                      .id!,
                                                              pickup: result ==
                                                                      'Bring me the order'
                                                                  ? false
                                                                  : true,
                                                            ),
                                                            transition:
                                                                Transition
                                                                    .fadeIn,
                                                          );
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          height: 160,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            image: restaurantList
                                                                    .elementAt(
                                                                        index)
                                                                    .logoPhotos!
                                                                    .isEmpty
                                                                ? const DecorationImage(
                                                                    image:
                                                                        AssetImage(
                                                                      AssetsUtils
                                                                          .restaurantFood,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : DecorationImage(
                                                                    image: NetworkImage(restaurantList
                                                                        .elementAt(
                                                                            index)
                                                                        .logoPhotos![0]),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              restaurantList
                                                                          .elementAt(
                                                                              index)
                                                                          .quotes!
                                                                          .cheapestDelivery!
                                                                          .deliveryFee!
                                                                          .deliveryFeeFlat ==
                                                                      0
                                                                  ? Container(
                                                                      width:
                                                                          109,
                                                                      margin:
                                                                          const EdgeInsets.all(
                                                                              12),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
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
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 109,
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(9),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Image.asset(
                                                                          AssetsUtils
                                                                              .ratingStar),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 4),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            restaurantList.elementAt(index).weightedRatingValue!.toStringAsFixed(1),
                                                                            style:
                                                                                FontUtils.h16(
                                                                              fontColor: Colors.black,
                                                                              fontWeight: FWT.regular,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          '(${restaurantList.elementAt(index).aggregatedRatingCount ?? ''})',
                                                                          style:
                                                                              FontUtils.h12(
                                                                            fontColor:
                                                                                AppColors.disable,
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8,
                                                                  bottom: 4),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  restaurantList
                                                                          .elementAt(
                                                                              index)
                                                                          .name ??
                                                                      '',
                                                                  style:
                                                                      FontUtils
                                                                          .h18(
                                                                    fontColor:
                                                                        AppColors
                                                                            .darkGray,
                                                                    fontWeight:
                                                                        FWT.semiBold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 22,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .lightGrey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    restaurantList.elementAt(index).cuisines!.isEmpty ||
                                                                            restaurantList.elementAt(index).cuisines ==
                                                                                []
                                                                        ? ''
                                                                        : restaurantList
                                                                            .elementAt(index)
                                                                            .cuisines![0],
                                                                    style:
                                                                        FontUtils
                                                                            .h14(
                                                                      fontColor:
                                                                          AppColors
                                                                              .darkGray,
                                                                      fontWeight:
                                                                          FWT.lightMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              AssetsUtils
                                                                  .deliveryVehicle,
                                                              width: 15,
                                                              height: 15,
                                                              color: AppColors
                                                                  .darkGray,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              '\$ ${restaurantList.elementAt(index).quotes!.cheapestDelivery!.deliveryFee!.deliveryFeeFlat ?? 0}  •  ${restaurantList.elementAt(index).quotes!.cheapestDelivery!.timeEstimate!.minimum ?? 0}-${restaurantList.elementAt(index).quotes!.cheapestDelivery!.timeEstimate!.maximum ?? 0} min',
                                                              style:
                                                                  FontUtils.h14(
                                                                fontColor:
                                                                    AppColors
                                                                        .darkGray,
                                                                fontWeight: FWT
                                                                    .lightMedium,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              child: ListView.separated(
                                                itemCount:
                                                    allRestaurantList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                padding: const EdgeInsets.only(
                                                    bottom: 10, top: 5),
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 16,
                                                  );
                                                },
                                                itemBuilder: (context, index) =>
                                                    GestureDetector(
                                                  onTap: () {
                                                    result.isEmpty
                                                        ? showBottomSheet()
                                                        : Get.to(
                                                            () =>
                                                                RestaurantMenuScreen(
                                                              restaurantName:
                                                                  allRestaurantList[
                                                                              index]
                                                                          .name ??
                                                                      '',
                                                              restaurantId:
                                                                  allRestaurantList[
                                                                          index]
                                                                      .id!,
                                                              pickup: result ==
                                                                      'Bring me the order'
                                                                  ? false
                                                                  : true,
                                                            ),
                                                            transition:
                                                                Transition
                                                                    .fadeIn,
                                                          );
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          height: 160,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            image: allRestaurantList[
                                                                        index]
                                                                    .logoPhotos!
                                                                    .isEmpty
                                                                ? const DecorationImage(
                                                                    image:
                                                                        AssetImage(
                                                                      AssetsUtils
                                                                          .restaurantFood,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : DecorationImage(
                                                                    image: NetworkImage(
                                                                        allRestaurantList[index]
                                                                            .logoPhotos![0]),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              allRestaurantList[
                                                                              index]
                                                                          .quotes
                                                                          ?.cheapestDelivery
                                                                          ?.deliveryFee
                                                                          ?.deliveryFeeFlat ==
                                                                      0
                                                                  ? Container(
                                                                      width:
                                                                          109,
                                                                      margin:
                                                                          const EdgeInsets.all(
                                                                              12),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
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
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  width: 109,
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(9),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Image.asset(
                                                                          AssetsUtils
                                                                              .ratingStar),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 4),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            allRestaurantList[index].weightedRatingValue!.toStringAsFixed(1),
                                                                            style:
                                                                                FontUtils.h16(
                                                                              fontColor: Colors.black,
                                                                              fontWeight: FWT.regular,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          '(${allRestaurantList[index].aggregatedRatingCount ?? ''})',
                                                                          style:
                                                                              FontUtils.h12(
                                                                            fontColor:
                                                                                AppColors.disable,
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8,
                                                                  bottom: 4),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  allRestaurantList[
                                                                              index]
                                                                          .name ??
                                                                      '',
                                                                  style:
                                                                      FontUtils
                                                                          .h18(
                                                                    fontColor:
                                                                        AppColors
                                                                            .darkGray,
                                                                    fontWeight:
                                                                        FWT.semiBold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 22,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .lightGrey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    allRestaurantList[index].cuisines!.isEmpty ||
                                                                            allRestaurantList[index].cuisines ==
                                                                                []
                                                                        ? ''
                                                                        : allRestaurantList[index]
                                                                            .cuisines![0],
                                                                    style:
                                                                        FontUtils
                                                                            .h14(
                                                                      fontColor:
                                                                          AppColors
                                                                              .darkGray,
                                                                      fontWeight:
                                                                          FWT.lightMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              AssetsUtils
                                                                  .deliveryVehicle,
                                                              width: 15,
                                                              height: 15,
                                                              color: AppColors
                                                                  .darkGray,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              '\$ ${allRestaurantList[index].quotes?.cheapestDelivery?.deliveryFee?.deliveryFeeFlat ?? 0}  •  ${allRestaurantList[index].quotes?.cheapestDelivery?.timeEstimate?.minimum ?? 0}-${allRestaurantList[index].quotes?.cheapestDelivery?.timeEstimate?.maximum ?? 0} min',
                                                              style:
                                                                  FontUtils.h14(
                                                                fontColor:
                                                                    AppColors
                                                                        .darkGray,
                                                                fontWeight: FWT
                                                                    .lightMedium,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                              // : restaurantList.isEmpty
                              //     ?
                              //     :
                            ],
                          ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
