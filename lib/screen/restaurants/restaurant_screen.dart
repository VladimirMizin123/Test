// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_dashboard_model.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/get_location/get_location.dart';
import 'package:gymeats_mobile/screen/restaurants/res_category_data_service/res_categorydata_service.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/delivery_order_option_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/food_intake_bottomsheet_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/filter_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/repository/get_restaurant_details.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_screen.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/calorie_details_dialog.dart';
import 'package:gymeats_mobile/widget/network_image_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gymeats_mobile/service/signalr_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymeats_mobile/repository/get_address.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/models/error_model.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({
    super.key,
    this.onBack,
  });
  final Function()? onBack;

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  RxDouble kmRadius = 3.0.obs;
  RxBool showRadiusSlider = false.obs;
  final GlobalKey _alertKey = GlobalKey();
  int currentPage = 2;
  bool isRestaurantsLoading = false;
  
  showBottomSheet() {
    String searchValue = search.text;
    fetchRestaurant(fromSearch: searchValue.trim().isNotEmpty);
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   builder: (context) {
    //     return DeliverOrderBottomSheet(
    //       selectedIndex: selectedIndex,
    //       isFrom: 'isFromRestaurant',
    //     );
    //   },
    //   isDismissible: false,
    //   enableDrag: false,
    //   shape: OutlineInputBorder(
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(16.r),
    //       topRight: Radius.circular(16.r),
    //     ),
    //     borderSide: const BorderSide(
    //       color: Colors.transparent,
    //     ),
    //   ),
    // ).then((value) {
    //   if (value != null) {
    //     result = value;
    //     selectedIndex = result == 'Bring me the order' ? 0 : 1;
    //     if (mounted) {
    //       setState(() {});
    //     }
    //     print('user address');
    //     print(getUserAddress);
    //     if (getUserAddress != null) {
    //       /// GET RESTAURANT LIST API-----------------------------------------------------------
    //       String searchValue = search.text;
    //       fetchRestaurant(fromSearch: searchValue.trim().isNotEmpty);

    //       /// GET COUSINES LIST API-----------------------------------------------------------
    //       restaurantBloc.add(
    //         GetCousinesEvent(
    //           getUserAddress?.latitude ?? 0,
    //           getUserAddress?.longitude ?? 0,
    //           getUserAddress?.streetNum ?? '',
    //           getUserAddress?.streetName ?? '',
    //           getUserAddress?.city ?? '',
    //           getUserAddress?.state ?? '',
    //           getUserAddress?.country ?? '',
    //           getUserAddress?.zipcode ?? '',
    //           result == 'Bring me the order' ? false : true,
    //           kmRadius.value.round(),
    //         ),
    //       );
    //     } else {}

    //     cartBloc.add(GetCartEvent());
    //   }
    // });
  }

  

  showLogIntakeBottomSheet({GetUserAddress? getUserAddress}) async {
    bool understand = PreferenceUtils.getBool(understandDisclaimer);
    if (!understand) {
      await showDisclaimer();
    }
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
        widget.onBack?.call();
        return;
      }
      if (value != null) {
        mealType = value;
      }
      showBottomSheet();
      if (mounted) {
        setState(() {});
      }
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
  bool getRestaurantMenuLoadingState = true;
  bool restaurantVerificationLoader = false;
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
  int selectedIndex = 0;
  final _debouncer = Debouncer();
  List<Map<String, dynamic>> categoryData = [];

  GetDashboardModel dashboardModel = GetDashboardModel();

  @override
  void initState() {
    super.initState();
    kmRadius.value = PreferenceUtils.getRestaurantsRadius();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Geolocator.requestPermission().then((value) {
        if (mounted) {
          initLoad();
        }
      });
    });
    // _fetchCategoryData();
    dashboardModel = GetDashboardModel.fromJson(
        jsonDecode(PreferenceUtils.getString(dashboardModelPref)));
  }

  

  Future<List<Map<String, dynamic>>> _fetchCategoryData() async {
    setState(){
       getRestaurantMenuLoadingState = true;
    }
    try {
      final prefs = await SharedPreferences.getInstance();

      String currentAddress = prefs.getString('currentUserAddress') ?? '';

      if (currentAddress.trim().isEmpty) {
        print('fetch Category data, address is empty');
        String newAddress = "";
        final repo = GetAddressRepository();
        final addressResult = await repo.getUserAddressData();
        print('Address Result in _fetchCategoryData');

        if (addressResult.isRight) {
          var add = addressResult.right.data
              ?.firstWhereOrNull((element) => element.isPrimary ?? false);
          add ??= addressResult.right.data?.first;

          if (add != null) {
            final parts = [
              add.streetNum,
              add.streetName,
              add.city,
              add.country
            ].where((e) => e != null && e.trim().isNotEmpty).cast<String>().toList();
            newAddress = parts.join(", ");
          }
          print('newAddress: $newAddress');
        }

        if (newAddress.trim().isEmpty) {
          return [];
        }

        final trimmedNew = newAddress.trim();
        final trimmedOld = currentAddress.trim();

        final addressChanged = trimmedOld.isNotEmpty && trimmedOld != trimmedNew;

        if (addressChanged || trimmedOld.isEmpty) {
          await prefs.setString('currentUserAddress', trimmedNew);
          print("Address saved in SharedPreferences: $trimmedNew");

          if (trimmedOld.isNotEmpty && trimmedOld != trimmedNew) {
            await prefs.setBool('AddressUpdated', true);
            print("AddressUpdated");
          }

          currentAddress = trimmedNew;
        }
      }

      final cacheKey = 'categoryCache_$currentAddress';

      final cachedCategoriesString = prefs.getString(cacheKey);

      if (cachedCategoriesString != null) {
        final cachedList = jsonDecode(cachedCategoriesString) as List<dynamic>;
        final cachedData = cachedList.cast<Map<String, dynamic>>();
        print('Categories from cache for address: $currentAddress');
        return cachedData;
      }
      String userID = PreferenceUtils.getString(prefUserData);
      final signalR = SignalRService();
      final categories = await signalR.getRestaurantCategories(currentAddress, userID);

      final categoryData = (categories as List<dynamic>)
        .where((category) => (category['name'] ?? '') != 'Grocery')
        .map<Map<String, dynamic>>((category) {
          print(category['name']);
          return {
            'title': category['name'],
            'id': category['id'],
            'image': category['imageSrc'],
          };
        }).toList();

      print(categoryData);

      await prefs.setString(cacheKey, jsonEncode(categoryData));
      setState(){
       getAddressLoadingState = false;
      }
      return categoryData;
    } catch (e) {
      setState(){
       getAddressLoadingState = false;
      }
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<void> initLoad() async {
    try {
      restaurantBloc.add(GetUserAddressEvent());
      cartBloc.add(GetCartEvent());
      restaurantBloc.add(GetDeliveryStatusEvent());
      PreferenceUtils.setFoodMenuAddress();
    } catch (e) {
      log(e.toString());
    }
  }

  String? verifyLoaderId;

  @override
  void dispose() {
    restaurantBloc.close();
    super.dispose();
  }

  String prefKey = "";
  bool isChange = false;
  bool cacheLoading = false;

  Future<void> fetchRestaurant({bool fromSearch = false}) async {
    print('fetchrestaurant');
    String searchValue = search.text;
    List<String> cuisineList = selectedFoodOrigin.isNotEmpty
        ? selectedFoodOrigin.map((e) => e.toString()).toList()
        : [];

    final newCategoryData = await _fetchCategoryData();

    if (mounted) {
      print('SetState');
      setState(() {
        categoryData = newCategoryData;
      });
    }

    // List<String> cuisineList = categoryData.isNotEmpty
    //     ? categoryData.map((e) => e["title"].toString()).toList()
    //     : [];
    //     print(cuisineList);
    //     print('LLLLLLL');
      if (fromSearch) {
        restaurantBloc.add(
          RestaurantByNameEvent(
            getUserAddress?.latitude,
            getUserAddress?.longitude,
            result == 'Bring me the order' ? false : true,
            searchValue,
            cuisineList,
          ),
        );
      }
      if (result == 'Bring me the order') {
        prefKey = restaurantsBring;
      } else {
        prefKey = restaurantsPickup;
      }
      String resPref = PreferenceUtils.getString(prefKey);
      restaurantBloc.add(
          GetRestaurantListEvent(
            getUserAddress?.latitude ?? 0,
            getUserAddress?.longitude ?? 0,
            result == 'Bring me the order' ? false : true,
            cuisineList,
            storeLocal: !isChange,
          ),
        );
  }

  Future<void> fetchNextRestaurants() async {
    if (isRestaurantsLoading == true) return;
      setState(() {
        isRestaurantsLoading = true;
      });
      try {
        List<String> cuisineList = selectedFoodOrigin.isNotEmpty
            ? selectedFoodOrigin.map((e) => e.toString()).toList()
            : [];

        final rep = RestaurantRepository();

        Either<ErrorModel, GetRestaurantListModel> data =
            await rep.getRestaurantListData(
          latitude: 0,
          longitude: 0,
          maximumMiles: PreferenceUtils.getRestaurantsRadius().round(),
          pickup: false,
          categoriesData: cuisineList,
          mealName: '',
          page: currentPage,
        );

        print(data);

        if (data.isRight) {
          final GetRestaurantListModel right = data.right;

          if (right.data != null && right.data!.isNotEmpty) {
            print('Fetched ${right.data!.length} restaurants on page $currentPage');
            print('First restaurant: ${right.data!.first.name}');


            final updatedSet = <RestaurantList>{...allRestaurantList};
            updatedSet.addAll(right.data!);

            allRestaurantList = updatedSet.toList();
            restaurantList = updatedSet;
            dataList = allRestaurantList;

            currentPage++;

            getRestaurantMenuLoadingState = false;

          } else {
            print('No new restaurants received on page $currentPage');
          }
        } else {
          data.fold(
            (error) => print('Error while fetching restaurants: $error'),
            (_) => null,
          );
        }

      } catch (e, st) {
      print('Exception while fetching restaurants: $e');
      print(st);
    } finally {
      setState(() {
        isRestaurantsLoading = false;
      });
    }
  }

  Future<dynamic> showDisclaimer() async {
    bool showAgain = PreferenceUtils.getBool(understandDisclaimer);
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) => Material(
        color: AppColors.transparentColor,
        child: Align(
          alignment: Alignment.center,
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: context.height * 0.92,
              constraints: const BoxConstraints(
                maxHeight: 615,
              ),
              width: context.width,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Align(
                          child: Image.asset(
                            AssetsUtils.gymEatsSpoon,
                            height: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        20.height,
                        const Text(
                          "Disclaimer:",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.errorRedColor,
                            fontFamily: "Avenir",
                          ),
                        ),
                        10.height,
                        const Text(
                          'The meals shown may not perfectly match your allergy preferences. To ensure safety, we strongly recommend that you customize your order by selecting from the available options.\n\nAlways add details such as "no bread" or "no onions" in the "order notes" before confirming your order.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.errorRedColor,
                            fontFamily: "Avenir",
                          ),
                        ),
                        20.height,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 150,
                                child: Image.asset(AssetsUtils.disclaimer1),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 150,
                                child: Image.asset(AssetsUtils.disclaimer2),
                              ),
                            ),
                          ].addBetweenItems(0.width),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      StatefulBuilder(
                        builder: (_, setState) => Checkbox(
                          value: showAgain,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -4.0),
                          onChanged: (bool? value) {
                            setState(() {
                              showAgain = value ?? false;
                            });
                          },
                          activeColor: AppColors.appColor,
                        ),
                      ),
                      10.width,
                      const Text(
                        "I understand. Don't show this again.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                          fontFamily: "Avenir",
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  simpleTextBorderButton(
                    context: context,
                    buttonLable: "I Understand",
                    height: context.height * 0.065,
                    width: context.width,
                    isDarkColor: true,
                    isFillColor: true,
                    onTap: () => {
                      PreferenceUtils.setBool(understandDisclaimer, showAgain),
                      Get.back(),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: bloc.BlocConsumer<CartBloc, CartState>(
          bloc: cartBloc,
          listener: (context, state) {
            if (state is RestaurantCartState) {
              cartCount = state.shoppingList.length;
            }
          },
          builder: (context, state) {
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
                            arguments: {
                              "string": 'isFromRestaurant',
                              "userData": ''
                            });
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
                                "string": 'isFromRestaurant',
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
                                  constraints:
                                      const BoxConstraints(maxWidth: 300),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircularProgressIndicator(
                                              color: AppColors.primaryBlue),
                                          20.height,
                                          StreamBuilder(
                                            stream: Stream.periodic(
                                                const Duration(
                                                    milliseconds: 500)),
                                            builder: (_, __) {
                                              int ml = DateTime.now()
                                                  .difference(time)
                                                  .inMilliseconds;
                                              return Text(
                                                ml > 1500
                                                    ? StringUtils
                                                        .organizingMenuItems
                                                    : StringUtils
                                                        .fetchingYourDelicious,
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
                                      // Positioned(
                                      //   right: 2,
                                      //   top: 2,
                                      //   child: IconButton(
                                      //     onPressed: () async {
                                      //       final signalR = SignalRService();
                                      //       await signalR.goBack();
                                      //       Get.back();
                                      //       restaurantBloc.prevId = null;
                                      //       verifyLoaderId = null;
                                      //     },
                                      //     icon: const Icon(Icons.close),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      if (mounted) {
                        setState(() {});
                      }
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

                    if (state is RestaurantVerificationLoader) {
                      restaurantVerificationLoader = state.isLoading;
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
                      if (cacheLoading != true) {
                        getCousinesLoadingState = true;
                      }
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
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(height: 5.h),
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
                                onTap: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountScreen(),
                                      ));
                                  String resPref =
                                      PreferenceUtils.getString(prefKey);
                                  if (resPref.trim().isEmpty) {
                                    initLoad();
                                  }
                                },
                                child: SvgPicture.asset(
                                  AssetsUtils.userSvg,
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
                              InkWell(
                                onTap: () {
                                  Get.toNamed('/OrderHistoryScreen');
                                },
                                child: SvgPicture.asset(
                                    AssetsUtils.notificationSvg),
                              )
                            ],
                          ),

                          /// Choose Delivery type ---------------------------------------------------------
                          SizedBox(
                            width: context.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print(result);
                                    // showBottomSheet();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 225.w,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.terracotta,
                                          width: 1),
                                      color: AppColors.coral,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          AssetsUtils.deliveryVehicle,
                                          width: 15,
                                          height: 15,
                                          color: AppColors.terracotta,
                                        ),
                                        Text(
                                          // result.isEmpty
                                          //     ? 'Choose delivery type'
                                          //     : result,
                                          'bring me the order',
                                          style: const TextStyle(
                                            color: AppColors.terracotta,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.terracotta,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    onTap: () {
                                      showRadiusSlider.toggle();
                                      // if (!showRadiusSlider.value) {
                                      //   if (PreferenceUtils
                                      //               .getRestaurantsRadius()
                                      //           .round() !=
                                      //       kmRadius.value.round()) {
                                      //     PreferenceUtils.setRestaurantsRadius(
                                      //         kmRadius.value);
                                      //     Constant.i.removeStore();
                                      //     Constant.i.handleStoreCache();
                                      //     isChange = true;
                                      //     if (search.text.trim().isEmpty) {
                                      //       fetchRestaurant();
                                      //     }
                                      //   }
                                      // }
                                    },
                                    child: Image.asset(
                                      AssetsUtils.icRadius,
                                      height: 25,
                                      color:
                                          const Color.fromRGBO(20, 27, 52, 1),
                                    ),
                                  ).paddingOnly(bottom: 4),
                                )
                              ],
                            ),
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
                                          onChangeEnd: (value) {
                                            kmRadius.value = value;
                                            showRadiusSlider.toggle();
                                            if (PreferenceUtils
                                                        .getRestaurantsRadius()
                                                    .round() !=
                                                kmRadius.value.round()) {
                                              PreferenceUtils
                                                  .setRestaurantsRadius(
                                                      kmRadius.value);
                                              Constant.i.removeStore();
                                              Constant.i.handleStoreCache();
                                              isChange = true;
                                              if (search.text.trim().isEmpty) {
                                                fetchRestaurant();
                                              }
                                            }
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

                          Expanded(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    /// Search bar -------------------------------------------------------------------

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Container(
                                          //   height: 48,
                                          //   width: 245.w,
                                          //   decoration: BoxDecoration(
                                          //     color: Colors.white,
                                          //     borderRadius:
                                          //         BorderRadius.circular(8),
                                          //     boxShadow: [
                                          //       BoxShadow(
                                          //         color: const Color(0xff004C63)
                                          //             .withOpacity(0.08),
                                          //         offset: const Offset(0, 0),
                                          //         blurRadius: 16,
                                          //       )
                                          //     ],
                                          //   ),
                                          //   child: TextFormField(
                                          //     style: const TextStyle(
                                          //         color: Colors.black),
                                          //     controller: search,
                                          //     decoration: InputDecoration(
                                          //       enabledBorder:
                                          //           OutlineInputBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(8),
                                          //         borderSide: BorderSide.none,
                                          //       ),
                                          //       focusedBorder:
                                          //           OutlineInputBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(8),
                                          //         borderSide: BorderSide.none,
                                          //       ),
                                          //       border: OutlineInputBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(8),
                                          //         borderSide: BorderSide.none,
                                          //       ),
                                          //       prefixIcon: const Icon(
                                          //         Icons.search,
                                          //         color: AppColors.darkGray,
                                          //       ),
                                          //       contentPadding:
                                          //           const EdgeInsets.all(0),
                                          //       hintText:
                                          //           'Search for item or place',
                                          //     ),
                                          //     onChanged: (String? value) {
                                          //       _debouncer.run(() {
                                          //         fetchRestaurant(
                                          //             fromSearch: true);
                                          //       });
                                          //     },
                                          //   ),
                                          // ),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     Get.to(
                                          //             () => RestaurantCart(
                                          //                   pickUp: result ==
                                          //                           'Bring me the order'
                                          //                       ? false
                                          //                       : true,
                                          //                   userAddress:
                                          //                       getUserAddress,
                                          //                 ),
                                          //             transition:
                                          //                 Transition.fadeIn)!
                                          //         .then((value) {
                                          //       cartBloc.add(GetCartEvent());
                                          //     });
                                          //   },
                                          //   child: Container(
                                          //     height: 48,
                                          //     width: 77,
                                          //     padding:
                                          //         const EdgeInsets.symmetric(
                                          //             horizontal: 18),
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.white,
                                          //       borderRadius:
                                          //           BorderRadius.circular(8),
                                          //       boxShadow: [
                                          //         BoxShadow(
                                          //           color:
                                          //               const Color(0xff004C63)
                                          //                   .withOpacity(0.08),
                                          //           offset: const Offset(0, 0),
                                          //           blurRadius: 16,
                                          //         )
                                          //       ],
                                          //     ),
                                          //     child: Row(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment
                                          //               .spaceBetween,
                                          //       children: [
                                          //         SvgPicture.asset(
                                          //           AssetsUtils.icShoppingIcon,
                                          //           color: AppColors.darkGray,
                                          //         ),
                                          //         Text(
                                          //           '$cartCount',
                                          //           style: FontUtils.h18(
                                          //               fontColor:
                                          //                   AppColors.darkGray,
                                          //               fontWeight: FWT.medium),
                                          //         )
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),

                                    /// Location ---------------------------------------------------------------------
                                    IntrinsicWidth(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 55.w),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await Get.to(
                                              () => const GetUserAddress(),
                                              transition: Transition.fadeIn,
                                              arguments: {
                                                "string": 'isFromRestaurant',
                                                "userData": ''
                                              },
                                            );
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
                                                    fontWeight: FWT.lightMedium,
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

                                    Expanded(
                                      child: getAddressLoadingState == true
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Builder(builder: (context) {
                                              return getRestaurantMenuLoadingState ==
                                                          true ||
                                                      getCousinesLoadingState ==
                                                          true
                                                  ? SingleChildScrollView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      child: ListView.builder(
                                                        itemCount: 10,
                                                        shrinkWrap: true,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Shimmer
                                                              .fromColors(
                                                                  baseColor: AppColors
                                                                      .disable
                                                                      .withOpacity(
                                                                          0.20),
                                                                  highlightColor: AppColors
                                                                      .disable
                                                                      .withOpacity(
                                                                          0.20),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            160.h,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                AppColors.disable,
                                                                            borderRadius: BorderRadius.circular(7)),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              7),
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 0,
                                                                                child: Container(
                                                                                  height: 30,
                                                                                  width: 70,
                                                                                  decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(7)),
                                                                                ),
                                                                              ),
                                                                              const Spacer(),
                                                                              Expanded(
                                                                                flex: 0,
                                                                                child: Container(
                                                                                  height: 20,
                                                                                  width: 50,
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColors.disable,
                                                                                    borderRadius: BorderRadius.circular(4),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Container(
                                                                                  height: 30,
                                                                                  decoration: BoxDecoration(color: AppColors.disable, borderRadius: BorderRadius.circular(7)),
                                                                                ),
                                                                              ),
                                                                              const Expanded(
                                                                                child: SizedBox(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      const Divider(
                                                                          color: AppColors
                                                                              .disable,
                                                                          thickness:
                                                                              1.2),
                                                                    ],
                                                                  ));
                                                        },
                                                      ),
                                                    )
                                                  : Column(
                                                      children: [
                                                        /// Tab bar ----------------------------------------------------------------------

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 16),
                                                          child:
                                                              SingleChildScrollView(
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: SizedBox(
                                                              height: 40.h,
                                                              child: Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      print(
                                                                          "enter filter screen");

                                                                      await Get
                                                                              .to(
                                                                        () =>
                                                                            FilterScreen(
                                                                          restaurantBloc:
                                                                              restaurantBloc,
                                                                          result:
                                                                              result,
                                                                          getUserAddres:
                                                                              getUserAddress,
                                                                          catgoryDataList:
                                                                              categoryData,
                                                                          // cousinesList:
                                                                          //     cousinesList!,
                                                                          restaurantList:
                                                                              allRestaurantList,
                                                                          selectedCategory:
                                                                              selectedFoodOrigin,
                                                                          rating:
                                                                              rating,
                                                                          isFastDelivery:
                                                                              isFastDelivery,
                                                                          isPickup: result == 'Bring me the order'
                                                                              ? false
                                                                              : true,
                                                                        ),
                                                                      )!
                                                                          .then(
                                                                              (value) {
                                                                        if (value !=
                                                                            null) {
                                                                          restaurantList =
                                                                              value['restaurantData'];

                                                                          selectedFoodOrigin =
                                                                              value['filterTab'];
                                                                          log(selectedFoodOrigin
                                                                              .toString());
                                                                          rating =
                                                                              value['rating'];

                                                                          isFastDelivery =
                                                                              value['fastDelivery'];
                                                                          if (mounted) {
                                                                            setState(() {});
                                                                          }
                                                                        } else {}
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8),
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              15),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppColors
                                                                            .lightGrey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              'All',
                                                                              style: FontUtils.h18(
                                                                                fontColor: AppColors.darkGray,
                                                                                fontWeight: FWT.medium,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 10),
                                                                            child:
                                                                                Icon(
                                                                              Icons.arrow_forward_ios_outlined,
                                                                              size: 15,
                                                                              color: AppColors.darkGray,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ListView.builder(
                                                                    shrinkWrap: true,
                                                                    itemCount: categoryData.length,
                                                                    padding: EdgeInsets.zero,
                                                                    scrollDirection: Axis.horizontal,
                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                    itemBuilder: (context, index) {
                                                                      return GestureDetector(
                                                                        onTap: () {
                                                                          final selectedTitle = categoryData[index]["title"];

                                                                          if (selectedFoodOrigin.contains(selectedTitle)) {
                                                                            selectedFoodOrigin.clear();
                                                                          } else {
                                                                            selectedFoodOrigin
                                                                              ..clear()
                                                                              ..add(selectedTitle);
                                                                          }

                                                                          if (mounted) {
                                                                            setState(() {});
                                                                          }

                                                                          fetchRestaurant();
                                                                        },
                                                                        child: Container(
                                                                          margin: const EdgeInsets.only(right: 8),
                                                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                          decoration: BoxDecoration(
                                                                            color: selectedFoodOrigin.contains(categoryData[index]["title"])
                                                                                ? AppColors.coral 
                                                                                : AppColors.lightGrey,
                                                                            borderRadius: BorderRadius.circular(100),
                                                                          ),
                                                                          child: Row(
                                                                            children: [
                                                                              Center(
                                                                                child: Text(
                                                                                  categoryData[index]["title"] ?? "",
                                                                                  style: FontUtils.h18(
                                                                                    fontColor: selectedFoodOrigin.contains(categoryData[index]["title"])
                                                                                        ? AppColors.terracotta 
                                                                                        : AppColors.darkGray,
                                                                                    fontWeight: FWT.medium,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              
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
                                                            ? searchRestaurantList
                                                                    .isNotEmpty
                                                                ? Expanded(
                                                                    child: ListView
                                                                        .separated(
                                                                      itemCount:
                                                                          searchRestaurantList
                                                                              .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const BouncingScrollPhysics(),
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              10,
                                                                          top:
                                                                              5),
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return const SizedBox(
                                                                          height:
                                                                              16,
                                                                        );
                                                                      },
                                                                      itemBuilder:
                                                                          (context, index) =>
                                                                              GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          onRestaurantTap(
                                                                              res: searchRestaurantList.elementAt(index));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 160,
                                                                                width: MediaQuery.of(context).size.width,
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Positioned.fill(
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                        child: (restaurantList.elementAt(index).logoPhotos?.isEmpty ?? true)
                                                                                            ? Image.asset(
                                                                                                AssetsUtils.icGenericLogo,
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : NetworkImageWidget(
                                                                                                url: restaurantList.elementAt(index).logoPhotos?[0] ?? "",
                                                                                                showLoader: false,
                                                                                                placeholder: AssetsUtils.icGenericLogo,
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        searchRestaurantList.elementAt(index).quotes?.cheapestDelivery?.deliveryFee?.deliveryFeeFlat == 0
                                                                                            ? Container(
                                                                                                width: 109,
                                                                                                margin: const EdgeInsets.all(12),
                                                                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
                                                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                Image.asset(AssetsUtils.ratingStar),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                                                  child: Center(
                                                                                                    child: Text(
                                                                                                      searchRestaurantList.elementAt(index).weightedRatingValue?.toStringAsFixed(1) ?? "",
                                                                                                      style: FontUtils.h16(
                                                                                                        fontColor: Colors.black,
                                                                                                        fontWeight: FWT.regular,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Center(
                                                                                                  child: Text(
                                                                                                    '(${searchRestaurantList.elementAt(index).aggregatedRatingCount ?? ''})',
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
                                                                                        searchRestaurantList.elementAt(index).name ?? '',
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
                                                                                          (searchRestaurantList.elementAt(index).cuisines?.isEmpty ?? true) || searchRestaurantList.elementAt(index).cuisines == [] ? '' : (searchRestaurantList.elementAt(index).cuisines?[0] ?? ""),
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
                                                                              // result == 'I will pick it up myself'
                                                                              //     ? const SizedBox()
                                                                              //     : Row(
                                                                              //         children: [
                                                                              //           Image.asset(
                                                                              //             AssetsUtils.deliveryVehicle,
                                                                              //             width: 15,
                                                                              //             height: 15,
                                                                              //             color: AppColors.darkGray,
                                                                              //           ),
                                                                              //           const SizedBox(
                                                                              //             width: 8,
                                                                              //           ),
                                                                              //           Text(
                                                                              //             '\$ ${searchRestaurantList.elementAt(index).quotes?.cheapestDelivery?.deliveryFee?.deliveryFeeFlat ?? 0}  •  ${searchRestaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.minimum ?? 0}-${searchRestaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.maximum ?? 0} min',
                                                                              //             style: FontUtils.h14(
                                                                              //               fontColor: AppColors.darkGray,
                                                                              //               fontWeight: FWT.lightMedium,
                                                                              //             ),
                                                                              //           )
                                                                              //         ],
                                                                              //       ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Expanded(
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Currently No Restaurant Found',
                                                                        style: FontUtils
                                                                            .h18(
                                                                          fontColor:
                                                                              AppColors.darkGray,
                                                                          fontWeight:
                                                                              FWT.medium,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                            : restaurantList
                                                                    .isNotEmpty
                                                                ? Expanded(
                                                        child: NotificationListener<ScrollNotification>(
                                                          onNotification: (ScrollNotification scrollInfo) {
                                                            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
                                                                !restaurantVerificationLoader) {
                                                              fetchNextRestaurants();
                                                            }
                                                            return false;
                                                          },
                                                          child: ListView(
                                                            shrinkWrap: true,
                                                            physics: const BouncingScrollPhysics(),
                                                            children: [
                                                              ListView.separated(
                                                                itemCount: restaurantList.length,
                                                                shrinkWrap: true,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                padding: const EdgeInsets.only(bottom: 10, top: 5),
                                                                separatorBuilder: (context, index) => const SizedBox(height: 16),
                                                                itemBuilder: (context, index) => GestureDetector(
                                                                  onTap: () {
                                                                    onRestaurantTap(res: restaurantList.elementAt(index));
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
                                                                        SizedBox(
                                                                          height: 160,
                                                                          width: MediaQuery.of(context).size.width,
                                                                          child: Stack(
                                                                            children: [
                                                                              Positioned.fill(
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                  child: (restaurantList.elementAt(index).logoPhotos?.isEmpty ?? true)
                                                                                      ? Image.asset(
                                                                                          AssetsUtils.icGenericLogo,
                                                                                          fit: BoxFit.cover,
                                                                                        )
                                                                                      : NetworkImageWidget(
                                                                                          url: restaurantList.elementAt(index).logoPhotos?[0] ?? "",
                                                                                          showLoader: false,
                                                                                          placeholder: AssetsUtils.icGenericLogo,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  restaurantList.elementAt(index).quotes?.cheapestDelivery?.deliveryFee?.deliveryFeeFlat == 0
                                                                                      ? Container(
                                                                                          width: 109,
                                                                                          margin: const EdgeInsets.all(12),
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.white,
                                                                                            borderRadius: BorderRadius.circular(8),
                                                                                          ),
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
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.white,
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                      ),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Image.asset(AssetsUtils.ratingStar),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                restaurantList.elementAt(index).weightedRatingValue?.toStringAsFixed(1) ?? "",
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
                                                                                    (restaurantList.elementAt(index).cuisines?.isEmpty ?? true) || restaurantList.elementAt(index).cuisines == []
                                                                                        ? ''
                                                                                        : (restaurantList.elementAt(index).cuisines?[0] ?? ""),
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
                                                                        // Row(
                                                                        //   children: [
                                                                        //     Image.asset(
                                                                        //       AssetsUtils.deliveryVehicle,
                                                                        //       width: 15,
                                                                        //       height: 15,
                                                                        //       color: AppColors.darkGray,
                                                                        //     ),
                                                                        //     const SizedBox(width: 8),
                                                                        //     Text(
                                                                        //       '\$ ${restaurantList.elementAt(index).quotes?.cheapestDelivery?.deliveryFee?.deliveryFeeFlat ?? 0}  •  ${restaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.minimum ?? 0}-${restaurantList.elementAt(index).quotes?.cheapestDelivery?.timeEstimate?.maximum ?? 0} min',
                                                                        //       style: FontUtils.h14(
                                                                        //         fontColor: AppColors.darkGray,
                                                                        //         fontWeight: FWT.lightMedium,
                                                                        //       ),
                                                                        //     )
                                                                        //   ],
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (restaurantVerificationLoader) ...[
                                                                const SizedBox(height: 16),
                                                                const AppCenterLoader(),
                                                                const SizedBox(height: 16),
                                                              ],
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                      : Expanded(
                                                        child: Center(
                                                          child: getRestaurantMenuLoadingState
                                                              ? SizedBox.shrink()
                                                              : Text(
                                                                  'Currently No Restaurant Found',
                                                                  style: FontUtils.h18(
                                                                    fontColor: AppColors.darkGray,
                                                                    fontWeight: FWT.medium,
                                                                  ),
                                                                ),
                                                        ),
                                                      )
                                                      ],
                                                    );
                                            }),
                                    )
                                  ],
                                ),
                                Obx(
                                  () => showRadiusSlider.value
                                      ? Positioned.fill(
                                          child: ClipRRect(
                                            child: Container(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                            ),
                                          ).animate(),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          if (isRestaurantsLoading) ...[
                            const SizedBox(height: 16),
                            const AppCenterLoader(),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
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

  void verifyRestaurant({required RestaurantList res}) {
    try {
      restaurantBloc.prevId = res.id;
      if (verifyLoaderId != null) {
        return;
      }
      restaurantBloc.add(
        RestaurantVerifyEvent(
          latitude: 0,
          longitude: 0,
          pickup: result == 'Bring me the order' ? false : true,
          id: res.id ?? "",
          mealType: mealType,
          context: context,
          restaurantName: res.name,
          onVerify: (menu, quote) async {
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
                pickup: result == 'Bring me the order' ? false : true,
                bloc: restaurantBloc,
                mealType: mealType,
                menu: menu,
                startedLoading: true,
                quote: quote,
              ),
              transition: Transition.fadeIn,
            )?.then(
              (value) {
                cartBloc.add(GetCartEvent());
              },
            );
          },
          notVerify: () {
            print("STORE NOT VERIFIFED");
            restaurantList.removeWhere((element) => element.id == res.id);
            searchRestaurantList.removeWhere((element) => element.id == res.id);
            if (search.text.trim().isEmpty) {
              PreferenceUtils.setString(
                prefKey, 
                jsonEncode(restaurantList.toList()),
              );
            }
            if (mounted) {
              setState(() {});
            }
          },
        ),
      );
    } catch (e) {
      print('exception');
      log(e.toString());
    }
  }
}

class CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const CustomSliderTrackShape();
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
