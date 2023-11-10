import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/bottomsheet/country_selection_bottomsheet.dart';
import 'package:gymeats_mobile/screen/grocery/screen/item_catalog/bottomsheet/price_selection_bottomsheet.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class ItemCatalogFilterBottomSheet extends StatefulWidget {
  const ItemCatalogFilterBottomSheet({super.key, this.value});
  final RangeValues? value;
  @override
  State<ItemCatalogFilterBottomSheet> createState() =>
      _ItemCatalogFilterBottomSheetState();
}

class _ItemCatalogFilterBottomSheetState
    extends State<ItemCatalogFilterBottomSheet> {
  int selectedIndex = 0;
  RangeValues? priceRange;
  bool isFilter = false;

  @override
  void initState() {
    super.initState();
    priceRange = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      color: AppColors.whiteColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 3.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.disable),
                  )),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Filters',
                      style: FontUtils.h22(
                          fontColor: AppColors.darkGray,
                          fontWeight: FWT.semiBold)),
                  const SizedBox(width: 10),
                  Container(
                    height: 22,
                    width: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.errorRedColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text('1',
                            style: FontUtils.h10(
                                fontColor: AppColors.whiteColor,
                                fontWeight: FWT.bold))),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      isFilter = false;
                      priceRange = const RangeValues(0, 500);
                      Get.back(result: {
                        'priceRange': priceRange,
                        'isFilter': isFilter,
                      });
                    },
                    child: Text(
                      'Clear all',
                      style: FontUtils.h16(fontColor: AppColors.darkGray),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              myFilterWidget(
                'Just available',
                '18',
                CupertinoSwitch(value: true, onChanged: (bool? value) {}),
              ),
              myFilterWidget(
                  'Brand',
                  'Milo',
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: AppColors.black,
                    size: 30,
                  )),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const CountrySelectionBottomSheet();
                    },
                    isDismissible: false,
                  );
                },
                child: myFilterWidget(
                    'Country',
                    'USA',
                    const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: AppColors.black,
                      size: 30,
                    )),
              ),
              GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return PriceSelectionBottomSheet(
                        priceRange: priceRange,
                      );
                    },
                    isDismissible: false,
                  ).then((value) {
                    log('value---------->>>>>> $value');

                    if (value != null) {
                      priceRange = value['priceRange'];
                      isFilter = value['isFilter'];
                      setState(() {});
                    }
                  });
                },
                child: myFilterWidget(
                    'Price',
                    '\$${priceRange?.start ?? 0}-${priceRange?.end ?? 0}',
                    const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: AppColors.black,
                      size: 30,
                    )),
              ),
              const SizedBox(height: 15),
              simpleTextBorderButton(
                context: context,
                color: AppColors.green,
                buttonLable: 'Show items',
                height: screenSize.height * 0.065,
                width: screenSize.width,
                isLoadingWidget: false,
                onTap: () {
                  // for (var element in widget.filterData) {
                  //   if ((element.originalPrice!) > priceRange!.start &&
                  //       (element.originalPrice!) < priceRange!.end) {
                  //     filterData.add(element);
                  //     isFilter = true;
                  //   }
                  // }

                  Get.back(result: {
                    'priceRange': priceRange,
                    'isFilter': isFilter,
                  });
                },
                isDarkColor: true,
                isFillColor: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget myFilterWidget(String title, String subTitle, Widget trailingWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Text(title, style: FontUtils.h16(fontColor: AppColors.black)),
                const Spacer(),
                Text(subTitle,
                    style: FontUtils.h16(fontColor: AppColors.black)),
                const SizedBox(width: 10),
                trailingWidget
              ],
            ),
            const SizedBox(height: 5),
            const Divider(color: AppColors.disable, thickness: 1.2),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
