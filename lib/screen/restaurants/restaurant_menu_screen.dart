import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/bottomsheet/filter_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_Add_button.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_details_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_details_screen.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/network_image_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gymeats_mobile/models/check_store_model.dart' as qu;

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({
    super.key,
    this.restaurantName,
    required this.restaurantId,
    required this.pickup,
    required this.mealType,
    required this.userId,
    required this.address,
    required this.getUserAddress,
    required this.bloc,
    this.menu,
    this.startedLoading = false,
    this.quote,
  });
  final String? restaurantName;
  final String restaurantId;
  final String mealType;
  final bool pickup;
  final String userId;
  final Address address;
  final UserAddress? getUserAddress;
  final RestaurantMenu? menu;
  final RestaurantBloc bloc;
  final bool startedLoading;
  final qu.Quote? quote;

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  List selectedTabData = [];

  List mealType = [
    'I can eat',
    'Price',
  ];

  int select = 0;
  int cartCount = 0;
  bool dialogOpen = false;

  // RestaurantBloc restaurantBloc = RestaurantBloc();
  bool loading = false;
  bool loading1 = false;
  bool alreadyLoaded = false;
  bool isAddUpdate = false;
  bool isRemoveUpdate = false;
  String priceValue = '';
  RestaurantMenu? restaurantMenu;
  List<ShoppingListData> cartData = [];
  ShoppingListData? selectedCartData;
  List<MenuItemList> menuItem = [];
  bool hasCartData = false;
  bool iCanEat = false;

  List<String> mealPlanId = [];
  List<MealData> mealInfo = [];
  final GlobalKey _alertKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    String trackerList = PreferenceUtils.getString(trackerListStore);
    mealInfo = mealDataModelFromJson(trackerList);
    if (widget.menu == null) {
      widget.bloc.add(
        GetRestaurantMenuListEvent(widget.restaurantId, widget.pickup,
            widget.mealType, widget.getUserAddress),
      );
    } else {
      alreadyLoaded = true;
      setRestaurantMenu(widget.menu);
    }
    cartBloc.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bloc.BlocConsumer<CartBloc, CartState>(
        bloc: cartBloc,
        listener: (context, state) {
          if (state is RestaurantCartState) {
            cartData.clear();
            cartData = state.shoppingList;
            cartCount = cartData.length;
            if (restaurantMenu != null) {
              if (cartData.isNotEmpty) {
                for (var element in restaurantMenu!.categories!) {
                  for (var element1 in element.menuItemList!) {
                    if (cartData
                        .any((e) => e.productId == element1.productId)) {
                      ShoppingListData? data = cartData.firstWhereOrNull(
                          (e) => e.productId == element1.productId);
                      element1.cartQuantity = data?.quantity ?? 0;
                      element1.cartPrice = data?.price ?? 0;
                      element1.isAdded = true;
                      hasCartData = true;
                    } else {
                      element1.cartQuantity = 0;
                      element1.cartPrice = 0;
                      element1.isAdded = false;
                    }
                  }
                }
              } else {
                for (var element in restaurantMenu!.categories!) {
                  for (var element1 in element.menuItemList!) {
                    element1.cartQuantity = 0;
                    element1.cartPrice = 0;
                    element1.isAdded = false;
                    hasCartData = false;
                  }
                }
              }
            }
            if (mounted) {
              setState(() {});
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: bloc.BlocConsumer(
              bloc: widget.bloc,
              listener: (context, state) {
                if (state is GetRestaurantMenuListLoadingState) {
                  loading = true;
                }
                if (state is GetRestaurantMenuListSuccessState) {
                  setRestaurantMenu(state.restaurantMenuList);
                  loading = false;
                }
                if (state is GetRestaurantMenuListErrorState) {
                  loading = false;
                }

                if (state is MatchMealState) {
                  int? index = restaurantMenu?.categories?.indexWhere(
                      (element) =>
                          element.subcategoryId == state.subCategoryId);
                  if (index != null && !index.isNegative) {
                    restaurantMenu?.categories?[index].menuItemList =
                        state.updatedList;
                  }
                  if (mounted) {
                    setState(() {});
                  }
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Center(
                      child: Image.asset(
                        AssetsUtils.gymEatsSpoon,
                        height: 22.h,
                        width: 56.w,
                        color: AppColors.terracotta,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 20.h, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                            ),
                          ),
                          SizedBox(
                            width: 270.w,
                            child: Text(
                              '${widget.restaurantName} Menu',
                              style: const TextStyle(
                                color: Color(0xFF010101),
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                    ),
                    loading == true || loading1 == true
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: 10,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                  top: 20, left: 16, right: 16),
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Shimmer.fromColors(
                                    baseColor:
                                        AppColors.disable.withOpacity(0.20),
                                    highlightColor:
                                        AppColors.disable.withOpacity(0.20),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: AppColors.disable,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                height: 80,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  color: AppColors.disable,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: AppColors.disable,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  // color: AppColors.disable,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                            color: AppColors.disable,
                                            thickness: 1.2),
                                      ],
                                    ));
                              },
                            ),
                          )
                        : restaurantMenu == null
                            ? Expanded(
                                child: Center(
                                    child: Text(
                                  StringUtils.notfoundResmenuError,
                                  textAlign: TextAlign.center,
                                  style: FontUtils.h18(
                                    fontColor: AppColors.darkGray,
                                    fontWeight: FWT.medium,
                                  ),
                                ).paddingAll(30)),
                              )
                            : restaurantMenu!.categories!.isEmpty
                                ? Expanded(
                                    child: Center(
                                        child: Text(
                                      StringUtils.notfoundResmenuError,
                                      textAlign: TextAlign.center,
                                      style: FontUtils.h18(
                                        fontColor: AppColors.darkGray,
                                        fontWeight: FWT.medium,
                                      ),
                                    ).paddingAll(30)),
                                  )
                                : Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// Meal type Slider ------------------------------------------------------------
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                restaurantMenu!
                                                    .categories!.length,
                                                (index) => GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      select = index;
                                                    });
                                                    _handleCanEat(restaurantMenu
                                                            ?.categories?[index]
                                                            .subcategoryId ??
                                                        "");
                                                  },
                                                  child: Container(
                                                    height: 30.h,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25.w),
                                                    decoration: BoxDecoration(
                                                      border: BorderDirectional(
                                                        bottom: BorderSide(
                                                          color: index == select
                                                              ? AppColors
                                                                  .primaryBlue
                                                              : AppColors
                                                                  .disabledColor,
                                                          width: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        restaurantMenu!
                                                            .categories![index]
                                                            .name!,
                                                        style: FontUtils.h18(
                                                          fontWeight:
                                                              FWT.medium,
                                                          fontColor: index ==
                                                                  select
                                                              ? AppColors
                                                                  .primaryBlue
                                                              : AppColors
                                                                  .disabledColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        /// Tab bar ----------------------------------------------------------------------
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16, bottom: 20),
                                          child: SizedBox(
                                            height: 40.h,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: mealType.length,
                                              padding: const EdgeInsets.only(
                                                  left: 16),
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (index != 0) {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return FilterBottomSheet(
                                                            filterType:
                                                                mealType[index],
                                                            price: priceValue,
                                                          );
                                                        },
                                                        isDismissible: false,
                                                        shape:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    16.r),
                                                            topRight:
                                                                Radius.circular(
                                                                    16.r),
                                                          ),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            priceValue = value;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            priceValue = '';
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      String subId =
                                                          restaurantMenu!
                                                                  .categories?[
                                                                      select]
                                                                  .subcategoryId ??
                                                              "";
                                                      setState(() {
                                                        iCanEat = !iCanEat;
                                                      });
                                                      _handleCanEat(subId);
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
                                                      color: index == 1 &&
                                                                  priceValue
                                                                      .isNotEmpty ||
                                                              index == 0 &&
                                                                  iCanEat ==
                                                                      true
                                                          ? AppColors.coral
                                                          : AppColors.lightGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          mealType[index],
                                                          style: FontUtils.h18(
                                                            fontColor: index ==
                                                                            1 &&
                                                                        priceValue
                                                                            .isNotEmpty ||
                                                                    index ==
                                                                            0 &&
                                                                        iCanEat ==
                                                                            true
                                                                ? AppColors
                                                                    .terracotta
                                                                : AppColors
                                                                    .darkGray,
                                                            fontWeight:
                                                                FWT.medium,
                                                          ),
                                                        ),
                                                        index != 0
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                  size: 15,
                                                                  color: index == 1 &&
                                                                              priceValue
                                                                                  .isNotEmpty ||
                                                                          index == 0 &&
                                                                              iCanEat ==
                                                                                  true
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
                                            ),
                                          ),
                                        ),

                                        /// Restaurant Menu ----------------------------------------------------------------

                                        Builder(
                                          builder: (context) {
                                            int? index = -1;

                                            if (priceValue.isNotEmpty) {
                                              index = restaurantMenu!
                                                  .categories![select]
                                                  .menuItemList
                                                  ?.indexWhere((element) {
                                                return priceValue == '40'
                                                    ? int.parse(priceValue) <=
                                                        ((element
                                                                .originalPrice)! /
                                                            100)
                                                    : int.parse(priceValue
                                                                .split('-')
                                                                .first) <=
                                                            ((element
                                                                    .originalPrice)! /
                                                                100) &&
                                                        int.parse(priceValue
                                                                .split('-')
                                                                .last) >=
                                                            ((element
                                                                    .originalPrice)! /
                                                                100);
                                              });

                                              if (index! < 0) {
                                                return Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      StringUtils
                                                          .thereIsNoMealInPriceRange,
                                                      style: FontUtils.h18(
                                                        fontColor:
                                                            AppColors.darkGray,
                                                        fontWeight: FWT.medium,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }

                                            return Expanded(
                                              child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: restaurantMenu!
                                                      .categories![select]
                                                      .menuItemList!
                                                      .length,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const SizedBox(
                                                      height: 10,
                                                    );
                                                  },
                                                  itemBuilder:
                                                      (context, index) {
                                                    return priceValue.isNotEmpty
                                                        ? (priceValue == "40"
                                                                ? int.parse(
                                                                        priceValue) <=
                                                                    ((restaurantMenu!
                                                                            .categories![
                                                                                select]
                                                                            .menuItemList![
                                                                                index]
                                                                            .originalPrice)! /
                                                                        100)
                                                                : int.parse(priceValue
                                                                            .split(
                                                                                '-')
                                                                            .first) <=
                                                                        ((restaurantMenu!.categories![select].menuItemList![index].originalPrice)! /
                                                                            100) &&
                                                                    int.parse(priceValue
                                                                            .split(
                                                                                '-')
                                                                            .last) >=
                                                                        ((restaurantMenu!.categories![select].menuItemList![index].originalPrice)! /
                                                                            100))
                                                            ? displayData(
                                                                index: index)
                                                            : const SizedBox()
                                                        : displayData(
                                                            index: index);
                                                  }),
                                            );
                                          },
                                        ),

                                        hasCartData == true && cartCount != 0
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.h),
                                                child:
                                                    RestaurantMealAddButtonWidget(
                                                  onTap: () {
                                                    Get.to(
                                                      () => RestaurantCart(
                                                        pickUp: widget.pickup,
                                                        userAddress: widget
                                                            .getUserAddress,
                                                      ),
                                                      // transition: Transition.fadeIn,
                                                    )!;
                                                  },
                                                  buttonLable: 'View Cart',
                                                  isFillColor: true,
                                                  selectedItemCount:
                                                      cartData.length,
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget displayData({required int index}) {
    final size = MediaQuery.of(context).size;
    MenuItemList menuItem =
        restaurantMenu!.categories![select].menuItemList![index];
    ShoppingListData? data = cartData
        .firstWhereOrNull((element) => element.productId == menuItem.productId);
    return GestureDetector(
      onTap: () async {
        bool hasSameRestaurant = cartData.isEmpty ||
            cartData
                .any((element) => element.mealmeStoreId == widget.restaurantId);

        if (!hasSameRestaurant) {
          dynamic result = await Constant.i.showAlertDialog(
            context: context,
            title: StringUtils.addingThisItemWillClear,
            desc: StringUtils.youAlreadyHaveItems,
            cancelTask: StringUtils.dontAdd,
            confirmTask: StringUtils.addItem,
          );
          if (result != true) {
            return;
          }
          cartBloc.add(RemoveCart());
          cartCount = 0;
        }

        for (var element in cartData) {
          if (element.productId == menuItem.productId) {
            selectedCartData = element;
          }
        }

        selectedCartData == null
            ? Get.to(
                () => RestaurantMealDetails(
                      data: menuItem,
                      restaurantId: widget.restaurantId,
                      cartCount: cartCount,
                      pickUp: widget.pickup,
                      matchMealStatus: iCanEat ? status(menuItem) : null,
                      quote: widget.quote,
                      getUserAddress: widget.getUserAddress,
                      onCustomizationChange: (p0) {
                        menuItem.customizations = p0;
                        setState(() {});
                      },
                    ),
                transition: Transition.fadeIn)!
            : Get.to(
                () => RestaurantMealDetails(
                  data: menuItem,
                  restaurantId: widget.restaurantId,
                  shoppingListData: selectedCartData,
                  cartCount: cartCount,
                  pickUp: widget.pickup,
                  getUserAddress: widget.getUserAddress,
                  matchMealStatus: iCanEat ? status(menuItem) : null,
                  quote: widget.quote,
                  onCustomizationChange: (p0) {
                    menuItem.customizations = p0;
                    setState(() {});
                  },
                ),
                transition: Transition.fadeIn,
              );
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                menuItem.image == null
                    ? Image.asset(AssetsUtils.food1, width: 80.w)
                    : NetworkImageWidget(
                        url: menuItem.image!,
                        placeholder: AssetsUtils.icGenericLogo,
                        width: 80.w,
                        showLoader: false,
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130.w,
                      child: Text(
                        menuItem.name!,
                        style: FontUtils.h16(
                          fontColor: AppColors.darkGray,
                          fontWeight: FWT.regular,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        menuItem.description ?? '',
                        style: FontUtils.h14(
                          fontColor: const Color(0xffA2A4A7),
                          fontWeight: FWT.light,
                        ),
                      ),
                    )
                  ],
                ),
                iCanEat
                    ? Image.asset(
                        matchIcon(status(menuItem)),
                        width: 25.w,
                      )
                    : const SizedBox.shrink(),
                Builder(builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${menuItem.price == 0 ? "\$${((menuItem.minPrice ?? 0) / 100).toStringAsFixed(2)}" : menuItem.formattedPrice}",
                        style: FontUtils.h18(
                          fontColor: Colors.black,
                          fontWeight: FWT.medium,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          for (var element in cartData) {
                            if (element.productId == menuItem.productId) {
                              selectedCartData = element;
                            }
                          }

                          bool hasSameRestaurant = cartData.isEmpty ||
                              cartData.any((element) =>
                                  element.mealmeStoreId == widget.restaurantId);

                          if (!hasSameRestaurant) {
                            dynamic result = await Constant.i.showAlertDialog(
                              context: context,
                              title: StringUtils.addingThisItemWillClear,
                              desc: StringUtils.youAlreadyHaveItems,
                              cancelTask: StringUtils.dontAdd,
                              confirmTask: StringUtils.addItem,
                            );
                            if (result != true) {
                              return;
                            }
                            cartBloc.add(RemoveCart());
                            cartCount = 0;
                          }

                          selectedCartData == null
                              ? await Get.to(
                                  () => RestaurantMenuDetailsScreen(
                                    data: menuItem,
                                    restaurantId: widget.restaurantId,
                                    cartCount: cartCount,
                                    pickUp: widget.pickup,
                                    quote: widget.quote,
                                    userAddress: widget.getUserAddress,
                                    onCustomizationChange: (p0) {
                                      menuItem.customizations = p0;
                                      setState(() {});
                                    },
                                  ),
                                  transition: Transition.fadeIn,
                                )!
                              : await Get.to(
                                  () => RestaurantMenuDetailsScreen(
                                    data: menuItem,
                                    restaurantId: widget.restaurantId,
                                    shoppingListData: selectedCartData,
                                    cartCount: cartCount,
                                    pickUp: widget.pickup,
                                    quote: widget.quote,
                                    userAddress: widget.getUserAddress,
                                    onCustomizationChange: (p0) {
                                      menuItem.customizations = p0;
                                      setState(() {});
                                    },
                                  ),
                                  transition: Transition.fadeIn,
                                );
                        },
                        child: Image.asset(
                          AssetsUtils.icAdd,
                          height: 22.h,
                          alignment: Alignment.bottomRight,
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
          menuItem.cartQuantity == 0 || menuItem.cartQuantity == null
              ? const SizedBox()
              : Builder(
                  builder: (context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: size.height * 0.08,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xff004C63).withOpacity(0.08),
                              offset: const Offset(0, 0),
                              blurRadius: 18),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '\$${double.parse(((data?.price ?? 0) / 100).toString()).toStringAsFixed(2)}',
                              style: FontUtils.h18(
                                  fontColor: const Color(0xff010101),
                                  fontWeight: FWT.semiBold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cartBloc.add(
                                    ChangeQty(
                                      productID: menuItem.productId,
                                      type: ModifyType.decrement,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: size.height * 0.060,
                                  width: size.height * 0.060,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: AppColors.terracotta)),
                                  child: Center(
                                    child: menuItem.isRemoveUpdated == true
                                        ? Transform.scale(
                                            scale: 0.5,
                                            child:
                                                const CircularProgressIndicator(
                                              color: AppColors.terracotta,
                                            ),
                                          )
                                        : menuItem.cartQuantity == 1
                                            ? SvgPicture.asset(
                                                AssetsUtils.icDelete,
                                                color: AppColors.terracotta,
                                              )
                                            : const Icon(
                                                Icons.remove,
                                                color: AppColors.terracotta,
                                              ),
                                  ),
                                  // child: const Center(child: Icon(Icons.remove, size: 27)),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                height: size.height * 0.060,
                                width: size.height * 0.060,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.disable),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                    child: Text(
                                  '${menuItem.cartQuantity}',
                                  style: FontUtils.h18(
                                      fontWeight: FWT.semiBold,
                                      fontColor: AppColors.darkGray),
                                )),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  cartBloc.add(
                                    ChangeQty(
                                      productID: menuItem.productId,
                                      type: ModifyType.increment,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: size.height * 0.060,
                                  width: size.height * 0.060,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: AppColors.coral,
                                  ),
                                  child: Center(
                                    child: menuItem.isAddUpdated == true
                                        ? Transform.scale(
                                            scale: 0.5,
                                            child:
                                                const CircularProgressIndicator(
                                              color: AppColors.terracotta,
                                            ))
                                        : const Icon(
                                            Icons.add,
                                            size: 27,
                                            color: AppColors.terracotta,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
          Divider(
            endIndent: 20.w,
            indent: 20.w,
            color: AppColors.disabledColor,
            thickness: 1,
          )
        ],
      ),
    );
  }

  String matchIcon(int status) {
    switch (status) {
      case 0:
        return AssetsUtils.icCanEat;
      case 1:
        return AssetsUtils.canEatYellow;
      default:
        return AssetsUtils.canEatRed;
    }
  }

  void _handleCanEat(String subId) {
    if (iCanEat && !mealPlanId.contains(subId) && restaurantMenu != null) {
      iCanEat = false;
      setState(() {});
      openLoader();
      MealData? meal = mealInfo.firstWhereOrNull(
          (element) => element.meal == widget.mealType.toLowerCase());
      widget.bloc.add(
        MealPlanMatchEvent(
          menu: restaurantMenu!,
          subcategoryId: subId,
          calories: meal?.calories,
          onSuccess: () {
            mealPlanId.add(subId);
            if (_alertKey.currentContext != null) {
              iCanEat = true;
              setState(() {});
              Navigator.of(context).pop();
            }
          },
          onError: () {
            if (_alertKey.currentContext != null) {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    }
  }

  Future<void> openLoader() async {
    try {
      DateTime time = DateTime.now();

      showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return Material(
            key: _alertKey,
            color: AppColors.transparentColor,
            child: Align(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 13),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      height: 210,
                      width: 250,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.black),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            child: Align(
                              alignment: Alignment.center,
                              child: StreamBuilder(
                                stream: Stream.periodic(
                                    const Duration(milliseconds: 500)),
                                builder: (context, snapshot) {
                                  int ml = DateTime.now()
                                      .difference(time)
                                      .inMilliseconds;
                                  return Text(
                                    ml > 4500
                                        ? StringUtils.almostThere
                                        : ml > 2500
                                            ? StringUtils.checkingAllergies
                                            : ml > 1500
                                                ? StringUtils
                                                    .gatheringIngredients
                                                : StringUtils
                                                    .calculatingMealCalories,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                      fontFamily: "Avenir",
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(
                            height: 30,
                            width: 30,
                            child: AppCenterLoader(),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 12,
                      child: IconButton(
                        onPressed: () => Get.back(result: false),
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
    } catch (e) {
      log(e.toString());
    }
  }

  int status(MenuItemList menu) {
    switch (menu.highLightedColor) {
      case "Yellow":
        return 1;
      case "Green":
        return 0;
      default:
        return 2;
    }
  }

  void setRestaurantMenu(RestaurantMenu? menu) {
    restaurantMenu = menu;

    if (restaurantMenu != null) {
      if (cartData.isNotEmpty) {
        for (var element in restaurantMenu!.categories!) {
          for (var element1 in element.menuItemList!) {
            for (var element2 in cartData) {
              if (element2.productId == element1.productId) {
                element1.cartQuantity = element2.quantity;
                element1.cartPrice = element2.price;
                element1.isAdded = true;
                hasCartData = true;
              }
            }
          }
        }
      } else {
        for (var element in restaurantMenu!.categories!) {
          for (var element1 in element.menuItemList!) {
            element1.cartQuantity = 0;
            element1.cartPrice = 0;
            element1.isAdded = false;
            hasCartData = false;
          }
        }
      }
    }
    if (mounted) {
      setState(() {});
    }
  }
}
