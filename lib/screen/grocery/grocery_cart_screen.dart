import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class GroceryCartScreen extends StatelessWidget {
  const GroceryCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                const Icon(Icons.keyboard_arrow_left_outlined, size: 30),
                Text('Grocery List', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101)),
              ],
            ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
            GestureDetector(
              onTap: () {
                Get.toNamed('/ChooseStoreScreen');
              },
              child: Container(
                width: screenSize.width * 0.50,
                decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(50), border: Border.all(color: AppColors.green)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const Icon(Icons.search, color: AppColors.green),
                      SvgPicture.asset(AssetsUtils.icLocation, color: AppColors.green),
                      const SizedBox(width: 10),
                      Text(
                        'Choose a Store',
                        style: FontUtils.h16(fontColor: AppColors.green, fontWeight: FWT.semiBold),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffDDDDDD),
                      blurRadius: 0.5,
                      spreadRadius: 2.0,
                      offset: Offset(0.0, 0.0),
                    )
                  ],
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
                  '12 Items',
                  style: FontUtils.h18(fontColor: AppColors.middleGray),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  myItemChooseWidget(screenSize, 'Almond Milk', () {}),
                  myItemChooseWidget(screenSize, 'Mushrooms', () {}),
                  myItemChooseWidget(screenSize, 'Potatoes', () {}),
                  myItemChooseWidget(screenSize, 'Tomatoes', () {}),
                ],
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
                      onTap: () {},
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
      ),
    );
  }

  Widget myItemChooseWidget(Size screenSize, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
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
      ),
    );
  }
}
