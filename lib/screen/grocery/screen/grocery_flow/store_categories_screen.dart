import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/bloc/store_cart_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/store_cart_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/categories_tile_widget.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/check_list_sheet.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/custom_search_field.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/model/categorie_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart'
    as groc_add;
import 'package:gymeats_mobile/service/signalr_service.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart' as gtm;

class StoreCategoriesScreen extends StatefulWidget {
  const StoreCategoriesScreen({
    super.key,
    required this.storeId,
    this.storeName,
    this.address,
    this.grocAdd,
    this.groceryDetails,
    this.askOrder,
    this.categorie,
  });
  final String? storeId;
  final String? storeName;
  final UserAddress? address;
  final groc_add.Address? grocAdd;
  final List<GroceryDetails>? groceryDetails;
  final AskReceiveOrder? askOrder;
  final CategorieModel? categorie;

  @override
  State<StoreCategoriesScreen> createState() => _StoreCategoriesScreenState();
}

class _StoreCategoriesScreenState extends State<StoreCategoriesScreen> {
  List<Category> categoriesList = [];
  RestaurantBloc restaurantBloc = RestaurantBloc();
  GroceryBloc groceryBloc = GroceryBloc();
  StoreCartBloc storeCartBloc = StoreCartBloc();
  String? searchText;
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool subcategoryLoader = false;
  bool isGoingBack = false;

  List<int> routing = [];

  @override
  void initState() {
    if (widget.categorie == null) {
      groceryBloc.add(
        StoreCategorieEvent(
          address: widget.address,
          storeId: widget.storeId,
          askReceiveOrder: widget.askOrder?.index,
        ),
      );
    } else {
      categoriesList = widget.categorie?.data?.categories ?? [];
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final signalR = SignalRService();
        signalR.redirectToHomePage();
      },
      child:  BlocConsumer<GroceryBloc, GroceryState>(
          bloc: groceryBloc,
          listener: (context, state) {
            if (state is CategorieLoaderState) {
              isLoading = state.loader;
            }
            if (state is CategorieSuccessState) {
              categoriesList = state.categoriesList.data?.categories ?? [];
            }
            if (state is SubCategorieLoaderState) {
              subcategoryLoader = state.loader;
            }
            if (state is SubCategorySuccessState) {
              getSubCategory()?.subcategoryList = state.subcategoryList;
              setState(() {});
            }
            setState(() {});
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      15.height,
                      Image.asset(
                        AssetsUtils.gymEatsLogo,
                        height: 20.h,
                        color: AppColors.green,
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [isGoingBack
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : 
                          BackButtonWidget(
                            onTap: () async {
                              Object state = storeCartBloc.state;
                              if (state is StoreCheckoutState &&
                                  state.menuItemList.isNotEmpty) {
                                dynamic allow = (await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          StringUtils.cart,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                            fontFamily: "Avenir",
                                          ),
                                        ),
                                        content: Text(
                                          StringUtils.cartWillEmptiedIfGoBack,
                                          style: const TextStyle(
                                            color: AppColors.black,
                                            fontFamily: "Avenir",
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            24, 15, 24, 15),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text(
                                              StringUtils.noTxt,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Avenir",
                                                fontSize: 16,
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.back(result: false);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text(
                                              StringUtils.yesTxt,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Avenir",
                                                fontSize: 16,
                                              ),
                                            ),
                                            onPressed: () async {
                                              final signalR = SignalRService();
                                              signalR.clearRestaurantCartItems();
                                              Get.back(result: true);
                                            },
                                          ),
                                          5.width,
                                        ],
                                      ),
                                    ) ??
                                    false);
                                if (allow == true) {
                                  print('ALLOW TRUE');
                                  setState(() => isGoingBack = true);
                                    final signalR = SignalRService();
                                    signalR.redirectToHomePage();
                                    setState(() => isGoingBack = false);
                                    Get.back();
                                }
                              } else {
                                  setState(() => isGoingBack = true);
                                  final signalR = SignalRService();
                                  signalR.redirectToHomePage();
                                  setState(() => isGoingBack = false);
                                  Get.back();
                              }
                            },
                          ),
                          Text(
                            'Categories',
                            style: FontUtils.h22(
                              fontColor: AppColors.oxFF010101,
                              fontWeight: FWT.medium,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              backgroundColor: AppColors.transparentColor,
                              isScrollControlled: true,
                              builder: (context) {
                                return CheckListSheet(
                                  groceryDetails: widget.groceryDetails,
                                );
                              },
                              isDismissible: false,
                            ),
                            child: SvgPicture.asset(AssetsUtils.icList),
                          ),
                        ],
                      ).paddingOnly(left: 14, right: 14),
                      SizedBox(height: 15.h),
                      CustomSearchField(
                        controller: searchController,
                        onChange: (p0) => setState(() => searchText = p0),
                      ).paddingOnly(left: 14, right: 14),
                      Expanded(
                        child: isLoading ? const AppCenterLoader() : categoriesList.isEmpty
                            ? 
                                
                              Center(
                                    child: Text(
                                      'Categories not found !',
                                      style: FontUtils.h16(
                                          fontColor: AppColors.black),
                                    ),
                                  )
                            : Container(
                                child: routing.isNotEmpty
                                    ? Builder(
                                        builder: (_) {
                                          Category? category = getSubCategory();

                                          List<
                                              Category> subcategoryList = (category
                                                      ?.subcategoryList ??
                                                  [])                   
                                              .where((element) =>
                                                  element.name
                                                      ?.toLowerCase()
                                                      .contains(searchText
                                                              ?.toLowerCase() ??
                                                          "") ??
                                                  false)
                                              .toList();

                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => setState(() {
                                                      handleBackTap();
                                                    }),
                                                    child: SvgPicture.asset(
                                                      AssetsUtils.icBackArrow,
                                                      height: 18,
                                                    ),
                                                  ),
                                                  24.width,
                                                  Expanded(
                                                    child: Text(
                                                      category?.name ??
                                                          "Sub Category",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: FontUtils.h16(
                                                        fontColor:
                                                            AppColors.oxFF010101,
                                                        fontWeight:
                                                            FWT.boldMedium,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ).paddingOnly(left: 20, right: 20),
                                              if (subcategoryLoader) ...[
                                                const Expanded(
                                                    child: AppCenterLoader()),
                                              ] else if (subcategoryList
                                                  .isEmpty) ...[
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      'Categories not found for ${subcategoryList.isEmpty && (category?.subcategoryList?.isEmpty ?? true) ? category?.name : searchText} !',
                                                      textAlign: TextAlign.center,
                                                      style: FontUtils.h16(
                                                          fontColor:
                                                              AppColors.black),
                                                    ),
                                                  ),
                                                )
                                              ] else ...[
                                                Expanded(
                                                  child: ListView.separated(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            0, 25, 0, 40),
                                                    itemCount:
                                                        subcategoryList.length,
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            _separator,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return CategoriesTileWidget(
                                                              category:
                                                                  subcategoryList[
                                                                      index],
                                                              showIcon: false,
                                                              onTap: () {
                                                                int i = category!
                                                                    .subcategoryList!
                                                                    .indexWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        subcategoryList[
                                                                                index]
                                                                            .name);
                                                                handleCategoryTap(
                                                                  category,
                                                                  i,
                                                                  subCategory: subcategoryList[index],
                                                                );
                                                                clearSearch();
                                                              })
                                                          .paddingOnly(
                                                              right: 6, left: 6);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ).paddingOnly(top: 20);
                                        },
                                      )
                                    : Builder(
                                        builder: (_) {
                                          List<Category> filterList = List<
                                                  Category>.from(categoriesList)
                                              .where((element) =>
                                                  element.name
                                                      ?.toLowerCase()
                                                      .contains(searchText
                                                              ?.toLowerCase() ??
                                                          "") ??
                                                  false)
                                              .toList();
                                          return ListView.separated(
                                            padding: const EdgeInsets.only(
                                                bottom: 40, top: 20),
                                            itemCount: filterList.length,
                                            separatorBuilder: (context, index) =>
                                                _separator,
                                            itemBuilder: (context, index) {
                                              return CategoriesTileWidget(
                                                category: filterList[index],
                                                onTap: () {
                                                  int i = categoriesList
                                                      .indexWhere((element) =>
                                                          element.name ==
                                                          filterList[index].name);
                                                  handleCategoryTap(
                                                      filterList[index], i);
                                                  clearSearch();
                                                  setState(() {});
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
                ),
              ),
            );
          })
    );
  }

  void handleCategoryTap(Category? category, int index, {Category? subCategory}) async {
  if (category == null) return;

  setState(() {
    isLoading = true;
  });

  final signalR = SignalRService();

  try {
    final alreadyHasMenu = () {
      if (subCategory != null) {
        return subCategory.menuItemList?.isNotEmpty == true;
      } else {
        return category.menuItemList?.isNotEmpty == true;
      }
    }();

    if (alreadyHasMenu) {
      setState(() {
        isLoading = false;
      });

      signalR.getMenuItems(
        category.name ?? '',
        subCategory?.name,
        1,
        false,
      );

      dynamic result = await Get.to(
        () => StoreCartScreen(
          groceryBloc: groceryBloc,
          menuItemList: subCategory?.menuItemList ?? category.menuItemList ?? [],
          categoryName: category.name ?? '',
          subCategoryName: subCategory?.name,
          storeName: widget.storeName,
          storeId: widget.storeId,
          address: widget.address,
          grocAdd: widget.grocAdd,
          groceryDetails: widget.groceryDetails,
          cartBloc: storeCartBloc,
          askOrder: widget.askOrder,
        ),
      );

      if (result == "category") {
        routing = [];
        setState(() {});
      }

      return;
    }

    if (category.hasShopRestaurant == true && subCategory == null) {
      final List<String> subcategoryNames =
          await signalR.getRestaurantSubcategories(category.name ?? '');

      if (subcategoryNames.isEmpty) {
        final signalRResult = await signalR.getMenuItems(category.name ?? '', null, 1, true);

        final menuItems = signalRResult.map<gtm.MenuItemList>((item) {
          final priceString = item['Price']?.replaceAll('\$', '').trim();
          final priceDouble = double.tryParse(priceString ?? '') ?? 0.0;

          return gtm.MenuItemList(
            name: item['Name'] ?? '',
            image: item['ImageUrl'],
            formattedPrice: item['Price'],
            cartPrice: priceDouble,
            originalPrice: (priceDouble * 100).round(),
            isAvailable: true,
            description: item['Calories'],
            itemUrl: item['ItemUrl'],
          );
        }).toList();

        category.menuItemList = menuItems;
      } else {
        final firstSub = subcategoryNames.first;
        final signalRResult = await signalR.getMenuItems(category.name ?? '', firstSub, 1, true);

        final firstMenuItems = signalRResult.map<gtm.MenuItemList>((item) {
          final priceString = item['Price']?.replaceAll('\$', '').trim();
          final priceDouble = double.tryParse(priceString ?? '') ?? 0.0;

          return gtm.MenuItemList(
            name: item['Name'] ?? '',
            image: item['ImageUrl'],
            formattedPrice: item['Price'],
            cartPrice: priceDouble,
            originalPrice: (priceDouble * 100).round(),
            isAvailable: true,
            description: item['Calories'],
            itemUrl: item['ItemUrl'],
          );
        }).toList();

        category.subcategoryList = List<Category>.generate(
          subcategoryNames.length,
          (subIndex) => Category(
            name: subcategoryNames[subIndex],
            subcategoryId: null,
            menuItemList: subIndex == 0 ? firstMenuItems : [],
          ),
        );

        setState(() {});
      }

      routing.add(index);
    } else {
      final signalRResult = await signalR.getMenuItems(
        category.name ?? '',
        subCategory?.name,
        1,
        true,
      );

      final menuItems = signalRResult.map<gtm.MenuItemList>((item) {
        final priceString = item['Price']?.replaceAll('\$', '').trim();
        final priceDouble = double.tryParse(priceString ?? '') ?? 0.0;

        return gtm.MenuItemList(
          name: item['Name'] ?? '',
          image: item['ImageUrl'],
          formattedPrice: item['Price'],
          cartPrice: priceDouble,
          originalPrice: (priceDouble * 100).round(),
          isAvailable: true,
          description: item['Calories'],
          itemUrl: item['ItemUrl'],
        );
      }).toList();

      if (subCategory != null) {
        subCategory.menuItemList = menuItems;
      } else {
        category.menuItemList = menuItems;
      }

      setState(() {});

      dynamic result = await Get.to(
        () => StoreCartScreen(
          groceryBloc: groceryBloc,
          menuItemList: subCategory?.menuItemList ?? category.menuItemList ?? [],
          categoryName: category.name ?? '',
          subCategoryName: subCategory?.name,
          storeName: widget.storeName,
          storeId: widget.storeId,
          address: widget.address,
          grocAdd: widget.grocAdd,
          groceryDetails: widget.groceryDetails,
          cartBloc: storeCartBloc,
          askOrder: widget.askOrder,
        ),
      );

      if (result == "category") {
        routing = [];
        setState(() {});
      }
    }

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    print('Error in handleCategoryTap: $e');
  }
}



  void handleBackTap() async {
    try {
      // final signalR = SignalRService();
      // await signalR.goBack();
      getSubCategory()?.subcategoryList?.clear();
      routing.removeLast();
      clearSearch();
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Category? getSubCategory() {
    try {
      Category? category;
      for (int i = 0; i < routing.length; i++) {
        if (category == null) {
          category = categoriesList[routing[i]];
        } else {
          category = category.subcategoryList?[routing[i]];
        }
      }
      return category;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchText = null;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  Widget get _separator => Column(
        children: [
          16.height,
          const Divider(
            height: 0,
            color: AppColors.lightGrey,
            thickness: 1,
          ),
          16.height,
        ],
      );
}
