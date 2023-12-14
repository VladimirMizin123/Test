import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/divider_widget.dart';

import '../../bloc/grocery_repository.dart';
import '../../bloc/grocery_state.dart';
import '../../modal/nutritionix_get_nx_meal_info_by_name_modal.dart';

class GroceryProductDetails extends StatefulWidget {
  final Product product;
  const GroceryProductDetails({super.key, required this.product});

  @override
  State<GroceryProductDetails> createState() => _GroceryProductDetailsState();
}


class _GroceryProductDetailsState extends State<GroceryProductDetails> {
  final GroceryRepository _repository = GroceryRepository();
  late NutritionixGetNxMealInfoByNameModelData nutritionixGetNxMealInfoByNameModelData = NutritionixGetNxMealInfoByNameModelData();
  bool isLoading = false;

  @override
  void initState() {
    _getNxData();
    super.initState();
  }

  Future<void> _getNxData()
  async {
    setState(() {
      isLoading = true;
    });
    try {
      await _repository
          .groceryDetailsMealInfo(productName: widget.product.itemName ?? '')
          .fold((left) {
        setState(() {
          isLoading = false;
        });
        // emit(GrocerySearchErrorState());
        // onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
            setState(() {
              isLoading = false;
              nutritionixGetNxMealInfoByNameModelData = right.data!;
            });
        // emit(GroceryNutritionixGetNxMealInfoByNameSuccessState(
        //     nutritionixGetNxMealInfoByNameModelData: right.data!));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // showToast(isSuccess: false, message: e.toString());
      // emit(GroceryNutritionixGetNxMealInfoByNameErrorState());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: isLoading ? const Center(
          child: CircularProgressIndicator(),
        ) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  Text('Item Details',
                      style: FontUtils.h20(
                          fontColor: AppColors.oxFF010101,
                          fontWeight: FWT.semiBold)),
                  Opacity(
                      opacity: 0,
                      child: Text('Edit',
                          style:
                              FontUtils.h16(fontColor: AppColors.oxFF010101))),
                ],
              ).paddingSymmetric(horizontal: 6, vertical: 5.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(
                          // image: const AssetImage(AssetsUtils.productDemoImg1),
                          image: NetworkImage(widget.product.image!),
                          height: screenSize.height * 0.50,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('General Information',
                              style: FontUtils.h22(
                                  fontColor: AppColors.oxFF010101,
                                  fontWeight: FWT.semiBold))),
                      const SizedBox(height: 10),
                      myGeneralInformationWidget(
                          'Brand', widget.product.itemName ?? ''),
                      /* myGeneralInformationWidget(
                          'Manufacturer', 'Almond Breeze'),
                      myGeneralInformationWidget('Country', 'N/A'),
                      myGeneralInformationWidget('Weight', '450 g'),
                      myGeneralInformationWidget(
                          'Fat', widget.product.fat ?? 'N/A'),
                      myGeneralInformationWidget(
                          'Expiration date', widget.product.day ?? 'N/A'),*/
                      const SizedBox(height: 20),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Nutritional Information',
                              style: FontUtils.h24(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.semiBold))),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Saturated Fat',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                          Text(
                            '${(nutritionixGetNxMealInfoByNameModelData.nfSaturatedFat ?? 0.00).toStringAsFixed(2)} g', style: FontUtils.h16(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cholesterol',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                          Text('${(nutritionixGetNxMealInfoByNameModelData?.nfCholesterol ?? 0.00).toStringAsFixed(2)} mg',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sodium',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                          Text( '${(nutritionixGetNxMealInfoByNameModelData?.nfSodium ?? 0.00).toStringAsFixed(2)} mg',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dietary Fiber',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                          Text('${(nutritionixGetNxMealInfoByNameModelData?.nfDietaryFiber ?? 0.00).toStringAsFixed(2)} g',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sugar',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                          Text('${(nutritionixGetNxMealInfoByNameModelData?.nfSugars ?? 0.00).toStringAsFixed(2)} g',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Potassium',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                          Text('${(nutritionixGetNxMealInfoByNameModelData?.nfPotassium ?? 0.00).toStringAsFixed(2)} mg',
                              style: FontUtils.h16(
                                  fontColor: AppColors.darkGray,
                                  fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Divider(color: AppColors.disabledColor, height: 2.h),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                      //     Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Divider(color: AppColors.disabledColor, height: 2.h),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                      //     Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Trans Fat', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //     Text('0g', style: FontUtils.h14(fontColor: AppColors.darkGray, fontWeight: FWT.lightMedium)),
                      //   ],
                      // ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Container(
                color: AppColors.whiteColor,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // simpleTextBorderButton(
                    //   context: context,
                    //   buttonLable: 'Add Item',
                    //   height: screenSize.height * 0.065,
                    //   width: screenSize.width,
                    //   isLoadingWidget: false,
                    //   onTap: () {},
                    //   isDarkColor: true,
                    //   isFillColor: true,
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       height: screenSize.height * 0.065,
                    //       width: screenSize.height * 0.065,
                    //       decoration: BoxDecoration(border: Border.all(color: AppColors.mint, width: 2), borderRadius: BorderRadius.circular(10)),
                    //       child: Center(child: SvgPicture.asset(AssetsUtils.icDelete, color: AppColors.green)),
                    //     ),
                    //     SizedBox(width: 8.w),
                    //     Container(
                    //       height: screenSize.height * 0.065,
                    //       width: screenSize.height * 0.065,
                    //       decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(10)),
                    //       child: Center(
                    //           child: Text(
                    //         '1',
                    //         style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                    //       )),
                    //     ),
                    //     SizedBox(width: 8.w),
                    //     Container(
                    //       height: screenSize.height * 0.065,
                    //       width: screenSize.height * 0.065,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: AppColors.mint,
                    //       ),
                    //       child: const Center(child: Icon(Icons.add, color: AppColors.green, size: 27)),
                    //     ),
                    //   ],
                    // ),
                    widget.product == true
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.product.isAddedToShoppingList = true;
                              });
                            },
                            child: Container(
                              height: screenSize.height * 0.065,
                              width: screenSize.height * 0.065,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.green),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: SvgPicture.asset(
                                      AssetsUtils.icShoppingIcon,
                                      color: AppColors.green)),
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.product.cartItemCount == 1
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // groceryResult.removeWhere((element) => element.productId == groceryResult[index].productId);
                                        });
                                      },
                                      child: Container(
                                        height: screenSize.height * 0.065,
                                        width: screenSize.height * 0.065,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.mint,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: SvgPicture.asset(
                                                AssetsUtils.icDelete,
                                                color: AppColors.green)),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          widget.product.cartItemCount =
                                              widget.product.cartItemCount - 1;
                                        });
                                      },
                                      child: Container(
                                        height: screenSize.height * 0.065,
                                        width: screenSize.height * 0.065,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.mint,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                          child: Icon(Icons.remove, size: 27),
                                        ),
                                      ),
                                    ),
                              SizedBox(width: 8.w),
                              Container(
                                height: screenSize.height * 0.065,
                                width: screenSize.height * 0.065,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.disable),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                  widget.product.cartItemCount.toString(),
                                  style: FontUtils.h18(
                                      fontWeight: FWT.semiBold,
                                      fontColor: AppColors.darkGray),
                                )),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.product.cartItemCount =
                                        widget.product.cartItemCount + 1;
                                  });
                                },
                                child: Container(
                                  height: screenSize.height * 0.065,
                                  width: screenSize.height * 0.065,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.mint,
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.add,
                                          color: AppColors.green, size: 27)),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myGeneralInformationWidget(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: FontUtils.h16(
                    fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
            Expanded(
              child: Text(
                value,
                style: FontUtils.h16(
                    fontColor: AppColors.darkGray, fontWeight: FWT.medium),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const DividerWidget(),
        // const SizedBox(height: 5),
      ],
    );
  }
}
