import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/bloc/store_cart_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/customization_header.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart'
    as opt;
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_Add_button.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class StoreMenuDetailsScreen extends StatefulWidget {
  const StoreMenuDetailsScreen({
    super.key,
    required this.cartBloc,
    required this.data,
    required this.restaurantId,
    this.shoppingListData,
    required this.cartCount,
    required this.pickUp,
    this.onCustomizationChange,
    this.options,
    this.onAddToCart,
  });
  final StoreCartBloc cartBloc;
  final MenuItemList data;
  final String restaurantId;
  final ShoppingListData? shoppingListData;
  final int cartCount;
  final bool pickUp;
  final List<Map<String, dynamic>>? options;
  final Function(List<Customization>)? onCustomizationChange;
  final Function(List<Map<String, dynamic>>, int qty)? onAddToCart;

  @override
  State<StoreMenuDetailsScreen> createState() => _StoreMenuDetailsScreenState();
}

class _StoreMenuDetailsScreenState extends State<StoreMenuDetailsScreen> {
  int item = 0;
  dynamic price = 0;
  int cartCount = 0;
  bool selectFirst = false;
  bool selectSecond = false;
  bool isAddUpdate = false;
  bool customizationChange = false;
  bool alreadyInCart = false;
  Map<String, dynamic> selectedData = {};
  List selectedOption = [];
  List data = [];
  List addApiData = [];
  List<Map<String, dynamic>> optionsList = [];
  List<Map<String, dynamic>> secondOptionsList = [];
  ShoppingListData? shoppingListData;
  List<Customization> customizationList = [];
  List<MenuItemList> cartMenuList = [];

  RxList<opt.Option> routingList = RxList<opt.Option>();
  List<Map<String, dynamic>> nestedOptionList = [];

  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool addToCart = false;
  bool isAdding = false;
  bool loading = false;

  getData() async {
    selectedOption.clear();
    secondOptionsList.clear();
    optionsList.clear();
    for (Customization element in customizationList) {
      selectedData.addAll(
        {
          element.name!: [],
          'isRequired': element.minChoiceOptions,
        },
      );
    }
    if (shoppingListData != null) {
      for (var element in shoppingListData!.options!) {
        selectedOption.add(element.optionId);
      }
    }
    item = widget.data.cartQuantity ?? 0;
    optionsList = widget.options ?? [];
  }

  void _handleCustomization() {
    if (customizationList.isEmpty &&
        (widget.data.shouldFetchCustomizations ?? false)) {
      restaurantBloc.add(ProductCustomizationEvent(
        productId: widget.data.productId ?? "",
        callback: (menu) {
          customizationList = menu.customizations ?? [];
          widget.onCustomizationChange?.call(customizationList);
          getData();
          if (mounted) {
            setState(() {});
          }
          log(customizationList.length.toString());
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    shoppingListData = widget.shoppingListData;
    cartCount = widget.cartCount;
    customizationList = widget.data.customizations ?? [];
    getData();
    _handleCustomization();
    widget.cartBloc.add(GetGroceryCartList());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        body: BlocConsumer<StoreCartBloc, StoreCartState>(
          bloc: widget.cartBloc,
          listener: (context, state) {
            if (state is StoreCheckoutState) {
              cartMenuList = state.menuItemList;
              int index = cartMenuList.indexWhere(
                  (element) => element.productId == widget.data.productId);

              if (!index.isNegative) {
                alreadyInCart = true;
                MenuItemList data = cartMenuList[index];
                nestedOptionList = data.selectedOptions
                        ?.map((e) => {
                              "option_id": e.optionId ?? '',
                              "quantity": e.quantity,
                              "marked_price": e.markedPrice,
                            })
                        .toList() ??
                    [];
                item = data.cartQuantity ?? 0;
                cartCount = cartMenuList.length;
              } else {
                routingList.clear();
                alreadyInCart = false;
                item = 0;
                cartCount = 0;
                nestedOptionList.clear();
              }
            }
          },
          builder: (context, state) {
            MenuItemList? cartMenu = cartMenuList.firstWhereOrNull(
                (element) => element.productId == widget.data.productId);

            return BlocConsumer(
              bloc: restaurantBloc,
              listener: (context, state) {},
              builder: (context, state) {
                return loading == true
                    ? const Align(
                        alignment: Alignment.center,
                        child: AppCenterLoader(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: size.height * 0.45,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: widget.data.image == null ||
                                        widget.data.image!.isEmpty
                                    ? const DecorationImage(
                                        image: AssetImage(AssetsUtils.food3),
                                        fit: BoxFit.cover)
                                    : DecorationImage(
                                        image: NetworkImage(widget.data.image!),
                                        fit: BoxFit.cover),
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 30.h, left: 15.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.back(result: addToCart);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: SizedBox(
                                width: context.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.data.name ?? "",
                                      style: FontUtils.h24(
                                        fontColor: Colors.black,
                                        fontWeight: FWT.medium,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Text(
                                        widget.data.formattedPrice ?? "",
                                        style: FontUtils.h18(
                                          fontColor: Colors.black,
                                          fontWeight: FWT.medium,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 10.w, bottom: 10.h),
                                      child: Text(
                                        widget.data.description ?? '',
                                        style: FontUtils.h14(
                                          fontColor: const Color(0xffA2A4A7),
                                          fontWeight: FWT.lightMedium,
                                        ),
                                      ),
                                    ),
                                    BlocBuilder(
                                      bloc: restaurantBloc,
                                      builder: (context, state) {
                                        return state
                                                is FetchCustomizationLoaderState
                                            ? const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  AppCenterLoader(),
                                                ],
                                              ).paddingOnly(top: 20, bottom: 20)
                                            : const SizedBox.shrink();
                                      },
                                    ),
                                    customizationList.isEmpty
                                        ? const SizedBox()
                                        : nestedItemView(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 18),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (alreadyInCart) {
                                                cartMenu?.cartQuantity =
                                                    (cartMenu.cartQuantity ??
                                                            0) -
                                                        1;
                                                widget.cartBloc.add(ModifyCart(
                                                    menuItemList:
                                                        cartMenuList));
                                              } else {
                                                if (item > 0) {
                                                  item--;
                                                }
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: size.height * 0.060,
                                              width: size.height * 0.060,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: AppColors
                                                          .terracotta)),
                                              child: Center(
                                                child: item == 1
                                                    ? SvgPicture.asset(
                                                        AssetsUtils.icDelete,
                                                        color: AppColors
                                                            .terracotta,
                                                      )
                                                    : const Icon(
                                                        Icons.remove,
                                                        color: AppColors
                                                            .terracotta,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Container(
                                            height: size.height * 0.060,
                                            width: size.height * 0.060,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.disable),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Center(
                                                child: Text(
                                              '$item',
                                              style: FontUtils.h18(
                                                  fontWeight: FWT.semiBold,
                                                  fontColor:
                                                      AppColors.darkGray),
                                            )),
                                          ),
                                          SizedBox(width: 8.w),
                                          GestureDetector(
                                            onTap: () {
                                              if (alreadyInCart) {
                                                cartMenu?.cartQuantity =
                                                    (cartMenu.cartQuantity ??
                                                            0) +
                                                        1;
                                                widget.cartBloc.add(ModifyCart(
                                                    menuItemList:
                                                        cartMenuList));
                                              } else {
                                                item++;
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                              height: size.height * 0.060,
                                              width: size.height * 0.060,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: AppColors.coral,
                                              ),
                                              child: Center(
                                                child: widget.data
                                                            .isAddUpdated ==
                                                        true
                                                    ? Transform.scale(
                                                        scale: 0.5,
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color: AppColors
                                                              .terracotta,
                                                        ))
                                                    : const Icon(
                                                        Icons.add,
                                                        size: 27,
                                                        color: AppColors
                                                            .terracotta,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RestaurantMealAddButtonWidget(
                                      onTap: () {
                                        if (!alreadyInCart) {
                                          addIntoTheCart();
                                        } else {
                                          Get.back();
                                        }
                                      },
                                      buttonLable: cartMenu != null
                                          ? 'View Cart'
                                          : 'Add to cart',
                                      isFillColor: true,
                                      selectedItemCount: cartMenu != null
                                          ? cartMenuList.length
                                          : 0,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Image.asset(
                                        AssetsUtils.gymEatsSpoon,
                                        height: 22.h,
                                        width: 56.w,
                                        color: AppColors.terracotta,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }

  // ! New Flow

  Widget nestedItemView() {
    return Obx(
      () => routingList.isEmpty
          ? Column(
              children: List.generate(
                customizationList.length,
                (index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    child: Column(
                      children: [
                        CustomizationHeader(
                            customization: customizationList[index]),
                        16.h.height,
                        expandableTile(customizationList[index],
                            parent: customizationList[index]),
                      ],
                    ),
                  );
                },
              ),
            )
          : Builder(
              builder: (context) {
                opt.Option routing = routingList.last;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    routing.customizations?.length ?? 0,
                    (index) {
                      List<Customization> routeCs =
                          routing.customizations ?? [];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        child: Column(
                          children: [
                            CustomizationHeader(
                              customization: routeCs[index],
                              setBackButton: index == 0 ? true : false,
                              parentTitle: routing.name,
                              onBack: () {
                                routingList.removeLast();
                                // routing.value = null;
                              },
                            ),
                            16.h.height,
                            nestedView(routeCs[index], parent: routeCs[index]),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget expandableTile(Customization customization,
      {required Customization parent}) {
    List<opt.Option> options = customization.options ?? [];

    return Column(
      children: List<Widget>.generate(
        options.length,
        (index1) {
          opt.Option currentOpt = options[index1];
          List<Customization> csList = currentOpt.customizations ?? [];
          bool isLastRecord = index1 < options.length - 1;
          return csList.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xffECECED), width: 1.2),
                  ),
                  child: Builder(builder: (context) {
                    return Column(
                      children: <Widget>[
                        normalTile(customization, currentOpt,
                            showRadioButton: false, parent: parent),
                      ].addBetweenItems(15.height),
                    );
                  }),
                )
              : Column(
                  children: [
                    normalTile(customization, currentOpt, parent: parent)
                        .paddingOnly(bottom: isLastRecord ? 15 : 0),
                    if (isLastRecord)
                      Container(
                        height: 1,
                        color: AppColors.lightGrey,
                      ).paddingOnly(bottom: 15),
                  ],
                );
        },
      ),
    );
  }

  Widget nestedView(Customization customization,
      {required Customization parent}) {
    List<opt.Option> options = customization.options ?? [];

    return Column(
      children: List<Widget>.generate(
        options.length,
        (index1) {
          opt.Option currentOpt = options[index1];
          List<Customization> csList = currentOpt.customizations ?? [];
          bool isLastRecord = index1 < options.length - 1;
          return csList.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xffECECED), width: 1.2),
                  ),
                  child: Column(
                    children: <Widget>[
                      normalTile(customization, currentOpt,
                          showRadioButton: false,
                          parent: parent,
                          setRouting: false),
                      ...csList.map((e) {
                        return Column(
                          children: [
                            NestedCustomizationHeader(
                              customization: e,
                              style: FontUtils.h16(
                                fontColor: Colors.black,
                                fontWeight: FWT.medium,
                              ),
                            ).paddingOnly(left: 5, right: 5),
                            15.height,
                            expandableTile(e, parent: parent)
                                .paddingOnly(left: 20, right: 5),
                          ],
                        );
                      }).toList(),
                    ].addBetweenItems(15.height),
                  ),
                )
              : Column(
                  children: [
                    normalTile(customization, currentOpt,
                            parent: parent, setRouting: false)
                        .paddingOnly(bottom: isLastRecord ? 15 : 0),
                    if (isLastRecord)
                      Container(
                        height: 1,
                        color: AppColors.lightGrey,
                      ).paddingOnly(bottom: 15),
                  ],
                );
        },
      ),
    );
  }

  Widget normalTile(Customization cs, opt.Option option,
      {bool showRadioButton = true,
      required Customization parent,
      bool setRouting = true}) {
    bool isOptionRequired = option.isRequired ?? false;
    return GestureDetector(
      onTap: () {
        bool isSelected = nestedOptionList
            .any((element) => element["option_id"] == option.optionId);
        if (cs.name == parent.name &&
            setRouting &&
            (option.customizations?.isNotEmpty ?? false) &&
            isSelected) {
          routingList.add(option);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (!alreadyInCart) {
                onTileTap(cs, option, parent: parent, setRouting: setRouting);
              } else {
                showToast(
                    isSuccess: false,
                    color: AppColors.black,
                    message:
                        "This product is already in the cart and cannot be modified.");
              }
            },
            child: Image.asset(
              nestedOptionList
                      .any((element) => element["option_id"] == option.optionId)
                  ? AssetsUtils.terracotaCheck
                  : AssetsUtils.greyCircle,
              height: 18.h,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: option.name ?? '',
                style: FontUtils.h15(
                  fontColor: Colors.black,
                  fontWeight: FWT.lightMedium,
                ),
                children: isOptionRequired
                    ? <InlineSpan>[
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: SizedBox(width: 10),
                        ),
                        TextSpan(
                          text: "Required",
                          style: FontUtils.h12(
                            fontColor: AppColors.terracotta,
                            fontWeight: FWT.medium,
                          ),
                        )
                      ]
                    : [],
              ),
            ),
          ),
          10.width,
          Text(
            option.formattedPrice ?? '',
            style: const TextStyle(color: Colors.black),
          )
        ],
      ).paddingOnly(left: 15, right: 15),
    );
  }

  void onTileTap(Customization cs, opt.Option option,
      {required Customization parent, bool setRouting = true}) {
    setState(() {
      if (nestedOptionList
          .any((element) => element["option_id"] == option.optionId)) {
        nestedOptionList
            .removeWhere((element) => element["option_id"] == option.optionId);
        removeOptions(option);
        return;
      }
      if (setRouting && (option.customizations?.isNotEmpty ?? false)) {
        routingList.add(option);
      }
      findOptionPath(parent, option);
      removeIfNotValidate(cs);

      nestedOptionList.add({
        "option_id": option.optionId ?? '',
        "quantity": 1,
        "marked_price": option.price,
      });
    });
  }

  bool isFormValid(List<Customization> cList) {
    for (var i = 0; i < cList.length; i++) {
      int count = nestedOptionList
          .where((e) => cList.any((element) =>
              cList[i].options?.any((k) => k.optionId == e["option_id"]) ??
              false))
          .toList()
          .length;

      List<opt.Option> requiredOptions = cList[i]
              .options
              ?.where((element) => element.isRequired ?? false)
              .toList() ??
          [];

      bool requiredOptionNotSelected = requiredOptions.isNotEmpty &&
          !requiredOptions.every((element) =>
              nestedOptionList.any((e) => e["option_id"] == element.optionId));

      List<opt.Option> validOptionList = cList[i]
              .options
              ?.where((element) => nestedOptionList
                  .any((e) => e["option_id"] == element.optionId))
              .toList() ??
          [];

      if ((count < (cList[i].minChoiceOptions ?? 0)) ||
          requiredOptionNotSelected) {
        return false;
      }

      if (cList[i].options?.isNotEmpty ?? false) {
        for (opt.Option ele in validOptionList) {
          if (!isFormValid(ele.customizations ?? [])) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void removeIfNotValidate(Customization cs) {
    List<String> optionsIds =
        cs.options?.map((e) => e.optionId ?? "").toList() ?? [];
    int count = nestedOptionList
        .where((element) => optionsIds.contains(element["option_id"]))
        .toList()
        .length;

    if (!(count < (cs.maxChoiceOptions ?? 1))) {
      int index = nestedOptionList
          .indexWhere((element) => optionsIds.contains(element["option_id"]));
      if (index.isNegative) {
        return;
      }
      (bool, opt.Option?) newOpt =
          findOption(cs, nestedOptionList[index]["option_id"]);
      if (newOpt.$2 != null) {
        removeOptions(newOpt.$2!);
      }
      nestedOptionList.removeAt(index);
    }
  }

  bool findOptionPath(Customization customization, opt.Option findOption) {
    if (customization.options != null) {
      for (opt.Option option in customization.options!) {
        if (option.optionId == findOption.optionId) {
          return true;
        }
        if (option.customizations != null) {
          for (Customization subCustomization in option.customizations!) {
            if (findOptionPath(subCustomization, findOption)) {
              if (!nestedOptionList
                  .any((element) => element["option_id"] == option.optionId)) {
                removeIfNotValidate(customization);
                nestedOptionList.add({
                  "option_id": option.optionId ?? '',
                  "quantity": 1,
                  "marked_price": option.price
                });
              }
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  void removeOptions(opt.Option option) {
    if (option.customizations != null) {
      for (Customization subCustomization in option.customizations!) {
        for (opt.Option element in (subCustomization.options ?? [])) {
          nestedOptionList
              .removeWhere((e) => e["option_id"] == element.optionId);
          removeOptions(element);
        }
      }
    }
  }

  (bool, opt.Option?) findOption(Customization customization, String optionId) {
    if (customization.options != null) {
      for (opt.Option option in customization.options!) {
        if (option.optionId == optionId) {
          return (true, option);
        }
        if (option.customizations != null) {
          for (Customization subCustomization in option.customizations!) {
            if (findOption(subCustomization, optionId).$1) {
              return (true, option);
            }
          }
        }
      }
    }
    return (false, null);
  }

  void setTotalPrice() {
    price = widget.data.originalPrice;
    for (var element in nestedOptionList) {
      price = price + element['marked_price'];
    }
    price = price * item;
  }

  void addIntoTheCart() {
    if (item > 0) {
      bool valid = isFormValid(customizationList);
      if (valid) {
        setTotalPrice();
        MenuItemList menuItem = widget.data;
        menuItem
          ..cartQuantity = item
          ..totalPrice = price;
        menuItem.selectedOptions = nestedOptionList
            .map(
              (e) => SelectedOptions(
                optionId: e["option_id"],
                quantity: e["quantity"],
                markedPrice: e["marked_price"],
              ),
            )
            .toList();
        cartMenuList.add(menuItem);
        widget.cartBloc.add(ModifyCart(menuItemList: cartMenuList));
      } else {
        showToast(
          message: 'Please Select Required Item',
          isSuccess: false,
          color: AppColors.black,
        );
      }
    } else {
      showToast(
        message: 'Please Select One Item',
        isSuccess: false,
        color: AppColors.black,
      );
    }
  }
}
