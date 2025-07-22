import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/bloc/store_cart_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/details_view/store_meal_details.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/details_view/store_menu_details_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/store_checkout_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/check_list_sheet.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/custom_search_field.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/product_card_widget.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/bottomsheet/item_catalog_sort_by_bottomsheet.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user_address;
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart'
    as groc_add;
import 'package:gymeats_mobile/service/signalr_service.dart';

class StoreCartScreen extends StatefulWidget {
  final List<MenuItemList>? menuItemList;
  final GroceryBloc groceryBloc;
  final StoreCartBloc cartBloc;
  final String? categoryName;
  final String? subCategoryName;
  final String? storeName;
  final String? storeId;
  final user_address.UserAddress? address;
  final groc_add.Address? grocAdd;
  final List<GroceryDetails>? groceryDetails;
  final AskReceiveOrder? askOrder;
  
  const StoreCartScreen({
    super.key,
    required this.cartBloc,
    this.menuItemList = const [],
    required this.groceryBloc,
    this.categoryName,
    this.subCategoryName = null,
    this.storeName,
    this.storeId,
    this.address,
    this.grocAdd,
    this.groceryDetails,
    this.askOrder,
  });

  @override
  State<StoreCartScreen> createState() => _StoreCartScreenState();
}

class _StoreCartScreenState extends State<StoreCartScreen> {
  List<Product> groceryResult = [];
  List<Product> filterResult = [];
  List<MenuItemList> menuItemList = [];
  List<MenuItemList> cartMenuList = [];
  bool _isGoingBack = false;

  List<MenuItemList> filterItem = [];

  List<Product> groceryTempResult = [];
  bool isProductSelect = false;
  bool isFilter = false;
  String? selectedSorting;
  TextEditingController searchController = TextEditingController();
  String? searchText;
  AddNewGroceryItemBloc groceryItemBloc = AddNewGroceryItemBloc();
  late StoreCartBloc cartBloc;
  bool _isFetchingMore = false;
  bool isLoadingMenu = false;
  int currentMenuPage = 0;

  @override
  void initState() {
    menuItemList = (jsonDecode(jsonEncode(widget.menuItemList)) as List)
        .map((e) => MenuItemList.fromJson(e))
        .toList();

    cartBloc = widget.cartBloc;
    cartBloc.add(GetGroceryCartList());
    groceryItemBloc.add(GetGroceryItemEvent());
    super.initState();
  }

  void sortingData() {
    print('SORTING DATA');
    if (selectedSorting == 'Cheapest first') {
      menuItemList.sort((a, b) => a.originalPrice!.compareTo(b.originalPrice!));
      setState(() {});
    } else if (selectedSorting == 'Expensive') {
      menuItemList.sort((a, b) => b.originalPrice!.compareTo(a.originalPrice!));
      setState(() {});
    }
  }

  RangeValues? priceRange;

  bool isCreateOrder = false;

  Future<void> loadNewMenuItems() async {
  if (isLoadingMenu) return;
  isLoadingMenu = true;

  try {
    print("Starting to load new menu items...");
    final signalR = SignalRService();

    print("Calling getMenuItems with:");
    print("   - category: ${widget.categoryName}");
    print("   - subcategory: ${widget.subCategoryName}");
    print("   - page: $currentMenuPage");

    final List<dynamic>? result = await signalR.getMenuItems(
      widget.categoryName!,
      widget.subCategoryName,
      currentMenuPage,
      false,
    );

    print('Response received');
    print(result);

    if (result != null && result.isNotEmpty) {
      final newItems = result.map<MenuItemList>((item) {
        final priceString = item['Price']?.replaceAll('\$', '').trim();
        final priceDouble = double.tryParse(priceString ?? '') ?? 0.0;

        final newItem = MenuItemList(
          name: item['Name'] ?? '',
          image: item['ImageUrl'],
          formattedPrice: item['Price'],
          cartPrice: priceDouble,
          isAvailable: true,
          description: item['Calories'],
          itemUrl: item['ItemUrl'],
          productId: item['ProductId'],
        );

        final inCart = cartMenuList.firstWhereOrNull(
          (e) => e.name?.toLowerCase().trim() == newItem.name!.toLowerCase().trim(),
        );

        if (inCart != null) {
          newItem.cartQuantity = inCart.cartQuantity;
          newItem.selectedOptions = inCart.selectedOptions;
          newItem.customizations = inCart.customizations;
        }

        return newItem;
      }).toList();

      final existingNames = menuItemList
          .map((e) => e.name?.toLowerCase().trim())
          .toSet();

      final filteredNewItems = <MenuItemList>[];

      for (final item in newItems) {
        final itemName = item.name!.toLowerCase().trim();
        if (existingNames.contains(itemName)) {
          print("✅ Already in menuItemList: $itemName");
        } else {
          print("➕ New to menuItemList: $itemName");
          filteredNewItems.add(item);
        }
      }

      if (filteredNewItems.isNotEmpty) {
        print("🟢 Adding ${filteredNewItems.length} new items to menuItemList");

        setState(() {
          cartMenuList.addAll(filteredNewItems);
          menuItemList.addAll(filteredNewItems);
          currentMenuPage++;
        });
      } else {
        print("ℹ️ No new items to add");
      }
    } else {
      print("ℹ️ No new menu items received");
    }
  } catch (e, st) {
    print("❌ Error loading more menu items: $e");
    print("📍 Stack trace:\n$st");
  } finally {
    isLoadingMenu = false;
  }
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: bloc.BlocConsumer<StoreCartBloc, StoreCartState>(
        bloc: widget.cartBloc,
        listener: (context, state) {
          if (state is StoreCheckoutState) {
            cartMenuList = state.menuItemList;
            setState(() {});
          }
        },
        builder: (context, state) {
          return Scaffold(
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
                    children: [
                      const BackButtonWidget(),
                      Expanded(
                        child: Text(
                          widget.categoryName ?? 'Almond milk',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontUtils.h20(
                            fontColor: AppColors.oxFF010101,
                            fontWeight: FWT.medium,
                          ),
                        ),
                      ),
                      10.width,
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.transparentColor,
                          isScrollControlled: true,
                          builder: (context) {
                            return CheckListSheet(
                                groceryDetails: widget.groceryDetails);
                          },
                          isDismissible: false,
                        ),
                        child: SvgPicture.asset(AssetsUtils.icList),
                      ),
                    ],
                  ).paddingOnly(left: 14, right: 14),
                  16.height,
                  // CustomSearchField(
                  //   onChange: (p0) => setState(() => searchText = p0),
                  //   controller: searchController,
                  // ).paddingOnly(left: 14, right: 14),
                  16.height,
                  Row(
                    children: [
                      _isGoingBack
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : myFilterView(
                        AssetsUtils.icListIcon,
                        'Category',
                        () async {
                          if (_isGoingBack) return;
                          setState(() => _isGoingBack = true);

                          final signalR = SignalRService();
                          try {
                            signalR.goBack();
                            Get.back(result: "category");
                          } catch (e) {
                          } finally {
                            if (mounted) setState(() => _isGoingBack = false);
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      myFilterView(
                        AssetsUtils.icFilterIcon,
                        'Sort & Filter',
                        () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.transparentColor,
                            builder: (context) {
                              return ItemCatalogSortByBottomSheet(
                                selectedSort: selectedSorting,
                                rangeValues: priceRange,
                              );
                            },
                            isDismissible: false,
                          ).then(
                            (value) {
                              if (value != null) {
                                if (value["value"] != null) {
                                  selectedSorting = value["value"];
                                  setState(() {});
                                  sortingData();
                                }

                                priceRange = value['priceRange'];
                                isFilter = value['isFilter'];

                                filterResult.clear();

                                if (isFilter) {
                                  for (var element in groceryResult) {
                                    double value = double.parse(
                                        (element.formattedPrice ?? '0')
                                            .replaceAll("\$", "")
                                            .trim());
                                    if ((value) > priceRange!.start &&
                                        (value) < priceRange!.end) {
                                      filterResult.add(element);
                                    }
                                  }
                                }
                                setState(() {});
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ).paddingOnly(left: 20, right: 20),
                  16.height,
                  const Divider(
                      color: AppColors.lightGrey, thickness: 1, height: 0),
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        filterItem =
                            List<MenuItemList>.from(menuItemList)
                                .where((element) =>
                                    element.name?.toLowerCase().contains(
                                        searchText?.toLowerCase() ?? "") ??
                                    false)
                                .toList();

                        if (priceRange != null) {
                          filterItem = filterItem.where((element) {
                            double value = double.parse(
                                (element.formattedPrice ?? '0')
                                    .replaceAll("\$", "")
                                    .trim());

                            return (value) > priceRange!.start &&
                                (value) < priceRange!.end;
                          }).toList();
                        }

                        return filterItem.isEmpty
                            ? Center(
                                child: Text(
                                  'Grocery not found for $searchText!',
                                  textAlign: TextAlign.center,
                                  style:
                                      FontUtils.h16(fontColor: AppColors.black),
                                ),
                              )
                            : NotificationListener<ScrollNotification>(
                                onNotification: (ScrollNotification scrollInfo) {
                                  if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
                                      !_isFetchingMore && !isLoadingMenu) {
                                    setState(() {
                                      _isFetchingMore = true;
                                    });

                                    loadNewMenuItems().then((_) {
                                      Future.delayed(const Duration(milliseconds: 1500), () {
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  children: [
                                    ListView.separated(
                                      itemCount: filterItem.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.fromLTRB(0, 28, 0, 28),
                                      separatorBuilder: (_, __) => Column(
                                        children: [
                                          16.height,
                                          const Divider(
                                            color: AppColors.lightGrey,
                                            thickness: 1,
                                            height: 0,
                                          ),
                                          16.height,
                                        ],
                                      ),
                                      itemBuilder: (_, index) {
                                        final item = filterItem[index];
                                        final splitItemName = item.name
                                                ?.toLowerCase()
                                                .replaceAll(",", " ")
                                                .split(" ") ??
                                            [];

                                        final i = widget.groceryDetails?.indexWhere((e) =>
                                                !(e.itemName
                                                        ?.toLowerCase()
                                                        .split(" ")
                                                        .any((element) => !splitItemName.contains(element)) ??
                                                    true)) ??
                                            -1;

                                        final cartMenu = cartMenuList.firstWhereOrNull(
                                            (element) => element.productId == item.productId);

                                        return ProductCardWidget(
                                          categoryName: !i.isNegative
                                              ? (widget.groceryDetails?[i].itemName ?? "")
                                              : "",
                                          cartItem: cartMenu,
                                          menuItem: item,
                                          showDiscount: false,
                                          storeName: widget.storeName,
                                          qty: item.cartQuantity,
                                          isGroceryItem: !i.isNegative,
                                          showQuantity: false,
                                          onTap: () async {
                                            Get.to(
                                              () => StoreMealDetails(
                                                data: item,
                                                cartBloc: widget.cartBloc,
                                                storeId: widget.storeId ?? "",
                                                shoppingListData: null,
                                                cartCount: item.cartQuantity ?? 0,
                                                grocAdd: widget.grocAdd,
                                                pickUp: widget.askOrder == AskReceiveOrder.pickMySelf,
                                                matchMealStatus: null,
                                                onAddToCart: (p0, qty) {
                                                  item.cartQuantity = qty;
                                                  item.selectedOptions = p0
                                                      .map(
                                                        (e) => SelectedOptions(
                                                          markedPrice: e["marked_price"],
                                                          optionId: e["option_id"],
                                                          quantity: e["quantity"],
                                                        ),
                                                      )
                                                      .toList();
                                                  setState(() {});
                                                  widget.cartBloc.add(ModifyCart(menuItemList: filterItem));
                                                  final signalR = SignalRService();
                                                  signalR.goBack();
                                                  Get.back();
                                                },
                                                fromGrocery: true,
                                                onCustomizationChange: (p0) {
                                                  item.customizations = p0;
                                                  setState(() {});
                                                },
                                              ),
                                              transition: Transition.fadeIn,
                                            );
                                          },
                                          onCartTap: () {
                                            Get.to(
                                              () => StoreMenuDetailsScreen(
                                                data: item,
                                                cartBloc: widget.cartBloc,
                                                restaurantId: widget.storeId ?? "",
                                                cartCount: item.cartQuantity ?? 1,
                                                pickUp: widget.askOrder == AskReceiveOrder.pickMySelf,
                                                grocAdd: widget.grocAdd,
                                                options: item.selectedOptions?.map((e) => e.toJson()).toList() ?? [],
                                                onCustomizationChange: (p0) {
                                                  item.customizations = p0;
                                                  setState(() {});
                                                },
                                              ),
                                            );
                                          },
                                          onAdd: () => cartBloc.add(ChangeGroceryQty(
                                            productID: item.productId,
                                            type: ModifyType.decrement,
                                          )),
                                          onRemove: () => cartBloc.add(ChangeGroceryQty(
                                            productID: item.productId,
                                            type: ModifyType.increment,
                                          )),
                                        );
                                      },
                                    ),

                                    if (isLoadingMenu) ...[
                                      const SizedBox(height: 16),
                                      const Center(child: CircularProgressIndicator()),
                                      const SizedBox(height: 16),
                                    ],
                                  ],
                                ),
                              );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: (cartBloc.state is StoreCheckoutState &&
                            (cartBloc.state as StoreCheckoutState).menuItemList.isNotEmpty)
                        ? simpleTextBorderButton(
                            context: context,
                            color: AppColors.green,
                            buttonLable: 'View Cart',
                            height: context.height * 0.065,
                            width: context.width,
                            isLoadingWidget: false,
                            onTap: () async {
                              await Get.to(
                                () => StoreCheckOutScreen(
                                  storeCartBloc: widget.cartBloc,
                                  address: widget.address,
                                  storeName: widget.storeName,
                                  groceryDetails: widget.groceryDetails,
                                  askOrder: widget.askOrder,
                                  grocAdd: widget.grocAdd,
                                ),
                              );
                              setState(() {});
                            },
                            isDarkColor: true,
                            isFillColor: true,
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget myFilterView(String icon, String title, VoidCallback onTap,
      [int? count]) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          decoration: BoxDecoration(
            color: AppColors.mint,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, color: AppColors.green),
              const SizedBox(width: 10),
              Text(
                title,
                style: FontUtils.h18(
                  fontColor: AppColors.green,
                  fontWeight: FWT.medium,
                ),
              ),
              const SizedBox(width: 10),
              if (count != null)
                CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.greenPressed,
                  child: Text(
                    "$count",
                    style: FontUtils.h12(
                      fontColor: AppColors.whiteColor,
                      fontWeight: FWT.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
