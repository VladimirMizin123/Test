import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_cart_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_bloc.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart'
    as getresAddress;
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as userAddress;

//TEMP

List<Product> dataList1 = [];
List<Product> dataList2 = [];
List<Product> dataList3 = [];
List<List<Product>> allData = [dataList1, dataList2, dataList3];

class ChooseStoreScreen extends StatefulWidget {
  final GroceryCartScreenArguments? arguments;
  const ChooseStoreScreen({super.key, this.arguments});

  @override
  State<ChooseStoreScreen> createState() => _ChooseStoreScreenState();
}

class _ChooseStoreScreenState extends State<ChooseStoreScreen> {
  int selectedStoreCount = 0;

  List<Cart> productsList = [];
  List<Cart> searchedProductsList = [];
  RestaurantBloc restaurantBloc = RestaurantBloc();

  bool isSearchOn = false;
  userAddress.UserAddress? getUserAddress;
  List<GrocerySearchModel> edgesDummyList = [];
  @override
  void initState() {
    super.initState();
    /* dataList1.clear();
    dataList2.clear();
    dataList3.clear();*/
    log(dataList1.length.toString(), name: "DATA LIST 1");
    log(dataList2.length.toString(), name: "DATA LIST 2");
    log(dataList3.length.toString(), name: "DATA LIST 3");
    searchStore();
  }

  searchStore() {
    for (var i = 0; i < widget.arguments!.edgesList.length; i++) {
      edgesDummyList.add(GrocerySearchModel(
        groceryName: widget.arguments!.edgesList[i].itemName,
        quantity: 0,
      ));
    }

    // log("init:${widget.arguments?.getUserAddress?.toJson()}");

    widget.arguments!.groceryBloc!.add(GrocerySearchEvent(
        grocerySearchModelList: edgesDummyList,
        getUserAddress: widget.arguments?.getUserAddress));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocConsumer<GroceryBloc, GroceryState>(
        bloc: widget.arguments!.groceryBloc!,
        listener: (context, state) {
          if (state is GrocerySearchSuccessState) {
            productsList = state.groceryMultiSearchProductList ?? [];
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40.w,
                        child: const BackButtonWidget(),
                      ),
                      Image.asset(
                        AssetsUtils.gymEatsLogo,
                        height: 35.h,
                        color: AppColors.green,
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                  const SizedBox(height: 10),
                  Text(
                    'Choose a Store',
                    style: FontUtils.h24(
                        fontColor: AppColors.green, fontWeight: FWT.semiBold),
                  ),
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
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? value) {
                          setState(() {
                            if (value!.isEmpty) {
                              isSearchOn = false;
                            } else {
                              isSearchOn = true;
                              searchedProductsList = productsList
                                  .where((item) => item.store!.name!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.darkGray),
                          hintText: 'Search store here...',
                          hintStyle:
                              FontUtils.h16(fontColor: AppColors.middleGray),
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
                    child: productsList.isEmpty
                        ? state is GrocerySearchLoadingState
                            ? const AppCenterLoader()
                            : Center(
                                child: Text(
                                  'No Data Found!',
                                  style:
                                      FontUtils.h14(fontColor: AppColors.black),
                                ),
                              )
                        : isSearchOn
                            ? searchedProductsList.isNotEmpty
                                ? SingleChildScrollView(
                                    child: ListView.builder(
                                      itemCount: searchedProductsList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: boxShadowWidget,
                                                  color: AppColors.whiteColor,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                                  child: Row(
                                                    children: [
                                                      // const Expanded(flex: 4, child: Center(child: Image(image: AssetImage(AssetsUtils.icDemoIcon)))),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Center(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  productsList[
                                                                          index]
                                                                      .store!
                                                                      .logoPhotos![0],
                                                              height: 60.h,
                                                              // width: 40.h,
                                                              fit: BoxFit.cover,
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Center(
                                                                      child: Icon(
                                                                          Icons
                                                                              .error)),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                color: AppColors
                                                                    .lightGrey,
                                                              )),
                                                            ),
                                                            // Image(
                                                            //   image: NetworkImage(searchedProductsList[index].store!.logoPhotos![0]),
                                                            //   height: 60.h,
                                                            //   // width: 40.h,
                                                            //   fit: BoxFit.cover,
                                                            // ),
                                                          )),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              productsList[
                                                                          index]
                                                                      .store!
                                                                      .name ??
                                                                  '', // 'The nearest time for pickup,',
                                                              style: FontUtils.h14(
                                                                  fontColor:
                                                                      AppColors
                                                                          .black),
                                                            ),
                                                            Text(
                                                              'tomorrow at 10am',
                                                              style: FontUtils.h12(
                                                                  fontColor:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight: FWT
                                                                      .semiBold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (searchedProductsList[
                                                                      index]
                                                                  .store!
                                                                  .isSelected) {
                                                                if (selectedStoreCount ==
                                                                    0) {
                                                                } else {
                                                                  searchedProductsList[
                                                                          index]
                                                                      .store!
                                                                      .isSelected = false;
                                                                  selectedStoreCount =
                                                                      selectedStoreCount -
                                                                          1;
                                                                }
                                                              } else {
                                                                if (selectedStoreCount ==
                                                                    3) {
                                                                } else {
                                                                  searchedProductsList[
                                                                          index]
                                                                      .store!
                                                                      .isSelected = true;
                                                                  selectedStoreCount =
                                                                      selectedStoreCount +
                                                                          1;
                                                                }
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 22.h,
                                                            width: 22.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .primaryBlue,
                                                                  width: 2),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Visibility(
                                                                  visible: searchedProductsList[
                                                                          index]
                                                                      .store!
                                                                      .isSelected,
                                                                  child:
                                                                      Container(
                                                                    decoration: const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: AppColors
                                                                            .primaryBlue),
                                                                    height:
                                                                        14.h,
                                                                    width: 14.w,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Text(
                                    'No Search Found!',
                                    style: TextStyle(color: Colors.black),
                                  )
                            : SingleChildScrollView(
                                child: ListView.builder(
                                  itemCount: productsList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    /*if(dataList1.isNotEmpty){
                                          if(dataList1[0].storeName ==  productsList[
                                          index]
                                              .store!.name){productsList[
                                          index]
                                              .store!
                                              .isSelected = true;}
                  
                                        }
                                        if(dataList2.isNotEmpty){}
                                        if(dataList3.isNotEmpty){}*/
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              boxShadow: boxShadowWidget,
                                              color: AppColors.whiteColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                              child: Row(
                                                children: [
                                                  // const Expanded(flex: 4, child: Center(child: Image(image: AssetImage(AssetsUtils.icDemoIcon)))),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Center(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: productsList[
                                                                          index]
                                                                      .store!
                                                                      .logoPhotos?[
                                                                  0] ??
                                                              '',
                                                          height: 60.h,
                                                          // width: 40.h,
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Center(
                                                                  child: Icon(Icons
                                                                      .error)),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                            color: AppColors
                                                                .lightGrey,
                                                          )),
                                                        ),
                                                        // Image(
                                                        //   image: NetworkImage(productsList[index].store!.logoPhotos![0]),
                                                        //   height: 60.h,
                                                        //   // width: 40.h,
                                                        //   fit: BoxFit.cover,
                                                        // ),
                                                      )),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          productsList[index]
                                                                  .store!
                                                                  .name ??
                                                              '', // 'The nearest time for pickup,',
                                                          style: FontUtils.h14(
                                                              fontColor:
                                                                  AppColors
                                                                      .black),
                                                        ),
                                                        Text(
                                                          'tomorrow at 10am',
                                                          style: FontUtils.h12(
                                                              fontColor:
                                                                  AppColors
                                                                      .black,
                                                              fontWeight:
                                                                  FWT.semiBold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (productsList[
                                                                  index]
                                                              .store!
                                                              .isSelected) {
                                                            if (selectedStoreCount ==
                                                                0) {
                                                            } else {
                                                              productsList[
                                                                          index]
                                                                      .store!
                                                                      .isSelected =
                                                                  false;
                                                              if (selectedStoreCount ==
                                                                  1) {
                                                                dataList1
                                                                    .clear();
                                                              }
                                                              if (selectedStoreCount ==
                                                                  2) {
                                                                dataList2
                                                                    .clear();
                                                              }
                                                              if (selectedStoreCount ==
                                                                  3) {
                                                                dataList3
                                                                    .clear();
                                                              }
                                                              selectedStoreCount =
                                                                  selectedStoreCount -
                                                                      1;
                                                            }
                                                          } else {
                                                            if (selectedStoreCount ==
                                                                3) {
                                                            } else {
                                                              productsList[
                                                                          index]
                                                                      .store!
                                                                      .isSelected =
                                                                  true;
                                                              selectedStoreCount =
                                                                  selectedStoreCount +
                                                                      1;
                                                              log(selectedStoreCount
                                                                  .toString());
                                                              if (selectedStoreCount ==
                                                                  1) {
                                                                dataList1
                                                                    .clear();
                                                                log("CLEAR");
                                                                (productsList[index]
                                                                            .groceryResult ??
                                                                        [])
                                                                    .forEach(
                                                                        (grocery) {
                                                                  log("ADD");
                                                                  (grocery.products ??
                                                                          [])
                                                                      .forEach(
                                                                          (element) {
                                                                    element
                                                                        .storeName = productsList[index]
                                                                            .store
                                                                            ?.name ??
                                                                        '';
                                                                    dataList1.add(
                                                                        element);
                                                                  });
                                                                });
                                                              }
                                                              if (selectedStoreCount ==
                                                                  2) {
                                                                dataList2
                                                                    .clear();
                                                                (productsList[index]
                                                                            .groceryResult ??
                                                                        [])
                                                                    .forEach(
                                                                        (grocery) {
                                                                  (grocery.products ??
                                                                          [])
                                                                      .forEach(
                                                                          (element) {
                                                                    element
                                                                        .storeName = productsList[index]
                                                                            .store
                                                                            ?.name ??
                                                                        '';
                                                                    dataList2.add(
                                                                        element);
                                                                  });
                                                                });
                                                              }
                                                              if (selectedStoreCount ==
                                                                  3) {
                                                                dataList3
                                                                    .clear();
                                                                (productsList[index]
                                                                            .groceryResult ??
                                                                        [])
                                                                    .forEach(
                                                                        (grocery) {
                                                                  (grocery.products ??
                                                                          [])
                                                                      .forEach(
                                                                          (element) {
                                                                    element
                                                                        .storeName = productsList[index]
                                                                            .store
                                                                            ?.name ??
                                                                        '';
                                                                    dataList3.add(
                                                                        element);
                                                                  });
                                                                });
                                                              }

                                                              /// Create Seperate List
                                                            }
                                                          }
                                                        });
                                                        allData.sort((a, b) =>
                                                            b.length.compareTo(
                                                                a.length));
                                                        log(
                                                            dataList1.length
                                                                .toString(),
                                                            name:
                                                                "DATA LIST 1");
                                                        log(
                                                            dataList2.length
                                                                .toString(),
                                                            name:
                                                                "DATA LIST 2");
                                                        log(
                                                            dataList3.length
                                                                .toString(),
                                                            name:
                                                                "DATA LIST 2");

                                                        log(
                                                            productsList[index]
                                                                .groceryResult![
                                                                    0]
                                                                .products!
                                                                .length
                                                                .toString(),
                                                            name:
                                                                "productsList");
                                                      },
                                                      child: Container(
                                                        height: 22.h,
                                                        width: 22.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .primaryBlue,
                                                              width: 2),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Visibility(
                                                              visible:
                                                                  productsList[
                                                                          index]
                                                                      .store!
                                                                      .isSelected,
                                                              child: Container(
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: AppColors
                                                                        .primaryBlue),
                                                                height: 14.h,
                                                                width: 14.w,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: simpleTextBorderButton(
                      context: context,
                      color: AppColors.green,
                      buttonLable: 'Confirm',
                      height: screenSize.height * 0.065,
                      width: screenSize.width,
                      isLoadingWidget: false,
                      onTap: () {
                        List<Cart> selectedProductStore = [];
                        for (var i = 0; i < productsList.length; i++) {
                          if (productsList[i].store!.isSelected) {
                            selectedProductStore.add(productsList[i]);
                          }
                        }

                        widget.arguments!.groceryBloc!.add(
                            GrocerySelectedStoreEvent(
                                productsList: selectedProductStore));
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
        });
  }
}
