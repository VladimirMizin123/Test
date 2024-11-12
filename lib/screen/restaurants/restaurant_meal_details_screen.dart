import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_Add_button.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_menu_details_screen.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'bottomsheet/food_intake_bottomsheet_screen.dart';
import 'package:gymeats_mobile/models/check_store_model.dart' as qu;
import 'model/get_user_address_model.dart' as address;

class RestaurantMealDetails extends StatefulWidget {
  const RestaurantMealDetails({
    super.key,
    required this.data,
    required this.restaurantId,
    this.shoppingListData,
    required this.cartCount,
    required this.pickUp,
    this.quote,
   required this.getUserAddress,
    this.matchMealStatus,
    this.onCustomizationChange,
  });

  final String restaurantId;
  final MenuItemList data;
  final ShoppingListData? shoppingListData;
  final int cartCount;
  final int? matchMealStatus;
  final bool pickUp;
  final qu.Quote? quote;
  final address.UserAddress? getUserAddress;
  final Function(List<Customization>)? onCustomizationChange;

  @override
  State<RestaurantMealDetails> createState() => _RestaurantMealDetailsState();
}

class _RestaurantMealDetailsState extends State<RestaurantMealDetails> {
  List<String> productList = ['Spoon', 'Cup'];
  GroceryBloc groceryBloc = GroceryBloc();
  bool addToCart = false;
  int selectedItem = 0;
  NutritionixGetNxMealInfoByNameModelData?
      nutritionixGetNxMealInfoByNameModelData;
  int productCount = 0;
  bool remove = false;
  bool add = false;
  bool delete = false;
  bool addItem = false;

  @override
  void initState() {
    super.initState();
    groceryBloc.add(
      GroceryDetailsMealInfoEvent(
        groceryProductName: widget.data.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.matchMealStatus);
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        body: BlocConsumer<GroceryBloc, GroceryState>(
            bloc: groceryBloc,
            listener: (context, state) {
              if (state is GroceryNutritionixGetNxMealInfoByNameSuccessState) {
                nutritionixGetNxMealInfoByNameModelData =
                    state.nutritionixGetNxMealInfoByNameModelData;
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      AssetsUtils.gymEatsLogo,
                      height: 20.h,
                      width: 56.w,
                      color: AppColors.terracotta,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back(result: widget.data.isAdded);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                            ),
                          ),
                          Text('Restaurant / Meal Details',
                              style: FontUtils.h24(
                                  fontColor: AppColors.oxFF010101,
                                  fontWeight: FWT.semiBold)),
                          const SizedBox()
                        ],
                      ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          switch (widget.matchMealStatus) {
                            0 => "Matches with your Meal Plan",
                            1 => "Partly matches with your Meal Plan",
                            _ => "Doesn’t match with your Meal Plan",
                          },
                          style: const TextStyle(
                            color: Color(0xff5F5F5F),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (widget.matchMealStatus != null) ...[
                          const SizedBox(width: 5),
                          Image.asset(
                            matchIcon(widget.matchMealStatus!),
                            width: 25.w,
                          ),
                        ],
                      ],
                    ),
                    Expanded(
                        child: nutritionixGetNxMealInfoByNameModelData == null
                            ? state is GroceryNutritionixGetNxMealInfoByNameLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const SizedBox()
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nutritionixGetNxMealInfoByNameModelData!
                                                .foodName ??
                                            widget.data.name ??
                                            '',
                                        style: FontUtils.h20(
                                            fontColor: AppColors.black,
                                            fontWeight: FWT.semiBold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 335.w,
                                        height: 120.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: widget.data.image == null ||
                                                  widget.data.image!.isEmpty
                                              ? const DecorationImage(
                                                  image: AssetImage(
                                                      AssetsUtils.food3),
                                                  fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image: NetworkImage(
                                                      widget.data.image!),
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      GridView(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 2,
                                          crossAxisSpacing: 6.w,
                                          mainAxisSpacing: 6.h,
                                        ),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          myProgressBarCardView(
                                              'Cal',
                                              nutritionixGetNxMealInfoByNameModelData!
                                                          .nfCalories ==
                                                      null
                                                  ? 0
                                                  : double.parse(
                                                      nutritionixGetNxMealInfoByNameModelData!
                                                          .nfCalories
                                                          .toString()),
                                              PreferenceUtils.getString(
                                                          totalCalorie)
                                                      .isEmpty
                                                  ? 1
                                                  : double.parse(double.parse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalCalorie))
                                                      .toStringAsFixed(2)),
                                              AppColors.primaryBlue,
                                              'cal'),
                                          myProgressBarCardView(
                                              'Fat',
                                              nutritionixGetNxMealInfoByNameModelData!
                                                          .nfTotalFat ==
                                                      null
                                                  ? 0
                                                  : double.parse(
                                                      nutritionixGetNxMealInfoByNameModelData!
                                                          .nfTotalFat
                                                          .toString()),
                                              PreferenceUtils.getString(
                                                          totalFat)
                                                      .isEmpty
                                                  ? 1
                                                  : double.parse(double.parse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalFat))
                                                      .toStringAsFixed(2)),
                                              AppColors.coral,
                                              'g'),
                                          myProgressBarCardView(
                                              'Carbs',
                                              nutritionixGetNxMealInfoByNameModelData!
                                                          .nfTotalCarbohydrate ==
                                                      null
                                                  ? 0
                                                  : double.parse(
                                                      nutritionixGetNxMealInfoByNameModelData!
                                                          .nfTotalCarbohydrate
                                                          .toString()),
                                              PreferenceUtils.getString(
                                                          totalCarbs)
                                                      .isEmpty
                                                  ? 1
                                                  : double.parse(double.parse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalCarbs))
                                                      .toStringAsFixed(2)),
                                              AppColors.mint,
                                              'g'),
                                          myProgressBarCardView(
                                              'Protein',
                                              nutritionixGetNxMealInfoByNameModelData!
                                                          .nfTotalFat ==
                                                      null
                                                  ? 0
                                                  : double.parse(
                                                      nutritionixGetNxMealInfoByNameModelData!
                                                          .nfTotalFat
                                                          .toString()),
                                              PreferenceUtils.getString(
                                                          totalProtein)
                                                      .isEmpty
                                                  ? 1
                                                  : double.parse(double.parse(
                                                          PreferenceUtils
                                                              .getString(
                                                                  totalProtein))
                                                      .toStringAsFixed(2)),
                                              AppColors.skyBlue,
                                              'g'),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Nutritional Information',
                                              style: FontUtils.h24(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.semiBold))),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Saturated Fat',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                          Text(
                                              '${(nutritionixGetNxMealInfoByNameModelData?.nfSaturatedFat ?? 0.00).toStringAsFixed(2)} g',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                          color: AppColors.disabledColor,
                                          height: 2.h),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Cholesterol',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                          Text(
                                              '${(nutritionixGetNxMealInfoByNameModelData?.nfCholesterol ?? 0.00).toStringAsFixed(2)} mg',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                          color: AppColors.disabledColor,
                                          height: 2.h),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Sodium',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                          Text(
                                              '${(nutritionixGetNxMealInfoByNameModelData?.nfSodium ?? 0.00).toStringAsFixed(2)} mg',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                          color: AppColors.disabledColor,
                                          height: 2.h),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Dietary Fiber',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                          Text(
                                              '${(nutritionixGetNxMealInfoByNameModelData?.nfDietaryFiber ?? 0.00).toStringAsFixed(2)} g',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                          color: AppColors.disabledColor,
                                          height: 2.h),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Sugar',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                          Text(
                                              '${(nutritionixGetNxMealInfoByNameModelData?.nfSugars ?? 0.00).toStringAsFixed(2)} g',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                          color: AppColors.disabledColor,
                                          height: 2.h),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Potassium',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                          Text(
                                              '${(nutritionixGetNxMealInfoByNameModelData?.nfPotassium ?? 0.00).toStringAsFixed(2)} mg',
                                              style: FontUtils.h16(
                                                  fontColor: AppColors.darkGray,
                                                  fontWeight: FWT.medium)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                          color: AppColors.disabledColor,
                                          height: 2.h),
                                      const SizedBox(height: 15),
                                      RestaurantMealAddButtonWidget(
                                        onTap: () {
                                          // if (addToCart == false) {
                                          //   setState(() {
                                          //     selectedItem = 1;
                                          //     addToCart = true;
                                          //   });
                                          // }

                                          widget.shoppingListData == null
                                              ? Get.to(
                                                  () =>
                                                      RestaurantMenuDetailsScreen(
                                                    data: widget.data,
                                                    restaurantId:
                                                        widget.restaurantId,
                                                    cartCount: widget.cartCount,
                                                    pickUp: widget.pickUp,
                                                    quote: widget.quote,
                                                    userAddress:
                                                        widget.getUserAddress,
                                                    onCustomizationChange:
                                                        (p0) => widget
                                                            .onCustomizationChange
                                                            ?.call(p0),
                                                  ),
                                                )
                                              : Get.to(
                                                  () =>
                                                      RestaurantMenuDetailsScreen(
                                                    data: widget.data,
                                                    restaurantId:
                                                        widget.restaurantId,
                                                    shoppingListData:
                                                        widget.shoppingListData,
                                                    cartCount: widget.cartCount,
                                                    pickUp: widget.pickUp,
                                                    quote: widget.quote,
                                                    userAddress:
                                                        widget.getUserAddress,
                                                    onCustomizationChange:
                                                        (p0) => widget
                                                            .onCustomizationChange
                                                            ?.call(p0),
                                                  ),
                                                );
                                        },
                                        buttonLable: 'Add to cart',
                                        isFillColor: true,
                                        selectedItemCount: 0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 10),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) {
                                                  return LogFoodIntakeBottomSheet(
                                                    nutritionixGetNxMealInfoByNameModelData:
                                                        nutritionixGetNxMealInfoByNameModelData,
                                                    isMainScreen: false,
                                                    name: widget.data.name,
                                                  );
                                                },
                                                isDismissible: false,
                                                shape: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16.r),
                                                    topRight:
                                                        Radius.circular(16.r),
                                                  ),
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Log To My Food Intake',
                                              style: FontUtils.h18(
                                                fontColor: AppColors.terracotta,
                                                fontWeight: FWT.medium,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget myProgressBarCardView(
    String title,
    double value,
    double totalValue,
    Color progressBarColor,
    String unit,
  ) {
    final screenSize = MediaQuery.of(context).size;

    num per = (value / totalValue).isNaN || (value / totalValue).isInfinite
        ? 0
        : value / totalValue;

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.whiteColor,
          boxShadow: const [
            BoxShadow(
                color: AppColors.black, blurRadius: 30, spreadRadius: -30),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: FontUtils.h20(
                    fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                commonProgressBar(
                  progressColor: progressBarColor,
                  width: screenSize.width * 0.27,
                  percentage: per.toDouble(),
                  lineHeight: 12,
                ),
              ],
            ),
            Text(
                '${value.toStringAsFixed(2)} / ${totalValue.toStringAsFixed(2)} $unit',
                style: FontUtils.h15(
                    fontColor: AppColors.darkGray,
                    fontWeight: FWT.lightMedium)),
          ],
        ));
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

  Widget commonProgressBar(
      {Color? progressColor,
      double? width,
      double? percentage,
      double? lineHeight}) {
    return LinearPercentIndicator(
      width: width,
      barRadius: const Radius.circular(10),
      animation: true,
      lineHeight: lineHeight!,
      animationDuration: 2000,
      percent: percentage!.isGreaterThan(1) ? 1 : percentage,
      center: const Text(""),
      linearStrokeCap: LinearStrokeCap.round,
      progressColor: progressColor,
    ).paddingAll(5);
  }
}

class GroceryItemDetailsArguments {
  final GroceryDetails? groceryShoppingData;
  final bool isFromGroceryScreen;
  final bool isFromCustomMealScreen;
  final bool isFromJournalScreen;
  final String? productName;
  final String? productID;
  final String? type;
  final Map<String, dynamic>? groceryDetails;

  GroceryItemDetailsArguments({
    this.groceryShoppingData,
    this.isFromGroceryScreen = false,
    this.isFromCustomMealScreen = false,
    this.isFromJournalScreen = false,
    this.productName,
    this.productID,
    this.type,
    this.groceryDetails,
  });
}
