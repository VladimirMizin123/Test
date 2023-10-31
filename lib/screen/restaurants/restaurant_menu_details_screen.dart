import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/restaurant_meal_Add_button.dart';

class RestaurantMenuDetailsScreen extends StatefulWidget {
  const RestaurantMenuDetailsScreen(
      {super.key, required this.data, required this.restaurantId});
  final MenuItemList data;
  final String restaurantId;

  @override
  State<RestaurantMenuDetailsScreen> createState() =>
      _RestaurantMenuDetailsScreenState();
}

class _RestaurantMenuDetailsScreenState
    extends State<RestaurantMenuDetailsScreen> {
  int item = 0;
  dynamic price = 0;
  bool selectFirst = false;
  bool selectSecond = false;
  Map<String, dynamic> selectedData = {};
  List data = [];
  List<Map<String, dynamic>> optionsList = [];
  RestaurantBloc restaurantBloc = RestaurantBloc();
  bool addToCart = false;
  bool isAdding = false;

  getData() async {
    if (widget.data.customizations != null) {
      for (var element in widget.data.customizations!) {
        selectedData.addAll(
          {
            element.name!: [],
          },
        );
      }
    }
    item = widget.data.cartQuantity!;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        body: SingleChildScrollView(
          child: BlocConsumer(
            bloc: restaurantBloc,
            listener: (context, state) {
              if (state is AddToRestaurantCartLoadingState) {
                isAdding = true;
              }
              if (state is AddToRestaurantCartSuccessState) {
                isAdding = false;
              }
              if (state is AddToRestaurantCartErrorState) {
                isAdding = false;
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.data.image!),
                        fit: BoxFit.cover,
                      ),
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      height: widget.data.customizations == null ||
                              widget.data.customizations!.isEmpty
                          ? size.height * 0.55
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.data.name!,
                            style: FontUtils.h24(
                              fontColor: Colors.black,
                              fontWeight: FWT.medium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              widget.data.formattedPrice!,
                              style: FontUtils.h18(
                                fontColor: Colors.black,
                                fontWeight: FWT.medium,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
                            child: Text(
                              widget.data.description ?? '',
                              style: FontUtils.h14(
                                fontColor: const Color(0xffA2A4A7),
                                fontWeight: FWT.lightMedium,
                              ),
                            ),
                          ),
                          widget.data.customizations == null ||
                                  widget.data.customizations!.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: List.generate(
                                    widget.data.customizations!.length,
                                    (index) => Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: widget
                                                          .data
                                                          .customizations?[
                                                              index]
                                                          .minChoiceOptions ==
                                                      0
                                                  ? 250.w
                                                  : 140.w,
                                              child: Text(
                                                widget
                                                        .data
                                                        .customizations?[index]
                                                        .name ??
                                                    '',
                                                style: FontUtils.h18(
                                                  fontColor: Colors.black,
                                                  fontWeight: FWT.semiBold,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            widget.data.customizations?[index]
                                                        .minChoiceOptions ==
                                                    0
                                                ? Text(
                                                    'Optional',
                                                    style: FontUtils.h12(
                                                      fontColor:
                                                          AppColors.middleGray,
                                                      fontWeight: FWT.regular,
                                                    ),
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        'Choose ${widget.data.customizations?[index].minChoiceOptions ?? 1} option',
                                                        style: FontUtils.h14(
                                                          fontColor:
                                                              Colors.black,
                                                          fontWeight:
                                                              FWT.regular,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8.w,
                                                                vertical: 4.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.coral,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          'Required',
                                                          style: FontUtils.h12(
                                                            fontColor: AppColors
                                                                .terracotta,
                                                            fontWeight:
                                                                FWT.regular,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          margin: EdgeInsets.only(bottom: 16.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffECECED),
                                                  width: 1)),
                                          child: Column(
                                            children: List.generate(
                                              widget.data.customizations![index]
                                                  .options!.length,
                                              (index1) => Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedData
                                                                .forEach(
                                                              (key, value) {
                                                                if (key ==
                                                                    widget
                                                                        .data
                                                                        .customizations![
                                                                            index]
                                                                        .name) {
                                                                  if (value.toString().contains(widget
                                                                      .data
                                                                      .customizations![
                                                                          index]
                                                                      .options![
                                                                          index1]
                                                                      .name!)) {
                                                                    value.removeWhere((element) =>
                                                                        element ==
                                                                        widget
                                                                            .data
                                                                            .customizations![index]
                                                                            .options![index1]
                                                                            .name!);

                                                                    optionsList.removeWhere((element) =>
                                                                        element[
                                                                            'option_id'] ==
                                                                        widget
                                                                            .data
                                                                            .customizations?[index]
                                                                            .options?[index1]
                                                                            .optionId);
                                                                  } else {
                                                                    if (widget
                                                                            .data
                                                                            .customizations![
                                                                                index]
                                                                            .maxChoiceOptions! <
                                                                        value.length +
                                                                            1) {
                                                                      value.removeAt(
                                                                          0);

                                                                      for (var j =
                                                                              0;
                                                                          j < widget.data.customizations![index].options!.length;
                                                                          j++) {
                                                                        for (var i =
                                                                                0;
                                                                            i < optionsList.length;
                                                                            i++) {
                                                                          print(
                                                                              'matched');
                                                                          if (widget
                                                                              .data
                                                                              .customizations![index]
                                                                              .options![j]
                                                                              .optionId!
                                                                              .contains(optionsList[i]['option_id'])) {
                                                                            optionsList.removeAt(i);

                                                                            break;
                                                                          }
                                                                        }
                                                                      }

                                                                      /// add data in option list
                                                                      optionsList
                                                                          .add({
                                                                        "option_id":
                                                                            widget.data.customizations?[index].options?[index1].optionId ??
                                                                                '',
                                                                        "quantity":
                                                                            1,
                                                                        "marked_price": widget
                                                                            .data
                                                                            .customizations?[index]
                                                                            .options?[index1]
                                                                            .price
                                                                      });

                                                                      value.add(widget
                                                                          .data
                                                                          .customizations![
                                                                              index]
                                                                          .options![
                                                                              index1]
                                                                          .name);
                                                                    } else {
                                                                      value.add(widget
                                                                          .data
                                                                          .customizations![
                                                                              index]
                                                                          .options![
                                                                              index1]
                                                                          .name);

                                                                      /// add data in option list
                                                                      optionsList
                                                                          .add({
                                                                        "option_id":
                                                                            widget.data.customizations?[index].options?[index1].optionId ??
                                                                                '',
                                                                        "quantity":
                                                                            1,
                                                                        "marked_price": widget
                                                                            .data
                                                                            .customizations?[index]
                                                                            .options?[index1]
                                                                            .price
                                                                      });
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                            );
                                                          });
                                                        },
                                                        child: Image.asset(
                                                          selectedData[widget
                                                                      .data
                                                                      .customizations![
                                                                          index]
                                                                      .name]
                                                                  .contains(widget
                                                                      .data
                                                                      .customizations![
                                                                          index]
                                                                      .options![
                                                                          index1]
                                                                      .name)
                                                              ? AssetsUtils
                                                                  .terracotaCheck
                                                              : AssetsUtils
                                                                  .greyCircle,
                                                          height: 18.h,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12.w,
                                                      ),
                                                      SizedBox(
                                                        width: 230.w,
                                                        child: Text(
                                                          widget
                                                                  .data
                                                                  .customizations?[
                                                                      index]
                                                                  .options?[
                                                                      index1]
                                                                  .name ??
                                                              '',
                                                          style: FontUtils.h15(
                                                            fontColor:
                                                                Colors.black,
                                                            fontWeight:
                                                                FWT.lightMedium,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        widget
                                                                .data
                                                                .customizations?[
                                                                    index]
                                                                .options?[
                                                                    index1]
                                                                .formattedPrice ??
                                                            '',
                                                      )
                                                    ],
                                                  ),
                                                  widget
                                                                  .data
                                                                  .customizations![
                                                                      index]
                                                                  .options!
                                                                  .length -
                                                              1 ==
                                                          index1
                                                      ? const SizedBox()
                                                      : Divider(
                                                          color: const Color(
                                                              0xffECECED),
                                                          thickness: 1,
                                                          height: 20.h,
                                                        )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          widget.data.customizations == null ||
                                  widget.data.customizations!.isEmpty
                              ? const Spacer()
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (item != 0) {
                                      setState(() {
                                        item--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: size.height * 0.060,
                                    width: size.height * 0.060,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: AppColors.terracotta)),
                                    child: Center(
                                        child: item == 1 || item == 0
                                            ? SvgPicture.asset(
                                                AssetsUtils.icDelete,
                                                color: AppColors.terracotta,
                                              )
                                            : const Icon(Icons.remove)),
                                    // child: const Center(child: Icon(Icons.remove, size: 27)),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  height: size.height * 0.060,
                                  width: size.height * 0.060,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.disable),
                                    borderRadius: BorderRadius.circular(6),
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
                                  onTap: () {
                                    setState(() {
                                      item++;
                                    });
                                  },
                                  child: Container(
                                    height: size.height * 0.060,
                                    width: size.height * 0.060,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: AppColors.coral,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.add,
                                          size: 27,
                                          color: AppColors.terracotta),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isAdding == true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : RestaurantMealAddButtonWidget(
                                  onTap: () {
                                    if (widget.data.isAdded == false) {
                                      price = widget.data.originalPrice;

                                      for (var element in optionsList) {
                                        price = price + element['marked_price'];
                                      }

                                      // log('----->>>>>${{
                                      //   'productName': widget.data.name ?? '',
                                      //   'productId': widget.data.productId ?? '',
                                      //   'price': price,
                                      //   'quantity': item,
                                      //   'options': optionsList,
                                      //   'mealmeStoreId': widget.restaurantId,
                                      //   'productType': 'Restaurant',
                                      //   'isChecked': false,
                                      // }}');

                                      restaurantBloc.add(
                                        AddRestaurantCartEvent(
                                          addItemsList: [
                                            AddRestaurantItemsToShoppingListModel(
                                              productId:
                                                  widget.data.productId ?? '',
                                              productName:
                                                  widget.data.name ?? '',
                                              quantity: item,
                                              price: price,
                                              options: optionsList,
                                              mealmeStoreId:
                                                  widget.restaurantId,
                                              productType: 'Restaurant',
                                              isChecked: false,
                                              recipeId: '',
                                              unitOfMeasurement: '',
                                              unitSize: 0,
                                              brandName: '',
                                            ),
                                          ],
                                        ),
                                      );

                                      setState(() {
                                        addToCart = true;
                                      });
                                      // Get.to(
                                      //   () => RestaurantCart(data: {
                                      //     'image': AssetsUtils.restaurantFood1,
                                      //     'title': widget.data.name!,
                                      //     'price': widget.data.formattedPrice!,
                                      //     'count': item
                                      //   }),
                                      //   transition: Transition.fadeIn,
                                      // );
                                    }
                                  },
                                  buttonLable: 'Add to cart',
                                  isFillColor: true,
                                  selectedItemCount: 0,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
