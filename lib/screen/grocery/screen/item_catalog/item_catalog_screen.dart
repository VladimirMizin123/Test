import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/grocery_product_details_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

import 'bottomsheet/item_catalog_filter_bottomsheet.dart';
import 'bottomsheet/item_catalog_sort_by_bottomsheet.dart';

class ItemCatalogScreen extends StatefulWidget {
  final List<Cart> selectedStoreProductList;
  final GroceryBloc groceryBloc;
  final String? productId;
  final String? typeOfProduct;
  final String? storeName;
  const ItemCatalogScreen({
    super.key,
    this.selectedStoreProductList = const [],
    required this.groceryBloc,
    required this.productId,
    required this.typeOfProduct,
    required this.storeName,
  });

  @override
  State<ItemCatalogScreen> createState() => _ItemCatalogScreenState();
}

class _ItemCatalogScreenState extends State<ItemCatalogScreen> {
  List<Product> groceryResult = [];
  List<Product> filterResult = [];
  bool isProductSelect = false;
  bool isFilter = false;

  String? selectedSorting;

  @override
  void initState() {
    super.initState();
    fillData();
  }

  fillData() {
    for (var i = 0; i < widget.selectedStoreProductList.length; i++) {
      for (var j = 0;
          j < widget.selectedStoreProductList[i].groceryResult!.length;
          j++) {
        if (widget.selectedStoreProductList[i].groceryResult != null) {
          if (widget.selectedStoreProductList[i].groceryResult![j].products !=
                  [] &&
              widget.selectedStoreProductList[i].groceryResult![j]
                      .searchedItemName ==
                  widget.typeOfProduct) {
            widget.selectedStoreProductList[i].groceryResult![j].products
                ?.forEach((element) {
              if (!element.isAddedToShoppingList) {
                groceryResult.add(element);
              }
            });
          }
        }
      }
    }
    setState(() {});
  }

  sortingData() {
    if (selectedSorting == 'Cheapest first') {
      groceryResult
          .sort((a, b) => a.originalPrice!.compareTo(b.originalPrice!));
      setState(() {});
    } else if (selectedSorting == 'Expensive') {
      groceryResult
          .sort((a, b) => b.originalPrice!.compareTo(a.originalPrice!));
      setState(() {});
    }
  }

  RangeValues? priceRange;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
                SizedBox(
                  width: 40.w,
                  child: const BackButtonWidget(),
                ),
                Text(
                  'Grocery List',
                  style: FontUtils.h20(
                      fontColor: AppColors.oxFF010101,
                      fontWeight: FWT.semiBold),
                ),
                SizedBox(
                  width: 40.w,
                ),
              ],
            ).paddingSymmetric(horizontal: 6, vertical: 5.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  myFilterView(AssetsUtils.icFilterIcon, 'Filter', () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ItemCatalogFilterBottomSheet(
                          value: priceRange,
                        );
                      },
                      isDismissible: false,
                    ).then((value) {
                      if (value != null) {
                        priceRange = value['priceRange'];
                        isFilter = value['isFilter'];

                        filterResult.clear();
                        if (isFilter) {
                          for (var element in groceryResult) {
                            if ((element.originalPrice!) > priceRange!.start &&
                                (element.originalPrice!) < priceRange!.end) {
                              filterResult.add(element);
                            }
                          }
                        }
                        log('isFilter---------->>>>>> $isFilter====$priceRange');
                        setState(() {});
                      }
                    });
                  }),
                  const SizedBox(width: 10),
                  myFilterView(AssetsUtils.icSortIcon, 'Sort by', () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ItemCatalogSortByBottomSheet(
                            selectedSort: selectedSorting);
                      },
                      isDismissible: false,
                    ).then((value) {
                      if (value != null) {
                        selectedSorting = value;

                        setState(() {});
                        sortingData();
                      }
                    });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 5),
            isFilter == true
                ? Expanded(
                    child: filterResult.isEmpty
                        ? const Center(
                            child: Text('No Data Found!'),
                          )
                        : GridView.builder(
                            itemCount: filterResult.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.6,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // Get.toNamed('/GroceryProductDetails');
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return GroceryProductDetails(
                                        product: filterResult[index]);
                                  }));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    boxShadow: boxShadowWidget,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        height: 80,
                                        width: 80,
                                        imageUrl: filterResult[index].image!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator(
                                          color: AppColors.lightGrey,
                                        )),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      // Image(
                                      //   image: NetworkImage(filterResult[index].image!),
                                      //   height: 80,
                                      //   width: 80,
                                      //   fit: BoxFit.cover,
                                      // ),
                                      const SizedBox(height: 10),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            filterResult[index].itemName ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: FontUtils.h15(
                                                fontColor: AppColors.darkGray),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        filterResult[index].formattedPrice ??
                                            '',
                                        style: FontUtils.h17(
                                            fontColor: AppColors.darkGray,
                                            fontWeight: FWT.semiBold),
                                      ),

                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.info_outline_rounded,
                                              color: AppColors.terracotta,
                                              size: 20),
                                          const SizedBox(width: 3),
                                          Text(
                                            'Available in: ',
                                            style: FontUtils.h12(
                                                fontColor: AppColors.middleGray,
                                                fontWeight: FWT.semiBold),
                                          ),
                                          Text(
                                            widget.storeName ?? '',
                                            style: FontUtils.h12(
                                                fontColor: AppColors.black,
                                                fontWeight: FWT.semiBold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      !filterResult[index].isAddedToShoppingList
                                          ? GestureDetector(
                                              onTap: () {
                                                if (!isProductSelect) {
                                                  setState(() {
                                                    filterResult[index]
                                                            .isAddedToShoppingList =
                                                        true;
                                                    isProductSelect = true;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: size.height * 0.065,
                                                width: size.height * 0.065,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors.green),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: SvgPicture.asset(
                                                        AssetsUtils
                                                            .icShoppingIcon,
                                                        color:
                                                            AppColors.green)),
                                              ),
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // filterResult[index].cartItemCount == 1
                                                //     ? GestureDetector(
                                                //         onTap: () {
                                                //           setState(() {
                                                //             // filterResult.removeWhere((element) => element.productId == filterResult[index].productId);
                                                //             filterResult[index].isAddedToShoppingList = false;
                                                //           });
                                                //         },
                                                //         child: Container(
                                                //           height: size.height * 0.065,
                                                //           width: size.height * 0.065,
                                                //           decoration: BoxDecoration(border: Border.all(color: AppColors.mint, width: 2), borderRadius: BorderRadius.circular(10)),
                                                //           child: Center(child: SvgPicture.asset(AssetsUtils.icDelete, color: AppColors.green)),
                                                //         ),
                                                //       )
                                                //     :
                                                SizedBox(width: 8.w),

                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (filterResult[index]
                                                                .cartItemCount ==
                                                            1) {
                                                          filterResult[index]
                                                                  .isAddedToShoppingList =
                                                              false;
                                                          isProductSelect =
                                                              false;
                                                        } else {
                                                          filterResult[index]
                                                                  .cartItemCount =
                                                              filterResult[
                                                                          index]
                                                                      .cartItemCount -
                                                                  1;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      height:
                                                          size.height * 0.060,
                                                      // width: size.height * 0.045,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .mint,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: const Center(
                                                        child: Icon(
                                                            Icons.remove,
                                                            size: 27),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: Container(
                                                    height: size.height * 0.060,
                                                    // width: size.height * 0.045,

                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .disable),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                        child: Text(
                                                      filterResult[index]
                                                          .cartItemCount
                                                          .toString(),
                                                      style: FontUtils.h18(
                                                          fontWeight:
                                                              FWT.semiBold,
                                                          fontColor: AppColors
                                                              .darkGray),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        filterResult[index]
                                                                .cartItemCount =
                                                            filterResult[index]
                                                                    .cartItemCount +
                                                                1;
                                                      });
                                                    },
                                                    child: Container(
                                                      height:
                                                          size.height * 0.060,
                                                      // width: size.height * 0.045,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: AppColors.mint,
                                                      ),
                                                      child: const Center(
                                                          child: Icon(Icons.add,
                                                              color: AppColors
                                                                  .green,
                                                              size: 27)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                : Expanded(
                    child: groceryResult.isEmpty
                        ? const Center(
                            child: Text('No Data Found!'),
                          )
                        : GridView.builder(
                            itemCount: groceryResult.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.6,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // Get.toNamed('/GroceryProductDetails');
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return GroceryProductDetails(
                                        product: groceryResult[index]);
                                  }));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    boxShadow: boxShadowWidget,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        height: 80,
                                        width: 80,
                                        imageUrl: groceryResult[index].image!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator(
                                          color: AppColors.lightGrey,
                                        )),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      // Image(
                                      //   image: NetworkImage(groceryResult[index].image!),
                                      //   height: 80,
                                      //   width: 80,
                                      //   fit: BoxFit.cover,
                                      // ),
                                      const SizedBox(height: 10),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            groceryResult[index].itemName ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: FontUtils.h15(
                                                fontColor: AppColors.darkGray),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        groceryResult[index].formattedPrice ??
                                            '',
                                        style: FontUtils.h17(
                                            fontColor: AppColors.darkGray,
                                            fontWeight: FWT.semiBold),
                                      ),

                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.info_outline_rounded,
                                              color: AppColors.terracotta,
                                              size: 20),
                                          const SizedBox(width: 3),
                                          Text(
                                            'Available in: ',
                                            style: FontUtils.h12(
                                                fontColor: AppColors.middleGray,
                                                fontWeight: FWT.semiBold),
                                          ),
                                          Flexible(
                                            child: Text(
                                              widget.storeName ?? '',
                                              style: FontUtils.h12(
                                                  fontColor: AppColors.black,
                                                  fontWeight: FWT.semiBold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      !groceryResult[index]
                                              .isAddedToShoppingList
                                          ? GestureDetector(
                                              onTap: () {
                                                if (!isProductSelect) {
                                                  setState(() {
                                                    groceryResult[index]
                                                            .isAddedToShoppingList =
                                                        true;
                                                    isProductSelect = true;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: size.height * 0.065,
                                                width: size.height * 0.065,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors.green),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: SvgPicture.asset(
                                                        AssetsUtils
                                                            .icShoppingIcon,
                                                        color:
                                                            AppColors.green)),
                                              ),
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // groceryResult[index].cartItemCount == 1
                                                //     ? GestureDetector(
                                                //         onTap: () {
                                                //           setState(() {
                                                //             // groceryResult.removeWhere((element) => element.productId == groceryResult[index].productId);
                                                //             groceryResult[index].isAddedToShoppingList = false;
                                                //           });
                                                //         },
                                                //         child: Container(
                                                //           height: size.height * 0.065,
                                                //           width: size.height * 0.065,
                                                //           decoration: BoxDecoration(border: Border.all(color: AppColors.mint, width: 2), borderRadius: BorderRadius.circular(10)),
                                                //           child: Center(child: SvgPicture.asset(AssetsUtils.icDelete, color: AppColors.green)),
                                                //         ),
                                                //       )
                                                //     :
                                                SizedBox(width: 8.w),

                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (groceryResult[index]
                                                                .cartItemCount ==
                                                            1) {
                                                          groceryResult[index]
                                                                  .isAddedToShoppingList =
                                                              false;
                                                          isProductSelect =
                                                              false;
                                                        } else {
                                                          groceryResult[index]
                                                                  .cartItemCount =
                                                              groceryResult[
                                                                          index]
                                                                      .cartItemCount -
                                                                  1;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      height:
                                                          size.height * 0.060,
                                                      // width: size.height * 0.045,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .mint,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: const Center(
                                                        child: Icon(
                                                            Icons.remove,
                                                            size: 27),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: Container(
                                                    height: size.height * 0.060,
                                                    // width: size.height * 0.045,

                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .disable),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                        child: Text(
                                                      groceryResult[index]
                                                          .cartItemCount
                                                          .toString(),
                                                      style: FontUtils.h18(
                                                          fontWeight:
                                                              FWT.semiBold,
                                                          fontColor: AppColors
                                                              .darkGray),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        groceryResult[index]
                                                                .cartItemCount =
                                                            groceryResult[index]
                                                                    .cartItemCount +
                                                                1;
                                                      });
                                                    },
                                                    child: Container(
                                                      height:
                                                          size.height * 0.060,
                                                      // width: size.height * 0.045,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: AppColors.mint,
                                                      ),
                                                      child: const Center(
                                                          child: Icon(Icons.add,
                                                              color: AppColors
                                                                  .green,
                                                              size: 27)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: simpleTextBorderButton(
                context: context,
                color: AppColors.green,
                buttonLable: 'Confirm',
                height: size.height * 0.065,
                width: size.width,
                isLoadingWidget: false,
                onTap: () {
                  List<Product> groceryCartList = [];

                  for (var i = 0; i < groceryResult.length; i++) {
                    if (groceryResult[i].isAddedToShoppingList == true) {
                      groceryCartList.add(groceryResult[i]);
                    }
                  }

                  widget.groceryBloc.add(GroceryProductListEvent(
                      productList: groceryCartList,
                      productId: widget.productId));
                  Navigator.pop(context);
                },
                isDarkColor: true,
                isFillColor: true,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget myFilterView(String icon, String title, VoidCallback onTap) {
    return Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.mint, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(icon),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: FontUtils.h18(
                        fontColor: AppColors.green, fontWeight: FWT.semiBold),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.keyboard_arrow_right_rounded)
                ],
              ),
            ),
          ),
        ));
  }
}
