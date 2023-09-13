import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_shopping_modal.dart';
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
  List<String> productList = ['Product 1', 'Product 2', 'Product 3', 'Product 4', 'Product 5'];
  GroceryBloc groceryBloc = GroceryBloc();
  List<GrocerySearchModel> grocerySearchModalDataList = [];
  List<Product>? groceryMultiSearchStoreProductListList = [];
  List<Cart> selectedStoreProductList = [];

  @override
  void initState() {
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   for (var i = 0; i < widget.arguments!.edgesList.length; i++) {
    //     grocerySearchModalDataList.add(GrocerySearchModel(
    //       groceryName: widget.arguments!.edgesList[i].productName,
    //       unitMeasurement: widget.arguments!.edgesList[i].unitOfMeasurement,
    //       unitSize: widget.arguments!.edgesList[i].unitSize!.toInt(),
    //     ));
    //   }
    // });
    // groceryBloc.add(GrocerySearchEvent(grocerySearchModelList: grocerySearchModalDataList));
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
                      Text('Grocery List', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                      Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101)),
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
                      decoration: BoxDecoration(color: selectedStoreProductList.isEmpty ? AppColors.middleGray.withOpacity(0.10) : AppColors.mint, borderRadius: BorderRadius.circular(50), border: Border.all(color: selectedStoreProductList.isEmpty ? AppColors.middleGray : AppColors.green)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // const Icon(Icons.search, color: AppColors.green),
                            SvgPicture.asset(AssetsUtils.icLocation, color: selectedStoreProductList.isEmpty ? AppColors.middleGray : AppColors.green),
                            const SizedBox(width: 10),
                            Text(
                              'Choose a Store',
                              style: FontUtils.h16(fontColor: selectedStoreProductList.isEmpty ? AppColors.middleGray : AppColors.green, fontWeight: FWT.semiBold),
                            ),
                            const SizedBox(width: 10),
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
                        onTap: () {},
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search for item',
                          hintStyle: FontUtils.h16(),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColors.coral,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Center(
                                      child: Text(
                                    'From 1 store only',
                                    style: FontUtils.h15(fontColor: AppColors.terracotta),
                                  )),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${widget.arguments!.edgesList.length} Items',
                        style: FontUtils.h18(fontColor: AppColors.middleGray),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListView.builder(
                                itemCount: widget.arguments!.edgesList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return myItemChooseWidget(screenSize, widget.arguments!.edgesList[index].productName ?? '', () {
                                    // Get.toNamed('/ItemCatalogScreen');
                                    if (selectedStoreProductList.isNotEmpty) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return ItemCatalogScreen(
                                          selectedStoreProductList: selectedStoreProductList,
                                        );
                                      }));
                                    } else {
                                      Fluttertoast.showToast(msg: 'Please, Select Store!');
                                    }
                                  });
                                })
                            // Column(
                            //   children: [
                            //     myItemChooseWidget(screenSize, 'Almond Milk', () {
                            //       Get.toNamed('/ItemCatalogScreen');
                            //     }),
                            //     myItemChooseWidget(screenSize, 'Mushrooms', () {}),
                            //     myItemChooseWidget(screenSize, 'Potatoes', () {}),
                            //     myItemChooseWidget(screenSize, 'Tomatoes', () {}),
                            //     // Column(
                            //     //   mainAxisAlignment: MainAxisAlignment.center,
                            //     //   crossAxisAlignment: CrossAxisAlignment.start,
                            //     //   children: [
                            //     //     Row(
                            //     //       crossAxisAlignment: CrossAxisAlignment.start,
                            //     //       children: [
                            //     //         const Image(
                            //     //           image: AssetImage(AssetsUtils.productDemoImg),
                            //     //         ),
                            //     //         const SizedBox(width: 10),
                            //     //         Expanded(
                            //     //           child: Column(
                            //     //             crossAxisAlignment: CrossAxisAlignment.start,
                            //     //             children: [
                            //     //               Text(
                            //     //                 'Milk Almond Breeze 500ml, 1.5% fat',
                            //     //                 textAlign: TextAlign.start,
                            //     //                 style: FontUtils.h17(fontColor: AppColors.darkGray),
                            //     //               ),
                            //     //               const SizedBox(height: 10),
                            //     //               Row(
                            //     //                 mainAxisAlignment: MainAxisAlignment.start,
                            //     //                 children: [
                            //     //                   const Icon(Icons.info_outline_rounded, color: AppColors.terracotta, size: 20),
                            //     //                   const SizedBox(width: 3),
                            //     //                   Text(
                            //     //                     'Available in: ',
                            //     //                     style: FontUtils.h12(fontColor: AppColors.middleGray, fontWeight: FWT.semiBold),
                            //     //                   ),
                            //     //                   Text(
                            //     //                     'Wallmart',
                            //     //                     style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                            //     //                   ),
                            //     //                 ],
                            //     //               ),
                            //     //             ],
                            //     //           ),
                            //     //         ),
                            //     //         const SizedBox(width: 10),
                            //     //         Text(
                            //     //           '\$ 5.99',
                            //     //           style: FontUtils.h17(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold),
                            //     //         ),
                            //     //         const SizedBox(height: 10),
                            //     //       ],
                            //     //     ),
                            //     //     const SizedBox(height: 10),
                            //     //     Row(
                            //     //       children: [
                            //     //         Expanded(
                            //     //           flex: 2,
                            //     //           child: Container(
                            //     //             decoration: BoxDecoration(border: Border.all(color: AppColors.switchColor, width: 1.2), borderRadius: BorderRadius.circular(6)),
                            //     //             height: screenSize.height * 0.070,
                            //     //             child: Padding(
                            //     //               padding: const EdgeInsets.symmetric(horizontal: 12),
                            //     //               child: Row(
                            //     //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     //                 children: [
                            //     //                   Text(
                            //     //                     'Product 1',
                            //     //                     style: FontUtils.h18(fontColor: AppColors.black),
                            //     //                   ),
                            //     //                   const Icon(Icons.check_circle_outline_outlined, size: 30, color: AppColors.switchColor)
                            //     //                 ],
                            //     //               ),
                            //     //             ),
                            //     //           ),
                            //     //         ),
                            //     //       ],
                            //     //     ),
                            //     //   ],
                            //     // ),
                            //     // const SizedBox(height: 10),
                            //     // const Divider(thickness: 1.2),
                            //   ],
                            // ),
                            )),
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
                                '\$ 0.00',
                                style: FontUtils.h22(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                          simpleTextBorderButton(
                            context: context,
                            color: AppColors.green,
                            buttonLable: 'Checkout',
                            height: screenSize.height * 0.065,
                            width: screenSize.width,
                            isLoadingWidget: false,
                            onTap: () {
                              Get.toNamed('/CheckoutScreen');
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
}

class GroceryCartScreenArguments {
  final List<GroceryShoppingData> edgesList;
  final AskReceiveOrder askReceiveOrder;
  final GroceryBloc? groceryBloc;

  GroceryCartScreenArguments({required this.edgesList, required this.askReceiveOrder, this.groceryBloc});
}
