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
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart'
    as groc_add;
import 'dart:convert';
import 'package:gymeats_mobile/service/signalr_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreMenuDetailsScreen extends StatefulWidget {
  const StoreMenuDetailsScreen({
    super.key,
    required this.cartBloc,
    required this.data,
    required this.restaurantId,
    this.shoppingListData,
    required this.cartCount,
    this.grocAdd,
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
  final groc_add.Address? grocAdd;
  final bool pickUp;
  final List<Map<String, dynamic>>? options;
  final Function(List<Customization>)? onCustomizationChange;
  final Function(List<Map<String, dynamic>>, int qty)? onAddToCart;

  @override
  State<StoreMenuDetailsScreen> createState() => _StoreMenuDetailsScreenState();
}

class _StoreMenuDetailsScreenState extends State<StoreMenuDetailsScreen> {
  int item = 1;
  dynamic price = 0;
  int cartCount = 1;
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
  bool _isLoadingCustomization = false;

  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool addToCart = false;
  bool isAdding = false;
  bool loading = false;
  bool isGoingBack = false;

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
    item = (widget.data.cartQuantity != null && widget.data.cartQuantity! > 0)
    ? widget.data.cartQuantity!
    : 1;
    optionsList = widget.options ?? [];
  }

  @override
  void initState() {
    super.initState();
    shoppingListData = widget.shoppingListData;
    cartCount = widget.cartCount == 0 ? 1 : widget.cartCount;
    print('Cart Count : $cartCount');
    customizationList = widget.data.customizations ?? [];
    getData();
    _handleCustomization();
    widget.cartBloc.add(GetGroceryCartList());
  }

  Future<void> _handleCustomization() async {
    final prefs = await SharedPreferences.getInstance();

    final signalRItem = {
      "Name": widget.data.name,
      "ImageUrl": widget.data.image,
      "Price": widget.data.formattedPrice,
      "Calories": widget.data.description,
      "ItemUrl": widget.data.itemUrl,
    };

    final jsonString = jsonEncode(signalRItem);

    setState(() {
      _isLoadingCustomization = true;
    });

    final signalR = SignalRService();
    List<dynamic>? signalRResult;

    final isCartOpened = prefs.getBool('cart-opened') ?? false;
    if (isCartOpened) {
      await signalR.CloseViewCart();
      await prefs.setBool('cart-opened', false);
    }

    try {
      signalRResult = await signalR.getCustomization(jsonString);
    } catch (_) {
      setState(() {
        _isLoadingCustomization = false;
      });
      return;
    }

    setState(() {
      _isLoadingCustomization = false;
    });

    if (signalRResult != null && signalRResult.isNotEmpty) {
      List<Customization> parsedCustomizations = [];

      try {
        parsedCustomizations = signalRResult.map<Customization>((item) {
          final String? header = item['Header'];
          final bool isRequired = item['IsRequired'] ?? false;
          final bool isManySelectionAllowed = item['IsManySelectionAllowed'] ?? false;

          final List<opt.Option> options =
              (item['Items'] as List).map<opt.Option>((optItem) {
            final String name = optItem['Name'] ?? '';
            final String priceString = optItem['Price'] ?? '';
            final int price = 0;

            return opt.Option(
              name: name,
              formattedPrice: priceString,
              price: price,
              minQty: 0,
              maxQty: isManySelectionAllowed ? 99 : 1,
              isRequired: isRequired,
              defaultQty: 0,
              optionId: name,
              isNestedSelection: optItem['IsNestedSelection'],
            );
          }).toList();

          return Customization(
            name: header,
            minChoiceOptions: isRequired ? 1 : 0,
            maxChoiceOptions: isManySelectionAllowed ? options.length : 1,
            options: options,
            customizationId: header,
            level: 1,
          );
        }).toList();
      } catch (_) {
        return;
      }

      setState(() {
        widget.data.customizations = parsedCustomizations;
        customizationList = parsedCustomizations;
        widget.onCustomizationChange?.call(customizationList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
              item = data.cartQuantity ?? 1;
              cartCount = cartMenuList.length;
            } else {
              routingList.clear();
              alreadyInCart = false;
              item = 1;
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
                                padding: EdgeInsets.only(top: 30.h, left: 15.w),
                                child: 
                                isGoingBack == true ? 
                                    const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                : 
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isGoingBack = true;
                                    });
                                    final signalR = SignalRService();
                                    await signalR.goBack();
                                    Get.back(result: addToCart);
                                    setState(() {
                                      isGoingBack = false;
                                    });
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
                                  _isLoadingCustomization
                                    ? const Center(
                                        child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      )
                                    :
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
                                          onTap: () async {
                                            if (alreadyInCart) {
                                              cartMenu?.cartQuantity =
                                                  (cartMenu.cartQuantity ?? 1) -
                                                      1;
                                              widget.cartBloc.add(ModifyCart(
                                                  menuItemList: cartMenuList));
                                            } else {
                                              if (item > 0) {
                                                item--;
                                              }
                                            }
                                              final signalR = SignalRService();
                                              await signalR.selectQuantity(item);
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: size.height * 0.060,
                                            width: size.height * 0.060,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color:
                                                        AppColors.terracotta)),
                                            child: Center(
                                              child: item == 1
                                                  ? SvgPicture.asset(
                                                      AssetsUtils.icDelete,
                                                      color:
                                                          AppColors.terracotta,
                                                    )
                                                  : const Icon(
                                                      Icons.remove,
                                                      color:
                                                          AppColors.terracotta,
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
                                                fontColor: AppColors.darkGray),
                                          )),
                                        ),
                                        SizedBox(width: 8.w),
                                        GestureDetector(
                                          onTap: () async {
                                            if (alreadyInCart) {
                                              cartMenu?.cartQuantity =
                                                  (cartMenu.cartQuantity ?? 1) +
                                                      1;
                                              widget.cartBloc.add(ModifyCart(
                                                  menuItemList: cartMenuList));
                                            } else {
                                              item++;
                                              setState(() {});
                                            }
                                              final signalR = SignalRService();
                                              await signalR.selectQuantity(item);
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
                                              child: widget.data.isAddUpdated ==
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
                                                      color:
                                                          AppColors.terracotta,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                   isAdding == true
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : 
                                  RestaurantMealAddButtonWidget(
                                    onTap: () async{
                                      final success = await addIntoTheCart();
                                      if (success) {
                                        Get.back();
                                      }
                                    },
                                    buttonLable: 'Add to cart',
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
                              onBack: () async {
                                final signalR = new SignalRService();
                                await signalR.SaveNestedSelectionOption();
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

  Future<void> onTileTap(Customization cs, opt.Option option,
    {required Customization parent, bool setRouting = true}) async {

    final signalR = SignalRService();
    final header = cs.name ?? '';
    final selectedName = option.name ?? '';

    if (option.isNestedSelection == true &&
        (option.customizations == null || option.customizations!.isEmpty)) {

      try {
        final signalRResult = await signalR.getNestedSelection(header, selectedName);

        final parsedNestedCustomizations = signalRResult.map<Customization>((item) {
          final String? nestedHeader = item['header'] ?? item['Header'];
          final bool isRequired = item['isRequired'] ?? item['IsRequired'] ?? false;
          final bool isManySelectionAllowed =
              item['isManySelectionAllowed'] ?? item['IsManySelectionAllowed'] ?? false;

          final optionsList = item['items'] ?? item['Items'] ?? [];

          List<opt.Option> options =
              (optionsList as List).map<opt.Option>((optItem) {
            try {
              final name = optItem['name'] ?? optItem['Name'] ?? '';
              final priceString = optItem['price']?.toString() ??
                  optItem['Price']?.toString() ??
                  '';
              final isNested =
                  optItem['isNestedSelection'] ?? optItem['IsNestedSelection'] ?? false;

              return opt.Option(
                name: name,
                formattedPrice: priceString,
                price: 0,
                minQty: 0,
                maxQty: isManySelectionAllowed ? 99 : 1,
                isRequired: isRequired,
                defaultQty: 0,
                optionId: name,
                isNestedSelection: isNested,
              );
            } catch (e) {
              rethrow;
            }
          }).toList();

          return Customization(
            name: nestedHeader,
            minChoiceOptions: isRequired ? 1 : 0,
            maxChoiceOptions: isManySelectionAllowed ? options.length : 1,
            options: options,
            customizationId: nestedHeader,
            level: cs.level + 1,
          );
        }).toList();

        option.customizations = parsedNestedCustomizations;
      } catch (e) {
        // handle error if needed
      }
    } else {
      try {
        await signalR.selectCustomizationItem(header, selectedName);
      } catch (e) {
        // handle error if needed
      }
    }

    setState(() {
      if (nestedOptionList.any((element) => element["option_id"] == option.optionId)) {
        nestedOptionList.removeWhere((element) => element["option_id"] == option.optionId);
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
      final customization = cList[i];

      int count = nestedOptionList
          .where((e) =>
              customization.options?.any((k) => k.optionId == e["option_id"]) ??
              false)
          .length;

      List<opt.Option> requiredOptions =
          customization.options?.where((element) => element.isRequired ?? false).toList() ?? [];

      int effectiveMinChoice =
          requiredOptions.isNotEmpty ? 1 : (customization.minChoiceOptions ?? 0);

      bool hasAtLeastOneRequiredSelected = requiredOptions.isNotEmpty &&
          requiredOptions.any((element) =>
              nestedOptionList.any((e) => e["option_id"] == element.optionId));

      if (requiredOptions.isNotEmpty && !hasAtLeastOneRequiredSelected) {
        return false;
      }

      if (count < effectiveMinChoice) {
        return false;
      }

      List<opt.Option> validOptionList =
          customization.options?.where((element) =>
              nestedOptionList.any((e) => e["option_id"] == element.optionId)).toList() ?? [];

      for (opt.Option ele in validOptionList) {
        if (!isFormValid(ele.customizations ?? [])) {
          return false;
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

  int setTotalPrice() {
    print('setTotalPrice');
    double price = 0.0;

    final basePriceString = widget.data.formattedPrice;
    if (basePriceString != null && basePriceString != 'Priced by add-ons') {
      price = double.tryParse(
            basePriceString.replaceAll(RegExp(r'[^\d.]'), ''),
          ) ??
          0.0;
    }

    for (var element in nestedOptionList) {
      final markedPrice = element['marked_price'];
      if (markedPrice != null) {
        price += markedPrice;
      }
    }

    price *= item;

    int priceInCents = (price * 100).round();

    print('Total price in cents: $priceInCents');
    return priceInCents;
  }

  Future<bool> addIntoTheCart() async {
    setState(() {
      isAdding = true;
    });
    print(item);
    if (customizationList.isNotEmpty && item <= 0) {
      showToast(
        message: 'Please Select One Item',
        isSuccess: false,
        color: AppColors.black,
      );
      setState(() {
        isAdding = false;
      });
      return false;
    }

    if (customizationList.isNotEmpty) {
      bool valid = isFormValid(customizationList);
      if (!valid) {
        showToast(
          message: 'Please Select Required Item',
          isSuccess: false,
          color: AppColors.black,
        );
        setState(() {
          isAdding = false;
        });
        return false;
      }
    }

    try {
      final signalR = SignalRService();
      final signalRResult = await signalR.addItemsToCart();

      price = setTotalPrice();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('item-added-to-cart', true);
      await prefs.setBool('cart-opened', true);

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

      setState(() {
        isAdding = false;
      });

      return true;
    } catch (e) {
      setState(() {
        isAdding = false;
      });
      return false;
    }
  }
}
