import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

class GrocerySearchScreen extends StatefulWidget {
  const GrocerySearchScreen({super.key});

  @override
  State<GrocerySearchScreen> createState() => _GrocerySearchScreenState();
}

class _GrocerySearchScreenState extends State<GrocerySearchScreen> {
  TextEditingController searchController = TextEditingController();
  GroceryBloc groceryBloc = GroceryBloc();

  List<Cart> groceryMultiSearchModelDataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GroceryBloc, GroceryState>(
          bloc: groceryBloc,
          listener: (context, state) {
            if (state is GrocerySearchSuccessState) {
              groceryMultiSearchModelDataList =
                  state.groceryMultiSearchProductList ?? [];
            }

            if (state is GroceryAddToShoppingSuccessState) {
              setState(() {
                for (var i = 0;
                    i < groceryMultiSearchModelDataList.length;
                    i++) {
                  for (var j = 0;
                      j <
                          groceryMultiSearchModelDataList[i]
                              .groceryResult!
                              .length;
                      j++) {
                    for (var k = 0;
                        k <
                            groceryMultiSearchModelDataList[i]
                                .groceryResult![j]
                                .products!
                                .length;
                        k++) {
                      if (groceryMultiSearchModelDataList[i]
                              .groceryResult![j]
                              .products![k]
                              .productId ==
                          state.recipesAddToGroceryData!.productId) {
                        groceryMultiSearchModelDataList[i]
                            .groceryResult![j]
                            .products![k]
                            .isAddedToShoppingList = true;
                        groceryMultiSearchModelDataList[i]
                            .groceryResult![j]
                            .products![k]
                            .isLoading = false;
                      }
                    }
                  }
                }
              });
            }

            if (state is GroceryAddToShoppingLoadingState) {
              setState(() {
                for (var i = 0;
                    i < groceryMultiSearchModelDataList.length;
                    i++) {
                  for (var j = 0;
                      j <
                          groceryMultiSearchModelDataList[i]
                              .groceryResult!
                              .length;
                      j++) {
                    for (var k = 0;
                        k <
                            groceryMultiSearchModelDataList[i]
                                .groceryResult![j]
                                .products!
                                .length;
                        k++) {
                      if (groceryMultiSearchModelDataList[i]
                              .groceryResult![j]
                              .products![k]
                              .productId ==
                          state.productId) {
                        groceryMultiSearchModelDataList[i]
                            .groceryResult![j]
                            .products![k]
                            .isLoading = true;
                      }
                    }
                  }
                }
              });
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  Image.asset(
                    AssetsUtils.gymEatsLogo,
                    height: 20.h,
                    width: 56.w,
                    color: AppColors.primaryBlue,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.keyboard_arrow_left_outlined,
                              size: 30)),
                      Text('Grocery List',
                          style: FontUtils.h20(
                              fontColor: AppColors.oxFF010101,
                              fontWeight: FWT.semiBold)),
                      Opacity(
                        opacity: 0,
                        child: Image.asset(
                          AssetsUtils.filter,
                          height: 20.h,
                          width: 20.w,
                          color: AppColors.darkGray,
                        ),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: boxShadowWidget,
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: searchController,
                        onSubmitted: (String value) {
                          groceryBloc.add(
                            GrocerySearchEvent(
                              grocerySearchModelList: [
                                GrocerySearchModel(
                                    groceryName: searchController.text,
                                    quantity: 0)
                              ],
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
                          hintText: 'Search for item',
                          hintStyle: FontUtils.h16(),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Expanded(
                    child: state is GrocerySearchLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(
                            children: [
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: ListView.builder(
                                  itemCount:
                                      groceryMultiSearchModelDataList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return ListView.builder(
                                      itemCount:
                                          groceryMultiSearchModelDataList[i]
                                              .groceryResult!
                                              .length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, ind) {
                                        return ListView.builder(
                                          itemCount:
                                              groceryMultiSearchModelDataList[i]
                                                  .groceryResult![ind]
                                                  .products!
                                                  .length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Get.toNamed(
                                                  //     '/GroceryItemDetails',
                                                  //     arguments: GroceryItemDetailsArguments(
                                                  //         productName:
                                                  //             groceryMultiSearchModelDataList[
                                                  //                     i]
                                                  //                 .groceryResult![
                                                  //                     ind]
                                                  //                 .products![
                                                  //                     index]
                                                  //                 .itemName));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow:
                                                          boxShadowWidget,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                groceryMultiSearchModelDataList[
                                                                            i]
                                                                        .groceryResult![
                                                                            ind]
                                                                        .products![
                                                                            index]
                                                                        .itemName ??
                                                                    '',
                                                                style: FontUtils.h16(
                                                                    fontColor:
                                                                        AppColors
                                                                            .black,
                                                                    fontWeight:
                                                                        FWT.medium),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '1 slice, Dave’s Killer Bread - ',
                                                                    style: FontUtils.h12(
                                                                        fontColor:
                                                                            AppColors
                                                                                .middleGray,
                                                                        fontWeight:
                                                                            FWT.medium),
                                                                  ),
                                                                  Text(
                                                                    '110 cal',
                                                                    style: FontUtils.h12(
                                                                        fontColor:
                                                                            AppColors
                                                                                .black,
                                                                        fontWeight:
                                                                            FWT.medium),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        groceryMultiSearchModelDataList[
                                                                    i]
                                                                .groceryResult![
                                                                    ind]
                                                                .products![
                                                                    index]
                                                                .isAddedToShoppingList
                                                            ? SvgPicture.asset(
                                                                AssetsUtils
                                                                    .icAddCircle,
                                                                height: 30)
                                                            : groceryMultiSearchModelDataList[
                                                                        i]
                                                                    .groceryResult![
                                                                        ind]
                                                                    .products![
                                                                        index]
                                                                    .isLoading
                                                                ? const Center(
                                                                    child:
                                                                        CircularProgressIndicator())
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      groceryBloc
                                                                          .add(
                                                                              GroceryAddToShoppingListEvent(
                                                                        productID: groceryMultiSearchModelDataList[i]
                                                                            .groceryResult![ind]
                                                                            .products![index]
                                                                            .productId!,
                                                                        productName:
                                                                            groceryMultiSearchModelDataList[i].groceryResult![ind].products![index].itemName ??
                                                                                '',
                                                                        price: groceryMultiSearchModelDataList[i]
                                                                            .groceryResult![ind]
                                                                            .products![index]
                                                                            .price
                                                                            .toString(),
                                                                        unitSize: groceryMultiSearchModelDataList[i]
                                                                            .groceryResult![ind]
                                                                            .products![index]
                                                                            .unitSize
                                                                            .toString(),
                                                                        unitOfMeasurement: groceryMultiSearchModelDataList[i]
                                                                            .groceryResult![ind]
                                                                            .products![index]
                                                                            .unitOfMeasurement
                                                                            .toString(),
                                                                        quantity:
                                                                            '1',
                                                                        recipeId:
                                                                            '',
                                                                        mealmeStoreId: groceryMultiSearchModelDataList[i]
                                                                            .store!
                                                                            .id!,
                                                                        isAdd:
                                                                            true,
                                                                        isRemove:
                                                                            false,
                                                                        isChecked:
                                                                            false,
                                                                      ));
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                        AssetsUtils
                                                                            .icAddIcon,
                                                                        height:
                                                                            30)),
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
                                  },
                                ),
                              ),
                            ],
                          ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
