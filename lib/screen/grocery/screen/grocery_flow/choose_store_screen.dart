import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/store_categories_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/custom_search_field.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/restaurant_card.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart'
    as re;
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart'
    as rs;
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_screen.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user_address;
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as address;

import 'package:get/get.dart' as gt;

class ChooseGroceryStore extends StatefulWidget {
  const ChooseGroceryStore({super.key});

  @override
  State<ChooseGroceryStore> createState() => _ChooseGroceryStoreState();
}

class _ChooseGroceryStoreState extends State<ChooseGroceryStore> {
  List<Store> storeList = [];
  bool pageLoader = false;
  RestaurantBloc restaurantBloc = RestaurantBloc();
  GroceryBloc groceryBloc = GroceryBloc();
  int? selectedStore;
  String? searchText;
  TextEditingController searchController = TextEditingController();

  AddNewGroceryItemBloc addNewGroceryItemBloc = AddNewGroceryItemBloc();
  List<GroceryDetails> groceryDetails = [];

  user_address.UserAddress? getUserAddress;
  List<dynamic> edgesDummyList = [];
  int selectedIndex = -1;

  String? verifyLoaderId;

  AskReceiveOrder? get askOrder => selectedIndex == 0 || selectedIndex == 1
      ? AskReceiveOrder.values[selectedIndex]
      : null;

  final _debouncer = Debouncer();

  late String prefKey;
  bool alreadyCache = false;

  RxDouble kmRadius = 3.0.obs;
  RxBool showRadiusSlider = false.obs;

  @override
  void initState() {
    super.initState();
    kmRadius.value = PreferenceUtils.getGroceryRadius();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Geolocator.requestPermission().then((value) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return DeliverOrderBottomSheet(
              selectedIndex: selectedIndex,
              isFrom: 'isFromRestaurant',
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
          selectedIndex = value == 'Bring me the order' ? 0 : 1;
          if (selectedIndex == 0) {
            prefKey = groceryBring;
          } else {
            prefKey = groceryPickup;
          }
          getCacheResponse();
          restaurantBloc.add(re.GetUserAddressEvent());
          addNewGroceryItemBloc.add(GetGroceryItemEvent());
        });
      });
    });
  }

  void getCacheResponse() {
    String value = PreferenceUtils.getString(prefKey);
    if (value.trim().isNotEmpty) {
      alreadyCache = true;
      storeList = storeListFromJson(value);
      setState(() {});
    }
  }

  void getNearByStore() {
    getCacheResponse();
    if (!alreadyCache) {
      groceryBloc.add(
        StoreNearByEvent(
          getUserAddress: getUserAddress,
          askReceiveOrder: askOrder,
        ),
      );
    }
  }

  @override
  void dispose() {
    groceryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<GroceryBloc, GroceryState>(
        bloc: groceryBloc,
        listener: (context, state) {
          if (state is NearByStoreSuccessState) {
            storeList = state.storeList ?? [];
          }

          if (state is NearByStoreLoaderState) {
            pageLoader = state.isLoading;
            setState(() {});
          }

          if (state is VerifyLoader) {
            verifyLoaderId = state.id;
            setState(() {});
          }
        },
        builder: (context, state) {
          return BlocListener<RestaurantBloc, RestaurantState>(
            bloc: restaurantBloc,
            listener: (context, state) {
              print(state is GrocerySearchLoadingState);

              if (state is rs.GetUserAddressLoadingState) {
                pageLoader = true;
              }
              if (state is rs.GetUserAddressErrorState) {
                pageLoader = false;
              }

              if (state is rs.GetUserAddressSuccessState) {
                for (var i = 0; i < state.userAddress.length; i++) {
                  if (state.userAddress[i].isPrimary == true) {
                    getUserAddress = state.userAddress[i];
                    break;
                  }
                }
                if ((state.userAddress.isNotEmpty) &&
                    !state.userAddress
                        .any((element) => (element.isPrimary ?? false))) {
                  getUserAddress = state.userAddress.first;
                }
                getNearByStore();
              }
            },
            child: BlocConsumer<AddNewGroceryItemBloc, AddNewGroceryItemState>(
              bloc: addNewGroceryItemBloc,
              listener: (context, state) {
                if (state is GetGroceryListSuccessState) {
                  groceryDetails = state.groceryDetails ?? [];
                  setState(() {});
                }
              },
              builder: (context, __) {
                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Scaffold(
                    body: SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Image.asset(
                            AssetsUtils.gymEatsLogo,
                            height: 35.h,
                            color: AppColors.green,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            StringUtils.chooseAStore,
                            style: FontUtils.h24(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.medium,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomSearchField(
                                  controller: searchController,
                                  onChange: (p0) {
                                    _debouncer.run(() {
                                      storeList = [];
                                      setState(() {});
                                      groceryBloc.add(
                                        StoreByNameEvent(
                                          getUserAddress: getUserAddress,
                                          askReceiveOrder: askOrder,
                                          name: p0,
                                        ),
                                      );
                                      if (p0?.trim().isEmpty ?? true) {
                                        getNearByStore();
                                      }
                                    });
                                  },
                                ),
                              ),
                              10.width,
                              GestureDetector(
                                onTap: () async {
                                  showRadiusSlider.toggle();
                                  if (!showRadiusSlider.value) {
                                    if (PreferenceUtils.getGroceryRadius()
                                            .round() !=
                                        kmRadius.value.round()) {
                                      PreferenceUtils.setGroceryRadius(
                                          kmRadius.value.roundToDouble());
                                      await Constant.i.removeStore();
                                      Constant.i.handleStoreCache();

                                      if (searchController.text
                                          .trim()
                                          .isEmpty) {
                                        alreadyCache = false;
                                        storeList = [];
                                        getNearByStore();
                                      }
                                    }
                                  }
                                },
                                child: Image.asset(
                                  AssetsUtils.icRadius,
                                  height: 25,
                                  color: const Color.fromRGBO(20, 27, 52, 1),
                                ).paddingOnly(right: 10, bottom: 4),
                              )
                            ],
                          ),
                          Obx(
                            () => showRadiusSlider.value
                                ? Column(
                                    children: [
                                      15.height,
                                      Text(
                                        "Delivery Radius",
                                        style:
                                            textTheme.displayMedium?.copyWith(
                                          color: const Color(0xFF000000),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SliderTheme(
                                        data: const SliderThemeData(
                                          trackShape: CustomSliderTrackShape(),
                                          showValueIndicator:
                                              ShowValueIndicator.always,
                                          valueIndicatorColor:
                                              AppColors.appColor,
                                          valueIndicatorTextStyle: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.whiteColor,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                        child: Slider(
                                          value: kmRadius.value,
                                          min: 3,
                                          max: 10,
                                          label:
                                              "${kmRadius.value.round()} Mile",
                                          onChanged: (value) {
                                            kmRadius.value = value;
                                          },
                                        ),
                                      ).paddingOnly(right: 10, left: 10),
                                    ],
                                  ).animate().scale(
                                      duration:
                                          const Duration(milliseconds: 200),
                                    )
                                : const SizedBox(),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: Container(
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      IntrinsicWidth(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 55.w),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await Get.to(
                                                  () => const GetUserAddress(),
                                                  transition:
                                                      gt.Transition.fadeIn,
                                                  arguments: {
                                                    "string": 'isFromGrocery',
                                                    "userData": ''
                                                  });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  AssetsUtils.icRestaurants,
                                                  height: 14,
                                                  width: 12,
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    getUserAddress == null
                                                        ? 'No Location'
                                                        : PreferenceUtils
                                                                .isManualLocation
                                                            ? (getUserAddress
                                                                    ?.streetName ??
                                                                '')
                                                            : "Current Location",
                                                    style: FontUtils.h14(
                                                      fontColor:
                                                          AppColors.darkGray,
                                                      fontWeight:
                                                          FWT.lightMedium,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      Expanded(
                                        child: storeList.isEmpty
                                            ? state is GrocerySearchLoadingState ||
                                                    pageLoader && !alreadyCache
                                                ? const AppCenterLoader()
                                                : Center(
                                                    child: Text(
                                                      StringUtils.noDataFound,
                                                      style: FontUtils.h14(
                                                          fontColor:
                                                              AppColors.black),
                                                    ),
                                                  )
                                            : SingleChildScrollView(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Builder(
                                                  builder: (context) {
                                                    List<Store> filterStore = storeList
                                                        .where((e) =>
                                                            e.name
                                                                ?.toLowerCase()
                                                                .contains(searchText
                                                                        ?.toLowerCase() ??
                                                                    "") ??
                                                            false)
                                                        .toList();
                                                    return ListView.separated(
                                                      itemCount:
                                                          filterStore.length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              16.height,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return RestaurantCard(
                                                          index: index,
                                                          selectedIndex:
                                                              selectedStore,
                                                          store: filterStore[
                                                              index],
                                                          logoPhotos: filterStore[
                                                                      index]
                                                                  .logoPhotos ??
                                                              [],
                                                          isLoading:
                                                              verifyLoaderId ==
                                                                  filterStore[
                                                                          index]
                                                                      .id,
                                                          onTap: () {
                                                            verifyGrocery(
                                                              filterStore[index]
                                                                  .id,
                                                              filterStore[index]
                                                                  .name,
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => showRadiusSlider.value
                                        ? Positioned.fill(
                                            child: ClipRRect(
                                              child: Container(
                                                color: Colors.white
                                                    .withOpacity(0.6),
                                              ),
                                            ).animate(),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(left: 12, right: 12),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  void verifyGrocery(String? id, String? storeName) {
    if (verifyLoaderId == null) {
      groceryBloc.add(
        StoreVerifyEvent(
          getUserAddress: getUserAddress,
          askReceiveOrder: askOrder,
          id: id,
          notVerify: () {
            storeList.removeWhere((element) => element.id == id);
            if (searchController.text.trim().isEmpty) {
              PreferenceUtils.setString(prefKey, jsonEncode(storeList));
            }
            setState(() {});
          },
          onVerify: (categorie) {
            Get.to(
              () => StoreCategoriesScreen(
                storeId: id,
                address: getUserAddress,
                storeName: storeName,
                groceryDetails: groceryDetails,
                askOrder: askOrder,
                categorie: categorie,
              ),
            );
          },
        ),
      );
    }
  }

  String getAddress(Address? address) {
    List<String?> addresslist = [
      address?.streetAddr,
      address?.city,
      address?.state
    ]..removeWhere((element) => element == null || element.trim().isEmpty);

    return addresslist.join(" , ");
  }
}

class StoreScreenArguments {
  final address.UserAddress? getUserAddress;

  StoreScreenArguments({this.getUserAddress});
}
