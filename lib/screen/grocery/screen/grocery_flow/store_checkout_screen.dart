// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/account_screen/map_address/map_address_screen_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/profile/profile_screen_widget.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/bloc/store_cart_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/check_list_sheet.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/custom_search_field.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/product_card_widget.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/checkout_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart'
    as o_address;
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user_address;
import 'package:gymeats_mobile/widget/food_menu_address.dart';

class StoreCheckOutScreen extends StatefulWidget {
  final String? storeName;
  final StoreCartBloc storeCartBloc;
  final user_address.UserAddress? address;
  final List<GroceryDetails>? groceryDetails;
  final AskReceiveOrder? askOrder;

  const StoreCheckOutScreen({
    super.key,
    this.storeName,
    required this.storeCartBloc,
    this.address,
    this.groceryDetails,
    this.askOrder,
  });

  @override
  State<StoreCheckOutScreen> createState() => _StoreCheckOutScreenState();
}

class _StoreCheckOutScreenState extends State<StoreCheckOutScreen> {
  TextEditingController search = TextEditingController();
  String? searchText;
  // List<MenuItemList> cartMenuList = [];
  List<MenuItemList> cartMenuList = [];
  bool orderLoader = false;
  GroceryBloc groceryBloc = GroceryBloc();
  late StoreCartBloc bloc;

  final formKey = GlobalKey<FormState>();

  TextEditingController addressNameController = TextEditingController();
  TextEditingController notes = TextEditingController();

  TextEditingController streetDetailsController = TextEditingController();
  TextEditingController apartmentNumberController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  @override
  void initState() {
    widget.storeCartBloc.add(GetGroceryCartList());
    super.initState();
  }

  int price = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCartBloc, StoreCartState>(
      bloc: widget.storeCartBloc,
      listener: (context, state) {
        if (state is StoreCheckoutState) {
          cartMenuList = state.menuItemList;
          setState(() {});

          price = 0;
          for (var element in cartMenuList) {
            price = price + (element.totalPrice ?? 0);
          }
          setState(() {});
        }
      },
      builder: (context, state) {
        return BlocConsumer<GroceryBloc, GroceryState>(
          bloc: groceryBloc,
          listener: (context, state) {
            if (state is CreateOrderLoadingState) {
              orderLoader = state.isLoading;
              setState(() {});
            }
            if (state is CreateOrderSuccessState) {
              Get.to(
                () => CheckOutScreen(
                  isFromGrocery: true,
                  cartData: cartMenuList,
                  orderData: state.orderData,
                  getUserAddress: widget.address,
                  groceryList: [],
                  hasMultipleStore: false,
                  createMultipleOrder: false,
                  currentAddress: streetDetailsController.text,
                ),
              );
            }
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                body: WillPopScope(
                  onWillPop: () async {
                    return true;
                  },
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        15.height,
                        Align(
                          child: Image.asset(
                            AssetsUtils.gymEatsLogo,
                            height: 20.h,
                            color: AppColors.green,
                          ),
                        ),
                        10.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BackButtonWidget(),
                            Text(
                              'Cart',
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
                                      groceryDetails: widget.groceryDetails);
                                },
                                isDismissible: false,
                              ),
                              child: SvgPicture.asset(AssetsUtils.icList),
                            ),
                          ],
                        ).paddingOnly(left: 14, right: 14),
                        10.height,
                        Align(
                          child: IntrinsicWidth(
                            child: GestureDetector(
                              onTap: () => Get.offAll(
                                  () => const AppManagerScreen(selectIndex: 1)),
                              child: Container(
                                height: 26,
                                constraints:
                                    const BoxConstraints(maxWidth: 180),
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.green),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AssetsUtils.icPin),
                                    10.width,
                                    Expanded(
                                        child: Text(
                                      widget.storeName ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FontUtils.h14(
                                          fontColor: AppColors.green,
                                          fontWeight: FWT.semiBold),
                                    )),
                                    8.width,
                                    SvgPicture.asset(AssetsUtils.downArrow,
                                        color: AppColors.green),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        16.height,
                        CustomSearchField(
                          hintText: "Search for item",
                          controller: search,
                          readOnly: false,
                          onChange: (p0) => setState(() => searchText = p0),
                        ).paddingOnly(left: 14, right: 14),
                        12.height,
                        Text(
                          "${cartMenuList.length} items",
                          style: FontUtils.h16(
                            fontColor: AppColors.middleGray,
                            fontWeight: FWT.medium,
                          ),
                        ).paddingOnly(left: 14, right: 14),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              List<MenuItemList> filterList = cartMenuList
                                  .where((element) =>
                                      element.name?.toLowerCase().contains(
                                          searchText?.toLowerCase() ?? "") ??
                                      false)
                                  .toList();
                              return filterList.isEmpty
                                  ? Center(
                                      child: Text(
                                        cartMenuList.isEmpty
                                            ? "Cart items not found !"
                                            : 'Cart items not found for $searchText!',
                                        textAlign: TextAlign.center,
                                        style: FontUtils.h16(
                                            fontColor: AppColors.black),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 12),
                                      child: Column(
                                        children: [
                                          ListView.separated(
                                            itemCount: filterList.length,
                                            separatorBuilder:
                                                (context, index) => 15.height,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 12),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              MenuItemList? item =
                                                  filterList[index];

                                              return ProductCardWidget(
                                                imgSize: 75,
                                                showDiscount: false,
                                                checkoutScreen: true,
                                                qty: item.cartQuantity,
                                                menuItem: item,
                                                cartItem: item,
                                                storeName: widget.storeName,
                                                add: true,
                                                onCartTap: () {},
                                                onAdd: () =>
                                                    widget.storeCartBloc.add(
                                                  ChangeGroceryQty(
                                                    productID: item.productId,
                                                    type: ModifyType.decrement,
                                                  ),
                                                ),
                                                onRemove: () =>
                                                    widget.storeCartBloc.add(
                                                  ChangeGroceryQty(
                                                    productID: item.productId,
                                                    type: ModifyType.increment,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: boxShadowWidget,
                            color: AppColors.whiteColor,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!orderLoader) ...[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Text(
                                    ' Order Notes',
                                    style: FontUtils.h18(
                                      fontColor: const Color(0xff000000),
                                      fontWeight: FWT.semiBold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff004C63)
                                            .withOpacity(0.08),
                                        offset: const Offset(0, 0),
                                        blurRadius: 16,
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: notes,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.all(0),
                                      hintText: 'Add order Notes.....',
                                    ),
                                  ),
                                ),
                              ],
                              12.height,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: FontUtils.h18(
                                      fontColor: AppColors.darkGray,
                                      fontWeight: FWT.semiBold,
                                    ),
                                  ),
                                  Text(
                                    '\$ ${price / 100}',
                                    style: FontUtils.h22(
                                      fontColor: AppColors.darkGray,
                                      fontWeight: FWT.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                              10.height,
                              orderLoader == true
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    ).paddingOnly(
                                      left: 20, right: 20, bottom: 20)
                                  : simpleTextBorderButton(
                                      width: context.width,
                                      height: 48,
                                      context: context,
                                      color: AppColors.green,
                                      buttonLable: StringUtils.checkout,
                                      isLoadingWidget: false,
                                      onTap: () async {
                                        Map<String, dynamic> req =
                                            PreferenceUtils.getMenuAddress();
                                        final value = Constant
                                            .i.requiredAddressField
                                            .every((e) => req.containsKey(e));
                                        if (!value) {
                                          dynamic result =
                                              await showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            isScrollControlled: true,
                                            builder: (context) =>
                                                FoodMenuAddress(request: req),
                                          );
                                          if (result != true) {
                                            return;
                                          }
                                        }
                                        List<CreateOrderGroceryItems> data = [];
                                        for (var element in cartMenuList) {
                                          data.add(
                                            CreateOrderGroceryItems(
                                              productId: element.productId,
                                              productType: 2,
                                              quantity: element.cartQuantity,
                                              notes: element.name,
                                              productMarkedPrice:
                                                  element.originalPrice,
                                              selectedOptions:
                                                  element.selectedOptions ?? [],
                                            ),
                                          );
                                        }

                                        if (data.isEmpty) {
                                          return;
                                        }

                                        (double?, double?) pos =
                                            await Constant.i.position;

                                        Map<String, dynamic> extAddress =
                                            PreferenceUtils.getMenuAddress();

                                        double? lat =
                                            pos.$1 ?? widget.address?.latitude;
                                        double? lng =
                                            pos.$1 ?? widget.address?.longitude;

                                        groceryBloc.add(
                                          CreateOrderEvent(
                                            context: context,
                                            createGroceryOrderModel:
                                                CreateGroceryOrderModel(
                                              userId: userId,
                                              pickup: widget.askOrder ==
                                                  AskReceiveOrder.pickMySelf,
                                              groceryItems: data,
                                              userAddress:
                                                  o_address.UserAddress(
                                                latitude: lat,
                                                longitude: lng,
                                                streetName: extAddress[
                                                    'user_street_name'],
                                                streetNum: extAddress[
                                                    'user_street_num'],
                                                city: extAddress['user_city'],
                                                country:
                                                    extAddress['user_country'],
                                                state: extAddress['user_state'],
                                                zipcode:
                                                    extAddress['user_zipcode'],
                                              ),
                                              userPhone: 1234567890,
                                              driverTipCents: 0,
                                              pickupTipCents: 0,
                                              userDropoffNotes: notes.text,
                                              extendedAddress: {
                                                "latitude": lat,
                                                "longitude": lng,
                                                "street_Num": extAddress[
                                                    "user_street_num"],
                                                "street_Name": extAddress[
                                                    "user_street_name"],
                                                "city": extAddress["user_city"],
                                                "state":
                                                    extAddress["user_state"],
                                                "country":
                                                    extAddress["user_country"],
                                                "zipcode":
                                                    extAddress["user_zipcode"],
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      isDarkColor: true,
                                      isFillColor: true,
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  num getTotal() {
    try {
      return cartMenuList.fold<double>(
        0,
        (p, e) =>
            ((((e.cartQuantity ?? 0) * (e.originalPrice ?? 0)) / 100) + p) +
            (e.selectedOptions?.fold<double>(
                    0,
                    (p1, e1) =>
                        (((e1.markedPrice ?? 0) * (e1.quantity ?? 0)) / 100) +
                        p1) ??
                0),
      );
    } catch (e) {
      return 0.0;
    }
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
        ));
  }

  Widget feeWidget(String title, String value, [bool showInfo = true]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: FontUtils.h14(
                fontColor: AppColors.darkGray,
                fontWeight: FWT.lightMedium,
              ),
            ),
            if (showInfo) ...[
              10.width,
              SvgPicture.asset(AssetsUtils.icInfo),
            ],
          ],
        ),
        Text(
          value,
          style: FontUtils.h14(
            fontColor: AppColors.darkGray,
            fontWeight: FWT.lightMedium,
          ),
        ),
      ],
    ).paddingOnly(left: 20, right: 20);
  }

  Future<dynamic> addressDialog() async {
    addressNameController.clear();
    streetDetailsController.clear();
    apartmentNumberController.clear();
    floorNumberController.clear();
    city.clear();
    zipCodeController.clear();

    return await showGeneralDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.3),
      pageBuilder: (context, _, __) => Material(
        color: AppColors.black.withOpacity(0.3),
        child: Align(
          child: IntrinsicHeight(
            child: Container(
              height: context.height * 0.9,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                      left: 22.w, right: 22.w, top: 8, bottom: 15),
                  children: [
                    const SizedBox(height: 10),
                    labelWidget(
                      text: "Current Address",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.w700),
                    ),
                    mapDetailWidget(
                      title: "Name",
                      textEditingController: addressNameController,
                      readOnly: false,
                      suffixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    mapDetailWidget(
                      title: "Street",
                      textEditingController: streetDetailsController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Street details';
                        } else {
                          return null;
                        }
                      },
                    ),
                    mapDetailWidget(
                      title: "Street Number",
                      textEditingController: apartmentNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Street Number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    mapDetailWidget(
                      title: "Extended Address",
                      textEditingController: floorNumberController,
                    ),
                    mapDetailWidget(
                      title: "City",
                      textEditingController: city,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter City Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    mapDetailWidget(
                      title: "Zip",
                      textEditingController: zipCodeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Zip Code';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    buildButton(
                      context: context,
                      title: StringUtils.continueTxt,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Get.back(result: true);
                        }
                      },
                      textColor: AppColors.whiteColor,
                      bgColor: AppColors.primaryBlueColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
