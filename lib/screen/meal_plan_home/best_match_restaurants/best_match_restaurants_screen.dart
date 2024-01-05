import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_screen.dart';

import '../../restaurants/bloc/restaurant_event.dart';
import '../../restaurants/bloc/restaurant_state.dart';
import '../../restaurants/model/get_user_address_model.dart';

class BestMatchRestaurantsScreen extends StatefulWidget {
  final String productName;
  const BestMatchRestaurantsScreen({super.key, required this.productName});

  @override
  State<BestMatchRestaurantsScreen> createState() => _BestMatchRestaurantsScreenState();
}

class _BestMatchRestaurantsScreenState extends State<BestMatchRestaurantsScreen> {
  //old code

  // MealPlanBloc mealPlanBloc = MealPlanBloc();
  //new code
  RestaurantBloc restaurantBloc = RestaurantBloc();

  ///old Code
  // List<RestaurantProduct> productsList = [];
  ///new Code
  Set<RestaurantList> restaurantList = {};
  UserAddress? getUserAddress;
  bool getAddressLoadingState = false;
  bool getRestaurantMenuLoadingState = false;
  var mealType = '';
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    ///old Code
    /*mealPlanBloc
        .add(RestaurantSearchEvent(name: widget.productName, latitude: '37.7786357', longitude: '-122.3918135', maximumMiles: '1.5', pickup: false));
   */ ///new Code
    restaurantBloc.add(GetUserAddressEvent());

    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return /*BlocConsumer<MealPlanBloc, FetchMealPlanState>(
        bloc: mealPlanBloc,
        listener: (context, state) {
          if (state is RestaurantSearchSuccessState) {
            productsList = state.restaurantSearchData!.products!;
          }
        },*/
        BlocConsumer(
            bloc: restaurantBloc,
            listener: (context, state) {
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

                  if (getUserAddress!.streetName.toString().isEmpty || getUserAddress!.streetName == null) {
                    Get.to(() => const GetUserAddress(),
                        /*transition: Transition.fadeIn,*/
                        arguments: {"string": 'isFromRestaurant', "userData": ''});
                  } else {
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
                        false,
                        5,
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
                    position: LatLng(element.address?.latitude ?? 0, element.address?.longitude ?? 0),
                    infoWindow: InfoWindow(title: element.name, snippet: element.address?.streetAddr ?? ''),
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
/*
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
              }*/
            },
            builder: (context, state) {
              return Scaffold(
                body: Stack(
                  children: [
                    getAddressLoadingState == true
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.primaryBlue),
                          )
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(getUserAddress?.latitude ?? 0, getUserAddress?.longitude ?? 0),
                              zoom: 15,
                            ),
                            markers: markers.values.toSet(),
                          ),
                    Positioned(
                        top: 40,
                        left: 15,
                        child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.keyboard_arrow_left_sharp, color: AppColors.darkGray, size: 40))),
                    DraggableScrollableSheet(
                        initialChildSize: 0.4,
                        minChildSize: 0.2,
                        maxChildSize: 0.7,
                        builder: (BuildContext context, ScrollController scrollController) {
                          return Container(
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
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.disable),
                                      )),
                                  const SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'See Best Matches',
                                      style: FontUtils.h22(fontColor: AppColors.darkGray, fontWeight: FWT.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  ///old Code
                                  /*Expanded(
                                child: state is RestaurantSearchLoadingState
                                    ? const Center(
                                        child: CircularProgressIndicator(color: AppColors.primaryBlue),
                                      )
                                    : productsList.isEmpty
                                        ? const SizedBox()
                                        : ListView.builder(
                                            controller: scrollController,
                                            itemCount: productsList.length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(12),
                                                                child: SizedBox(
                                                                    height: screenSize.height * 0.25,
                                                                    width: double.infinity,
                                                                    child: CachedNetworkImageWidget(imgURL: productsList[index].image ?? '')
                                                                    //  Image.network(
                                                                    //   // AssetsUtils.defaultImage,
                                                                    //   productsList[index].image!,
                                                                    //   fit: BoxFit.cover,
                                                                    // ),
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 12, left: 12),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors.whiteColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                        child: Text(
                                                                          'Free delivery',
                                                                          style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors.whiteColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                        child: Text(
                                                                          '-10% off',
                                                                          style: FontUtils.h12(
                                                                              fontColor: AppColors.terracotta, fontWeight: FWT.semiBold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 12, left: 12),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors.whiteColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                        child: Text(
                                                                          'Free delivery',
                                                                          style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors.whiteColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                        child: Text(
                                                                          '-10% off',
                                                                          style: FontUtils.h12(
                                                                              fontColor: AppColors.terracotta, fontWeight: FWT.semiBold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: 12,
                                                                bottom: 12,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors.whiteColor,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(AssetsUtils.icThumbUpLine),
                                                                        const SizedBox(width: 5),
                                                                        Text(
                                                                          '95%',
                                                                          style: FontUtils.h16(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                                                        ),
                                                                        const SizedBox(width: 5),
                                                                        Text(
                                                                          '(145)',
                                                                          style: FontUtils.h14(fontColor: AppColors.disable, fontWeight: FWT.light),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(productsList[index].itemName ?? '',
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                  style: FontUtils.h18(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold)),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.lightGrey,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                                  child: Text(
                                                                    productsList[index].category ?? '',
                                                                    style: FontUtils.h14(fontColor: AppColors.black, fontWeight: FWT.regular),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(AssetsUtils.icScooter),
                                                              const SizedBox(width: 10),
                                                              Text(productsList[index].formattedPrice ?? '',
                                                                  style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                              const SizedBox(width: 10),
                                                              const CircleAvatar(maxRadius: 3, backgroundColor: AppColors.darkGray),
                                                              const SizedBox(width: 10),
                                                              Text('15-25 min',
                                                                  style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 5),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                              ),*/

                                  ///new Code
                                  getAddressLoadingState == true || getRestaurantMenuLoadingState == true
                                      ? Expanded(
                                          child: Center(
                                            child: CircularProgressIndicator(color: AppColors.primaryBlue),
                                          ),
                                        )
                                      : restaurantList.isNotEmpty
                                          ? Expanded(
                                              child: ListView.separated(
                                                itemCount: restaurantList.length,
                                                shrinkWrap: true,
                                                physics: const BouncingScrollPhysics(),
                                                padding: const EdgeInsets.only(bottom: 10, top: 5),
                                                separatorBuilder: (context, index) {
                                                  return const SizedBox(
                                                    height: 16,
                                                  );
                                                },
                                                itemBuilder: (context, index) => GestureDetector(
                                                  onTap: () {
                                                    Get.to(
                                                      () => RestaurantMenuScreen(
                                                        restaurantName: restaurantList.elementAt(index).name ?? '',
                                                        restaurantId: restaurantList.elementAt(index).id!,
                                                        pickup: false,
                                                        mealType: mealType,
                                                      ),
/*
                                                      transition: Transition.fadeIn,
*/
                                                    )!
                                                        .then((value) {
                                                      restaurantBloc.add(GetShoppingListEvent());
                                                    });
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          height: 160,
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8),
                                                            image: restaurantList.elementAt(index).logoPhotos!.isEmpty
                                                                ? const DecorationImage(
                                                                    image: AssetImage(
                                                                      AssetsUtils.restaurantFood,
                                                                    ),
                                                                    fit: BoxFit.cover,
                                                                  )
                                                                : DecorationImage(
                                                                    image: NetworkImage(restaurantList.elementAt(index).logoPhotos![0]),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                      margin: const EdgeInsets.all(12),
                                                                      decoration:
                                                                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                                      child: Center(
                                                                        child: Text(
                                                                          'Free Delivery',
                                                                          style: FontUtils.h16(
                                                                            fontColor: Colors.black,
                                                                            fontWeight: FWT.regular,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                              const Spacer(),
                                                              Align(
                                                                alignment: Alignment.bottomRight,
                                                                child: Container(
                                                                  height: 30,
                                                                  width: 109,
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                  margin: const EdgeInsets.all(9),
                                                                  decoration:
                                                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Image.asset(AssetsUtils.ratingStar),
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                        child: Center(
                                                                          child: Text(
                                                                            restaurantList.elementAt(index).weightedRatingValue!.toStringAsFixed(1),
                                                                            style: FontUtils.h16(
                                                                              fontColor: Colors.black,
                                                                              fontWeight: FWT.regular,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child: Text(
                                                                          '(${restaurantList.elementAt(index).aggregatedRatingCount ?? ''})',
                                                                          style: FontUtils.h12(
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
                                                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  restaurantList.elementAt(index).name ?? '',
                                                                  style: FontUtils.h18(
                                                                    fontColor: AppColors.darkGray,
                                                                    fontWeight: FWT.semiBold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 22,
                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.lightGrey,
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    restaurantList.elementAt(index).cuisines!.isEmpty ||
                                                                            restaurantList.elementAt(index).cuisines == []
                                                                        ? ''
                                                                        : restaurantList.elementAt(index).cuisines![0],
                                                                    style: FontUtils.h14(
                                                                      fontColor: AppColors.darkGray,
                                                                      fontWeight: FWT.lightMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        /*  result == 'I will pick it myself'
                                                ? const SizedBox()
                                                : Row(
                                                    children: [
                                                      Image.asset(
                                                        AssetsUtils.deliveryVehicle,
                                                        width: 15,
                                                        height: 15,
                                                        color: AppColors.darkGray,
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        '\$ ${restaurantList.elementAt(index).quotes?.cheapestDelivery?.deliveryFee?.deliveryFeeFlat ?? 0}  •  ${restaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.minimum ?? 0}-${restaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.maximum ?? 0} min',
                                                        style: FontUtils.h14(
                                                          fontColor: AppColors.darkGray,
                                                          fontWeight: FWT.lightMedium,
                                                        ),
                                                      )
                                                    ],
                                                  ),*/
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
                          );
                        }),
                  ],
                ),
              );
            });
  }
}
