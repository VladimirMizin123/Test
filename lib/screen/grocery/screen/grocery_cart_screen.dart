import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/item_catalog_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

class GroceryCartScreen extends StatefulWidget {
  final GroceryCartScreenArguments? arguments;
  const GroceryCartScreen({super.key, this.arguments});

  @override
  State<GroceryCartScreen> createState() => _GroceryCartScreenState();
}

class _GroceryCartScreenState extends State<GroceryCartScreen> {
  List<String> productList = [
    'Product 1',
    'Product 2',
    'Product 3',
    'Product 4',
    'Product 5'
  ];
  GroceryBloc groceryBloc = GroceryBloc();
  List<GrocerySearchModel> grocerySearchModalDataList = [];
  List<Product>? groceryMultiSearchStoreProductListList = [];
  List<Cart> selectedStoreProductList = [];
  List<GroceryDetails> edgesList = [];
  List<GroceryDetails> onlyProductList = [];
  // List<GroceryDetails> onlyProductList = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        print('askReceiveOrder==>${widget.arguments!.askReceiveOrder}');
        edgesList = List.from(widget.arguments!.edgesList);
        for (var element in edgesList) {
          element.product = null;
          print('==element.toJson();==>${element.toJson()}');
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
            // STATE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            if (state is GrocerySelectedStoreEventState) {
              selectedStoreProductList = state.productsList;
            }
            if (state is GroceryProductListState) {
              print(
                  '==state.productList!.length===>${state.productList!.length}');
              if (state.productList?.isNotEmpty ?? false) {
                if (selectedIndex == 0) {
                  for (var i = 0; i < edgesList.length; i++) {
                    if (i == state.index) {
                      edgesList[i].product = state.productList!.first;
                    }
                  }
                } else {
                  for (var i = 0; i < onlyProductList.length; i++) {
                    if (i == state.index) {
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
                      const BackButtonWidget(),
                      Text('Grocery List',
                          style: FontUtils.h20(
                              fontColor: AppColors.oxFF010101,
                              fontWeight: FWT.semiBold)),
                      Text('Edit',
                          style:
                              FontUtils.h16(fontColor: AppColors.oxFF010101)),
                    ],
                  ).paddingSymmetric(horizontal: 6, vertical: 5.h),
                  GestureDetector(
                    onTap: () {
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
                          color: selectedStoreProductList.isEmpty
                              ? AppColors.middleGray.withOpacity(0.10)
                              : AppColors.mint,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: selectedStoreProductList.isEmpty
                                  ? AppColors.middleGray
                                  : AppColors.green)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // const Icon(Icons.search, color: AppColors.green),
                            SvgPicture.asset(AssetsUtils.icLocation,
                                color: selectedStoreProductList.isEmpty
                                    ? AppColors.middleGray
                                    : AppColors.green),
                            selectedStoreProductList.isEmpty
                                ? Text(
                                    'Choose a Store',
                                    style: FontUtils.h14(
                                        fontColor:
                                            selectedStoreProductList.isEmpty
                                                ? AppColors.middleGray
                                                : AppColors.green,
                                        fontWeight: FWT.semiBold),
                                  )
                                : selectedStoreProductList[0]
                                            .store!
                                            .logoPhotos ==
                                        null
                                    ? const SizedBox()
                                    : CachedNetworkImage(
                                        height: 20,
                                        imageUrl: selectedStoreProductList[0]
                                            .store!
                                            .logoPhotos![0],
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: boxShadowWidget,
                      ),
                      child: TextFormField(
                        onTap: () {},
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedStoreProductList.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: 'Please, select a Store!');
                                        } else {
                                          setState(() {
                                            selectedIndex = 0;
                                            List.from(
                                                widget.arguments!.edgesList);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: selectedIndex == 0
                                                ? AppColors.coral
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: selectedIndex == 0
                                                  ? Colors.transparent
                                                  : AppColors.coral,
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Center(
                                              child: Text(
                                            'All',
                                            style: FontUtils.h15(
                                                fontColor:
                                                    AppColors.terracotta),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  selectedStoreProductList.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: GestureDetector(
                                            onTap: () {
                                              // From 1 store only
                                              if (selectedStoreProductList
                                                  .isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Please, select a Store!');
                                              } else {
                                                setState(() {
                                                  selectedIndex = 1;
                                                });
                                                // selectedStoreProductList
                                                // List<GroceryShoppingData> edgesDList = [];
                                                onlyProductList.clear();
                                                // List<List<GroceryShoppingData>> dList = [];
                                                List<List<GroceryDetails>>
                                                    dList = [];
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
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: selectedIndex == 1
                                                    ? AppColors.coral
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: selectedIndex == 1
                                                      ? Colors.transparent
                                                      : AppColors.coral,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Center(
                                                    child: Text(
                                                  'From 1 store only',
                                                  style: FontUtils.h15(
                                                      fontColor:
                                                          AppColors.terracotta),
                                                )),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  selectedStoreProductList.length >= 2
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: GestureDetector(
                                            onTap: () {
                                              // From 1 store only
                                              if (selectedStoreProductList
                                                  .isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Please, select a Store!');
                                              } else {
                                                setState(() {
                                                  selectedIndex = 2;
                                                });
                                                // selectedStoreProductList
                                                // List<GroceryShoppingData> edgesDList = [];
                                                onlyProductList.clear();
                                                // List<List<GroceryShoppingData>> dList = [];
                                                List<List<GroceryDetails>>
                                                    dList = [];
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
                                                //     } else {
                                                //       return;
                                                //     }
                                                //   }
                                                // }
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: selectedIndex == 2
                                                    ? AppColors.coral
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: selectedIndex == 2
                                                      ? Colors.transparent
                                                      : AppColors.coral,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Center(
                                                    child: Text(
                                                  'From 2 store only',
                                                  style: FontUtils.h15(
                                                      fontColor:
                                                          AppColors.terracotta),
                                                )),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  selectedStoreProductList.length >= 3
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: GestureDetector(
                                            onTap: () {
                                              // From 1 store only
                                              if (selectedStoreProductList
                                                  .isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Please, select a Store!');
                                              } else {
                                                setState(() {
                                                  selectedIndex = 3;
                                                });
                                                // selectedStoreProductList
                                                // List<GroceryShoppingData> edgesDList = [];
                                                onlyProductList.clear();
                                                List<List<GroceryDetails>>
                                                    dList = [];
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
                                                // }
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: selectedIndex == 3
                                                    ? AppColors.coral
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: selectedIndex == 3
                                                      ? Colors.transparent
                                                      : AppColors.coral,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Center(
                                                    child: Text(
                                                  'From 3 store only',
                                                  style: FontUtils.h15(
                                                      fontColor:
                                                          AppColors.terracotta),
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
                  Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: selectedIndex == 0
                                ? ListView.builder(
                                    itemCount: edgesList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return edgesList[index].product != null
                                          ? Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CachedNetworkImage(
                                                      height: 130,
                                                      width: 130,
                                                      imageUrl: edgesList[index]
                                                          .product!
                                                          .image!,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color:
                                                            AppColors.lightGrey,
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                    // Image(
                                                    //   image: NetworkImage(edgesList[index].cartData!.image!),
                                                    //   height: 130,
                                                    //   width: 130, fit: BoxFit.cover,
                                                    // ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            edgesList[index]
                                                                    .product!
                                                                    .itemName ??
                                                                '', // 'Milk Almond Breeze 500ml, 1.5% fat',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FontUtils.h17(
                                                                fontColor:
                                                                    AppColors
                                                                        .darkGray),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Icon(
                                                                  Icons
                                                                      .info_outline_rounded,
                                                                  color: AppColors
                                                                      .terracotta,
                                                                  size: 20),
                                                              const SizedBox(
                                                                  width: 3),
                                                              Text(
                                                                'Available in: ',
                                                                style: FontUtils.h12(
                                                                    fontColor:
                                                                        AppColors
                                                                            .middleGray,
                                                                    fontWeight:
                                                                        FWT.semiBold),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  selectedStoreProductList[
                                                                              0]
                                                                          .store!
                                                                          .name ??
                                                                      '',
                                                                  style: FontUtils.h12(
                                                                      fontColor:
                                                                          AppColors
                                                                              .black,
                                                                      fontWeight:
                                                                          FWT.semiBold),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      '\$ ${(((edgesList[index].product!.price ?? 0) / 100) * edgesList[index].product!.cartItemCount).toStringAsFixed(2)}', // '\$ 5.99',
                                                      style: FontUtils.h17(
                                                          fontColor: AppColors
                                                              .darkGray,
                                                          fontWeight:
                                                              FWT.semiBold),
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
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .switchColor,
                                                                width: 1.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                        height:
                                                            screenSize.height *
                                                                0.070,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      12),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Product 1',
                                                                style: FontUtils.h18(
                                                                    fontColor:
                                                                        AppColors
                                                                            .black),
                                                              ),
                                                              const Icon(
                                                                  Icons
                                                                      .check_circle_outline_outlined,
                                                                  size: 30,
                                                                  color: AppColors
                                                                      .switchColor)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: edgesList[index]
                                                                  .product!
                                                                  .cartItemCount ==
                                                              1
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  edgesList[index]
                                                                          .product =
                                                                      null;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: screenSize
                                                                        .height *
                                                                    0.070,
                                                                width: screenSize
                                                                        .height *
                                                                    0.070,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColors
                                                                            .disable),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Center(
                                                                    child: SvgPicture.asset(
                                                                        AssetsUtils
                                                                            .icDelete)),
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  setState(() {
                                                                    edgesList[
                                                                            index]
                                                                        .product
                                                                        ?.cartItemCount--;
                                                                  });
                                                                });
                                                              },
                                                              child: Container(
                                                                height: screenSize
                                                                        .height *
                                                                    0.070,
                                                                // width: size.height * 0.045,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColors
                                                                            .mint,
                                                                        width:
                                                                            2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child:
                                                                    const Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 27),
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: Container(
                                                        height:
                                                            screenSize.height *
                                                                0.070,
                                                        // width: size.height * 0.045,

                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .disable),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Center(
                                                            child: Text(
                                                          edgesList[index]
                                                              .product!
                                                              .cartItemCount
                                                              .toString(),
                                                          style: FontUtils.h18(
                                                              fontWeight:
                                                                  FWT.semiBold,
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray),
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            edgesList[index]
                                                                .product
                                                                ?.cartItemCount++;
                                                          });
                                                        },
                                                        child: Container(
                                                          height: screenSize
                                                                  .height *
                                                              0.070,
                                                          // width: size.height * 0.045,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                AppColors.mint,
                                                          ),
                                                          child: const Center(
                                                              child: Icon(
                                                                  Icons.add,
                                                                  color:
                                                                      AppColors
                                                                          .green,
                                                                  size: 27)),
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
                                          : myItemChooseWidget(screenSize,
                                              edgesList[index].itemName ?? '',
                                              () {
                                              // Get.toNamed('/ItemCatalogScreen');
                                              if (selectedStoreProductList
                                                  .isNotEmpty) {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ItemCatalogScreen(
                                                    selectedStoreProductList:
                                                        selectedStoreProductList,
                                                    groceryBloc: groceryBloc,
                                                    index: index,
                                                  );
                                                }));
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Please, Select Store!');
                                              }
                                            });
                                    })
                                : ListView.builder(
                                    itemCount: onlyProductList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return onlyProductList[index].product !=
                                              null
                                          ? Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CachedNetworkImage(
                                                      height: 130,
                                                      width: 130,
                                                      imageUrl:
                                                          onlyProductList[index]
                                                              .product!
                                                              .image!,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color:
                                                            AppColors.lightGrey,
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                    // Image(
                                                    //   // image: AssetImage(AssetsUtils.productDemoImg),
                                                    //   image: NetworkImage(onlyProductList[index].cartData!.image!),
                                                    //   height: 130,
                                                    //   width: 130, fit: BoxFit.cover,
                                                    // ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            onlyProductList[
                                                                        index]
                                                                    .product!
                                                                    .itemName ??
                                                                '', // 'Milk Almond Breeze 500ml, 1.5% fat',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FontUtils.h17(
                                                                fontColor:
                                                                    AppColors
                                                                        .darkGray),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Icon(
                                                                  Icons
                                                                      .info_outline_rounded,
                                                                  color: AppColors
                                                                      .terracotta,
                                                                  size: 20),
                                                              const SizedBox(
                                                                  width: 3),
                                                              Text(
                                                                'Available in: ',
                                                                style: FontUtils.h12(
                                                                    fontColor:
                                                                        AppColors
                                                                            .middleGray,
                                                                    fontWeight:
                                                                        FWT.semiBold),
                                                              ),
                                                              Text(
                                                                'Wallmart',
                                                                style: FontUtils.h12(
                                                                    fontColor:
                                                                        AppColors
                                                                            .black,
                                                                    fontWeight:
                                                                        FWT.semiBold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      onlyProductList[index]
                                                              .product!
                                                              .formattedPrice ??
                                                          '', // '\$ 5.99',
                                                      style: FontUtils.h17(
                                                          fontColor: AppColors
                                                              .darkGray,
                                                          fontWeight:
                                                              FWT.semiBold),
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
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .switchColor,
                                                                width: 1.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                        height:
                                                            screenSize.height *
                                                                0.070,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      12),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Product 1',
                                                                style: FontUtils.h18(
                                                                    fontColor:
                                                                        AppColors
                                                                            .black),
                                                              ),
                                                              const Icon(
                                                                  Icons
                                                                      .check_circle_outline_outlined,
                                                                  size: 30,
                                                                  color: AppColors
                                                                      .switchColor)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: edgesList[index]
                                                                  .product!
                                                                  .cartItemCount ==
                                                              1
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  edgesList[index]
                                                                          .product =
                                                                      null;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: screenSize
                                                                        .height *
                                                                    0.070,
                                                                width: screenSize
                                                                        .height *
                                                                    0.070,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColors
                                                                            .disable),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Center(
                                                                    child: SvgPicture.asset(
                                                                        AssetsUtils
                                                                            .icDelete)),
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  if (edgesList[
                                                                              index]
                                                                          .product!
                                                                          .cartItemCount ==
                                                                      1) {
                                                                    edgesList[
                                                                            index]
                                                                        .product!
                                                                        .isAddedToShoppingList = false;
                                                                    // isProductSelect = false;
                                                                  } else {
                                                                    edgesList[
                                                                            index]
                                                                        .product!
                                                                        .cartItemCount = edgesList[index]
                                                                            .product!
                                                                            .cartItemCount -
                                                                        1;
                                                                  }
                                                                });
                                                              },
                                                              child: Container(
                                                                height: screenSize
                                                                        .height *
                                                                    0.070,
                                                                // width: size.height * 0.045,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColors
                                                                            .mint,
                                                                        width:
                                                                            2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child:
                                                                    const Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 27),
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: Container(
                                                        height:
                                                            screenSize.height *
                                                                0.070,
                                                        // width: size.height * 0.045,

                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .disable),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Center(
                                                            child: Text(
                                                          edgesList[index]
                                                              .product!
                                                              .cartItemCount
                                                              .toString(),
                                                          style: FontUtils.h18(
                                                              fontWeight:
                                                                  FWT.semiBold,
                                                              fontColor:
                                                                  AppColors
                                                                      .darkGray),
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            edgesList[index]
                                                                    .product!
                                                                    .cartItemCount =
                                                                edgesList[index]
                                                                        .product!
                                                                        .cartItemCount +
                                                                    1;
                                                          });
                                                        },
                                                        child: Container(
                                                          height: screenSize
                                                                  .height *
                                                              0.070,
                                                          // width: size.height * 0.045,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                AppColors.mint,
                                                          ),
                                                          child: const Center(
                                                              child: Icon(
                                                                  Icons.add,
                                                                  color:
                                                                      AppColors
                                                                          .green,
                                                                  size: 27)),
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
                                          : myItemChooseWidget(
                                              screenSize,
                                              onlyProductList[index].itemName ??
                                                  '', () {
                                              // Get.toNamed('/ItemCatalogScreen');
                                              if (selectedStoreProductList
                                                  .isNotEmpty) {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ItemCatalogScreen(
                                                    selectedStoreProductList:
                                                        selectedStoreProductList,
                                                    groceryBloc: groceryBloc,
                                                    index: index,
                                                  );
                                                }));
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Please, Select Store!');
                                              }
                                            });
                                    }))),
                  ),
                  Container(
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: FontUtils.h20(
                                    fontColor: AppColors.black,
                                    fontWeight: FWT.semiBold),
                              ),
                              Text(
                                '\$ ${totalAmount(edgesList).toStringAsFixed(2)}',
                                style: FontUtils.h22(
                                    fontColor: AppColors.black,
                                    fontWeight: FWT.semiBold),
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                          simpleTextBorderButton(
                            context: context,
                            color: edgesList.indexWhere(
                                        (element) => element.product == null) <
                                    0
                                ? AppColors.green
                                : AppColors.gray,
                            buttonLable: 'Checkout',
                            height: screenSize.height * 0.065,
                            width: screenSize.width,
                            isLoadingWidget: false,
                            onTap: () {
                              int emptyIndex = edgesList.indexWhere(
                                  (element) => element.product == null);

                              if (emptyIndex < 0) {
                                Get.toNamed('/CheckoutScreen',
                                    arguments: GroceryCartScreenArguments(
                                      edgesList: edgesList,
                                      askReceiveOrder:
                                          widget.arguments!.askReceiveOrder,
                                      groceryBloc: groceryBloc,
                                    ));
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please, select the product!');
                              }
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
          }),
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
                    'Choose a Brand (required)',
                    style: FontUtils.h16(fontColor: AppColors.black),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.black)
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
        total = total +
            ((edgesList[i].product!.price! / 100) *
                edgesList[i].product!.cartItemCount);
      }
    }
    return total;
  }
}

class GroceryCartScreenArguments {
  // final List<GroceryShoppingData> edgesList;
  final List<GroceryDetails> edgesList;
  final AskReceiveOrder askReceiveOrder;
  final GroceryBloc? groceryBloc;

  GroceryCartScreenArguments(
      {required this.edgesList,
      required this.askReceiveOrder,
      this.groceryBloc});
}
