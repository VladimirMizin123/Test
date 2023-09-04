import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/divider_widget.dart';

class GroceryProductDetails extends StatelessWidget {
  const GroceryProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                  Text('Item Details', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                  Opacity(opacity: 0, child: Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101))),
                ],
              ).paddingSymmetric(horizontal: 6, vertical: 5.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(
                          image: const AssetImage(AssetsUtils.productDemoImg1),
                          height: screenSize.height * 0.50,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(alignment: Alignment.centerLeft, child: Text('General Information', style: FontUtils.h22(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold))),
                      const SizedBox(height: 10),
                      myGeneralInformationWidget('Brand', 'Almond Breeze'),
                      myGeneralInformationWidget('Manufacturer', 'Almond Breeze'),
                      myGeneralInformationWidget('Country', 'USA'),
                      myGeneralInformationWidget('Weight', '450 g'),
                      myGeneralInformationWidget('Fat', '1.5%'),
                      myGeneralInformationWidget('Expiration date', '45 days'),
                      const SizedBox(height: 20),
                      Align(alignment: Alignment.centerLeft, child: Text('Nutritional Information', style: FontUtils.h24(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold))),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calories', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                          Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Protein', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                          Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Carbs', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                          Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: AppColors.disabledColor, height: 2.h),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fat', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
                          Text('2g', style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: screenSize.height * 0.065,
                          width: screenSize.height * 0.065,
                          decoration: BoxDecoration(border: Border.all(color: AppColors.mint, width: 2), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: SvgPicture.asset(AssetsUtils.icDelete, color: AppColors.green)),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          height: screenSize.height * 0.065,
                          width: screenSize.height * 0.065,
                          decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            '1',
                            style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                          )),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          height: screenSize.height * 0.065,
                          width: screenSize.height * 0.065,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.mint,
                          ),
                          child: const Center(child: Icon(Icons.add, color: AppColors.green, size: 27)),
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
          children: [
            Text(title, style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
            const Spacer(),
            Text(value, style: FontUtils.h16(fontColor: AppColors.darkGray, fontWeight: FWT.medium)),
          ],
        ),
        const DividerWidget(),
        // const SizedBox(height: 5),
      ],
    );
  }
}
