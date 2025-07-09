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
import 'package:gymeats_mobile/service/signalr_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List mealType = ['I can eat', 'Price'];

  int select = 0;
  int cartCount = 0;
  bool dialogOpen = false;
  int selectedSubCategoryIndex = 0;
  bool _isGoingBack = false;
  bool isMenuLoading = false;

  int currentMenuPage = 1;
  bool isLoadingMenu = false;

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
  int selectedCategoryIndex = 0;
  int? selectedSubIndex;

  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  String selectedCategoryName = '';
  String? selectedSubcategoryName = '';

  List<String> mealPlanId = [];
  List<MealData> mealInfo = [];
  final GlobalKey _alertKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    String trackerList = PreferenceUtils.getString(trackerListStore);
    print('TRACKER LIST');
    print(trackerList);
    mealInfo = mealDataModelFromJson(trackerList);
    print('MEAL INFO');
    print(widget.mealType.toLowerCase());
    print(mealInfo);
    for (final meal in mealInfo) {
      print(meal.toJson());
    }
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
                  final parentCategoryIndex = restaurantMenu?.categories?.indexWhere(
                    (cat) => cat.name == state.categoryName,
                  );

                  if (parentCategoryIndex != null && parentCategoryIndex >= 0) {
                    if (state.subCategoryId == null) {
                      var categoryList = restaurantMenu?.categories?[parentCategoryIndex].menuItemList ?? [];

                      categoryList.removeWhere((item) {
                        final exists = state.updatedList.any((updated) => updated.name == item.name);
                        return !exists;
                      });

                      restaurantMenu?.categories?[parentCategoryIndex].menuItemList = categoryList;

                    } else {
                      final subIndex = int.tryParse(state.subCategoryId ?? '');
                      if (subIndex != null &&
                          subIndex >= 0 &&
                          subIndex < (restaurantMenu?.categories?[parentCategoryIndex].subcategories?.length ?? 0)) {
                        
                        var subcategoryList = restaurantMenu?.categories?[parentCategoryIndex]
                            .subcategories?[subIndex]
                            .menuItemList ?? [];

                        subcategoryList.removeWhere((item) {
                          final exists = state.updatedList.any((updated) => updated.name == item.name);
                          return !exists;
                        });

                        restaurantMenu?.categories?[parentCategoryIndex]
                            .subcategories?[subIndex]
                            .menuItemList = subcategoryList;
                      } else {
                        print("Invalid subcategory index: $subIndex");
                      }
                    }
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
                          _isGoingBack
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            )
                          : 
                          GestureDetector(
                              onTap: () async {
                                if (_isGoingBack) return;

                                setState(() => _isGoingBack = true);

                                final signalR = SignalRService();
                                final prefs = await SharedPreferences.getInstance();

                                final isItemAdded = prefs.getBool('item-added-to-cart') ?? false;

                                if (isItemAdded) {
                                  dynamic result = await Constant.i.showAlertDialog(
                                    context: context,
                                    title: 'Leaving this page will clear your cart. Do you want to continue?',
                                    desc: '',
                                    cancelTask: 'Cancel',
                                    confirmTask: 'Confirm',
                                  );
                                  if (result != true) {

                                    setState(() => _isGoingBack = true);
                                    return;
                                  }
                                  cartBloc.add(RemoveCart());
                                  cartCount = 0;
                                  await signalR.clearRestaurantCartItems();
                                  await prefs.setBool('item-added-to-cart', false);
                                }

                                await signalR.redirectToHomePage();

                                if (mounted) {
                                  setState(() => _isGoingBack = false);
                                  Get.back();
                                }
                              },
                              child: const Icon(Icons.arrow_back_ios),
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
                                                        iCanEat = !iCanEat;
                                                      });
                                                      _handleFilterTap(restaurantMenu?.categories?[index].name ?? "", index);
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
                                                        restaurantMenu
                                                                ?.categories?[
                                                                    index]
                                                                .name ??
                                                            "",
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
                                        if (restaurantMenu!.hasShopRestaurant == true &&
                                            restaurantMenu!.categories![select].subcategories != null &&
                                            restaurantMenu!.categories![select].subcategories!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16, bottom: 20),
                                            child: SizedBox(
                                              height: 40.h,
                                              child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                padding: const EdgeInsets.only(left: 16),
                                                itemCount:
                                                    restaurantMenu!.categories![select].subcategories!.length,
                                                itemBuilder: (context, index) {
                                                  final sub = restaurantMenu!
                                                      .categories![select].subcategories![index];

                                                  final isSelected = index == selectedSubCategoryIndex;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedSubCategoryIndex = index;
                                                      });

                                                      final category = restaurantMenu?.categories?[select];
                                                      final subcategory = category?.subcategories?[index];

                                                      if (category != null && subcategory != null) {
                                                        _handleFilterTap(
                                                          category.name ?? "",
                                                          select,
                                                          subcategoryIndex: index,
                                                          subcategoryName: subcategory.name,
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets.only(right: 8),
                                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? AppColors.coral
                                                            : AppColors.lightGrey,
                                                        borderRadius: BorderRadius.circular(100),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          sub.name ?? '',
                                                          style: FontUtils.h18(
                                                            fontColor: isSelected
                                                                ? AppColors.terracotta
                                                                : AppColors.darkGray,
                                                            fontWeight: FWT.medium,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),

                                          // Filters

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
                                                      _handleCanEat();
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
                                                          mealType[index] ?? "",
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
                                            if (isMenuLoading) {
                                              return const Expanded(
                                                child: Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              );
                                            }

                                            int selectedCategoryIndex = select;

                                            final selectedCategory = restaurantMenu!.categories![selectedCategoryIndex];

                                            final menuItems = restaurantMenu!.hasShopRestaurant == true
                                                ? (selectedCategory.subcategories?.isNotEmpty ?? false)
                                                    ? selectedCategory.subcategories![selectedSubCategoryIndex].menuItemList ?? []
                                                    : []
                                                : selectedCategory.menuItemList ?? [];

                                            int? index = -1;

                                            if (priceValue.isNotEmpty) {
                                              index = menuItems.indexWhere((element) {
                                                final price = (element.originalPrice ?? 0) / 100;

                                                if (priceValue == '40') {
                                                  return int.parse(priceValue) <= price;
                                                } else {
                                                  final range = priceValue.split('-');
                                                  final min = int.parse(range.first);
                                                  final max = int.parse(range.last);
                                                  return price >= min && price <= max;
                                                }
                                              });

                                              if (index < 0) {
                                                return Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      StringUtils.thereIsNoMealInPriceRange,
                                                      style: FontUtils.h18(
                                                        fontColor: AppColors.darkGray,
                                                        fontWeight: FWT.medium,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                                                                  

                                            return Expanded(
                                              child: NotificationListener<ScrollNotification>(
                                                onNotification: (ScrollNotification scrollInfo) {
                                                  if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
                                                      !_isFetchingMore && !isLoadingMenu) {
                                                        print('FETCHING MORE $_isFetchingMore');
                                                        setState(() {
                                                            _isFetchingMore = true;
                                                        });
                                                    loadNewMenuItems().then((_) {
                                                      Future.delayed(const Duration(milliseconds: 500), () {
                                                        setState(() {
                                                          _isFetchingMore = false;
                                                        });
                                                      });
                                                    });
                                                  }
                                                  return false;
                                                },
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics: const BouncingScrollPhysics(),
                                                  children: [
                                                    ListView.separated(
                                                      itemCount: menuItems.length,
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                                                      itemBuilder: (context, index) {
                                                        final item = menuItems[index];
                                                        final price = (item.originalPrice ?? 0) / 100;

                                                        final isInRange = priceValue.isEmpty ||
                                                            (priceValue == '40'
                                                                ? int.parse(priceValue) <= price
                                                                : int.parse(priceValue.split('-').first) <= price &&
                                                                    int.parse(priceValue.split('-').last) >= price);

                                                        return isInRange
                                                            ? displayData(
                                                                index: index,
                                                                subcategoryIndex: restaurantMenu!.hasShopRestaurant == true
                                                                    ? selectedSubCategoryIndex
                                                                    : null,
                                                              )
                                                            : const SizedBox();
                                                      },
                                                    ),

                                                    if (isLoadingMenu) ...[
                                                      const SizedBox(height: 16),
                                                      const Center(child: CircularProgressIndicator()),
                                                      const SizedBox(height: 16),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Padding(
                                        //         padding: EdgeInsets.symmetric(
                                        //             vertical: 10.h),
                                        //         child:
                                        //             RestaurantMealAddButtonWidget(
                                        //           onTap: () {
                                        //             Get.to(
                                        //               () => RestaurantCart(
                                        //                 pickUp: widget.pickup,
                                        //                 userAddress: widget
                                        //                     .getUserAddress,
                                        //               ),
                                        //               // transition: Transition.fadeIn,
                                        //             )!;
                                        //           },
                                        //           buttonLable: 'View Cart',
                                        //           isFillColor: true,
                                        //           selectedItemCount:
                                        //               cartData.length,
                                        //         ),
                                        // )

                                        cartData.length != 0
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

  Widget displayData({
    required int index,
    int? subcategoryIndex,
  }) {
    final size = MediaQuery.of(context).size;

    final category = restaurantMenu!.categories![select];

    final menuItem = restaurantMenu!.hasShopRestaurant == true
        ? category.subcategories![subcategoryIndex ?? 0].menuItemList![index]
        : category.menuItemList![index];

    final data = cartData.firstWhereOrNull(
      (element) => element.productId == menuItem.productId,
    );

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
                      resAddress: widget.address,
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
                  resAddress: widget.address,
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (menuItem.image != null)
                //   NetworkImageWidget(
                //     url: menuItem.image!,
                //     showSizedBox: true,
                //     width: 80.w,
                //     showLoader: false,
                //   ).paddingOnly(right: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Text(
                          menuItem.name ?? "",
                          style: FontUtils.h16(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.boldMedium,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          menuItem.description ?? '',
                          style: FontUtils.h14(
                            fontColor: const Color(0xffA2A4A7),
                            fontWeight: FWT.light,
                          ),
                        ),
                      )
                    ],
                  ).paddingOnly(right: 10),
                ),
                iCanEat
                    ? Image.asset(
                        matchIcon(status(menuItem)),
                        width: 25.w,
                      )
                    : const SizedBox.shrink(),
                SizedBox(width: 25),
                SizedBox(
                  width: 80.w,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${menuItem.price == 0 ? "\$${((menuItem.minPrice ?? 0) / 100).toStringAsFixed(2)}" : menuItem.formattedPrice}",
                        style: FontUtils.h18(
                          fontColor: Colors.black,
                          fontWeight: FWT.medium,
                        ),
                      ),
                      if (menuItem.image != null) ...[
                        NetworkImageWidget(
                          url: menuItem.image!,
                          showSizedBox: true,
                          width: 80.w,
                          showLoader: false,
                        ).paddingOnly(bottom: 10),
                      ],
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
                                    resAddress: widget.address,
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
                                    resAddress: widget.address,
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
                          height: 28,
                          alignment: Alignment.bottomRight,
                        ),
                      ),
                    ],
                  ),
                ),
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

  Future<void> loadNewMenuItems() async {
  if (isLoadingMenu) return;
  isLoadingMenu = true;

  try {

     if (selectedCategoryName == "") {
      final categories = restaurantMenu?.categories;
      if (categories != null && categories.isNotEmpty) {
        selectedCategoryName = categories[0].name ?? '';
        selectedCategoryIndex = 0;

        final subcategories = categories[0].subcategories;
        if (subcategories != null && subcategories.isNotEmpty) {
          selectedSubcategoryName = subcategories[0].name ?? '';
          selectedSubIndex = 0;
        } else {
          selectedSubcategoryName = null;
          selectedSubIndex = null;
        }
      }
    }

    print("🟦 Starting to load new menu items...");
    final signalR = SignalRService();

    print("🔹 Calling getMenuItems with:");
    print("   - category: $selectedCategoryName");
    print("   - subcategory: $selectedSubcategoryName");
    print("   - page: $currentMenuPage");

    final List<dynamic>? result = await signalR.getMenuItems(
      selectedCategoryName,
      selectedSubcategoryName,
      currentMenuPage,
      false,
    );

    print('✅ Response received');
    print(result);

    setState(() {
      currentMenuPage++;
    });

    if (result != null && result.isNotEmpty) {
      final newItems = result.map<MenuItemList>((item) {
        final priceString = item['Price']?.replaceAll('\$', '').trim();
        final priceDouble = double.tryParse(priceString ?? '') ?? 0.0;
        return MenuItemList(
          name: item['Name'] ?? '',
          image: item['ImageUrl'],
          formattedPrice: item['Price'],
          cartPrice: priceDouble,
          isAvailable: true,
          description: item['Calories'],
          itemUrl: item['ItemUrl'],
        );
      }).toList();

      setState(() {
        print("🔍 Trying to update existing menu list");

        if (selectedCategoryIndex == null) {
          print("❌ selectedCategoryIndex is null");
          return;
        }

        final category = restaurantMenu?.categories?[selectedCategoryIndex!];
        if (category == null) {
          print("❌ Category is null");
          return;
        }

        List<MenuItemList>? currentList;

        if (selectedSubIndex != null) {
          final subcategories = category.subcategories;
          if (subcategories == null || selectedSubIndex! >= subcategories.length) {
            print("❌ Subcategory index out of bounds or null list");
            return;
          }
          currentList = subcategories[selectedSubIndex!].menuItemList;
        } else {
          currentList = category.menuItemList;
        }

        final existingNames = currentList?.map((e) => e.name).toSet() ?? {};
        final filteredNewItems = newItems
            .where((item) => !existingNames.contains(item.name))
            .toList();

        if (filteredNewItems.isNotEmpty) {
          print("Adding ${filteredNewItems.length} new items to current list");
          currentList?.addAll(filteredNewItems);
          currentMenuPage++;
        } else {
          print("ℹNo new items to add");
        }
      });
    } else {
      print("ℹNo new menu items received");
    }
  } catch (e, st) {
    print("Error loading more menu items: $e");
    print("Stack trace:\n$st");
  } finally {
    isLoadingMenu = false;
  }
}

void _handleCanEat() {
  if (iCanEat && restaurantMenu != null) {
    iCanEat = false;
    openLoader();

    String? localSubcategoryIndex = selectedSubCategoryIndex.toString();

    if (localSubcategoryIndex != null) {
      final subcategories = restaurantMenu
          ?.categories?[selectedCategoryIndex].subcategories;
      if (subcategories != null && subcategories.isNotEmpty) {
        localSubcategoryIndex = '0';
      } else {
        localSubcategoryIndex = null;
      }
    }

    MealData? meal = mealInfo.firstWhereOrNull(
      (element) => element.meal == widget.mealType.toLowerCase(),
    );

    widget.bloc.add(
      MealPlanMatchEvent(
        menu: restaurantMenu!,
        categoryId: selectedCategoryIndex.toString(),
        subcategoryId: localSubcategoryIndex?.toString(),
        calories: meal?.calories,
        onSuccess: () {
          mealPlanId.add((localSubcategoryIndex ?? selectedCategoryIndex).toString());
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

 Future<void> _handleFilterTap(
    String categoryName,
    int index, {
    int? subcategoryIndex,
    String? subcategoryName,
  }) async {
    print("HANDLE CAN EAT");

    setState(() {
      isMenuLoading = true;
      selectedCategoryName = categoryName;
      selectedCategoryIndex = index;
      if (subcategoryName != null) {
        selectedSubcategoryName = subcategoryName;
        selectedSubIndex = subcategoryIndex;
      }
    });

    final signalR = SignalRService();
    List<dynamic>? signalRResult;

    try {
      final category = restaurantMenu?.categories?[index];

      final alreadyHasMenu = () {
        if (subcategoryIndex != null && category?.subcategories != null) {
          final subcat = category!.subcategories!;
          final menu = subcategoryIndex >= 0 &&
                      subcategoryIndex < subcat.length
                      ? subcat[subcategoryIndex].menuItemList
                      : null;
          return menu?.isNotEmpty == true;
        } else {
          return category?.menuItemList?.isNotEmpty == true;
        }
      }();

      if (alreadyHasMenu) {
        signalR.getMenuItems(categoryName, subcategoryName, 1, false);
        print("Using already loaded menu. Triggered background update with isInitLoad = false");

        setState(() {
          isMenuLoading = false;
        });

      } else {
        if (restaurantMenu?.hasShopRestaurant == true &&
            subcategoryIndex == null &&
            subcategoryName == null) {
          final subcategoryNames = await signalR.getRestaurantSubcategories(categoryName);

          if (subcategoryNames.isEmpty) {
            signalRResult = await signalR.getMenuItems(categoryName);
          } else {
            selectedSubCategoryIndex = 0;
            final firstSub = subcategoryNames.first;
            signalRResult = await signalR.getMenuItems(categoryName, firstSub);

            final subcategoryList = List<Category>.generate(
              subcategoryNames.length,
              (subIndex) => Category(
                name: subcategoryNames[subIndex],
                subcategoryId: null,
                menuItemList: subIndex == 0
                    ? signalRResult!.map<MenuItemList>((item) {
                        final priceString = item['Price']?.replaceAll('\$', '').trim();
                        final priceDouble = double.tryParse(priceString ?? '') ?? 0.0;

                        return MenuItemList(
                          name: item['Name'] ?? '',
                          image: item['ImageUrl'],
                          formattedPrice: item['Price'],
                          cartPrice: priceDouble,
                          isAvailable: true,
                          description: item['Calories'],
                          itemUrl: item['ItemUrl'],
                        );
                      }).toList()
                    : [],
              ),
            );

            if (category != null) {
              category.subcategories = subcategoryList;
            }

            if (mounted) {
              setState(() {
                isMenuLoading = false;
              });
            }

            return;
          }
        } else {
          signalRResult = await signalR.getMenuItems(categoryName, subcategoryName);
        }

        final List<MenuItemList> menuItems = signalRResult!.map<MenuItemList>((item) {
          final priceString = item['Price']?.replaceAll('\$', '').trim();
          final priceDouble = double.tryParse(priceString ?? '') ?? 0.0;

          return MenuItemList(
            name: item['Name'] ?? '',
            image: item['ImageUrl'],
            formattedPrice: item['Price'],
            cartPrice: priceDouble,
            isAvailable: true,
            description: item['Calories'],
            itemUrl: item['ItemUrl'],
          );
        }).toList();

        if (category != null) {
          if (subcategoryIndex != null &&
              category.subcategories != null &&
              subcategoryIndex >= 0 &&
              subcategoryIndex < category.subcategories!.length) {
            category.subcategories![subcategoryIndex].menuItemList = menuItems;
          } else {
            category.menuItemList = menuItems;
          }
        }

        if (mounted) {
          setState(() {
            isMenuLoading = false;
          });
        }
      }

      if (iCanEat) {
        iCanEat = false;
        setState(() {});
        openLoader();

        MealData? meal = mealInfo.firstWhereOrNull(
          (element) => element.meal == widget.mealType.toLowerCase(),
        );

        widget.bloc.add(
          MealPlanMatchEvent(
            menu: restaurantMenu!,
            subcategoryId: subcategoryIndex != null ? subcategoryIndex.toString() : null,
            categoryId: categoryName,
            calories: meal?.calories,
            onSuccess: () {
              String? valueToAdd;
              if (subcategoryIndex == null) {
                valueToAdd = categoryName;
              } else {
                final subcategories = category?.subcategories;
                if (subcategoryIndex >= 0 && subcategories != null && subcategoryIndex < subcategories.length) {
                  valueToAdd = subcategories[subcategoryIndex].name;
                }
              }

              if (valueToAdd != null && !mealPlanId.contains(valueToAdd)) {
                mealPlanId.add(valueToAdd);
              }

              setState(() {});
              Navigator.of(context).pop();
            },
            onError: () {
              setState(() {});
              if (_alertKey.currentContext != null) {
                Navigator.of(context).pop();
              }
            },
          ),
        );
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          isMenuLoading = false;
        });
      }
      print('Error in _handleCanEat: $e');
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
