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
import 'package:gymeats_mobile/screen/account_screen/account/account_screen.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/food_intake_bottomsheet_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/filter_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_screen.dart';
import 'package:shimmer/shimmer.dart';

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
        return DeliverOrderBottomSheet(
          selectedIndex: selectedIndex,
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
      if (value != null) {
        setState(() {
          result = value;
          selectedIndex = result == 'Bring me the order' ? 0 : 1;
        });

        if (getUserAddress != null) {
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
        } else {}

        restaurantBloc.add(GetShoppingListEvent());
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
      setState(() {
        mealType = value;
        showBottomSheet();
      });
    });
  }

  List selectedFoodOrigin = [];
  UserAddress? getUserAddress;
  Set<RestaurantList> restaurantList = {};
  Set<RestaurantList> searchRestaurantList = {};
  Set<RestaurantList> allSearchRestaurantList = {};
  Set<RestaurantList> ratingFilter = {};
  Set<RestaurantList> finalData = {};
  List<RestaurantList> allRestaurantList = [];
  List<RestaurantList> dataList = [];
  CousinesList? cousinesList;
  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool getRestaurantMenuLoadingState = false;
  bool getCousinesLoadingState = false;
  bool getAddressLoadingState = false;
  var result = '';
  var mealType = '';
  bool hasData = false;
  List rating = [];
  bool isFastDelivery = false;
  bool isSearchOn = false;
  int cartCount = 0;
  TextEditingController search = TextEditingController();
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurantBloc.add(GetUserAddressEvent());
      restaurantBloc.add(GetShoppingListEvent());
      restaurantBloc.add(GetDeliveryStatusEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Get.to(
        //       () => const RestaurantMenuScreen(
        //         restaurantId: '9ef2baaa-9414-4708-be26-93a8b96ed441',
        //         pickup: false,
        //       ),
        //     );
        //   },
        // ),
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
                        transition: Transition.fadeIn,
                        arguments: {
                          "string": 'isFromCheckout',
                          "userData": ''
                        });
                  } else {
                    showLogIntakeBottomSheet();
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

              /// Delivery Status state --------------------------------------------------------
              if (state is GetDeliveryStatusSuccessState) {
                selectedIndex = state.data['isPickUp'] == true ? 1 : 0;
              }

              /// Restaurant state --------------------------------------------------------
              if (state is GetRestaurantListLoadingState) {
                getRestaurantMenuLoadingState = true;
              }
              if (state is GetRestaurantListSuccessState) {
                allRestaurantList = state.restaurantList;
                restaurantList = Set.from(state.restaurantList);
                dataList = state.restaurantList;
                getRestaurantMenuLoadingState = false;
              }
              if (state is GetRestaurantListErrorState) {
                getRestaurantMenuLoadingState = false;
              }

              /// Cousines State ----------------------------------------------------------
              if (state is GetCousinesListLoadingState) {
                getCousinesLoadingState = true;
              }
              if (state is GetCousinesListSuccessState) {
                cousinesList = state.cousinesList;
                cousinesList!.cousines!.isEmpty
                    ? hasData = false
                    : hasData = true;
                getCousinesLoadingState = false;
              }
              if (state is GetCousinesListErrorState) {
                getCousinesLoadingState = false;
              }

              /// Shopping list state -----------------------------------------------------
              if (state is GetShoppingListSuccessState) {
                cartCount = 0;
                state.shoppingListData?.forEach((element) {
                  if (element.productType == 'Restaurant') {
                    cartCount++;
                  }
                });
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountScreen(),
                                ));
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
                              controller: search,
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
                              onChanged: (String? value) {
                                setState(() {
                                  if (value!.isNotEmpty) {
                                    isSearchOn = true;
                                    allSearchRestaurantList =
                                        restaurantList.where(
                                      (element) {
                                        return element.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase());
                                      },
                                    ).toSet();

                                    searchRestaurantList =
                                        allSearchRestaurantList;
                                    setState(() {});
                                  } else {
                                    isSearchOn = false;
                                  }
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                      () => RestaurantCart(
                                            pickUp:
                                                result == 'Bring me the order'
                                                    ? false
                                                    : true,
                                          ),
                                      transition: Transition.fadeIn)!
                                  .then((value) {
                                restaurantBloc.add(GetShoppingListEvent());
                              });
                            },
                            child: Container(
                              height: 48,
                              width: 77,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff004C63)
                                        .withOpacity(0.08),
                                    offset: const Offset(0, 0),
                                    blurRadius: 16,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    AssetsUtils.icShoppingIcon,
                                    color: AppColors.darkGray,
                                  ),
                                  Text(
                                    '$cartCount',
                                    style: FontUtils.h18(
                                        fontColor: AppColors.darkGray,
                                        fontWeight: FWT.medium),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Location ---------------------------------------------------------------------
                    IntrinsicWidth(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 55.w),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const GetUserAddress(),
                                transition: Transition.fadeIn,
                                arguments: {
                                  "string": 'isFromCheckout',
                                  "userData": ''
                                });
                          },
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
                    ),

                    Expanded(
                      child: getAddressLoadingState == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : getRestaurantMenuLoadingState == true ||
                                  getCousinesLoadingState == true
                              ? SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ListView.builder(
                                    itemCount: 10,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 20),
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Shimmer.fromColors(
                                          baseColor: AppColors.disable
                                              .withOpacity(0.20),
                                          highlightColor: AppColors.disable
                                              .withOpacity(0.20),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 160.h,
                                                decoration: BoxDecoration(
                                                    color: AppColors.disable,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                              ),
                                              const SizedBox(height: 7),
                                              Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 0,
                                                        child: Container(
                                                          height: 30,
                                                          width: 70,
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .disable,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7)),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Expanded(
                                                        flex: 0,
                                                        child: Container(
                                                          height: 20,
                                                          width: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .disable,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .disable,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7)),
                                                        ),
                                                      ),
                                                      const Expanded(
                                                        child: SizedBox(),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              const Divider(
                                                  color: AppColors.disable,
                                                  thickness: 1.2),
                                            ],
                                          ));
                                    },
                                  ),
                                )
                              : Column(
                                  children: [
                                    /// Tab bar ----------------------------------------------------------------------

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
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
                                                              restaurantList =
                                                                  value[
                                                                      'restaurantData'];

                                                              selectedFoodOrigin =
                                                                  value[
                                                                      'filterTab'];

                                                              rating = value[
                                                                  'rating'];

                                                              isFastDelivery =
                                                                  value[
                                                                      'fastDelivery'];
                                                            });
                                                          } else {}
                                                        });
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 8),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .lightGrey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                'All',
                                                                style: FontUtils
                                                                    .h18(
                                                                  fontColor:
                                                                      AppColors
                                                                          .darkGray,
                                                                  fontWeight:
                                                                      FWT.medium,
                                                                ),
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
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
                                                      itemBuilder:
                                                          (context, index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            /// TAB COLOR CHANGE ON TAP LOGIC ------------------------------------------------------

                                                            if (selectedFoodOrigin
                                                                .contains(cousinesList
                                                                        ?.cousines![
                                                                    index])) {
                                                              setState(() {
                                                                selectedFoodOrigin.remove(
                                                                    cousinesList
                                                                            ?.cousines![
                                                                        index]);
                                                              });
                                                            } else {
                                                              setState(() {
                                                                selectedFoodOrigin.add(
                                                                    cousinesList
                                                                            ?.cousines![
                                                                        index]);
                                                              });
                                                            }

                                                            if (isSearchOn ==
                                                                true) {
                                                              ratingFilter = {};
                                                              finalData = {};

                                                              /// WHEN RATING IS SELECTED ------------------------------------------------------
                                                              if (rating
                                                                  .isNotEmpty) {
                                                                /// WHEN ONLY ONE RATING IS SELECTED ------------------------------------------------------
                                                                if (rating
                                                                        .length ==
                                                                    1) {
                                                                  ratingFilter.addAll(allSearchRestaurantList
                                                                      .where((element) =>
                                                                          element
                                                                              .weightedRatingValue! <=
                                                                          int.parse(
                                                                              rating.first))
                                                                      .toList());
                                                                }

                                                                /// WHEN RANGE OF RATING IS SELECTED ------------------------------------------------------
                                                                else {
                                                                  ratingFilter.addAll(allSearchRestaurantList
                                                                      .where((element) =>
                                                                          element.weightedRatingValue! >=
                                                                              int.parse(rating
                                                                                  .first) &&
                                                                          element.weightedRatingValue! <=
                                                                              int.parse(rating.last))
                                                                      .toList());
                                                                }

                                                                /// WHEN CATEGORY IS SELECTED ------------------------------------------------------

                                                                if (selectedFoodOrigin
                                                                    .isNotEmpty) {
                                                                  for (var i =
                                                                          0;
                                                                      i <
                                                                          ratingFilter
                                                                              .length;
                                                                      i++) {
                                                                    for (var j =
                                                                            0;
                                                                        j < ratingFilter.elementAt(i).cuisines!.length;
                                                                        j++) {
                                                                      for (var k =
                                                                              0;
                                                                          k < selectedFoodOrigin.length;
                                                                          k++) {
                                                                        if (ratingFilter
                                                                            .elementAt(i)
                                                                            .cuisines![j]
                                                                            .contains(selectedFoodOrigin[k])) {
                                                                          finalData
                                                                              .add(ratingFilter.elementAt(i));
                                                                        }
                                                                      }
                                                                    }
                                                                  }

                                                                  /// WHEN FAST DELIVERY IS SELECTED ------------------------------------------------------

                                                                  searchRestaurantList =
                                                                      finalData;
                                                                } else {
                                                                  searchRestaurantList =
                                                                      allSearchRestaurantList;
                                                                }
                                                              }

                                                              /// WHEN RATING IS NOT SELECTED AND CATEGORY SELECTED ------------------------------------------------------

                                                              else if (selectedFoodOrigin
                                                                  .isNotEmpty) {
                                                                for (var i = 0;
                                                                    i <
                                                                        allSearchRestaurantList
                                                                            .length;
                                                                    i++) {
                                                                  for (var j =
                                                                          0;
                                                                      j <
                                                                          allSearchRestaurantList
                                                                              .elementAt(i)
                                                                              .cuisines!
                                                                              .length;
                                                                      j++) {
                                                                    for (var k =
                                                                            0;
                                                                        k < selectedFoodOrigin.length;
                                                                        k++) {
                                                                      if (allSearchRestaurantList
                                                                          .elementAt(
                                                                              i)
                                                                          .cuisines![
                                                                              j]
                                                                          .contains(
                                                                              selectedFoodOrigin[k])) {
                                                                        finalData
                                                                            .add(allSearchRestaurantList.elementAt(i));
                                                                      }
                                                                    }
                                                                  }
                                                                }

                                                                /// WHEN FAST DELIVERY SELECTED ------------------------------------------------------

                                                                searchRestaurantList =
                                                                    finalData;
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
                                                                    Set.from(
                                                                        dataList);

                                                                searchRestaurantList =
                                                                    finalData;
                                                              } else {
                                                                searchRestaurantList =
                                                                    allSearchRestaurantList;
                                                              }
                                                            }

                                                            /// When Search is off
                                                            else {
                                                              restaurantList
                                                                  .clear();
                                                              ratingFilter
                                                                  .clear();
                                                              finalData.clear();

                                                              /// WHEN RATING IS SELECTED ------------------------------------------------------
                                                              if (rating
                                                                  .isNotEmpty) {
                                                                /// WHEN ONLY ONE RATING IS SELECTED ------------------------------------------------------
                                                                if (rating
                                                                        .length ==
                                                                    1) {
                                                                  ratingFilter.addAll(allRestaurantList
                                                                      .where((element) =>
                                                                          element
                                                                              .weightedRatingValue! <=
                                                                          int.parse(
                                                                              rating.first))
                                                                      .toList());
                                                                }

                                                                /// WHEN RANGE OF RATING IS SELECTED ------------------------------------------------------
                                                                else {
                                                                  ratingFilter.addAll(allRestaurantList
                                                                      .where((element) =>
                                                                          element.weightedRatingValue! >=
                                                                              int.parse(rating
                                                                                  .first) &&
                                                                          element.weightedRatingValue! <=
                                                                              int.parse(rating.last))
                                                                      .toList());
                                                                }

                                                                /// WHEN CATEGORY IS SELECTED ------------------------------------------------------

                                                                if (selectedFoodOrigin
                                                                    .isNotEmpty) {
                                                                  for (var i =
                                                                          0;
                                                                      i <
                                                                          ratingFilter
                                                                              .length;
                                                                      i++) {
                                                                    for (var j =
                                                                            0;
                                                                        j < ratingFilter.elementAt(i).cuisines!.length;
                                                                        j++) {
                                                                      for (var k =
                                                                              0;
                                                                          k < selectedFoodOrigin.length;
                                                                          k++) {
                                                                        if (ratingFilter
                                                                            .elementAt(i)
                                                                            .cuisines![j]
                                                                            .contains(selectedFoodOrigin[k])) {
                                                                          finalData
                                                                              .add(ratingFilter.elementAt(i));
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
                                                                            .compareTo(b.quotes!.cheapestDelivery!.timeEstimate!.minimum!);
                                                                      },
                                                                    );

                                                                    finalData =
                                                                        Set.from(
                                                                            data);

                                                                    restaurantList =
                                                                        finalData;
                                                                  } else {
                                                                    restaurantList =
                                                                        finalData;
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
                                                                            .compareTo(b.quotes!.cheapestDelivery!.timeEstimate!.minimum!);
                                                                      },
                                                                    );

                                                                    ratingFilter =
                                                                        Set.from(
                                                                            data);
                                                                    restaurantList =
                                                                        ratingFilter;
                                                                  } else {
                                                                    restaurantList =
                                                                        ratingFilter;
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
                                                                  for (var j =
                                                                          0;
                                                                      j <
                                                                          allRestaurantList
                                                                              .elementAt(i)
                                                                              .cuisines!
                                                                              .length;
                                                                      j++) {
                                                                    for (var k =
                                                                            0;
                                                                        k < selectedFoodOrigin.length;
                                                                        k++) {
                                                                      if (allRestaurantList
                                                                          .elementAt(
                                                                              i)
                                                                          .cuisines![
                                                                              j]
                                                                          .contains(
                                                                              selectedFoodOrigin[k])) {
                                                                        finalData
                                                                            .add(allRestaurantList.elementAt(i));
                                                                      }
                                                                    }
                                                                  }
                                                                }

                                                                /// WHEN FAST DELIVERY SELECTED ------------------------------------------------------
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
                                                                      Set.from(
                                                                          data);

                                                                  restaurantList =
                                                                      finalData;
                                                                }

                                                                /// WHEN FAST DELIVERY NOT SELECTED ------------------------------------------------------
                                                                else {
                                                                  restaurantList =
                                                                      finalData;
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
                                                                    Set.from(
                                                                        dataList);

                                                                restaurantList =
                                                                    finalData;
                                                              } else {
                                                                restaurantList =
                                                                    Set.from(
                                                                        allRestaurantList);
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 8),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: selectedFoodOrigin.contains(
                                                                      cousinesList
                                                                              ?.cousines![
                                                                          index])
                                                                  ? AppColors
                                                                      .coral
                                                                  : AppColors
                                                                      .lightGrey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    cousinesList!
                                                                            .cousines![
                                                                        index],
                                                                    style:
                                                                        FontUtils
                                                                            .h18(
                                                                      fontColor: selectedFoodOrigin.contains(cousinesList?.cousines![
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
                                                                        padding:
                                                                            const EdgeInsets.only(left: 10),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_forward_ios_outlined,
                                                                          size:
                                                                              15,
                                                                          color: selectedFoodOrigin.contains(cousinesList?.cousines![index])
                                                                              ? AppColors.terracotta
                                                                              : AppColors.darkGray,
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

                                    isSearchOn == true
                                        ? searchRestaurantList.isNotEmpty
                                            ? Expanded(
                                                child: ListView.separated(
                                                  itemCount:
                                                      searchRestaurantList
                                                          .length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10, top: 5),
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const SizedBox(
                                                      height: 16,
                                                    );
                                                  },
                                                  itemBuilder:
                                                      (context, index) =>
                                                          GestureDetector(
                                                    onTap: () {
                                                      result.isEmpty
                                                          ? showBottomSheet()
                                                          : Get.to(
                                                              () =>
                                                                  RestaurantMenuScreen(
                                                                restaurantName:
                                                                    searchRestaurantList
                                                                            .elementAt(index)
                                                                            .name ??
                                                                        '',
                                                                restaurantId:
                                                                    searchRestaurantList
                                                                        .elementAt(
                                                                            index)
                                                                        .id!,
                                                                pickup: result ==
                                                                        'Bring me the order'
                                                                    ? false
                                                                    : true,
                                                                mealType:
                                                                    mealType,
                                                              ),
                                                              transition:
                                                                  Transition
                                                                      .fadeIn,
                                                            )!
                                                              .then((value) {
                                                              restaurantBloc.add(
                                                                  GetShoppingListEvent());
                                                            });
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
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
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              image: searchRestaurantList
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
                                                                      image: NetworkImage(searchRestaurantList
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
                                                                searchRestaurantList
                                                                            .elementAt(index)
                                                                            .quotes
                                                                            ?.cheapestDelivery
                                                                            ?.deliveryFee
                                                                            ?.deliveryFeeFlat ==
                                                                        0
                                                                    ? Container(
                                                                        width:
                                                                            109,
                                                                        margin:
                                                                            const EdgeInsets.all(12),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Free Delivery',
                                                                            style:
                                                                                FontUtils.h16(
                                                                              fontColor: Colors.black,
                                                                              fontWeight: FWT.regular,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox(),
                                                                const Spacer(),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
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
                                                                    margin: const EdgeInsets
                                                                        .all(9),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Image.asset(
                                                                            AssetsUtils.ratingStar),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 4),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              searchRestaurantList.elementAt(index).weightedRatingValue!.toStringAsFixed(1),
                                                                              style: FontUtils.h16(
                                                                                fontColor: Colors.black,
                                                                                fontWeight: FWT.regular,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            '(${searchRestaurantList.elementAt(index).aggregatedRatingCount ?? ''})',
                                                                            style:
                                                                                FontUtils.h12(
                                                                              fontColor: AppColors.disable,
                                                                              fontWeight: FWT.regular,
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
                                                                    searchRestaurantList
                                                                            .elementAt(index)
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
                                                                            .circular(8),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      searchRestaurantList.elementAt(index).cuisines!.isEmpty ||
                                                                              searchRestaurantList.elementAt(index).cuisines ==
                                                                                  []
                                                                          ? ''
                                                                          : searchRestaurantList
                                                                              .elementAt(index)
                                                                              .cuisines![0],
                                                                      style: FontUtils
                                                                          .h14(
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
                                                          result ==
                                                                  'I will pick it myself'
                                                              ? const SizedBox()
                                                              : Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      AssetsUtils
                                                                          .deliveryVehicle,
                                                                      width: 15,
                                                                      height:
                                                                          15,
                                                                      color: AppColors
                                                                          .darkGray,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      '\$ ${searchRestaurantList.elementAt(index).quotes?.cheapestDelivery?.deliveryFee?.deliveryFeeFlat ?? 0}  •  ${searchRestaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.minimum ?? 0}-${searchRestaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.maximum ?? 0} min',
                                                                      style: FontUtils
                                                                          .h14(
                                                                        fontColor:
                                                                            AppColors.darkGray,
                                                                        fontWeight:
                                                                            FWT.lightMedium,
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
                                                child: Center(
                                                  child: Text(
                                                    'Currently No Restaurant Found',
                                                    style: FontUtils.h18(
                                                      fontColor:
                                                          AppColors.darkGray,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10, top: 5),
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const SizedBox(
                                                      height: 16,
                                                    );
                                                  },
                                                  itemBuilder:
                                                      (context, index) =>
                                                          GestureDetector(
                                                    onTap: () {
                                                      result.isEmpty
                                                          ? showBottomSheet()
                                                          : mealType.isEmpty
                                                              ? showLogIntakeBottomSheet()
                                                              : Get.to(
                                                                  () =>
                                                                      RestaurantMenuScreen(
                                                                    restaurantName:
                                                                        restaurantList.elementAt(index).name ??
                                                                            '',
                                                                    restaurantId:
                                                                        restaurantList
                                                                            .elementAt(index)
                                                                            .id!,
                                                                    pickup: result ==
                                                                            'Bring me the order'
                                                                        ? false
                                                                        : true,
                                                                    mealType:
                                                                        mealType,
                                                                  ),
                                                                  transition:
                                                                      Transition
                                                                          .fadeIn,
                                                                )!
                                                                  .then(
                                                                      (value) {
                                                                  restaurantBloc
                                                                      .add(
                                                                          GetShoppingListEvent());
                                                                });
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
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
                                                            width:
                                                                MediaQuery.of(
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
                                                                            .elementAt(index)
                                                                            .quotes
                                                                            ?.cheapestDelivery
                                                                            ?.deliveryFee
                                                                            ?.deliveryFeeFlat ==
                                                                        0
                                                                    ? Container(
                                                                        width:
                                                                            109,
                                                                        margin:
                                                                            const EdgeInsets.all(12),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(8)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Free Delivery',
                                                                            style:
                                                                                FontUtils.h16(
                                                                              fontColor: Colors.black,
                                                                              fontWeight: FWT.regular,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox(),
                                                                const Spacer(),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
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
                                                                    margin: const EdgeInsets
                                                                        .all(9),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Image.asset(
                                                                            AssetsUtils.ratingStar),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 4),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              restaurantList.elementAt(index).weightedRatingValue!.toStringAsFixed(1),
                                                                              style: FontUtils.h16(
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
                                                                              fontColor: AppColors.disable,
                                                                              fontWeight: FWT.regular,
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
                                                                            .elementAt(index)
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
                                                                            .circular(8),
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
                                                                      style: FontUtils
                                                                          .h14(
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
                                                          result ==
                                                                  'I will pick it myself'
                                                              ? const SizedBox()
                                                              : Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      AssetsUtils
                                                                          .deliveryVehicle,
                                                                      width: 15,
                                                                      height:
                                                                          15,
                                                                      color: AppColors
                                                                          .darkGray,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      '\$ ${restaurantList.elementAt(index).quotes?.cheapestDelivery?.deliveryFee?.deliveryFeeFlat ?? 0}  •  ${restaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.minimum ?? 0}-${restaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.maximum ?? 0} min',
                                                                      style: FontUtils
                                                                          .h14(
                                                                        fontColor:
                                                                            AppColors.darkGray,
                                                                        fontWeight:
                                                                            FWT.lightMedium,
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
                                                child: Center(
                                                  child: Text(
                                                    'Currently No Restaurant Found',
                                                    style: FontUtils.h18(
                                                      fontColor:
                                                          AppColors.darkGray,
                                                      fontWeight: FWT.medium,
                                                    ),
                                                  ),
                                                ),
                                              )
                                  ],
                                ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
