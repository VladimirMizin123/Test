import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';

import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

import 'bottomsheet/item_catalog_filter_bottomsheet.dart';
import 'bottomsheet/item_catalog_sort_by_bottomsheet.dart';

class ItemCatalogScreen extends StatelessWidget {
  const ItemCatalogScreen({super.key});

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
                const BackButtonWidget(),
                Text('Grocery List', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101)),
              ],
            ).paddingSymmetric(horizontal: 6, vertical: 5.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  myFilterView(AssetsUtils.icFilterIcon, 'Filter', () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const ItemCatalogFilterBottomSheet();
                      },
                      isDismissible: false,
                    );
                  }),
                  const SizedBox(width: 10),
                  myFilterView(AssetsUtils.icSortIcon, 'Sort by', () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const ItemCatalogSortByBottomSheet();
                      },
                      isDismissible: false,
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.6,
                ),
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/GroceryProductDetails');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        boxShadow: boxShadowWidget,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Image(image: AssetImage(AssetsUtils.productDemoImg)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Milk Almond Breeze 500ml, 1.5% fat',
                              textAlign: TextAlign.center,
                              style: FontUtils.h15(fontColor: AppColors.darkGray),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$ 5.99',
                            style: FontUtils.h17(fontColor: AppColors.darkGray, fontWeight: FWT.semiBold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline_rounded, color: AppColors.terracotta, size: 20),
                              const SizedBox(width: 3),
                              Text(
                                'Available in: ',
                                style: FontUtils.h12(fontColor: AppColors.middleGray, fontWeight: FWT.semiBold),
                              ),
                              Text(
                                'Wallmart',
                                style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: size.height * 0.065,
                                width: size.height * 0.065,
                                decoration: BoxDecoration(border: Border.all(color: AppColors.mint, width: 2), borderRadius: BorderRadius.circular(10)),
                                child: Center(child: SvgPicture.asset(AssetsUtils.icDelete, color: AppColors.green)),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                height: size.height * 0.065,
                                width: size.height * 0.065,
                                decoration: BoxDecoration(border: Border.all(color: AppColors.disable), borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                  '1',
                                  style: FontUtils.h18(fontWeight: FWT.semiBold, fontColor: AppColors.darkGray),
                                )),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                height: size.height * 0.065,
                                width: size.height * 0.065,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.mint,
                                ),
                                child: const Center(child: Icon(Icons.add, color: AppColors.green, size: 27)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
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
            decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(50)),
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
                    style: FontUtils.h18(fontColor: AppColors.green, fontWeight: FWT.semiBold),
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
