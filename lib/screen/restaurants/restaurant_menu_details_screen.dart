import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/customization_header.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart'
    as opt;
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart'
    as s_opt;
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_Add_button.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/models/check_store_model.dart' as qu;
import 'model/get_user_address_model.dart' as address;
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';

class RestaurantMenuDetailsScreen extends StatefulWidget {
  const RestaurantMenuDetailsScreen({
    super.key,
    required this.data,
    required this.restaurantId,
    this.shoppingListData,
    this.resAddress,
    required this.cartCount,
    required this.pickUp,
    this.quote,
    required this.userAddress,
    this.onCustomizationChange,
  });
  final MenuItemList data;
  final String restaurantId;
  final ShoppingListData? shoppingListData;
  final Address? resAddress;
  final int cartCount;
  final bool pickUp;
  final qu.Quote? quote;
  final Function(List<Customization>)? onCustomizationChange;
  final address.UserAddress? userAddress;

  @override
  State<RestaurantMenuDetailsScreen> createState() =>
      _RestaurantMenuDetailsScreenState();
}

class _RestaurantMenuDetailsScreenState
    extends State<RestaurantMenuDetailsScreen> {
  int item = 1;
  dynamic price = 0;
  int cartCount = 0;
  bool selectFirst = false;
  bool selectSecond = false;
  bool isAddUpdate = false;
  bool customizationChange = false;
  Map<String, dynamic> selectedData = {};
  List selectedOption = [];
  List data = [];
  List addApiData = [];
  List<Map<String, dynamic>> optionsList = [];
  List<Map<String, dynamic>> nestedOptionList = [];
  List<Map<String, dynamic>> secondOptionsList = [];
  ShoppingListData? shoppingListData;
  List<Customization> customizationList = [];
  RxList<opt.Option> routingList = RxList<opt.Option>();
  // Rxn<opt.Option> routing = Rxn<opt.Option>(null);
  ScrollController controller = ScrollController();

  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool addToCart = false;
  bool isAdding = false;
  bool loading = false;

  bool alreadyInCart = false;

  getData() async {
    selectedOption.clear();
    secondOptionsList.clear();
    optionsList.clear();
    for (Customization element in customizationList) {
      selectedData.addAll({element.name!: []});
    }

    if (shoppingListData != null) {
      for (var element in shoppingListData!.options!) {
        selectedOption.add(element.optionId);
      }
    }
    item = widget.data.cartQuantity != 0 ? widget.data.cartQuantity ?? 1 : 1;
  }

  void _handleCustomization() {
    if (customizationList.isEmpty &&
        (widget.data.shouldFetchCustomizations ?? false)) {
      restaurantBloc.add(FetchCustomizationEvent(
        productId: widget.data.productId ?? "",
        pickUp: widget.pickUp,
        callback: (menu) {
          customizationList = menu.customizations ?? [];
          widget.onCustomizationChange?.call(customizationList);

          getData();
          setState(() {});
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    customizationList = widget.data.customizations ?? [];
    _handleCustomization();
    cartBloc.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: bloc.BlocConsumer<CartBloc, CartState>(
        bloc: cartBloc,
        listener: (context, state) {
          if (state is RestaurantCartState) {
            int index = state.shoppingList.indexWhere(
                (element) => element.productId == widget.data.productId);
            if (!index.isNegative) {
              alreadyInCart = true;
              ShoppingListData data = state.shoppingList[index];
              nestedOptionList = data.options
                      ?.map((e) => {
                            "option_id": e.optionId ?? '',
                            "quantity": e.quantity,
                            "marked_price": e.markedPrice,
                          })
                      .toList() ??
                  [];
              item = data.quantity ?? 1;
              cartCount = state.shoppingList.length;
            } else {
              routingList.clear();
              alreadyInCart = false;
              item = 1;
              cartCount = 0;
              nestedOptionList.clear();
            }
            setState(() {});
          }
        },
        builder: (context, state) {
          return bloc.BlocConsumer(
            bloc: restaurantBloc,
            listener: (context, state) {},
            builder: (context, state) {
              return loading == true
                  ? const Align(
                      alignment: Alignment.center,
                      child: AppCenterLoader(),
                    )
                  : SingleChildScrollView(
                      controller: controller,
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
                                padding: EdgeInsets.only(top: 30.h, left: 15.w),
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
                              // height: customizationList.isEmpty
                              //     ? size.height * 0.55
                              //     : null,
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
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
                                  bloc.BlocBuilder(
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
                                  15.height,
                                  Column(
                                    children: [
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
                                                  cartBloc.add(
                                                    ChangeQty(
                                                      productID:
                                                          widget.data.productId,
                                                      type:
                                                          ModifyType.decrement,
                                                    ),
                                                  );
                                                } else {
                                                  if (item > 0) {
                                                    item--;
                                                  }
                                                }
                                                setState(() {
                                                  addToCart = true;
                                                });
                                              },
                                              child: Container(
                                                height: size.height * 0.060,
                                                width: size.height * 0.060,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .terracotta)),
                                                child: Center(
                                                  child: widget.data
                                                              .isRemoveUpdated ==
                                                          true
                                                      ? Transform.scale(
                                                          scale: 0.5,
                                                          child:
                                                              const CircularProgressIndicator(
                                                            color: AppColors
                                                                .terracotta,
                                                          ),
                                                        )
                                                      : widget.data
                                                                  .cartQuantity ==
                                                              1
                                                          ? SvgPicture.asset(
                                                              AssetsUtils
                                                                  .icDelete,
                                                              color: AppColors
                                                                  .terracotta,
                                                            )
                                                          : const Icon(
                                                              Icons.remove,
                                                              color: AppColors
                                                                  .terracotta,
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
                                                  cartBloc.add(
                                                    ChangeQty(
                                                      productID:
                                                          widget.data.productId,
                                                      type:
                                                          ModifyType.increment,
                                                    ),
                                                  );
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
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 27,
                                                    color: AppColors.terracotta,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (alreadyInCart) ...[
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: Text(
                                            "Back to Menu",
                                            style: FontUtils.h18(
                                              fontColor: AppColors.black,
                                              fontWeight: FWT.medium,
                                            ),
                                          ),
                                        ),
                                      ],
                                      isAdding == true
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : RestaurantMealAddButtonWidget(
                                              onTap: () {
                                                if (!alreadyInCart) {
                                                  addIntoTheCart();
                                                } else {
                                                  Get.to(
                                                    () => RestaurantCart(
                                                      pickUp: widget.pickUp,
                                                      userAddress:
                                                          widget.userAddress,
                                                    ),
                                                    transition:
                                                        Transition.fadeIn,
                                                  );
                                                }
                                              },
                                              buttonLable: alreadyInCart
                                                  ? 'View Cart'
                                                  : 'Add to cart',
                                              isFillColor: true,
                                              selectedItemCount:
                                                  alreadyInCart ? cartCount : 0,
                                            ),
                                      const SizedBox(height: 5),
                                      Center(
                                        child: Image.asset(
                                          AssetsUtils.gymEatsSpoon,
                                          height: 22.h,
                                          width: 56.w,
                                          color: AppColors.terracotta,
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                    ],
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
    );
  }

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
                        // ! Add For Nested Item
                        // if (routingList.isNotEmpty)
                        //   ...csList.map((e) {
                        //     return Column(
                        //       children: [
                        //         NestedCustomizationHeader(
                        //           customization: e,
                        //           style: FontUtils.h16(
                        //             fontColor: Colors.black,
                        //             fontWeight: FWT.medium,
                        //           ),
                        //         ).paddingOnly(left: 5, right: 5),
                        //         15.height,
                        //         expandableTile(e, parent: parent)
                        //             .paddingOnly(left: 20, right: 5),
                        //       ],
                        //     );
                        //   }).toList(),
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
          _animateToTop();
        } else {
          if (!alreadyInCart) {
            onTileTap(cs, option, parent: parent, setRouting: setRouting);
          } else {
            showToast(
              isSuccess: false,
              color: AppColors.black,
              message: StringUtils.productAlreadyInCart,
            );
          }
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
                  message: StringUtils.productAlreadyInCart,
                );
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
        _animateToTop();
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

  void _animateToTop() {
    controller.animateTo(0,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeInOut);
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

      if (requiredOptions.isNotEmpty) {
        log("${cList[i].name}:-------Required Option---------${requiredOptions.map((e) => e.name).toList()}");
      }

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
        cartBloc.add(
          AddCartEvent(
            shoppingItem: ShoppingListData(
              userId: userId,
              productId: widget.data.productId ?? '',
              productName: widget.data.name ?? '',
              quantity: item,
              price: price,
              originalPrice: widget.data.originalPrice,
              options: nestedOptionList
                  .map((e) => s_opt.Option(
                        optionId: e["option_id"],
                        quantity: e["quantity"],
                        markedPrice: e["marked_price"],
                      ))
                  .toList(),
              mealmeStoreId: widget.restaurantId,
              productType: 'Restaurant',
              isChecked: false,
              recipeId: '',
              unitOfMeasurement: '',
              unitSize: 0,
              brandName: '',
              orderMin: widget.quote?.orderMinimum,
              orderMax: widget.quote?.orderMaximum,
              resAddress: widget.resAddress,
            ),
          ),
        );
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
