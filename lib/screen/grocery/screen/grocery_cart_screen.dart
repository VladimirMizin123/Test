import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_response_model.dart' as order;
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_choose_store_screen.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/item_catalog_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/checkout_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

import '../../restaurants/model/get_user_address_model.dart' as address;

// import 'package:gymeats_mobile/screen/restaurants/model/create_order_response_model.dart'
//     as order;

class GroceryCartScreen extends StatefulWidget {
  final GroceryCartScreenArguments? arguments;

  const GroceryCartScreen({super.key, this.arguments});

  @override
  State<GroceryCartScreen> createState() => _GroceryCartScreenState();
}

class _GroceryCartScreenState extends State<GroceryCartScreen> {
  GroceryBloc groceryBloc = GroceryBloc();
  List<Cart> selectedStoreProductList = [];
  List<GroceryDetails> edgesList = [];
  List<GroceryDetails> onlyProductList = [];
  List<GroceryDetails> allSearchRestaurantList = [];
  bool isSearchOn = false;
  bool loadCreateOrder = false;

  // bool createOrder = false;

  // List<GroceryDetails> onlyProductList = [];
  int selectedIndex = 0;
  address.UserAddress? getUserAddress;
  order.CreateOrderData? orderData;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      groceryBloc.add(GetUserAddressEvent());
      setState(() {
        edgesList = List.from(widget.arguments!.edgesList);
        for (var element in edgesList) {
          element.product = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<GroceryBloc, GroceryState>(
        bloc: groceryBloc,
        listener: (context, state) {
          // Address
          if (state is GetUserAddressSuccessState) {
            if (state.userAddress.isEmpty) {
            } else {
              /// address is primary then primary will be taken
              for (var i = 0; i < state.userAddress.length; i++) {
                if (state.userAddress[i].isPrimary == true) {
                  getUserAddress = state.userAddress[i];
                  break;
                }
              }

              /// address is not primary then first will be taken
              getUserAddress ??= state.userAddress[0];

              log("getUserAddress LISTENER:-------> ${getUserAddress?.latitude ?? '=='}  ${getUserAddress?.longitude ?? "00"}");
            }
          }

          if (state is CreateOrderLoadingState) {
            loadCreateOrder = true;
          }
          if (state is CreateOrderErrorState) {
            loadCreateOrder = false;
          }
          if (state is CreateOrderSuccessState) {
            orderData = state.orderData;
            if (orderData != null) {
              Get.to(
                () => CheckOutScreen(
                  isFromGrocery: true,
                  cartData: selectedStoreProductList,
                  orderData: orderData,
                  getUserAddress: getUserAddress,
                ),
              );
            }

            loadCreateOrder = false;
          }

          // STATE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          if (state is GrocerySelectedStoreEventState) {
            selectedStoreProductList = state.productsList;
          }
          if (state is GroceryProductListState) {
            print('==state.productList!.length===>${state.productList!.length}');
            if (state.productList?.isNotEmpty ?? false) {
              if (selectedIndex == 0) {
                for (var i = 0; i < edgesList.length; i++) {
                  if (edgesList[i].id == state.productId) {
                    edgesList[i].product = state.productList!.first;
                  }
                }
              } else {
                for (var i = 0; i < onlyProductList.length; i++) {
                  if (onlyProductList[i].id == state.productId) {
                    onlyProductList[i].product = state.productList!.first;
                  }
                }
              }
            }
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
                    SizedBox(
                      width: 40.w,
                      child: const BackButtonWidget(),
                    ),
                    Text('Grocery List', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                    SizedBox(
                      width: 40.w,
                    ),
                  ],
                ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                GestureDetector(
                  onTap: () {
                    ///clear cart and selected items
                    log(selectedStoreProductList.length.toString(), name: "Selected Length");
                    selectedIndex = 0;

                    if (selectedStoreProductList.length == 0) {
                      dataList1.clear();
                      dataList2.clear();
                      dataList3.clear();
                    } else {
                      selectedStoreProductList.forEach((element) {
                        log(element.store!.name.toString(), name: "Selected Length");
                      });
                      if (allData[0].isNotEmpty && selectedStoreProductList.any((element) => element.store!.name == allData[0][0].storeName)) {
                      } else {
                        log("CLEAR");

                        allData[0].clear();
                      }
                      if (allData[1].isNotEmpty && selectedStoreProductList.any((element) => element.store!.name == allData[1][0].storeName)) {
                      } else {
                        log("CLEAR");

                        allData[1].clear();
                      }
                      if (allData[2].isNotEmpty && selectedStoreProductList.any((element) => element.store!.name == allData[2][0].storeName)) {
                      } else {
                        log("CLEAR");
                        allData[2].clear();
                      }
                      // });
                      log((allData[0].isNotEmpty ? allData[0][0].storeName : 'DEFAULT').toString(), name: "All Data Length");

                      allData.sort((a, b) => b.length.compareTo(a.length));

                      log(selectedStoreProductList.length.toString(), name: "Selected Length");
                    }

                    Get.toNamed('/ChooseStoreScreen',
                        arguments: GroceryCartScreenArguments(
                          edgesList: widget.arguments!.edgesList,
                          askReceiveOrder: widget.arguments!.askReceiveOrder,
                          groceryBloc: groceryBloc,
                        ));
                  },
                  child: Container(
                    width: screenSize.width * 0.50,
                    decoration: BoxDecoration(
                        color: selectedStoreProductList.isEmpty ? AppColors.middleGray.withOpacity(0.10) : AppColors.mint,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: selectedStoreProductList.isEmpty ? AppColors.middleGray : AppColors.green)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const Icon(Icons.search, color: AppColors.green),
                          SvgPicture.asset(AssetsUtils.icLocation, color: selectedStoreProductList.isEmpty ? AppColors.middleGray : AppColors.green),
                          selectedStoreProductList.isEmpty
                              ? Text(
                                  'Choose a Store',
                                  style: FontUtils.h14(
                                      fontColor: selectedStoreProductList.isEmpty ? AppColors.middleGray : AppColors.green, fontWeight: FWT.semiBold),
                                )
                              : selectedStoreProductList[0].store!.logoPhotos == null
                                  ? const SizedBox()
                                  : CachedNetworkImage(
                                      height: 20,
                                      imageUrl: selectedStoreProductList[0].store!.logoPhotos![0],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(
                                        color: AppColors.lightGrey,
                                      )),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      boxShadow: boxShadowWidget,
                    ),
                    child: TextFormField(
                      readOnly: false,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search for item',
                        hintStyle: FontUtils.h16(),
                        border: InputBorder.none,
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          if (value!.isNotEmpty) {
                            isSearchOn = true;
                            allSearchRestaurantList = edgesList.where(
                              (element) {
                                return element.itemName!.toString().toLowerCase().contains(value.toLowerCase());
                              },
                            ).toList();

                            setState(() {});
                          } else {
                            isSearchOn = false;
                          }
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                selectedStoreProductList.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        height: 45,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedStoreProductList.isEmpty) {
                                        Fluttertoast.showToast(msg: 'Please, select a Store!');
                                      } else {
                                        setState(() {
                                          selectedIndex = 0;
                                          List.from(widget.arguments!.edgesList);
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: selectedIndex == 0 ? AppColors.coral : Colors.transparent,
                                          border: Border.all(
                                            color: selectedIndex == 0 ? Colors.transparent : AppColors.coral,
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Center(
                                          child: Text(
                                            'All',
                                            style: FontUtils.h15(fontColor: AppColors.terracotta),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                selectedStoreProductList.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: GestureDetector(
                                          onTap: () {
                                            // From 1 store only
                                            if (selectedStoreProductList.isEmpty) {
                                              Fluttertoast.showToast(msg: 'Please, select a Store!');
                                            } else {
                                              setState(() {
                                                selectedIndex = 1;
                                              });
                                              // selectedStoreProductList
                                              // List<GroceryShoppingData> edgesDList = [];
                                              onlyProductList.clear();
                                              // List<List<GroceryShoppingData>> dList = [];
                                              ///new Code
                                              if (allData[selectedIndex - 1].isNotEmpty) {
                                                widget.arguments!.edgesList.forEach((element) {
                                                  onlyProductList.add(element);
                                                });
                                              }

                                              ///old Code
                                              /*
                                                List<List<GroceryDetails>> dList =
                                                [];
                                                for (var i = 0;
                                                    i <
                                                        widget.arguments!
                                                            .edgesList.length;
                                                    i++) {
                                                  // List<GroceryShoppingData> singleDList = [];
                                                  List<GroceryDetails>
                                                      singleDList = [];
                                                  for (var j = 0;
                                                      j <
                                                          selectedStoreProductList
                                                              .length;
                                                      j++) {
                                                    log(selectedStoreProductList
                                                        .length
                                                        .toString());
                                                    for (var k = 0;
                                                        k <
                                                            selectedStoreProductList[
                                                                    j]
                                                                .groceryResult!
                                                                .length;
                                                        k++) {
                                                      for (var l = 0;
                                                          l <
                                                              selectedStoreProductList[
                                                                      j]
                                                                  .groceryResult![
                                                                      k]
                                                                  .products!
                                                                  .length;
                                                          l++) {
                                                        // print('${widget.arguments!.edgesList[i].productName} == ${selectedStoreProductList[j].groceryResult![k].products![l].itemName}');
                                                        if (widget
                                                                .arguments!
                                                                .edgesList[i]
                                                                .itemName ==
                                                            selectedStoreProductList[j]
                                                                .groceryResult![
                                                                    k]
                                                                .products![l]
                                                                .itemName) {
                                                          if (singleDList
                                                              .contains(widget
                                                                      .arguments!
                                                                      .edgesList[
                                                                  i])) {
                                                          } else {
                                                            singleDList.add(widget
                                                                .arguments!
                                                                .edgesList[i]);
                                                          }
                                                        } else {
                                                          // print('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
                                                        }
                                                      }
                                                    }
                                                  }
                                                  if (singleDList.isNotEmpty) {
                                                    dList.add(singleDList);
                                                  }
                                                }

                                                dList.sort((a, b) => a.length
                                                    .compareTo(b.length));
                                                if (dList.isNotEmpty) {
                                                  onlyProductList =
                                                      List.from(dList.first);
                                                }*/
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: selectedIndex == 1 ? AppColors.coral : Colors.transparent,
                                              border: Border.all(
                                                color: selectedIndex == 1 ? Colors.transparent : AppColors.coral,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: Center(
                                                  child: Text(
                                                'From ${allData[0].isNotEmpty ? allData[0][0].storeName ?? '' : "-"} store only',
                                                style: FontUtils.h15(fontColor: AppColors.terracotta),
                                              )),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                selectedStoreProductList.length >= 2
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: GestureDetector(
                                          onTap: () {
                                            // From 1 store only
                                            if (selectedStoreProductList.isEmpty) {
                                              Fluttertoast.showToast(msg: 'Please, select a Store!');
                                            } else {
                                              ///new code
                                              setState(() {
                                                selectedIndex = 2;
                                              });
                                              onlyProductList.clear();
                                              if (allData[selectedIndex - 1].isNotEmpty) {
                                                widget.arguments!.edgesList.forEach((element) {
                                                  onlyProductList.add(element);
                                                });
                                              }

                                              ///old code
                                              /* setState(() {
                                                selectedIndex = 2;
                                              });
                                              // selectedStoreProductList
                                              // List<GroceryShoppingData> edgesDList = [];
                                              onlyProductList.clear();
                                              // List<List<GroceryShoppingData>> dList = [];
                                              List<List<GroceryDetails>> dList =
                                                  [];
                                              for (var i = 0;
                                                  i <
                                                      widget.arguments!
                                                          .edgesList.length;
                                                  i++) {
                                                // List<GroceryShoppingData> singleDList = [];
                                                List<GroceryDetails>
                                                    singleDList = [];
                                                for (var j = 0;
                                                    j <
                                                        selectedStoreProductList
                                                            .length;
                                                    j++) {
                                                  for (var k = 0;
                                                      k <
                                                          selectedStoreProductList[
                                                                  j]
                                                              .groceryResult!
                                                              .length;
                                                      k++) {
                                                    for (var l = 0;
                                                        l <
                                                            selectedStoreProductList[
                                                                    j]
                                                                .groceryResult![
                                                                    k]
                                                                .products!
                                                                .length;
                                                        l++) {
                                                      if (widget
                                                              .arguments!
                                                              .edgesList[i]
                                                              .itemName ==
                                                          selectedStoreProductList[
                                                                  j]
                                                              .groceryResult![k]
                                                              .products![l]
                                                              .itemName) {
                                                        if (singleDList
                                                            .contains(widget
                                                                    .arguments!
                                                                    .edgesList[
                                                                i])) {
                                                        } else {
                                                          singleDList.add(widget
                                                              .arguments!
                                                              .edgesList[i]);
                                                        }
                                                      } else {
                                                        // print('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
                                                      }
                                                    }
                                                  }
                                                }
                                                if (singleDList.isNotEmpty) {
                                                  dList.add(singleDList);
                                                }
                                              }

                                              dList.sort((a, b) =>
                                                  b.length.compareTo(a.length));
                                              if (dList.isNotEmpty) {
                                                for (var i = 0;
                                                    i < dList.length;
                                                    i++) {
                                                  if (i == 0) {
                                                    onlyProductList
                                                        .addAll(dList[i]);
                                                  } else if (i == 1) {
                                                    onlyProductList
                                                        .addAll(dList[i]);
                                                  } else {
                                                    return;
                                                  }
                                                }
                                              }*/
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: selectedIndex == 2 ? AppColors.coral : Colors.transparent,
                                              border: Border.all(
                                                color: selectedIndex == 2 ? Colors.transparent : AppColors.coral,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: Center(
                                                  child: Text(
                                                'From ${allData[1].isNotEmpty ? allData[1][0].storeName ?? '' : "-"} store only',
                                                style: FontUtils.h15(fontColor: AppColors.terracotta),
                                              )),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                selectedStoreProductList.length >= 3
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: GestureDetector(
                                          onTap: () {
                                            // From 1 store only
                                            if (selectedStoreProductList.isEmpty) {
                                              Fluttertoast.showToast(msg: 'Please, select a Store!');
                                            } else {
                                              setState(() {
                                                selectedIndex = 3;
                                              });
                                              // selectedStoreProductList
                                              // List<GroceryShoppingData> edgesDList = [];
                                              onlyProductList.clear();
                                              // List<List<GroceryShoppingData>> dList = [];
                                              ///new Code
                                              if (allData[selectedIndex - 1].isNotEmpty) {
                                                widget.arguments!.edgesList.forEach((element) {
                                                  onlyProductList.add(element);
                                                });
                                              }
                                              /*  List<List<GroceryDetails>> dList =
                                                  [];
                                              for (var i = 0;
                                                  i <
                                                      widget.arguments!
                                                          .edgesList.length;
                                                  i++) {
                                                List<GroceryDetails>
                                                    singleDList = [];
                                                for (var j = 0;
                                                    j <
                                                        selectedStoreProductList
                                                            .length;
                                                    j++) {
                                                  for (var k = 0;
                                                      k <
                                                          selectedStoreProductList[
                                                                  j]
                                                              .groceryResult!
                                                              .length;
                                                      k++) {
                                                    for (var l = 0;
                                                        l <
                                                            selectedStoreProductList[
                                                                    j]
                                                                .groceryResult![
                                                                    k]
                                                                .products!
                                                                .length;
                                                        l++) {
                                                      if (widget
                                                              .arguments!
                                                              .edgesList[i]
                                                              .itemName ==
                                                          selectedStoreProductList[
                                                                  j]
                                                              .groceryResult![k]
                                                              .products![l]
                                                              .itemName) {
                                                        if (singleDList
                                                            .contains(widget
                                                                    .arguments!
                                                                    .edgesList[
                                                                i])) {
                                                        } else {
                                                          singleDList.add(widget
                                                              .arguments!
                                                              .edgesList[i]);
                                                        }
                                                      } else {
                                                        // print('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
                                                      }
                                                    }
                                                  }
                                                }
                                                if (singleDList.isNotEmpty) {
                                                  dList.add(singleDList);
                                                }
                                              }

                                              // dList.sort((a, b) => a.length
                                              //     .compareTo(b.length));
                                              // if (dList.isNotEmpty) {
                                              //   for (var i = 0;
                                              //       i < dList.length;
                                              //       i++) {
                                              //     if (i == 0) {
                                              //       onlyProductList
                                              //           .addAll(dList[i]);
                                              //     } else if (i == 1) {
                                              //       onlyProductList
                                              //           .addAll(dList[i]);
                                              //     } else if (i == 2) {
                                              //       onlyProductList
                                              //           .addAll(dList[i]);
                                              //     } else {
                                              //       return;
                                              //     }
                                              //   }
                                              // }*/
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: selectedIndex == 3 ? AppColors.coral : Colors.transparent,
                                              border: Border.all(
                                                color: selectedIndex == 3 ? Colors.transparent : AppColors.coral,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: Center(
                                                  child: Text(
                                                'From ${allData[2].isNotEmpty ? allData[2][0].storeName ?? '' : "-"} store only',
                                                style: FontUtils.h15(fontColor: AppColors.terracotta),
                                              )),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            )
                            // ListView.builder(
                            //     itemCount: 5,
                            //     shrinkWrap: true,
                            //     physics: const BouncingScrollPhysics(),
                            //     scrollDirection: Axis.horizontal,
                            //     itemBuilder: (context, index) {
                            //       return Padding(
                            //         padding: const EdgeInsets.symmetric(horizontal: 4),
                            //         child: Container(
                            //           height: 40,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(50),
                            //             color: AppColors.coral,
                            //           ),
                            //           child: Padding(
                            //             padding: const EdgeInsets.symmetric(horizontal: 20),
                            //             child: Center(
                            //                 child: Text(
                            //               'From 1 store only',
                            //               style: FontUtils.h15(fontColor: AppColors.terracotta),
                            //             )),
                            //           ),
                            //         ),
                            //       );
                            //     }),
                            ),
                      ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${selectedIndex == 0 ? edgesList.length : onlyProductList.length} Items',
                      style: FontUtils.h18(fontColor: AppColors.middleGray),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                /// Display Data -------------------------------------------------------------------
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: isSearchOn == true
                            ? displayData(displayData: allSearchRestaurantList, hello: "123")
                            : selectedIndex == 0
                                ? displayData(displayData: edgesList, hello: "456")
                                : displayData(displayData: onlyProductList, hello: "789")),
                  ),
                ),
                Container(
                  color: AppColors.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: FontUtils.h20(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                            ),
                            Text(
                              '\$ ${totalAmount(edgesList).toStringAsFixed(2)}',
                              style: FontUtils.h22(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        loadCreateOrder == true
                            ? const Center(child: CircularProgressIndicator())
                            : simpleTextBorderButton(
                                context: context,
                                color: edgesList.indexWhere((element) => element.product == null) < 0 ? AppColors.green : AppColors.gray,
                                buttonLable: 'Checkout',
                                height: screenSize.height * 0.065,
                                width: screenSize.width,
                                isLoadingWidget: false,
                                onTap: () {
                                  loadCreateOrder = true;

                                  setState(() {});
                                  int emptyIndex = edgesList.indexWhere((element) => element.product == null);

                                  if (emptyIndex < 0) {
                                    if (getUserAddress == null) {
                                      Fluttertoast.showToast(
                                        msg: 'Please Select Address For Order',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      List<CreateOrderGroceryItems> data = [];

                                      for (var element in edgesList) {
                                        data.add(
                                          CreateOrderGroceryItems(
                                            productId: element.product?.productId,
                                            productType: 2,
                                            quantity: element.product?.cartItemCount,
                                            notes: '',
                                            productMarkedPrice: element.product?.originalPrice,
                                            selectedOptions: [],
                                          ),
                                        );
                                      }

                                      groceryBloc.add(
                                        CreateOrderEvent(
                                          createGroceryOrderModel: CreateGroceryOrderModel(
                                            userId: userId,
                                            pickup: widget.arguments!.askReceiveOrder.index == 0 ? false : true,
                                            groceryItems: data,
                                            userAddress: UserAddress(
                                              streetName: getUserAddress?.streetName ?? '',
                                              streetNum: getUserAddress?.streetNum ?? '',
                                              latitude: (getUserAddress?.latitude ?? 0.0),
                                              longitude: (getUserAddress?.longitude ?? 0.0),
                                              city: getUserAddress?.city ?? '',
                                              country: getUserAddress?.country ?? '',
                                              state: getUserAddress?.state ?? "",
                                              zipcode: getUserAddress?.zipcode ?? '',
                                            ),
                                            userPhone: 1234567890,
                                            driverTipCents: 0,
                                            pickupTipCents: 0,
                                            userDropoffNotes: '',
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    Fluttertoast.showToast(msg: 'Please, select the product!');
                                  }
                                  // loadCreateOrder = false;
                                  // setState(() {});
                                },
                                isDarkColor: true,
                                isFillColor: true,
                              ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget myItemChooseWidget(Size screenSize, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FontUtils.h16(fontColor: AppColors.black),
          ),
          const SizedBox(height: 5),
          Container(
            height: screenSize.height * 0.06,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.errorColor),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.lightGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose',
                    style: FontUtils.h16(fontColor: AppColors.black),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.black)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 1.2),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

// Total Amount

  double totalAmount(List<GroceryDetails> edgesList) {
    // '\$ ${(((edgesList[index].product!.price ?? 0) / 100) * edgesList[index].product!.cartItemCount).toStringAsFixed(2)}', //

    double total = 0;
    for (var i = 0; i < edgesList.length; i++) {
      if (edgesList[i].product != null) {
        total = total + ((edgesList[i].product!.price! / 100) * edgesList[i].product!.cartItemCount);
      }
    }
    return total;
  }

  Widget displayData({List<GroceryDetails>? displayData, required String hello}) {
    log(hello, name: "CHECK");
    final screenSize = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: displayData!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return displayData[index].product != null &&
                  (selectedIndex >= 1 && allData[selectedIndex - 1].contains(displayData[index].product) || selectedIndex == 0)
              ? Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          height: 130,
                          width: 130,
                          imageUrl: displayData[index].product!.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.lightGrey,
                          )),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        // Image(
                        //   image: NetworkImage(displayData[index].cartData!.image!),
                        //   height: 130,
                        //   width: 130, fit: BoxFit.cover,
                        // ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayData[index].product!.itemName ?? '', // 'Milk Almond Breeze 500ml, 1.5% fat',
                                textAlign: TextAlign.start,
                                style: FontUtils.h17(
                                  fontColor: AppColors.darkGray,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    color: AppColors.terracotta,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Available in: ',
                                    style: FontUtils.h12(
                                      fontColor: AppColors.middleGray,
                                      fontWeight: FWT.semiBold,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      displayData[index].product!.storeName ?? '',
                                      style: FontUtils.h12(
                                        fontColor: AppColors.black,
                                        fontWeight: FWT.semiBold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '\$ ${(((displayData[index].product!.price ?? 0) / 100) * displayData[index].product!.cartItemCount).toStringAsFixed(2)}', // '\$ 5.99',
                          style: FontUtils.h17(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration:
                                BoxDecoration(border: Border.all(color: AppColors.switchColor, width: 1.2), borderRadius: BorderRadius.circular(6)),
                            height: screenSize.height * 0.070,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Product 1',
                                    style: FontUtils.h18(fontColor: AppColors.black),
                                  ),
                                  const Icon(Icons.check_circle_outline_outlined, size: 30, color: AppColors.switchColor)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: displayData[index].product!.cartItemCount == 1
                              ? GestureDetector(
                                  onTap: () {
                                    for (var element in selectedStoreProductList) {
                                      element.groceryResult?.forEach((groceryItem) {
                                        final products = groceryItem.products;
                                        if (products != null) {
                                          for (var productsItem in products) {
                                            if (productsItem.productId == displayData[index].product?.productId) {
                                              productsItem.cartItemCount = 1;
                                              productsItem.isAddedToShoppingList = false;
                                            }
                                          }
                                        }
                                      });
                                    }

                                    setState(() {
                                      displayData[index].product = null;
                                    });
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.070,
                                    width: screenSize.height * 0.070,
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(10)),
                                    child: Center(child: SvgPicture.asset(AssetsUtils.icDelete)),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      displayData[index].product!.cartItemCount--;
                                    });
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.070,
                                    // width: size.height * 0.045,
                                    decoration:
                                        BoxDecoration(border: Border.all(color: AppColors.mint, width: 2), borderRadius: BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Icon(Icons.remove, size: 27),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Container(
                            height: screenSize.height * 0.070,
                            // width: size.height * 0.045,

                            decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              displayData[index].product!.cartItemCount.toString(),
                              style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                            )),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                displayData[index].product?.cartItemCount++;
                              });
                            },
                            child: Container(
                              height: screenSize.height * 0.070,
                              // width: size.height * 0.045,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.mint,
                              ),
                              child: const Center(child: Icon(Icons.add, color: AppColors.green, size: 27)),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 1.2),
                  ],
                )
              : myItemChooseWidget(screenSize, displayData[index].itemName ?? '', () {
                  // Get.toNamed('/ItemCatalogScreen');
                  if (selectedStoreProductList.isNotEmpty) {
                    print("StoreName:- ${selectedStoreProductList[0].store!.name ?? ''}");
                    print("itemName:- ${displayData[index].itemName ?? ''}");
                    log(selectedIndex.toString(), name: "selectedIndex");

                    filterList() {
                      List<Product> productList = [];
                      if (selectedIndex != 0) {
                        if (selectedIndex == 1) {
                          allData[0].forEach((element) {
                            if ((element.itemName ?? '').toLowerCase().contains(displayData[index].itemName ?? '')) {
                              productList.add(element);
                            }
                          });
                        } else if (selectedIndex == 2) {
                          allData[1].forEach((element) {
                            if ((element.itemName ?? '').toLowerCase().contains(displayData[index].itemName ?? '')) {
                              productList.add(element);
                            }
                          });
                        } else {
                          allData[2].forEach((element) {
                            if ((element.itemName ?? '').toLowerCase().contains(displayData[index].itemName ?? '')) {
                              productList.add(element);
                            }
                          });
                        }
                        log(productList.toString());
                        return productList;
                      } else {
                        return null;
                      }
                    }

                    Get.to(() => ItemCatalogScreen(
                          selectedStoreProductList: selectedStoreProductList,
                          productList: selectedIndex != 0 /*&& selectedIndex != 3*/
                              ? /*selectedIndex == 1
                                  ? */
                              filterList()
                              /* : selectedIndex == 2
                                      ? (allData[selectedIndex - 2] +
                                          allData[selectedIndex - 1])
                                      : null*/
                              : null,
                          groceryBloc: groceryBloc,
                          productId: displayData[index].id,
                          typeOfProduct: displayData[index].itemName ?? '',
                        ));
                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ;
                    }));*/
                  } else {
                    Fluttertoast.showToast(msg: 'Please, Select Store!');
                  }
                });
        });
  }
}

class GroceryCartScreenArguments {
  // final List<GroceryShoppingData> edgesList;
  final List<GroceryDetails> edgesList;
  final AskReceiveOrder askReceiveOrder;
  final GroceryBloc? groceryBloc;

  GroceryCartScreenArguments({required this.edgesList, required this.askReceiveOrder, this.groceryBloc});
}
